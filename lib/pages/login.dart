import 'package:entrega1/pages/actividades.dart';
import 'package:entrega1/pages/registro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usuarioController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void irARegistro(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Registro()),
    );
  }

  Future<Map<String, String?>> obtenerCredenciales() async {
    final prefs = await SharedPreferences.getInstance();
    final login = prefs.getString('login');
    final contrasena = prefs.getString('contrasena');
    return {'login': login, 'contrasena': contrasena};
  }

  Future<void> verificarCredenciales() async {
    final nombreUsuario = usuarioController.text;
    final contrasena = contrasenaController.text;

    final credencialesGuardadas = await obtenerCredenciales();
    final loginGuardado = credencialesGuardadas['login'];
    final contrasenaGuardada = credencialesGuardadas['contrasena'];

    print('nombre guardado: $loginGuardado; nombreUsuario: $nombreUsuario\n');
    print('contraseña guardada: $contrasenaGuardada; Contraseña: $contrasena\n');
    if (loginGuardado == nombreUsuario && contrasenaGuardada == contrasena) {
      // Credenciales correctas, navega a la siguiente página
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TaskList()),
      );
    } else {
      // Credenciales incorrectas
      print('Credenciales incorrectas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text("Todo listas"),
      ),
      body: SingleChildScrollView( // Envuelve la columna con un SingleChildScrollView
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/logo_udec.jpg',
              width: MediaQuery.of(context).size.width,
              height: 150,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10,),
                const Text("Nombre de usuario: "),
                Container(
                  width: 200,
                  height: 40,
                  child: TextField(
                    controller: usuarioController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10,),
                const Text("Contraseña: "),
                const SizedBox(width: 47),
                Container(
                  width: 200,
                  height: 40,
                  child: TextField(
                    controller: contrasenaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verificarCredenciales,
              child: const Text("Ingresar"),
            ),
            const SizedBox(height: 80),
            Center(
              child: InkWell(
                onTap: irARegistro,
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
