import '../entities/product.dart';

/// Devuelve hasta cinco etiquetas populares de [products].
///
/// Las etiquetas vacías se ignoran. La comparación para contar y desempatar no
/// distingue mayúsculas/minúsculas ni espacios al inicio o final; se conserva
/// la primera grafía encontrada para mostrarla. Si dos etiquetas tienen la
/// misma frecuencia, se ordenan alfabéticamente sin distinguir mayúsculas.
List<String> topTags(List<Product> products) {
  final frequencies = <String, _TagCount>{};

  for (final product in products) {
    for (final rawTag in product.tags) {
      final tag = rawTag.trim();
      if (tag.isEmpty) continue;

      final key = tag.toLowerCase();
      final count = frequencies[key];
      if (count == null) {
        frequencies[key] = _TagCount(label: tag, count: 1);
      } else {
        count.count++;
      }
    }
  }

  final ordered = frequencies.values.toList()
    ..sort((a, b) {
      final frequencyOrder = b.count.compareTo(a.count);
      return frequencyOrder != 0
          ? frequencyOrder
          : a.label.toLowerCase().compareTo(b.label.toLowerCase());
    });
  return ordered.take(5).map((item) => item.label).toList(growable: false);
}

class _TagCount {
  _TagCount({required this.label, required this.count});

  final String label;
  int count;
}
