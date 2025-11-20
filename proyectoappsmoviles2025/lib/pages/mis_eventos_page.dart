import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyectoappsmoviles2025/constants.dart';
import 'package:proyectoappsmoviles2025/services/fs_services.dart';
import 'package:proyectoappsmoviles2025/utils/apps_utils.dart';  

class MisEventosPage extends StatelessWidget {

  const MisEventosPage({super.key, required});

   String _formatearFecha(Timestamp fecha) {
    return DateFormat('dd/MM/yyyy').format(fecha.toDate());
  }

  @override
  Widget build(BuildContext context) {
    final autor = FirebaseAuth.instance.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        title:
        Text("Mis eventos", style: TextStyle(color: Color(kColorBlanco))),
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

          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final eventos = snapshot.data!.docs;

          if (eventos.isEmpty) {
            return Center(child: Text("No has creado eventos aún"));
          }

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, i) {
              var doc = eventos[i];
              var evento = doc.data() as Map<String, dynamic>;
              var id = doc.id;
             return Slidable(
                key: ValueKey(id),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Color(kColorRosado),
                      icon: Icons.delete,
                      label: "Borrar",

                      onPressed: (context) async {
                        var confirmar = await AppsUtils.mostrarConfirmacion(
                          context, 
                          "Confirmar borrado",
                          '¿Deseas eliminar el evento "${evento['titulo']}"?',
                        );
                        if (confirmar) {
                          await FsService().borrarEventos(id);
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
