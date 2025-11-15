import 'package:flutter/material.dart';
import 'package:proyectoappsmoviles2025/constants.dart';

class DetalleEvento extends StatelessWidget {
  final Map<String, dynamic> evento;

  DetalleEvento({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          evento['titulo'],
          style: TextStyle(color: Color(kColorBlanco)),
        ),
        backgroundColor: Color(kColorVioleta),
      ),

      /// CENTRAR EL CUADRO EN LA PANTALLA
      body: Center(
        child: Container(
          width: 330, 
          padding: EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evento['titulo'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16),

              Text(
                "Fecha: ${evento['Fecha']}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),

              Text(
                "Lugar: ${evento['lugar']}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),

              Text(
                "Categoría: ${evento['categoria']}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),

              Text(
                "Autor: ${evento['autor']}",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
