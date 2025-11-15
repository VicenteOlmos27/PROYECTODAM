import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectoappsmoviles2025/constants.dart';
import 'package:proyectoappsmoviles2025/pages/detalle_evento.dart';
import 'package:proyectoappsmoviles2025/pages/mis_eventos_page.dart';
import 'package:proyectoappsmoviles2025/services/auth_services.dart';
import 'agregar_evento.dart';

class PaginaInicio extends StatelessWidget {
  final User usuario;
  const PaginaInicio({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos", style: TextStyle(color: Color(kColorBlanco)),),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(kColorNegro),
                Color(kColorRosado),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "mis_eventos",
                child: Text("Mis eventos"),
              ),
              PopupMenuItem(
                value: "logout",
                child: Text("Cerrar Sesión"),
              ),
            ],
            onSelected: (value) async {
              if (value == "mis_eventos") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MisEventosPage(autor: usuario.email!),
                  ),
                );
              }

              if (value == "logout") {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),

      body: Column(
        children: [
          //HEADER DEL USUARIO
          Container(
              padding: EdgeInsets.all(10),
              color: Color(kColorVioleta),
              width: double.infinity,
              child: FutureBuilder<User?>(
                future: AuthService().currentUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Cargando usuario...',
                      style: TextStyle(color: Color(kColorBlanco)),
                    );
                  }
                  return Row(
                    children: [
                      Icon(Icons.person, color: Color(kColorBlanco), size: 30),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          snapshot.data!.email ?? "Usuario desconocido",
                          style: TextStyle(color: Color(kColorBlanco), fontSize: 16),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          //LISTAR LOS EVENTOS
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Eventos')
                  .orderBy('Fecha')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error al cargar eventos"));
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final eventos = snapshot.data!.docs;

                if (eventos.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay eventos aún",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(height: 6),
                  itemCount: eventos.length,
                  itemBuilder: (context, index) {
                  final evento = eventos[index].data() as Map<String, dynamic>? ?? {};
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(kColorBlanco),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Color(kColorNegro),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade300,
                          child: Icon(Icons.event, color: Colors.white),
                        ),
                        title: Text(
                          evento['titulo'] ?? "Sin título",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("🏷 ${evento['categoria'] ?? "Sin categoría"}"),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalleEvento(evento: evento),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AgregarEvento(autor: usuario.email ?? "desconocido"),
            ),
          );
        },
      ),
    );
  }
}
