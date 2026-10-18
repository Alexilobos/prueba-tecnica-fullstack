import 'package:flutter/material.dart';

import '../domain/entities/favorite_product.dart';
import '../domain/usecases/get_favorites.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key, required this.getFavorites});
  final GetFavorites getFavorites;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<FavoriteProduct>?> _future;
  String? _error;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = widget.getFavorites().then((result) {
      _error = result.failure?.message;
      return result.favorites;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Favoritos')),
    body: FutureBuilder<List<FavoriteProduct>?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_error != null) {
          return Center(child: Text(_error!));
        }
        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return const Center(
            child: Text('Aún no tienes productos favoritos.'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (_, i) => Card(
            child: ListTile(
              title: Text(items[i].title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${items[i].price.toStringAsFixed(2)}'),
                  Wrap(
                    spacing: 4,
                    children: items[i].tags
                        .map((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
