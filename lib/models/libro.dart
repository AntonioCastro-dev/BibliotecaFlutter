class Libro {
  String id;
  String titulo;
  String autor;
  String portada;
  bool enPrestamo;

  Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.portada,
    required this.enPrestamo,
  });

  factory Libro.fromMap(String id, Map<String, dynamic> data) {
    return Libro(
      id: id,
      titulo: data['titulo'],
      autor: data['autor'],
      portada: data['portada'],
      enPrestamo: data['enPrestamo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'portada': portada,
      'enPrestamo': enPrestamo,
    };
  }
}
