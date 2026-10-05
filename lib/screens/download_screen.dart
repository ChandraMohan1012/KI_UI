import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../services/pdf_service.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class DownloadScreen extends StatefulWidget {
  final Map<String, dynamic> projectData;
  final Set<String> selectedReportIds;
  final VoidCallback? onNavigateTo3D;
  final Map<String, dynamic>? userData;
  final Future<Map<String, Uint8List>> Function()? capture3DScreenshots;

  const DownloadScreen({
    super.key,
    required this.projectData,
    required this.selectedReportIds,
    this.onNavigateTo3D,
    this.userData,
    this.capture3DScreenshots,
  });

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  bool _isDownloading = false;

  Future<void> _downloadPDF() async {
    setState(() => _isDownloading = true);
    try {
      Map<String, Uint8List>? screenshots;
      if (widget.capture3DScreenshots != null) {
        screenshots = await widget.capture3DScreenshots!();
      }

      final pdfBytes = await PdfService.createProfessionalPdf(
        widget.projectData,
        widget.selectedReportIds,
        screenshots3D: screenshots,
      );

      final projectName = widget.projectData['name'] ?? 'Project';
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'KanavuIllam_${projectName}_Report.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate PDF'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDownloading) {
      return const Center(child: AppLoader(message: 'Generating PDF...'));
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              flex: 4,
              child: HeroCard(
                title: 'Ready',
                subtitle: 'Export Package',
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              flex: 4,
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    AppListRow(
                      label: 'PDF Report',
                      leadingIcon: Icons.picture_as_pdf_rounded,
                      trailingWidget: Icon(Icons.check_circle_rounded,
                          color: AppColors.success, size: 20),
                      showDivider: true,
                    ),
                    AppListRow(
                      label: 'CAD DXF',
                      leadingIcon: Icons.architecture_rounded,
                      trailingWidget: Icon(Icons.check_circle_rounded,
                          color: AppColors.success, size: 20),
                      showDivider: true,
                    ),
                    AppListRow(
                      label: '3D Renders',
                      leadingIcon: Icons.image_rounded,
                      trailingWidget: Icon(Icons.check_circle_rounded,
                          color: AppColors.success, size: 20),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppPillButton(
              label: 'Download All',
              onPressed: _downloadPDF,
              isLoading: _isDownloading,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
