import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class StructuralScreen extends StatefulWidget {
  final Map<String, dynamic> projectData;
  const StructuralScreen({super.key, required this.projectData});

  @override
  State<StructuralScreen> createState() => _StructuralScreenState();
}

class _StructuralScreenState extends State<StructuralScreen> {
  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    final cs = context.cs;

    return ReportScaffold(
      title: 'Structural Load',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: HeroCard(
              title: 'Structural Safety Analysis',
              subtitle:
                  'Load-bearing distribution and steel reinforcement schedules.',
              buttonLabel: 'Download Full Report',
              onButtonTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text('Beam Schedule',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: cs.onSurfaceVariant),
                  dataTextStyle: tt.bodyMedium?.copyWith(color: cs.onSurface),
                  dividerThickness: 1,
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 60,
                  columns: const [
                    DataColumn(label: Text('Mark')),
                    DataColumn(label: Text('Size')),
                    DataColumn(label: Text('Top Bars')),
                    DataColumn(label: Text('Bottom Bars')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('PB1')),
                      const DataCell(Text('9" x 15"')),
                      const DataCell(Text('2-12Ø')),
                      const DataCell(Text('3-16Ø')),
                      DataCell(AppStatusChip(
                          label: 'Safe', variant: AppBadgeVariant.success)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('PB2')),
                      const DataCell(Text('9" x 18"')),
                      const DataCell(Text('2-16Ø')),
                      const DataCell(Text('3-16Ø')),
                      DataCell(AppStatusChip(
                          label: 'Safe', variant: AppBadgeVariant.success)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('PB3')),
                      const DataCell(Text('9" x 12"')),
                      const DataCell(Text('2-12Ø')),
                      const DataCell(Text('2-12Ø')),
                      DataCell(AppStatusChip(
                          label: 'Review', variant: AppBadgeVariant.warning)),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text('Column Schedule',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: cs.onSurfaceVariant),
                  dataTextStyle: tt.bodyMedium?.copyWith(color: cs.onSurface),
                  dividerThickness: 1,
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 60,
                  columns: const [
                    DataColumn(label: Text('Mark')),
                    DataColumn(label: Text('Size')),
                    DataColumn(label: Text('Vertical Reinforcement')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('C1')),
                      const DataCell(Text('9" x 15"')),
                      const DataCell(Text('6-16Ø')),
                      DataCell(AppStatusChip(
                          label: 'Safe', variant: AppBadgeVariant.success)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('C2')),
                      const DataCell(Text('9" x 18"')),
                      const DataCell(Text('8-16Ø')),
                      DataCell(AppStatusChip(
                          label: 'Safe', variant: AppBadgeVariant.success)),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
