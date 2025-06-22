import './../models/models.dart';
import './repository.dart';

class CartRepository {
  final CartLocalRepository cartLocalRepository;
  final CartProductsLocalRepository cartProductsLocalRepository;

  CartRepository(this.cartLocalRepository, this.cartProductsLocalRepository);

  Future<int> saveCart(int userId, String date) async {
    return await cartLocalRepository.saveCart(userId, date);
  }

  Future<void> removeCartProduct(int cartId, int productId) async {
    return await cartLocalRepository.removeCartProduct(cartId, productId);
  }

  Future<void> saveCartProduct(int cartId, CartProductModel cartProduct) async {
    await cartProductsLocalRepository.saveCartProduct(cartId, cartProduct);
  }

  Future<CartModel?> getCartById(int cartId) async {
    return await cartLocalRepository.getCartById(cartId);
  }

  Future<List<CartProductModel>> getCartProducts(int cartId) async {
    return await cartProductsLocalRepository.getCartProducts(cartId);
  }

  Future<void> deleteCart(int cartId) async {
    await cartProductsLocalRepository.deleteCartProducts(cartId);
    await cartLocalRepository.deleteCart(cartId);
  }
}
