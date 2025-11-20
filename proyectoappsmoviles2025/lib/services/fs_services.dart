import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FsService{
  
  //OBTENER TODOS LOS EVENTOS
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('Eventos').snapshots();
  }

    //AGREGAR EVENTO
Future<void> agregarEvento(
  DateTime fecha,
  String categoria,
  String lugar,
  String titulo,
) {
  final autor = FirebaseAuth.instance.currentUser?.email;
  return FirebaseFirestore.instance.collection('Eventos').doc().set({
    'Fecha' : Timestamp.fromDate(fecha),
    'autor': autor,
    'categoria' : categoria,
    'lugar' : lugar,
    'titulo': titulo,
  });
}

//OBTENER LA LISTA DE LAS CATEGORIAS
  Future<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance
        .collection('Categorias')
        .orderBy('categoria')
        .get();
  }

  //BORRAR UN EVENTO
  Future<void> borrarEventos(String id) {
    return FirebaseFirestore.instance.collection('Eventos').doc(id).delete();
  }
}
