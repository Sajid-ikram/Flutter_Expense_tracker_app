import 'dart:io';
import 'package:flutter/cupertino.dart';

class DataSample {
  final int id;
  final String title;
  final DateTime datetime;
  final double price;
  final String description;

  DataSample({
    @required this.id,
    @required this.datetime,
    @required this.title,
    @required this.price,
    @required this.description,
  });

  Map<String, dynamic> toMap() {

    return {
      'title': title,
      'description': description,
      'datetime': datetime.toIso8601String(),
      'price': price,
    };
  }
}


