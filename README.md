# Tokopedia Clone - Flutter Project

## Struktur Folder

```
tokopedia_clone/
├── lib/
│   ├── main.dart                          ← Entry point app
│   ├── screens/
│   │   └── home_screen.dart               ← Routing responsive (desktop/mobile)
│   ├── constants/
│   │   └── app_constants.dart             ← Warna, text style
│   ├── models/
│   │   └── product_model.dart             ← Data produk
│   └── widgets/
│       ├── shared/
│       │   └── product_card.dart          ← Card produk (dipakai desktop & mobile)
│       ├── desktop/
│       │   ├── desktop_home.dart          ← Layout utama desktop
│       │   ├── desktop_navbar.dart        ← Navbar desktop
│       │   ├── desktop_banner.dart        ← Banner carousel desktop
│       │   ├── desktop_kategori_topup.dart ← Kategori Populer + Top Up
│       │   └── desktop_product_section.dart ← Grid produk desktop (6 kolom)
│       └── mobile/
│           ├── mobile_home.dart           ← Layout utama mobile
│           ├── mobile_navbar.dart         ← Navbar mobile
│           ├── mobile_banner.dart         ← Banner carousel mobile
│           ├── mobile_quick_access.dart   ← Tombol Bonus, Aktifkan, dll
│           ├── mobile_exklusif_section.dart ← Eksklusif Pengguna Baru
│           ├── mobile_product_section.dart ← Grid produk mobile (2 kolom)
│           └── mobile_bottom_nav.dart     ← Bottom navigation bar
├── assets/
│   ├── images/                            ← Taruh gambar hasil crop di sini
│   └── icons/                             ← Taruh ikon hasil crop di sini
└── pubspec.yaml                           ← Konfigurasi assets
```

## Cara Menjalankan

```bash
flutter pub get
flutter run -d chrome   # Untuk web
```

## Cara Mengganti Placeholder dengan Gambar Asli

Setelah kamu crop gambar dari screenshot, taruh di folder `assets/images/` dan `assets/icons/`
sesuai nama file yang sudah didaftarkan di `pubspec.yaml`.

### Daftar Gambar yang Dibutuhkan

#### assets/images/
| File | Keterangan |
|------|-----------|
| banner_1.png | Banner desktop slide 1 (background) |
| banner_2.png | Banner desktop slide 2 |
| banner_3.png | Banner desktop slide 3 |
| banner_product_1.png | Produk di sebelah kanan banner desktop |
| mascot.png | Maskot Tokopedia di Kategori Populer |
| mobile_banner_1.png | Banner mobile slide 1 |
| mobile_banner_2.png | Banner mobile slide 2 |
| mobile_banner_3.png | Banner mobile slide 3 |
| banner_mobile_product.png | Gambar kartu di banner mobile |
| new_user_product_1.png | Produk pertama di seksi Pengguna Baru |
| new_user_product_2.png | Produk kedua di seksi Pengguna Baru |
| product_1.png s/d product_12.png | 12 produk di grid |

#### assets/icons/
| File | Keterangan |
|------|-----------|
| cat_0.png s/d cat_6.png | 7 ikon kategori desktop (Kategori, HP&Tablet, dll) |
| cat_mobile_0.png s/d cat_mobile_5.png | 6 ikon kategori mobile (Mulai Langganan, dll) |
| quick_0.png s/d quick_3.png | 4 ikon quick access (Bonus, Aktifkan, Cek Kupon, Ja) |

## Responsive Breakpoint

- **≥ 768px** → Tampilan Desktop (6 kolom produk, navbar lengkap)
- **< 768px** → Tampilan Mobile (2 kolom produk, bottom nav)

Saat di-inspect di browser dan pilih tampilan mobile, otomatis akan switch ke tampilan mobile.
