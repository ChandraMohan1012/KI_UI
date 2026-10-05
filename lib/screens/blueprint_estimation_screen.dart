import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/app_badge.dart';

class BlueprintEstimationScreen extends StatefulWidget {
  final Map<String, dynamic> projectData;
  const BlueprintEstimationScreen({super.key, required this.projectData});

  @override
  State<BlueprintEstimationScreen> createState() =>
      _BlueprintEstimationScreenState();
}

class _BlueprintEstimationScreenState extends State<BlueprintEstimationScreen> {
  final Map<String, Map<String, dynamic>> _materials = {
    'Cement': {
      'options': [
        'UltraTech (Premium)',
        'ACC Concrete+',
        'Birla Gold',
        'Priya',
        'Ramco'
      ],
      'selected': 'UltraTech (Premium)',
      'price_per_unit': 450.0,
      'base_price': 450.0,
      'unit': 'bag',
      'qty_multiplier': 0.45,
    },
    'Steel': {
      'options': [
        'TATA Tiscon SD',
        'JSW Neosteel 550D',
        'Vizag Steel',
        'Prime Gold',
        'vela'
      ],
      'selected': 'TATA Tiscon SD',
      'price_per_unit': 88.0,
      'base_price': 88.0,
      'unit': 'kg',
      'qty_multiplier': 4.8,
    },
    'Sand & Aggregate': {
      'options': [
        'M-Sand (Double Washed)',
        'P-Sand (Plastering)',
        'River Sand',
      ],
      'selected': 'M-Sand (Double Washed)',
      'price_per_unit': 75.0,
      'base_price': 75.0,
      'unit': 'cft',
      'qty_multiplier': 1.8,
    },
    'Aggregates': {
      'options': ['20mm Blue Metal', '40mm Blue Metal', 'Granite Chips'],
      'selected': '20mm Blue Metal',
      'price_per_unit': 64.0,
      'base_price': 64.0,
      'unit': 'cft',
      'qty_multiplier': 1.4,
    },
    'Bricks / Blocks': {
      'options': [
        'First Class Red Bricks',
        'AAC Blocks (Lightweight)',
        'Solid Concrete Blocks',
      ],
      'selected': 'First Class Red Bricks',
      'price_per_unit': 13.0,
      'base_price': 13.0,
      'unit': 'pcs',
      'qty_multiplier': 24.0,
    },
    'Flooring': {
      'options': [
        'Vitrified Tiles (Kajaria)',
        'Indian Marble',
        'Italian Granite',
      ],
      'selected': 'Vitrified Tiles (Kajaria)',
      'price_per_unit': 160.0,
      'base_price': 160.0,
      'unit': 'sqft',
      'qty_multiplier': 1.15,
    },
    'Electrical': {
      'options': [
        'Havells / Finolex (Std)',
        'Schneider Electric',
        'Anchor Roma',
      ],
      'selected': 'Havells / Finolex (Std)',
      'price_per_unit': 110.0,
      'base_price': 110.0,
      'unit': 'sqft',
      'qty_multiplier': 1.0,
    },
    'Plumbing & Sanitation': {
      'options': [
        'Astral / Ashirvad (CPVC)',
        'Supreme Pipes',
        'Finolex',
      ],
      'selected': 'Astral / Ashirvad (CPVC)',
      'price_per_unit': 85.0,
      'base_price': 85.0,
      'unit': 'sqft',
      'qty_multiplier': 1.0,
    },
  };

  double _totalArea = 1200.0;

  @override
  void initState() {
    super.initState();
    _initData();
    _fetchLiveRates();
  }

  void _initData() {
    final modelData = widget.projectData['model_data'];
    if (modelData != null && modelData['project'] != null) {
      final prj = modelData['project'];
      double w = (prj['width'] as num?)?.toDouble() ?? 30.0;
      double h = (prj['height'] as num?)?.toDouble() ?? 40.0;
      setState(() {
        _totalArea = w * h;
      });
    }
  }

