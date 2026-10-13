// ============================================================================
// PRAKTIKUM PEMROGRAMAN MOBILE - PERTEMUAN 2 & 3
// MODEL     : Product
// DESKRIPSI : Class model produk beserta data dummy dan fungsi utilitas.
// ============================================================================

// ignore_for_file: avoid_print

// ============================================================================
// LANGKAH 5 & TUGAS MANDIRI 1: MODEL DATA & OOP (CLASS & NULL SAFETY)
// ============================================================================

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  int stock;
  final String? description; // Nullable: boleh null jika tidak diisi

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.description, // Optional parameter
  });

  // Tugas Mandiri 1: Method tambahan untuk cek status stok
  String getStatusStok() {
    if (stock <= 0) {
      return 'Habis';
    } else if (stock <= 5) {
      return 'Stok Terbatas';
    } else {
      return 'Tersedia';
    }
  }

  void tampilkanInfo() {
    print(
      '[$category] $name - Rp ${price.toStringAsFixed(0)} (Stok: $stock | Status: ${getStatusStok()})',
    );
    if (description != null) {
      print('  Deskripsi: $description');
    }
  }
}

// Langkah 5: Inheritance
class DiscountedProduct extends Product {
  final double discountPercent; // Contoh: 10.0 untuk 10%

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

  // Method untuk menghitung harga setelah diskon
  double get finalPrice => price - (price * (discountPercent / 100));

  @override
  void tampilkanInfo() {
    print('[$category - PROMO DISKON ${discountPercent.toInt()}%] $name');
    print(
      '  Harga Asli: Rp ${price.toStringAsFixed(0)} -> Harga Diskon: Rp ${finalPrice.toStringAsFixed(0)} (Stok: $stock)',
    );
  }
}

// ============================================================================
// LANGKAH 4 & TUGAS MANDIRI 3: FUNCTIONS
// ============================================================================

// Arrow function untuk format mata uang
String formatRupiah(double nominal) => 'Rp ${nominal.toStringAsFixed(0)}';

// Function dengan named & optional parameter
double hitungHargaSetelahDiskon(double harga, {double persenDiskon = 0.0}) {
  return harga - (harga * (persenDiskon / 100));
}

// Tugas Mandiri 3: Function hitung total belanja dari List<Product>
double hitungTotalBelanja(List<Product> keranjang) {
  double total = 0.0;
  for (var item in keranjang) {
    if (item is DiscountedProduct) {
      total += item.finalPrice;
    } else {
      total += item.price;
    }
  }
  return total;
}

// ============================================================================
// TUGAS MANDIRI 2: DATA DUMMY PRODUK (top-level, dapat diakses dari main.dart)
// ============================================================================

