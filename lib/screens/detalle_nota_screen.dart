import 'package:flutter/material.dart';

class DetalleNotaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //HABIA UN ERROR DE QUE LOS ARGUMENTOS NO SE ESTABAN VALIDANDO
    final nota = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (nota == null) {
      //EN CASO DE ARGUMENTOS NULOS
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text(
            'No se pudo cargar la nota.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nota['titulo'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descripción:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              nota['descripcion'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Precio:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              '\$${nota['precio']}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
