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
          return const ReportScaffold(
            title: 'Vastu Report',
            isLoading: true,
            body: SizedBox(),
          );
        }

        if (snapshot.hasError) {
          return const ReportScaffold(
            title: 'Vastu Report',
            isError: true,
            body: SizedBox(),
          );
        }

        final rootV = snapshot.data!;
        final bool isMultiFloor = rootV.containsKey('ground');
        final v =
            isMultiFloor ? (rootV['ground'] ?? rootV.values.first) : rootV;
        final score = (v['score'] as num?)?.toInt() ?? 0;
        final orientation = v['orientation']?.toString() ?? 'EAST';

        final strengths = List<String>.from(v['strengths'] ?? []);
        final violations = List<String>.from(v['violations'] ?? []);
        final suggestions = List<String>.from(v['suggestions'] ?? []);

        final tt = context.tt;

        return ReportScaffold(
          title: 'Vastu Report',
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero Summary Card
                HeroCard(
                  title: '$score%',
                  subtitle: '${orientation.toUpperCase()} Facing House',
                  buttonLabel: 'Download Report PDF',
                  onButtonTap: () {},
                  statLine: Text(
                    score > 80
                        ? 'Excellent Vastu Compliance'
                        : 'Moderate Vastu Compliance',
                    style: tt.titleMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                if (strengths.isNotEmpty) ...[
                  Text('Key Strengths',
                      style: tt.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: strengths.asMap().entries.map((entry) {
                        return AppListRow(
                          label: entry.value,
                          leadingIcon: Icons.check_circle_rounded,
                          isAccent: true,
                          showDivider: entry.key != strengths.length - 1,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                if (violations.isNotEmpty || suggestions.isNotEmpty) ...[
                  Text('Improvements',
                      style: tt.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: AppSpacing.md),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ...violations.map((v) => AppListRow(
                              label: v,
                              leadingIcon: Icons.warning_rounded,
                              showDivider: true,
                            )),
                        ...suggestions
                            .asMap()
                            .entries
                            .map((entry) => AppListRow(
                                  label: entry.value,
                                  leadingIcon: Icons.lightbulb_rounded,
                                  showDivider:
                                      entry.key != suggestions.length - 1,
                                )),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }
}
