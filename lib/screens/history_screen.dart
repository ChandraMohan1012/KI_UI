import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../utils/app_assets.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/app_loader.dart';

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
    final cs = context.cs;
    final tt = context.tt;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          'Project History',
          style: tt.titleMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: cs.primary,
                    size: 18,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.luxuryVillaBg,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => Image.asset(
                AppAssets.architecturalBg,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.75),
                    cs.surface.withValues(alpha: 0.98),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: FutureBuilder<List<dynamic>>(
              future: _projectsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AppLoader(message: 'Loading project history...');
                }

                if (snapshot.hasError ||
                    (snapshot.data != null && snapshot.data!.isEmpty)) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: AppEmptyState(
                        icon: Icons.history_toggle_off_rounded,
                        title: 'No Project Records Yet',
                        message:
                            'Your generated 3D blueprints & architectural reports will appear here.',
                      ),
                    ),
                  );
                }

                final projects = snapshot.data ?? [];

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];

                    bool isValidData(dynamic data) {
                      if (data == null) return false;
                      if (data is Map && data.isEmpty) return false;
                      if (data is String && data.isEmpty) return false;
                      if (data is List && data.isEmpty) return false;
                      return true;
                    }

                    String rawName = project['name'] ?? 'Project';
                    String displayProjectName = rawName;
                    Set<String> selectedReports = {};
                    double amountPaid = 99.0;
                    bool isLegacy = true;

                    if (rawName.contains('|')) {
                      final parts = rawName.split('|');
                      displayProjectName = parts[0];
                      if (parts.length > 1 && parts[1].isNotEmpty) {
                        selectedReports = parts[1].split(',').toSet();
                        isLegacy = false;
                      }
                      if (parts.length > 2) {
                        amountPaid = double.tryParse(parts[2]) ?? amountPaid;
                      }
                    }

                    final model = project['model_data'] ?? {};
                    bool has3D = isLegacy
                        ? (isValidData(project['visual_data']) ||
                            isValidData(model['_visual']))
                        : selectedReports.contains('3d');
                    bool hasElevation = isLegacy
                        ? (isValidData(project['elevation_data']) ||
                            isValidData(model['_elevation']))
                        : selectedReports.contains('elevation');
                    bool hasVastu = isLegacy
                        ? (isValidData(project['vastu_data']) ||
                            isValidData(model['_vastu']))
                        : selectedReports.contains('vastu');
                    bool hasCost = isLegacy
                        ? (isValidData(project['cost_data']) ||
                            isValidData(model['_cost']))
                        : selectedReports.contains('cost') ||
                            selectedReports.contains('boq');
                    bool hasStructural = isLegacy
                        ? (isValidData(project['structural_data']) ||
                            isValidData(model['_structural']))
                        : selectedReports.contains('structural');

                    int totalPrice = isLegacy
                        ? (() {
                            int p = 0;
                            if (has3D) p += 30;
                            if (hasElevation) p += 29;
                            if (hasVastu) p += 20;
                            if (hasCost) p += 20;
                            if (hasStructural) p += 29;
                            return p;
                          })()
                        : amountPaid.round();

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.lgBorder,
                        border: Border.all(
                          color: cs.outlineVariant.withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: AppRadius.lgBorder,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: InkWell(
                            borderRadius: AppRadius.lgBorder,
                            onTap: () {
                              if (widget.onSelectProject != null &&
                                  project is Map<String, dynamic>) {
                                widget.onSelectProject!(project);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              color: cs.surfaceContainer.withValues(alpha: 0.8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          displayProjectName,
                                          style: tt.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: cs.primary,
                                          borderRadius: AppRadius.fullBorder,
                                        ),
                                        child: Text(
                                          'Paid ₹$totalPrice',
                                          style: TextStyle(
                                            color: cs.onPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        size: 14,
                                        color: cs.primary,
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Text(
                                        "Created: ${project['created_at']?.toString().split('T')[0] ?? 'N/A'}",
                                        style: TextStyle(
                                          color: cs.onSurfaceVariant,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        if (has3D) ...[
                                          const AppBadge(
                                            label: '3D View',
                                            icon: Icons.view_in_ar_rounded,
                                            variant: AppBadgeVariant.primary,
                                          ),
                                          const SizedBox(width: AppSpacing.xs),
                                        ],
                                        if (hasElevation) ...[
                                          const AppBadge(
                                            label: 'Elevation',
                                            icon: Icons.apartment_rounded,
                                            variant: AppBadgeVariant.info,
                                          ),
                                          const SizedBox(width: AppSpacing.xs),
                                        ],
                                        if (hasVastu) ...[
                                          const AppBadge(
                                            label: 'Vastu Score',
                                            icon: Icons.explore_outlined,
                                            variant: AppBadgeVariant.vastu,
                                          ),
                                          const SizedBox(width: AppSpacing.xs),
                                        ],
                                        if (hasCost) ...[
                                          const AppBadge(
                                            label: 'Cost Estimate',
                                            icon: Icons.payments_outlined,
                                            variant: AppBadgeVariant.cost,
                                          ),
                                          const SizedBox(width: AppSpacing.xs),
                                        ],
                                        if (hasStructural)
                                          const AppBadge(
                                            label: 'Structural',
                                            icon: Icons.domain_rounded,
                                            variant: AppBadgeVariant.structural,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: (index * 60).ms)
                        .slideY(begin: 0.05, end: 0);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
