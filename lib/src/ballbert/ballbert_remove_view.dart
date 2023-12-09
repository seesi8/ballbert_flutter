import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../database/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BallbertRemoveView extends StatefulWidget {
  final Ballbert ballbert;
  BallbertRemoveView({
    Key? key,
    required this.ballbert,
  }) : super(key: key);

  @override
  _BallbertRemoveViewState createState() => _BallbertRemoveViewState();
}

class _BallbertRemoveViewState extends State<BallbertRemoveView> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Ballbert Removal"),
          content: Text("Are you sure you want to remove this ballbert?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Remove Ballbert"),
              onPressed: () async {
                await BallbertStorage.removeBallbert(widget.ballbert);
                Navigator.of(context).pushNamed("/");
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
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog();
            },
            child: Text("Remove Ballbert"),
          ),
        ],
      ),
    );
  }
}
