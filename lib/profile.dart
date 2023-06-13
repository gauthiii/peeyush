import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peeyush/loader.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:peeyush/home.dart';
import 'package:peeyush/sett.dart';

class Profile extends StatefulWidget {
  @override
  Profiles createState() => Profiles();
}

class Profiles extends State<Profile> {
  bool isEdit = false;
  List<TextEditingController> con = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  @override
  void initState() {
    super.initState();
    //x();
  }

  x() {
    setState(() {
      con[0].text = "";
      con[1].text = currentUser.name;
      con[2].text = currentUser.email;
      con[3].text = currentUser.mobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Padding(
            padding: EdgeInsets.all(12),
            child: ListView(
              children: [
                DrawerHeader(
                    margin: EdgeInsets.only(bottom: 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[500],
                              child: Text("${currentUser.name[0]}",
                                  style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: "Poppins-Regular")),
                            ),
                          ),
                        ])),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Table(
                        border: TableBorder.symmetric(
                          inside: BorderSide(width: 2),
                        ),
                        children: [
                          TableRow(children: [
                            (isEdit)
                                ? Container(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: TextFormField(
                                      onFieldSubmitted: (val) {},
                                      autofocus: true,
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 20),
                                      controller: con[0],
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                        ),
                                        hintText: "Name of the Firm",
                                        hintStyle: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: 18),
                                      ),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEdit = true;
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text("Name of the Firm",
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))),
                          ]),
                          TableRow(children: [
                            (isEdit)
                                ? Container(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: TextFormField(
                                      onFieldSubmitted: (val) {},
                                      autofocus: true,
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 20),
                                      controller: con[1],
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                        ),
                                        hintText: "Your Name",
                                        hintStyle: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: 18),
                                      ),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEdit = true;
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(currentUser.name,
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))),
                          ]),
                          TableRow(children: [
                            (isEdit)
                                ? Container(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: TextFormField(
                                      onFieldSubmitted: (val) {},
                                      autofocus: true,
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 20),
                                      controller: con[2],
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                        ),
                                        hintText: "Mobile Number",
                                        hintStyle: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: 18),
                                      ),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEdit = true;
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(currentUser.mobile,
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))),
                          ]),
                          TableRow(children: [
                            (isEdit)
                                ? Container(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: TextFormField(
                                      onFieldSubmitted: (val) {},
                                      autofocus: true,
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 20),
                                      controller: con[3],
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 0),
                                        ),
                                        hintText: "Email ID",
                                        hintStyle: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: 18),
                                      ),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isEdit = true;
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(currentUser.email,
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))),
                          ]),
                        ])),
                Container(
                    padding: EdgeInsets.only(right: 12, top: 30, bottom: 20),
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      child: Container(
                          height: 50,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Save Changes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: "Poppins-Regular"),
                                ),
                              ])),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.blue[700],
                      onPressed: () {
                        setState(() {
                          isEdit = false;
                        });
                      },
                    ))
              ],
            )),
        Padding(
            padding: EdgeInsets.only(top: 30),
            child: Row(children: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset('images/Arrow.png', width: 18, height: 20),
                minWidth: 20,
              ),
            ])),
        Padding(
            padding: EdgeInsets.only(top: 40),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.only(left: 150),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        isEdit = true;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.black),
                        Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text("Edit",
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    fontSize: 15,
                                    color: Colors.black)))
                      ],
                    ),
                  ))
            ]))
      ],
    ));
  }
}
