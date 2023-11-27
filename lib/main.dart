import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class UserData {
  int id;
  String name;
  String email;
  String mobile;
  String gender;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'gender': gender,
    };
  }
}

class DatabaseHelper {
  static late Database _database;

  DatabaseHelper._();

  static Future<Database> get database async {
    return _database;
  }

  static Future<void> insertUserData(UserData userData) async {
    final db = await database;
    await db.insert('UserData', userData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<UserData>> getAllUserData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('UserData');

    return List.generate(maps.length, (i) {
      return UserData(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        mobile: maps[i]['mobile'],
        gender: maps[i]['gender'],
      );
    } );
  }
}
class ConflictAlgorithm {
  static var replace;
}

class MyDatabase {
  query(String s) {}

  insert(String s, Map<String, dynamic> map, {required conflictAlgorithm}) {}

  execute(String s) {}
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  get http => null;

  @override
  void initState() {
    super.initState();
    fetchDataAndStoreLocally();
  }

  Future<void> fetchDataAndStoreLocally() async {
    // Save data to CRUD API (Replace with your actual API URL)
    String apiUrl = 'https://crudcrud.com/api/6a65940e1d0d4cb2b0652c545ec6972f';
    Map<String, String> data = {
      'name': 'Thambidurai',
      'email': 'Thambidurai@Apple.com',
      'mobile': '8110099200',
      'gender': 'Male',
    };

    var response = await http.post(Uri.parse(apiUrl), body: json.encode(data));
    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('Data saved successfully');
      }
    } else {
      if (kDebugMode) {
        print('Failed to save data. Status code: ${response.statusCode}');
      }
    }

    // List data using GET method
    response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> dataJson = json.decode(response.body);
      List<UserData> userDataList =
          dataJson.map((json) => UserData.fromJson(json)).toList();

      // Store API data locally
      for (var userData in userDataList) {
        await DatabaseHelper.insertUserData(userData);
      }

      // Print local data
      List<UserData> localData = await DatabaseHelper.getAllUserData();
      if (kDebugMode) {
        print('Local Data:');
      }
      for (var userData in localData) {
        if (kDebugMode) {
          print(userData.toMap());
        }
      }
    } else {
      print('Failed to retrieve data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('I completed the task successfully'),
      ), body: const Center(child: Text('Pls check the console for output'),

    ),
    );
  }
}
