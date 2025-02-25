import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../models/libro.dart';

class ProfileScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  final String usuario = "Antonio Castro";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Libro>>(
            stream: firestoreService.obtenerLibros(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error al cargar los datos"));
              }

              var librosPrestados = snapshot.data?.where((libro) => libro.enPrestamo).toList() ?? [];

              if (librosPrestados.isEmpty) {
                return Center(child: Text("No tienes libros en préstamo", style: TextStyle(fontSize: 18)));
              }

              return ListView.builder(
                itemCount: librosPrestados.length,
                itemBuilder: (context, index) {
                  var libro = librosPrestados[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(libro.portada, width: 100, height: 150, fit: BoxFit.cover),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(libro.titulo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text(libro.autor, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                                SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => firestoreService.devolverLibro(libro.id),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    textStyle: TextStyle(fontSize: 16),
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text("Cancelar préstamo", style: TextStyle(color: Colors.white)),
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
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            await generarInformePDF();
          },
          icon: Icon(Icons.picture_as_pdf),
          label: Text("Descargar Informe"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Future<void> generarInformePDF() async {
    try {
      final pdf = pw.Document();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/informe_prestamos.pdf";

      final librosPrestados = await firestoreService.obtenerLibros().first;
      final librosUsuario = librosPrestados.where((libro) => libro.enPrestamo).toList();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 1,
                child: pw.Text("Informe de Préstamos", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Usuario: $usuario", style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text("Libros Prestados:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: librosUsuario.map((libro) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("${libro.titulo} - ${libro.autor}"),
                      pw.Text("Fecha de devolución: ${DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 15)))}"),
                      pw.SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Visita nuestra web: www.biblioAntonio.com", style: pw.TextStyle(color: PdfColors.blue)),
            ];
          },
        ),
      );

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      print("PDF guardado en: $filePath"); // Depuración

      // Abre el archivo automáticamente
      OpenFile.open(filePath);
    } catch (e) {
      print("Error al generar el PDF: $e");
    }
  }
}
