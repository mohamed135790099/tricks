import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test2/optimistic_uI/domain/products_cubit.dart';

import '../domain/products_state.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: const Text('قائمة المنتجات')),
        body: BlocConsumer<ProductsCubit, ProductsState>(
          listener: (context, state) {
            if (state is ProductsSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
            } else if (state is ProductsFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            final products = (state is ProductsLoaded || state is ProductsSuccess || state is ProductsFailed)
                ? (state as dynamic).products
                : null;

            if (products == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
                        onPressed: () => context.read<ProductsCubit>().toggleFavorite(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(context, index, product.name),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => context.read<ProductsCubit>().deleteProduct(index),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showAddDialog(context),
        ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة منتج'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'اسم المنتج'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<ProductsCubit>().addProduct(name);
              }
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعديل المنتج'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'اسم جديد'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                context.read<ProductsCubit>().updateProduct(index, newName);
              }
              Navigator.pop(context);
            },
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }
}