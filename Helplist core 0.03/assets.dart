import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helplist3/screens/room.dart';
import 'package:helplist3/widgets/enterroomdia.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String username;
  bool op;
  FieldValue created;
  Map mapversion;
  String createdby;

  User(String username, bool op, String creator) {
    this.username = username;
    this.op = op;
    this.created = FieldValue.serverTimestamp();
    this.createdby = creator;

    this.mapversion = makeMap();
  }

  Map makeMap() {
    return {
      "username": this.username,
      "op": this.op,
      "created": this.created,
      'ownedby': this.createdby,
      // 'queue': {}
    };
  }
}

class Room {
  String id;
  String name;
  String pass;
  bool passreq;
  Map roomusers;
  bool online;
  List queue;
  DocumentReference firebaseref;
  List<String> userphones;

  Room(String name, bool passreq, String pass) {
    this.name = name;
    this.id = randomID();
    this.passreq = passreq;
    this.pass = pass;
    this.roomusers = Map();

    this.online = true;
    this.firebaseref = Firestore.instance.collection('Rooms').document(this.id);
  }

  void pushRoomToFirebase() {
    this.firebaseref.setData({
      'id': this.id,
      'created': FieldValue.serverTimestamp(),
      'name': this.name,
      'passreq': this.passreq,
      'password': this.pass,
      'users': this.roomusers,
      'queue': [],
      'online': this.online,
      'bannedusers': [],
      'userphones': this.userphones,
      'latestchange': FieldValue.serverTimestamp(),
    });
  }
}

String randomID() {
  var rng = Random();
  String id = (rng.nextInt(899999) + 100000).toString();
  Firestore.instance.collection('Rooms').document(id).get().then((snapshot) {
    print('read');
    if (snapshot.exists) {
      id = randomID();
    }
  });

  return id;
}

Future<String> getPhoneID() {
  return SharedPreferences.getInstance().then((prefs) {
    String phoneID = prefs.getString('phoneid');
    if (phoneID == null) {
      DocumentReference document =
          Firestore.instance.collection('Phones').document();
      phoneID = document.documentID;
      document.setData(
          {'PhoneID': phoneID, 'Joined': FieldValue.serverTimestamp()});
      prefs.setString('phoneid', phoneID);
    }
    return phoneID;
  }, onError: () {
    print('error');
  });
}

Future<String> enterRoom(String id, String phone, BuildContext context) async {
  String text;
  if (id == '') {
    text = 'Please enter a List ID';
  } else {
    await Firestore.instance
        .collection('Rooms')
        .document(id)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data['users'][phone] == null) {
          if (snapshot.data['bannedusers'].contains(phone)) {
            text = 'You are banned from this list';
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return enterDiaRoom(snapshot, context, phone);
                });
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Roomview(id, phone),
            ),
          );
        }
      }
      if (!snapshot.exists) {
        text = 'Cant find list with this ID';
      }
    });
  }
  return text;
}

void deleteRoom(Map snapshotdata) {
  Firestore.instance.collection('Rooms').document(snapshotdata['id']).delete();
}

void addUserToQueue(Map roomdata, String phone) {
  List currentqueue = List.from(roomdata['queue']);
  DocumentReference document =
      Firestore.instance.collection('Rooms').document(roomdata['id']);

  if (!currentqueue.contains(phone)) {
    currentqueue.add(phone);
    roomdata.update('queue', (c) {
      return currentqueue;
    });

    document.updateData(roomdata);
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

void banUser(Map snapshotdata, String phoneID) {
  DocumentReference documentref =
      Firestore.instance.collection('Rooms').document(snapshotdata['id']);
  List newbannedusers = List.from(snapshotdata['bannedusers']);
  newbannedusers.add(phoneID);
  Map newusers = Map.from(snapshotdata['users']);
  newusers.remove(phoneID);
  List newqueue = List.from(snapshotdata['queue']);
  newqueue.remove(phoneID);

  documentref.updateData({
    'users': newusers,
    'bannedusers': newbannedusers,
    'queue': FieldValue.arrayRemove([phoneID]),
    'userphones': FieldValue.arrayRemove([phoneID])
  });
}

void leaveList(Map snapshotdata, String phoneID) {
  DocumentReference documentref =
      Firestore.instance.collection('Rooms').document(snapshotdata['id']);
  Map newusers = Map.from(snapshotdata['users']);
  newusers.remove(phoneID);
  List newqueue = List.from(snapshotdata['queue']);
  newqueue.remove(phoneID);
  documentref.updateData({
    'users': newusers,
    'queue': FieldValue.arrayRemove([phoneID]),
    'userphones': FieldValue.arrayRemove([phoneID])
  });
}
