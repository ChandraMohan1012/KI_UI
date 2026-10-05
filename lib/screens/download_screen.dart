import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
          SnackBar(
              content: Text('Failed to generate PDF: $e'),
              backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  void _unsupportedExport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type export is coming soon.'),
        backgroundColor: context.cs.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;

    return ReportScaffold(
      title: 'Download & Export',
      body: _isDownloading
          ? const Center(
              child: AppLoader(message: 'Generating High-Quality PDF...'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: AppSpacing.maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HeroCard(
                        title: 'Ready to Export',
                        subtitle:
                            'Download your full project report containing all selected analysis, BOQ, and models.',
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text('Export Formats',
                          style: tt.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _ExportCard(
                              title: 'PDF Report',
                              icon: Icons.picture_as_pdf_rounded,
                              onTap: _downloadPDF,
                              isPrimary: true,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _ExportCard(
                              title: 'CAD (DXF)',
                              icon: Icons.architecture_rounded,
                              onTap: () => _unsupportedExport('CAD'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _ExportCard(
                              title: 'Images (PNG)',
                              icon: Icons.image_rounded,
                              onTap: () => _unsupportedExport('Images'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          const Spacer(), // Empty space for grid alignment
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ExportCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isPrimary ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: context.tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isPrimary ? cs.primary : cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
