import '../data/product_model.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;

  ProductsLoaded(this.products);
}

class ProductsSuccess extends ProductsLoaded {
  final String message;

  ProductsSuccess(super.products, this.message);
}

class ProductsFailed extends ProductsLoaded {
  final String error;

  ProductsFailed(super.products, this.error);
}

