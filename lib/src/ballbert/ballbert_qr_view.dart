import 'package:ballbert_app/src/ballbert/NameView.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanView extends StatefulWidget {
  const QRScanView({Key? key}) : super(key: key);

  static const routeName = '/qr';

  @override
  _QRScanViewState createState() => _QRScanViewState();
}

class _QRScanViewState extends State<QRScanView> {
  final TextEditingController _manualUIDEntry = TextEditingController();
  String imagePath = "";
  GlobalKey qrKey = GlobalKey();
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    _manualUIDEntry.addListener(() {
      setState(() {
        if (_manualUIDEntry.text.length == 32 ||
            _manualUIDEntry.text.length == 36) {
          imagePath = "assets/images/windows_logo.png";
        } else if (_manualUIDEntry.text.length == 16) {
          imagePath = "assets/images/raspi_logo.png";
        } else {
          imagePath = "";
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Step 3"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Scan QR code", style: TextStyle(fontSize: 20)),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ),
              const Text("Or", style: TextStyle(fontSize: 20)),
              const Text('Enter Manually', style: TextStyle(fontSize: 20)),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _manualUIDEntry,
                      decoration: const InputDecoration(
                        hintText: 'Enter Id Shown On Device',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Id Shown On Device';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: imagePath.isNotEmpty
                        ? Image.asset(imagePath)
                        : const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: imagePath.isNotEmpty
                    ? () {
                        if (imagePath.isEmpty) {
                          return;
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                NameView(uid: _manualUIDEntry.text)));
                      }
                    : null,
                child: const Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _manualUIDEntry.text = scanData.code ?? "";
        // You can also set imagePath based on the scanned QR code here
      });
    });
  }

  @override
  void dispose() {
    _manualUIDEntry.dispose();
    controller?.dispose();
    super.dispose();
  }
}
