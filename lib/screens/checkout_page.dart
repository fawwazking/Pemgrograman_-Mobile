// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 6
// SCREEN    : CheckoutPage
// MATERI    : State Management & Routing dengan GetX (Get.off, Get.find, Obx)
// DESKRIPSI : Halaman checkout sederhana yang menampilkan ringkasan pesanan
//              dari CartController, rincian biaya, dan simulasi penyelesaian pesanan.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';

/// Halaman checkout yang menampilkan ringkasan belanja dari [CartController].
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection: Mengambil instance CartController yang telah terdaftar
    final CartController cartController = Get.find<CartController>();
    const double shippingCost = 15000.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1565C0)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Checkout Pesanan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
      ),
      body: Obx(() {
        if (cartController.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pesanan Berhasil Diselesaikan!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Terima kasih telah berbelanja di TokoKita.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kembali ke Beranda'),
                ),
              ],
            ),
          );
        }

        final double grandTotal = cartController.totalHarga + shippingCost;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alamat Pengiriman
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Color(0xFF1565C0), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Alamat Pengiriman',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Fawwaz Wijdan (+62 812-3456-7890)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jl. Kampus Teknik No. 5, Cilegon, Banten 42435',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Ringkasan Produk
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar Produk (${cartController.totalItem} item)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const Divider(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartController.items.length,
                      separatorBuilder: (_, _) => const Divider(height: 16),
                      itemBuilder: (context, index) {
                        final item = cartController.items[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.quantity} x ${formatRupiah(item.unitPrice)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatRupiah(item.subtotal),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Rincian Pembayaran
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rincian Pembayaran',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      'Subtotal Produk',
                      formatRupiah(cartController.totalHarga),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Biaya Pengiriman (Reguler)',
                      formatRupiah(shippingCost),
                    ),
                    const Divider(height: 20),
                    _buildSummaryRow(
                      'Total Pembayaran',
                      formatRupiah(grandTotal),
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.isEmpty) return const SizedBox.shrink();

        final double grandTotal = cartController.totalHarga + shippingCost;
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
                        'Total Tagihan:',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatRupiah(grandTotal),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Selesaikan pesanan & bersihkan keranjang via CartController
                    cartController.clearCart();
                    Get.defaultDialog(
                      title: 'Pembayaran Berhasil',
                      titleStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                      middleText:
                          'Terima kasih! Pesanan Anda telah diterima dan sedang diproses.',
                      textConfirm: 'Ke Beranda',
                      confirmTextColor: Colors.white,
                      buttonColor: const Color(0xFF1565C0),
                      onConfirm: () {
                        // Menggunakan Get.offAllNamed untuk membersihkan stack rute
                        Get.offAllNamed('/');
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Bayar Sekarang',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFF1A237E) : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? const Color(0xFF1565C0) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
