import 'package:flutter/material.dart';
import "../database/database.dart";

class NameView extends StatefulWidget {
  final String uid; // Add the uid parameter

  const NameView({Key? key, required this.uid}) : super(key: key);

  @override
  _NameViewState createState() => _NameViewState();
}

class _NameViewState extends State<NameView> {
  final TextEditingController _nameEntry = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameEntry.addListener(_checkTextField);
  }

  void _checkTextField() {
    setState(() {
      _isSubmitButtonEnabled = _nameEntry.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Step 3"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: 'Enter the name you wish to choose for the device of UID: ', style: TextStyle(fontSize: 20)),
                      TextSpan(
                          text: widget.uid,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _nameEntry,
                  decoration: const InputDecoration(
                    hintText: 'Enter the name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Id Shown On Device';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _isSubmitButtonEnabled
                      ? () {
              
                          BallbertStorage.addBallbert(Ballbert(_nameEntry.text, widget.uid));
                          Navigator.of(context).popAndPushNamed("/");
                        }
                      : null,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
