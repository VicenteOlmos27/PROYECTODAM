import 'package:flutter/material.dart';

class DetalleEvento extends StatelessWidget {
  final Map<String, dynamic> evento;

  const DetalleEvento({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          evento['titulo'],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),

      /// CENTRAR EL CUADRO EN LA PANTALLA
      body: Center(
        child: Container(
          width: 330, // tamaño fijo para verse agradable
          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                evento['titulo'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "📅 Fecha: ${evento['Fecha']}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              Text(
                "📍 Lugar: ${evento['lugar']}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              Text(
                "🏷 Categoría: ${evento['categoria']}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              Text(
                "👤 Autor: ${evento['autor']}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
