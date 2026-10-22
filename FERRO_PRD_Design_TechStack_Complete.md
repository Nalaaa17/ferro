# 🎵 FERRO — Universal Offline Audio Player
## Dokumen Lengkap: PRD Final + Design System + Spesifikasi Halaman + Tech Stack
**Versi Dokumen:** v1.5 Final | **Tanggal:** Oktober 2026

---

# BAGIAN I — PRODUCT REQUIREMENTS DOCUMENT

## 1. Identitas Produk

| Item | Detail |
|------|--------|
| Nama | **FERRO** |
| Tagline | *"Semua format, satu player — EQ yang hafal perangkatmu."* |
| Kategori | Audio & Music Player |
| Model | **100% Offline-only** — memutar file milik pengguna, tanpa streaming |
| Platform | Android 6.0+ (min SDK 23) |
| Distribusi | GitHub Releases (APK via link), repo publik |
| Monetisasi | Gratis tanpa iklan; tombol donasi opsional (Trakteer/Buy Me a Coffee) |
| Bahasa | Indonesia & Inggris |

## 2. Tujuan Produk

1. Memutar **semua format** audio & video populer (MP3 s/d MKV) tanpa konversi
2. **Lossless / Original Sample Rate Playback** — tanpa transcode
3. **Offline penuh** — tanpa internet, tanpa server, privasi maksimal
4. UX setara Spotify/Apple Music
5. **Fitur andalan: Per-Gear Auto Preset** — EQ otomatis berganti sesuai perangkat dengar yang tersambung
6. Iterasi feedback-driven via GitHub Issues

## 3. Target Pengguna

- Casual listener dengan koleksi file campuran (download, rekaman, screen-record)
- Audiophile pemilik FLAC/WAV & USB DAC
- Pengguna yang ingin mendengarkan audio dari file video tanpa app tambahan

## 4. Format yang Didukung

**Audio:** MP3, AAC/M4A, FLAC, WAV/PCM, OGG Vorbis, OPUS, WMA, AIFF (DSD: evaluasi v2.0)
**Audio-dari-video:** MP4, M4V, MKV, AVI, MOV, 3GP, WEBM — stream audio saja (hemat baterai)

## 5. Fitur Lengkap v1.0

| # | Fitur | Ringkasan |
|---|-------|-----------|
| 1 | Library Scanner | Scan otomatis storage (internal, SD card, OTG), kategorisasi Lagu/Album/Artis/Genre/Folder/Playlist |
| 2 | Player | All-format, lossless, gapless, crossfade (0–12 dtk), sleep timer, speed 0.5–2.0x, repeat/shuffle |
| 3 | Equalizer | 10-band custom + preset via FFmpeg filter; bass boost; virtualizer; loudness normalization |
| 4 | Now Playing | Album art besar, lirik sinkron (LRC, karaoke mode), blur background, queue management |
| 5 | Playlist | CRUD tak terbatas, multi-select, restore queue terakhir |
| 6 | Favorit & Riwayat | Like, recently played, most played |
| 7 | Per-Gear Auto Preset | Deteksi perangkat BT (nama) & USB DAC (Vendor/Product ID) → auto-switch EQ + volume tersimpan |
| 8 | Car Mode | UI besar, auto-play saat BT tersambung, gesture sederhana |
| 9 | Integrasi Sistem | Notifikasi media, lockscreen control, headset button, homescreen widget |
| 10 | File Browser | Jelajah manual per folder, exclude folder, OTG/SD card |
| 11 | Auto-Fetch Metadata | Ambil tag/album art dari file; fallback MusicBrainz (opsional, bisa dimatikan) |
| 12 | Update Checker | Cek versi via GitHub Releases API, tombol download update |
| 13 | Settings | Tema, bahasa, privasi, donasi, tentang |

## 6. Fitur Non-Fungsional

- Tap-to-play latency < 100ms; library 10.000 lagu ter-load < 3 detik
- Background playback via foreground service + `audio_service`
- Crash-free sessions ≥ 99.5%; APK < 50MB (per ABI split)
- Tidak butuh izin RECORD_AUDIO; internet hanya untuk update checker & metadata (opsional)
- Aksesibilitas: dynamic text scale, TalkBack, kontras AA

## 7. Risiko & Mitigasi (ringkas)

