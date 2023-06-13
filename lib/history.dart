import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:peeyush/calendar.dart';
import 'package:peeyush/home.dart';
import 'dart:ui' as ui;

import 'package:peeyush/loader.dart';
import 'package:peeyush/sett.dart';

class History extends StatefulWidget {
  @override
  Historys createState() => Historys();
}

class Historys extends State<History> {
  bool isLoading = false;
  List<Tr> incomes = [];
  List<Tr> expenses = [];
  num inc = 0.0;
  num exp = 0.0;
  @override
  void initState() {
    super.initState();

    if (datazx.size.shortestSide < 600)
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    ij();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;

      inc = 0.0;
      exp = 0.0;

      incomes = [];
      expenses = [];
    });

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

          if (t.type == "income") {
            incomes.add(t);
            inc += t.amount;
          } else {
            expenses.add(t);
            exp += t.amount;
          }
        });
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  ij() {
    timestamp = DateTime.now();

    day = DateFormat('EEEE').format(timestamp);
    day1 =
        DateFormat('EEEE').format(DateTime(timestamp.year, timestamp.month, 1));
    dd = weekd.indexOf(day1);

    x = ld[timestamp.month];
    x1 = ld[timestamp.month - 1];
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
  DateTime tapDate = DateTime(0, 1, 1);
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

  String mode = "no";
  Widget build(BuildContext context) {
    if (isLoading)
      return circularProgress();
    else
      return WillPopScope(
          child: Scaffold(
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
                    (mode == "no")
                        ? GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Image.asset('images/Calendar.png',
                                    height: 35)),
                            onTap: () {
                              //  showDialog(context: context, builder: (_) => d(context));

                              setState(() {
                                yes = !yes;
                              });
                            })
                        : Container(height: 0, width: 0)
                  ],
                  title: Text("${appTitle(0)}",
                      style: TextStyle(
                          fontFamily: "Poppins-Regular",
                          fontSize: 28,
                          color: Colors.black)),
                  centerTitle: true),
              body: RefreshIndicator(
                  // ignore: missing_return
                  onRefresh: () {
                    ij();
                    getData();
                  },
                  child: Stack(children: [
                    ListView(
                      children: [
                        Container(
                            height: 60,
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Container(
                                    height: 1, width: 120, color: Colors.black),
                                Text((mode == "no") ? "MONTH" : "DD/MM/YYYY",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    height: 1, width: 120, color: Colors.black),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )),
                        (mode == "no") ? list() : cb(),
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
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Poppins-Regular"),
                                                      ),
                                                      (calM)
                                                          ? Container(
                                                              height: 0,
                                                              width: 0)
                                                          : Icon(
                                                              Icons.expand_more,
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
                                                    for (var i = 0; i < 4; i++)
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
                                                                      display(i,
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
                                                                elevation: 0.0,
                                                                child:
                                                                    Container(
                                                                        height:
                                                                            25,
                                                                        width:
                                                                            25,
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                1),
                                                                        child:
                                                                            Text(
                                                                          weekd[z].substring(
                                                                              0,
                                                                              3),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: "Poppins-Regular"),
                                                                        ))),
                                                        ]),
                                                    for (var i = 0; i < 6; i++)
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
                                                                        isTap = x1 +
                                                                            ((j + 1) +
                                                                                (i * 7) -
                                                                                dd);
                                                                        cha(
                                                                            0,
                                                                            -1,
                                                                            isTap);
                                                                      } else if (((j + 1) +
                                                                              (i * 7) -
                                                                              dd) <=
                                                                          x) {
                                                                        isTap = ((j +
                                                                                1) +
                                                                            (i *
                                                                                7) -
                                                                            dd);
                                                                        cha(
                                                                            0,
                                                                            0,
                                                                            isTap);
                                                                      } else {
                                                                        isTap =
                                                                            ((j + 1) + (i * 7) - dd) -
                                                                                x;
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
                                                                            (i *
                                                                                7))));

                                                                    //   Navigator.pop(context);
                                                                  },
                                                                  child:
                                                                      display(i,
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
              if (yes == true) yes = !yes;
              if (mode != "no") {
                mode = "no";

                if (datazx.size.shortestSide < 600)
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown
                  ]);
              }
            });
          });
  }

  cb() {
    if (datazx.size.shortestSide < 600)
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return Column(children: [
      Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(1),
                  },
                  border: TableBorder.symmetric(
                    inside: BorderSide(width: 2),
                  ),
                  children: [
                    TableRow(children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Particulars',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins-Regular",
                                fontSize: 15)),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Rs',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins-Regular",
                                fontSize: 15)),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Particulars',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins-Regular",
                                fontSize: 15)),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('Rs',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins-Regular",
                                fontSize: 15)),
                      ),
                    ]),
                    for (var i = 0;
                        i <
                            ((incomes.length > expenses.length)
                                ? incomes.length
                                : expenses.length);
                        i++)
                      TableRow(children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child:
                              Text((i < incomes.length) ? incomes[i].cat : '',
                                  style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                  )),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                              (i < incomes.length)
                                  ? incomes[i].amount.toStringAsFixed(2)
                                  : '',
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child:
                              Text((i < expenses.length) ? expenses[i].cat : '',
                                  style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                  )),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text(
                              (i < expenses.length)
                                  ? expenses[i].amount.toStringAsFixed(2)
                                  : '',
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                              )),
                        ),
                      ]),
                    for (var i = 0; i < 3; i++)
                      TableRow(children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('',
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('',
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('',
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('',
                              style: TextStyle(
                                fontFamily: "Poppins-Regular",
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ]),
                    TableRow(children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('TOTAL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins-Regular",
                                fontSize: 15)),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('${inc.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins-Regular",
                                fontSize: 15)),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('TOTAL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins-Regular",
                                fontSize: 15)),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text('${exp.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins-Regular",
                                fontSize: 15)),
                      ),
                    ]),
                  ]))),
      Padding(
          padding: EdgeInsets.only(top: 20, left: 8),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                        'Difference - Rs.${(inc - exp).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontFamily: "Poppins-Regular",
                            color: Colors.red[600],
                            fontSize: 15))),
              ))),
      Container(height: 20)
    ]);
  }

  list() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (BuildContext context, int index) =>
                Container(height: 0, width: 0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  padding: EdgeInsets.all(8),
                  child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                          onTap: () {
                            setState(() {
                              mode = "yes";
                            });
                          },
                          trailing: Image.asset('images/share.and.arrow.up.png',
                              height: 30),
                          leading: Text("DD/MM/YYYY",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins-Regular",
                                  fontSize: 20)))));
            }));
  }

  appTitle(x) {
    if (mode == "no")
      return "History";
    else
      return "Cash Book";
  }
}
