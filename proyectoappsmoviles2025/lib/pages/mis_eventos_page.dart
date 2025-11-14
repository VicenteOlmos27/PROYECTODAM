import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MisEventosPage extends StatelessWidget {
  final String autor;

  const MisEventosPage({super.key, required this.autor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis eventos", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
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
            return const Center(child: CircularProgressIndicator());
          }

          final eventos = snapshot.data!.docs;

          if (eventos.isEmpty) {
            return const Center(
              child: Text("No has creado eventos aún"),
            );
          }

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, i) {
              final evento =
                  eventos[i].data() as Map<String, dynamic>? ?? {};

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(evento['titulo']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📅 ${evento['Fecha']}"),
                      Text("📍 ${evento['lugar']}"),
                      Text("🏷 ${evento['categoria']}"),
                    ],
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