  void _fetchLiveRates() async {
    try {
      final liveData = await ApiService().getMaterialPricing();
      if (!mounted) return;
      if (liveData.containsKey('materials') && liveData['materials'] is Map) {
        final m = liveData['materials'] as Map<String, dynamic>;
        setState(() {
          if (m['cement'] != null) {
            _materials['Cement']?['price_per_unit'] =
                (m['cement']['standard'] as num?)?.toDouble() ?? 450.0;
            _materials['Cement']?['base_price'] =
                (m['cement']['standard'] as num?)?.toDouble() ?? 450.0;
          }
          if (m['steel'] != null) {
            _materials['Steel']?['price_per_unit'] =
                (m['steel']['standard'] as num?)?.toDouble() ?? 88.0;
            _materials['Steel']?['base_price'] =
                (m['steel']['standard'] as num?)?.toDouble() ?? 88.0;
          }
          if (m['sand'] != null) {
            _materials['Sand & Aggregate']?['price_per_unit'] =
                (m['sand']['standard'] as num?)?.toDouble() ?? 75.0;
            _materials['Sand & Aggregate']?['base_price'] =
                (m['sand']['standard'] as num?)?.toDouble() ?? 75.0;
          }
          if (m['aggregate'] != null) {
            _materials['Aggregates']?['price_per_unit'] =
                (m['aggregate']['standard'] as num?)?.toDouble() ?? 64.0;
            _materials['Aggregates']?['base_price'] =
                (m['aggregate']['standard'] as num?)?.toDouble() ?? 64.0;
          }
          if (m['bricks'] != null) {
            _materials['Bricks / Blocks']?['price_per_unit'] =
                (m['bricks']['standard'] as num?)?.toDouble() ?? 13.0;
            _materials['Bricks / Blocks']?['base_price'] =
                (m['bricks']['standard'] as num?)?.toDouble() ?? 13.0;
          }
          if (m['tiles'] != null) {
            _materials['Flooring']?['price_per_unit'] =
                (m['tiles']['standard'] as num?)?.toDouble() ?? 160.0;
            _materials['Flooring']?['base_price'] =
                (m['tiles']['standard'] as num?)?.toDouble() ?? 160.0;
          }
        });
      }
    } catch (e) {
      debugPrint('[BlueprintEstimation] Live market fetch notice: $e');
    }
  }

  double _calculateTotal() {
    double total = 0;
    _materials.forEach((key, data) {
      double qty = _totalArea * (data['qty_multiplier'] as num).toDouble();
      total += qty * (data['price_per_unit'] as num).toDouble();
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final liveTotal = _calculateTotal();

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(cs),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTotalCard(liveTotal, cs),
                  const SizedBox(height: AppSpacing.xl),
                  _sectionLabel('LIVE MARKET MATERIAL SELECTION', cs),
                  const SizedBox(height: AppSpacing.md),
                  ..._materials.entries.map(
                    (entry) => _buildMaterialEditor(entry.key, entry.value, cs),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildRealtimeBanner(cs),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) {
    final tt = context.tt;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimation / Real-time Config',
          style: tt.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(duration: 350.ms),
        const SizedBox(height: 6),
        Row(
          children: [
            Text('Accurate',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
            _dot(cs),
            Text('Transparent',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
            _dot(cs),
            Text('Real-time',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
          ],
        ).animate().fadeIn(delay: 100.ms),
      ],
    );
  }

  Widget _dot(ColorScheme cs) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Icon(Icons.circle,
            size: 4, color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
      );

  Widget _buildTotalCard(double total, ColorScheme cs) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: AppRadius.xlBorder,
        color: cs.surfaceContainer,
        border:
            Border.all(color: cs.primary.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ESTIMATED PROJECT TOTAL',
                style: TextStyle(
                  color: cs.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              AppBadge(
                label: 'AI BOQ',
                variant: AppBadgeVariant.cost,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '₹${(total / 100000).toStringAsFixed(2)} Lakhs',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 38,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Estimated for ${_totalArea.toInt()} Sq.Ft. built-up area',
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).scale(begin: const Offset(0.98, 0.98));
  }

  Widget _buildMaterialEditor(
      String name, Map<String, dynamic> data, ColorScheme cs) {
    IconData icon = Icons.inventory_2_outlined;
    Color iconColor = cs.primary;
    if (name == 'Steel') {
      icon = Icons.reorder_rounded;
      iconColor = cs.secondary;
    } else if (name.contains('Sand')) {
      icon = Icons.grain;
      iconColor = context.semanticColors.warning;
    } else if (name.contains('Brick')) {
      icon = Icons.grid_view_rounded;
      iconColor = cs.error;
    } else if (name == 'Flooring') {
      icon = Icons.layers_outlined;
      iconColor = context.semanticColors.vastuAccent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '₹${(data['price_per_unit'] as num).toInt()} / ${data['unit']}',
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _customDropdown(data, cs),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _customDropdown(Map<String, dynamic> data, ColorScheme cs) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: AppRadius.mdBorder,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: data['selected'],
          isExpanded: true,
          dropdownColor: cs.surfaceContainer,
          borderRadius: AppRadius.mdBorder,
          elevation: 6,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: cs.onSurfaceVariant),
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          items: (data['options'] as List<String>)
              .map((opt) => DropdownMenuItem(
                    value: opt,
                    child: Text(
                      opt,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (val) {
            setState(() {
              data['selected'] = val;
              double bp = (data['base_price'] as num).toDouble();
              if (val!.contains('Premium') ||
                  val.contains('TATA') ||
                  val.contains('UltraTech')) {
                data['price_per_unit'] = bp * 1.2;
              } else if (val.contains('Concrete+') || val.contains('JSW')) {
                data['price_per_unit'] = bp * 1.1;
              } else {
                data['price_per_unit'] = bp;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildRealtimeBanner(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.15),
              borderRadius: AppRadius.mdBorder,
            ),
            child: Icon(Icons.shield_outlined, color: cs.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Prices are updated in real-time',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Market rates may vary based on location',
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppBadge(
            label: 'Live',
            icon: Icons.circle,
            variant: AppBadgeVariant.success,
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