| Risiko | Mitigasi |
|--------|----------|
| Scope v1.0 besar | Milestone GitHub; fitur tak stabil H-2 rilis → transparan ditunda ke v1.1 |
| Nama TWS generik identik | Profil disimpan per nama + hash MAC address |
| Bundle libmpv besar | ABI split (armeabi-v7a / arm64-v8a / x86_64) |
| Pengguna bingung install APK | Panduan bergambar di README |
| Keystore hilang | Backup minimal 2 lokasi (cloud terenkripsi + offline) |

## 8. Metrik Sukses

Retention D7 ≥ 40% • sesi rata-rata ≥ 25 menit • bug report < 2% dari download •
deteksi perangkat ≥ 95% • switch profil < 2 dtk tanpa interrupt • respon issue < 7 hari •
siklus release minor 2–4 minggu

## 9. Roadmap (Feedback-Driven)

- **v1.0** — semua fitur di atas, rilis via GitHub
- **v1.1+** — bug fix & penyesuaian dari GitHub Issues, siklus 2–4 minggu
- **v2.0** — hasil voting komunitas: visualizer native, USB DAC passthrough, Chromecast, cloud import, tema custom, DSD

---

# BAGIAN II — TECH STACK LENGKAP

## 2.1 Environment

| Komponen | Versi/Catatan |
|----------|---------------|
| Flutter SDK | stable terbaru (>= 3.24) |
| Dart | >= 3.5 |
| Android Studio | Hedgehog+ dengan SDK 34 |
| Min/Compile SDK | 23 / 34 |
| Java/Kotlin | JDK 17 |
| Repo & CI | GitHub (publik) + GitHub Actions |

## 2.2 Package Utama

| Kategori | Package | Fungsi |
|----------|---------|--------|
| Audio Engine | `media_kit` + `media_kit_libs_android_audio` | Playback semua format via libmpv; EQ via `--af`; audio-only dari video |
| Background | `audio_service` | Foreground service, notifikasi media, lockscreen, headset buttons |
| State | `flutter_riverpod` | State management (reactive, testable) |
| Routing | `go_router` | Navigasi + deep link |
| Database | `isar` | DB lokal noSQL: lagu, playlist, profil perangkat, riwayat |
| Metadata | `audio_metadata_reader` | Baca tag & album art dari file |
| Permission | `permission_handler` | Izin media (Android 13+) & storage legacy |
| UI | `flutter_svg`, `lottie`, `cached_network_image` *(hanya utk metadata online)*, `shimmer` | Ikon, animasi loading |
| Util | `path_provider`, `device_info_plus`, `shared_preferences`, `equatable`, `intl` | Path, info device, prefs, value equality, format durasi |
| Update | `http` + GitHub Releases API (custom, ringan) | Cek versi terbaru |

## 2.3 Arsitektur: Feature-First Clean Architecture

```
lib/
├── main.dart
├── app/                      # App root, theme, router, observers
│   ├── app.dart
│   ├── theme/                # colors, typography, components theme
│   └── router.dart
├── core/                     # Bersifat global, tidak tahu feature
│   ├── constants/
│   ├── extensions/
│   ├── utils/                # formatters, debouncer, result wrapper
│   ├── errors/               # Failure classes + exception handler
│   └── platform/             # Method Channels (audio_devices, volume)
├── data/
│   ├── models/               # Isar entities (@collection)
│   ├── sources/              # local_db (isar), media_scanner, device_monitor
│   └── repositories/         # implementasi repository
├── domain/
│   ├── entities/             # pure Dart entities (Song, Playlist, DeviceProfile)
│   ├── repositories/         # abstract contracts
│   └── usecases/             # 1 usecase = 1 aksi bisnis
└── features/                 # 1 folder = 1 layar/fitur
    ├── library/
    │   ├── data/  domain/  presentation/
    │   └── presentation/
    │       ├── screens/
    │       ├── widgets/
    │       └── providers/
    ├── player/
    ├── equalizer/
    ├── devices/              # Per-Gear profiles
    ├── playlists/
    ├── lyrics/
    ├── car_mode/
    ├── settings/
    └── updater/
```

**Aturan main (agar aman & nyaman ngoding):**
1. Presentation → domain → data. **Tidak pernah** presentation bicara langsung ke data layer.
2. Semua state di Riverpod provider; widget se-mungkin mungkin *stateless*.
3. 1 usecase = 1 file = 1 tanggung jawab.
4. Semua operasi file/DB async → Future/Stream; UI menampilkan state loading/error/empty/success.
5. Error wajib di-wrap: `Result<T>` atau `Either`-style; **dilarang** try/catch diam-diam.

## 2.4 Pola State (Riverpod)

