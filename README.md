# TokoKita - Pemrograman Mobile

Aplikasi e-commerce sederhana berbasis **Flutter** yang dikembangkan untuk tugas mata kuliah **Pemrograman Mobile**. Proyek ini mencakup implementasi konsep Object-Oriented Programming (OOP), Custom Widgets, Navigasi Multi-Halaman, serta State Management reaktif menggunakan **GetX**.

---

## 👤 Identitas Mahasiswa

- **Nama:** Fawwaz Wijdan
- **NIM:** 3337240058
- **Mata Kuliah:** Pemrograman Mobile
- **Repositori:** [Pemgrograman_-Mobile](https://github.com/fawwazking/Pemgrograman_-Mobile)

---

## 🚀 Fitur Utama & Perkembangan Praktikum

### 1. Praktikum Pertemuan 2: Model & Logika OOP (Dart)
- **Model `Product` & `DiscountedProduct`**: Enkapsulasi properti produk (id, nama, harga, stok, deskripsi, gambar).
- **Inheritance & Polymorphism**: Penanganan diskon produk dengan diskon persentase dan validasi harga akhir.
- **Logika Stok**: Status ketersediaan stok (`Tersedia`, `Stok Menipis`, `Habis`).

### 2. Praktikum Pertemuan 5: UI, Komponen Kustom & Navigasi
- **Custom Reusable Widgets**:
  - `ProductCard`: Kartu produk interaktif dengan indikator stok dan harga.
  - `PriceLabel`: Format mata uang Rupiah (`formatRupiah`) dengan styling diskon.
  - `StockBadge`: Badge status stok dinamis.
  - `CategoryTag`: Tag kategori produk.
- **Navigasi Multi-Halaman**:
  - `MainPage`: Shell navigasi utama dengan `BottomNavigationBar` (Beranda, Keranjang, Profil).
  - `HomePage`: Menampilkan daftar katalog produk.
  - `ProductDetailPage`: Halaman rincian produk dengan pengiriman parameter & tombol aksi keranjang.
  - `ProfilePage`: Informasi profil pengguna.

### 3. Praktikum Pertemuan 6: State Management dengan GetX
- **`CartController`**:
  - State reaktif (`RxList`, `RxMap`, `RxDouble`) untuk mengelola item keranjang belanja.
  - Fitur tambah item ke keranjang (`addToCart`) dengan snackbar konfirmasi.
  - Pengaturan kuantitas produk (+ / -) dengan pembaruan subtotal seketika.
  - Hapus produk tunggal dan dialog konfirmasi kosongkan keranjang (`clearCart`).
  - Badge jumlah item di keranjang yang otomatis reaktif (`Obx`).
- **`CartPage`**: Daftar belanja interaktif dengan kalkulasi total harga otomatis.
- **`CheckoutPage`**: Rincian transaksi, ringkasan biaya, dan simulasi pembayaran sukses.

---

## 📁 Struktur Direktori

```text
tokokita/
├── lib/
│   ├── controllers/
│   │   └── cart_controller.dart      # State management GetX untuk keranjang
│   ├── models/
│   │   └── product.dart              # Model data Product & data dummy katalog
│   ├── screens/
│   │   ├── cart_page.dart            # Halaman keranjang belanja
│   │   ├── checkout_page.dart        # Halaman ringkasan checkout
│   │   ├── home_page.dart            # Halaman katalog produk
│   │   ├── main_page.dart            # Shell navigasi & bottom navigation bar
│   │   ├── product_detail_page.dart  # Halaman detail produk
│   │   └── profile_page.dart         # Halaman profil pengguna
│   ├── widgets/
│   │   ├── category_tag.dart         # Widget tag kategori
│   │   ├── price_label.dart          # Widget format harga & diskon
│   │   ├── product_card.dart         # Widget kartu item produk
│   │   └── stock_badge.dart          # Widget badge ketersediaan stok
│   └── main.dart                     # Entry point aplikasi & konfigurasi tema
├── test/
│   └── widget_test.dart              # Unit testing & Widget testing komprehensif
├── pubspec.yaml                      # Konfigurasi dependensi project (GetX, dll)
└── README.md                         # Dokumentasi proyek
```

---

## 🛠️ Cara Menjalankan Project

1. **Clone Repositori**:
   ```bash
   git clone https://github.com/fawwazking/Pemgrograman_-Mobile.git
   cd Pemgrograman_-Mobile
   ```

2. **Install Dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan Aplikasi**:
   ```bash
   flutter run
   ```

4. **Jalankan Automated Tests**:
   ```bash
   flutter test
   ```
