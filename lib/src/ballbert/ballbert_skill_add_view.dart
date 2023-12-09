import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../database/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BallbertSkillAddView extends StatefulWidget {
  final Ballbert ballbert;
  final WebSocketChannel channel;
  final String? snapshot;
  final TextEditingController urlController;
  final TextEditingController versionController;

  BallbertSkillAddView({
    Key? key,
    required this.ballbert,
    required this.channel,
    required this.snapshot,
    required this.urlController,
    required this.versionController,
  }) : super(key: key);

  @override
  _BallbertSkillAddViewState createState() => _BallbertSkillAddViewState();
}

class _BallbertSkillAddViewState extends State<BallbertSkillAddView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // widget.urlController.dispose();
    // widget.versionController.dispose();
    super.dispose();
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Skill Addition"),
          content: Text("Are you sure you want to add this skill?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Add Skill"),
              onPressed: () {
                final data = {
                  "type": "add_skill",
                  "version": widget.versionController.text,
                  "url": widget.urlController.text
                };
                widget.channel.sink.add(jsonEncode(data));
                widget.versionController.clear();
                widget.urlController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "Add a skill",
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            controller: widget.urlController,
            decoration: InputDecoration(labelText: "URL"),
          ),
          TextField(
            controller: widget.versionController,
            decoration: InputDecoration(labelText: "Version"),
          ),
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog();
            },
            child: Text("Add Skill"),
          ),
        ],
      ),
    );
  }
}
