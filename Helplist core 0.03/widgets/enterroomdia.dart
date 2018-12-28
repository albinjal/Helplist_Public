import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helplist3/assets.dart';
import 'package:helplist3/screens/room.dart';

enterDiaRoom(DocumentSnapshot snapshot, context, phoneid) {
  Map data = snapshot.data;
  Map currentusers = data['users'];
  var namecon = TextEditingController();
  // var passcon = TextEditingController();

  List roomnames = [];
  for (Map currentuser in data['users'].values) {
    roomnames.add(currentuser['username']);
  }

  return SimpleDialog(
    children: <Widget>[
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              data['name'],
              textScaleFactor: 2,
            ),
            ListTile(
                leading: const Icon(Icons.person),
                title: new TextFormField(
                  onEditingComplete: () {
                    if (roomnames.contains(namecon.text) ||
                        namecon.text == '') {
                      print('name taken');
                    } else {
                      User user = User(namecon.text, false, phoneid);
                      currentusers.addAll({user.createdby: user.mapversion});
                      Firestore.instance
                          .collection('Rooms')
                          .document(data['id'])
                          .updateData({
                        'users': currentusers,
                        'userphones': FieldValue.arrayUnion([phoneid])
                      });

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Roomview(data['id'], phoneid),
                        ),
                      );
                    }
                  },
                  maxLength: 12,
                  maxLengthEnforced: true,
                  controller: namecon,
                  decoration: new InputDecoration(
                    hintText: "Username",
                  ),
                  validator: (text) {
                    if (roomnames.contains(text)) {
                      return 'Name is already taken';
                    }
                  },
                  autovalidate: true,
                )),
            RaisedButton(
              color: Colors.pink,
              padding: EdgeInsets.all(10),
              onPressed: () {
                if (roomnames.contains(namecon.text) || namecon.text == '') {
                  print('name taken');
                } else {
                  User user = User(namecon.text, false, phoneid);
                  currentusers.addAll({user.createdby: user.mapversion});
                  Firestore.instance
                      .collection('Rooms')
                      .document(data['id'])
                      .updateData({
                    'users': currentusers,
                    'userphones': FieldValue.arrayUnion([phoneid])
                  });

                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Roomview(data['id'], phoneid),
                    ),
                  );
                }
              },
              child: Row(
                children: <Widget>[Text('Join'), Icon(Icons.arrow_forward)],
                mainAxisSize: MainAxisSize.min,
              ),
              disabledColor: Colors.grey,
            )
          ],
        ),
      )
    ],
  );
}
