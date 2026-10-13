// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 6
// SCREEN    : MainPage
// MATERI    : BottomNavigationBar & Integrasi State Management GetX
// DESKRIPSI : Halaman utama yang mengelola navigasi tab bawah (Bottom Navigation)
//             antara Beranda (HomePage), Keranjang (CartPage), dan Profil (ProfilePage),
//             dilengkapi badge dinamis reaktif GetX pada tab Keranjang.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

/// Halaman induk dengan BottomNavigationBar sebagai kerangka navigasi aplikasi.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Daftar halaman utama sesuai tab navigasi
  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      // Menggunakan IndexedStack untuk mempertahankan status state/scroll tiap tab
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1565C0),
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Obx(() {
                final count = cartController.totalItem;
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              }),
              activeIcon: Obx(() {
                final count = cartController.totalItem;
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: const Icon(Icons.shopping_cart_rounded),
                );
              }),
              label: 'Keranjang',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
