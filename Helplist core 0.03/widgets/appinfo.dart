import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

infoDialog() {
  return SimpleDialog(
    children: <Widget>[
      Column(
        children: <Widget>[
          Container(
            child: Text(
              'Helplist',
              textScaleFactor: 2,
            ),
          ),
          Container(
            child: Text(
                'Helplist was created to simplify the process of queueing for help.'
                '\nTo use the app, join a list by entering the list ID or, if you want to offer help, create a list and invite others.'),
            padding: EdgeInsets.all(10),
          ),
          Container(
            child: Text(
              'Support the App!',
              textScaleFactor: 1.3,
            ),
          ),
          Container(
            child: Text(
                'If you enjoy the app and want to support it there are several diffrent ways:\n \n'
                '1. Spread it to others who might be interested.\n'
                    '2. Give it a good rating on the App or Playstore.\n'
                    '3. Donate to help cover app costs.'
            ),
            padding: EdgeInsets.all(10),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: _launchURL,
                child: Text('Donate', style: TextStyle(color: Colors.black),),
                color: Colors.blue,
              ),
            ],
          )
        ],
      )
    ],
  );
}

_launchURL() async {
  const url = 'https://www.paypal.me/AlbinJ/50';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
