import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:peeyush/home.dart';
import 'package:peeyush/loader.dart';
import 'package:peeyush/sett.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:peeyush/calendar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:ui' as ui;

class SubscriberSeries {
  final String month;
  final int subscribers1, subscribers2;
  final charts.Color barColor1, barColor2;

  SubscriberSeries({
    @required this.month,
    @required this.subscribers1,
    @required this.subscribers2,
    @required this.barColor1,
    @required this.barColor2,
  });
}

class SubscriberSeries1 {
  final String month;
  final int subscribers1, subscribers2, subscribers3, subscribers4;
  final charts.Color barColor1, barColor2, barColor3, barColor4;

  SubscriberSeries1({
    @required this.month,
    @required this.subscribers1,
    @required this.subscribers2,
    @required this.subscribers3,
    @required this.subscribers4,
    @required this.barColor1,
    @required this.barColor2,
    @required this.barColor3,
    @required this.barColor4,
  });
}

class Chart extends StatefulWidget {
  @override
  Charts createState() => Charts();
}

class Charts extends State<Chart> {
  bool isLoading = false;
  List<SubscriberSeries> data = List<SubscriberSeries>();
  List<SubscriberSeries1> data1 = List<SubscriberSeries1>();
  List<SubscriberSeries1> data2 = List<SubscriberSeries1>();

  List<charts.Series<SubscriberSeries, String>> series;
  List<charts.Series<SubscriberSeries1, String>> series1;
  List<charts.Series<SubscriberSeries1, String>> series2;

