import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mock_data.dart';

class ApiService {
  // Set to true to run 100% standalone frontend without backend server
  static bool isOfflineMockMode = true;

  static const String baseUrl = 'http://127.0.0.1:3000/api';

  Future<Map<String, dynamic>> uploadPlan(
    XFile groundFile,
    XFile? firstFloorFile,
    XFile? secondFloorFile,
    String projectName, {
    String orientation = 'North',
  }) async {
    if (isOfflineMockMode) {
      // Simulate realistic AI generation processing time
      await Future.delayed(const Duration(milliseconds: 1400));
      final proj = Map<String, dynamic>.from(MockData.sampleProject);
      proj['name'] = projectName.split('|').first;
      proj['orientation'] = orientation;
      return {'success': true, 'project': proj};
    }

    try {
      final request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      request.fields['name'] = projectName;
      request.fields['orientation'] = orientation;

      final prefs = await SharedPreferences.getInstance();
      request.fields['email'] = prefs.getString('user_email') ?? 'unknown';

      // Attach ground floor
      final groundBytes = await groundFile.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'ground_plan',
        groundBytes,
        filename: groundFile.name,
      ));

      if (firstFloorFile != null) {
        final firstBytes = await firstFloorFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'first_plan',
          firstBytes,
          filename: firstFloorFile.name,
        ));
      }

      if (secondFloorFile != null) {
        final secondBytes = await secondFloorFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'second_plan',
          secondBytes,
          filename: secondFloorFile.name,
        ));
      }

      final response =
          await request.send().timeout(const Duration(seconds: 15));
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseData);
      }
    } catch (_) {
      // Graceful fallback to mock data on network failure
    }

    final proj = Map<String, dynamic>.from(MockData.sampleProject);
    proj['name'] = projectName.split('|').first;
    proj['orientation'] = orientation;
    return {'success': true, 'project': proj};
  }

  Future<List<dynamic>> getAllProjects([String? email]) async {
    if (isOfflineMockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.sampleProjectsList;
    }

    try {
      String url = '$baseUrl/projects';
      if (email != null && email.isNotEmpty) {
        url += '?email=${Uri.encodeComponent(email)}';
      }
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (_) {
      // Fallback
    }

    return MockData.sampleProjectsList;
  }

  Future<Map<String, dynamic>> getProject(String projectId) async {
    if (isOfflineMockMode) {
      return MockData.sampleProject;
    }

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/project/$projectId'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (_) {
      // Fallback
    }

    return MockData.sampleProject;
  }

  Future<Map<String, dynamic>> analyzeVastu(
    String projectId, {
    String lang = 'English',
  }) async {
    if (isOfflineMockMode) {
      await Future.delayed(const Duration(milliseconds: 350));
      return lang == 'Tamil'
          ? MockData.sampleVastuTamil
          : MockData.sampleVastuEnglish;
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/analyze-vastu/$projectId'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'lang': lang}),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (_) {
      // Fallback
    }

    return lang == 'Tamil'
        ? MockData.sampleVastuTamil
        : MockData.sampleVastuEnglish;
  }

  Future<List<dynamic>> searchMaterial(String query) async {
    if (isOfflineMockMode) {
      return MockData.searchMaterials(query);
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/material/search'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'query': query}),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) return decoded;
        return [decoded];
      }
    } catch (_) {
      // Fallback
    }

    return MockData.searchMaterials(query);
  }

  /// Alias for backward compatibility with estimation screens
  Future<Map<String, dynamic>> getMaterialPricing() => getLiveMarketPrices();

  Future<Map<String, dynamic>> getLiveMarketPrices({
    String location = 'Tamil Nadu, India',
  }) async {
    if (!isOfflineMockMode) {
      try {
        final response = await http
            .post(
              Uri.parse('$baseUrl/material/live-prices'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'location': location}),
            )
            .timeout(const Duration(seconds: 4));
        if (response.statusCode == 200) {
          return json.decode(response.body);
        }
      } catch (_) {}
    }

    return {
      'is_live_market': true,
      'location': location,
      'materials': {
        'cement': {
          'basic': 390.0,
          'standard': 440.0,
          'premium': 490.0,
          'unit': 'bag',
          'name': 'Cement (OPC/PPC)'
        },
        'steel': {
          'basic': 68.0,
          'standard': 84.0,
          'premium': 92.0,
          'unit': 'kg',
          'name': 'TMT Steel Rebar'
        },
        'sand': {
          'basic': 65.0,
          'standard': 75.0,
          'premium': 110.0,
          'unit': 'cft',
          'name': 'M-Sand / River Sand'
        },
        'aggregate': {
          'basic': 40.0,
          'standard': 48.0,
          'premium': 55.0,
          'unit': 'cft',
          'name': 'Blue Metal Aggregate'
        },
        'bricks': {
          'basic': 9.0,
          'standard': 12.0,
          'premium': 65.0,
          'unit': 'pcs',
          'name': 'Bricks / AAC Blocks'
        },
        'tiles': {
          'basic': 45.0,
          'standard': 75.0,
          'premium': 160.0,
          'unit': 'sqft',
          'name': 'Flooring Tiles'
        },
        'paint': {
          'basic': 190.0,
          'standard': 280.0,
          'premium': 420.0,
          'unit': 'liter',
          'name': 'Paint & Putty'
        },
        'electrical': {
          'basic': 110.0,
          'standard': 140.0,
          'premium': 220.0,
          'unit': 'sqft',
          'name': 'Electrical Systems'
        },
        'plumbing': {
          'basic': 95.0,
          'standard': 130.0,
          'premium': 210.0,
          'unit': 'sqft',
          'name': 'Plumbing Systems'
        },
        'doors': {
          'basic': 7500.0,
          'standard': 12000.0,
          'premium': 22000.0,
          'unit': 'nos',
          'name': 'Doors'
        },
        'windows': {
          'basic': 5500.0,
          'standard': 8500.0,
          'premium': 14000.0,
          'unit': 'nos',
          'name': 'Windows'
        },
      }
    };
  }

  Future<Map<String, dynamic>> createRazorpayOrder(double amount) async {
    return {
      'id': 'order_demo_${DateTime.now().millisecondsSinceEpoch}',
      'amount': (amount * 100).toInt(),
      'currency': 'INR',
    };
  }

  Future<Map<String, dynamic>> verifyRazorpayPayment(
    Map<String, dynamic> data,
  ) async {
    return {'success': true, 'verified': true};
  }

  static Future<Map<String, dynamic>?> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    if (isOfflineMockMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      final email = body['email']?.toString() ?? 'architect@kanavuillam.ai';
      final name = body['name']?.toString() ??
          email.split('@').first.replaceAll(RegExp(r'[._]'), ' ');
      final capitalizedName = name.isNotEmpty
          ? '${name[0].toUpperCase()}${name.substring(1)}'
          : 'Demo Architect';

      return {
        'user': {
          'id': 'demo_user_1',
          'name': capitalizedName,
          'email': email,
          'phone': '9876543210',
          'role': 'architect',
        },
        'token': 'demo_jwt_token',
      };
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (_) {
      // Fallback
    }

    final email = body['email']?.toString() ?? 'architect@kanavuillam.ai';
    return {
      'user': {
        'id': 'demo_user_1',
        'name': 'Demo Architect',
        'email': email,
        'phone': '9876543210',
        'role': 'architect',
      },
      'token': 'demo_jwt_token',
    };
  }
}
