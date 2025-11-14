// -------------------- PAGINA DE INICIO --------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectoappsmoviles2025/pages/detalle_evento.dart';
import 'package:proyectoappsmoviles2025/pages/mis_eventos_page.dart';
import 'package:proyectoappsmoviles2025/pages/pagina_login.dart';
import 'package:proyectoappsmoviles2025/utils/apps_utils.dart';

import 'agregar_evento.dart';

class PaginaInicio extends StatelessWidget {
  final User usuario;
  const PaginaInicio({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -------------------- APPBAR --------------------
      appBar: AppBar(
        title: const Text("Eventos", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade400,
                Colors.indigo.shade500,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "mis_eventos",
                child: Text("Mis eventos"),
              ),
              const PopupMenuItem(
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

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaLogin()),
                );
              }
            },
          ),
        ],
      ),

      // -------------------- CUERPO --------------------
      body: Column(
        children: [
          // -------------------- HEADER USUARIO --------------------
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo.shade700,
                  Colors.indigo.shade400,
                ],
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.white, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    usuario.email ?? "Usuario desconocido",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),

          // -------------------- LISTA DE EVENTOS --------------------
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Eventos')
                  .orderBy('Fecha')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text("Error al cargar eventos"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final eventos = snapshot.data!.docs;

                if (eventos.isEmpty) {
                  return const Center(
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
                    final id = eventos[index].id;

                    return Slidable(
                      key: ValueKey(id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            label: "Borrar",
                            onPressed: (context) async {
                              bool aceptaBorrar = await AppsUtils.mostrarConfirmacion(
                                context,
                                'Confirmar Borrado',
                                '¿Deseas borrar el evento "${evento['titulo']}"?',
                              );

                              if (aceptaBorrar) {
                                await FirebaseFirestore.instance
                                    .collection('Eventos')
                                    .doc(id)
                                    .delete();

                      
                              }
                            },
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade300,
                            child: const Icon(Icons.event, color: Colors.white),
                          ),
                          title: Text(
                            evento['titulo'] ?? "Sin título",
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                              builder: (context) => DetalleEvento(evento: evento),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // -------------------- BOTÓN FLOTANTE --------------------
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
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
