import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/screens/checkout_page.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(CartController());
  });

  tearDown(() {
    Get.reset();
  });
  test('Pengujian method getStatusStok() dan model Product', () {
    Product p = Product(
      id: 'TEST-1',
      name: 'Test Item',
      price: 10000,
      imageUrl: 'test.png',
      category: 'Test',
      stock: 10,
    );

    expect(p.getStatusStok(), 'Tersedia');

    p.stock = 5;
    expect(p.getStatusStok(), 'Stok Terbatas');

    p.stock = 0;
    expect(p.getStatusStok(), 'Habis');
  });

  test('Pengujian DiscountedProduct inheritance', () {
    DiscountedProduct dp = DiscountedProduct(
      id: 'PROMO-1',
      name: 'Promo Item',
      price: 100000,
      imageUrl: 'promo.png',
      category: 'Test',
      stock: 5,
      discountPercent: 20,
    );

    expect(dp.finalPrice, 80000);
    expect(dp.getStatusStok(), 'Stok Terbatas');
  });

  test('Pengujian helper functions', () {
    expect(formatRupiah(50000), 'Rp 50000');
    expect(hitungHargaSetelahDiskon(100000, persenDiskon: 10), 90000);

    List<Product> list = [
      Product(
        id: '1',
        name: 'Item 1',
        price: 10000,
        imageUrl: '1.png',
        category: 'Test',
        stock: 10,
      ),
      DiscountedProduct(
        id: '2',
        name: 'Item 2',
        price: 20000,
        imageUrl: '2.png',
        category: 'Test',
        stock: 5,
        discountPercent: 50,
      ),
    ];

    expect(hitungTotalBelanja(list), 20000);
  });

  testWidgets('Pengujian UI HomePage, ProductCard, dan TokoKitaApp', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    // Pastikan AppBar menampilkan judul dan slogan
    expect(find.text('TokoKita'), findsOneWidget);
    expect(find.text('Belanja jadi lebih mudah'), findsOneWidget);

    // Pastikan kartu produk muncul di ListView
    expect(find.text('Laptop Ultrabook 14 Pro'), findsOneWidget);

    // Uji interaksi tombol favorit
    final favoriteIcon = find.byIcon(Icons.favorite_border).first;
    await tester.tap(favoriteIcon);
    await tester.pumpAndSettle();

    // Sekarang ikon favorit aktif harus ditemukan
    expect(find.byIcon(Icons.favorite), findsAtLeastNWidgets(1));
  });

  testWidgets('Pengujian Pertemuan 5: Bottom Navigation Tab Switching', (WidgetTester tester) async {
    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    // Pastikan berada di tab Beranda (HomePage)
    expect(find.text('Katalog Produk (20)'), findsOneWidget);

    // Pindah ke tab Keranjang via BottomNavigationBar
    await tester.tap(find.text('Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang Belanja Kosong'), findsOneWidget);

    // Pindah ke tab Profil via BottomNavigationBar
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Fawwaz Wijdan'), findsOneWidget);
    expect(find.text('Riwayat Pesanan'), findsOneWidget);

    // Kembali ke tab Beranda via BottomNavigationBar
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Katalog Produk (20)'), findsOneWidget);
  });

  test('Pengujian Praktikum 6: CartController (State Management GetX)', () {
    final controller = Get.find<CartController>();
    expect(controller.isEmpty, isTrue);
    expect(controller.totalItem, 0);
    expect(controller.totalHarga, 0.0);

    final product1 = Product(
      id: 'P-1',
      name: 'Keyboard Mechanical',
      price: 500000,
      imageUrl: 'keyboard.png',
      category: 'Elektronik',
      stock: 10,
    );

    final promoProduct = DiscountedProduct(
      id: 'P-2',
      name: 'Mouse Gaming',
      price: 200000,
      imageUrl: 'mouse.png',
      category: 'Elektronik',
      stock: 5,
      discountPercent: 10,
    );

    controller.addToCart(product1, 2);
    expect(controller.items.length, 1);
    expect(controller.totalItem, 2);
    expect(controller.totalHarga, 1000000.0);

    controller.addToCart(promoProduct, 1);
    expect(controller.items.length, 2);
    expect(controller.totalItem, 3);
    expect(controller.totalHarga, 1180000.0);

    controller.increaseQuantity(promoProduct);
    expect(controller.totalItem, 4);
    expect(controller.totalHarga, 1360000.0);

    controller.decreaseQuantity(product1);
    expect(controller.totalItem, 3);
    expect(controller.totalHarga, 860000.0);

    controller.removeFromCart(promoProduct);
    expect(controller.items.length, 1);
    expect(controller.totalItem, 1);
    expect(controller.totalHarga, 500000.0);

    controller.clearCart();
    expect(controller.isEmpty, isTrue);
    expect(controller.totalItem, 0);
    expect(controller.totalHarga, 0.0);
  });

  testWidgets('Pengujian Tambah ke Keranjang via Detail Page & Reaktivitas Obx', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const TokoKitaApp());
    await tester.pumpAndSettle();

    final controller = Get.find<CartController>();
    expect(controller.totalItem, 0);

    await tester.tap(find.text('Laptop Ultrabook 14 Pro'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Produk'), findsOneWidget);
    expect(find.text('Atur Jumlah Pembelian'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.pumpAndSettle();

    expect(controller.totalItem, 2);
    expect(controller.items.length, 1);
    expect(controller.items.first.product.name, 'Laptop Ultrabook 14 Pro');

    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsWidgets);
  });

  testWidgets('Pengujian CheckoutPage Ringkasan dan Simulasi Bayar', (WidgetTester tester) async {
    final controller = Get.find<CartController>();
    controller.addToCart(
      Product(
        id: 'TEST-CHK',
        name: 'Produk Uji Checkout',
        price: 50000,
        imageUrl: 'test.png',
        category: 'Elektronik',
        stock: 5,
      ),
      2,
    );

    await tester.pumpWidget(const GetMaterialApp(
      home: CheckoutPage(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Checkout Pesanan'), findsOneWidget);
    expect(find.text('Produk Uji Checkout'), findsOneWidget);
    expect(find.text('Rincian Pembayaran'), findsOneWidget);
    expect(find.text('Bayar Sekarang'), findsOneWidget);

    await tester.tap(find.text('Bayar Sekarang'));
    await tester.pumpAndSettle();

    expect(find.text('Pembayaran Berhasil'), findsOneWidget);
    expect(find.text('Ke Beranda'), findsOneWidget);
    expect(controller.isEmpty, isTrue);
  });
}
