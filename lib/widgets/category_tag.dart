// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 3
// WIDGET    : CategoryTag  (Tugas Mandiri)
// DESKRIPSI : Label chip kecil untuk menampilkan kategori produk.
// ============================================================================

import 'package:flutter/material.dart';

/// Widget stateless untuk menampilkan tag/chip kategori produk.
///
/// Menerima [category] bertipe [String] dan menampilkannya sebagai
/// label kecil berstyle chip dengan sudut membulat dan warna abu-abu muda.
class CategoryTag extends StatelessWidget {
  final String category;

  const CategoryTag({super.key, required this.category});

  /// Mengembalikan ikon yang sesuai dengan kategori produk.
  IconData _getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'elektronik':
        return Icons.devices;
      case 'fashion':
        return Icons.checkroom;
      case 'makanan':
        return Icons.fastfood;
      case 'olahraga':
        return Icons.fitness_center;
      case 'buku':
        return Icons.menu_book;
      default:
        return Icons.label_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.shade200, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(),
            size: 11,
            color: Colors.blueGrey.shade500,
          ),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 11,
              color: Colors.blueGrey.shade600,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
