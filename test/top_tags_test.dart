import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_app/features/products/domain/entities/product.dart';
import 'package:tienda_app/features/products/domain/usecases/top_tags.dart';

Product product(List<String> tags) =>
    Product(id: 1, title: 'Producto', price: 1, thumbnailUrl: '', tags: tags);

void main() {
  test('ordena por frecuencia y desempata alfabéticamente', () {
    final result = topTags([
      product(['Beauty', 'skin']),
      product(['beauty', 'makeup']),
      product(['makeup']),
    ]);
    expect(result, ['Beauty', 'makeup', 'skin']);
  });

  test('ignora etiquetas vacías y limita el resultado a cinco', () {
    final result = topTags([
      product([' ', '', 'a', 'b', 'c', 'd', 'e', 'f']),
    ]);
    expect(result, ['a', 'b', 'c', 'd', 'e']);
  });
}
