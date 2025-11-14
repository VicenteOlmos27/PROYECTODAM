import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyectoappsmoviles2025/pages/pagina_inicio.dart';


class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? usuario;

  @override
  void initState() {
    super.initState();
    usuario = _auth.currentUser;
    // Si ya hay usuario logueado, ir directo a la pantalla de inicio
    if (usuario != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaginaInicio(usuario: usuario!),
          ),
        );
      });
    }
  }

  Future<void> iniciarSesionConGoogle() async {
    final cuentaGoogle = await _googleSignIn.signIn();
    if (cuentaGoogle == null) return; // Canceló el login

    final autenticacionGoogle = await cuentaGoogle.authentication;

    final credencial = GoogleAuthProvider.credential(
      accessToken: autenticacionGoogle.accessToken,
      idToken: autenticacionGoogle.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credencial);
    usuario = userCredential.user;

    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaginaInicio(usuario: usuario!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DAM 2025"),
        backgroundColor: const Color.fromARGB(255, 169, 164, 216),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Iniciar sesión con Google"),
          onPressed: iniciarSesionConGoogle,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}
