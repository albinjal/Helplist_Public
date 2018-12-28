import 'package:flutter/material.dart';
import 'package:helplist3/assets.dart';

import 'room.dart';

//initiating vars
final textStyle = TextStyle(fontSize: 20.0, color: Colors.black);
var passreq = false;

var _namefield = TextEditingController();
var _opnamefield = TextEditingController();
var _passfield = TextEditingController();

class CreateRoom extends StatefulWidget {
  String phoneid;

  CreateRoom(this.phoneid);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("New Helplist"),
        ),
        body: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 2.0, 2.0, 20.0),
            alignment: Alignment.topLeft,
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Divider(),
                  ListTile(
                    leading: Icon(Icons.assignment),
                    title: TextFormField(
                      maxLength: 12,
                      maxLengthEnforced: true,
                      controller: _namefield,
                      decoration: InputDecoration(
                        hintText: "Helplist Name",
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: TextFormField(
                      maxLength: 12,
                      maxLengthEnforced: true,
                      controller: _opnamefield,
                      decoration: InputDecoration(
                        hintText: "You name",
                      ),
                    ),
                  ),
                  // password support
                  // Divider(),
                  //   Container(
                  //    margin: EdgeInsets.symmetric(horizontal: 10),
                  //    child: Text(
                  //      "Password required?",
                  //      textAlign: TextAlign.left,
                  //      style: textStyle,
                  //    ),
                  //  ),
                  //    ListTile(
                  //     contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                  //     leading:  Switch(
                  //       value: passreq,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           passreq = value;
                  //         });
                  //       },
                  //     ),
                  //     title:  TextField(
                  //       controller: _passfield,
                  //       enabled: passreq,
                  //       decoration:  InputDecoration(
                  //         hintText: "Password",
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
          Divider(),
          RaisedButton(
            onPressed: () {
              if (_namefield.text == '' || _opnamefield.text == '') {
              } else {
                var creator = User(_opnamefield.text, true, widget.phoneid);
                var _room = Room(_namefield.text, passreq, _passfield.text);
                _room.roomusers = {creator.createdby: creator.mapversion};
                _room.userphones = [widget.phoneid];
                _room.pushRoomToFirebase();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (Roomview(_room.id, widget.phoneid)),
                  ),
                );
              }
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Icon(
                Icons.add,
                size: 55.0,
                color: Colors.white,
              ),
              Text(
                'Create List',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
            ]),
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 30.0, 5.0),
            color: Colors.pink,
            elevation: 11.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
          ),
        ]));
  }
}
