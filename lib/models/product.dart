// ignore_for_file: avoid_print

// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 2
// APLIKASI   : TOKOKITA
// MATERI     : DART OOP, NULL SAFETY, INHERITANCE & FUNCTIONS
// ============================================================================

// ============================================================================
// 1. MODEL DATA & CLASS PRODUCT (TUGAS MANDIRI 1 & NULL SAFETY)
// ============================================================================

/// Model data utama untuk produk di aplikasi TokoKita.
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  int stock; // Mutable (tanpa final): dapat diperbarui saat stok berubah
  final String? description; // Nullable (String?): bersifat opsional

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.description,
  });

  /// Method getStatusStok(): Mengecek ketersediaan stok produk
  /// - stock <= 0 : 'Habis'
  /// - stock <= 5 : 'Stok Terbatas'
  /// - selain itu : 'Tersedia'
  String getStatusStok() {
    if (stock <= 0) {
      return 'Habis';
    } else if (stock <= 5) {
      return 'Stok Terbatas';
    } else {
      return 'Tersedia';
    }
  }

  /// Method untuk menampilkan ringkasan informasi produk ke konsol
  void tampilkanInfo() {
    print('[$category] $name (ID: $id)');
    print('  Harga     : ${formatRupiah(price)}');
    print('  Stok      : $stock unit (Status: ${getStatusStok()})');
    print('  Gambar    : $imageUrl');
    if (description != null && description!.isNotEmpty) {
      print('  Deskripsi : $description');
    }
  }
}

// ============================================================================
// 2. INHERITANCE (CLASS DISCOUNTEDPRODUCT)
// ============================================================================

/// Subclass dari Product untuk produk yang memiliki potongan harga (diskon).
class DiscountedProduct extends Product {
  final double discountPercent; // Persentase diskon (misal: 20.0 untuk 20%)

  DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.stock,
    super.description,
    required this.discountPercent,
  });

  /// Getter untuk menghitung harga bersih setelah potongan diskon
  double get finalPrice =>
      hitungHargaSetelahDiskon(price, persenDiskon: discountPercent);

  @override
  void tampilkanInfo() {
    print(
      '[$category - PROMO DISKON ${discountPercent.toInt()}%] $name (ID: $id)',
    );
    print('  Harga Asli   : ${formatRupiah(price)}');
    print(
      '  Harga Diskon : ${formatRupiah(finalPrice)} (Hemat: ${formatRupiah(price - finalPrice)})',
    );
    print('  Stok         : $stock unit (Status: ${getStatusStok()})');
    print('  Gambar       : $imageUrl');
    if (description != null && description!.isNotEmpty) {
      print('  Deskripsi    : $description');
    }
  }
}

// ============================================================================
// 3. HELPER FUNCTIONS (TUGAS MANDIRI 3)
// ============================================================================

/// Arrow function untuk memformat angka nominal menjadi representasi Rupiah
String formatRupiah(double nominal) => 'Rp ${nominal.toStringAsFixed(0)}';

/// Function dengan named optional parameter untuk menghitung harga setelah diskon
double hitungHargaSetelahDiskon(double harga, {double persenDiskon = 0.0}) {
  return harga - (harga * (persenDiskon / 100));
}

/// Function untuk menghitung total nilai belanja dari list produk
double hitungTotalBelanja(List<Product> keranjang) {
  double total = 0.0;
  for (final item in keranjang) {
    if (item is DiscountedProduct) {
      total += item.finalPrice;
    } else {
      total += item.price;
    }
  }
  return total;
}

// ============================================================================
// 4. DUMMY DATA (TUGAS MANDIRI 2: MINIMAL 8 PRODUK BERVARIASI)
// ============================================================================

