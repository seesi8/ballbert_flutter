import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

const isProduction = true;


Future<void> setWifi(String ssid, String password) async {
  // Prepare URL
  var wifiIP = isProduction ? '192.168.50.10' : "10.0.2.2";

  final url = Uri(scheme: "http", host: wifiIP, port: 5000, path: "/save_credentials");

  // Prepare HTTP Request
  final request = HttpClient()
      .postUrl(url)
      .then((HttpClientRequest request) {
    request.headers.set('Content-Type', 'application/json');

    final requestBody = {
      'ssid': ssid,
      'wifi_key': password,
    };

    final jsonBody = json.encode(requestBody);

    request.write(jsonBody);

    return request.close();
  });

  // Perform HTTP Request
  final response = await request;

  if (response.statusCode == 200) {
    final responseBody = await response.transform(utf8.decoder).join();

    try {
      final jsonObject = json.decode(responseBody);
      print('Success: $jsonObject');
    } catch (e) {
      print('Error decoding JSON: $e');
    }
  } else {
    print('HTTP Request Failed: ${response.statusCode}');
  }
}

Future<bool> checkConnection() async {
  // Prepare URL
  var wifiIP = isProduction ? '192.168.50.10' : "10.0.2.2";
  final url = Uri(scheme: "http", host: wifiIP, port: 5000, path: "/connected");

  // Prepare HTTP Request
  final request = HttpClient()
      .getUrl(url)
      .then((HttpClientRequest request) => request.close());

  // Perform HTTP Request
  try {
    final response = await request.timeout(const Duration(milliseconds: 750));
    if (response.statusCode == 200) {
      return true;
    } else {
      print("invalid status code");
      return false;
    }
  } catch (e) {
    print("error $e");
    return false;
  }
}