```dart
// Contoh pola provider per fitur
final libraryProvider = StateNotifierProvider<LibraryNotifier, LibraryState>(...);
// LibraryState = union: initial | loading | loaded(List<Song>) | error(message)
```

- `Notifier`/`StateNotifier` untuk logika; `FutureProvider`/`StreamProvider` untuk data sekali/stream.
- Player state (position, duration, playing) berasal dari stream `audio_service` → satu source of truth.

## 2.5 Database Schema (Isar)

```dart
@collection
class SongEntity {
  Id id = Isar.autoIncrement;
  @Index(unique: true) late String filePath;   // path absolut
  late String title, artist, album, genre;
  late int durationMs;
  late int fileSizeBytes;
  late String folderPath;
  String? artworkPath;      // cache art di app dir
  String? lyricsPath;       // file .lrc di folder yg sama
  bool hasVideoStream = false;
  DateTime? lastPlayedAt;
  int playCount = 0;
}

@collection
class PlaylistEntity {
  Id id = Isar.autoIncrement;
  late String name;
  DateTime createdAt = DateTime.now();
  final songs = IsarLinks<PlaylistSongEntity>();
}

@collection
class PlaylistSongEntity {
  Id id = Isar.autoIncrement;
  late int orderIndex;
  final song = IsarLink<SongEntity>();
}

@collection
class DeviceProfileEntity {   // ⭐ Per-Gear Auto Preset
  Id id = Isar.autoIncrement;
  @Index() late String deviceKey;      // "BT:Soundcore R50i" / "USB:0x05ac:0x1101"
  late String displayName;
  late String connectionType;          // bluetooth | usb | wired
  String? macHash;                     // identifikasi internal BT
  List<double> eqGains = [];           // 10 band, -12..+12 dB
  int? savedVolume;                    // 0-100
  bool bassBoost = false;
}

@collection
class EQPresetEntity {
  Id id = Isar.autoIncrement;
  late String name;                    // Pop, Rock, Jazz, Flat, Custom...
  List<double> gains = [];             // 10 band
  bool isBuiltIn = false;
}
```

## 2.6 Konfigurasi Penting

**`analysis_options.yaml`** (disiplin sejak awal):

```yaml
include: package:flutter_lints/flutter.yaml
linter:
  rules:
    - prefer_single_quotes
    - always_use_package_imports
    - unawaited_futures
    - avoid_relative_lib_imports
```

**AndroidManifest:** `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`,
`POST_NOTIFICATIONS` (API 33+), `READ_MEDIA_AUDIO/VIDEO` (API 33+) /
`READ_EXTERNAL_STORAGE` maxSdk 32, `BLUETOOTH_CONNECT` (untuk nama perangkat).

**media_kit EQ (FFmpeg filter):**
```dart
// Generate filter 10-band → diteruskan saat init/update player
// contoh 1 band: --af=equalizer=f=100:t=q:w=1.0:g=4.0
// full: gabungkan 10 equalizer filter dengan koma
```

---

# BAGIAN III — DESIGN SYSTEM
## (Menggabungkan bahasa Spotify: gelap, bold, card; & Apple Music: artwork besar, bersih, immersive)

## 3.1 Prinsip Desain

1. **Dark-first** — khas audio player, nyaman dipakai malam hari
2. **Artwork adalah raja** — album art besar & dominan (Apple Music style)
3. **Card-based discovery** — card rounded dengan artwork + judul (Spotify style)
4. **Gerakan halus** — hero animation, bottom sheet, fade; durasi 200–300ms, easing `easeOutCubic`
5. **Jarak sentuh minimum 48dp** — ramah jempol

## 3.2 Warna

| Token | Hex | Pemakaian |
|-------|-----|-----------|
| `background` | `#0E0E10` | Latar utama (Spotify-like) |
| `surface` | `#18181C` | Card, bottom sheet, mini player |
| `surfaceHigh` | `#242429` | Card hover/pressed, chip aktif |
| `onSurface` | `#F5F5F7` | Teks utama |
| `onSurfaceMuted` | `#9C9CA3` | Teks sekunder |
| `divider` | `#2C2C31` | Garis tipis |
| `primary` (Ferro Orange) | `#FF7A1A` | Aksen: tombol utama, progress, indikator |
| `primaryGradient` | `#FF7A1A → #FF3D5A` | Header hero, tombol CTA besar |
| `success` | `#2DD4A7` | Notifikasi sukses |
| `error` | `#FF5252` | Error state |

> Kenapa oranye? Identitas "Ferro" (besi/api metalurgi), beda dari hijau Spotify & merah Apple Music — tetap hangat dan enak dilihat di dark mode.

