import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyectoappsmoviles2025/constants.dart';
import 'package:proyectoappsmoviles2025/pages/detalle_evento.dart';
import 'package:proyectoappsmoviles2025/services/fs_services.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser; 
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos", style: TextStyle(color: Color(kColorBlanco))),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(kColorNegro), Color(kColorRosado)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: "logout", child: Text("Cerrar Sesión")),
            ],
            onSelected: (value) async {
              if (value == "logout") {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Color(kColorVioleta),
            width: double.infinity,
            child: Row(
              children: [
                Icon(Icons.person, color: Color(kColorBlanco), size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    usuario?.email ?? "Usuario desconocido",
                    style: TextStyle(
                      color: Color(kColorBlanco),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LISTA DE EVENTOS
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FsService().eventos(), 
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error al cargar eventos"));
                }

                final eventos = snapshot.data!.docs;

                if (eventos.isEmpty) {
                  return Center(
                    child: Text("No hay eventos aún",
                        style: TextStyle(fontSize: 16)),
                  );
                }

                return ListView.separated(
                  itemCount: eventos.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    var evento = eventos[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Icon(Icons.event, color: Color(kColorRosado)),
                      title: Text(evento['titulo']),
                      subtitle: Row(
                        children: [
                          Icon(MdiIcons.tag, color: Color(kColorVioleta), size: 15,),
                          Text(evento['categoria']),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleEvento(evento: evento),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
