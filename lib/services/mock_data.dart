import '../core/app_assets.dart';

/// Complete, realistic mock architectural dataset.
/// Allows the entire Kanavu Illam frontend to function 100% standalone
/// without requiring a live backend server.
class MockData {
  static const bool useMockByDefault = true;

  static Map<String, dynamic> get sampleProject => {
        'id': 'demo_project_101',
        'name': 'Greenwood Luxury Villa',
        'orientation': 'North',
        'created_at': DateTime.now().toIso8601String(),
        'model_data': {
          'project': {
            'name': 'Greenwood Luxury Villa',
            'width': 36.0,
            'height': 48.0,
            'total_area': 2400.0,
          },
          'floors': {
            'ground': {
              'rooms': [
                {
                  'name': 'Portico / Parking',
                  'x': 2.0,
                  'y': 2.0,
                  'width': 14.0,
                  'height': 12.0,
                  'type': 'parking'
                },
                {
                  'name': 'Living Room',
                  'x': 16.0,
                  'y': 2.0,
                  'width': 18.0,
                  'height': 16.0,
                  'type': 'living'
                },
                {
                  'name': 'Pooja Room',
                  'x': 2.0,
                  'y': 14.0,
                  'width': 6.0,
                  'height': 8.0,
                  'type': 'pooja'
                },
                {
                  'name': 'Dining Room',
                  'x': 8.0,
                  'y': 14.0,
                  'width': 12.0,
                  'height': 12.0,
                  'type': 'dining'
                },
                {
                  'name': 'Kitchen',
                  'x': 20.0,
                  'y': 18.0,
                  'width': 14.0,
                  'height': 12.0,
                  'type': 'kitchen'
                },
                {
                  'name': 'Master Bedroom',
                  'x': 2.0,
                  'y': 26.0,
                  'width': 16.0,
                  'height': 16.0,
                  'type': 'bedroom'
                },
                {
                  'name': 'Attached Bath',
                  'x': 18.0,
                  'y': 30.0,
                  'width': 8.0,
                  'height': 8.0,
                  'type': 'bathroom'
                },
                {
                  'name': 'Guest Bedroom',
                  'x': 2.0,
                  'y': 42.0,
                  'width': 14.0,
                  'height': 12.0,
                  'type': 'bedroom'
                },
                {
                  'name': 'Common Bath',
                  'x': 16.0,
                  'y': 38.0,
                  'width': 8.0,
                  'height': 8.0,
                  'type': 'bathroom'
                },
                {
                  'name': 'Utility Area',
                  'x': 24.0,
                  'y': 30.0,
                  'width': 10.0,
                  'height': 10.0,
                  'type': 'utility'
                },
              ],
              'walls': [
                {
                  'start': [0, 0],
                  'end': [36, 0]
                },
                {
                  'start': [36, 0],
                  'end': [36, 48]
                },
                {
                  'start': [36, 48],
                  'end': [0, 48]
                },
                {
                  'start': [0, 48],
                  'end': [0, 0]
                },
                {
                  'start': [16, 0],
                  'end': [16, 26]
                },
                {
                  'start': [0, 14],
                  'end': [16, 14]
                },
                {
                  'start': [0, 26],
                  'end': [36, 26]
                },
                {
                  'start': [18, 26],
                  'end': [18, 48]
                },
              ],
              'doors': [
                {'x': 18.0, 'y': 2.0, 'width': 3.5, 'angle': 0},
                {'x': 8.0, 'y': 14.0, 'width': 3.0, 'angle': 0},
                {'x': 20.0, 'y': 20.0, 'width': 3.0, 'angle': 90},
                {'x': 4.0, 'y': 26.0, 'width': 3.2, 'angle': 0},
              ],
              'windows': [
                {'x': 24.0, 'y': 0.0, 'width': 4.0, 'dir': 'z'},
                {'x': 36.0, 'y': 8.0, 'width': 4.0, 'dir': 'x'},
                {'x': 36.0, 'y': 22.0, 'width': 3.5, 'dir': 'x'},
                {'x': 0.0, 'y': 30.0, 'width': 4.0, 'dir': 'x'},
                {'x': 8.0, 'y': 48.0, 'width': 4.0, 'dir': 'z'},
              ],
            },
          },
        },
        'vastu_data': sampleVastuEnglish,
        'cost_data': {
          'total_cost': 4250000.0,
          'material_cost': 2680000.0,
          'labor_cost': 1150000.0,
          'contingency': 420000.0,
          'built_up_area': 2400.0,
          'cost_per_sqft': 1770.0,
          'materials': {
            'cement': {
              'name': 'Cement (OPC/PPC)',
              'qty': 980,
              'unit': 'bags',
              'rate': 440.0,
              'cost': 431200.0
            },
            'steel': {
              'name': 'TMT Fe-550D Steel',
              'qty': 8500,
              'unit': 'kg',
              'rate': 82.0,
              'cost': 697000.0
            },
            'sand': {
              'name': 'M-Sand / Plastering Sand',
              'qty': 2800,
              'unit': 'cft',
              'rate': 72.0,
              'cost': 201600.0
            },
            'aggregate': {
              'name': '20mm Blue Metal',
              'qty': 2200,
              'unit': 'cft',
              'rate': 48.0,
              'cost': 105600.0
            },
            'bricks': {
              'name': 'Red Wire-Cut Bricks',
              'qty': 28000,
              'unit': 'pcs',
              'rate': 12.0,
              'cost': 336000.0
            },
            'flooring': {
              'name': 'Vitrified Tiles (4x2 ft)',
              'qty': 2100,
              'unit': 'sqft',
              'rate': 95.0,
              'cost': 199500.0
            },
            'paint': {
              'name': 'Interior/Exterior Paint',
              'qty': 240,
              'unit': 'liters',
              'rate': 320.0,
              'cost': 76800.0
            },
            'electrical': {
              'name': 'Wires, Switches & DB',
              'qty': 1,
              'unit': 'lumpsum',
              'rate': 240000.0,
              'cost': 240000.0
            },
            'plumbing': {
              'name': 'CPVC Pipes & Sanitaryware',
              'qty': 1,
              'unit': 'lumpsum',
              'rate': 210000.0,
              'cost': 210000.0
            },
            'woodwork': {
              'name': 'Teak Main Door & Windows',
              'qty': 1,
              'unit': 'lumpsum',
              'rate': 182300.0,
              'cost': 182300.0
            },
          },
          'room_breakdown': [
            {'name': 'Living & Foyer', 'area': 420.0, 'cost': 743400.0},
            {'name': 'Master Suite', 'area': 360.0, 'cost': 637200.0},
            {'name': 'Kitchen & Dining', 'area': 380.0, 'cost': 672600.0},
            {'name': 'Guest Bedroom', 'area': 280.0, 'cost': 495600.0},
            {'name': 'Bathrooms (2)', 'area': 160.0, 'cost': 354000.0},
            {'name': 'Pooja & Utility', 'area': 140.0, 'cost': 247800.0},
            {'name': 'Portico & Stairs', 'area': 300.0, 'cost': 479400.0},
          ],
          'labor_breakdown': [
            {
              'role': 'Masonry & Concrete Works',
              'days': 450,
              'rate': 950.0,
              'cost': 427500.0
            },
            {
              'role': 'Steel Fabrication / Bar Bending',
              'days': 160,
              'rate': 900.0,
              'cost': 144000.0
            },
            {
              'role': 'Plumbing & Drainage',
              'days': 110,
              'rate': 850.0,
              'cost': 93500.0
            },
            {
              'role': 'Electrical Wiring & Fittings',
              'days': 120,
              'rate': 850.0,
              'cost': 102000.0
            },
            {
              'role': 'Plastering & Tile Laying',
              'days': 220,
              'rate': 900.0,
              'cost': 198000.0
            },
            {
              'role': 'Painting & Polishing',
              'days': 150,
              'rate': 800.0,
              'cost': 120000.0
            },
            {
              'role': 'Supervision & Engineering',
              'days': 1,
              'rate': 65000.0,
              'cost': 65000.0
            },
          ],
        },
        'structural_data': {
          'soil_type': 'Medium Dense Red Sand / Gravel',
          'safe_bearing_capacity': '220 kN/m²',
          'foundation': {
            'type': 'Isolated Trapezoidal RCC Footing',
            'depth': '5.5 ft below ground level',
            'footing_size': '5 ft x 5 ft x 1.5 ft',
            'rebar': '12mm TMT @ 150mm c/c both ways',
          },
          'columns': [
            {
              'mark': 'C1',
              'width': 9.0,
              'height': 15.0,
              'rebar': '6 nos 16mm Fe550D',
              'ties': '8mm @ 150mm c/c'
            },
            {
              'mark': 'C2',
              'width': 9.0,
              'height': 12.0,
              'rebar': '4 nos 16mm + 2 nos 12mm',
              'ties': '8mm @ 150mm c/c'
            },
            {
              'mark': 'C3',
              'width': 9.0,
              'height': 18.0,
              'rebar': '8 nos 16mm Fe550D',
              'ties': '8mm @ 125mm c/c'
            },
          ],
          'plinth_beam': {
            'size': '9" x 12"',
            'top_bars': '2 nos 12mm',
            'bottom_bars': '3 nos 16mm',
            'stirrups': '8mm @ 150mm c/c',
          },
          'roof_beam': {
            'size': '9" x 15"',
            'top_bars': '3 nos 12mm',
            'bottom_bars': '3 nos 16mm + 1 no 12mm',
            'stirrups': '8mm @ 125mm c/c near supports',
          },
          'slab': {
            'thickness': '5 inches (125mm) M20 Concrete',
            'main_rebar': '10mm @ 150mm c/c',
            'dist_rebar': '8mm @ 175mm c/c',
          },
        },
        'visual_data': {
          'variations': [
            {
              'title': 'Ultra-Modern Minimalist',
              'description':
                  'Clean rectilinear cubic lines, wooden louvers, warm exterior LED strip lighting, and toughened glass railings.',
              'image_url': AppAssets.luxuryVillaBg,
            },
            {
              'title': 'Contemporary Tropical Villa',
              'description':
                  'Overhanging pitched terracotta eaves, textured exposed stone cladding, and abundant garden greenery integration.',
              'image_url': AppAssets.luxuryVillaBg,
            },
            {
              'title': 'Traditional Chettinad-Fusion',
              'description':
                  'Carved teakwood pillar portico, sloped clay roof tiling, and central courtyard ventilation layout.',
              'image_url': AppAssets.architecturalBg,
            },
          ],
        },
      };

