import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:peeyush/home.dart';
import 'package:peeyush/loader.dart';
import 'package:peeyush/calendar.dart';
import 'package:peeyush/sett.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'dart:ui' as ui;

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

class Account extends StatefulWidget {
  @override
  Accounts createState() => Accounts();
}

class Accounts extends State<Account> {
  List<Tr> incomes = [];
  List<Tr> expenses = [];
  List<Tr> txn = [];
  List<Bill> bill_list = [];
  String mode = "no";
  String modex = "no";
  String dropdownValue = "";
  String dropdownValue1 = "Billed";
  String dropdownValue2 = "";
  String cat = "who cares";
  List<String> cats = [];
  List<String> accs = [];
  TextEditingController addController = TextEditingController();

  List<bool> edit = [false, false, false, false, false, false];
  List<TextEditingController> con = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  bool isLoading = false;
  Sett sett;

  @override
  void initState() {
    super.initState();
    
    if(datazx.size.shortestSide<600)
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    setValues();
    getS();
    ij();
  }

  ij() {
    timestamp = DateTime.now();

    day = DateFormat('EEEE').format(timestamp);
    day1 =
        DateFormat('EEEE').format(DateTime(timestamp.year, timestamp.month, 1));
    dd = weekd.indexOf(day1);

    x = ld[timestamp.month];
    x1 = ld[timestamp.month - 1];
    tapDate = timestamp;
    print(timestamp);
  }

  dtext(i, j) {
    if (x == 28 && timestamp.year % 4 == 0) x = 29;
    if (x1 == 28 && timestamp.year % 4 == 0) x1 = 29;

    if (calM) {
      return "${month[(j + 1) + (i * 3)]}";
    } else {
      if (((j + 1) + (i * 7) - dd) <= 0)
        return "${x1 + (j + 1) + (i * 7) - dd}";
      else if (((j + 1) + (i * 7) - dd) <= x)
        return "${(j + 1) + (i * 7) - dd}";
      else
        return "${(j + 1) + (i * 7) - dd - x}";
    }
  }

  dcolor(i, j) {
    if (calM)
      return Colors.black;
    else {
      if (((j + 1) + (i * 7) - dd) <= 0)
        return Colors.grey[350];
      else if (((j + 1) + (i * 7) - dd) <= x)
        return Colors.black;
      else
        return Colors.grey[350];
    }
  }

  int isTap = -100;
  DateTime tapDate;
  bool calM = false;
  bool yes = false;

