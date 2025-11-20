import 'package:flutter/material.dart';
import 'package:proyectoappsmoviles2025/constants.dart';

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
          backgroundColor: Color(kColorVioleta),
          iconColor: Color(kColorBlanco),
          title: Text(titulo, style: TextStyle(color: Color(kColorBlanco)),),
          content: Text(mensaje, style: TextStyle(color: Color(kColorBlanco)),),
          actions: [
            TextButton(
              child: Text('CANCELAR', style: TextStyle(color: Color(kColorBlanco)),),
              onPressed: () => Navigator.pop(context, false),
            ),
            OutlinedButton(
              child: Text('ACEPTAR', style: TextStyle(color: Color(kColorBlanco)),),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    return resultado ?? false;
  }
}