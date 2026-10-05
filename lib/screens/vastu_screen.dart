import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class VastuScreen extends StatefulWidget {
  final Map<String, dynamic> projectData;
  const VastuScreen({super.key, required this.projectData});

  @override
  State<VastuScreen> createState() => _VastuScreenState();
}

class _VastuScreenState extends State<VastuScreen> {
  late Future<Map<String, dynamic>> _vastuFuture;

  @override
  void initState() {
    super.initState();
    final initialVastu =
        widget.projectData['vastu_data'] ?? widget.projectData['_vastu'];
    if (initialVastu != null) {
      _vastuFuture = Future.value(initialVastu);
    } else {
      _vastuFuture =
          ApiService().analyzeVastu(widget.projectData['id'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _vastuFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoader(message: 'Loading Vastu...');
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const AppErrorView(message: 'Failed to load Vastu report.');
        }

        final rootV = snapshot.data!;
        final bool isMultiFloor = rootV.containsKey('ground');
        final v =
            isMultiFloor ? (rootV['ground'] ?? rootV.values.first) : rootV;
        final score = (v['score'] as num?)?.toInt() ?? 98;
        final orientation = v['orientation']?.toString() ?? 'North';

        final strengths = List<String>.from(v['strengths'] ?? []);
        final violations = List<String>.from(v['violations'] ?? []);

        final items = [
          ...strengths.map((s) => MapEntry(s, Icons.check_circle_rounded)),
          ...violations.map((vi) => MapEntry(vi, Icons.warning_rounded)),
        ].take(4).toList();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: HeroCard(
                    title: '$score%',
                    subtitle: '$orientation Facing',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  flex: 4,
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(items.length, (index) {
                        return AppListRow(
                          label: items[index].key,
                          leadingIcon: items[index].value,
                          showDivider: index < items.length - 1,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
