import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/libro.dart';

class FirestoreService {
  final CollectionReference librosRef =
      FirebaseFirestore.instance.collection('libros');

  Stream<List<Libro>> obtenerLibros() {
  return librosRef.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return Libro.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      } catch (e) {
        print("Error al convertir documento: ${doc.id}");
        return null;
      }
    }).where((libro) => libro != null).cast<Libro>().toList();
  });
}

  Future<void> prestarLibro(String id) async {
    await librosRef.doc(id).update({'enPrestamo': true});
  }

  Future<void> devolverLibro(String id) async {
    await librosRef.doc(id).update({'enPrestamo': false});
  }
}