/// Daftar produk dummy yang digunakan sebagai sumber data katalog (20 produk).
final List<Product> dummyProducts = [
  DiscountedProduct(
    id: 'P01',
    name: 'Laptop Ultrabook 14 Pro',
    price: 13500000,
    imageUrl: 'assets/laptop.png',
    category: 'Elektronik',
    stock: 8, // Tersedia
    description: 'Intel Core i7 Gen 13, RAM 16GB, SSD 512GB NVMe ringkas dan elegan.',
    discountPercent: 10,
  ),
  Product(
    id: 'P02',
    name: 'Mouse Wireless Silent Click',
    price: 175000,
    imageUrl: 'assets/mouse.png',
    category: 'Elektronik',
    stock: 4, // Stok Terbatas
    description: 'Dual-mode Bluetooth 5.0 dan 2.4GHz USB receiver hemat daya.',
  ),
  Product(
    id: 'P03',
    name: 'Mechanical Gaming Keyboard RGB',
    price: 520000,
    imageUrl: 'assets/keyboard.png',
    category: 'Elektronik',
    stock: 0, // Habis
    description: 'Blue switch tactile clicky dengan lampu backlit RGB dinamis.',
  ),
  DiscountedProduct(
    id: 'P04',
    name: 'Smartwatch Fitness Tracker',
    price: 650000,
    imageUrl: 'assets/smartwatch.png',
    category: 'Elektronik',
    stock: 12, // Tersedia
    description: 'Sensor detak jantung, SpO2, sleep tracking, dan tahan air 5 ATM.',
    discountPercent: 15,
  ),
  Product(
    id: 'P05',
    name: 'Kaos Polos Cotton Combed 30s',
    price: 65000,
    imageUrl: 'assets/kaos.png',
    category: 'Fashion',
    stock: 35, // Tersedia
    description: 'Bahan 100% combed cotton lembut, adem dan menyerap keringat.',
  ),
  DiscountedProduct(
    id: 'P06',
    name: 'Kemeja Batik Modern Slim Fit',
    price: 185000,
    imageUrl: 'assets/kemeja.png',
    category: 'Fashion',
    stock: 3, // Stok Terbatas
    description: 'Batik cap motif elegan dengan potongan slim fit modern.',
    discountPercent: 20,
  ),
  Product(
    id: 'P07',
    name: 'Jaket Hoodie Fleece Premium',
    price: 240000,
    imageUrl: 'assets/hoodie.png',
    category: 'Fashion',
    stock: 0, // Habis
    description: 'Bahan cotton fleece tebal dan hangat dengan kantong kangguru.',
  ),
  Product(
    id: 'P08',
    name: 'Celana Chino Slim Fit Pria',
    price: 160000,
    imageUrl: 'assets/chino.png',
    category: 'Fashion',
    stock: 15, // Tersedia
    description: 'Celana panjang katun stretch elastis nyaman untuk kerja & santai.',
  ),
  DiscountedProduct(
    id: 'P09',
    name: 'Kopi Arabika Gayo Specialty 250g',
    price: 85000,
    imageUrl: 'assets/kopi.png',
    category: 'Makanan',
    stock: 18, // Tersedia
    description: 'Biji kopi pilihan roasted medium dengan notes buah dan karamel.',
    discountPercent: 12,
  ),
  Product(
    id: 'P10',
    name: 'Keripik Singkong Pedas Manis',
    price: 22000,
    imageUrl: 'assets/keripik.png',
    category: 'Makanan',
    stock: 2, // Stok Terbatas
    description: 'Keripik renyah berbalut bumbu cabai asli khas nusantara.',
  ),
  Product(
    id: 'P11',
    name: 'Madu Hutan Liar Murni 500ml',
    price: 110000,
    imageUrl: 'assets/madu.png',
    category: 'Makanan',
    stock: 0, // Habis
    description: 'Madu alami murni kaya antioksidan tanpa tambahan gula pengawet.',
  ),
  DiscountedProduct(
    id: 'P12',
    name: 'Granola Cokelat Almond 400g',
    price: 68000,
    imageUrl: 'assets/granola.png',
    category: 'Makanan',
    stock: 14, // Tersedia
    description: 'Sarapan sereal gandum panggang dengan dark chocolate dan kacang almond.',
    discountPercent: 25,
  ),
  Product(
    id: 'P13',
    name: 'Sepatu Running Breathable',
    price: 420000,
    imageUrl: 'assets/sepatu.png',
    category: 'Olahraga',
    stock: 5, // Stok Terbatas
    description: 'Sol busa empuk dengan sirkulasi udara mesh atas yang ringan.',
  ),
  DiscountedProduct(
    id: 'P14',
    name: 'Matras Yoga Anti-Slip TPE 6mm',
    price: 175000,
    imageUrl: 'assets/matras.png',
    category: 'Olahraga',
    stock: 9, // Tersedia
    description: 'Bahan ramah lingkungan anti-slip dengan garis panduan postur tubuh.',
    discountPercent: 15,
  ),
  Product(
    id: 'P15',
    name: 'Botol Minum Olahraga 1 Liter',
    price: 48000,
    imageUrl: 'assets/botol.png',
    category: 'Olahraga',
    stock: 0, // Habis
    description: 'Botol plastik Tritan BPA-Free dengan penanda waktu minum harian.',
  ),
  DiscountedProduct(
    id: 'P16',
    name: 'Buku Pemrograman Flutter & Dart',
    price: 125000,
    imageUrl: 'assets/buku_flutter.png',
    category: 'Buku',
    stock: 16, // Tersedia
    description: 'Panduan komprehensif membangun aplikasi mobile modern dari dasar.',
    discountPercent: 20,
  ),
  Product(
    id: 'P17',
    name: 'Buku Filosofi Teras',
    price: 98000,
    imageUrl: 'assets/buku_filosofi.png',
    category: 'Buku',
    stock: 3, // Stok Terbatas
    description: 'Penerapan filsafat stoisisme kuno untuk mental tangguh masa kini.',
  ),
  Product(
    id: 'P18',
    name: 'Lampu Meja LED Fleksibel',
    price: 89000,
    imageUrl: 'assets/lampu.png',
    category: 'Elektronik',
    stock: 20, // Tersedia
    description: '3 tingkat kecerahan dengan leher silikon fleksibel dan baterai isi ulang.',
  ),
  DiscountedProduct(
    id: 'P19',
    name: 'Tas Ransel Laptop Anti-Air',
    price: 295000,
    imageUrl: 'assets/ransel.png',
    category: 'Fashion',
    stock: 5, // Stok Terbatas
    description: 'Kapasitas 20L dengan kompartemen laptop 15.6 inch dan port USB charger.',
    discountPercent: 30,
  ),
  Product(
    id: 'P20',
    name: 'Earphone TWS Bluetooth 5.3',
    price: 199000,
    imageUrl: 'assets/tws.png',
    category: 'Elektronik',
    stock: 0, // Habis
    description: 'Kualitas suara bass mendalam dengan mikrofon noise reduction jernih.',
  ),
];
