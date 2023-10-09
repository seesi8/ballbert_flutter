import 'dart:convert';
import 'package:web_socket_channel/io.dart';

Future<void> sendDataToWebSocket(String url, double userVersion) async {
  final channel = IOWebSocketChannel.connect(url);

  try {    
    final data = {
      "type": "add_skill",
      "version": userVersion,
      "url": "https://github.com/Ballbert-LLC/Ballbert-Weather.git",
    };

    channel.sink.add(json.encode(data));
    print('Sent data: $data');

    channel.sink.close();

  } catch (e) {
    print('An error occurred: $e');
    channel.sink.close();
  }
}