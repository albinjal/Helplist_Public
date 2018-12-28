import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helplist3/assets.dart';

editDialog(Map snapshotdata, String phoneid, context) {
  var _namefield = TextEditingController(text: snapshotdata['name']);
  // var _opnamefield = TextEditingController();
  // var _passfield = TextEditingController();
  return SimpleDialog(
    children: <Widget>[
      Column(
        children: <Widget>[
          Container(
            child: Text(
              'Edit List',
              textScaleFactor: 1.6,
            ),
          ),
          ListTile(
            leading: Text('Listname:'),
            title: TextField(
              controller: _namefield,
            ),
          ),
          Divider(),
          RaisedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Membersdialog(snapshotdata);
                  });
            },
            child: Text('Manage Members'),
          ),
          Divider(),
          RaisedButton(
            onPressed: () {
              Firestore.instance
                  .collection('Rooms')
                  .document(snapshotdata['id'])
                  .updateData({'name': _namefield.text});
            },
            child: Text('Save Changes'),
            color: Colors.blue,
          ),
          Divider(),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Yes'),
                  value: true,
                ),
                PopupMenuItem(child: Text('No'), value: false)
              ];
            },
            tooltip: 'Are you sure you want to delte this list',
            child: RaisedButton(
              onPressed: null,
              child: Text(
                'Delete List',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              disabledColor: Colors.red,
            ),
            onSelected: (bool value) {
              if (value) {
                Navigator.popUntil(context, ModalRoute.withName('/'));
                deleteRoom(snapshotdata);
              }
            },
          ),
        ],
      )
    ],
  );
}

class Membersdialog extends StatefulWidget {
  Map snapshotdata;

  Membersdialog(this.snapshotdata);

  @override
  _Memberdialogstate createState() => _Memberdialogstate();
}

class _Memberdialogstate extends State<Membersdialog> {
  @override
  Widget build(context) {
    List<Widget> _memberlist = [
      Container(
        child: Text('List Members:'),
      )
    ];
    for (Map user in widget.snapshotdata['users'].values) {
      if (!user['op']) {
        _memberlist.add(Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(user['username']),
              RaisedButton(
                onPressed: () {
                  banUser(widget.snapshotdata, user['ownedby']);
                  Map newusers = Map.from(widget.snapshotdata['users']);
                  newusers.remove(user['ownedby']);
                  setState(() {
                    widget.snapshotdata['users'] = newusers;
                  });
                },
                child: Text('Ban'),
                color: Colors.red,
              )
            ],
          ),
        ));
      }
    }

    return SimpleDialog(
      children: <Widget>[
        Column(
          children: _memberlist,
        )
      ],
    );
  }
}
