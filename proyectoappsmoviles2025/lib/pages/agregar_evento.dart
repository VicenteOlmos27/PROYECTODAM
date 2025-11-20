import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyectoappsmoviles2025/constants.dart';
import 'package:proyectoappsmoviles2025/services/fs_services.dart';

class AgregarEvento extends StatefulWidget {
  const AgregarEvento({super.key, required});

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tituloCtrl = TextEditingController();
  TextEditingController fechaCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();

  String? categoriaSeleccionada;
  DateTime? fechaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Evento"),
        backgroundColor: Color(kColorVioleta),
        foregroundColor: Color(kColorBlanco),
      ),

      body: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(kColorNegro),
              Color(kColorRosado),
            ],
          ),
        ),

        child: Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Color(kColorBlanco),
            borderRadius: BorderRadius.circular(15),
          ),

          child: Form(
            key: formKey,
            child: ListView(
              children: [

                //CAMPO TITULO
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(kColorBlanco),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: tituloCtrl,
                    decoration: InputDecoration(
                      labelText: 'Título del evento',
                      border: InputBorder.none,
                    ),
                    validator: (v) => v!.isEmpty ? "Indique un título" : null,
                  ),
                ),

                //CAMPO FECHA
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(kColorBlanco),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: fechaCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha del evento',
                      border: InputBorder.none,
                    ),
                    onTap: () async {
                      DateTime? fecha = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (fecha != null) {
                        TimeOfDay? hora = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (hora != null) {
                          fecha = DateTime(
                            fecha.year,
                            fecha.month,
                            fecha.day,
                            hora.hour,
                            hora.minute,
                          );

                          setState(() {
                            fechaSeleccionada = fecha;
                            fechaCtrl.text =
                                "${fecha?.day}/${fecha?.month}/${fecha?.year} ${hora.format(context)}";
                          });
                        }
                      }
                    },
                    validator: (v) => v!.isEmpty ? "Indique la fecha" : null,
                  ),
                ),

                //CAMPO LUGAR
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(kColorBlanco),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: lugarCtrl,
                    decoration: InputDecoration(
                      labelText: 'Lugar',
                      border: InputBorder.none,
                    ),
                    validator: (v) => v!.isEmpty ? "Indique el lugar" : null,
                  ),
                ),

                //MOSTRAR EL CAMPO CATEGORIA
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(kColorBlanco),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FutureBuilder(
                    future: FsService().categorias(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Cargando categorías...");
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text("No hay categorías");
                      }

                      final categorias = snapshot.data!.docs;

                      return DropdownButtonFormField(
                        value: categoriaSeleccionada,
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          border: InputBorder.none,
                        ),
                        items: categorias.map((c) {
                          final foto = c['Foto'];
                          return DropdownMenuItem(
                            value: c['categoria'].toString(),
                            child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(c['categoria']),
                                Image.asset("assets/images/$foto", width: 32,height: 32,fit: BoxFit.cover), 
                              ],
                            )
                          );
                        }).toList(),
                        validator: (v) => v == null ? "Seleccione una categoría" : null,
                        onChanged: (valor) {
                          categoriaSeleccionada = valor.toString();
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 12),

                //BOTON GUARDAR
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Color(kColorVioleta),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    await FsService().agregarEvento(
                      fechaSeleccionada!,
                      categoriaSeleccionada!,
                      lugarCtrl.text.trim(),
                      tituloCtrl.text.trim(),
                    );

                    Navigator.pop(context);
                  },
                  child: Text(
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
}