  static Map<String, dynamic> get sampleVastuEnglish => {
        'score': 94,
        'grade': 'A+',
        'summary':
            'Excellent architectural compliance with authentic Tamil Manaiyadi Shastra & Vastu principles.',
        'strengths': [
          'Master Bedroom positioned accurately in Southwest (Kuberan Corner / Nairuthi)',
          'Kitchen positioned in Southeast (Agni Corner) ensuring positive fire element energy',
          'Pooja Room oriented in Northeast (Eshanya Corner) inviting supreme prosperity',
          'Main entrance opens towards auspicious North-Northeast with clear positive flow',
          'Open portico and veranda located in North/Northwest allowing natural cross-ventilation',
        ],
        'violations': [
          'Minor: Master bathroom door opens directly into southwest bedroom zone',
        ],
        'suggestions': [
          'Place a sacred Tulsi plant near the Northeast corner of the veranda',
          'Ensure the septic tank is located strictly in the Northwest boundary zone',
          'Keep the central Brahmasthana open and unobstructed for free cosmic energy circulation',
        ],
        'room_analysis': [
          {
            'room': 'Pooja Room',
            'direction': 'Northeast',
            'compliance': '100% Ideal',
            'status': 'Optimal'
          },
          {
            'room': 'Kitchen',
            'direction': 'Southeast',
            'compliance': '98% Ideal',
            'status': 'Optimal'
          },
          {
            'room': 'Master Bedroom',
            'direction': 'Southwest',
            'compliance': '95% Ideal',
            'status': 'Optimal'
          },
          {
            'room': 'Living Room',
            'direction': 'North / East',
            'compliance': '92% Good',
            'status': 'Good'
          },
          {
            'room': 'Portico / Parking',
            'direction': 'Northwest',
            'compliance': '90% Good',
            'status': 'Good'
          },
        ],
      };

