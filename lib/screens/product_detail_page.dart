// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 5
// SCREEN    : ProductDetailPage
// MATERI    : Navigasi & Routing: Menerima Data, Kembali dengan Nilai
// DESKRIPSI : Halaman detail produk lengkap dengan pemilihan kuantitas,
//             tampilan rapi berbasis widget layout Pertemuan 4, dan
//             kembalian nilai kuantitas ke halaman pemanggil via Navigator.pop.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../widgets/category_tag.dart';
import '../widgets/price_label.dart';
import '../widgets/stock_badge.dart';

/// Halaman detail produk yang menampilkan informasi lengkap produk,
/// pemilih kuantitas (quantity selector), serta tombol tambah ke keranjang
/// yang mengembalikan jumlah item yang dipilih ke halaman sebelumnya.
class ProductDetailPage extends StatefulWidget {
  final Product? product;

  const ProductDetailPage({super.key, this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Mendukung pengiriman data via constructor, Get.arguments, maupun Named Route arguments
    final Product? routeProduct = (Get.arguments is Product)
        ? Get.arguments as Product
        : ModalRoute.of(context)?.settings.arguments as Product?;
    final Product? product = widget.product ?? routeProduct;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Produk'),
        ),
        body: const Center(
          child: Text('Data produk tidak ditemukan.'),
        ),
      );
    }

    final CartController cartController = Get.find<CartController>();
    final bool isDiscounted = product is DiscountedProduct;
    final double unitPrice =
        product is DiscountedProduct ? product.finalPrice : product.price;
    final double totalPrice = unitPrice * _quantity;
    final bool isOutOfStock = product.stock <= 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      // ── AppBar dengan tombol kembali dan aksi bagikan ─────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1565C0)),
          tooltip: 'Kembali',
          onPressed: () {
            // Navigasi kembali menggunakan Get.back()
            Get.back();
          },
        ),
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF1565C0)),
            tooltip: 'Bagikan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tautan untuk "${product.name}" disalin!'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),

      // ── Body: Konten detail produk yang dapat di-scroll ───────────────────
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Banner / Gambar Produk dengan Stack
            _buildImageHero(product, isDiscounted),

            // Bagian Informasi Utama (Kategori, Stok, Nama, Harga)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryTag(category: product.category),
                      StockBadge(stock: product.stock),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nama Produk
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Label Harga
                  if (isDiscounted) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        PriceLabel(price: unitPrice),
                        const SizedBox(width: 8),
                        Text(
                          formatRupiah(product.price),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            'Hemat ${product.discountPercent.toInt()}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    PriceLabel(price: product.price),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Bagian Deskripsi Produk
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description != null && product.description!.isNotEmpty
                        ? product.description!
                        : 'Tidak ada deskripsi detail untuk produk ini.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Bagian Pemilih Kuantitas (Tugas Mandiri 1)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Atur Jumlah Pembelian',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isOutOfStock)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Maaf, stok produk ini sedang habis.',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sisa Stok: ${product.stock}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        // Widget tombol kuantitas (- / +)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                onPressed: _quantity > 1
                                    ? () {
                                        setState(() {
                                          _quantity--;
                                        });
                                      }
                                    : null,
                              ),
                              Container(
                                constraints: const BoxConstraints(minWidth: 36),
                                alignment: Alignment.center,
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                onPressed: _quantity < product.stock
                                    ? () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Ruang untuk bottom bar
          ],
        ),
      ),

      // ── Bottom Navigation / Bar Aksi Beli ──────────────────────────────────
      bottomNavigationBar: Container(
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
              // Kolom Subtotal
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pembelian:',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatRupiah(totalPrice),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Tombol Tambah ke Keranjang (Praktikum 6: CartController.addItem + Get.snackbar)
              ElevatedButton.icon(
                onPressed: isOutOfStock
                    ? null
                    : () {
                        // Memanggil CartController untuk menambahkan produk dengan kuantitas
                        cartController.addItem(product, quantity: _quantity);

                        // Feedback visual via Get.snackbar sesuai modul Praktikum 6
                        Get.snackbar(
                          'Sukses',
                          '$_quantity item "${product.name}" berhasil ditambahkan ke keranjang!',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color(0xFF1565C0),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 10,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Membangun visual preview gambar produk berbasis Stack dan warna gradien kategori.
  Widget _buildImageHero(Product product, bool isDiscounted) {
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
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Lingkaran dekoratif latar belakang
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Ikon besar di tengah
          Center(
            child: Icon(
              icon,
              size: 96,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),

          // Badge Diskon jika ada
          if (isDiscounted)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'DISKON ${(product as DiscountedProduct).discountPercent.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
