import 'package:cloud_firestore/cloud_firestore.dart';

class Sett {
  final List<dynamic> cat;
  final List<dynamic> supp;
  final List<dynamic> acc;

  Sett({
    this.cat,
    this.supp,
    this.acc,
  });

  factory Sett.fromDocument(DocumentSnapshot doc) {
    return Sett(
      cat: doc['cat'],
      supp: doc['supp'],
      acc: doc['acc'],
    );
  }
}

class Tr {
  final String type;
  final Timestamp date;
  final num amount;
  final String cat;
  final String id;
  final String acc;
  final String tag;
  final String note;

  Tr(
      {this.type,
      this.date,
      this.amount,
      this.cat,
      this.id,
      this.acc,
      this.tag,
      this.note});

  factory Tr.fromDocument(DocumentSnapshot doc) {
    return Tr(
      type: doc['type'],
      date: doc['date'],
      amount: doc['amount'],
      cat: doc['cat'],
      id: doc['id'],
      acc: doc['acc'],
      tag: doc['tag'],
      note: doc['note'],
    );
  }
}

class Bill {
  final String type;
  final Timestamp date;
  final num gross;
  final num touch;
  final String id;
  final num net;
  final num mc;
  final String name;

  Bill(
      {this.type,
      this.date,
      this.gross,
      this.touch,
      this.id,
      this.net,
      this.mc,
      this.name});

  factory Bill.fromDocument(DocumentSnapshot doc) {
    return Bill(
      type: doc['type'],
      date: doc['date'],
      gross: doc['gross'],
      touch: doc['touch'],
      id: doc['id'],
      net: doc['net'],
      mc: doc['mc'],
      name: doc['name'],
    );
  }
}