  static Map<String, dynamic> get sampleVastuTamil => {
        'score': 94,
        'grade': 'A+',
        'summary':
            'பாரம்பரிய தமிழ் மனையடி சாஸ்திரம் மற்றும் வாஸ்து நெறிமுறைகளுடன் கூடிய மிகச்சிறந்த வடிவமைப்பு.',
        'strengths': [
          'தலைமை படுக்கையறை தென்மேற்கு (குபேர மூலை / நிருதி) திசையில் அமைந்துள்ளது',
          'சமையலறை தென்கிழக்கு (அக்னி மூலை) திசையில் உரிய முறையில் வடிவமைக்கப்பட்டுள்ளது',
          'பூஜை அறை வடகிழக்கு (ஈசான்ய மூலை) திசையில் தெய்வீக ஆற்றலை ஈர்க்கும் வகையில் உள்ளது',
          'தலைவாசல் மங்களகரமான வடக்கு-வடகிழக்கு திசையை நோக்கி அமைக்கப்பட்டுள்ளது',
          'போர்டிகோ மற்றும் தாழ்வாரம் வடக்கு/வடமேற்கு திசையில் நல்ல காற்றோட்டத்தை அளிக்கிறது',
        ],
        'violations': [
          'சிறிய குறை: படுக்கையறை கழிப்பறை கதவு தென்மேற்கு மண்டலத்தை நோக்கியுள்ளது',
        ],
        'suggestions': [
          'தாழ்வாரத்தின் வடகிழக்கு மூலையில் துளசி மாடம் அமைப்பது சிறந்தது',
          'கழிவுநீர் தொட்டியை கட்டாயமாக வடமேற்கு எல்லைப் பகுதியில் மட்டுமே அமைக்கவும்',
          'வீட்டின் நடுப்பகுதியான பிரம்மஸ்தானத்தை எவ்வித தடையும் இன்றி சுத்தமாக வைக்கவும்',
        ],
        'room_analysis': [
          {
            'room': 'பூஜை அறை',
            'direction': 'வடகிழக்கு (ஈசான்யம்)',
            'compliance': '100% சிறப்பு',
            'status': 'சிறப்பு'
          },
          {
            'room': 'சமையலறை',
            'direction': 'தென்கிழக்கு (அக்னி)',
            'compliance': '98% சிறப்பு',
            'status': 'சிறப்பு'
          },
          {
            'room': 'தலைமை படுக்கையறை',
            'direction': 'தென்மேற்கு (குபேரன்)',
            'compliance': '95% சிறப்பு',
            'status': 'சிறப்பு'
          },
          {
            'room': 'வரவேற்பறை',
            'direction': 'வடக்கு / கிழக்கு',
            'compliance': '92% நன்று',
            'status': 'நன்று'
          },
        ],
      };

