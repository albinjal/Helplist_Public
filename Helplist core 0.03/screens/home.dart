import 'package:flutter/material.dart';
import 'package:helplist3/assets.dart';
import 'package:helplist3/widgets/appinfo.dart';
import 'package:helplist3/widgets/homedrawer.dart';

import 'createlist.dart';

class MyHomePage extends StatelessWidget {
  String phoneid;

  MyHomePage() {
    getPhoneID().then((id) {
      this.phoneid = id;
    });
  }

  final roomID = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (CreateRoom(this.phoneid)),
              ),
            );
          },
          icon: Icon(Icons.add),
          label: Text('Create New List')),
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return infoDialog();
                      });
                })
          ],
          centerTitle: true,
          title: Text(
            'Helplist',
            textScaleFactor: 1.5,
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter Helplist ID',
              textScaleFactor: 2.0,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Builder(builder: (context) {
                      return TextFormField(
                        controller: roomID,
                        onEditingComplete: () {
                          enterRoom(
                                  roomID.text.toString(), this.phoneid, context)
                              .then((text) {
                            if (text == null) {
                            } else {
                              Scaffold.of(context)
                                  .showSnackBar(SnackBar(content: Text(text)));
                            }
                          });
                        },
                        autofocus: false,
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        autocorrect: false,
                        maxLength: 6,
                        maxLengthEnforced: true,
                        enabled: true,
                      );
                    }),
                    Builder(builder: (context) {
                      return RaisedButton(
                        color: Colors.pink,
                        onPressed: () {
                          enterRoom(
                                  roomID.text.toString(), this.phoneid, context)
                              .then((text) {
                            if (text == null) {
                            } else {
                              Scaffold.of(context)
                                  .showSnackBar(SnackBar(content: Text(text)));
                            }
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Done',
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 1.4,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
                            )
                          ],
                        ),
                      );
                    })
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
