// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 4
// WIDGET    : ProductCard
// MATERI    : Layout & UI: Row, Column, Container, Stack, ListView
// DESKRIPSI : Kartu produk horizontal dengan Container, Row, Column, Stack,
//             dan tombol favorit interaktif.
// ============================================================================

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'category_tag.dart';
import 'price_label.dart';
import 'stock_badge.dart';

/// Widget kartu produk dengan layout horizontal sesuai materi Praktikum 4:
/// - Dibungkus Container dengan margin, padding, border radius, dan box shadow.
/// - Layout horizontal (Row): Gambar di kiri (Stack) & Informasi di kanan (Column).
/// - Stack pada gambar menampung placeholder, badge diskon (Positioned pojok kanan atas),
///   dan badge status stok (Positioned pojok kiri bawah).
/// - Kolom informasi dibungkus Expanded untuk mencegah RenderFlex overflow.
/// - Tombol favorit di sisi kanan dengan setState.
class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // ── State lokal ────────────────────────────────────────────────────────────
  bool isFavorite = false;

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    print('initState terpanggil untuk: ${widget.product.name}');
  }

  @override
  void dispose() {
    print('dispose terpanggil untuk: ${widget.product.name}');
    super.dispose();
  }

  // ── Builders ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    print('build terpanggil untuk: ${widget.product.name}');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Bagian Gambar (Kiri): Stack Placeholder & Badges ───────────────
                _buildImageSection(),

                const SizedBox(width: 14),

                // ── Bagian Informasi (Kanan): Expanded Column ──────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Baris Atas: CategoryTag di kiri & Tombol Favorit di kanan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryTag(category: widget.product.category),
                          _buildFavoriteButton(),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Nama Produk
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Deskripsi Produk (opsional/nullable)
                      if (widget.product.description != null &&
                          widget.product.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.product.description!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      const SizedBox(height: 8),

                      // Label Harga (Format diskon jika DiscountedProduct)
                      if (widget.product is DiscountedProduct) ...[
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            PriceLabel(
                              price: (widget.product as DiscountedProduct).finalPrice,
                            ),
                            Text(
                              'Rp ${widget.product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        PriceLabel(price: widget.product.price),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Membangun bagian gambar sebelah kiri dengan widget Stack.
  Widget _buildImageSection() {
    final Map<String, List<Color>> categoryGradients = {
      'elektronik': [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
      'fashion': [const Color(0xFF6A1B9A), const Color(0xFFCE93D8)],
      'makanan': [const Color(0xFFE65100), const Color(0xFFFFCC80)],
      'olahraga': [const Color(0xFF1B5E20), const Color(0xFF81C784)],
      'buku': [const Color(0xFF4E342E), const Color(0xFFBCAAA4)],
    };

    final gradientColors =
        categoryGradients[widget.product.category.toLowerCase()] ??
        [const Color(0xFF37474F), const Color(0xFF90A4AE)];

    final Map<String, IconData> categoryIcons = {
      'elektronik': Icons.devices,
      'fashion': Icons.checkroom,
      'makanan': Icons.fastfood,
      'olahraga': Icons.fitness_center,
      'buku': Icons.menu_book,
    };
    final icon =
        categoryIcons[widget.product.category.toLowerCase()] ??
        Icons.inventory_2_rounded;

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          // Placeholder Gambar/Ikon di Tengah
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -15,
                  top: -15,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    icon,
                    size: 46,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
          ),

          // Posisi Kanan Atas: Badge Diskon jika merupakan DiscountedProduct
          if (widget.product is DiscountedProduct)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  '-${(widget.product as DiscountedProduct).discountPercent.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),

          // Posisi Kiri Bawah: Badge Status Stok
          Positioned(
            bottom: 6,
            left: 6,
            child: StockBadge(stock: widget.product.stock),
          ),
        ],
      ),
    );
  }

  /// Membangun tombol favorit dengan setState.
  Widget _buildFavoriteButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red.shade500 : Colors.grey.shade400,
          size: 20,
        ),
      ),
    );
  }
}
