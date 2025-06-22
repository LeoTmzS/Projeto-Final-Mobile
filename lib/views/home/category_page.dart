import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../../controllers/controllers.dart';
import '../views.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final ProductController categoryController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final categoria = Uri.decodeComponent(Get.parameters['category'] ?? '');

    // Dispara o carregamento ao entrar na página
    categoryController.fetchProductsByCategory(categoria);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria: $categoria'),
      ),
      body: Obx(() {
        if (categoryController.carregando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categoryController.erro.isNotEmpty) {
          return Center(child: Text(categoryController.erro.value));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: categoryController.productList.length,
          itemBuilder: (context, index) {
            final produto = categoryController.productList[index];
            return ProductCard(
              cartAnimationMethod: (p0) {},
              product: produto,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: produto),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
