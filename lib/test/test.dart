import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sociachatv2/database/databaseConfig.dart';
import 'package:sociachatv2/models/users/userConfig.dart';
import 'package:http/http.dart' as http;
class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  TextEditingController usernameController =TextEditingController();
  var db =  DatabaseConfig();
  GlobalKey formKey = GlobalKey();
  var name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Form(
            key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder()
                    ),
                  ),
                  // ElevatedButton(onPressed: ()=>UserConfig().addUser(usernameController.text), child: Text('Click')),
                  ElevatedButton(onPressed: () {
                    generateEmployeeList();
                  }, child: Text('Click')),
                  Text("$name"),
                ],
              ))
        ],
      ),
    );
  }
  Future<void> _getUser() async {

      final connection =await db.getConnection();
      final results = await connection.query('SELECT * FROM users');
      for (var row in results) {
        print('User ID: ${row[0]}, Username: ${row[1]}');
      } 

      await connection.close();

  }
  Future<dynamic> generateEmployeeList() async {
    var url = 'http://localhost/databaseConfig.php';
    final response = await http.get(Uri.parse(url));
    return response;
  }
}
