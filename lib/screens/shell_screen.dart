import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/api_service.dart';
import '../services/mock_data.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../utils/app_assets.dart';
import '../widgets/widgets.dart';
import 'home/home_screen.dart';
import 'upload_screen.dart';
import 'viewer_screen.dart';
import 'vastu_screen.dart';
import 'estimation_screen.dart';
import 'structural_screen.dart';
import 'download_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

// ─── Nav Item Model ───────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

const _navItems = [
  _NavItem(Icons.home_outlined, 'Home'),
  _NavItem(Icons.view_in_ar_rounded, '3D View'),
  _NavItem(Icons.self_improvement_outlined, 'Vastu Report'),
  _NavItem(Icons.calculate_outlined, 'Cost Estimation'),
  _NavItem(Icons.foundation_outlined, 'Structural Report'),
  _NavItem(Icons.download_outlined, 'Download Report'),
  _NavItem(Icons.history_rounded, 'History'),
  _NavItem(Icons.person_outline_rounded, 'Profile'),
  _NavItem(Icons.add_box_outlined, 'New Plan'),
];

class ShellScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ShellScreen({super.key, this.userData});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool _isGenerating = false;
  Map<String, dynamic>? _projectData = MockData.sampleProject;
  Set<String> _selectedReportIds = {
    '3d',
    'vastu',
    'cost',
    'structural',
    'elevation',
    'plan'
  };

  final GlobalKey<ViewerScreenState> _viewerKey =
      GlobalKey<ViewerScreenState>();

  void _onProjectLoaded(Map<String, dynamic> project, Set<String> selectedIds) {
    setState(() {
      _projectData = project;
      _selectedReportIds = selectedIds;
      if (selectedIds.contains('3d')) {
        _selectedIndex = 1;
      } else if (selectedIds.isNotEmpty) {
        _selectedIndex = _getMappedIndex(selectedIds.first);
      } else {
        _selectedIndex = 1;
      }
    });
  }

  Future<void> _startAIGeneration(
    XFile groundFile,
    XFile? firstFile,
    XFile? secondFile,
    int floors,
    Set<String> selectedIds,
    String orientation,
  ) async {
    setState(() => _isGenerating = true);
    debugPrint('SHELL: Starting AI Generation pipeline...');

    WakelockPlus.enable();

    try {
      final apiService = ApiService();

      final totalAmount = (selectedIds.contains('3d') ? 499.0 : 0.0) +
          (selectedIds.contains('vastu') ? 299.0 : 0.0) +
          (selectedIds.contains('cost') ? 199.0 : 0.0) +
          (selectedIds.contains('structural') ? 999.0 : 0.0) +
          (selectedIds.contains('elevation') ? 799.0 : 0.0);

      final projectName =
          'Project ${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}|${selectedIds.join(",")}|$totalAmount';

      final res = await apiService.uploadPlan(
        groundFile,
        firstFile,
        secondFile,
        projectName,
        orientation: orientation,
      );

      debugPrint('SHELL: Upload successful, processing results...');

      if (mounted) {
        _onProjectLoaded(res['project'] as Map<String, dynamic>, selectedIds);
        setState(() => _isGenerating = false);
      }
    } catch (e) {
      debugPrint('SHELL: Upload error: $e');
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Generation could not be completed. Please check your network and blueprint file and try again.',
            ),
            backgroundColor: context.cs.error,
          ),
        );
      }
    } finally {
      WakelockPlus.disable();
    }
  }

  int _getMappedIndex(String id) {
    switch (id) {
      case '3d':
        return 1;
      case 'vastu':
        return 2;
      case 'cost':
      case 'boq':
        return 3;
      case 'structural':
        return 4;
      default:
        return 1;
    }
  }

  List<int> get _visibleIndices {
    List<int> indices = [0];
    if (_selectedReportIds.contains('3d')) indices.add(1);
    if (_selectedReportIds.contains('vastu')) indices.add(2);
    if (_selectedReportIds.contains('cost') ||
        _selectedReportIds.contains('boq')) {
      indices.add(3);
    }
    if (_selectedReportIds.contains('structural')) indices.add(4);
    if (_projectData != null) indices.add(5);
    indices.add(6);
    indices.add(7);
    return indices;
  }

  int _getBottomNavIndex() {
    if (_selectedIndex == 6) return 1;
    if (_selectedIndex == 7) return 2;
    return 0; // Default to Home for tools
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      setState(() => _selectedIndex = 0);
    } else if (index == 1) {
      setState(() => _selectedIndex = 6);
    } else if (index == 2) {
      setState(() => _selectedIndex = 7);
    } else if (index == 3) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        HomeScreen(
          onStartNewPlan: () => setState(() => _selectedIndex = 8),
          onOpen3D: () => setState(() => _selectedIndex = 1),
          onOpenVastu: () => setState(() => _selectedIndex = 2),
          onOpenCost: () => setState(() => _selectedIndex = 3),
          onOpenStructural: () => setState(() => _selectedIndex = 4),
          recentProject: _projectData,
          onOpenRecentProject: () => setState(() => _selectedIndex = 1),
        ),
        _projectData != null
            ? ViewerScreen(
                key: _viewerKey,
                projectData: _projectData!,
                onNavigateToVastu: () => setState(() => _selectedIndex = 2),
              )
            : AppEmptyState(
                icon: Icons.view_in_ar_rounded,
                title: '3D View',
                message:
                    'Upload a floor plan on the Home Map screen to generate your interactive 3D model.',
                actionLabel: 'Go to Home Map',
                onAction: () => setState(() => _selectedIndex = 0),
              ),
        _projectData != null
            ? VastuScreen(projectData: _projectData!)
            : AppEmptyState(
                icon: Icons.self_improvement_outlined,
                title: 'Vastu Report',
                message:
                    'Generate a project first to view comprehensive Vastu compliance analysis.',
                actionLabel: 'Go to Home Map',
                onAction: () => setState(() => _selectedIndex = 0),
              ),
        _projectData != null
            ? EstimationScreen(projectData: _projectData!)
            : AppEmptyState(
                icon: Icons.calculate_outlined,
                title: 'Cost Estimation',
                message:
                    'Generate a project first to view detailed material and labor cost breakdown.',
                actionLabel: 'Go to Home Map',
                onAction: () => setState(() => _selectedIndex = 0),
              ),
        _projectData != null
            ? StructuralScreen(projectData: _projectData!)
            : AppEmptyState(
                icon: Icons.foundation_outlined,
                title: 'Structural Report',
                message:
                    'Generate a project first to inspect structural load analysis and specifications.',
                actionLabel: 'Go to Home Map',
                onAction: () => setState(() => _selectedIndex = 0),
              ),
        _projectData != null
            ? DownloadScreen(
                projectData: _projectData!,
                selectedReportIds: _selectedReportIds,
                onNavigateTo3D: () => setState(() => _selectedIndex = 1),
                userData: widget.userData,
                capture3DScreenshots: () async {
                  return await _viewerKey.currentState
                          ?.captureAllFloorScreenshots() ??
                      {};
                },
              )
            : AppEmptyState(
                icon: Icons.download_outlined,
                title: 'Download Report',
                message:
                    'Generate a project first to download your high-resolution PDF architectural reports.',
                actionLabel: 'Go to Home Map',
                onAction: () => setState(() => _selectedIndex = 0),
              ),
        HistoryScreen(
          onSelectProject: (p) => _onProjectLoaded(
            p,
            {'3d', 'vastu', 'cost', 'structural', 'elevation', 'plan'},
          ),
        ),
        ProfileScreen(userData: widget.userData),
        UploadScreen(
          onProjectLoaded: _onProjectLoaded,
          onStartGeneration: _startAIGeneration,
          isExternalLoading: _isGenerating,
        ),
      ],
    );
  }

  Widget _buildNavigationHeader() {
    if (_selectedIndex == 0 || _projectData == null) {
      return const SizedBox.shrink();
    }

    final visible = _visibleIndices;
    final currentIndexInVisible = visible.indexOf(_selectedIndex);

    if (currentIndexInVisible == -1) return const SizedBox.shrink();

    final hasPrevious = currentIndexInVisible > 0;
    final hasNext = currentIndexInVisible < visible.length - 1;

    if (!hasPrevious && !hasNext) return const SizedBox.shrink();

    final cs = context.cs;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          if (hasPrevious)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = visible[currentIndexInVisible - 1];
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.surfaceContainerHighest,
                  foregroundColor: cs.onSurface,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.lgBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back_rounded, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        _navItems[visible[currentIndexInVisible - 1]].label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.05, end: 0),
            ),
          if (hasPrevious && hasNext) const SizedBox(width: AppSpacing.md),
          if (hasNext)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = visible[currentIndexInVisible + 1];
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.lgBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _navItems[visible[currentIndexInVisible + 1]].label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, end: 0),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return ResponsiveBuilder(
      builder: (context, breakpoint, constraints) {
        if (breakpoint.isExpanded) {
          // Expanded Desktop (>1024): Extended Sidebar + Main Body
          return Scaffold(
            backgroundColor: cs.surface,
            body: Row(
              children: [
                _Sidebar(
                  selectedIndex: _selectedIndex,
                  visibleIndices: _visibleIndices,
                  onTap: (i) => setState(() => _selectedIndex = i),
                  isDrawer: false,
                ),
                VerticalDivider(width: 1, color: cs.outlineVariant),
                Expanded(
                  child: Column(
                    children: [
                      _buildNavigationHeader(),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (breakpoint.isMedium) {
          // Medium Tablet (600 to 1024): NavigationRail + Main Body
          return Scaffold(
            backgroundColor: cs.surface,
            body: Row(
              children: [
                _TabletNavRail(
                  selectedIndex: _selectedIndex,
                  visibleIndices: _visibleIndices,
                  onTap: (i) => setState(() => _selectedIndex = i),
                ),
                VerticalDivider(width: 1, color: cs.outlineVariant),
                Expanded(
                  child: Column(
                    children: [
                      _buildNavigationHeader(),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Compact Mobile (<600): Drawer + Body + Floating Capsule Nav Bar
        return Scaffold(
          key: _scaffoldKey,
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: cs.surface,
          drawer: Drawer(
            backgroundColor: cs.surfaceContainer,
            child: _Sidebar(
              selectedIndex: _selectedIndex,
              visibleIndices: _visibleIndices,
              onTap: (i) {
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) setState(() => _selectedIndex = i);
                });
              },
              isDrawer: true,
            ),
          ),
          body: Column(
            children: [
              _buildNavigationHeader(),
              Expanded(child: _buildBody()),
            ],
          ),
          bottomNavigationBar: _isGenerating
              ? null
              : AppBottomNav(
                  currentIndex: _getBottomNavIndex(),
                  onTap: _onBottomNavTap,
                  items: const [
                    AppBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
                    AppBottomNavItem(
                        icon: Icons.history_rounded, label: 'History'),
                    AppBottomNavItem(
                        icon: Icons.person_rounded, label: 'Profile'),
                    AppBottomNavItem(icon: Icons.menu_rounded, label: 'Menu'),
                  ],
                ),
        );
      },
    );
  }
}

// ─── Adaptive Tablet Navigation Rail ──────────────────────────────────────────
class _TabletNavRail extends StatelessWidget {
  const _TabletNavRail({
    required this.selectedIndex,
    required this.visibleIndices,
    required this.onTap,
  });

  final int selectedIndex;
  final List<int> visibleIndices;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return Container(
      width: 72,
      color: cs.surfaceContainerHighest.withValues(alpha: 0.25),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Image.asset(
            AppAssets.logo,
            height: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView.builder(
              itemCount: visibleIndices.length,
              itemBuilder: (context, idx) {
                final itemIndex = visibleIndices[idx];
                final item = _navItems[itemIndex];
                final isSelected = selectedIndex == itemIndex;

                return Tooltip(
                  message: item.label,
                  preferBelow: false,
                  child: InkWell(
                    onTap: () => onTap(itemIndex),
                    borderRadius: AppRadius.mdBorder,
                    child: Container(
                      height: 52,
                      margin: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xs,
                        horizontal: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cs.primary.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: AppRadius.mdBorder,
                        border: isSelected
                            ? Border.all(
                                color: cs.primary.withValues(alpha: 0.4),
                              )
                            : null,
                      ),
                      child: Icon(
                        item.icon,
                        size: 24,
                        color: isSelected ? cs.primary : cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sidebar (Desktop persistent or Mobile Drawer) ─────────────────────────────
class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final List<int> visibleIndices;
  final ValueChanged<int> onTap;
  final bool isDrawer;

  const _Sidebar({
    required this.selectedIndex,
    required this.visibleIndices,
    required this.onTap,
    this.isDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final tt = context.tt;

    return Container(
      width: 270,
      color: cs.surfaceContainer,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.logo,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Kanavu Illam',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 250.ms),
          const SizedBox(height: AppSpacing.lg),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ListView.separated(
              itemCount: visibleIndices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, idx) {
                final itemIndex = visibleIndices[idx];
                final item = _navItems[itemIndex];
                final isActive = selectedIndex == itemIndex;

                return _SidebarItem(
                  icon: item.icon,
                  label: item.label,
                  isActive: isActive,
                  onTap: () => onTap(itemIndex),
                  delay: idx * 25,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int delay;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return Semantics(
      selected: isActive,
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdBorder,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? cs.primary.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: AppRadius.mdBorder,
              border: isActive
                  ? Border.all(
                      color: cs.primary.withValues(alpha: 0.35),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive ? cs.primary : cs.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? cs.primary : cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay));
  }
}

// ─── Floating Capsule Navigation Bar (Compact Mobile) ─────────────────────────
class _FloatingCapsuleNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _FloatingCapsuleNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        height: 60,
        decoration: BoxDecoration(
          color: cs.surfaceContainer.withValues(alpha: 0.85),
          borderRadius: AppRadius.fullBorder,
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.fullBorder,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    context: context,
                    index: 0,
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: selectedIndex == 0,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 6,
                    icon: Icons.history_rounded,
                    label: 'History',
                    isSelected: selectedIndex == 6,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 7,
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    isSelected: selectedIndex == 7,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 99,
                    icon: Icons.menu_rounded,
                    label: 'Menu',
                    isSelected: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    final cs = context.cs;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md - 2,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : Colors.transparent,
            borderRadius: AppRadius.fullBorder,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
              ),
              if (isSelected) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(duration: 150.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
