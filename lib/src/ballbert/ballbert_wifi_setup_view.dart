import 'package:ballbert_app/src/api/wifi.dart';
import 'package:flutter/material.dart';

class WifiSetupView extends StatefulWidget {
  const WifiSetupView({Key? key}) : super(key: key);

  static const routeName = '/wifiSetup';

  @override
  _WifiSetupViewState createState() => _WifiSetupViewState();
}

class _WifiSetupViewState extends State<WifiSetupView> {
  TextEditingController _wifiNameController = TextEditingController();
  TextEditingController _wifiPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Step 2"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                _isButtonEnabled =
                    _formKey.currentState!.validate(); // Check validation
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Enter your Wi-Fi name and password of the network you wish to connect to.",
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.justify,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _wifiNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Wi-Fi Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Wi-Fi Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _wifiPasswordController,
                      obscureText: true, // to hide password
                      decoration: const InputDecoration(
                        hintText: 'Enter Wi-Fi Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Wi-Fi Password';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () {
                              String wifiName = _wifiNameController.text;
                              String wifiPassword = _wifiPasswordController.text;
                              setWifi(wifiName, wifiPassword);
                              Navigator.of(context).pushNamed("/qr");
                            }
                          : null, // Disable the button if not valid
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _wifiNameController.dispose();
    _wifiPasswordController.dispose();
    super.dispose();
  }
}
