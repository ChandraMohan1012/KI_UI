import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class EstimationScreen extends StatefulWidget {
  final Map<String, dynamic> projectData;
  const EstimationScreen({super.key, required this.projectData});

  @override
  State<EstimationScreen> createState() => _EstimationScreenState();
}

class _EstimationScreenState extends State<EstimationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _selectedTier = 'standard';
  String _selectedContractMode = 'turnkey';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _totalArea => 1728.0; // Mock derived from projectData

  double get _baseRate {
    double rate = _selectedTier == 'premium'
        ? 3350.0
        : (_selectedTier == 'standard' ? 2250.0 : 1750.0);
    if (_selectedContractMode == 'labor') rate *= 0.40;
    return rate;
  }

  double get _totalCost => _totalArea * _baseRate;

  @override
  Widget build(BuildContext context) {
    return ReportScaffold(
      title: 'Cost Estimation',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: HeroCard(
              title: '₹${_totalCost.toStringAsFixed(0)}',
              subtitle:
                  '₹${_baseRate.toInt()} / sq.ft • ${_totalArea.toInt()} sq.ft',
              buttonLabel: 'Download BOQ PDF',
              onButtonTap: () {},
            ),
          ),
          AppTabBar(
            controller: _tabController,
            tabs: const ['Overview', 'BOQ Table', 'Materials'],
          ),
          SizedBox(
            height:
                600, // Fixed height for tab view content in scrollable scaffold
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildBOQTab(),
                _buildMaterialsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final tt = context.tt;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cost Factors',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppListRow(
                  label: 'Quality Tier',
                  subtitle: 'Select material grade',
                  leadingIcon: Icons.star_rounded,
                  trailingWidget: DropdownButton<String>(
                    value: _selectedTier,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'basic', child: Text('Basic')),
                      DropdownMenuItem(
                          value: 'standard', child: Text('Standard')),
                      DropdownMenuItem(
                          value: 'premium', child: Text('Premium')),
                    ],
                    onChanged: (v) => setState(() => _selectedTier = v!),
                  ),
                  showDivider: true,
                ),
                AppListRow(
                  label: 'Contract Mode',
                  subtitle: 'Labor vs Turnkey',
                  leadingIcon: Icons.handshake_rounded,
                  trailingWidget: DropdownButton<String>(
                    value: _selectedContractMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                          value: 'labor', child: Text('Labor Only')),
                      DropdownMenuItem(
                          value: 'turnkey', child: Text('Turnkey')),
                    ],
                    onChanged: (v) =>
                        setState(() => _selectedContractMode = v!),
                  ),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBOQTab() {
    final cs = context.cs;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: context.tt.titleSmall?.copyWith(
                fontWeight: FontWeight.bold, color: cs.onSurfaceVariant),
            dataTextStyle: context.tt.bodyMedium?.copyWith(color: cs.onSurface),
            dividerThickness: 1,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 60,
            columns: const [
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('Unit')),
              DataColumn(label: Text('Rate (₹)')),
              DataColumn(label: Text('Amount (₹)')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('Cement (50kg bags)')),
                DataCell(Text('691')),
                DataCell(Text('Bags')),
                DataCell(Text('380')),
                DataCell(Text('2,62,580')),
              ]),
              DataRow(cells: [
                DataCell(Text('Steel (TMT Bars)')),
                DataCell(Text('6500')),
                DataCell(Text('Kg')),
                DataCell(Text('65')),
                DataCell(Text('4,22,500')),
              ]),
              DataRow(cells: [
                DataCell(Text('Sand (M-Sand)')),
                DataCell(Text('2937')),
                DataCell(Text('cft')),
                DataCell(Text('55')),
                DataCell(Text('1,61,535')),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const AppListRow(
                  label: 'Cement',
                  subtitle: 'Dalmia / Ramco / Ultratech',
                  leadingIcon: Icons.category_rounded,
                  value: '₹380 / Bag',
                  showDivider: true,
                ),
                const AppListRow(
                  label: 'Steel (TMT 500D)',
                  subtitle: 'Tata Tiscon / JSW Neo',
                  leadingIcon: Icons.fitness_center_rounded,
                  value: '₹65 / Kg',
                  showDivider: true,
                ),
                const AppListRow(
                  label: 'Bricks (Red)',
                  subtitle: 'Chamber Bricks',
                  leadingIcon: Icons.apps_rounded,
                  value: '₹9 / Piece',
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