final List<Product> dummyProducts = [
  Product(
    id: 'P01',
    name: 'Laptop Gaming ASUS ROG',
    price: 18500000.0,
    imageUrl: 'assets/laptop_rog.png',
    category: 'Elektronik',
    stock: 8, // Stok Tersedia (> 5)
    description: 'Laptop bertenaga tinggi untuk coding dan multitasking.',
  ),
  Product(
    id: 'P02',
    name: 'Mouse Wireless Silent Click',
    price: 150000.0,
    imageUrl: 'assets/mouse_wireless.png',
    category: 'Elektronik',
    stock: 3, // Stok Terbatas (1 - 5)
    description: 'Konektivitas dual mode Bluetooth & 2.4GHz USB Dongle.',
  ),
  Product(
    id: 'P03',
    name: 'Mechanical Keyboard RGB',
    price: 450000.0,
    imageUrl: 'assets/keyboard_rgb.png',
    category: 'Elektronik',
    stock: 0, // Stok Habis (<= 0)
    description: null, // Nullable parameter tanpa deskripsi
  ),
  Product(
    id: 'P04',
    name: 'Kaos Polos Cotton Combed 30s',
    price: 65000.0,
    imageUrl: 'assets/kaos_cotton.png',
    category: 'Fashion',
    stock: 25, // Stok Tersedia
    description: 'Bahan katun adem dan nyaman digunakan sehari-hari.',
  ),
  Product(
    id: 'P05',
    name: 'Kemeja Flanel Casual',
    price: 135000.0,
    imageUrl: 'assets/kemeja_flanel.png',
    category: 'Fashion',
    stock: 4, // Stok Terbatas
    description: null, // Nullable parameter tanpa deskripsi
  ),
  Product(
    id: 'P06',
    name: 'Kopi Susu Gula Aren 1 Liter',
    price: 75000.0,
    imageUrl: 'assets/kopi_literan.png',
    category: 'Makanan',
    stock: 15, // Stok Tersedia
    description:
        'Espresso blend pilihan dengan susu segar dan gula aren murni.',
  ),
  Product(
    id: 'P07',
    name: 'Keripik Tempe Renyah Gurih',
    price: 18000.0,
    imageUrl: 'assets/keripik_tempe.png',
    category: 'Makanan',
    stock: 50, // Stok Tersedia
    description: null, // Nullable parameter tanpa deskripsi
  ),
  Product(
    id: 'P08',
    name: 'Headphone Bluetooth ANC',
    price: 320000.0,
    imageUrl: 'assets/headphone_anc.png',
    category: 'Elektronik',
    stock: 2, // Stok Terbatas
    description: 'Fitur Active Noise Cancelling untuk pengalaman audio jernih.',
  ),
  DiscountedProduct(
    id: 'P09',
    name: 'Smartwatch Fitness Tracker',
    price: 500000.0,
    imageUrl: 'assets/smartwatch.png',
    category: 'Elektronik',
    stock: 5, // Stok Terbatas dengan Diskon
    discountPercent: 20.0,
    description: 'Monitor detak jantung, SpO2, dan pelacak aktivitas olahraga.',
  ),
];

// ============================================================================
// 5. MAIN FUNCTION (PENGUJIAN & DEMONSTRASI SELURUH FITUR)
// ============================================================================

