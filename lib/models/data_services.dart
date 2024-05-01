import 'dart:convert';

import 'package:flutter/services.dart';

class DataServices {
  static Future<Map<dynamic, dynamic>> getAllData() async {
    String jsonResponse = await rootBundle.loadString('assets/data.json');
    return json.decode(jsonResponse);
  }
}
