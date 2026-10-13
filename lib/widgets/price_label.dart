// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 3
// WIDGET    : PriceLabel
// DESKRIPSI : Menampilkan harga produk berformat Rupiah dengan teks tebal.
// ============================================================================

import 'package:flutter/material.dart';

/// Widget stateless untuk menampilkan label harga dalam format Rupiah.
///
/// Menerima [price] bertipe [double] dan menampilkannya sebagai teks
/// terformat (contoh: "Rp 150.000") dengan gaya tebal.
class PriceLabel extends StatelessWidget {
  final double price;

  const PriceLabel({super.key, required this.price});

  /// Memformat nilai [double] menjadi string Rupiah dengan pemisah ribuan.
  /// Contoh: 150000.0 → "Rp 150.000"
  String _formatRupiah(double nominal) {
    final String raw = nominal.toStringAsFixed(0);
    final StringBuffer buffer = StringBuffer();
    int counter = 0;
    for (int i = raw.length - 1; i >= 0; i--) {
      if (counter != 0 && counter % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(raw[i]);
      counter++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatRupiah(price),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1565C0), // Biru gelap untuk kesan premium
      ),
    );
  }
}
