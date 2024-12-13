import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/formulario_notas.dart';
import 'screens/lista_notas_screen.dart';
import 'screens/detalle_nota_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación de Gastos',
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/notas',
      routes: {
        '/login': (context) => LoginScreen(),
        '/registro': (context) => RegistroScreen(),
        '/notas': (context) => PantallaListaNotas(),
        '/formulario-nota': (context) => PantallaFormularioNota(),
        '/detalle-nota': (context) => DetalleNotaScreen(),
      },
    );
  }
}
