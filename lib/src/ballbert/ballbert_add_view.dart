import 'package:flutter/material.dart';
import '../api/wifi.dart';

class BallbertAddView extends StatefulWidget {
  const BallbertAddView({Key? key}) : super(key: key);

  static const routeName = '/addBallbert';

  @override
  _BallbertAddViewState createState() => _BallbertAddViewState();
}

class _BallbertAddViewState extends State<BallbertAddView> {
  void _checkConnection(context) async {
    bool isConnected = await checkConnection();
    if (isConnected) {
      Navigator.of(context).pushNamed("/wifiSetup");
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Unable to connect'),
          content:
              const Text('Your device was unable to connect to the assistant'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Step 1"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Connect to the device\'s Wi-Fi',
                style: TextStyle(fontSize: 20)),
            Text('Name will be: Ballbert-XXXX', style: TextStyle(fontSize: 20)),
            Icon(
              Icons.wifi,
              size: 200,
              color: Colors.blue,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_checkConnection(context)},
        child: Text("Next"),
      ),
    );
  }
}