## 3.3 Tipografi (Google Fonts: **Plus Jakarta Sans** — modern, sangat cocok utk Bahasa Indonesia)

| Style | Ukuran | Weight | Pemakaian |
|-------|--------|--------|-----------|
| Display | 28sp | Bold (700) | Judul layar, judul lagu di Now Playing |
| Headline | 20sp | SemiBold (600) | Section header, judul album |
| Title | 16sp | SemiBold | Judul item list, card |
| Body | 14sp | Regular | Deskripsi, metadata |
| Caption | 12sp | Regular | Timestamp, label kecil |
| Mono/Timer | 13sp | Medium, tabular nums | Seekbar timestamp |

## 3.4 Spacing, Radius, Elevation

- Grid spacing: **4dp base** — jarak umum 8 / 12 / 16 / 24
- Radius: card **12dp**, tombol pill **24dp**, bottom sheet **20dp** (atas saja), artwork **8dp**
- Elevation: dark theme memakai **batas (border 1dp, color `divider`)**, bukan bayangan berat
- Mini player tinggi **64dp**; bottom nav **72dp**; safe-area aware

## 3.5 Komponen Reusable

| Komponen | Spesifikasi |
|----------|-------------|
| `SongTile` | Tinggi 64dp: art 48dp rounded 8, judul (Title), artis (Caption muted), trailing icon more (24dp, hit 48dp) |
| `AlbumCard` | Lebar 160dp: art 1:1 rounded 12, judul 2 baris max, artis 1 baris, overlay play button muncul saat tekan |
| `SectionHeader` | Judul Headline + aksi "Lihat semua" (Caption, warna primary) |
| `FerroButton` | Pill 48dp, gradient primary, label SemiBold; varian: filled/outline/text |
| `MiniPlayer` | Lihat §4.4 |
| `SeekBar` | Track 3dp (muted), buffer 3dp (surfaceHigh), progress 3dp gradient, thumb 12dp muncul saat drag |
| `Chip` | Pill 28dp, surfaceHigh saat aktif + border primary |
| `EmptyState` | Ilustrasi Lottie 160dp + judul + deskripsi + CTA |
| `ArtworkPlaceholder` | Gradient primary lembut + ikon nota (untuk lagu tanpa art) |
| `BottomSheetMenu` | List aksi (Tambah ke playlist, Favorit, Detail file, Hapus) |

---

# BAGIAN IV — SPESIFIKASI SEMUA HALAMAN

## 4.0 Peta Navigasi

```
Splash ─→ Onboarding (1x) ─→ Permission Screen ─→ Home
                                              ├─ Bottom Nav: Beranda | Pustaka | Cari | Pengaturan
                                              ├─ Mini Player (persist di atas bottom nav)
                                              ├─ Now Playing (fullscreen, push)
                                              │     ├─ Queue Sheet
                                              │     ├─ Lyrics View
                                              │     └─ Devices Sheet
                                              ├─ Playlist Detail / Create Sheet
                                              ├─ Album & Artis Detail
                                              ├─ Folder Browser
                                              ├─ Equalizer
                                              ├─ Perangkat Saya (Per-Gear)
                                              └─ Car Mode
```

---

## 4.1 Splash Screen

- **Layout:** Latar `background`, logo FERRO (ikon nota + teks wordmark) di tengah, berdenyut halus (scale 0.96→1.0, 1.2s, loop)
- **Durasi:** maksimal 1.5 detik atau sampai library cache siap
- **Setelah:** onboarding pertama kali → permission screen; selanjutnya langsung Home
- **State loading:** indikator tipis di bawah logo (2dp gradient bar)

## 4.2 Onboarding (hanya tampil sekali, 3 halaman swipeable)

**Gaya:** fullscreen ilustrasi + headline + deskripsi + dot indicator + tombol "Lewati"

| Halaman | Headline | Deskripsi | Ilustrasi |
|---------|----------|-----------|-----------|
| 1 | Semua Format, Satu Player | MP3, FLAC, WAV, bahkan audio dari video MP4/MKV — semua bisa diputar tanpa konversi | Ilustrasi format file menyatu jadi nota |
| 2 | EQ yang Hafal Perangkatmu | Colok IEM, sambung TWS — kurva EQ & volume menyesuaikan otomatis | Ilustrasi headphone & DAC bergantian |
| 3 | 100% Offline & Privat | Musimu tidak pernah meninggalkan perangkat. Tanpa kuota, tanpa server | Ilustrasi HP mode pesawat memutar musik |

