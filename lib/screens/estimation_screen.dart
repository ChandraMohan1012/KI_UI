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

  double get _totalArea => 1728.0;

  double get _baseRate {
    double rate = _selectedTier == 'premium'
        ? 3350.0
        : (_selectedTier == 'standard' ? 2250.0 : 1750.0);
    if (_selectedContractMode == 'labor') rate *= 0.40;
    return rate;
  }

  double get _totalCost => _totalArea * _baseRate;

  void _showAllSheet(String title, List<Widget> children) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              width: 36,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.fullBorder,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(title,
                  style: context.tt.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(AppSpacing.md),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeroCard(
              title: '₹${_totalCost.toStringAsFixed(0)}',
              subtitle: '₹${_baseRate.toInt()} / sq.ft',
            ),
            const SizedBox(height: AppSpacing.xs),
            AppTabBar(
              controller: _tabController,
              tabs: const ['Overview', 'BOQ', 'Materials'],
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
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
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Column(
      children: [
        Expanded(
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppListRow(
                  label: 'Tier',
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
                  label: 'Mode',
                  leadingIcon: Icons.handshake_rounded,
                  trailingWidget: DropdownButton<String>(
                    value: _selectedContractMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'labor', child: Text('Labor')),
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
        ),
      ],
    );
  }

  Widget _buildBOQTab() {
    final rows = [
      const AppListRow(
        label: 'Cement',
        value: '₹2,62,580',
        leadingIcon: Icons.inventory_2_outlined,
        showDivider: true,
      ),
      const AppListRow(
        label: 'Steel',
        value: '₹4,22,500',
        leadingIcon: Icons.fitness_center_rounded,
        showDivider: true,
      ),
      const AppListRow(
        label: 'Sand',
        value: '₹1,61,535',
        leadingIcon: Icons.grain_rounded,
        showDivider: false,
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rows,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _showAllSheet('BOQ Breakdown', rows),
          child:
              const Text('View all', style: TextStyle(color: AppColors.accent)),
        ),
      ],
    );
  }

  Widget _buildMaterialsTab() {
    final rows = [
      const AppListRow(
        label: 'Cement',
        value: '₹380/Bag',
        leadingIcon: Icons.category_rounded,
        showDivider: true,
      ),
      const AppListRow(
        label: 'Steel',
        value: '₹65/Kg',
        leadingIcon: Icons.fitness_center_rounded,
        showDivider: true,
      ),
      const AppListRow(
        label: 'Bricks',
        value: '₹9/Piece',
        leadingIcon: Icons.apps_rounded,
        showDivider: false,
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rows,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _showAllSheet('Materials Rate', rows),
          child:
              const Text('View all', style: TextStyle(color: AppColors.accent)),
        ),
      ],
    );
  }
}
