class Product {
  final int id;
  final String name;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    this.isFavorite = false,
  });

  Product copyWith({int? id, String? name, bool? isFavorite}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
