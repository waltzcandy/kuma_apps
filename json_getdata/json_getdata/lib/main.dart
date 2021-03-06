import 'package:flutter/material.dart';
import 'package:navigation/shared/styles.dart';

import 'dart:async';
import 'dart:convert';
import 'package:navigation/models/Profile.dart';
import 'package:navigation/models/Product.dart';
import 'package:http/http.dart' as http;

void main() {
  // runApp(HomeScreen());
  runApp(MaterialApp(
    title: 'Testing Page Navigation',
    initialRoute: '/2',
    routes: {'/': (context) => MyApp(), '/2': (context) => MyApp2()},
    debugShowCheckedModeBanner: false,
  ));
}

Future<Profile> fetchProfile() async {
  //ganti dengan ip server masing2
  final response = await http.get('http://192.168.2.101:4002/api/users/1');

  return Profile.fromJson(jsonDecode(response.body));
}

Future<List<Product>> fetchProduct() async {
  //ganti dengan ip server masing2
  final response = await http.get('http://192.168.2.101:4002/api/product');
  final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Profile> myProfile;

  @override
  void initState() {
    super.initState();
    myProfile = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sample Load Data')),
      body: Center(
        child: FutureBuilder<Profile>(
            future: myProfile,
            builder: (context, snapshot) {
              print(snapshot.hasData);
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(snapshot.data.name),
                    Text(snapshot.data.email)
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("Failed");
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}

class MyApp2 extends StatefulWidget {
  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  Future<List<Product>> myProducts;

  @override
  void initState() {
    super.initState();
    this.myProducts = fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sample Load Data')),
      body: Center(
        child: FutureBuilder<List<Product>>(
            future: myProducts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    Product current = snapshot.data[index];
                    return Column(
                      children: [
                        Text(current.id.toString()),
                        Text(current.name)
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
