import 'package:flutter/material.dart';

Scaffold circularProgress() {
  return Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("App Name\n&\nLogo\n",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 33, fontFamily: "Poppins-Regular")),
          Text("Please wait...\n",
              style: TextStyle(fontSize: 22, fontFamily: "Poppins-Regular")),
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 10.0),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Colors.black),
              )),
        ],
      )));
}