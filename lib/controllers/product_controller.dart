import 'package:get/get.dart';

import './../repository/repository.dart';
import './../models/models.dart';

class ProductController extends GetxController {
  final ProductRepository productRepository;

  ProductController({required this.productRepository});

  // Lista de produtos observável
  final RxList<ProductModel> productList = <ProductModel>[].obs;

  // Produto atual (caso queira exibir um detalhe)
  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);

  var carregando = true.obs;
  var erro = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Carregar todos os produtos
  Future<void> fetchProducts() async {
    try {
      carregando.value = true;
      erro.value = '';
      final products = await productRepository.fetchProducts();
      productList.assignAll(products);
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregando.value = false;
    }
  }

  // Carregar todos os produtos por categoria
  Future<void> fetchProductsByCategory(String category) async {
    try {
      carregando.value = true;
      erro.value = '';
      final products = await productRepository.fetchProductsByCategory(category);
      productList.assignAll(products);
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregando.value = false;
    }
  }

  // Carregar um produto pelo id
  Future<void> fetchProductById(int id) async {
    try {
      carregando.value = true;
      erro.value = '';
      final product = await productRepository.fetchProductById(id);
      selectedProduct.value = product;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregando.value = false;
    }
  }

  ProductModel? getProdutoById(int id) {
    try {
      return productList.firstWhereOrNull((produto) => produto.id == id);
    } catch (_) {
      return null;
    }
  }
}
