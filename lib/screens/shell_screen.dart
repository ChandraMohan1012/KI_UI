import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/api_service.dart';
import '../services/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import 'download_screen.dart';
import 'estimation_screen.dart';
import 'history_screen.dart';
import 'home/home_screen.dart';
import 'profile_screen.dart';
import 'structural_screen.dart';
import 'upload_screen.dart';
import 'vastu_screen.dart';
import 'viewer_screen.dart';

class ShellScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ShellScreen({super.key, this.userData});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
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
      _selectedIndex = 1; // Open 3D view on completion
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
    WakelockPlus.enable();

    try {
      final apiService = ApiService();
      final totalAmount = (selectedIds.contains('3d') ? 499.0 : 0.0) +
          (selectedIds.contains('vastu') ? 299.0 : 0.0) +
          (selectedIds.contains('cost') ? 199.0 : 0.0) +
          (selectedIds.contains('structural') ? 999.0 : 0.0);

      final projectName =
          'Project ${DateTime.now().millisecondsSinceEpoch.toString().substring(10)}|${selectedIds.join(",")}|$totalAmount';

      final res = await apiService.uploadPlan(
        groundFile,
        firstFile,
        secondFile,
        projectName,
        orientation: orientation,
      );

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
            content: const Text('Generation failed. Please try again.'),
            backgroundColor: context.cs.error,
          ),
        );
      }
    } finally {
      WakelockPlus.disable();
    }
  }

  int _getNavRailIndex() {
    if (_selectedIndex == 6) return 1;
    if (_selectedIndex == 7) return 2;
    return 0; // Default to Home for tools / inner screens
  }

  void _onNavRailTap(int navIndex) {
    if (navIndex == 0) {
      setState(() => _selectedIndex = 0);
    } else if (navIndex == 1) {
      setState(() => _selectedIndex = 6);
    } else if (navIndex == 2) {
      setState(() => _selectedIndex = 7);
    }
  }

  Widget _buildBody() {
    final isInnerScreen = _selectedIndex != 0 &&
        _selectedIndex != 6 &&
        _selectedIndex != 7 &&
        _selectedIndex != 8;

    Widget child;

    switch (_selectedIndex) {
      case 0:
        child = HomeScreen(
          onStartNewPlan: () => setState(() => _selectedIndex = 8),
          onOpen3D: () => setState(() => _selectedIndex = 1),
          onOpenVastu: () => setState(() => _selectedIndex = 2),
          onOpenCost: () => setState(() => _selectedIndex = 3),
          onOpenStructural: () => setState(() => _selectedIndex = 4),
          recentProject: _projectData,
          onOpenRecentProject: () => setState(() => _selectedIndex = 1),
        );
        break;
      case 1:
        child = _projectData != null
            ? ViewerScreen(
                key: _viewerKey,
                projectData: _projectData!,
                onNavigateToVastu: () => setState(() => _selectedIndex = 2),
              )
            : AppEmptyState(
                icon: Icons.view_in_ar_rounded,
                title: '3D View',
                message: 'Start a plan to view 3D model.',
                actionLabel: 'Go to Home',
                onAction: () => setState(() => _selectedIndex = 0),
              );
        break;
      case 2:
        child = _projectData != null
            ? VastuScreen(projectData: _projectData!)
            : AppEmptyState(
                icon: Icons.self_improvement_outlined,
                title: 'Vastu Report',
                message: 'Start a plan to view Vastu score.',
                actionLabel: 'Go to Home',
                onAction: () => setState(() => _selectedIndex = 0),
              );
        break;
      case 3:
        child = _projectData != null
            ? EstimationScreen(projectData: _projectData!)
            : AppEmptyState(
                icon: Icons.calculate_outlined,
                title: 'Cost Estimation',
                message: 'Start a plan to view estimation.',
                actionLabel: 'Go to Home',
                onAction: () => setState(() => _selectedIndex = 0),
              );
        break;
      case 4:
        child = _projectData != null
            ? StructuralScreen(projectData: _projectData!)
            : AppEmptyState(
                icon: Icons.foundation_outlined,
                title: 'Structural Report',
                message: 'Start a plan to view structural load.',
                actionLabel: 'Go to Home',
                onAction: () => setState(() => _selectedIndex = 0),
              );
        break;
      case 5:
        child = _projectData != null
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
                message: 'Start a plan to download report.',
                actionLabel: 'Go to Home',
                onAction: () => setState(() => _selectedIndex = 0),
              );
        break;
      case 6:
        child = HistoryScreen(
          onSelectProject: (p) => _onProjectLoaded(
            p,
            {'3d', 'vastu', 'cost', 'structural', 'elevation', 'plan'},
          ),
        );
        break;
      case 7:
        child = ProfileScreen(userData: widget.userData);
        break;
      case 8:
        child = UploadScreen(
          onProjectLoaded: _onProjectLoaded,
          onStartGeneration: _startAIGeneration,
          isExternalLoading: _isGenerating,
        );
        break;
      default:
        child = HomeScreen(
          onStartNewPlan: () => setState(() => _selectedIndex = 8),
          onOpen3D: () => setState(() => _selectedIndex = 1),
          onOpenVastu: () => setState(() => _selectedIndex = 2),
          onOpenCost: () => setState(() => _selectedIndex = 3),
          onOpenStructural: () => setState(() => _selectedIndex = 4),
          recentProject: _projectData,
          onOpenRecentProject: () => setState(() => _selectedIndex = 1),
        );
    }

    if (!isInnerScreen) {
      return child;
    }

    // Inner screens show a plain back arrow in the top-left returning to Home
    return Column(
      children: [
        Container(
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          color: AppColors.background,
          child: AppIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () => setState(() => _selectedIndex = 0),
            tooltip: 'Back to Home',
            backgroundColor: AppColors.transparent,
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, breakpoint, constraints) {
        if (breakpoint.isExpanded || breakpoint.isMedium) {
          final isExtended = breakpoint.isExpanded;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: Row(
              children: [
                NavigationRail(
                  extended: isExtended,
                  selectedIndex: _getNavRailIndex(),
                  onDestinationSelected: _onNavRailTap,
                  backgroundColor: AppColors.surface,
                  indicatorColor: AppColors.accent.withValues(alpha: 0.15),
                  selectedIconTheme:
                      const IconThemeData(color: AppColors.accent),
                  unselectedIconTheme:
                      const IconThemeData(color: AppColors.textSecondary),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelTextStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.history_outlined),
                      selectedIcon: Icon(Icons.history_rounded),
                      label: Text('History'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, color: AppColors.border),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: AppSpacing.maxContentWidth),
                      child: _buildBody(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Compact Mobile (<600): Body + Floating Black Pill Nav Bar (3 items)
        return Scaffold(
          backgroundColor: AppColors.background,
          body: _buildBody(),
          bottomNavigationBar: _isGenerating
              ? null
              : AppBottomNav(
                  currentIndex: _getNavRailIndex(),
                  onTap: _onNavRailTap,
                  items: const [
                    AppBottomNavItem(icon: Icons.home_rounded, label: 'Home'),
                    AppBottomNavItem(
                        icon: Icons.history_rounded, label: 'History'),
                    AppBottomNavItem(
                        icon: Icons.person_rounded, label: 'Profile'),
                  ],
                ),
        );
      },
    );
  }
}
