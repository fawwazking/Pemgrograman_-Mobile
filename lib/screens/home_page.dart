// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 4
// SCREEN    : HomePage
// MATERI    : Layout & UI: Row, Column, Container, Stack, ListView
// DESKRIPSI : Layar utama katalog TokoKita dengan AppBar kustom,
//             filter kategori, dan katalog produk menggunakan ListView.builder.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

/// Halaman utama katalog produk TokoKita.
/// Menggunakan:
/// - AppBar dengan Row dan Column untuk logo/judul dan tombol keranjang belanja.
/// - ListView.builder untuk menampilkan data dari dummyProducts secara lazy loaded.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Kategori yang sedang dipilih untuk filter katalog
  String _selectedCategory = 'Semua';

  final List<String> _categories = const [
    'Semua',
    'Elektronik',
    'Fashion',
    'Makanan',
    'Olahraga',
    'Buku',
  ];

  /// Mengambil daftar produk berdasarkan kategori yang dipilih.
  List<Product> get _filteredProducts {
    if (_selectedCategory == 'Semua') {
      return dummyProducts;
    }
    return dummyProducts
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      // ── Bagian Header (AppBar) ─────────────────────────────────────────────
      // Menggunakan Row (spaceBetween) dan Column (crossAxisAlignment.start)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Kolom judul & slogan TokoKita
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.storefront_rounded,
                      color: Color(0xFF1565C0),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'TokoKita',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Belanja jadi lebih mudah',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),

            // Ikon Keranjang Belanja dengan Badge Reaktif GetX Obx
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF1565C0),
                      size: 22,
                    ),
                    tooltip: 'Keranjang Belanja',
                    onPressed: () {
                      Get.to(() => const CartPage());
                    },
                  ),
                ),
                // Badge indikator item di keranjang secara reaktif
                Obx(() {
                  final count = cartController.totalItem;
                  if (count == 0) return const SizedBox.shrink();
                  return Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),

      // ── Bagian Body ────────────────────────────────────────────────────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Chip Filter Kategori
          _buildCategoryChips(),

          // Info Jumlah Produk
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Katalog Produk (${products.length})',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                if (_selectedCategory != 'Semua')
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'Semua';
                      });
                    },
                    child: const Text(
                      'Tampilkan Semua',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ListView.builder untuk lazy loading data katalog
          Expanded(
            child: products.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 4, bottom: 24),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        key: ValueKey(product.id),
                        product: product,
                        onTap: () {
                          // Langkah 4: Navigasi ke ProductDetailPage menggunakan Get.to()
                          Get.to(
                            () => const ProductDetailPage(),
                            arguments: product,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Membangun deretan FilterChip untuk memfilter kategori produk secara horizontal.
  Widget _buildCategoryChips() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },
            selectedColor: const Color(0xFF1565C0),
            backgroundColor: const Color(0xFFF1F5F9),
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.blueGrey.shade800,
            ),
            checkmarkColor: Colors.white,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          );
        },
      ),
    );
  }

  /// Tampilan ketika tidak ada produk pada kategori yang dipilih.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Tidak ada produk ditemukan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Coba pilih kategori lainnya',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
