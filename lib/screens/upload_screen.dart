import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import 'secure_payment_screen.dart';

class UploadScreen extends StatefulWidget {
  final void Function(Map<String, dynamic> project, Set<String> selectedIds)?
      onProjectLoaded;
  final Function(XFile ground, XFile? first, XFile? second, int floors,
      Set<String> selectedIds, String orientation)? onStartGeneration;
  final bool isExternalLoading;

  const UploadScreen({
    super.key,
    this.onProjectLoaded,
    this.onStartGeneration,
    this.isExternalLoading = false,
  });

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  XFile? _groundFile;
  final Set<String> _selectedIds = {'3d', 'vastu', 'cost', 'structural'};

  Future<void> _pickFile() async {
    final f = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (f != null) {
      setState(() {
        _groundFile = f;
      });
    }
  }

  void _toggleOption(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  double get _totalAmount {
    double total = 0;
    if (_selectedIds.contains('3d')) total += 499.0;
    if (_selectedIds.contains('vastu')) total += 299.0;
    if (_selectedIds.contains('cost')) total += 199.0;
    if (_selectedIds.contains('structural')) total += 999.0;
    if (_selectedIds.contains('elevation')) total += 799.0;
    return total;
  }

  void _onPay() {
    _groundFile ??= XFile('', name: 'sample_luxury_villa.png');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SecurePaymentScreen(
          amount: _totalAmount,
          selectedItems: _selectedIds.map((id) => id.toUpperCase()).toList(),
          onFinish: () {
            widget.onStartGeneration?.call(
              _groundFile!,
              null,
              null,
              0, // floors
              _selectedIds,
              'Auto',
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final cs = context.cs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload & Checkout'),
        backgroundColor: Colors.transparent,
      ),
      body: widget.isExternalLoading
          ? const AppLoader(message: 'Generating your plan...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: AppSpacing.maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Upload Floor Plan',
                        style: tt.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Upload Area
                      GestureDetector(
                        onTap: _pickFile,
                        child: AppCard(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: cs.primary.withValues(alpha: 0.5),
                                style: BorderStyle.solid,
                              ),
                              borderRadius: AppRadius.mdBorder,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(Icons.upload_file_rounded,
                                    size: 48, color: cs.primary),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  _groundFile != null
                                      ? _groundFile!.name
                                      : 'Tap to upload plan image',
                                  style: tt.bodyMedium?.copyWith(
                                    color: _groundFile != null
                                        ? cs.onSurface
                                        : cs.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      Text(
                        'Select Features',
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Plan Options
                      AppCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _buildOption('3D Walkthrough',
                                'Interactive 3D model', '3d', 499),
                            _buildOption('Vastu Report', 'Compliance analysis',
                                'vastu', 299),
                            _buildOption('Cost Estimator',
                                'Material & labor BOQ', 'cost', 199),
                            _buildOption('Structural Load', 'Safety & analysis',
                                'structural', 999,
                                isLast: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Order Summary
                      Text(
                        'Order Summary',
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount', style: tt.titleMedium),
                            Text(
                              '₹${_totalAmount.toInt()}',
                              style: tt.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      AppPillButton(
                        label: 'Pay ₹${_totalAmount.toInt()}',
                        onPressed: _selectedIds.isEmpty ? null : _onPay,
                        isFullWidth: true,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildOption(String title, String subtitle, String id, int price,
      {bool isLast = false}) {
    final isSelected = _selectedIds.contains(id);
    return AppListRow(
      label: title,
      subtitle: subtitle,
      leadingWidget: Checkbox(
        value: isSelected,
        onChanged: (_) => _toggleOption(id),
        activeColor: AppColors.accent,
      ),
      trailingWidget: Text(
        '₹$price',
        style: context.tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      showDivider: !isLast,
      onTap: () => _toggleOption(id),
    );
  }
}
