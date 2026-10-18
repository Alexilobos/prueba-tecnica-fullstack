import 'package:flutter/material.dart';

import '../../favorites/domain/usecases/get_favorites.dart';
import '../../favorites/presentation/favorites_page.dart';
import '../domain/entities/product.dart';
import 'product_list_controller.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({
    super.key,
    required this.controller,
    required this.getFavorites,
  });
  final ProductListController controller;
  final GetFavorites getFavorites;
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('TiendaApp'),
      actions: [
        IconButton(
          tooltip: 'Favoritos',
          icon: const Icon(Icons.favorite_outline),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => FavoritesPage(getFavorites: widget.getFavorites),
            ),
          ),
        ),
      ],
    ),
    body: AnimatedBuilder(
      animation: widget.controller,
      builder: (_, _) => _body(),
    ),
  );

  Widget _body() {
    final c = widget.controller;
    if (c.status == ProductListStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (c.status == ProductListStatus.empty) {
      return const Center(child: Text('No hay productos disponibles.'));
    }
    if (c.status == ProductListStatus.offline ||
        c.status == ProductListStatus.error) {
      final offline = c.status == ProductListStatus.offline;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                offline ? Icons.wifi_off_outlined : Icons.error_outline,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                offline ? 'Sin conexión' : 'No pudimos cargar los productos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                offline
                    ? 'Revisa tu conexión a internet e inténtalo de nuevo.'
                    : c.message!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: c.load, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: c.load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Etiquetas populares',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: c.tags
                .map(
                  (tag) => FilterChip(
                    label: Text(tag),
                    selected: c.selectedTag?.toLowerCase() == tag.toLowerCase(),
                    onSelected: (_) => c.toggleTag(tag),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          if (c.products.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Center(child: Text('No hay productos con esta etiqueta.')),
            ),
          ...c.products.map(
            (p) => _ProductTile(
              product: p,
              favorite: c.isFavorite(p),
              onFavorite: () => c.toggleFavorite(p),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
    required this.favorite,
    required this.onFavorite,
  });
  final Product product;
  final bool favorite;
  final VoidCallback onFavorite;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: SizedBox(
        width: 56,
        height: 56,
        child: product.thumbnailUrl.isEmpty
            ? const Icon(Icons.image_not_supported_outlined)
            : Image.network(
                product.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.broken_image_outlined),
              ),
      ),
      title: Text(product.title),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
      trailing: IconButton(
        tooltip: favorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
        icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
        onPressed: onFavorite,
      ),
    ),
  );
}
