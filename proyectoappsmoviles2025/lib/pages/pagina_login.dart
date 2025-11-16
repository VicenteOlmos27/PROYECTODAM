import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:proyectoappsmoviles2025/constants.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _cargando = false;

  Future<void> iniciarSesionConGoogle() async {
  setState(() {
    _cargando = true;
  });

  try {
    final cuentaGoogle = await _googleSignIn.signIn();
    if (cuentaGoogle == null) return; //SI EL USUARIO CANCELA EL LOGIN

    final autenticacionGoogle = await cuentaGoogle.authentication;

    final credencial = GoogleAuthProvider.credential(
      accessToken: autenticacionGoogle.accessToken,
      idToken: autenticacionGoogle.idToken,
    );

    await _auth.signInWithCredential(credencial);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al iniciar sesión: $e')),
    );
  } finally {
    if (mounted) {
      setState(() {
        _cargando = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(kColorNegro), Color(kColorRosado)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animado o icono grande
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Icon(
                    MdiIcons.calendar,
                    size: 120,
                    color: Color(kColorBlanco),
                  ),
                ),
                // Texto motivador
                Text(
                  "CreaTuEvento.com",
                  style: TextStyle(
                    color: Color(kColorBlanco),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                _cargando
                    ? CircularProgressIndicator(color: Color(kColorBlanco))
                    : ElevatedButton.icon(
                        icon: Icon(Icons.login),
                        label: Text(
                          "Iniciar sesión con Google",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(kColorBlanco),
                          foregroundColor: Color(kColorNegro),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: iniciarSesionConGoogle,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
