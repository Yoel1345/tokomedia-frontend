import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiService {
    static String get baseUrl {
    return 'https://tokomedia-backend-production.up.railway.app/api';
  }

  static Future<Map<String, dynamic>> register(
      String phone, String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: jsonEncode({'phone': phone, 'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> login(String phone, String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: jsonEncode({'phone': phone, 'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> verify(
      String phone, String email, String code) async {
    final res = await http.post(
      Uri.parse('$baseUrl/verify.php'),
      body: jsonEncode({'phone': phone, 'email': email, 'code': code}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> sendOtp(
      String phoneOrEmail, String method, String code) async {
    final res = await http.post(
      Uri.parse('$baseUrl/send_otp.php'),
      body: jsonEncode({'phoneOrEmail': phoneOrEmail, 'method': method, 'code': code}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getUser(String phoneOrEmail) async {
    final res = await http.post(
      Uri.parse('$baseUrl/get_user.php'),
      body: jsonEncode({'phoneOrEmail': phoneOrEmail}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  // ─── Product API ───────────────────────────────────────────────

  static Future<Map<String, dynamic>> getProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/products_list.php'));
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> addProduct(
    Map<String, String> fields,
    XFile? imageXFile,
  ) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/products_add.php'));
    request.fields.addAll(fields);
    if (imageXFile != null) {
      final bytes = await imageXFile.readAsBytes();
      final ext = imageXFile.name.contains('.') ? imageXFile.name.split('.').last : 'jpg';
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: 'upload.$ext',
      ));
    }
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateProduct(
    String id,
    Map<String, String> fields,
    XFile? imageXFile,
  ) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/products_update.php'));
    request.fields.addAll(fields);
    request.fields['id'] = id;
    if (imageXFile != null) {
      final bytes = await imageXFile.readAsBytes();
      final ext = imageXFile.name.contains('.') ? imageXFile.name.split('.').last : 'jpg';
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: 'upload.$ext',
      ));
    }
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> deleteProduct(
      String id, String userIdentifier) async {
    final res = await http.post(
      Uri.parse('$baseUrl/products_delete.php'),
      body: jsonEncode({'id': id, 'user_identifier': userIdentifier}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }
}
