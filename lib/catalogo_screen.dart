import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/libro.dart';

class CatalogoScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Libro>>(
      stream: firestoreService.obtenerLibros(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Cargando
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error al cargar los datos")); // Error
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No hay libros disponibles")); // Sin datos
        }

        var libros = snapshot.data!;
        return ListView.builder(
          itemCount: libros.length,
          itemBuilder: (context, index) {
            var libro = libros[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Imagen más grande
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        libro.portada,
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16), // Espacio entre imagen y texto
                    // Información del libro
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            libro.titulo,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            libro.autor,
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 12),
                          libro.enPrestamo
                              ? Row(
                                  children: [
                                    Icon(Icons.lock, color: Colors.red, size: 24),
                                    SizedBox(width: 8),
                                    Text("En préstamo", style: TextStyle(color: Colors.red, fontSize: 16))
                                  ],
                                )
                              : ElevatedButton(
                                  onPressed: () => firestoreService.prestarLibro(libro.id),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    textStyle: TextStyle(fontSize: 16),
                                  ),
                                  child: Text("Prestar"),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
