import 'package:flutter/material.dart';

class AppsUtils {

   static Future<bool> mostrarConfirmacion(
    BuildContext context,
    String titulo,
    String mensaje,
  ) async {
    final resultado = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          iconColor: Colors.white,
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: Text('CANCELAR'),
              onPressed: () => Navigator.pop(context, false),
            ),
            OutlinedButton(
              child: Text('ACEPTAR'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    return resultado ?? false;
  }
}