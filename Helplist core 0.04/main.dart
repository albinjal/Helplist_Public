import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

void main() async {
  final Firestore firestore = Firestore();
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: routes,
      title: 'Helplist',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
    );
  }
}