CTA akhir: tombol pill gradient **"Mulai Menggunakan Ferro"**

## 4.3 Permission Screen

- **Layout:** tengah layar — ikon folder musik, Headline "Izinkan Ferro mengakses musikmu", Body menjelaskan data tidak pernah diunggah
- **Tombol:** filled "Izinkan Akses" → system permission dialog
- **Ditolak:** tampilkan state elegan + tombol "Buka Pengaturan" (deep link ke app settings). Player tidak bisa berjalan tanpa izin — jujur dan jelas
- **Android 13+:** minta `READ_MEDIA_AUDIO` + `READ_MEDIA_VIDEO`; jangan minta satu paket besar

## 4.4 Shell Utama (Bottom Nav + Mini Player)

Struktur scaffold:

```
┌─────────────────────┐
│                     │
│      Konten         │
│                     │
├─────────────────────┤ ← MiniPlayer (64dp, muncul jika ada queue)
│ 🏠  🎵   🔍   ⚙️    │ ← Bottom Nav (72dp)
└─────────────────────┘
```

- **Bottom Nav:** 4 tab — Beranda, Pustaka, Cari, Pengaturan. Ikon outline → filled + label + indikator pill kecil saat aktif (Spotify style)
- **MiniPlayer:** surface, border atas 1dp. Kiri: art 48dp + judul/artis (marquee jika panjang). Kanan: tombol Play/Pause (28dp, hit 48) + Next. Tap body → buka Now Playing (hero animation art). Geser ke bawah → dismiss queue
- **Offline banner kecil:** jika update tersedia, pill kuning tipis muncul di atas MiniPlayer

## 4.5 Beranda (Home)

**App bar:** salam berdasarkan jam ("Selamat malam") Headline Display + avatar profil setting di kanan

**Section (vertikal scroll, Spotify-style cards):**

1. **"Putar Lagi Cepat"** — horizontal list 6 card album/playlist terakhir diputar (card 160dp: art + label)
2. **"Baru Ditambahkan"** — 10 lagu terbaru masuk library → `SongTile` compact 2 kolom grid
3. **"Paling Sering Diputar"** — horizontal card artis/album
4. **"Rekomendasi dari Koleksimu"** — shuffle mix berdasarkan genre dominan (semua lokal, dipilih dari play count — *bukan* rekomendasi online)
5. **"Lanjutkan Playlist"** — 3 playlist terakhir dibuka, progress chip "12/40 lagu"

**Empty state (library kosong):** ilustrasi + "Belum ada musik" + CTA "Pindai Sekarang" + tip cara memindahkan file ke HP

**Pull-to-refresh:** re-scan library dengan indikator shimmer

## 4.6 Pustaka (Library)

**Header:** judul "Pustaka" + ikon sort & more (Sortir: Judul/Artis/Terakhir ditambah; Tata letak: Grid/List)

**Tab bar (scrollable, pill chips):** Lagu | Album | Artis | Genre | Folder | Playlist

- **Lagu:** list `SongTile`, sticky header alfabetis (A-Z), fast-scroll scrollbar di kanan (Apple Music style)
- **Album:** grid 2 kolom (portrait) card artwork + judul album + artis
- **Artis:** grid lingkaran avatar (art dari album pertama) + nama
- **Genre:** grid card gradient + nama genre + jumlah lagu
- **Folder:** list folder (ikon folder + nama + jumlah item) → tap masuk hierarki folder (breadcrumb di atas)
- **Playlist:** card horizontal "Playlist Baru" (dashed border, ikon +) + list playlist dengan 4 grid art mini sebagai cover

**Multi-select mode:** long-press → checkbox di kiri, app bar berubah jadi aksi (Tambah ke playlist, Favorit, Hapus)

## 4.7 Cari (Search)

- **Header:** search bar pill (ikon 🔍, hint "Cari lagu, artis, album...") — auto-focus opsional
- **Sedang mengetik:** hasil real-time terfilter (grup: Lagu / Album / Artis), debounce 200ms, shimmer saat memuat
- **Kosong:** "Pencarian terakhir" chip + "Telusuri menurut genre" grid (sama dgn genre di library)
- **Tidak ditemukan:** empty state "Tidak ada hasil untuk '...'" + tips cek ejaan

## 4.8 Now Playing (Fullscreen) ⭐ Layar Terpenting

**Layout (Apple Music immersive + kontrol Spotify):**

