import 'package:flutter/material.dart';
import 'package:todo/utils/app_constant.dart';

Widget emptyView(String emptyMessage) {
  return new Center(
    child: new Text(emptyMessage,
        style: new TextStyle(fontSize: FONT_MEDIUM, color: Colors.black)),
  );
}