void main() {
  print('============================================================');
  print('       PRAKTIKUM 2 PEMROGRAMAN MOBILE - TOKOKITA            ');
  print('============================================================\n');

  // --------------------------------------------------------------------------
  // LANGKAH 1 s.d. 3: DASAR DART (Variabel, Operator, Control Flow)
  // --------------------------------------------------------------------------
  print('=== [1] PENGUJIAN VARIABEL, OPERATOR & KONDISI ===');
  const String namaToko = 'TokoKita Official';
  final String tanggalUji = DateTime.now().toString().split(' ')[0];
  var totalKategori = 3;

  print('Toko           : $namaToko');
  print('Tanggal Uji    : $tanggalUji');
  print('Total Kategori : $totalKategori (Elektronik, Fashion, Makanan)\n');

  // --------------------------------------------------------------------------
  // LANGKAH 4 & TUGAS MANDIRI 3: HELPER FUNCTIONS
  // --------------------------------------------------------------------------
  print('=== [2] PENGUJIAN HELPER FUNCTIONS ===');
  double hargaUji = 200000.0;
  double persenDiskonUji = 15.0;
  double hargaSetelahDiskon = hitungHargaSetelahDiskon(
    hargaUji,
    persenDiskon: persenDiskonUji,
  );

  print('Arrow Function formatRupiah  : ${formatRupiah(hargaUji)}');
  print('Harga Normal                 : ${formatRupiah(hargaUji)}');
  print('Diskon                       : ${persenDiskonUji.toInt()}%');
  print('Harga Setelah Diskon         : ${formatRupiah(hargaSetelahDiskon)}\n');

  // --------------------------------------------------------------------------
  // LANGKAH 5 & TUGAS MANDIRI 2: DUMMY DATA & getStatusStok()
  // --------------------------------------------------------------------------
  print('=== [3] DAFTAR KATALOG PRODUK (DUMMY DATA - MINIMAL 8 ITEM) ===');
  print('Total item dalam katalog: ${dummyProducts.length} produk\n');

  for (int i = 0; i < dummyProducts.length; i++) {
    print('Produk #${i + 1}:');
    dummyProducts[i].tampilkanInfo();
    print('------------------------------------------------------------');
  }

  // --------------------------------------------------------------------------
  // LANGKAH 5 (INHERITANCE): PENGUJIAN DISCOUNTEDPRODUCT
  // --------------------------------------------------------------------------
  print('\n=== [4] PENGUJIAN INHERITANCE (DiscountedProduct) ===');
  DiscountedProduct promoSpesial = DiscountedProduct(
    id: 'PROMO-SPESIAL-01',
    name: 'Sepatu Running Sporty',
    price: 750000.0,
    imageUrl: 'assets/sepatu_sporty.png',
    category: 'Fashion',
    stock: 5,
    discountPercent: 30.0,
    description: 'Sepatu lari ringan dengan bantalan ekstra nyaman.',
  );
  promoSpesial.tampilkanInfo();

  // --------------------------------------------------------------------------
  // TUGAS MANDIRI 3: PENGUJIAN hitungTotalBelanja()
  // --------------------------------------------------------------------------
  print('\n=== [5] PENGUJIAN FUNGSI hitungTotalBelanja() ===');
  List<Product> keranjangSimulasi = [
    dummyProducts[0], // Laptop (Rp 18.500.000)
    dummyProducts[1], // Mouse (Rp 150.000)
    dummyProducts[5], // Kopi (Rp 75.000)
    promoSpesial, // Sepatu Diskon 30% (Rp 750.000 -> Rp 525.000)
  ];

  print('Item dalam Keranjang Belanja:');
  for (var item in keranjangSimulasi) {
    if (item is DiscountedProduct) {
      print(
        '  - ${item.name} (${item.category}) : ${formatRupiah(item.finalPrice)} [Diskon ${item.discountPercent.toInt()}%]',
      );
    } else {
      print(
        '  - ${item.name} (${item.category}) : ${formatRupiah(item.price)}',
      );
    }
  }

  double totalKeranjang = hitungTotalBelanja(keranjangSimulasi);
  print('\n=> Total Nilai Keranjang Belanja : ${formatRupiah(totalKeranjang)}');

  double totalSeluruhKatalog = hitungTotalBelanja(dummyProducts);
  print(
    '=> Total Nilai Seluruh Katalog   : ${formatRupiah(totalSeluruhKatalog)}\n',
  );

  // --------------------------------------------------------------------------
  // PENGUJIAN MUTABILITAS STOK (MUTABLE FIELD & getStatusStok)
  // --------------------------------------------------------------------------
  print('=== [6] PENGUJIAN PERUBAHAN STOK (MUTABLE STOCK & STATUS) ===');
  Product produkUjiStok = Product(
    id: 'TEST-MUTASI',
    name: 'Powerbank Fast Charging 10000mAh',
    price: 199000.0,
    imageUrl: 'assets/powerbank.png',
    category: 'Elektronik',
    stock: 10,
  );

  print(
    '1. Kondisi Awal      : Stok = ${produkUjiStok.stock} unit -> Status: "${produkUjiStok.getStatusStok()}"',
  );
  produkUjiStok.stock = 4; // Mengubah nilai properti stock (mutable)
  print(
    '2. Terjual 6 Unit    : Stok = ${produkUjiStok.stock} unit  -> Status: "${produkUjiStok.getStatusStok()}"',
  );
  produkUjiStok.stock = 0; // Mengubah nilai properti stock menjadi 0
  print(
    '3. Terjual Habis     : Stok = ${produkUjiStok.stock} unit  -> Status: "${produkUjiStok.getStatusStok()}"',
  );

  print('\n============================================================');
  print('       SEMUA PENGUJIAN PRAKTIKUM BERHASIL DIJALANKAN        ');
  print('============================================================');
}
