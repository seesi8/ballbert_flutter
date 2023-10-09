import 'package:flutter/material.dart';
import '../settings/settings_view.dart';
import '../database/database.dart';
import 'ballbert_details_view.dart';

class BallbertListView extends StatefulWidget {
  static const routeName = '/';

  @override
  _BallbertListViewState createState() => _BallbertListViewState();
}

class _BallbertListViewState extends State<BallbertListView> {
  late List<Ballbert> items = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    loadBallbertList(); // Load the Ballbert list when the view is initialized
  }

  Future<void> loadBallbertList() async {
    // Load the list of Ballbert items from storage.
    final loadedItems = await BallbertStorage.load();

    // Update the state to rebuild the UI with the loaded data.
    setState(() {
      items = loadedItems; // Assign the loaded data to 'items'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up a Ballbert'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'ballbertListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          String imagePath;
          if (item.uid.length == 32 ||
              item.uid.length == 36) {
            imagePath = "assets/images/windows_logo.png";
          } else if (item.uid.length == 16) {
            imagePath = "assets/images/raspi_logo.png";
          } else {
            imagePath = "";
          }
          return ListTile(
            title: Text(item.name),
            leading: Image.asset(imagePath, width: 40, height: 40,),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BallbertDetailsView(ballbert: item),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/addBallbert");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
