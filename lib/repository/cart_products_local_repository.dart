import './../database/app_database.dart';
import './../models/models.dart';

class CartProductsLocalRepository {
  Future<void> saveCartProduct(int cartId, CartProductModel cartProduct) async {
    final db = await AppDatabase().database;

    // Primeiro tenta fazer UPDATE → se o item já existe no carrinho, atualiza
    final count = await db.update(
      'cart_products',
      {
        'quantity': cartProduct.quantity,
        'title': cartProduct.title,
        'price': cartProduct.price,
        'imageUrl': cartProduct.imageUrl,
      },
      where: 'cartId = ? AND productId = ?',
      whereArgs: [cartId, cartProduct.productId],
    );

    // Se não atualizou nada (ou seja, o item não existia), faz INSERT
    if (count == 0) {
      await db.insert(
        'cart_products',
        {
          'cartId': cartId,
          'productId': cartProduct.productId,
          'quantity': cartProduct.quantity,
          'title': cartProduct.title,
          'price': cartProduct.price,
          'imageUrl': cartProduct.imageUrl,
        },
      );
    }
  }

  Future<List<CartProductModel>> getCartProducts(int cartId) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'cart_products',
      where: 'cartId = ?',
      whereArgs: [cartId],
    );

    // Convertendo cada Map para CartProductModel
    return maps.map((map) => CartProductModel.fromJson(map)).toList();
  }

  Future<void> deleteCartProducts(int cartId) async {
    final db = await AppDatabase().database;
    await db.delete(
      'cart_products',
      where: 'cartId = ?',
      whereArgs: [cartId],
    );
  }
}
