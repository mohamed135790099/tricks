import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test2/optimistic_uI/domain/products_state.dart';

import '../data/product_model.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial()) {
    loadInitialProducts();
  }

  void loadInitialProducts() {
    final initialProducts = [
      const Product(id: 1, name: 'منتج 1'),
      const Product(id: 2, name: 'منتج 2'),
      const Product(id: 3, name: 'منتج 3'),
    ];
    emit(ProductsLoaded(initialProducts));
  }

  Future<void> toggleFavorite(int index) async {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      final oldList = List<Product>.from(currentState.products);
      final updated = oldList[index].copyWith(isFavorite: !oldList[index].isFavorite);
      final newList = [...oldList]..[index] = updated;

      emit(ProductsLoaded(newList)); // optimistic

      try {
        await simulateApiCall(success: true);
        emit(ProductsSuccess(newList, 'تم تحديث المفضلة بنجاح'));
      } catch (_) {
        emit(ProductsFailed(oldList, 'فشل تحديث المفضلة'));
      }
    }
  }

  Future<void> deleteProduct(int index) async {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      final oldList = List<Product>.from(currentState.products);
      final newList = List<Product>.from(oldList)..removeAt(index);

      emit(ProductsLoaded(newList)); // optimistic

      try {
        await simulateApiCall(success: true);
        emit(ProductsSuccess(newList, 'تم حذف المنتج بنجاح'));
      } catch (_) {
        emit(ProductsFailed(oldList, 'فشل حذف المنتج'));
      }
    }
  }


  Future<void> addProduct(String name) async {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      final oldList = List<Product>.from(currentState.products);
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
      );
      final newList = [...oldList, newProduct];

      emit(ProductsLoaded(newList)); // optimistic

      try {
        await simulateApiCall(success: true);
        emit(ProductsSuccess(newList, 'تمت إضافة المنتج بنجاح'));
      } catch (_) {
        emit(ProductsFailed(oldList, 'فشل إضافة المنتج'));
      }
    }
  }


  Future<void> updateProduct(int index, String newName) async {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      final oldList = List<Product>.from(currentState.products);
      final updated = oldList[index].copyWith(name: newName);
      final newList = [...oldList]..[index] = updated;

      emit(ProductsLoaded(newList)); // optimistic

      try {
        await simulateApiCall(success: true);
        emit(ProductsSuccess(newList, 'تم تحديث المنتج بنجاح'));
      } catch (_) {
        emit(ProductsFailed(oldList, 'فشل تحديث المنتج'));
      }
    }
  }

  Future<void> simulateApiCall({required bool success}) async {
    await Future.delayed(const Duration(seconds:3));
    if (!success) throw Exception('فشل العملية');
  }
}
