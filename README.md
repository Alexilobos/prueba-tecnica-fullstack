# TiendaApp

Catálogo Flutter que consume DummyJSON y permite guardar productos favoritos localmente.

## Decisiones de diseño

- **Clean Architecture + Feature-First:** cada feature (`products` y `favorites`) separa `data`, `domain` y `presentation`.
- **Estados explícitos:** el listado diferencia carga, lista vacía, sin conexión y error de servidor.
- **Persistencia:** SQLite usa `favorites` y `favorite_tags`, una tabla relacionada para conservar las etiquetas de cada favorito.
- **Etiquetas:** `topTags` no usa paquetes externos y entrega hasta cinco etiquetas ordenadas por frecuencia y desempate alfabético.

## Ejecutar

```bash
flutter pub get
flutter run
```

La consulta usa `&delay=2000` para hacer visible el estado de carga.

## Verificar

```bash
flutter analyze
flutter test
```

## Pruebas manuales sugeridas

1. Filtrar y quitar un filtro desde las etiquetas populares.
2. Agregar y quitar favoritos; aparecerá una confirmación inferior.
3. Cerrar y abrir la app para comprobar que los favoritos permanecen.
4. Activar modo avión: el listado muestra "Sin conexión" y Favoritos continúa disponible.