```
┌──────────────────────────┐
│  chevron-down   •••  BT🔊│ ← top bar
│                          │
│      [ ALBUM ART ]       │ ← 72% lebar, rounded 16, shadow lembut,
│                          │   hero animation dari mini player
│   Judul Lagu (Display)   │
│   Artis — Album (Body)   │
│                          │
│  ──────seekbar──────     │
│  1:24              3:56  │
│                          │
│  ♡   ⏮   ▶/⏸   ⏭   🔀   │ ← kontrol utama 64dp
│                          │
│  🔈─────volume─────🔊    │ ← volume slider tipis
│                          │
│  🎵 lirik   📋 antrian   │ ← bottom action row
│  🎚️ EQ      🎧 perangkat │
└──────────────────────────┘
```

- **Background:** album art di-blur penuh (backdrop filter, scale 1.4, opacity gelap 60%) — warna layar mengikuti art (dynamic theme sederhana: sample 3 warna dominan)
- **Swipe gestures:** geser art ke kiri/kanan = prev/next lagu; swipe down = tutup ke mini player
- **Seekbar:** drag untuk scrub, tampilkan preview waktu di atas thumb; buffering indicator
- **Tombol ♡:** toggle favorit, animasi pop + haptic
- **🔀:** cycle repeat (off → all → one) dengan badge kecil
- **Tombol BT/🎧:** membuka **Devices Sheet** — menampilkan perangkat aktif + profil yang dipakai + shortcut ke Perangkat Saya
- **Tombol lirik 🎵:** expand ke Lyrics View (slide up)
- **Tombol •••:** menu (Detail file, Tambah ke playlist, Bagikan info lagu, Hapus)

## 4.9 Queue Sheet (bottom sheet, tinggi 70%)

- Header: "Antrian" + count + tombol "Simpan jadi playlist"
- List: lagu sedang diputar (highlight border primary + animasi equalizer bar mini) → "Berikutnya" (urutan shuffle tampil nyata) → "Berikutnya dari: [Album/Playlist sumber]"
- Long-press drag untuk reorder; swipe item → remove
- Tab kecil: Antrian | Riwayat (lagu yang sudah diputar)

## 4.10 Lyrics View (Lirik Sinkron)

- **Mode default:** lirik penuh di tengah, baris aktif = Display bold putih; baris lain muted 40%; auto-scroll halus; geser manual → auto-resume setelah 5 dtk idle
- **Mode karaoke:** baris aktif di-highlight dengan gradient primary per kata (sinkron via timestamp LRC per kata bila tersedia)
- **Tanpa lirik:** cek file .lrc dengan nama sama di folder lagu → jika ada tombol "Muat file .lrc"; jika tidak, empty state "Lirik tidak tersedia"
- **Background:** art blur + overlay gelap 80% (fokus ke teks)

## 4.11 Equalizer

**Struktur:**
- Header: "Equalizer" + toggle master (switch besar)
- **Preset chips:** Flat, Pop, Rock, Jazz, Klasik, Bass Boost, Vokal, + "Simpan sebagai preset..." dan "Preset Saya"
- **Slider 10-band** (vertikal, 60dp tinggi range): 31Hz, 62Hz, 125Hz, 250Hz, 500Hz, 1kHz, 2kHz, 4kHz, 8kHz, 16kHz; rentang -12..+12dB; haptic di 0dB
- **Panel bawah (accordion):** Bass Boost (slider 0–100), Virtualizer (0–100), Loudness Normalization (switch + info)
- **Live:** perubahan terdengar real-time saat lagu memutar (hot-swap `--af`)
- **Tombol "Simpan ke profil perangkat"** ⭐ → simpan kurva ke DeviceProfile perangkat aktif (integrasi fitur andalan)

## 4.12 Perangkat Saya (Per-Gear Profiles) ⭐ FITUR ANDALAN

**Header:** judul "Perangkat Saya" + switch global "Auto-switch profil"

**List perangkat pernah tersambung:**
```
┌────────────────────────────────┐
│ 🎧  TWS-Soundcore R50i         │
│     Bluetooth • Profil: V-shape│ ← badge hijau jika ini perangkat AKTIF
│     EQ 10-band • Vol 70%       │
├────────────────────────────────┤
│ 🔌  Apple USB-C DAC            │
│     USB DAC • Profil: IEM-flat │
│     EQ 10-band • Vol 45%       │
└────────────────────────────────┘
```
- Perangkat yang sedang aktif: border primary + badge "AKTIF" + equalizer bar animasi mini
- Tap item → **Detail Profil**: edit nama, edit EQ (buka Equalizer prefilled), slider volume, hapus profil
- Tombol FAB "+": tambah profil manual (pilih dari daftar perangkat terdeteksi historis atau input nama)
- **Banner edukasi di atas (first-run):** "Colok headphone atau sambung Bluetooth — Ferro otomatis mengingat pengaturanmu."
- **Event log kecil:** "Terakhir switch: 2 menit lalu ke TWS-Soundcore"

