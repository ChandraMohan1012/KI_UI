import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_assets.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

class DoorStyleOption {
  final String id;
  final String name;
  final String description;
  final String assetPath;
  final String badge;

  const DoorStyleOption({
    required this.id,
    required this.name,
    required this.description,
    required this.assetPath,
    required this.badge,
  });
}

class WindowStyleOption {
  final String id;
  final String name;
  final String description;
  final String assetPath;
  final String badge;

  const WindowStyleOption({
    required this.id,
    required this.name,
    required this.description,
    required this.assetPath,
    required this.badge,
  });
}

const List<DoorStyleOption> doorStyleOptions = [
  DoorStyleOption(
    id: 'glass',
    name: 'Glass Insert',
    description: 'Mahogany frosted glass',
    assetPath: AppAssets.doorGlass,
    badge: 'OPTION 3',
  ),
  DoorStyleOption(
    id: 'teak',
    name: 'Teak Wood',
    description: 'Vertical teak grain',
    assetPath: AppAssets.doorTeak,
    badge: 'OPTION 1',
  ),
  DoorStyleOption(
    id: 'panel',
    name: 'Mahogany Panel',
    description: 'Mahogany raised panel',
    assetPath: AppAssets.doorPanel,
    badge: 'OPTION 2',
  ),
];

const List<WindowStyleOption> windowStyleOptions = [
  WindowStyleOption(
    id: 'wood',
    name: 'Teak Frame',
    description: 'Teak wood frame',
    assetPath: AppAssets.windowWood,
    badge: 'OPTION 2',
  ),
  WindowStyleOption(
    id: 'upvc',
    name: 'UPVC Sliding',
    description: 'UPVC sliding frame',
    assetPath: AppAssets.windowUpvc,
    badge: 'OPTION 1',
  ),
  WindowStyleOption(
    id: 'black',
    name: 'Black Aluminum',
    description: 'Black aluminum frame',
    assetPath: AppAssets.windowBlack,
    badge: 'OPTION 3',
  ),
];

class DoorWindowSelectorWidget extends StatefulWidget {
  final String currentDoorStyle;
  final String currentWindowStyle;
  final Function(String doorStyle) onDoorStyleChanged;
  final Function(String windowStyle) onWindowStyleChanged;
  final Function(XFile customImage, String type)? onCustomImageUploaded;

  const DoorWindowSelectorWidget({
    super.key,
    this.currentDoorStyle = 'glass',
    this.currentWindowStyle = 'wood',
    required this.onDoorStyleChanged,
    required this.onWindowStyleChanged,
    this.onCustomImageUploaded,
  });

  @override
  State<DoorWindowSelectorWidget> createState() =>
      _DoorWindowSelectorWidgetState();
}

class _DoorWindowSelectorWidgetState extends State<DoorWindowSelectorWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _selectedDoor;
  late String _selectedWindow;
  XFile? _customDoorImage;
  XFile? _customWindowImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDoor = widget.currentDoorStyle;
    _selectedWindow = widget.currentWindowStyle;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickCustomImage(String category) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (category == 'door') {
          _customDoorImage = image;
          _selectedDoor = 'custom';
          widget.onDoorStyleChanged('custom');
        } else {
          _customWindowImage = image;
          _selectedWindow = 'custom';
          widget.onWindowStyleChanged('custom');
        }
      });
      widget.onCustomImageUploaded?.call(image, category);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$category uploaded'),
          backgroundColor: context.cs.primary,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final tt = context.tt;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
      backgroundColor: cs.surfaceContainer,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Container(
        width: 740,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.15),
                        borderRadius: AppRadius.mdBorder,
                      ),
                      child: Icon(
                        Icons.door_sliding_outlined,
                        color: cs.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Realistic Door & Window Selection',
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Customize architectural elements for 3D model',
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: AppRadius.mdBorder,
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: cs.primary,
                  borderRadius: AppRadius.smBorder,
                ),
                labelColor: cs.onPrimary,
                unselectedLabelColor: cs.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: '🚪 Door Designs'),
                  Tab(text: '🪟 Window Designs'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Tab View Body
            SizedBox(
              height: 380,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDoorTab(),
                  _buildWindowTab(),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Footer Action
            AppButton(
              label: 'Apply Selection to 3D Model',
              isFullWidth: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoorTab() {
    final cs = context.cs;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: doorStyleOptions.map((opt) {
              final isSelected = _selectedDoor == opt.id;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedDoor = opt.id);
                    widget.onDoorStyleChanged(opt.id);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.surfaceContainerHighest.withValues(alpha: 0.6)
                          : cs.surfaceContainerHighest.withValues(alpha: 0.2),
                      borderRadius: AppRadius.mdBorder,
                      border: Border.all(
                        color: isSelected
                            ? cs.primary
                            : cs.outlineVariant.withValues(alpha: 0.4),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: cs.primary.withValues(alpha: 0.15),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: AppRadius.smBorder,
                              child: Image.asset(
                                opt.assetPath,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 160,
                                  color: cs.surfaceContainerHighest,
                                  child: Center(
                                    child: Icon(
                                      Icons.door_front_door_outlined,
                                      size: 40,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? cs.primary
                                      : Colors.black.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  opt.badge,
                                  style: TextStyle(
                                    color: isSelected
                                        ? cs.onPrimary
                                        : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: cs.onPrimary,
                                    size: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          opt.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          opt.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, AppSpacing.minTapTarget),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.mdBorder,
              ),
              side: BorderSide(color: cs.outlineVariant),
            ),
            onPressed: () => _pickCustomImage('door'),
            icon: Icon(Icons.add_photo_alternate_outlined, color: cs.primary),
            label: Text(
              _customDoorImage != null
                  ? 'Door: ${_customDoorImage!.name}'
                  : 'Upload Custom Door',
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowTab() {
    final cs = context.cs;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: windowStyleOptions.map((opt) {
              final isSelected = _selectedWindow == opt.id;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedWindow = opt.id);
                    widget.onWindowStyleChanged(opt.id);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.surfaceContainerHighest.withValues(alpha: 0.6)
                          : cs.surfaceContainerHighest.withValues(alpha: 0.2),
                      borderRadius: AppRadius.mdBorder,
                      border: Border.all(
                        color: isSelected
                            ? cs.primary
                            : cs.outlineVariant.withValues(alpha: 0.4),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: cs.primary.withValues(alpha: 0.15),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: AppRadius.smBorder,
                              child: Image.asset(
                                opt.assetPath,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 160,
                                  color: cs.surfaceContainerHighest,
                                  child: Center(
                                    child: Icon(
                                      Icons.window_outlined,
                                      size: 40,
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? cs.primary
                                      : Colors.black.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  opt.badge,
                                  style: TextStyle(
                                    color: isSelected
                                        ? cs.onPrimary
                                        : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: cs.onPrimary,
                                    size: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          opt.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          opt.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, AppSpacing.minTapTarget),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.mdBorder,
              ),
              side: BorderSide(color: cs.outlineVariant),
            ),
            onPressed: () => _pickCustomImage('window'),
            icon: Icon(Icons.add_photo_alternate_outlined, color: cs.primary),
            label: Text(
              _customWindowImage != null
                  ? 'Window: ${_customWindowImage!.name}'
                  : 'Upload Custom Window',
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
