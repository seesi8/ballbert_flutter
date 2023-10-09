import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../database/database.dart';

class BallbertSkillsView extends StatefulWidget {
  final Ballbert ballbert;
  final WebSocketChannel channel;
  final String? snapshot;

  const BallbertSkillsView(
      {Key? key, required this.ballbert, required this.channel, required this.snapshot})
      : super(key: key);

  @override
  _BallbertSkillsViewState createState() => _BallbertSkillsViewState();
}

class _BallbertSkillsViewState extends State<BallbertSkillsView> {
  @override
  void initState() {
    super.initState();
    // Send the initial message when the widget is created
    sendGetInstalledSkillsMessage();
  }

  void sendGetInstalledSkillsMessage() {
    final message = {"type": "get_installed_skills"};
    widget.channel.sink.add(jsonEncode(message));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = jsonDecode(widget.snapshot ?? "{}");
    if (data['type'] == 'get_installed_skills') {
      List<dynamic> installedSkills = data['installed_skills'];
      return ListView.builder(
        itemCount: installedSkills.length,
        itemBuilder: (context, index) {
          final skill = installedSkills[index];
          return ListTile(
            title: Text(skill['name']),
            subtitle: Text('Version: ${skill['version']}'),
          );
        },
      );
    }
    return Container(child: CircularProgressIndicator());
  }
}