## 4.13 Playlist Detail

- Header: cover playlist (grid 2x2 art lagu pertama / atau placeholder gradient + ikon) + nama + jumlah lagu + total durasi + tombol Shuffle besar (gradient pill) & Play
- List `SongTile` dengan drag-handle reorder (owner mode), swipe hapus
- More: Rename, Ubah cover, Hapus playlist, Bagikan (file .m3u? dievaluasi)
- **Create Sheet:** bottom sheet input nama + opsi "Dari antrian sekarang" + "Kosong"

## 4.14 Album & Artis Detail

- **Album:** hero art besar (portrait) + judul + artis + tahun/jumlah lagu + total durasi + tombol Play/Shuffle; list lagu dengan nomor
- **Artis:** hero foto/art bulat besar + jumlah album/lagu; section Album (horizontal card) + Semua Lagu

## 4.15 Folder Browser

- Breadcrumb bar (ikon 📁 root / SD card / USB-OTG) + nama folder
- List: folder dulu (ikon folder + count), lalu file musik `SongTile`
- More di folder: "Sembunyikan dari Pustaka" (masuk daftar exclude)
- FAB kecil: "Muat lirik .lrc" (jika folder punya lrc tanpa pasangan — dievaluasi)

## 4.16 Car Mode

**Di-trigger:** otomatis (toggle di Settings: "Auto car mode saat BT tersambung") atau shortcut manual

**Layout (safety-first):**
```
┌──────────────────────────┐
│  🚗  CAR MODE   [Keluar] │
│                          │
│    [ ALBUM ART 200dp ]   │
│   Judul (Title besar)    │
│   Artis (Body)           │
│                          │
│   ⏮        ⏸        ⏭    │ ← tombol raksasa 96dp, high contrast
│                          │
│  ❤️ Favorit   🔀 Acak    │ ← 2 tombol besar bawah
└──────────────────────────┘
```
- Semua elemen ≥ 64dp touch target, kontras maksimal, gesture: tap kanan art = next, kiri = prev
- Nonaktifkan animasi kompleks; keep screen-on toggle opsional

## 4.17 Settings (Pengaturan)

Grup section (list tile dengan ikon, grouped inset style — Apple-like):

1. **Audio:** Equalizer • Perangkat Saya • Crossfade (slider 0–12 dtk + toggle) • Gapless (toggle) • Normalisasi volume (toggle) • Kecepatan default
2. **Pustaka:** Folder tersembunyi • Scan otomatis saat charger (toggle) • Termasuk audio dari video (toggle)
3. **Tampilan:** Tema (Gelap/Sistem — terang opsional evaluasi) • Bahasa (ID/EN) • Ukuran teks
4. **Metadata online:** Auto-fetch metadata (toggle) • Hanya via Wi-Fi (toggle)
5. **Car Mode:** Auto aktif saat BT (toggle)
6. **Aplikasi:** Cek pembaruan • Donasi • Beri feedback (buka GitHub Issues) • Bagikan aplikasi (link GitHub) • Tentang Ferro (versi, lisensi open source, changelog)
7. **Privasi:** "Ferro tidak mengumpulkan data apa pun. Semua tersimpan di perangkatmu." (read-only statement)

## 4.18 Update Dialog

- Trigger: saat app dibuka + cek GitHub Releases (maks 1x/hari, cache di SharedPreferences)
- Dialog: "Versi baru tersedia: v1.1.0" + changelog bullet 3 item + tombol "Unduh" (buka browser ke halaman release) / "Nanti"
- **Tidak pernah memaksa** — aplikasi tetap jalan offline penuh tanpa update

## 4.19 Widget Homescreen (Android)

- Ukuran 4x1: art kecil + judul/artis + 3 tombol (prev/play/next)
- Background: surface gelap blur; warna aksen mengikuti art
- Tap body → buka Now Playing

## 4.20 Notifikasi Media & Lockscreen

- Standard Android media notification: art, judul, artis, kontrol (prev/play/next), seekbar (Android 13+)
- Style sesuai Material 3; warna aksen notification mengikuti art

---