  static List<Map<String, dynamic>> get sampleProjectsList => [
        sampleProject,
        {
          'id': 'demo_project_102',
          'name': 'Emerald Contemporary Duplex',
          'orientation': 'East',
          'created_at': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          'model_data': sampleProject['model_data'],
          'vastu_data': sampleVastuEnglish,
          'cost_data': sampleProject['cost_data'],
          'structural_data': sampleProject['structural_data'],
          'visual_data': sampleProject['visual_data'],
        },
        {
          'id': 'demo_project_103',
          'name': 'Kaveri Traditional Courtyard Home',
          'orientation': 'North',
          'created_at': DateTime.now()
              .subtract(const Duration(days: 8))
              .toIso8601String(),
          'model_data': sampleProject['model_data'],
          'vastu_data': sampleVastuTamil,
          'cost_data': sampleProject['cost_data'],
          'structural_data': sampleProject['structural_data'],
          'visual_data': sampleProject['visual_data'],
        },
      ];

  static List<dynamic> searchMaterials(String query) {
    final q = query.toLowerCase();
    final all = [
      {
        'id': 'mat_1',
        'name': 'UltraTech Super Cement (PPC)',
        'category': 'Cement',
        'price': 440.0,
        'unit': 'bag',
        'brand': 'UltraTech',
        'rating': 4.9,
      },
      {
        'id': 'mat_2',
        'name': 'Tata Tiscon 550D TMT Rebar (12mm)',
        'category': 'Steel',
        'price': 84.0,
        'unit': 'kg',
        'brand': 'Tata Tiscon',
        'rating': 4.9,
      },
      {
        'id': 'mat_3',
        'name': 'Kajaria Double Charge Vitrified Tiles (4x2)',
        'category': 'Tiles',
        'price': 110.0,
        'unit': 'sqft',
        'brand': 'Kajaria',
        'rating': 4.8,
      },
      {
        'id': 'mat_4',
        'name': 'Asian Paints Royale Luxury Emulsion',
        'category': 'Paints',
        'price': 490.0,
        'unit': 'liter',
        'brand': 'Asian Paints',
        'rating': 4.7,
      },
      {
        'id': 'mat_5',
        'name': 'Finolex FRLS Flame Retardant Wires (2.5 sq.mm)',
        'category': 'Electrical',
        'price': 2250.0,
        'unit': 'bundle (90m)',
        'brand': 'Finolex',
        'rating': 4.8,
      },
      {
        'id': 'mat_6',
        'name': 'Ashirvad CPVC FlowGuard Pipes (1 inch)',
        'category': 'Plumbing',
        'price': 460.0,
        'unit': 'length (3m)',
        'brand': 'Ashirvad',
        'rating': 4.8,
      },
    ];

    if (q.isEmpty) return all;
    return all.where((m) {
      final name = m['name'].toString().toLowerCase();
      final cat = m['category'].toString().toLowerCase();
      final brand = m['brand'].toString().toLowerCase();
      return name.contains(q) || cat.contains(q) || brand.contains(q);
    }).toList();
  }
}
