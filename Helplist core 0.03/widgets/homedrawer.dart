import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helplist3/assets.dart';
import 'package:helplist3/screens/room.dart';

class HomeDrawer extends StatefulWidget {
  List<DocumentSnapshot> rooms = [];
  String phoneid;
  bool norooms = false;
  bool updating = false;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();

  HomeDrawer();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    getPhoneID().then((id) {
      Firestore.instance
          .collection('Rooms')
          .where('userphones', arrayContains: id)
          .getDocuments()
          .then((QuerySnapshot querysnaps) {
        List<DocumentSnapshot> snapshots = querysnaps.documents;
        if (snapshots.isEmpty) {
          setState(() {
            widget.phoneid = id;
            widget.norooms = true;
          });
        } else {
          setState(() {
            widget.rooms = snapshots;
            widget.phoneid = id;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> currentrooms = widget.rooms;
    List<Widget> roomtiles = [
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Title(
                color: Colors.black,
                child: Text(
                  'Your Lists:',
                  textScaleFactor: 1.7,
                  textAlign: TextAlign.left,
                )),
            Builder(builder: (context) {
              if (widget.updating) {
                return RaisedButton(
                  onPressed: null,
                  child: Icon(Icons.refresh),
                  shape: CircleBorder(),
                );
              } else {
                return RaisedButton(
                  shape: CircleBorder(),
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      widget.updating = true;
                    });
                    Firestore.instance
                        .collection('Rooms')
                        .where('userphones', arrayContains: widget.phoneid)
                        .getDocuments()
                        .then((QuerySnapshot querysnaps) {
                      List<DocumentSnapshot> snapshots = querysnaps.documents;
                      if (snapshots.isEmpty) {
                        setState(() {
                          widget.norooms = true;
                          widget.phoneid = widget.phoneid;
                        });
                      } else {
                        setState(() {
                          widget.rooms = snapshots;
                          widget.phoneid = widget.phoneid;
                        });
                      }
                      setState(() {
                        widget.updating = false;
                      });
                    });
                  },
                  color: Colors.pink,
                );
              }
            })
          ],
        ),
        padding: EdgeInsets.fromLTRB(5, 30, 0, 5),
      )
    ];
    for (DocumentSnapshot room in currentrooms) {
      roomtiles.add(GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Roomview(room['id'], widget.phoneid),
              ),
            );
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(room['name']),
                    width: 130,
                  ),
                  Text(room['id']),
                  Icon(
                    Icons.arrow_forward,
                    size: 30,
                  ),
                ],
              ),
            ),
          )));
    }
    if (widget.norooms) {
      roomtiles.add(Text('You are not in any rooms'));
    }
    if (widget.phoneid == null || widget.updating) {
      return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Title(
                      color: Colors.black,
                      child: Text(
                        'Your Lists:',
                        textScaleFactor: 1.7,
                        textAlign: TextAlign.left,
                      )),
                  RaisedButton(
                    shape: CircleBorder(),
                    onPressed: null,
                    child: Icon(Icons.refresh),
                  )
                ],
              ),
              padding: EdgeInsets.fromLTRB(5, 30, 0, 5),
            ),
            Icon(Icons.sync)
          ],
        ),
      );
    }

    return Drawer(
      child: Column(
        children: roomtiles,
      ),
    );
  }
}
