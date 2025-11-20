import 'package:flutter/material.dart';
import 'package:proyectoappsmoviles2025/pages/mis_eventos_page.dart';
import 'package:proyectoappsmoviles2025/pages/pagina_inicio.dart';
import 'package:proyectoappsmoviles2025/pages/agregar_evento.dart';
import 'package:proyectoappsmoviles2025/constants.dart';

class BasePage extends StatefulWidget {

  const BasePage({super.key, required});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _paginaSeleccionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _paginaSeleccionada,
        children: [
          PaginaInicio(),
          MisEventosPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaSeleccionada,
        onTap: (index) {
          setState(() {
            _paginaSeleccionada = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Mis eventos',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(kColorVioleta),
        foregroundColor: Color(kColorBlanco),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarEvento(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
