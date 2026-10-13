// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 3
// WIDGET    : StockBadge
// DESKRIPSI : Menampilkan badge status stok produk dengan warna sesuai kondisi.
// ============================================================================

import 'package:flutter/material.dart';

/// Widget stateless untuk menampilkan badge/label status ketersediaan stok.
///
/// Logika status (konsisten dengan [Product.getStatusStok] dari Pertemuan 2):
/// - [stock] <= 0 : "Habis" — latar merah muda, teks merah.
/// - [stock] <= 5 : "Stok Terbatas" — latar oranye muda, teks oranye tebal.
/// - lainnya      : "Tersedia" — latar hijau muda, teks hijau tebal.
class StockBadge extends StatelessWidget {
  final int stock;

  const StockBadge({super.key, required this.stock});

  /// Menentukan teks, warna latar, dan warna teks berdasarkan nilai [stock].
  _BadgeStyle _getBadgeStyle() {
    if (stock <= 0) {
      return _BadgeStyle(
        label: 'Habis',
        backgroundColor: Colors.red.shade100,
        textColor: Colors.red.shade700,
        fontWeight: FontWeight.w600,
      );
    } else if (stock <= 5) {
      return _BadgeStyle(
        label: 'Stok Terbatas',
        backgroundColor: Colors.orange.shade100,
        textColor: Colors.orange.shade800,
        fontWeight: FontWeight.bold,
      );
    } else {
      return _BadgeStyle(
        label: 'Tersedia',
        backgroundColor: Colors.green.shade100,
        textColor: Colors.green.shade700,
        fontWeight: FontWeight.bold,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getBadgeStyle();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          fontSize: 12,
          color: style.textColor,
          fontWeight: style.fontWeight,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// Data class pembantu untuk menyimpan properti visual badge.
class _BadgeStyle {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;

  const _BadgeStyle({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.fontWeight,
  });
}
