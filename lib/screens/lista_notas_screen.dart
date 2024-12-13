import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PantallaListaNotas extends StatefulWidget {
  @override
  State<PantallaListaNotas> createState() => _PantallaListaNotasState();
}

class _PantallaListaNotasState extends State<PantallaListaNotas> {
  final DatabaseReference baseDeDatos = FirebaseDatabase.instance.ref();
  final String usuarioId = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> notas = [];

  @override
  void initState() {
    super.initState();
    obtenerNotas();
  }

  Future<void> obtenerNotas() async {
    try {
      final snapshot = await baseDeDatos.child('notas/$usuarioId').get();
      if (snapshot.exists && snapshot.value != null) {
        final datos = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          notas = datos.entries
              .map((entrada) {
                final valor = Map<String, dynamic>.from(entrada.value);
                
                if (valor.containsKey('titulo') &&
                    valor.containsKey('descripcion') &&
                    valor.containsKey('precio')) {
                  return {
                    'id': entrada.key,
                    ...valor,
                  };
                } else {
                  return null; 
                }
              })
              .where((nota) => nota != null)
              .toList()
              .cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          notas = [];
        });
      }
    } catch (e) {
      setState(() {
        notas = [];
      });
    }
  }

  Future<void> eliminarNota(String notaId) async {
    try {
      await baseDeDatos.child('notas/$usuarioId/$notaId').remove();
      obtenerNotas();
    } catch (e) {
      
    }
  }

  void navegarADetalle(Map<String, dynamic> nota) {
    if (nota.isNotEmpty) {
      Navigator.pushNamed(context, '/detalle-nota', arguments: nota);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Gastos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: notas.isEmpty
          ? const Center(child: Text('Aún no se han escrito gastos'))
          : ListView.builder(
              itemCount: notas.length,
              itemBuilder: (context, indice) {
                final nota = notas[indice];
                return ListTile(
                  title: Text(nota['titulo'] ?? 'Sin título'),
                  subtitle: Text(
                    nota.containsKey('precio')
                        ? '\$${nota['precio']}'
                        : 'Precio no disponible',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => eliminarNota(nota['id']),
                  ),
                  onTap: () => navegarADetalle(nota),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/formulario-nota')
              .then((_) => obtenerNotas());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
