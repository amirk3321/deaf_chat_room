import 'package:flutter/material.dart';

void snackBar({String msg, GlobalKey<ScaffoldState> scaffoldState}) {
  scaffoldState.currentState.showSnackBar(
    SnackBar(
      duration: Duration(seconds: 1),
      content: Text(msg),
    ),
  );
}

void snackBarError({String msg, GlobalKey<ScaffoldState> scaffoldState}) {
  scaffoldState.currentState.showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(msg),
          Icon(Icons.warning_amber_sharp)
        ],
      ),
    ),
  );
}