import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class HistoryScreen extends StatefulWidget {
  final void Function(Map<String, dynamic> project)? onSelectProject;
  const HistoryScreen({super.key, this.onSelectProject});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  Future<List<dynamic>>? _projectsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserHistory();
  }

  Future<void> _loadUserHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    setState(() {
      _projectsFuture = _apiService.getAllProjects(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'History',
          style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Projects',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _projectsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const AppLoader(message: 'Loading history...');
                    }

                    if (snapshot.hasError ||
                        snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const AppEmptyState(
                        icon: Icons.history_rounded,
                        title: 'No History',
                      );
                    }

                    // Show at most latest 5 rows
                    final projects = snapshot.data!.take(5).toList();

                    return AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(projects.length, (index) {
                          final project = projects[index];
                          String rawName = project['name'] ?? 'Project';
                          String displayName = rawName.split('|').first;
                          String date =
                              project['created_at']?.toString().split('T')[0] ??
                                  'Today';

                          return AppListRow(
                            label: displayName,
                            value: date,
                            leadingIcon: Icons.home_work_outlined,
                            trailingWidget: const AppStatusChip(
                              label: 'Ready',
                              variant: AppBadgeVariant.success,
                            ),
                            showDivider: index < projects.length - 1,
                            onTap: () {
                              if (widget.onSelectProject != null &&
                                  project is Map<String, dynamic>) {
                                widget.onSelectProject!(project);
                              }
                            },
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
