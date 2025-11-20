import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyectoappsmoviles2025/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetalleEvento extends StatelessWidget {
  final Map<String, dynamic> evento;

  const DetalleEvento({super.key, required this.evento});

  String _formatearFecha(dynamic fechaRaw) {
    try {
      if (fechaRaw is Timestamp) {
        final fecha = fechaRaw.toDate();
        return DateFormat('dd/MM/yyyy HH:mm').format(fecha);
      }

      if (fechaRaw is String) {
        return fechaRaw;
      }

      return "Fecha no válida";
    } catch (e) {
      return "Fecha no válida";
    }
  }

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
      body: Center(
        child: Container(
          width: 330,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(kColorBlanco),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Color(kColorNegro),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(MdiIcons.textBoxOutline, size: 28),
                  SizedBox(width: 8),
                  Text(evento['titulo'],style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(MdiIcons.calendar, size: 22),
                  SizedBox(width: 8),
                  Text("Fecha: ${_formatearFecha(evento['Fecha'])}",style: TextStyle(fontSize: 16),),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(MdiIcons.mapMarker, size: 22),
                  SizedBox(width: 8),
                  Text("Lugar: ${evento['lugar']}",style: TextStyle(fontSize: 16),),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(MdiIcons.tag, size: 22),
                  SizedBox(width: 8),
                  Text("Categoría: ${evento['categoria']}",style: TextStyle(fontSize: 16),),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(MdiIcons.account, size: 22),
                  SizedBox(width: 8),
                  Text("Autor: ${evento['autor']}",style: TextStyle(fontSize: 13),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
