// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 6
// SCREEN    : CartPage
// MATERI    : State Management dengan GetX: Obx, CartController, Get.find, Get.off
// DESKRIPSI : Halaman keranjang belanja nyata yang terhubung secara reaktif
//              dengan CartController menggunakan Obx, mendukung pengubahan
//              kuantitas, hapus item, pengosongan keranjang, dan navigasi checkout.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../widgets/category_tag.dart';
import '../widgets/price_label.dart';
import 'checkout_page.dart';

/// Halaman keranjang belanja yang mengamati state dari [CartController] via [Obx].
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection: Mengambil instance CartController
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Obx(() => Text(
              cartController.totalItem > 0
                  ? 'Keranjang Belanja (${cartController.totalItem})'
                  : 'Keranjang Belanja',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            )),
        actions: [
          // Tugas Mandiri 2: Tombol Kosongkan Keranjang beserta dialog konfirmasi
          Obx(() {
            if (cartController.isEmpty) return const SizedBox.shrink();
            return TextButton.icon(
              onPressed: () {
                Get.defaultDialog(
                  title: 'Kosongkan Keranjang?',
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                    fontSize: 16,
                  ),
                  middleText:
                      'Semua produk yang ada di dalam keranjang akan dihapus.',
                  textCancel: 'Batal',
                  textConfirm: 'Ya, Kosongkan',
                  confirmTextColor: Colors.white,
                  cancelTextColor: Colors.grey.shade700,
                  buttonColor: Colors.red.shade600,
                  onConfirm: () {
                    cartController.clearCart();
                    Get.back(); // Tutup dialog
                    Get.snackbar(
                      'Keranjang Dikosongkan',
                      'Seluruh item di keranjang belanja telah dihapus.',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                );
              },
              icon: Icon(Icons.delete_sweep_outlined, color: Colors.red.shade600, size: 20),
              label: Text(
                'Kosongkan',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),

      // Langkah 5 & Obx: Memantau perubahan items secara otomatis
      body: Obx(() {
        if (cartController.isEmpty) {
          return _buildEmptyCart(context);
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: cartController.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final cartItem = cartController.items[index];
            final product = cartItem.product;

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Placeholder Ikon Kategori
                  _buildItemThumbnail(product),

                  const SizedBox(width: 12),

                  // Detail Produk & Kuantitas
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CategoryTag(category: product.category),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        PriceLabel(price: cartItem.unitPrice),
                        const SizedBox(height: 8),

                        // Tugas Mandiri 1: Pemilih Kuantitas di Keranjang (- / +)
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () => cartController.decreaseQuantity(product),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Icon(Icons.remove, size: 16),
                                    ),
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(minWidth: 28),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${cartItem.quantity}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => cartController.increaseQuantity(product),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Icon(Icons.add, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Subtotal per item
                            Text(
                              formatRupiah(cartItem.subtotal),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Langkah 5: Tombol Hapus per Item
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade400,
                      size: 22,
                    ),
                    tooltip: 'Hapus item',
                    onPressed: () {
                      cartController.removeFromCart(product);
                      Get.snackbar(
                        'Item Dihapus',
                        '${product.name} dihapus dari keranjang.',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),

      // Langkah 5: Bagian Bawah Konsisten dengan Total Harga & Tombol Checkout
      bottomNavigationBar: Obx(() {
        if (cartController.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Harga (${cartController.totalItem} item):',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Nilai totalHarga selalu konsisten dan reaktif
                      Text(
                        formatRupiah(cartController.totalHarga),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Langkah 4 & Tugas Mandiri 3: Navigasi Checkout menggunakan Get.off()
                ElevatedButton.icon(
                  onPressed: () {
                    Get.off(() => const CheckoutPage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.payment_outlined, size: 18),
                  label: const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_shopping_cart_outlined,
                size: 50,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Keranjang Belanja Kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada produk yang ditambahkan ke keranjang.\nSilakan jelajahi katalog TokoKita dan pilih produk impian Anda!',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemThumbnail(Product product) {
    final Map<String, List<Color>> categoryGradients = {
      'elektronik': [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
      'fashion': [const Color(0xFF6A1B9A), const Color(0xFFCE93D8)],
      'makanan': [const Color(0xFFE65100), const Color(0xFFFFCC80)],
      'olahraga': [const Color(0xFF1B5E20), const Color(0xFF81C784)],
      'buku': [const Color(0xFF4E342E), const Color(0xFFBCAAA4)],
    };

    final gradientColors =
        categoryGradients[product.category.toLowerCase()] ??
        [const Color(0xFF37474F), const Color(0xFF90A4AE)];

    final Map<String, IconData> categoryIcons = {
      'elektronik': Icons.devices,
      'fashion': Icons.checkroom,
      'makanan': Icons.fastfood,
      'olahraga': Icons.fitness_center,
      'buku': Icons.menu_book,
    };
    final icon =
        categoryIcons[product.category.toLowerCase()] ??
        Icons.inventory_2_rounded;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