# BAGIAN V — PER-GEAR AUTO PRESET: FLOW TEKNIS LENGKAP

```
[BT connect / USB attach]
        │
        ▼
BroadcastReceiver (native, Android)
  • BT: AudioManager.getDevices() → nama device + address
  • USB: UsbManager.getDeviceList() → vendorId:productId + productName
        │
        ▼
Method Channel "ferro/audio_devices" → Flutter
        │
        ▼
DeviceMonitorProvider (Riverpod StreamProvider<DeviceInfo?>)
        │
        ▼
Cari DeviceProfileEntity by deviceKey
  ├─ ADA → terapkan: build EQ filter → player.setAudioFilter()
  │         set volume via channel → AudioManager.setStreamVolume()
  │         tampilkan SnackBar ringan: "Profil 'IEM-KZ' diterapkan 🎧"
  └─ TIDAK ADA → pakai EQ global/default
               → setelah user ubah EQ/volume, offer snackbar:
                 "Simpan profil untuk 'TWS-Soundcore R50i'?" [Simpan] [Nanti]
        │
[Perangkat lepas] → kembalikan EQ global + volume default
```

**Detail penting:**
- `deviceKey` BT: `"BT:{nama}"` + hash MAC untuk membedakan 2 unit nama sama
- `deviceKey` USB: `"USB:{vendorId}:{productId}"`
- Switch EQ harus seamless (tanpa pause) — libmpv menerima perubahan `--af` runtime
- Semua logika di `domain/usecases/apply_device_profile.dart` — testable tanpa UI

---

# BAGIAN VI — WORKFLOW PENGEMBANGAN & RILIS

## 6.1 Git Branching

```
main          → rilis stabil, protected
develop       → integrasi harian
feature/xxx   → 1 fitur 1 branch → PR ke develop
fix/xxx       → hotfix
Tag: v1.0.0, v1.0.1, ... (semantic versioning)
```

## 6.2 GitHub Actions: Build & Release APK

```yaml
# .github/workflows/release.yml (ringkas)
on:
  push:
    tags: ['v*']
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix: { abi: [armeabi-v7a, arm64-v8a, x86_64] }
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release --split-per-abi --build-name=${GITHUB_REF#refs/tags/v}
      - uses: actions/upload-artifact@v4
  release:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: softprops/action-gh-release@v2
        with:
          files: build/app/outputs/flutter-apk/*.apk
          generate_release_notes: true
```

> ⚠️ Signing: untuk rilis publik, sign dengan keystore **yang disimpan sebagai GitHub Secret** (base64), BUKAN commit ke repo. Backup keystore juga di luar GitHub.

## 6.3 Template GitHub

- **Issue templates:** Bug Report (versi app, Android version, langkah repro, expected/actual) & Feature Request
- **Labels:** `bug`, `enhancement`, `per-gear`, `ui`, `audio-engine`, `good first issue`
- **Milestone per versi:** v1.0, v1.1, ...
- **README:** badge download, screenshot, panduan install APK (aktifkan "unknown sources"), fitur, roadmap, lisensi (MIT), cara kontribusi, disclaimer musik milik pengguna

---

# BAGIAN VII — CHECKLIST MULAI NGODING (Langkah Aman)

1. ✅ `flutter doctor` — semua hijau
2. ✅ Buat project: `flutter create ferro` — package name unik, misal `id.ferro.player`
3. ✅ Init git + push repo GitHub (publik)
4. ✅ Setup `analysis_options.yaml` + pre-commit (optional: lefthook/melos — skip utk solo)
5. ✅ Tambahkan packages (Bagian II) — **pin versi** di pubspec
6. ✅ Setup theme (Bagian III) + routing shell + bottom nav
7. ✅ Isar schema (Bagian 2.5) + generate
8. ✅ Media scanner + permission → Library
9. ✅ audio_service + media_kit → Player core (play/pause/seek/next)
10. ✅ Now Playing screen
11. ✅ Playlist, favorit, riwayat
12. ✅ EQ via FFmpeg filter
13. ✅ Per-Gear: Method Channel native → monitor → auto-switch
14. ✅ Lyrics, queue, folder browser
15. ✅ Car mode, widget, settings, updater
16. ✅ Polish animasi + empty/error states
17. ✅ Beta ke circle kecil (1–2 minggu) → perbaikan → **TAG v1.0.0 → rilis GitHub** 🚀

---

*Dokumen ini adalah sumber kebenaran tunggal (single source of truth) untuk pengembangan FERRO.
Perubahan scope wajib melalui revisi dokumen ini.*