  SubscriberSeries _item1 = SubscriberSeries(
    month: "Apr",
    subscribers1: 26000,
    subscribers2: 10010,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red),
  );

  SubscriberSeries _item2 = SubscriberSeries(
    month: "May",
    subscribers1: 26000,
    subscribers2: 20000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red),
  );

  SubscriberSeries _item3 = SubscriberSeries(
    month: "Jun",
    subscribers1: 33000,
    subscribers2: 18000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red),
  );

  SubscriberSeries _item4 = SubscriberSeries(
    month: "Jul",
    subscribers1: 40000,
    subscribers2: 24000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red),
  );

  SubscriberSeries _item5 = SubscriberSeries(
    month: "Aug",
    subscribers1: 30000,
    subscribers2: 15000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red),
  );

  SubscriberSeries1 _item11 = SubscriberSeries1(
    month: "Apr",
    subscribers1: 1000,
    subscribers2: 2500,
    subscribers3: 4200,
    subscribers4: 4000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.blue[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.blue[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.blue[100]),
  );

  SubscriberSeries1 _item12 = SubscriberSeries1(
    month: "May",
    subscribers1: 1000,
    subscribers2: 1750,
    subscribers3: 3500,
    subscribers4: 4000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.blue[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.blue[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.blue[100]),
  );

  SubscriberSeries1 _item13 = SubscriberSeries1(
    month: "Jun",
    subscribers1: 300,
    subscribers2: 500,
    subscribers3: 1500,
    subscribers4: 1750,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.blue[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.blue[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.blue[100]),
  );

  SubscriberSeries1 _item14 = SubscriberSeries1(
    month: "Jul",
    subscribers1: 800,
    subscribers2: 1500,
    subscribers3: 1000,
    subscribers4: 3750,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.blue[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.blue[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.blue[100]),
  );

  SubscriberSeries1 _item15 = SubscriberSeries1(
    month: "Aug",
    subscribers1: 2300,
    subscribers2: 3500,
    subscribers3: 1700,
    subscribers4: 2750,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.blue[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.blue[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.blue[100]),
  );

  SubscriberSeries1 _item16 = SubscriberSeries1(
    month: "Sep",
    subscribers1: 2700,
    subscribers2: 3500,
    subscribers3: 4000,
    subscribers4: 3000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.blue[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.blue[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.blue[100]),
  );

  SubscriberSeries1 _item17 = SubscriberSeries1(
    month: "Oct",
    subscribers1: 3500,
    subscribers2: 3500,
    subscribers3: 3500,
    subscribers4: 3500,
    barColor1: charts.ColorUtil.fromDartColor(Colors.blue),
    barColor2: charts.ColorUtil.fromDartColor(Colors.blue[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.blue[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.blue[100]),
  );

  SubscriberSeries1 _item21 = SubscriberSeries1(
    month: "Apr",
    subscribers1: 1000,
    subscribers2: 2500,
    subscribers3: 4200,
    subscribers4: 4000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.red),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.red[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.red[100]),
  );

  SubscriberSeries1 _item22 = SubscriberSeries1(
    month: "May",
    subscribers1: 1000,
    subscribers2: 1750,
    subscribers3: 3500,
    subscribers4: 4000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.red),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.red[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.red[100]),
  );

  SubscriberSeries1 _item23 = SubscriberSeries1(
    month: "Jun",
    subscribers1: 300,
    subscribers2: 500,
    subscribers3: 1500,
    subscribers4: 1750,
    barColor1: charts.ColorUtil.fromDartColor(Colors.red),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.red[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.red[100]),
  );

  SubscriberSeries1 _item24 = SubscriberSeries1(
    month: "Jul",
    subscribers1: 800,
    subscribers2: 1500,
    subscribers3: 1000,
    subscribers4: 3750,
    barColor1: charts.ColorUtil.fromDartColor(Colors.red),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.red[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.red[100]),
  );

  SubscriberSeries1 _item25 = SubscriberSeries1(
    month: "Aug",
    subscribers1: 2300,
    subscribers2: 3500,
    subscribers3: 1700,
    subscribers4: 2750,
    barColor1: charts.ColorUtil.fromDartColor(Colors.red),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.red[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.red[100]),
  );

  SubscriberSeries1 _item26 = SubscriberSeries1(
    month: "Sep",
    subscribers1: 2700,
    subscribers2: 3500,
    subscribers3: 4000,
    subscribers4: 3000,
    barColor1: charts.ColorUtil.fromDartColor(Colors.red),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.red[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.red[100]),
  );

  SubscriberSeries1 _item27 = SubscriberSeries1(
    month: "Oct",
    subscribers1: 3500,
    subscribers2: 3500,
    subscribers3: 3500,
    subscribers4: 3500,
    barColor1: charts.ColorUtil.fromDartColor(Colors.red),
    barColor2: charts.ColorUtil.fromDartColor(Colors.red[300]),
    barColor3: charts.ColorUtil.fromDartColor(Colors.red[200]),
    barColor4: charts.ColorUtil.fromDartColor(Colors.red[100]),
  );

  @override
  void initState() {
    super.initState();

if(datazx.size.shortestSide<600)
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    ij();

    abc();

    getPie();
    print("Width : ${datazx.size.shortestSide}");
  }

  ij() {
    setState(() {
      isLoading = true;
    });
    timestamp = DateTime.now();

    day = DateFormat('EEEE').format(timestamp);
    day1 =
        DateFormat('EEEE').format(DateTime(timestamp.year, timestamp.month, 1));
    dd = weekd.indexOf(day1);

    x = ld[timestamp.month];
    x1 = ld[timestamp.month - 1];
    print(timestamp);
    setState(() {
      isLoading = false;
    });
  }

  abc() {
    mode = "no";
    data = [_item1, _item2, _item3, _item4, _item5];
    data1 = [_item11, _item12, _item13, _item14, _item15, _item16, _item17];
    data2 = [_item21, _item22, _item23, _item24, _item25, _item26, _item27];

    series = [
      charts.Series(
          id: "Expenses",
          data: data,
          domainFn: (SubscriberSeries series, _) => series.month,
          measureFn: (SubscriberSeries series, _) => series.subscribers2,
          colorFn: (SubscriberSeries series, _) => series.barColor2),
      charts.Series(
          id: "Income",
          data: data,
          domainFn: (SubscriberSeries series, _) => series.month,
          measureFn: (SubscriberSeries series, _) => series.subscribers1,
          colorFn: (SubscriberSeries series, _) => series.barColor1),
    ];

    series1 = [
      charts.Series(
          id: "Frame",
          data: data1,
          domainFn: (SubscriberSeries1 series, _) => series.month,
          measureFn: (SubscriberSeries1 series, _) => series.subscribers1,
          colorFn: (SubscriberSeries1 series, _) => series.barColor1),
      charts.Series(
          id: "Coin",
          data: data1,
          domainFn: (SubscriberSeries1 series, _) => series.month,
          measureFn: (SubscriberSeries1 series, _) => series.subscribers2,
          colorFn: (SubscriberSeries1 series, _) => series.barColor2),
      charts.Series(
          id: "Chit",
          data: data1,
          domainFn: (SubscriberSeries1 series, _) => series.month,
          measureFn: (SubscriberSeries1 series, _) => series.subscribers3,
          colorFn: (SubscriberSeries1 series, _) => series.barColor3),
      charts.Series(
          id: "Sales",
          data: data1,
          domainFn: (SubscriberSeries1 series, _) => series.month,
          measureFn: (SubscriberSeries1 series, _) => series.subscribers4,
          colorFn: (SubscriberSeries1 series, _) => series.barColor4),
    ];

    series2 = [
      charts.Series(
          id: "Frame",
          data: data2,
          domainFn: (SubscriberSeries1 series, _) => series.month,
          measureFn: (SubscriberSeries1 series, _) => series.subscribers1,
          colorFn: (SubscriberSeries1 series, _) => series.barColor1),
      charts.Series(
          id: "Coin",
          data: data2,
          domainFn: (SubscriberSeries1 series, _) => series.month,
          measureFn: (SubscriberSeries1 series, _) => series.subscribers2,
          colorFn: (SubscriberSeries1 series, _) => series.barColor2),
      charts.Series(
          id: "Chit",
          data: data2,
          domainFn: (SubscriberSeries1 series, _) => series.month,
          measureFn: (SubscriberSeries1 series, _) => series.subscribers3,
          colorFn: (SubscriberSeries1 series, _) => series.barColor3),
      charts.Series(
          id: "Sales",
          data: data2,
          domainFn: (SubscriberSeries1 series, _) => series.month,
          measureFn: (SubscriberSeries1 series, _) => series.subscribers4,
          colorFn: (SubscriberSeries1 series, _) => series.barColor4),
    ];
  }

  num inc, exp;
  List<String> incT = [];
  List<String> expT = [];

  getPie() async {
    setState(() {
      isLoading = true;
      inc = 0.0;
      exp = 0.0;
      incT = [];
      expT = [];

      dataMap = {};
      colorlist = [];

      dataMap1 = {};
      colorlist1 = [];

      dataMap2 = {};
      colorlist2 = [];
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
            inc += t.amount.toDouble();
            if (!incT.contains(t.cat)) incT.add(t.cat);
          } else {
            exp += t.amount.toDouble();
            if (!expT.contains(t.cat)) expT.add(t.cat);
          }
        });

        incT.forEach((e) {
          dataMap1[e] = 0;
        });
        expT.forEach((e) {
          dataMap2[e] = 0;
        });

        snapshot.documents.forEach((d) {
          Tr t = Tr.fromDocument(d);

          if (t.type == "income") {
            dataMap1[t.cat] = dataMap1[t.cat] + t.amount;
          } else {
            dataMap2[t.cat] = dataMap2[t.cat] + t.amount;
          }
        });

        dataMap = {"Income": inc, "Expenses": exp};
        colorlist = [Colors.blue, Colors.red];

        dataMap1 = Map.fromEntries(dataMap1.entries.toList()
          ..sort((e1, e2) => e1.value.compareTo(e2.value)));

        dataMap2 = Map.fromEntries(dataMap2.entries.toList()
          ..sort((e1, e2) => e1.value.compareTo(e2.value)));

        for (var i = 0; i < dataMap1.length; i++) {
          colorlist1.add(Colors.blue[(i + 1) * 100]);
        }

        for (var i = 0; i < dataMap2.length; i++) {
          colorlist2.add(Colors.red[(i + 1) * 100]);
        }

        print(dataMap1);
        print(dataMap2);
      });
    } else {
      setState(() {
        dataMap = {"Income": 65, "Expenses": 35};
        dataMap1 = {"Sales": 60, "Chit": 20, "Coin": 15, "Frame": 5};
        dataMap2 = {"RTGS": 60, "Cash Bills": 20, "Hasthe": 15, "Petty": 5};
        colorlist = [Colors.blue, Colors.red];
        colorlist1 = [
          Colors.blue[500],
          Colors.blue[300],
          Colors.blue[200],
          Colors.blue[100]
        ];
        colorlist2 = [
          Colors.red,
          Colors.red[300],
          Colors.red[200],
          Colors.red[100]
        ];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Map<String, double> dataMap = {"Income": 65, "Expenses": 135};
  Map<String, double> dataMap1 = {
    "Sales": 60,
    "Chit": 20,
    "Coin": 15,
    "Frame": 5
  };
  Map<String, double> dataMap2 = {
    "RTGS": 60,
    "Cash Bills": 20,
    "Hasthe": 15,
    "Petty": 5
  };
  List<Color> colorlist = [Colors.blue, Colors.red];
  List<Color> colorlist1 = [
    Colors.blue[500],
    Colors.blue[300],
    Colors.blue[200],
    Colors.blue[100]
  ];
  List<Color> colorlist2 = [
    Colors.red,
    Colors.red[300],
    Colors.red[200],
    Colors.red[100]
  ];

  String mode = "no";
  bool scaf = true;

  bcharts() {
    if (mode == "no") return;
  }

  pcharts() {
    if (mode == "no")
      return (incT.isEmpty && expT.isEmpty)
          ? Container(height: 0, width: 0)
          : PieChart(
              chartValueStyle:
                  TextStyle(fontFamily: "Poppins-Regular", color: Colors.black),
              chartValueBackgroundColor: Colors.grey,
              chartRadius: MediaQuery.of(context).size.width * 0.8,
              chartType: ChartType.disc,
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              showChartValues: true,
              showChartValuesInPercentage: true,
              showLegends: false,
              colorList: colorlist,
            );
    else if (mode == "income")
      return (incT.isEmpty)
          ? Container(height: 0, width: 0)
          : PieChart(
              chartValueStyle:
                  TextStyle(fontFamily: "Poppins-Regular", color: Colors.black),
              chartValueBackgroundColor: Colors.grey,
              chartRadius: MediaQuery.of(context).size.width * 0.8,
              chartType: ChartType.disc,
              dataMap: dataMap1,
              animationDuration: Duration(milliseconds: 800),
              showChartValues: true,
              showChartValuesInPercentage: true,
              showLegends: false,
              colorList: colorlist1,
            );
    else if (mode == "expenses")
      return (expT.isEmpty)
          ? Container(height: 0, width: 0)
          : PieChart(
              chartValueStyle:
                  TextStyle(fontFamily: "Poppins-Regular", color: Colors.black),
              chartValueBackgroundColor: Colors.grey,
              chartRadius: MediaQuery.of(context).size.width * 0.8,
              chartType: ChartType.disc,
              dataMap: dataMap2,
              animationDuration: Duration(milliseconds: 800),
              showChartValues: true,
              showChartValuesInPercentage: true,
              showLegends: false,
              colorList: colorlist2,
            );
  }

  tables() {
    if (mode == "no")
      return (incT.isEmpty && expT.isEmpty)
          ? Container(height: 0, width: 0)
          : Table(
              border: TableBorder.symmetric(
                inside: BorderSide(width: 2),
              ),
              children: [
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(width: 10),
                                Container(
                                    height: 20, width: 20, color: Colors.blue),
                                Container(width: 20),
                                Text(
                                  'Income',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.black),
                                ),
                              ]),
                          onTap: () {
                            setState(() {
                              mode = "income";
                            });
                          }),
                    ),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'Rs.${inc.toStringAsFixed(2)}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: "Poppins-Regular",
                                  color: Colors.black),
                            ))),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(width: 10),
                                Container(
                                    height: 20, width: 20, color: Colors.red),
                                Container(width: 20),
                                Text(
                                  'Expenses',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: "Poppins-Regular",
                                      color: Colors.black),
                                ),
                              ]),
                          onTap: () {
                            setState(() {
                              mode = "expenses";
                            });
                          }),
                    ),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'Rs.${exp.toStringAsFixed(2)}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: "Poppins-Regular",
                                  color: Colors.black),
                            ))),
                  ]),
                ]);
    else if (mode == "income")
      return (incT.isEmpty)
          ? Container(height: 0, width: 0)
          : Table(
              border: TableBorder.symmetric(
                inside: BorderSide(width: 2),
              ),
              columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                },
              children: [
                  for (var i = dataMap1.length - 1; i >= 0; i--)
                    TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(width: 10),
                              Container(
                                  height: 20, width: 20, color: colorlist1[i]),
                              Container(width: 20),
                              Text(
                                dataMap1.keys.toList()[i],
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.black),
                              ),
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Rs.${dataMap1.values.toList()[i].toStringAsFixed(2)}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.black),
                              ))),
                    ]),
                ]);
    else if (mode == "expenses")
      return (expT.isEmpty)
          ? Container(height: 0, width: 0)
          : Table(
              border: TableBorder.symmetric(
                inside: BorderSide(width: 2),
              ),
              columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                },
              children: [
                  for (var i = dataMap2.length - 1; i >= 0; i--)
                    TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(width: 10),
                              Container(
                                  height: 20, width: 20, color: colorlist2[i]),
                              Container(width: 20),
                              Text(
                                dataMap2.keys.toList()[i],
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.black),
                              ),
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Rs.${dataMap2.values.toList()[i].toStringAsFixed(2)}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.black),
                              ))),
                    ]),
                ]);
  }

  tit() {
    if (mode == "no")
      return "Overall";
    else
      return "";
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

  cal() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.only(top: 60, right: 15),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 261,
                    height: 296,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  print("next");

                                  calM ? cha(-1, 0, 0) : cha(0, -1, 0);
                                });
                              },
                              child: Icon(Icons.chevron_left,
                                  color: Colors.grey, size: 30)),
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
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins-Regular"),
                                ),
                                (calM)
                                    ? Container(height: 0, width: 0)
                                    : Icon(Icons.expand_more,
                                        color: Colors.grey, size: 20),
                              ])),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  print("next");

                                  calM ? cha(1, 0, 0) : cha(0, 1, 0);
                                });
                              },
                              child: Icon(Icons.chevron_right,
                                  color: Colors.grey, size: 30))
                        ],
                      ),
                      Container(height: 5),
                      (calM)
                          ? Column(children: [
                              for (var i = 0; i < 4; i++)
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      for (var j = 0; j < 3; j++)
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                cha(
                                                    0,
                                                    ((j + 1) + (i * 3)) -
                                                        timestamp.month,
                                                    0);
                                                calM = !calM;
                                              });
                                            },
                                            child: display(i, j)),
                                    ]),
                            ])
                          : Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (int z = 0; z < 7; z++)
                                      Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          elevation: 0.0,
                                          child: Container(
                                              height: 25,
                                              width: 25,
                                              padding: EdgeInsets.all(1),
                                              child: Text(
                                                weekd[z].substring(0, 3),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Poppins-Regular"),
                                              ))),
                                  ]),
                              for (var i = 0; i < 6; i++)
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      for (var j = 0; j < 7; j++)
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              setState(() {
                                                if (((j + 1) + (i * 7) - dd) <=
                                                    0) {
                                                  isTap = x1 +
                                                      ((j + 1) + (i * 7) - dd);
                                                  cha(0, -1, isTap);
                                                } else if (((j + 1) +
                                                        (i * 7) -
                                                        dd) <=
                                                    x) {
                                                  isTap =
                                                      ((j + 1) + (i * 7) - dd);
                                                  cha(0, 0, isTap);
                                                } else {
                                                  isTap =
                                                      ((j + 1) + (i * 7) - dd) -
                                                          x;
                                                  cha(0, 1, isTap);
                                                }

                                                tapDate = timestamp;
                                              });
                                              print(DateTime(
                                                  timestamp.year,
                                                  timestamp.month,
                                                  ((j + 1) + (i * 7))));

                                              //  Navigator.pop(context);

                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            child: display(i, j)),
                                    ]),
                            ]),
                    ]),
                  )),
            );
          });
        });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: (scaf)
                    ? IconButton(
                        icon: Icon(Icons.menu,
                            size: 40,
                            color: Colors.black), // change this size and style
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      )
                    : GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Image.asset('images/Arrow.png', height: 24)),
                        onTap: () {
                          setState(() {
                            scaf = !scaf;
                          });
                        },
                      ),
                actions: [
                  (scaf == false)
                      ? GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Image.asset('images/Calendar.png',
                                  height: 35)),
                          onTap: () {
                            // cal();
                            setState(() {
                              yes = !yes;
                            });
                          })
                      : GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Image.asset(
                                  'images/Vertical Bar Chart.png',
                                  height: 35)),
                          onTap: () {
                            setState(() {
                              scaf = !scaf;
                            });
                          })
                ],
                title: Text(
                    (scaf == true)
                        ? "${appTitle(0)}"
                        : ((appTitle(0) == "Charts"
                            ? "Overall"
                            : "${appTitle(0)}")),
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        fontSize: 28,
                        color: Colors.black)),
                centerTitle: true),
            body: Stack(children: [
              (isLoading)
                  ? circularProgress()
                  : (scaf)
                      ? ListView(padding: EdgeInsets.all(4), children: [
                          ((mode == "no")
                                  ? (incT.isEmpty && expT.isEmpty)
                                  : (mode == "income")
                                      ? incT.isEmpty
                                      : expT.isEmpty)
                              ? Container(height: 0, width: 0)
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 12),
                                        child: Text(tit(),
                                            style: TextStyle(
                                                fontFamily: "Poppins-Regular",
                                                fontSize: 25,
                                                color: Colors.black))),
                                    GestureDetector(
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                                'images/Calendar.png',
                                                height: 35)),
                                        onTap: () {
                                          setState(() {
                                            yes = !yes;
                                          });
                                        })
                                  ],
                                ),
                          ((mode == "no")
                                  ? (incT.isEmpty && expT.isEmpty)
                                  : (mode == "income")
                                      ? incT.isEmpty
                                      : expT.isEmpty)
                              ? Column(children: [
                                  Container(height: 170),
                                  Center(
                                      child: Image.asset('images/pie.png',
                                          height: 128)),
                                  Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Text(
                                          "Chart Analysis available only after " +
                                              ((mode == "no")
                                                  ? "updating accounts!!"
                                                  : (mode == "income")
                                                      ? "adding income!!"
                                                      : "adding expenses!!"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Poppins-Regular",
                                              fontSize: 25,
                                              color: Colors.black))),
                                ])
                              : Container(height: 0, width: 0),
                          pcharts(),
                          ((mode == "no")
                                  ? (incT.isEmpty && expT.isEmpty)
                                  : (mode == "income")
                                      ? incT.isEmpty
                                      : expT.isEmpty)
                              ? Container(height: 0, width: 0)
                              : Container(
                                  width: 120.0,
                                  height: 100.0,
                                  alignment: Alignment.center,
                                  child: RaisedButton(
                                    child: Text(
                                      "01-${month[timestamp.month]}-${timestamp.year} to ${ld[timestamp.month]}-${month[timestamp.month]}-${timestamp.year}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Poppins-Regular"),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.grey[400],
                                    onPressed: () {
                                      setState(() {
                                        yes = !yes;
                                      });
                                    },
                                  )),
                          ((mode == "no")
                                  ? (incT.isEmpty && expT.isEmpty)
                                  : (mode == "income")
                                      ? incT.isEmpty
                                      : expT.isEmpty)
                              ? Container(height: 0, width: 0)
                              : Padding(
                                  padding: EdgeInsets.only(left: 32, right: 32),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: tables())),
                        ])
                      : Column(
                          children: [
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                padding: EdgeInsets.all(16),
                                child: charts.BarChart(
                                  (mode == "no")
                                      ? series
                                      : ((mode == "income")
                                          ? series1
                                          : series2),
                                  barGroupingType: (mode == "no")
                                      ? charts.BarGroupingType.grouped
                                      : charts.BarGroupingType.stacked,
                                  animate: true,
                                  domainAxis: new charts.OrdinalAxisSpec(
                                      renderSpec:
                                          new charts.SmallTickRendererSpec(
                                    // Tick and Label styling here.
                                    labelStyle: new charts.TextStyleSpec(
                                        // size in Pts.

                                        fontFamily: "Poppins-Regular",
                                        color: charts.ColorUtil.fromDartColor(
                                            Colors.grey[700])),

                                    axisLineStyle: new charts.LineStyleSpec(
                                        // size in Pts.

                                        color: charts.ColorUtil.fromDartColor(
                                            Colors.grey[400])),
                                    tickLengthPx: 0,

                                    // Change the line colors to match text color.
                                  )),
                                  primaryMeasureAxis: charts.NumericAxisSpec(
                                      showAxisLine: true,
                                      renderSpec:
                                          new charts.GridlineRendererSpec(
                                        // Tick and Label styling here.
                                        labelStyle: new charts.TextStyleSpec(
                                            // size in Pts.

                                            fontFamily: "Poppins-Regular",
                                            color:
                                                charts.ColorUtil.fromDartColor(
                                                    Colors.grey[700])),

                                        lineStyle: new charts.LineStyleSpec(
                                            // size in Pts.
                                            dashPattern: [4, 4],
                                            color:
                                                charts.ColorUtil.fromDartColor(
                                                    Colors.grey[400])),

                                        axisLineStyle: new charts.LineStyleSpec(
                                            // size in Pts.

                                            color:
                                                charts.ColorUtil.fromDartColor(
                                                    Colors.grey[400])),
                                        tickLengthPx: 0,

                                        // Change the line colors to match text color.
                                      ),
                                      tickProviderSpec:
                                          charts.BasicNumericTickProviderSpec(
                                              desiredTickCount: 6),
                                      tickFormatterSpec:
                                          charts.BasicNumericTickFormatterSpec(
                                              (num value) {
                                        if (value == 0)
                                          return '0';
                                        else
                                          return '${value ~/ 1000}K';
                                      }),
                                      viewport: (mode == "no")
                                          ? charts.NumericExtents(0, 50000)
                                          : charts.NumericExtents(0, 15000)),
                                )),
                            Padding(
                                padding: EdgeInsets.only(left: 50, right: 50),
                                child: Container(
                                  child: Table(children: [
                                    TableRow(children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(width: 10),
                                              Container(
                                                  height: 15,
                                                  width: 15,
                                                  color: (mode == "expenses")
                                                      ? Colors.red
                                                      : Colors.blue),
                                              Container(width: 10),
                                              Text(
                                                (mode == "no")
                                                    ? 'Income'
                                                    : ((mode == "income")
                                                        ? "Sales"
                                                        : "RTGS"),
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily:
                                                        "Poppins-Regular",
                                                    color: Colors.black),
                                              ),
                                            ]),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(width: 10),
                                              Container(
                                                  height: 15,
                                                  width: 15,
                                                  color: (mode == "no")
                                                      ? Colors.red
                                                      : ((mode == "income")
                                                          ? Colors.blue[300]
                                                          : Colors.red[300])),
                                              Container(width: 10),
                                              Text(
                                                (mode == "no")
                                                    ? 'Expenses'
                                                    : ((mode == "income")
                                                        ? "Chit"
                                                        : "Cash Bills"),
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily:
                                                        "Poppins-Regular",
                                                    color: Colors.black),
                                              ),
                                            ]),
                                      ),
                                    ]),
                                    (mode == "no")
                                        ? TableRow(children: [
                                            Container(width: 0, height: 0),
                                            Container(width: 0, height: 0)
                                          ])
                                        : TableRow(children: [
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(width: 10),
                                                    Container(
                                                        height: 15,
                                                        width: 15,
                                                        color: (mode ==
                                                                "income")
                                                            ? Colors.blue[200]
                                                            : Colors.red[200]),
                                                    Container(width: 10),
                                                    Text(
                                                      (mode == "income")
                                                          ? "Coin"
                                                          : "Hasthe",
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontFamily:
                                                              "Poppins-Regular",
                                                          color: Colors.black),
                                                    ),
                                                  ]),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(width: 10),
                                                    Container(
                                                        height: 15,
                                                        width: 15,
                                                        color: (mode ==
                                                                "income")
                                                            ? Colors.blue[100]
                                                            : Colors.red[100]),
                                                    Container(width: 10),
                                                    Text(
                                                      (mode == "income")
                                                          ? "Frame"
                                                          : "Petty",
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontFamily:
                                                              "Poppins-Regular",
                                                          color: Colors.black),
                                                    ),
                                                  ]),
                                            ),
                                          ]),
                                  ]),
                                )),
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
                              padding: EdgeInsets.only(right: 20, top: 20),
                              child: Card(
                                  color: Colors.transparent,
                                  elevation: 100,
                                  child: Container(
                                    width: 261,
                                    height: 296,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              child: Icon(Icons.chevron_left,
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
                                                        height: 0, width: 0)
                                                    : Icon(Icons.expand_more,
                                                        color: Colors.grey,
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
                                              child: Icon(Icons.chevron_right,
                                                  color: Colors.grey, size: 30))
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
                                                              setState(() {
                                                                cha(
                                                                    0,
                                                                    ((j + 1) +
                                                                            (i *
                                                                                3)) -
                                                                        timestamp
                                                                            .month,
                                                                    0);
                                                                calM = !calM;
                                                              });
                                                            },
                                                            child:
                                                                display(i, j)),
                                                    ]),
                                            ])
                                          : Column(children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    for (int z = 0; z < 7; z++)
                                                      Card(
                                                          color: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0))),
                                                          elevation: 0.0,
                                                          child: Container(
                                                              height: 25,
                                                              width: 25,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(1),
                                                              child: Text(
                                                                weekd[z]
                                                                    .substring(
                                                                        0, 3),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        "Poppins-Regular"),
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
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              setState(() {
                                                                if (((j + 1) +
                                                                        (i *
                                                                            7) -
                                                                        dd) <=
                                                                    0) {
                                                                  isTap = x1 +
                                                                      ((j + 1) +
                                                                          (i *
                                                                              7) -
                                                                          dd);
                                                                  cha(0, -1,
                                                                      isTap);
                                                                } else if (((j +
                                                                            1) +
                                                                        (i *
                                                                            7) -
                                                                        dd) <=
                                                                    x) {
                                                                  isTap = ((j +
                                                                          1) +
                                                                      (i * 7) -
                                                                      dd);
                                                                  cha(0, 0,
                                                                      isTap);
                                                                } else {
                                                                  isTap = ((j +
                                                                              1) +
                                                                          (i *
                                                                              7) -
                                                                          dd) -
                                                                      x;
                                                                  cha(0, 1,
                                                                      isTap);
                                                                }

                                                                tapDate =
                                                                    timestamp;

                                                                yes = !yes;
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

                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            },
                                                            child:
                                                                display(i, j)),
                                                    ]),
                                            ]),
                                    ]),
                                  )))))
                  : Container(height: 0, width: 0),
            ])),
        // ignore: missing_return
        onWillPop: () {
          setState(() {
            if (yes == true)
              yes = !yes;
            else {
              if (mode != "no" && scaf == true) mode = "no";
              if (scaf == false) scaf = !scaf;
            }
          });
        });
  }

  appTitle(x) {
    if (mode == "no")
      return "Charts";
    else if (mode == "income")
      return "Income";
    else if (mode == "expenses") return "Expenses";
  }
}