  display(i, j) {
    if (calM) {
      return ((((j + 1) + (i * 3)) == timestamp.month &&
                  timestamp.year == DateTime.now().year &&
                  tapDate.year == 0) ||
              (((j + 1) + (i * 3)) == tapDate.month &&
                  tapDate.year == timestamp.year))
          ? Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              elevation: 0.0,
              child: Container(
                  height: 45,
                  width: 75,
                  padding: EdgeInsets.all(2),
                  alignment: Alignment.center,
                  child: Text(
                    dtext(i, j),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins-Regular"),
                  )))
          : Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              elevation: 0.0,
              child: Container(
                  height: 45,
                  width: 65,
                  padding: EdgeInsets.all(2),
                  alignment: Alignment.center,
                  child: Text(
                    dtext(i, j),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: dcolor(i, j),
                        fontSize: 14,
                        fontWeight:
                            (((j + 1) + (i * 3)) == DateTime.now().month &&
                                    (dcolor(i, j) == Colors.black) &&
                                    DateTime.now().year == timestamp.year)
                                ? FontWeight.bold
                                : FontWeight.normal,
                        fontFamily: "Poppins-Regular"),
                  )));
    } else
      return ((((j + 1) + (i * 7) - dd) == timestamp.day &&
                  timestamp.day == DateTime.now().day &&
                  timestamp.month == DateTime.now().month &&
                  timestamp.year == DateTime.now().year &&
                  tapDate != timestamp) ||
              (((j + 1) + (i * 7) - dd) == tapDate.day &&
                  tapDate.month == timestamp.month &&
                  tapDate.year == timestamp.year))
          ? Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              elevation: 0.0,
              child: Container(
                  height: 25,
                  width: 25,
                  padding: EdgeInsets.all(2),
                  child: Text(
                    dtext(i, j),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins-Regular"),
                  )))
          : Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              elevation: 0.0,
              child: Container(
                  height: 25,
                  width: 25,
                  padding: EdgeInsets.all(2),
                  child: Text(
                    dtext(i, j),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: dcolor(i, j),
                        fontSize: 14,
                        fontWeight:
                            (((j + 1) + (i * 7) - dd) == DateTime.now().day &&
                                    (dcolor(i, j) == Colors.black) &&
                                    DateTime.now().month == timestamp.month &&
                                    DateTime.now().year == timestamp.year)
                                ? FontWeight.bold
                                : FontWeight.normal,
                        fontFamily: "Poppins-Regular"),
                  )));
  }

  cha(n, o, m) {
    timestamp = DateTime(
        timestamp.year + n, timestamp.month + o, (m == 0) ? timestamp.day : m);
    day = DateFormat('EEEE').format(timestamp);
    day1 =
        DateFormat('EEEE').format(DateTime(timestamp.year, timestamp.month, 1));
    dd = weekd.indexOf(day1);

    x = ld[timestamp.month];
    x1 = ld[timestamp.month - 1];
    print(timestamp);
  }

  setValues() {
    setState(() {
      mode = "no";
      modex = "no";
      edit = [false, false, false, false, false, false];
    });
  }

  func() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(0, 20.0, 0, 20),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              backgroundColor: _getColorFromHex("#F2F2F2"),
              title: new Container(
                  child: Text(tit(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins-Bold",
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
              content: Container(
                  height: 30,
                  padding: EdgeInsets.only(left: 28, right: 28),
                  child: TextFormField(
                      controller: addController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(3.0),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: tit().substring(4, tit().length),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: "Poppins-Regular"),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ))),
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
                                  child: Text("Cancel",
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
                                      if (addController.text
                                          .trim()
                                          .isNotEmpty) {
                                        if (cat == "cat") {
                                          sett.cat
                                              .add(addController.text.trim());
                                        }

                                        if (cat == "acc") {
                                          sett.acc
                                              .add(addController.text.trim());
                                        }

                                        if (cat == "supp") {
                                          sett.supp
                                              .add(addController.text.trim());
                                        }

                                        setRef
                                            .document(currentUser.email)
                                            .updateData({
                                          "acc": sett.acc,
                                          "supp": sett.supp,
                                          "cat": sett.cat,
                                        });

                                        getS();

                                        addController.clear();
                                      }
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: Text("Add",
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontFamily: "Poppins-Bold"))))),
                    ]))
              ],
            ));
  }

  getS() async {
    setState(() {
      isLoading = true;

      cats = [];
      accs = [];

      incomes = [];
      expenses = [];
      txn = [];
      bill_list = [];
    });

    DocumentSnapshot doc = await setRef.document(currentUser.email).get();

    if (doc.exists) {
      setState(() {
        sett = Sett.fromDocument(doc);
      });
    }

    QuerySnapshot snapshot = await trRef
        .document(currentUser.email)
        .collection('transactions')
        .orderBy('date', descending: true)
        .getDocuments();

    print(snapshot.documents.length);

    if (snapshot.documents.length > 0) {
      setState(() {
        snapshot.documents.forEach((d) {
          Tr t = Tr.fromDocument(d);
          print(t.amount);
          txn.add(t);
          if (t.type == "income")
            incomes.add(t);
          else
            expenses.add(t);
        });
      });
    }

    QuerySnapshot snapshot1 = await billRef
        .document(currentUser.email)
        .collection('bills')
        .orderBy('date', descending: true)
        .getDocuments();

    print(snapshot1.documents.length);

    if (snapshot1.documents.length > 0) {
      setState(() {
        snapshot1.documents.forEach((d) {
          Bill t = Bill.fromDocument(d);
          print(t.gross);

          bill_list.add(t);
        });
      });
    }

    setState(() {
      dropdownValue1 = "Billed";

      cats = sett.cat.map((e) => e.toString()).toList();
      accs = sett.acc.map((e) => e.toString()).toList();

      cats.add("Add more");
      accs.add("Add more");
      dropdownValue2 = cats[0];
      dropdownValue = accs[0];

      isLoading = false;
    });
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
                    title: Text("${appTitle(0)}",
                        style: TextStyle(
                            fontFamily: "Poppins-Regular",
                            fontSize: 28,
                            color: Colors.black)),
                    centerTitle: true),
                // ignore: missing_return
                body: RefreshIndicator(
                    // ignore: missing_return
                    onRefresh: () {
                      // setValues();
                      getS();
                      ij();
                    },
                    child: Stack(children: [
                      ListView(
                        children: [
                          (mode == "no")
                              ? Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: tables()))
                              : bill2(),
                          (modex == "no")
                              ? Container(height: 0, width: 0)
                              : Container(
                                  padding: EdgeInsets.only(
                                      right: 12, top: 30, bottom: 20),
                                  alignment: Alignment.bottomRight,
                                  child: RaisedButton(
                                    child: Container(
                                        height: 50,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Save Changes",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontFamily:
                                                        "Poppins-Regular"),
                                              ),
                                            ])),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.blue[700],
                                    onPressed: () {
                                      if (modex == "income" ||
                                          modex == "expenses") {
                                        if (double.tryParse(
                                                    con[1].text.trim()) !=
                                                null &&
                                            con[5].text.trim().length > 0 &&
                                            dropdownValue2 != "Add more" &&
                                            dropdownValue != "Add more") {
                                          String mId = Uuid().v4();
                                          trRef
                                              .document(currentUser.email)
                                              .collection("transactions")
                                              .document(mId)
                                              .setData({
                                            "type": modex,
                                            "id": mId,
                                            "date": tapDate,
                                            "amount": double.parse(
                                                con[1].text.trim()),
                                            "cat": dropdownValue2,
                                            "acc": dropdownValue,
                                            "tag": dropdownValue1,
                                            "note": con[5].text.trim()
                                          });

                                          print("yes");

                                          error("yes");
                                        } else {
                                          String x = "";
                                          if (double.tryParse(
                                                  con[1].text.trim()) ==
                                              null) x = x + "Invalid Amount\n";

                                          if (con[5].text.trim().isEmpty)
                                            x = x + "Note can't be empty\n";

                                          if (dropdownValue2 == "Add more")
                                            x = x + "Category must be added\n";

                                          if (dropdownValue == "Add more")
                                            x = x + "Account must be added\n";

                                          error(x);
                                        }
                                      } else {
                                        if (double.tryParse(
                                                    con[1].text.trim()) !=
                                                null &&
                                            double.tryParse(
                                                    con[2].text.trim()) !=
                                                null &&
                                            double.tryParse(
                                                    con[3].text.trim()) !=
                                                null &&
                                            double.tryParse(
                                                    con[4].text.trim()) !=
                                                null &&
                                            con[5].text.trim().length > 0) {
                                          String mId = Uuid().v4();
                                          billRef
                                              .document(currentUser.email)
                                              .collection("bills")
                                              .document(mId)
                                              .setData({
                                            "type": modex,
                                            "id": mId,
                                            "date": tapDate,
                                            "gross": double.parse(
                                                con[1].text.trim()),
                                            "touch": double.parse(
                                                con[2].text.trim()),
                                            "net": double.parse(
                                                con[3].text.trim()),
                                            "mc": double.parse(
                                                con[4].text.trim()),
                                            "name": con[5].text.trim()
                                          });

                                          print("yes");

                                          error("yes");
                                        } else {
                                          String x = "";
                                          if (double.tryParse(
                                                  con[1].text.trim()) ==
                                              null)
                                            x = x + "Invalid Gross Weight\n";

                                          if (double.tryParse(
                                                  con[2].text.trim()) ==
                                              null) x = x + "Invalid Touch\n";

                                          if (double.tryParse(
                                                  con[3].text.trim()) ==
                                              null)
                                            x = x + "Invalid Net Weight\n";

                                          if (double.tryParse(
                                                  con[4].text.trim()) ==
                                              null) x = x + "Invalid MC\n";

                                          if (con[5].text.trim().isEmpty)
                                            x = x +
                                                "Supplier Name can't be empty\n";

                                          error(x);
                                        }
                                      }
                                    },
                                  ))
                        ],
                      ),
                      (yes == true)
                          ? BackdropFilter(
                              filter: ui.ImageFilter.blur(
                                sigmaX: 8.0,
                                sigmaY: 8.0,
                              ),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 20, top: 20),
                                      child: Card(
                                          color: Colors.transparent,
                                          elevation: 100,
                                          child: Container(
                                            width: 261,
                                            height: 296,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white),
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          print("next");

                                                          calM
                                                              ? cha(-1, 0, 0)
                                                              : cha(0, -1, 0);
                                                        });
                                                      },
                                                      child: Icon(
                                                          Icons.chevron_left,
                                                          color: Colors.grey,
                                                          size: 30)),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          calM = !calM;
                                                          cha(0, 0, 0);
                                                        });
                                                      },
                                                      child: Row(children: [
                                                        Text(
                                                          (calM)
                                                              ? "${timestamp.year}"
                                                              : "${month[timestamp.month]} ${timestamp.year}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Poppins-Regular"),
                                                        ),
                                                        (calM)
                                                            ? Container(
                                                                height: 0,
                                                                width: 0)
                                                            : Icon(
                                                                Icons
                                                                    .expand_more,
                                                                color:
                                                                    Colors.grey,
                                                                size: 20),
                                                      ])),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          print("next");

                                                          calM
                                                              ? cha(1, 0, 0)
                                                              : cha(0, 1, 0);
                                                        });
                                                      },
                                                      child: Icon(
                                                          Icons.chevron_right,
                                                          color: Colors.grey,
                                                          size: 30))
                                                ],
                                              ),
                                              Container(height: 5),
                                              (calM)
                                                  ? Column(children: [
                                                      for (var i = 0;
                                                          i < 4;
                                                          i++)
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              for (var j = 0;
                                                                  j < 3;
                                                                  j++)
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        cha(
                                                                            0,
                                                                            ((j + 1) + (i * 3)) -
                                                                                timestamp.month,
                                                                            0);
                                                                        calM =
                                                                            !calM;
                                                                      });
                                                                    },
                                                                    child:
                                                                        display(
                                                                            i,
                                                                            j)),
                                                            ]),
                                                    ])
                                                  : Column(children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            for (int z = 0;
                                                                z < 7;
                                                                z++)
                                                              Card(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10.0))),
                                                                  elevation:
                                                                      0.0,
                                                                  child: Container(
                                                                      height: 25,
                                                                      width: 25,
                                                                      padding: EdgeInsets.all(1),
                                                                      child: Text(
                                                                        weekd[z].substring(
                                                                            0,
                                                                            3),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontFamily: "Poppins-Regular"),
                                                                      ))),
                                                          ]),
                                                      for (var i = 0;
                                                          i < 6;
                                                          i++)
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              for (var j = 0;
                                                                  j < 7;
                                                                  j++)
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        if (((j + 1) +
                                                                                (i * 7) -
                                                                                dd) <=
                                                                            0) {
                                                                          isTap =
                                                                              x1 + ((j + 1) + (i * 7) - dd);
                                                                          cha(
                                                                              0,
                                                                              -1,
                                                                              isTap);
                                                                        } else if (((j + 1) +
                                                                                (i * 7) -
                                                                                dd) <=
                                                                            x) {
                                                                          isTap = ((j + 1) +
                                                                              (i * 7) -
                                                                              dd);
                                                                          cha(
                                                                              0,
                                                                              0,
                                                                              isTap);
                                                                        } else {
                                                                          isTap =
                                                                              ((j + 1) + (i * 7) - dd) - x;
                                                                          cha(
                                                                              0,
                                                                              1,
                                                                              isTap);
                                                                        }

                                                                        tapDate =
                                                                            timestamp;

                                                                        yes =
                                                                            !yes;
                                                                      });
                                                                      print(DateTime(
                                                                          timestamp
                                                                              .year,
                                                                          timestamp
                                                                              .month,
                                                                          ((j + 1) +
                                                                              (i * 7))));

                                                                      //   Navigator.pop(context);
                                                                    },
                                                                    child:
                                                                        display(
                                                                            i,
                                                                            j)),
                                                            ]),
                                                    ]),
                                            ]),
                                          )))))
                          : Container(height: 0, width: 0),
                    ]))),
        // ignore: missing_return
        onWillPop: () {
          setState(() {
            if (yes == true)
              yes = !yes;
            else {
              if (mode != "no") mode = "no";
              if (modex != "no") modex = "no";

              edit = [false, false, false, false, false, false];
              con = [
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
                TextEditingController(),
                TextEditingController()
              ];
            }
          });
        });
  }

  cal() {
    //  showDialog(context: context, builder: (_) => d(context));
  }

  billColor(index) {
    if (index.type == "income")
      return Colors.blue[100];
    else if (index.type == "expenses")
      return Colors.red[200];
    else if (index.type == "bill") return Colors.orange[100];
  }

  bill2() {
    return (((mode == "income")
                ? incomes.length
                : (mode == "expenses")
                    ? expenses.length
                    : (mode == "trans")
                        ? txn.length
                        : bill_list.length) ==
            0)
        ? Column(children: [
            Container(height: 170),
            Center(child: Image.asset('images/budget.png', height: 128)),
            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                    "You haven't added any " +
                        ((mode == "income")
                            ? "income"
                            : (mode == "expenses")
                                ? "expenses"
                                : (mode == "trans")
                                    ? "transactions"
                                    : "pending bills") +
                        "!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        fontSize: 25,
                        color: Colors.black))),
          ])
        : Column(children: [
            for (var index = 0;
                index <
                    ((mode == "income")
                        ? incomes.length
                        : (mode == "expenses")
                            ? expenses.length
                            : (mode == "trans")
                                ? txn.length
                                : bill_list.length);
                index++)
              Column(children: [
                if (index == 0 ||
                    (((mode == "income")
                            ? daysBetween(incomes[index].date.toDate(),
                                incomes[index - 1].date.toDate())
                            : (mode == "expenses")
                                ? daysBetween(expenses[index].date.toDate(),
                                    expenses[index - 1].date.toDate())
                                : (mode == "trans")
                                    ? daysBetween(txn[index].date.toDate(),
                                        txn[index - 1].date.toDate())
                                    : daysBetween(
                                        bill_list[index].date.toDate(),
                                        bill_list[index - 1].date.toDate())) !=
                        0))
                  Container(
                      height: 30,
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Container(height: 1, width: 120, color: Colors.black),
                          Text(
                              (mode == "income")
                                  ? dT1(incomes[index].date.toDate())
                                  : (mode == "expenses")
                                      ? dT1(expenses[index].date.toDate())
                                      : (mode == "trans")
                                          ? dT1(txn[index].date.toDate())
                                          : dT1(bill_list[index].date.toDate()),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Poppins-Regular",
                                  fontWeight: FontWeight.bold)),
                          Container(height: 1, width: 120, color: Colors.black),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      )),
                GestureDetector(
                    onLongPress: () {
                      deleted(index);
                    },
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: Card(
                            color: (mode == "income")
                                ? billColor(incomes[index])
                                : (mode == "expenses")
                                    ? billColor(expenses[index])
                                    : (mode == "trans")
                                        ? billColor(txn[index])
                                        : billColor(bill_list[index]),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            borderOnForeground: true,
                            elevation: 5.0,
                            child: Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (mode == "income")
                                              ? dT1(
                                                  incomes[index].date.toDate())
                                              : (mode == "expenses")
                                                  ? dT1(expenses[index]
                                                      .date
                                                      .toDate())
                                                  : (mode == "trans")
                                                      ? dT1(txn[index]
                                                          .date
                                                          .toDate())
                                                      : dT1(bill_list[index]
                                                          .date
                                                          .toDate()),
                                          style: TextStyle(
                                              fontFamily: "Poppins-Regular",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 13),
                                        ),
                                        (mode == "bill")
                                            ? Text(
                                                bill_list[index].name,
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Poppins-Regular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              )
                                            : Row(children: [
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        'images/Stack.png',
                                                        height: 25)),
                                                Text(
                                                  (mode == "income")
                                                      ? incomes[index].acc
                                                      : (mode == "expenses")
                                                          ? expenses[index].acc
                                                          : (mode == "trans")
                                                              ? txn[index].acc
                                                              : "Account",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins-Regular",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 13),
                                                )
                                              ])
                                      ],
                                    ),
                                    Container(height: 8),
                                    (mode == "bill")
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                bill_list[index]
                                                        .net
                                                        .toStringAsFixed(2) +
                                                    " Gms",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Poppins-Regular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                "Rs." +
                                                    bill_list[index]
                                                        .mc
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Poppins-Regular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Card(
                                                  color: Colors.orange,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  borderOnForeground: true,
                                                  elevation: 2.0,
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: Text(
                                                        "Mark as Paid",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Poppins-Bold",
                                                            color: Colors.black,
                                                            fontSize: 13),
                                                      ))),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                (mode == "income")
                                                    ? incomes[index].cat
                                                    : (mode == "expenses")
                                                        ? expenses[index].cat
                                                        : txn[index].cat,
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Poppins-Regular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                "Rs." +
                                                    ((mode == "income")
                                                        ? incomes[index]
                                                            .amount
                                                            .toStringAsFixed(2)
                                                        : (mode == "expenses")
                                                            ? expenses[index]
                                                                .amount
                                                                .toStringAsFixed(
                                                                    2)
                                                            : txn[index]
                                                                .amount
                                                                .toStringAsFixed(
                                                                    2)),
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Poppins-Regular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ),
                                  ],
                                )))))
              ])
          ]);
  }

  bill3() {
    return Column(children: [
      Container(
          height: 30,
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Container(height: 1, width: 120, color: Colors.black),
              Text("DD/MM/YYYY",
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Poppins-Regular",
                      fontWeight: FontWeight.bold)),
              Container(height: 1, width: 120, color: Colors.black),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )),
      bills(),
    ]);
  }

  bills() {
    return Container(
        padding: EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, int index) {
              return Column(children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: Card(
                        color: billColor(index),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        borderOnForeground: true,
                        elevation: 5.0,
                        child: Container(
                            padding: EdgeInsets.all(8),
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "DD/MM/YYYY",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 13),
                                    ),
                                    (mode == "bill")
                                        ? Text(
                                            "Name of Supplier",
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13),
                                          )
                                        : Row(children: [
                                            Container(
                                                padding:
                                                    EdgeInsets.only(right: 5),
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                    'images/Stack.png',
                                                    height: 25)),
                                            Text(
                                              "Account",
                                              style: TextStyle(
                                                  fontFamily: "Poppins-Regular",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            )
                                          ])
                                  ],
                                ),
                                (mode == "bill")
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Net Weight",
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            "MC Amount",
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                          Card(
                                              color: Colors.orange,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              borderOnForeground: true,
                                              elevation: 2.0,
                                              child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  child: Text(
                                                    "Mark as Paid",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Poppins-Bold",
                                                        color: Colors.black,
                                                        fontSize: 13),
                                                  ))),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Category of Income",
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            "Amount ",
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13),
                                          )
                                        ],
                                      ),
                              ],
                            ))))
              ]);
            }));
  }

  dT() {
    String m, d;
    m = tapDate.month.toString();
    d = tapDate.day.toString();
    if (tapDate.day < 10) d = "0" + d;
    if (tapDate.month < 10) m = "0" + m;

    if (tapDate.year == 0)
      return "DD/MM/YYYY";
    else
      return "$d/$m/${tapDate.year}";
  }

  dT1(s) {
    String m, d;
    m = s.month.toString();
    d = s.day.toString();
    if (s.day < 10) d = "0" + d;
    if (s.month < 10) m = "0" + m;

    return "$d/$m/${s.year}";
  }

  bool isE = false;

  altit(x) {
    if (x == con[1] && modex == "bill")
      return "Enter Gross Weight";
    else if (x == con[1] && modex != "bill")
      return "Enter Amount";
    else if (x == con[2])
      return "Enter Touch";
    else if (x == con[3])
      return "Enter Net Weight";
    else if (x == con[4]) return "Enter MC";
  }

  alht(x) {
    if (x == con[1] && modex == "bill")
      return "00 Gms";
    else if (x == con[1] && modex != "bill")
      return "Rs.12345";
    else if (x == con[2])
      return "00 %";
    else if (x == con[3])
      return "00 Gms";
    else if (x == con[4]) return "Rs.12345";
  }

  deleted(index) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(0, 20.0, 0, 20),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              backgroundColor: _getColorFromHex("#F2F2F2"),
              title: Column(children: [
                Container(
                    child: Text(
                        "Do you want to delete this " +
                            ((mode == "income")
                                ? "income?"
                                : (mode == "expenses")
                                    ? "expense?"
                                    : (mode == "trans")
                                        ? "transaction?"
                                        : "bill?"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins-Bold",
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
              ]),
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
                                  child: Text("Cancel",
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
                                    Navigator.pop(context);

                                    if (mode == "bill") {
                                      billRef
                                          .document(currentUser.email)
                                          .collection("bills")
                                          .document(bill_list[index].id)
                                          .get()
                                          .then((doc) {
                                        if (doc.exists) {
                                          doc.reference.delete();
                                          delete1();
                                        }
                                      });
                                    } else {
                                      trRef
                                          .document(currentUser.email)
                                          .collection("transactions")
                                          .document((mode == "income")
                                              ? incomes[index].id
                                              : (mode == "expenses")
                                                  ? expenses[index].id
                                                  : txn[index].id)
                                          .get()
                                          .then((doc) {
                                        if (doc.exists) {
                                          doc.reference.delete();
                                          delete1();
                                        }
                                      });
                                    }
                                  },
                                  child: Text("Delete",
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontFamily: "Poppins-Bold"))))),
                    ]))
              ],
            ));
  }

  delete1() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(0, 20.0, 0, 20),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              backgroundColor: _getColorFromHex("#F2F2F2"),
              title: Text("Success",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: "Poppins-Bold",
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              content: Text(
                  (mode == "income")
                      ? "Income deleted successfully!!!"
                      : (mode == "expenses")
                          ? "Expense deleted successfully!!!"
                          : (mode == "trans")
                              ? "Trasaction deleted successfully!!!"
                              : "Bill deleted successfully!!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins-Regular",
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ));

    getS();
    ij();
  }

  error(x) {
    if (x == "yes") {
      getS();
      ij();

      setState(() {
        modex = "no";
      });
    }

    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(0, 20.0, 0, 20),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              backgroundColor: _getColorFromHex("#F2F2F2"),
              title: Text((x == "yes") ? "Success" : "Error",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: "Poppins-Bold",
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              content: Text(
                  (x == "yes")
                      ? ((modex == "income")
                          ? "Income saved successfully!!!"
                          : (modex == "expenses")
                              ? "Expense saved successfully!!!"
                              : "Bill saved successfully!!!")
                      : x,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins-Regular",
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ));
  }

  func1(x) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(0, 20.0, 0, 20),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              backgroundColor: _getColorFromHex("#F2F2F2"),
              title: Column(children: [
                Container(
                    child: Text(altit(x),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins-Bold",
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),
              ]),
              content: Container(
                  height: 30,
                  padding: EdgeInsets.only(left: 28, right: 28),
                  child: TextFormField(
                      controller: x,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(3.0),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: alht(x),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: "Poppins-Regular"),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ))),
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
                                    setState(() {
                                      x.text = "";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel",
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
                                    setState(() {});

                                    Navigator.pop(context);
                                  },
                                  child: Text("Add",
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontFamily: "Poppins-Bold"))))),
                    ]))
              ],
            ));
  }

  tables() {
    if (mode == "no" && modex == "no")
      return Table(
          border: TableBorder.symmetric(
            inside: BorderSide(width: 2),
          ),
          children: [
            TableRow(children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      mode = "income";
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Income",
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                            GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: Image.asset('images/Blue.png',
                                        height: 30)),
                                onTap: () {
                                  setState(() {
                                    modex = "income";
                                  });
                                })
                          ]))),
            ]),
            TableRow(children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      mode = "expenses";
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Expenses",
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                            GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: Image.asset('images/Red.png',
                                        height: 30)),
                                onTap: () {
                                  setState(() {
                                    modex = "expenses";
                                  });
                                })
                          ]))),
            ]),
            TableRow(children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      mode = "bill";
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Pending Bills",
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                            GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: Image.asset('images/Yellow.png',
                                        height: 30)),
                                onTap: () {
                                  setState(() {
                                    modex = "bill";
                                  });
                                })
                          ]))),
            ]),
            TableRow(children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      mode = "trans";
                    });
                  },
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Transactions",
                                style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                          ]))),
            ]),
          ]);
    else if (mode == "no" && modex == "income")
      return Table(
          border: TableBorder.symmetric(
            inside: BorderSide(width: 2, color: Colors.blue),
          ),
          children: [
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        (edit[0] == false)
                            ? GestureDetector(
                                onTap: () {
                                  cal();
                                  setState(() {
                                    edit = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    //  edit[0] = !edit[0];
                                    yes = !yes;
                                  });
                                },
                                child: Text(dT(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 70,
                                child: TextFormField(
                                  onFieldSubmitted: (val) {
                                    setState(() {
                                      edit[0] = !edit[0];
                                    });
                                  },
                                  autofocus: true,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                  controller: con[0],
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    hintText: "DD/MM/YYYY",
                                    hintStyle: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                )),
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        (edit[1] == false)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    //  edit[1] = !edit[1];
                                  });
                                  func1(con[1]);
                                },
                                child: Text(
                                    (con[1].text.trim().isEmpty)
                                        ? "Rs.12345"
                                        : "Rs." + ffs(con[1].text.trim()),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))
                            : Container(
                                width: (con[1].text.trim().length > 8)
                                    ? MediaQuery.of(context).size.width * 0.5
                                    : MediaQuery.of(context).size.width * 0.3,
                                child: TextFormField(
                                  onFieldSubmitted: (val) {
                                    setState(() {
                                      edit[1] = !edit[1];
                                    });
                                  },
                                  autofocus: true,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                  controller: con[1],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    hintText: "Rs.12345",
                                    hintStyle: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                )),
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Category",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        PopupMenuButton<String>(
                          itemBuilder: (context) {
                            return cats.map((str) {
                              return PopupMenuItem(
                                value: str,
                                child: Text(str,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)),
                              );
                            }).toList();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(dropdownValue2,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.grey,
                                      fontSize: 18)),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          onSelected: (v) {
                            setState(() {
                              if (v == "Add more") {
                                func();
                                cat = "cat";
                              } else {
                                print('!!!===== $v');
                                dropdownValue2 = v;
                                edit = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                              }
                            });
                          },
                        )
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Account",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        PopupMenuButton<String>(
                          itemBuilder: (context) {
                            return accs.map((str) {
                              return PopupMenuItem(
                                value: str,
                                child: Text(str,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)),
                              );
                            }).toList();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(dropdownValue,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.grey,
                                      fontSize: 18)),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          onSelected: (v) {
                            setState(() {
                              if (v == "Add more") {
                                func();
                                cat = "acc";
                              } else {
                                print('!!!===== $v');
                                dropdownValue = v;
                                edit = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                              }
                            });
                          },
                        )
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tags",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        PopupMenuButton<String>(
                          itemBuilder: (context) {
                            return ["Billed", "Unbilled"].map((str) {
                              return PopupMenuItem(
                                value: str,
                                child: Text(str,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)),
                              );
                            }).toList();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(dropdownValue1,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.grey,
                                      fontSize: 18)),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          onSelected: (v) {
                            setState(() {
                              print('!!!===== $v');
                              dropdownValue1 = v;
                              edit = [false, false, false, false, false, false];
                            });
                          },
                        )
                      ])),
            ]),
            TableRow(children: [
              Column(children: [
                Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Note",
                              style: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          (con[5].text.trim().isEmpty && edit[5] == false)
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      edit = [
                                        false,
                                        false,
                                        false,
                                        false,
                                        false,
                                        false
                                      ];
                                      edit[5] = !edit[5];
                                    });
                                  },
                                  child: Text("Item Description",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.grey,
                                          fontSize: 18)))
                              : IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      edit = [
                                        false,
                                        false,
                                        false,
                                        false,
                                        false,
                                        false
                                      ];
                                      edit[5] = !edit[5];
                                    });
                                  }),
                        ])),
                ((edit[5] == true)
                    ? Container(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: TextFormField(
                          onFieldSubmitted: (val) {
                            setState(() {
                              edit[5] = !edit[5];
                            });
                          },
                          autofocus: true,
                          style: TextStyle(
                              fontFamily: "Poppins-Regular",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                          controller: con[5],
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            hintText: "Item Description",
                            hintStyle: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                                fontSize: 18),
                          ),
                        ))
                    : (con[5].text.trim().isEmpty)
                        ? Container(height: 0, width: 0)
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(con[5].text.trim(),
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))))
              ])
            ]),
          ]);
    else if (mode == "no" && modex == "expenses")
      return Table(
          border: TableBorder.symmetric(
            inside: BorderSide(width: 2, color: Colors.red),
          ),
          children: [
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        (edit[0] == false)
                            ? GestureDetector(
                                onTap: () {
                                  cal();
                                  setState(() {
                                    edit = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    //  edit[0] = !edit[0];
                                    yes = !yes;
                                  });
                                },
                                child: Text(dT(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 70,
                                child: TextFormField(
                                  onFieldSubmitted: (val) {
                                    setState(() {
                                      edit[0] = !edit[0];
                                    });
                                  },
                                  autofocus: true,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                  controller: con[0],
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    hintText: "DD/MM/YYYY",
                                    hintStyle: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                )),
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        (edit[1] == false)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    //  edit[1] = !edit[1];
                                  });
                                  func1(con[1]);
                                },
                                child: Text(
                                    (con[1].text.trim().isEmpty)
                                        ? "Rs.12345"
                                        : "Rs." + ffs(con[1].text.trim()),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))
                            : Container(
                                width: (con[1].text.trim().length > 8)
                                    ? MediaQuery.of(context).size.width * 0.5
                                    : MediaQuery.of(context).size.width * 0.3,
                                child: TextFormField(
                                  onFieldSubmitted: (val) {
                                    setState(() {
                                      edit[1] = !edit[1];
                                    });
                                  },
                                  autofocus: true,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                  controller: con[1],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    hintText: "Rs.12345",
                                    hintStyle: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                )),
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Category",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        PopupMenuButton<String>(
                          itemBuilder: (context) {
                            return cats.map((str) {
                              return PopupMenuItem(
                                value: str,
                                child: Text(str,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)),
                              );
                            }).toList();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(dropdownValue2,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.grey,
                                      fontSize: 18)),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          onSelected: (v) {
                            setState(() {
                              if (v == "Add more") {
                                func();
                                cat = "cat";
                              } else {
                                print('!!!===== $v');
                                dropdownValue2 = v;
                                edit = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                              }
                            });
                          },
                        )
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Account",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        PopupMenuButton<String>(
                          itemBuilder: (context) {
                            return accs.map((str) {
                              return PopupMenuItem(
                                value: str,
                                child: Text(str,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)),
                              );
                            }).toList();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(dropdownValue,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.grey,
                                      fontSize: 18)),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          onSelected: (v) {
                            setState(() {
                              if (v == "Add more") {
                                func();
                                cat = "acc";
                              } else {
                                print('!!!===== $v');
                                dropdownValue = v;
                                edit = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                              }
                            });
                          },
                        )
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tags",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        PopupMenuButton<String>(
                          itemBuilder: (context) {
                            return ["Billed", "Unbilled"].map((str) {
                              return PopupMenuItem(
                                value: str,
                                child: Text(str,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)),
                              );
                            }).toList();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(dropdownValue1,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.grey,
                                      fontSize: 18)),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          onSelected: (v) {
                            setState(() {
                              print('!!!===== $v');
                              dropdownValue1 = v;
                              edit = [false, false, false, false, false, false];
                            });
                          },
                        )
                      ])),
            ]),
            TableRow(children: [
              Column(children: [
                Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Note",
                              style: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          (con[5].text.trim().isEmpty && edit[5] == false)
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      edit = [
                                        false,
                                        false,
                                        false,
                                        false,
                                        false,
                                        false
                                      ];
                                      edit[5] = !edit[5];
                                    });
                                  },
                                  child: Text("Item Description",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.grey,
                                          fontSize: 18)))
                              : IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      edit = [
                                        false,
                                        false,
                                        false,
                                        false,
                                        false,
                                        false
                                      ];
                                      edit[5] = !edit[5];
                                    });
                                  }),
                        ])),
                ((edit[5] == true)
                    ? Container(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: TextFormField(
                          onFieldSubmitted: (val) {
                            setState(() {
                              edit[5] = !edit[5];
                            });
                          },
                          autofocus: true,
                          style: TextStyle(
                              fontFamily: "Poppins-Regular",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                          controller: con[5],
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            hintText: "Item Description",
                            hintStyle: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                                fontSize: 18),
                          ),
                        ))
                    : (con[5].text.trim().isEmpty)
                        ? Container(height: 0, width: 0)
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(con[5].text.trim(),
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))))
              ])
            ]),
          ]);
    else if (mode == "no" && modex == "bill")
      return Table(
          border: TableBorder.symmetric(
            inside: BorderSide(width: 2, color: Colors.yellow[700]),
          ),
          children: [
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        (edit[0] == false)
                            ? GestureDetector(
                                onTap: () {
                                  cal();
                                  setState(() {
                                    edit = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    //  edit[0] = !edit[0];
                                    yes = !yes;
                                  });
                                },
                                child: Text(dT(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 70,
                                child: TextFormField(
                                  onFieldSubmitted: (val) {
                                    setState(() {
                                      edit[0] = !edit[0];
                                    });
                                  },
                                  autofocus: true,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                  controller: con[0],
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    hintText: "DD/MM/YYYY",
                                    hintStyle: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                )),
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Gross Weight",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        (edit[1] == false)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    //  edit[1] = !edit[1];
                                  });
                                  func1(con[1]);
                                },
                                child: Text(
                                    (con[1].text.trim().isEmpty)
                                        ? "00 Gms"
                                        : ffs(con[1].text.trim()) + " Gms",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))
                            : Container(
                                width: (con[1].text.trim().length > 8)
                                    ? MediaQuery.of(context).size.width * 0.5
                                    : MediaQuery.of(context).size.width * 0.3,
                                child: TextFormField(
                                  onFieldSubmitted: (val) {
                                    setState(() {
                                      edit[1] = !edit[1];
                                    });
                                  },
                                  autofocus: true,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                  controller: con[1],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    hintText: "Rs.12345",
                                    hintStyle: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                )),
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Touch",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        (edit[2] == false)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    //  edit[1] = !edit[1];
                                  });
                                  func1(con[2]);
                                },
                                child: Text(
                                    (con[2].text.trim().isEmpty)
                                        ? "00 %"
                                        : ffs(con[2].text.trim()) + " %",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))
                            : Container(
                                width: (con[2].text.trim().length > 8)
                                    ? MediaQuery.of(context).size.width * 0.5
                                    : MediaQuery.of(context).size.width * 0.3,
                                child: TextFormField(
                                  onFieldSubmitted: (val) {
                                    setState(() {
                                      edit[2] = !edit[2];
                                    });
                                  },
                                  autofocus: true,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                  controller: con[2],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    hintText: "Rs.12345",
                                    hintStyle: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                )),
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Net Weight",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        (edit[3] == false)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    //  edit[1] = !edit[1];
                                  });
                                  func1(con[3]);
                                },
                                child: Text(
                                    (con[3].text.trim().isEmpty)
                                        ? "00 Gms"
                                        : ffs(con[3].text.trim()) + " Gms",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))
                            : Container(
                                width: (con[3].text.trim().length > 8)
                                    ? MediaQuery.of(context).size.width * 0.5
                                    : MediaQuery.of(context).size.width * 0.3,
                                child: TextFormField(
                                  onFieldSubmitted: (val) {
                                    setState(() {
                                      edit[3] = !edit[3];
                                    });
                                  },
                                  autofocus: true,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                  controller: con[3],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    hintText: "Rs.12345",
                                    hintStyle: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                )),
                      ])),
            ]),
            TableRow(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("MC",
                            style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        (edit[4] == false)
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    edit = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    //  edit[1] = !edit[1];
                                  });
                                  func1(con[4]);
                                },
                                child: Text(
                                    (con[4].text.trim().isEmpty)
                                        ? "Rs.12345"
                                        : "Rs." + ffs(con[4].text.trim()),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))
                            : Container(
                                width: (con[4].text.trim().length > 8)
                                    ? MediaQuery.of(context).size.width * 0.5
                                    : MediaQuery.of(context).size.width * 0.3,
                                child: TextFormField(
                                  onFieldSubmitted: (val) {
                                    setState(() {
                                      edit[4] = !edit[4];
                                    });
                                  },
                                  autofocus: true,
                                  style: TextStyle(
                                      fontFamily: "Poppins-Regular",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                  controller: con[4],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    hintText: "Rs.12345",
                                    hintStyle: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                )),
                      ])),
            ]),
            TableRow(children: [
              Column(children: [
                Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Supplier Name",
                              style: TextStyle(
                                  fontFamily: "Poppins-Regular",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          (con[5].text.trim().isEmpty && edit[5] == false)
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      edit = [
                                        false,
                                        false,
                                        false,
                                        false,
                                        false,
                                        false
                                      ];
                                      edit[5] = !edit[5];
                                    });
                                  },
                                  child: Text("XYZ",
                                      style: TextStyle(
                                          fontFamily: "Poppins-Regular",
                                          color: Colors.grey,
                                          fontSize: 18)))
                              : IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      edit = [
                                        false,
                                        false,
                                        false,
                                        false,
                                        false,
                                        false
                                      ];
                                      edit[5] = !edit[5];
                                    });
                                  }),
                        ])),
                ((edit[5] == true)
                    ? Container(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: TextFormField(
                          onFieldSubmitted: (val) {
                            setState(() {
                              edit[5] = !edit[5];
                            });
                          },
                          autofocus: true,
                          style: TextStyle(
                              fontFamily: "Poppins-Regular",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                          controller: con[5],
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            hintText: "XYZ",
                            hintStyle: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                                fontSize: 18),
                          ),
                        ))
                    : (con[5].text.trim().isEmpty)
                        ? Container(height: 0, width: 0)
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(con[5].text.trim(),
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        color: Colors.grey,
                                        fontSize: 18)))))
              ])
            ]),
          ]);
    else
      return Container();
  }

  tit() {
    if (cat == "cat")
      return "Add Category";
    else if (cat == "acc")
      return "Add Accounts";
    else if (cat == "supp") return "Add Supplier Name";
  }

  ffs(x) {
    if (x.length > 20)
      return x.substring(0, 20) + "...";
    else
      return x;
  }

  appTitle(x) {
    if (mode == "no" && modex == "no")
      return "Daily Accounts";
    else if (mode == "income" && modex == "no")
      return "Income";
    else if (mode == "no" && modex == "income")
      return "Add Income";
    else if (mode == "expenses" && modex == "no")
      return "Expenses";
    else if (mode == "no" && modex == "expenses")
      return "Add Expense";
    else if (mode == "bill" && modex == "no")
      return "Pending Bills";
    else if (mode == "no" && modex == "bill")
      return "Add Bill";
    else if (mode == "trans" && modex == "no") return "Transactions";
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
