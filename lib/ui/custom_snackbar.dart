import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    Key? key,
    required String mensaje,
    String btnLabel = 'OK',
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onOk,
  }) : super(
          key: key,
          content: Text(mensaje),
          duration: duration,
          action: SnackBarAction(
            label: btnLabel,
            onPressed: () {
              if (onOk != null) {
                onOk();
              }
            },
          ),
        );
}
