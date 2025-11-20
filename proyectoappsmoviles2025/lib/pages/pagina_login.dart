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

  Future<void> iniciarConGoogle() async {
    final cuenta = await _googleSignIn.signIn();
    if (cuenta == null) return;

    final autenticacionGoogle = await cuenta.authentication;

    final credencial = GoogleAuthProvider.credential(
      accessToken: autenticacionGoogle.accessToken,
      idToken: autenticacionGoogle.idToken,
    );
    await _auth.signInWithCredential(credencial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(kColorNegro), Color(kColorRosado)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(MdiIcons.calendar, size: 120, color: Color(kColorBlanco)),
              SizedBox(height: 20),
              Text(
                "CreaTuEvento.com",
                style: TextStyle(
                  color: Color(kColorBlanco),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton.icon(
                      icon: Icon(Icons.login),
                      label: Text("Iniciar sesión con Google"),
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Color(kColorBlanco),
                      foregroundColor: Color(kColorNegro),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                onPressed: iniciarConGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
