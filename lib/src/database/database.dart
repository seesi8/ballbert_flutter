import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Ballbert {
  String? id; // Make id nullable to allow auto-incrementing

  final String name;
  final String uid;

  Ballbert(this.name, this.uid);

  // Convert a Ballbert into a Map. Exclude id when saving.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      "id": id
    };
  }

  // Implement a factory constructor to create a Ballbert from a Map.
  factory Ballbert.fromJson(Map<String, dynamic> json) {
    print(json);
    final ballbert = Ballbert((json['name'] ?? "" )as String, (json['uid'] ?? "" )as String);
    ballbert.id = (json['id'] ?? "") as String; // Assign the id from JSON
    return ballbert;
  }

  // Implement toString to make it easier to see information about
  // each Ballbert when using the print statement.
  @override
  String toString() {
    return 'Ballbert{id: $id, name: $name, uid: $uid}';
  }
}

class BallbertStorage {
  static const String key = 'ballbert_list';

  // Store a list of Ballbert objects in shared preferences.
  static Future<void> save(List<Ballbert> ballbertList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = ballbertList.map((ballbert) => ballbert.toMap()).toList();
    final jsonString = jsonEncode(jsonData);
    await prefs.setString(key, jsonString);
  }

  // Retrieve a list of Ballbert objects from shared preferences.
  static Future<List<Ballbert>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final jsonData = jsonDecode(jsonString) as List<dynamic>;
      final ballbertList = jsonData
          .map((json) => Ballbert.fromJson(json as Map<String, dynamic>))
          .toList();
      return ballbertList;
    } else {
      return [];
    }
  }

  // Add a Ballbert object to the list with an auto-incremented id and update storage.
  static Future<void> addBallbert(Ballbert ballbert) async {
    final ballbertList = await load();

    ballbert.id = Uuid().v4();
    ballbertList.add(ballbert);
    await save(ballbertList);
  }

  // Remove a Ballbert object from the list and update storage.
  static Future<void> removeBallbert(Ballbert ballbert) async {
    final ballbertList = await load();
    print(ballbert.id);
    print(ballbertList);
    ballbertList.removeWhere((b) => b.id == ballbert.id);
    await save(ballbertList);
  }
}
