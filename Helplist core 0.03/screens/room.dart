import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helplist3/assets.dart';
import 'package:helplist3/widgets/info.dart';

class Roomview extends StatelessWidget {
  String roomid;
  String phone;
  DocumentReference document;

  Roomview(String id, String phone) {
    this.roomid = id;
    this.phone = phone;
    this.document = Firestore.instance.collection('Rooms').document(id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: this.document.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }
              break;
            case ConnectionState.waiting:
              return Scaffold(
                appBar: AppBar(
                  title: Text(''),
                ),
              );
            case ConnectionState.active:
              {
                if (!snapshot.data.exists) {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(''),
                    ),
                  );
                } else {
                  Map roomdata = snapshot.data.data;

                  Map currentUser = roomdata['users'][this.phone];
                  if (currentUser == null) {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }
                  List currentqueue = List.from(roomdata['queue']);

                  List<Widget> queuecards = [];
                  int index = 1;
                  for (String user in currentqueue) {
                    Map userinqueue = roomdata['users'][user];
                    if (index == 1) {
                      Widget firstcard = Card(
                        color: Colors.white,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 18, horizontal: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  index.toString(),
                                  textScaleFactor: 2,
                                ),
                                width: 40,
                              ),
                              Text(
                                capitalize(userinqueue['username']),
                                textScaleFactor: 2,
                              ),
                              Builder(builder: (context) {
                                if (currentUser['op'] ||
                                    roomdata['queue'].first ==
                                        currentUser['ownedby']) {
                                  return IconButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      alignment: Alignment(0, 0),
                                      color: Colors.green,
                                      icon: Icon(
                                        Icons.check,
                                        size: 60,
                                      ),
                                      onPressed: () {
                                        currentqueue.removeAt(
                                            currentqueue.indexWhere((e) {
                                          return e == user;
                                        }, 0));
                                        roomdata.update('queue', (c) {
                                          return currentqueue;
                                        });
                                        document.updateData(roomdata);
                                      });
                                } else {
                                  return Text('');
                                }
                              })
                            ],
                          ),
                        ),
                      );
                      queuecards.add(firstcard);
                    } else {
                      Widget queuecard = Card(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  index.toString(),
                                  textScaleFactor: 2,
                                ),
                                width: 40,
                              ),
                              Text(
                                capitalize(userinqueue['username']),
                                textScaleFactor: 2,
                              ),
                              Builder(builder: (context) {
                                print(index.toString());
                                if (currentUser['op'] ||
                                    user == currentUser['ownedby']) {
                                  return IconButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      iconSize: 35,
                                      alignment: AlignmentDirectional(0, 0),
                                      color: Colors.pink,
                                      icon: Icon(
                                        Icons.backspace,
                                        size: 45,
                                      ),
                                      onPressed: () {
                                        currentqueue.removeAt(
                                            currentqueue.indexWhere((e) {
                                          return e == user;
                                        }, 0));
                                        roomdata.update('queue', (c) {
                                          return currentqueue;
                                        });
                                        document.updateData(roomdata);
                                      });
                                } else
                                  return Text('');
                              })
                            ],
                          ),
                        ),
                      );

                      queuecards.add(queuecard);
                    }
                    index = index + 1;
                  }

                  if (true) {
                    return Scaffold(
                        endDrawer: InfoScreen(snapshot, this.phone),
                        floatingActionButton: FloatingActionButton.extended(
                            icon: Icon(Icons.add),
                            label: (Text('Queue Me')),
                            onPressed: () {
                              addUserToQueue(roomdata, this.phone);
                            }),
                        appBar: AppBar(
                            actions: <Widget>[],
                            title: Row(
                              children: <Widget>[
                                Text(roomdata['name']),
                                Text('ID: ' + roomdata['id'])
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )),
                        body: Center(
                          child: ListView(
                            children: queuecards,
                          ),
                        ));
                  }
                }
              }
              break;
            case ConnectionState.done:
              return Text('\$${snapshot.data} (closed)');
          }
        });
  }
}
