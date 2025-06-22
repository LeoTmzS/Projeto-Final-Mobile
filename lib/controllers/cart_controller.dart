import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './../controllers/controllers.dart';
import './../repository/repository.dart';
import './../models/models.dart';

class CartController extends GetxController {
  final CartRepository cartRepository;

  CartController({required this.cartRepository});

  final Rx<CartModel?> cart = Rx<CartModel?>(null);
  final RxList<CartProductModel> cartProducts = <CartProductModel>[].obs;

  var carregandoFinalizar = false.obs;
  var erro = ''.obs;

  GlobalKey<CartIconKey>? cartKey;

  void setCartKey(GlobalKey<CartIconKey> key) {
    cartKey = key;
  }

  Future<void> updateCartBadge() async {
    var cartQuantityItems = totalQuantity;
    if (cartKey?.currentState != null) {
      await cartKey!.currentState!.runCartAnimation((++cartQuantityItems).toString());
    }
  }

  Future<void> downgradeCartBadge() async {
    var cartQuantityItems = totalQuantity;
    if (cartKey?.currentState != null) {
      await cartKey!.currentState!.runCartAnimation((--cartQuantityItems).toString());
    }
  }

  Future<void> clearCartBadge() async {
    if (cartKey?.currentState != null) {
      await cartKey!.currentState!.runClearCartAnimation();
    }
  }

  Future<void> itemSelectedCartAnimations(GlobalKey<State<StatefulWidget>> gkImage) async {
    if (_runAddToCartAnimation != null) {
      await _runAddToCartAnimation!(gkImage);
      // Atualiza o badge após a animação da imagem
      await cartKey?.currentState?.runCartAnimation(totalQuantity.toString());
    }
  }

// Guarda a função de animação da imagem
  Future<void> Function(GlobalKey<State<StatefulWidget>>)? _runAddToCartAnimation;

  void setRunAddToCartAnimation(Future<void> Function(GlobalKey<State<StatefulWidget>>) animation) {
    _runAddToCartAnimation = animation;
  }

  void limparCarrinho() {
    cartProducts.clear();
  }

  Future<void> atualizarquantity(int productId, int novaQuantidade) async {
    final productList = Get.find<ProductController>().productList;
    final produto = productList.where((item) => item.id == productId).firstOrNull;

    if (produto == null || cart.value == null) return;

    if (novaQuantidade > 0) {
      // Atualiza no banco
      CartProductModel cartProduct = CartProductModel(
        productId: productId,
        quantity: novaQuantidade,
        title: produto.title,
        price: produto.price,
        imageUrl: produto.image,
      );

      await cartRepository.saveCartProduct(cart.value!.id, cartProduct);
    } else {
      // Remove do banco
      await cartRepository.removeCartProduct(cart.value!.id, productId);
    }

    // Atualiza lista local
    final products = await cartRepository.getCartProducts(cart.value!.id);
    cartProducts.assignAll(products);
  }

  void removerItem(int productId) {
    cartProducts.removeWhere((item) => item.productId == productId);
  }

  Future<void> loadCartForUser(int userId) async {
    try {
      await fetchCart(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao carregar carrinho para user $userId: $e');
      }
    }
  }

  Future<void> fetchCart(int cartId) async {
    try {
      final fetchedCart = await cartRepository.getCartById(cartId);
      cart.value = fetchedCart;

      if (fetchedCart != null) {
        final products = await cartRepository.getCartProducts(fetchedCart.id);
        cartProducts.assignAll(products);
      } else {
        cartProducts.clear();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar carrinho: $e');
      }
    }
  }

  Future<void> addProductToCart(ProductModel produto, int quantity) async {
    try {
      final userId = Get.find<UserController>().user.value?.id;

      if (userId == null) {
        Get.snackbar(
          'Erro',
          'Para adicionar ao carrinho, você precisa estar logado.',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          duration: const Duration(seconds: 5),
        );
        return;
      }

      if (cart.value == null) {
        final newCartId = await cartRepository.saveCart(userId, DateTime.now().toIso8601String());
        cart.value = CartModel(id: newCartId, userId: userId, date: DateTime.now(), products: []);
      }

      CartProductModel cartProduct = CartProductModel(
        productId: produto.id,
        quantity: quantity,
        title: produto.title,
        price: produto.price,
        imageUrl: produto.image,
      );
      await cartRepository.saveCartProduct(cart.value!.id, cartProduct);

      final products = await cartRepository.getCartProducts(cart.value!.id);
      cartProducts.clear();
      cartProducts.assignAll(products);
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregandoFinalizar.value = false;
    }
  }

  Future<void> removeProductFromCart(int productId) async {
    try {
      if (cart.value == null) return;

      // Remove do banco
      await cartRepository.removeCartProduct(cart.value!.id, productId);

      // Atualiza lista local
      final products = await cartRepository.getCartProducts(cart.value!.id);
      cartProducts.assignAll(products);

      // Opcional: feedback para o usuário
      Get.snackbar(
        'Produto removido',
        'Produto removido do carrinho.',
        colorText: Colors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.delete_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      erro.value = e.toString();
      Get.snackbar(
        'Erro',
        'Falha ao remover produto: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> finalizarPedido() async {
    try {
      final userId = Get.find<UserController>().user.value?.id;

      if (userId == null) {
        throw Exception('Usuário não logado');
      }

      if (cartProducts.isEmpty) {
        throw Exception('Carrinho vazio');
      }

      // Cria o OrderModel
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch, // ou use seu OrderService para gerar ID
        userId: userId,
        date: DateTime.now(),
        status: OrderStatus.concluido,

        products: cartProducts.map((p) {
          return OrderProductModel(
            productId: p.productId,
            quantity: p.quantity,
            price: p.price,
          );
        }).toList(),
      );

      // Salva o pedido
      await Get.find<OrderController>().saveOrder(order);

      // Limpa o carrinho
      await deleteCart();

      // Opcional: mostrar snackbar
      Get.snackbar(
        'Pedido concluído',
        'Seu pedido foi finalizado com sucesso!',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );

      // Navegar para tela de confirmação
      Get.offAllNamed('/order-confirmation');
    } catch (e) {
      Get.snackbar(
        'Erro ao finalizar pedido',
        '$e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> updateProductQuantity(
      int productId, String title, double price, int newQuantity) async {
    final productList = Get.find<ProductController>().productList;
    final produto = productList.where((item) => item.id == productId).firstOrNull;

    if (produto == null) {
      return;
    }

    if (cart.value == null) return;

    CartProductModel cartProduct = CartProductModel(
      productId: productId,
      quantity: newQuantity,
      title: produto.title,
      price: price,
      imageUrl: produto.image,
    );

    await cartRepository.saveCartProduct(cart.value!.id, cartProduct);

    final products = await cartRepository.getCartProducts(cart.value!.id);
    cartProducts.assignAll(products);
  }

  Future<void> deleteCart() async {
    if (cart.value == null) return;

    await cartRepository.deleteCart(cart.value!.id);

    cart.value = null;
    cartProducts.clear();
  }

  int get totalQuantity {
    return cartProducts.fold(0, (sum, item) => sum + item.quantity);
  }

  double get total => cartProducts.fold(0.0, (soma, item) => soma + item.price * item.quantity);
}
