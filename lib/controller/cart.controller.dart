import 'package:get/get.dart';
import 'package:sepatu_client/model/user/product/product.dart';

class CartController extends GetxController {
  // Daftar produk yang ada di keranjang
  var cartItems = <Product>[].obs;
  var productQuantities = <String, int>{}.obs; // Menyimpan kuantitas setiap produk berdasarkan ID

  // Menambahkan produk ke keranjang atau menambah kuantitas jika sudah ada
  void addToCart(Product product) {
    if (productQuantities.containsKey(product.id)) {
      // Jika produk sudah ada, tambahkan kuantitas
      productQuantities[product.id!] = (productQuantities[product.id!]! + 1);
    } else {
      // Jika produk belum ada, tambahkan ke keranjang dan set kuantitas ke 1
      cartItems.add(product);
      productQuantities[product.id!] = 1;
    }
    update(); // Memperbarui UI
  }

  // Menghapus produk atau mengurangi kuantitas produk dari keranjang
  void removeFromCart(Product product) {
    if (productQuantities.containsKey(product.id) && productQuantities[product.id]! > 1) {
      // Kurangi kuantitas jika lebih dari 1
      productQuantities[product.id!] = (productQuantities[product.id!]! - 1);
    } else {
      // Hapus produk jika kuantitas 1 atau kurang
      cartItems.remove(product);
      productQuantities.remove(product.id);
    }
    update();
  }

  // Menghitung total harga semua produk di keranjang berdasarkan kuantitas
  double get totalAmount {
    double total = 0;
    for (var item in cartItems) {
      total += (item.price ?? 0) * (productQuantities[item.id] ?? 1);
    }
    return total;
  }

  // Menghitung jumlah item di keranjang
  int get itemCount {
    return productQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  // Menghapus semua produk dari keranjang
  void clearCart() {
    cartItems.clear();
    productQuantities.clear();
    update();
  }
}
