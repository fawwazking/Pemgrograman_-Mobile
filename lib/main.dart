// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 6
// APLIKASI   : TOKOKITA
// MATERI     : State Management dengan GetX: Obx, GetxController, GetMaterialApp
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/cart_controller.dart';
import 'screens/main_page.dart';
import 'screens/home_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/cart_page.dart';
import 'screens/profile_page.dart';
import 'screens/checkout_page.dart';

export 'models/product.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Langkah 3: Dependency Injection menggunakan Get.put() agar CartController
  // tersedia secara global di seluruh siklus hidup aplikasi.
  Get.put(CartController());
  runApp(const TokoKitaApp());
}

/// Root widget aplikasi TokoKita menggunakan GetMaterialApp.
class TokoKitaApp extends StatelessWidget {
  const TokoKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Langkah 3: Gunakan GetMaterialApp sebagai pengganti MaterialApp
    return GetMaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FA),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 2,
        ),
      ),
      initialRoute: '/',
      // Named routes & GetPages untuk navigasi TokoKita
      getPages: [
        GetPage(name: '/', page: () => const MainPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/detail', page: () => const ProductDetailPage()),
        GetPage(name: '/cart', page: () => const CartPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/checkout', page: () => const CheckoutPage()),
      ],
      routes: {
        '/': (context) => const MainPage(),
        '/home': (context) => const HomePage(),
        '/detail': (context) => const ProductDetailPage(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
        '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}
