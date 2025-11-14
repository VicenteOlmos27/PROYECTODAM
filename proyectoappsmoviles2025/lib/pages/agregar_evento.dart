import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyectoappsmoviles2025/services/fs_services.dart';

class AgregarEvento extends StatefulWidget {
  final String autor;
  const AgregarEvento({super.key, required this.autor});

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  final formKey = GlobalKey<FormState>();

  final tituloCtrl = TextEditingController();
  final fechaCtrl = TextEditingController();
  final lugarCtrl = TextEditingController();
  String? categoriaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Evento")),
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.purple.shade300,
              Colors.deepPurple.shade700,
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xEEFFFFFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                _campo(
                  child: TextFormField(
                    controller: tituloCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Título del evento',
                      border: InputBorder.none,
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Indique un título" : null,
                  ),
                ),

                _campo(
                  child: TextFormField(
                    controller: fechaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Fecha (DD/MM/AAAA hh:mm)',
                      border: InputBorder.none,
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Indique la fecha" : null,
                  ),
                ),

                _campo(
                  child: TextFormField(
                    controller: lugarCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Lugar',
                      border: InputBorder.none,
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Indique el lugar" : null,
                  ),
                ),

                _campo(
                  child: FutureBuilder(
                    future: FsService().categorias(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Cargando categorías...");
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text("No hay categorías");
                        }
                        
                      final categorias = snapshot.data!.docs;

                      return DropdownButtonFormField(
                        value: categoriaSeleccionada,
                        decoration: const InputDecoration(
                          labelText: 'Categoría',
                          border: InputBorder.none,
                        ),
                        items: categorias.map((c) {
                          return DropdownMenuItem(
                            value: c['categoria'].toString(),
                            child: Text(c['categoria']),
                          );
                        }).toList(),
                        validator: (v) => v == null
                            ? "Seleccione una categoría"
                            : null,
                        onChanged: (valor) {
                          categoriaSeleccionada = valor.toString();
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    await FirebaseFirestore.instance
                        .collection("Eventos")
                        .add({
                      "titulo": tituloCtrl.text.trim(),
                      "Fecha": fechaCtrl.text.trim(),
                      "lugar": lugarCtrl.text.trim(),
                      "categoria": categoriaSeleccionada,
                      "autor": widget.autor.trim(),
                    });

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Guardar Evento",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget reutilizable que crea un "campo" visual como en tu ejemplo
  Widget _campo({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
