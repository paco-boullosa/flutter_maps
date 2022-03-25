import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: const Text('Espere un momento'),
          content: Container(
            width: 100,
            height: 70,
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              children: const [
                Text('Calculando ruta...'),
                SizedBox(height: 12),
                CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
              ],
            ),
          )),
    );
    return;
  } else {
    showCupertinoDialog(
      context: context,
      builder: (context) => const CupertinoAlertDialog(
        title: Text('Espere un momento'),
        content: CupertinoActivityIndicator(),
      ),
    );
  }
}
