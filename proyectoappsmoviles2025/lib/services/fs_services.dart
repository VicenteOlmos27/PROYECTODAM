import 'package:cloud_firestore/cloud_firestore.dart';

class FsService{
  
  //OBTENER TODOS LOS EVENTOS
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('Eventos').snapshots();
  }

    //AGREGAR EVENTO
Future<void> agregarEvento(
  String fecha,
  String autor,
  String categoria,
  String lugar,
  String titulo,
) {
  return FirebaseFirestore.instance.collection('Eventos').doc().set({
    'Fecha' : fecha,
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
