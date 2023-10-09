import 'dart:async';

import 'package:ballbert_app/src/ballbert/ballbert_skill_add_view.dart';
import 'package:ballbert_app/src/ballbert/ballbert_view_skills.dart';
import 'package:flutter/material.dart';
import '../database/database.dart'; // Import the Ballbert class
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class BallbertDetailsView extends StatefulWidget {
  final Ballbert ballbert;
  final TextEditingController urlController = TextEditingController();
  final TextEditingController versionController = TextEditingController();

  BallbertDetailsView({Key? key, required this.ballbert}) : super(key: key);

  @override
  State<BallbertDetailsView> createState() => _BallbertDetailsViewState();
}

class _BallbertDetailsViewState extends State<BallbertDetailsView> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://websocket.ballbert.com:8765'),
  );

  Stream? myStream;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleConnection() async {
    await _channel.ready;
    print("ran");
    final data = {
      "type": "Authentication",
      "UID": widget.ballbert.uid
    };
    _channel.sink.add(jsonEncode(data));
  }

  var myStreamController = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    myStream = _channel.stream.asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.ballbert.name} Details'),
      ),
      body: FutureBuilder(
        future: _handleConnection(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: myStream,
                builder: (context, snapshot) {
                  _widgetOptions = [
                    BallbertSkillsView(
                        ballbert: widget.ballbert,
                        channel: _channel,
                        snapshot: snapshot.data),
                    BallbertSkillAddView(
                        ballbert: widget.ballbert,
                        channel: _channel,
                        snapshot: snapshot.data,
                        urlController: widget.urlController,
                        versionController: widget.versionController,),
                  ];
                  return Center(
                    child: _widgetOptions.elementAt(_selectedIndex),
                  );
                });
          } else {
            // Still loading, you can show a loading indicator here
            return Text("Loading");
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Skills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
