import 'package:flutter/material.dart';
import 'package:helplist3/assets.dart';

import 'editdialog.dart';

class InfoScreen extends StatelessWidget {
  AsyncSnapshot snapshot;
  String phone;

  InfoScreen(this.snapshot, this.phone);

  @override
  Widget build(BuildContext context) {
    Map snapshotdata = this.snapshot.data.data;
    double factor = 1.1;

    List<Widget> Colcontent = [
      Divider(),
      ListTile(
        leading: Icon(Icons.assignment),
        title: Text(
          'Listname: ' + snapshotdata['name'],
          textScaleFactor: factor,
        ),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.attach_file),
        title: Text(
          'ID: ' + snapshotdata['id'],
          textScaleFactor: factor,
        ),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text(
          'Created: ' +
              snapshotdata['created'].toLocal().year.toString() +
              '-' +
              snapshotdata['created'].toLocal().month.toString() +
              '-' +
              snapshotdata['created'].toLocal().day.toString(),
        ),
        subtitle: Text(snapshotdata['created'].toLocal().hour.toString() +
            ':' +
            snapshotdata['created'].toLocal().minute.toString() +
            ':' +
            snapshotdata['created'].toLocal().second.toString()),
      ),
      // Divider(),
      // ListTile(
      //   leading: Icon(Icons.lock),
      //   title: Text('Password Required: ' + snapshotdata['passreq'].toString()),
      // ),
      Divider(),
      Text(
        'Users:',
        textScaleFactor: factor,
      )
    ];
    if (snapshotdata['users'][this.phone]['op']) {
      Colcontent.insert(
          0,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Info',
                  textScaleFactor: 2,
                ),
                RaisedButton(
                  color: Colors.pink,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return editDialog(snapshotdata, this.phone, context);
                        });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
            padding: EdgeInsets.fromLTRB(5, 25, 5, 5),
          ));
    } else {
      Colcontent.insert(
          0,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Info',
                  textScaleFactor: 2,
                ),
                RaisedButton(
                  color: Colors.pink,
                  onPressed: () {
                    Navigator.pop(context);
                    leaveList(snapshotdata, phone);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text(
                        'Leave List',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(5, 25, 5, 5),
          ));
    }

    for (Map user in snapshotdata['users'].values) {
      Colcontent.add(Card(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Builder(builder: (context) {
                if (user['op']) {
                  return Icon(Icons.assignment_ind);
                } else {
                  if (user['ownedby'] == phone) {
                    return Icon(Icons.account_circle);
                  } else {
                    return Icon(Icons.person);
                  }
                }
              }),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                width: 150,
                child: Text(
                  user['username'],
                  textScaleFactor: factor,
                ),
              ),
              Column(
                children: <Widget>[
                  // Text(
                  //   'Admin: ' + user['op'].toString(),
                  //   textScaleFactor: 0.8,
                  // ),
                  Text(
                    'Joined: ' +
                        user['created'].day.toString() +
                        '/' +
                        user['created'].month.toString(),
                    textScaleFactor: 0.8,
                  )
                ],
              )
            ],
          ),
        ),
      ));
    }

// PopupMenuButton(itemBuilder: (context) {return [CheckedPopupMenuItem(child: Text('xd'),)];}, icon: Icon(Icons.),));
    return Drawer(
      child: Column(
        children: Colcontent,
      ),
    );
  }
}
