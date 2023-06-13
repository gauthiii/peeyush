import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peeyush/loader.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:peeyush/home.dart';
import 'package:peeyush/sett.dart';

class Settings extends StatefulWidget {
  @override
  Settingss createState() => Settingss();
}

class Settingss extends State<Settings> {
  String cat = "no";
  bool isTable = true;
  TextEditingController addController = TextEditingController();
  bool isLoading = false;
  Sett sett;

  @override
  void initState() {
    super.initState();

if(datazx.size.shortestSide<600)
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    getS();
  }

  getS() async {
    setState(() {
      isLoading = true;
    });

    DocumentSnapshot doc = await setRef.document(currentUser.email).get();

    if (doc.exists) {
      setState(() {
        sett = Sett.fromDocument(doc);
      });
    }
    setState(() {
      isLoading = false;
      print(sett.acc);
    });
  }

  alert(x) {
    var y = x.toString();

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(0, 20.0, 0, 20),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              backgroundColor: _getColorFromHex("#F2F2F2"),
              title: new Container(
                  child: Text(
                      "Are you sure you want to delete " +
                          tit().substring(4, tit().length) +
                          " : $y?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins-Bold",
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
              actions: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1, color: Colors.grey[400]),
                                  right: BorderSide(
                                      width: 0.5, color: Colors.grey[400]),
                                ),
                              ),
                              child: FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No",
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontFamily: "Poppins-Regular"))))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1, color: Colors.grey[400]),
                                  left: BorderSide(
                                      width: 0.5, color: Colors.grey[400]),
                                ),
                              ),
                              child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      if (cat == "cat") {
                                        sett.cat.remove(x);
                                      }

                                      if (cat == "acc") {
                                        sett.acc.remove(x);
                                      }

                                      if (cat == "supp") {
                                        sett.supp.remove(x);
                                      }

                                      setRef
                                          .document(currentUser.email)
                                          .updateData({
                                        "acc": sett.acc,
                                        "supp": sett.supp,
                                        "cat": sett.cat,
                                      });

                                      getS();
                                      isTable = true;

                                      if (cat == "cat") {
                                        if (sett.cat.isEmpty) isTable = false;
                                      }

                                      if (cat == "acc") {
                                        if (sett.acc.isEmpty) isTable = false;
                                      }

                                      if (cat == "supp") {
                                        if (sett.supp.isEmpty) isTable = false;
                                      }
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: Text("Yes",
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontFamily: "Poppins-Bold"))))),
                    ]))
              ],
            ));
  }

  tables() {
    if (cat == "no")
      return Table(
          border: TableBorder.symmetric(
            inside: BorderSide(width: 2),
          ),
          children: [
            TableRow(children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      cat = "cat";
                      if (sett.cat.isEmpty) isTable = false;
                    });
                    getS();
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Categories",
                          style: TextStyle(
                              fontFamily: "Poppins-Regular",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)))),
            ]),
            TableRow(children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      cat = "acc";
                      if (sett.acc.isEmpty) isTable = false;
                    });
                    getS();
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Accounts",
                          style: TextStyle(
                              fontFamily: "Poppins-Regular",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)))),
            ]),
            TableRow(children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      cat = "supp";
                      if (sett.supp.isEmpty) isTable = false;
                    });
                    getS();
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Supplier Name",
                          style: TextStyle(
                              fontFamily: "Poppins-Regular",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)))),
            ]),
          ]);
    else if (cat == "cat") {
      return Table(
          border: TableBorder.symmetric(
            inside: BorderSide(width: 2),
          ),
          children: [
            for (var i = 0; i < sett.cat.length; i++)
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                        onTap: () {
                          alert(sett.cat[i]);
                        },
                        leading: Text(sett.cat[i],
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25)))),
              ]),
          ]);
    } else if (cat == "acc") {
      return Table(
          border: TableBorder.symmetric(
            inside: BorderSide(width: 2),
          ),
          children: [
            for (var i = 0; i < sett.acc.length; i++)
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                        onTap: () {
                          alert(sett.acc[i]);
                        },
                        leading: Text(sett.acc[i],
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25)))),
              ]),
          ]);
    } else if (cat == "supp") {
      return Table(
          border: TableBorder.symmetric(
            inside: BorderSide(width: 2),
          ),
          children: [
            for (var i = 0; i < sett.supp.length; i++)
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                        onTap: () {
                          alert(sett.supp[i]);
                        },
                        leading: Text(sett.supp[i],
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25)))),
              ]),
          ]);
    }
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        child: (isLoading)
            ? circularProgress()
            : Scaffold(
                appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: Icon(Icons.menu,
                          size: 40,
                          color: Colors.black), // change this size and style
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                    actions: [
                      (cat == "no")
                          ? Container(height: 0, width: 0)
                          : GestureDetector(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  child: Image.asset('images/Blue.png',
                                      height: 35)),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              0, 20.0, 0, 20),
                                          actionsPadding: EdgeInsets.zero,
                                          buttonPadding: EdgeInsets.zero,
                                          backgroundColor:
                                              _getColorFromHex("#F2F2F2"),
                                          title: new Container(
                                              child: Text(tit(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          "Poppins-Bold",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                          content: Container(
                                              height: 30,
                                              padding: EdgeInsets.only(
                                                  left: 28, right: 28),
                                              child: TextFormField(
                                                  controller: addController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(3.0),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: tit().substring(
                                                        4, tit().length),
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            "Poppins-Regular"),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                  ))),
                                          actions: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border(
                                                              top: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                          .grey[
                                                                      400]),
                                                              right: BorderSide(
                                                                  width: 0.5,
                                                                  color: Colors
                                                                          .grey[
                                                                      400]),
                                                            ),
                                                          ),
                                                          child: FlatButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .blue[
                                                                          800],
                                                                      fontFamily:
                                                                          "Poppins-Regular"))))),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border(
                                                              top: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                          .grey[
                                                                      400]),
                                                              left: BorderSide(
                                                                  width: 0.5,
                                                                  color: Colors
                                                                          .grey[
                                                                      400]),
                                                            ),
                                                          ),
                                                          child: FlatButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (addController
                                                                      .text
                                                                      .trim()
                                                                      .isNotEmpty) {
                                                                    if (cat ==
                                                                        "cat") {
                                                                      sett.cat.add(addController
                                                                          .text
                                                                          .trim());
                                                                    }

                                                                    if (cat ==
                                                                        "acc") {
                                                                      sett.acc.add(addController
                                                                          .text
                                                                          .trim());
                                                                    }

                                                                    if (cat ==
                                                                        "supp") {
                                                                      sett.supp.add(addController
                                                                          .text
                                                                          .trim());
                                                                    }

                                                                    setRef
                                                                        .document(
                                                                            currentUser.email)
                                                                        .updateData({
                                                                      "acc": sett
                                                                          .acc,
                                                                      "supp": sett
                                                                          .supp,
                                                                      "cat": sett
                                                                          .cat,
                                                                    });

                                                                    getS();
                                                                    isTable =
                                                                        true;

                                                                    addController
                                                                        .clear();
                                                                  }
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("Add",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .blue[
                                                                          800],
                                                                      fontFamily:
                                                                          "Poppins-Bold"))))),
                                                ]))
                                          ],
                                        ));
                              })
                    ],
                    title: Text("${appTitle(0)}",
                        style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            fontSize: 28,
                            color: Colors.black)),
                    centerTitle: true),
                body: Padding(
                    padding: EdgeInsets.all(12),
                    child: (isTable)
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: tables())
                        : Column(children: [
                            Container(height: 170),
                            Center(
                                child: Image.asset(
                                    ((cat == "supp")
                                        ? 'images/supplier.png'
                                        : (cat == "acc")
                                            ? 'images/money.png'
                                            : 'images/ig10.png'),
                                    height: 128)),
                            Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Text(
                                    ((cat == "supp")
                                        ? "No Suppliers!!"
                                        : (cat == "acc")
                                            ? "No Accounts!!"
                                            : "No Categories!!"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 25,
                                        color: Colors.black))),
                          ])),
              ),
        // ignore: missing_return
        onWillPop: () {
          setState(() {
            if (cat != "no") {
              cat = "no";
              isTable = true;
            }
          });
        });
  }

  tit() {
    if (cat == "cat")
      return "Add Category";
    else if (cat == "acc")
      return "Add Accounts";
    else if (cat == "supp") return "Add Supplier Name";
  }

  appTitle(x) {
    if (cat == "no")
      return "Settings";
    else if (cat == "cat")
      return "Categories";
    else if (cat == "acc")
      return "Accounts";
    else if (cat == "supp") return "Supplier Name";
  }
}

Color _getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
}
