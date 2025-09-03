// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'ConvertEase';

  @override
  String get selectCategory => 'Pilih kategori konversi';

  @override
  String get converter => 'Konverter';

  @override
  String get loading => 'Memuat...';

  @override
  String get enterColorValue => 'Masukkan nilai warna';

  @override
  String get enterValueToConvert => 'Masukkan nilai untuk dikonversi';

  @override
  String get pleaseEnterValue => 'Silakan masukkan nilai';

  @override
  String get selectUnits => 'Pilih Satuan';

  @override
  String get from => 'Dari';

  @override
  String get to => 'Ke';

  @override
  String get convert => 'Konversi';

  @override
  String get result => 'Hasil';

  @override
  String get waitingForInput => 'Menunggu input...';

  @override
  String get resultCopied => 'Hasil disalin ke clipboard';

  @override
  String get unit => 'Satuan';

  @override
  String get currency => 'Mata Uang';

  @override
  String get units => 'satuan';

  @override
  String get showMore => 'Tampilkan Lebih Banyak';

  @override
  String get showLess => 'Tampilkan Lebih Sedikit';

  @override
  String hiding(int count) {
    return 'Menyembunyikan $count kategori';
  }

  @override
  String moreCategories(int count) {
    return '+$count lagi';
  }

  @override
  String get settings => 'Pengaturan';

  @override
  String get language => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get english => 'English';

  @override
  String get chinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get languageChanged => 'Bahasa berhasil diubah';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get lightMode => 'Mode Terang';

  @override
  String get about => 'Tentang';

  @override
  String get appName => 'Nama Aplikasi';

  @override
  String get version => 'Versi';

  @override
  String get buildNumber => 'Nomor Build';

  @override
  String get developer => 'Pengembang';

  @override
  String get appDescription =>
      'Aplikasi konversi unit yang powerful dan indah\nmendukung berbagai kategori dan bahasa.';

  @override
  String get themeSwitchingComingSoon => 'Pergantian tema segera hadir!';

  @override
  String get home => 'Beranda';

  @override
  String get history => 'Riwayat';

  @override
  String get favorites => 'Favorit';

  @override
  String get conversionHistory => 'Riwayat Konversi';

  @override
  String get clearAll => 'Hapus Semua';

  @override
  String get clearAllHistory => 'Hapus Semua Riwayat';

  @override
  String get clearAllHistoryConfirm =>
      'Apakah Anda yakin ingin menghapus semua riwayat konversi?';

  @override
  String get cancel => 'Batal';

  @override
  String get noConversionHistory => 'Tidak Ada Riwayat Konversi';

  @override
  String get historyWillAppearHere =>
      'Riwayat konversi Anda akan muncul di sini';

  @override
  String get category => 'Kategori';

  @override
  String get time => 'Waktu';

  @override
  String get delete => 'Hapus';

  @override
  String get favoritesComingSoon => 'Fitur favorit segera hadir!';

  @override
  String get failedToLoadCurrencies => 'Gagal memuat mata uang';

  @override
  String get failedToLoadHistory => 'Gagal memuat riwayat';

  @override
  String get exchangeFailed => 'Pertukaran gagal';

  @override
  String get invalidResult => 'Format hasil tidak valid';

  @override
  String get noResult => 'Tidak ada hasil';

  @override
  String get error => 'Kesalahan';

  @override
  String get conversionNotImplemented => 'Konversi belum diimplementasikan';

  @override
  String get invalidColorFormat => 'Format warna tidak valid';

  @override
  String get invalidHexFormat => 'Format hex tidak valid';

  @override
  String get invalidRgbFormat => 'Format RGB tidak valid';

  @override
  String get rateUpdatedRecently => 'Kurs baru saja diperbarui';

  @override
  String get rateUpdatedJustNow => 'Kurs baru saja diperbarui';

  @override
  String rateUpdatedMinutesAgo(int minutes, String plural) {
    return 'Kurs diperbarui $minutes menit yang lalu';
  }

  @override
  String rateUpdatedHoursAgo(int hours, String plural) {
    return 'Kurs diperbarui $hours jam yang lalu';
  }

  @override
  String rateUpdatedDaysAgo(int days, String plural) {
    return 'Kurs diperbarui $days hari yang lalu';
  }

  @override
  String rateUpdatedAt(String time) {
    return 'Kurs diperbarui pada: $time';
  }

  @override
  String get categoryLength => 'Panjang';

  @override
  String get categoryArea => 'Luas';

  @override
  String get categoryVolume => 'Volume';

  @override
  String get categoryWeight => 'Berat';

  @override
  String get categoryTemperature => 'Suhu';

  @override
  String get categoryStorage => 'Penyimpanan';

  @override
  String get categorySpeed => 'Kecepatan';

  @override
  String get categoryColor => 'Warna';

  @override
  String get categoryEnergy => 'Energi';

  @override
  String get categoryPressure => 'Tekanan';

  @override
  String get categoryAngle => 'Sudut';

  @override
  String get conversionHistoryEmpty => 'Belum ada riwayat konversi';

  @override
  String get startConverting =>
      'Mulai mengkonversi untuk melihat riwayat di sini';

  @override
  String get deleteItem => 'Hapus Item';

  @override
  String get deleteItemConfirm => 'Apakah Anda yakin ingin menghapus item ini?';

  @override
  String get appSubtitle => 'Konverter Unit yang Powerful';

  @override
  String get darkModeTitle => 'Mode Gelap';

  @override
  String get darkModeSubtitle => 'Aktifkan tema gelap yang ramah mata';

  @override
  String get accentColor => 'Warna Aksen';

  @override
  String get colorPicker => 'Pemilih Warna';

  @override
  String get selectColor => 'Pilih Warna';

  @override
  String get chooseFromPalette => 'Pilih dari Palet';

  @override
  String get colorSelected => 'Warna dipilih';

  @override
  String get pickColor => 'Ambil Warna';

  @override
  String get useSelectedColor => 'Gunakan Warna yang Dipilih';
}
