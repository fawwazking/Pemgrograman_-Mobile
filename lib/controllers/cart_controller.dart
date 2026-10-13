// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 6
// CONTROLLER : CartController
// MATERI     : State Management dengan GetX: GetxController, RxList, Obx
// DESKRIPSI  : Mengelola state keranjang belanja TokoKita secara reaktif dan
//              terpusat, mencakup penambahan, penghapusan, ubah kuantitas,
//              serta kalkulasi total item dan total harga.
// ============================================================================

import 'package:get/get.dart';
import '../models/product.dart';

/// Model item keranjang belanja yang menampung objek [Product] dan kuantitasnya.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Mengambil harga satuan setelah diskon jika produk merupakan [DiscountedProduct].
  double get unitPrice {
    if (product is DiscountedProduct) {
      return (product as DiscountedProduct).finalPrice;
    }
    return product.price;
  }

  /// Menghitung subtotal untuk item ini (harga satuan * kuantitas).
  double get subtotal => unitPrice * quantity;
}

/// Controller GetX untuk mengelola keranjang belanja TokoKita.
class CartController extends GetxController {
  /// Variabel reaktif [RxList] untuk menyimpan daftar item keranjang.
  final RxList<CartItem> items = <CartItem>[].obs;

  /// Menambahkan produk ke keranjang belanja.
  /// Jika produk sudah ada, tambahkan kuantitasnya sesuai [quantity].
  void addToCart(Product product, [int quantity = 1]) {
    final int index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final int newQty = items[index].quantity + quantity;
      // Batasi kuantitas maksimum agar tidak melebihi stok produk
      items[index].quantity = newQty > product.stock ? product.stock : newQty;
      items.refresh();
    } else {
      items.add(
        CartItem(
          product: product,
          quantity: quantity > product.stock ? product.stock : quantity,
        ),
      );
    }
  }

  /// Alias metode untuk menambahkan produk ke keranjang belanja.
  void addItem(Product product, {int quantity = 1}) {
    addToCart(product, quantity);
  }

  /// Menghapus produk tertentu dari keranjang belanja.
  void removeFromCart(Product product) {
    items.removeWhere((item) => item.product.id == product.id);
  }

  /// Menambah kuantitas produk sebanyak 1 (selama belum melebihi stok).
  void increaseQuantity(Product product) {
    final int index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (items[index].quantity < product.stock) {
        items[index].quantity++;
        items.refresh();
      } else {
        Get.snackbar(
          'Stok Maksimum',
          'Jumlah item mencapai batas stok yang tersedia (${product.stock}).',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  /// Mengurangi kuantitas produk sebanyak 1.
  /// Jika kuantitas sudah 1, tanyakan atau hapus item.
  void decreaseQuantity(Product product) {
    final int index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
        items.refresh();
      } else {
        removeFromCart(product);
      }
    }
  }

  /// Memperbarui kuantitas produk secara langsung.
  void updateQuantity(Product product, int quantity) {
    final int index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (quantity <= 0) {
        removeFromCart(product);
      } else {
        items[index].quantity = quantity > product.stock ? product.stock : quantity;
        items.refresh();
      }
    }
  }

  /// Mengosongkan seluruh isi keranjang belanja.
  void clearCart() {
    items.clear();
  }

  /// Getter reaktif untuk total seluruh item di keranjang.
  int get totalItem => items.fold(0, (sum, item) => sum + item.quantity);

  /// Getter reaktif untuk total harga seluruh item di keranjang.
  double get totalHarga => items.fold(0.0, (sum, item) => sum + item.subtotal);

  /// Memeriksa apakah keranjang kosong.
  bool get isEmpty => items.isEmpty;
}
