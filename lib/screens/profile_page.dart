// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 5
// SCREEN    : ProfilePage (Placeholder)
// MATERI    : Navigasi & BottomNavigationBar (Tugas Mandiri 3)
// DESKRIPSI : Halaman placeholder profil pengguna dengan kartu identitas,
//             menu opsi akun, dan pesan informatif.
// ============================================================================

import 'package:flutter/material.dart';

/// Halaman placeholder untuk menu Profil pada BottomNavigationBar.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Kartu Profil Pengguna
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFF1565C0),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fawwaz Wijdan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'fawwaz@tokokita.id',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Member Gold',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu Opsi Profil Placeholder
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Riwayat Pesanan',
                      subtitle: 'Lihat status & riwayat transaksi',
                      onTap: () {
                        _showNotice(context, 'Riwayat pesanan akan hadir di pertemuan berikutnya');
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Daftar Alamat',
                      subtitle: 'Kelola alamat pengiriman barang',
                      onTap: () {
                        _showNotice(context, 'Fitur alamat segera hadir');
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      icon: Icons.notifications_none_outlined,
                      title: 'Pemberitahuan',
                      subtitle: 'Atur notifikasi promo & pesanan',
                      onTap: () {
                        _showNotice(context, 'Pengaturan notifikasi segera hadir');
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Pusat Bantuan',
                      subtitle: 'FAQ dan layanan pelanggan TokoKita',
                      onTap: () {
                        _showNotice(context, 'Pusat bantuan segera hadir');
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'TokoKita v1.0.0 (Pertemuan 5)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1565C0).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF1565C0), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A237E),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }

  static void _showNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
