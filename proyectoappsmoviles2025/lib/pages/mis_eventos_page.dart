import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyectoappsmoviles2025/constants.dart';

class MisEventosPage extends StatelessWidget {
  final String autor;

  const MisEventosPage({super.key, required this.autor});

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
        title: Text("Mis eventos", style: TextStyle(color: Color(kColorBlanco))),
        backgroundColor: Color(kColorVioleta),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Eventos")
            .where("autor", isEqualTo: autor)
            .orderBy("Fecha")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error al cargar eventos: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final eventos = snapshot.data!.docs;

          if (eventos.isEmpty) {
            return Center(
              child: Text("No has creado eventos aún"),
            );
          }

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, i) {
              final evento = eventos[i].data() as Map<String, dynamic>; 
              final id = eventos[i].id;

              return Slidable(
                key: ValueKey(id),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      icon: Icons.delete,
                      backgroundColor: Color(kColorRosado),
                      label: "Borrar",
                      onPressed: (context) async {
                        final confirmar = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Confirmar borrado"),
                            content: Text(
                              '¿Deseas eliminar el evento "${evento['titulo']}"?',
                            ),
                            actions: [
                              TextButton(
                                child: Text("Cancelar"),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: Text("Borrar"),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );

                        if (confirmar == true) {
                          await FirebaseFirestore.instance
                              .collection("Eventos")
                              .doc(id)
                              .delete();
                        }
                      },
                    ),
                  ],
                ),
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(evento['titulo']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(MdiIcons.calendar, size: 20),
                            SizedBox(width: 6),
                            Text(_formatearFecha(evento['Fecha'])),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(MdiIcons.mapMarker, size: 20),
                            SizedBox(width: 6),
                            Text(evento['lugar']),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(MdiIcons.tag, size: 20),
                            SizedBox(width: 6),
                            Text(evento['categoria']),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
