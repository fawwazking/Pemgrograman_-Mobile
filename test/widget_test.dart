import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/models/product.dart';

void main() {
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
}
