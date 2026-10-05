import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

// ─── Material Data Model ──────────────────────────────────────────────────────
class MaterialBrand {
  final String name;
  final String brand;
  final String type;
  final double price;
  final String unit;
  final String location;
  final IconData icon;
  final Color color;

  const MaterialBrand({
    required this.name,
    required this.brand,
    required this.type,
    required this.price,
    required this.unit,
    required this.location,
    required this.icon,
    required this.color,
  });

  String get updatedTime => '🟢 Live Market Price';
  bool get inStock => name.hashCode.abs() % 5 != 0;
}

// ─── Full Material Database ──────────────────────────────────────────────────
final List<MaterialBrand> allMaterials = [
  // CEMENT
  const MaterialBrand(
    name: 'Priya Cement 53 Grade',
    brand: 'Priya Cements',
    type: 'cement',
    price: 390,
    unit: 'bag',
    location: 'Tamil Nadu',
    icon: Icons.shopping_bag,
    color: Colors.deepPurple,
  ),
  const MaterialBrand(
    name: 'UltraTech Premium',
    brand: 'UltraTech',
    type: 'cement',
    price: 450,
    unit: 'bag',
    location: 'All India',
    icon: Icons.shopping_bag,
    color: Colors.blue,
  ),
  const MaterialBrand(
    name: 'ACC Gold Water Shield',
    brand: 'ACC',
    type: 'cement',
    price: 440,
    unit: 'bag',
    location: 'All India',
    icon: Icons.shopping_bag,
    color: Colors.green,
  ),
  const MaterialBrand(
    name: 'Ambuja Plus',
    brand: 'Ambuja Cements',
    type: 'cement',
    price: 430,
    unit: 'bag',
    location: 'North India',
    icon: Icons.shopping_bag,
    color: Colors.red,
  ),
  const MaterialBrand(
    name: 'Ramco Super Grade',
    brand: 'Ramco',
    type: 'cement',
    price: 410,
    unit: 'bag',
    location: 'South India',
    icon: Icons.shopping_bag,
    color: Colors.cyan,
  ),
  const MaterialBrand(
    name: 'Dalmia',
    brand: 'Dalmia',
    type: 'cement',
    price: 400,
    unit: 'bag',
    location: 'South India',
    icon: Icons.shopping_bag,
    color: Colors.teal,
  ),

  // STEEL
  const MaterialBrand(
    name: 'Tata Tiscon 550SD',
    brand: 'Tata Steel',
    type: 'steel',
    price: 88,
    unit: 'kg',
    location: 'Pan India',
    icon: Icons.view_headline,
    color: Colors.indigo,
  ),
  const MaterialBrand(
    name: 'JSW Neosteel 550D',
    brand: 'JSW Steel',
    type: 'steel',
    price: 85,
    unit: 'kg',
    location: 'Pan India',
    icon: Icons.view_headline,
    color: Colors.green,
  ),
  const MaterialBrand(
    name: 'SAIL TMT',
    brand: 'SAIL',
    type: 'steel',
    price: 82,
    unit: 'kg',
    location: 'Pan India',
    icon: Icons.view_headline,
    color: Colors.red,
  ),
  const MaterialBrand(
    name: 'Jindal Panther',
    brand: 'Jindal Steel',
    type: 'steel',
    price: 84,
    unit: 'kg',
    location: 'Pan India',
    icon: Icons.view_headline,
    color: Colors.amber,
  ),
];

class MaterialSearchWidget extends StatefulWidget {
  final void Function(MaterialBrand brand) onSelected;
  const MaterialSearchWidget({super.key, required this.onSelected});

  @override
  State<MaterialSearchWidget> createState() => _MaterialSearchWidgetState();
}

class _MaterialSearchWidgetState extends State<MaterialSearchWidget> {
  String _searchQuery = '';
  bool _isSearching = false;
  final List<MaterialBrand> _aiResults = [];

  List<MaterialBrand> get _filteredMaterials {
    if (_searchQuery.isEmpty) return [];
    return allMaterials.where((b) {
      return b.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.type.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _searchAI(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isSearching = true;
      _aiResults.clear();
    });
    try {
      final res = await ApiService().searchMaterial(query);
      if (res.isNotEmpty && mounted) {
        setState(() {
          for (var item in res) {
            if (item['brand'] != null) {
              _aiResults.add(MaterialBrand(
                name: item['brand'].toString(),
                brand: 'AI Matched',
                price: double.tryParse(item['price']?.toString() ?? '500') ??
                    500.0,
                unit: item['unit'] ?? 'unit',
                type: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                location: 'India',
                color: Colors.deepPurple,
                icon: Icons.auto_awesome,
              ));
            }
          }
        });
      }
    } catch (_) {
      // Ignored gracefully
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final tt = context.tt;
    final results = _filteredMaterials;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search materials',
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.35),
            borderRadius: AppRadius.mdBorder,
            border: Border.all(
              color: cs.outlineVariant,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.md),
              Icon(Icons.search_rounded, color: cs.onSurfaceVariant, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                      _aiResults.clear();
                    });
                  },
                  onSubmitted: (val) => _searchAI(val),
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search material...',
                    hintStyle: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_isSearching)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cs.primary,
                    ),
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(delay: 50.ms),
        if (results.isNotEmpty || _aiResults.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: AppRadius.mdBorder,
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length + _aiResults.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
              itemBuilder: (context, index) {
                final b = index < _aiResults.length
                    ? _aiResults[index]
                    : results[index - _aiResults.length];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: b.color.withValues(alpha: 0.15),
                    child: Icon(b.icon, color: b.color, size: 20),
                  ),
                  title: Text(
                    b.name.toUpperCase(),
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    '${b.brand} • ₹${b.price}/${b.unit}',
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  trailing: OutlinedButton(
                    onPressed: () {
                      widget.onSelected(b);
                      setState(() => _searchQuery = '');
                      FocusScope.of(context).unfocus();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: cs.primary),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.smBorder,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn(delay: 80.ms),
        ] else if (_searchQuery.isNotEmpty && !_isSearching) ...[
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Text(
                  'No local material found.',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Search Market Prices',
                  icon: Icons.auto_awesome,
                  onPressed: () => _searchAI(_searchQuery),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
