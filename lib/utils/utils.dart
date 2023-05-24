import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

showDialogMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Dismiss'),
          ),
        ],
      );
    },
  );
}

Future<void> saveToSharedPreference(String key, dynamic value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (value is String) {
    preferences.setString(key, value);
  } else if (value is bool) {
    preferences.setBool(key, value);
  } else if (value is double) {
    preferences.setDouble(key, value);
  } else if (value is int) {
    preferences.setInt(key, value);
  } else if (value is List<String>) {
    preferences.setStringList(key, value);
  }
}

Future<dynamic> getFromSharedPreference(String key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.get(key);
}
