import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PantallaFormularioNota extends StatefulWidget {
  @override
  State<PantallaFormularioNota> createState() => EstadoPantallaFormularioNota();
}

class EstadoPantallaFormularioNota extends State<PantallaFormularioNota> {
  final baseDeDatos = FirebaseDatabase.instance.ref();
  final usuarioId = FirebaseAuth.instance.currentUser!.uid;

  final controladorTitulo = TextEditingController();
  final controladorDescripcion = TextEditingController();
  final controladorPrecio = TextEditingController();

  String? notaId; //PARA GUARDAR EL ID DE LA NOTA Y PODER EDITAR

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //NAVEGACION
    final argumentosNavegacion = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (argumentosNavegacion != null) {
      //ASIGNAR VALORES CON EL ID PARA PODER ACTUALIZAR
      notaId = argumentosNavegacion['id'];
      controladorTitulo.text = argumentosNavegacion['titulo'];
      controladorDescripcion.text = argumentosNavegacion['descripcion'];
      controladorPrecio.text = argumentosNavegacion['precio'].toString();
    }
  }

  void guardarNota() {
    final nota = {
      'titulo': controladorTitulo.text,
      'descripcion': controladorDescripcion.text,
      'precio': double.tryParse(controladorPrecio.text) ?? 0,
    };

    if (notaId == null) {
      //CUANDO ES UNA NUEVA NOTA
      baseDeDatos.child('notas/$usuarioId').push().set(nota);
    } else {
      //CUANDO SE VA A ACTUALIZAR UNA NOTA
      baseDeDatos.child('notas/$usuarioId/$notaId').set(nota);
    }

    Navigator.pop(context, true); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notaId == null ? 'Nueva Nota' : 'Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controladorTitulo,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controladorDescripcion,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controladorPrecio,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: guardarNota,
              child: Text(notaId == null ? 'Guardar' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
