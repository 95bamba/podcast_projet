# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Galsen Podcast is a Flutter mobile application for browsing, streaming, and managing podcast content. The app features audio playback, playlist management, favorites, and offline download capabilities.

## Development Commands

### Setup & Dependencies
```bash
# Install Flutter dependencies
flutter pub get

# Install iOS CocoaPods (requires UTF-8 encoding)
export LANG=en_US.UTF-8 && cd ios && pod install

# Install macOS CocoaPods
export LANG=en_US.UTF-8 && cd macos && pod install
```

### Running the App
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices

# Run in release mode
flutter run --release
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format all Dart files
flutter format lib/

# Check for outdated dependencies
flutter pub outdated
```

### Building
```bash
# Build APK (Android)
flutter build apk

# Build iOS app
flutter build ios

# Build macOS app
flutter build macos

# Clean build artifacts
flutter clean
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Architecture Overview

### Navigation Structure

The app uses a **dual navigation system**:

1. **Bottom Navigation Bar** (Primary) - 4 main tabs:
   - Home (Accueil) - Browse categories and featured podcast
   - Playlist - View curated playlists
   - Favorites (Favoris) - Access saved episodes
   - Profile (Profil) - User info and statistics

2. **Hamburger Menu** (Secondary) - Slide-in menu with:
   - All primary pages plus Settings and About
   - Animated 300px wide overlay
   - Located in `lib/widgets/hamburger_menu.dart`

**Navigation Flow**:
- All page transitions use `PageRouteBuilder` with `SlideTransition` (300ms, `Curves.easeInOut`)
- Deep navigation: Home → Categories → Podcasts → Episodes
- Each navigation creates a new route on the stack

### Audio Playback Architecture

**Core Library**: `just_audio ^0.9.36`

**Audio Session Setup** (in `main.dart`):
```dart
final session = await AudioSession.instance;
await session.configure(const AudioSessionConfiguration.music());
```

**Implementation Pattern** (repeated across pages):
- Each page maintains its own `AudioPlayer` instance
- Three stream subscriptions:
  - `playerStateStream` - Play/pause state and completion
  - `durationStream` - Total audio duration
  - `positionStream` - Current playback position
- Proper disposal in `dispose()` method

**Key Audio Methods**:
- `_audioPlayer.setUrl(audioUrl)` - Load audio from URL
- `_audioPlayer.play()` / `_audioPlayer.pause()` - Playback control
- `_audioPlayer.seek(Duration)` - Jump to position

### State Management

**Pattern**: Local state with `setState()` - No global state manager

- Each page is a `StatefulWidget` managing its own state
- Common state variables:
  - Audio: `AudioPlayer`, `isPlaying`, `duration`, `position`
  - UI: `_selectedIndex`, `_isMenuOpen`, filter/search results
- State updates trigger UI rebuilds via `setState()`
- **Limitation**: No state persistence across app restarts

### Service Layer

**AudioDownloadService** (`lib/services/audio_download_service.dart`):
- Downloads audio files to app documents directory (`downloads/` subfolder)
- Methods:
  - `downloadAudio(url, fileName, {onProgress})` - Download with progress callback
  - `deleteAudio(fileName)` - Remove downloaded file
  - `isAudioDownloaded(fileName)` - Check if file exists
- Uses `path_provider` for directory access and `http` for downloads
- 5-minute timeout on download requests

### Data Models

**Data Structure**:
```
PodcastCategory
├── name: String
├── image: String (asset path)
├── color: Color
└── podcasts: List<Podcast>
    ├── title: String
    ├── image: String
    ├── description: String
    ├── author: String
    └── episodes: List<Episode>
        ├── title: String
        ├── duration: String
        └── audioUrl: String
```

**Data Storage**: All data is in-memory (hardcoded in pages). No database persistence.

### Key Widgets

**AudioControls** (`lib/widgets/audio_controls.dart`):
- Reusable download/play controls component
- States: Not Downloaded → Downloading → Downloaded (with play/delete)
- Integrates with `AudioDownloadService`

**DownloadProgress** (`lib/widgets/download_progress.dart`):
- Shows download progress with percentage
- Displays during file download operations

**HamburgerMenu** (`lib/widgets/hamburger_menu.dart`):
- Side navigation overlay
- Tracks current page and highlights active menu item
- Animated slide-in/out (300ms)

## Important Development Notes

### Audio Player Management
- **Multiple Instances**: Each page creates its own `AudioPlayer`
- When adding audio features to new pages, follow the pattern in `home_page.dart`:
  1. Create `AudioPlayer` instance
  2. Set up three stream listeners (player state, duration, position)
  3. Dispose player in `dispose()` method
  4. Handle `ProcessingState.completed` for auto-replay or next episode

### Download System
- Downloads stored in: `{ApplicationDocumentsDirectory}/downloads/`
- Downloaded files are NOT automatically used for playback (still streams from URL)
- Download state is session-only (not persisted)
- File names should be sanitized (no special characters, spaces)

### Asset Management
```yaml
assets:
  - assets/          # General assets
  - assets/audio/    # Local audio files (e.g., sons1.m4a)
  - assets/fa.jpg    # Religion category image
  - assets/bve.jpg   # Education category image
  - assets/mame.jpg  # Motivation category image
```

### Code Organization Pattern
```
lib/
├── *_page.dart              # Full-screen pages (12 files)
├── widgets/                 # Reusable UI components
│   ├── hamburger_menu.dart
│   ├── audio_controls.dart
│   └── download_progress.dart
└── services/                # Business logic
    └── audio_download_service.dart
```

### Current Limitations
1. **No Persistence**: Favorites and downloads reset on app restart
2. **Code Duplication**: Audio player setup repeated in 6 pages
3. **Unused Dependencies**: `dio` and `fl_chart` are imported but not used
4. **Hardcoded Data**: All podcast/episode data is in-memory
5. **Test Credentials**: Admin login in `login_page.dart` has hardcoded passwords

## Testing the App

### Test Data
- **Local Audio**: `assets/audio/sons1.m4a` (6MB M4A file)
- **Remote URLs**: Mix of uic.edu and soundhelix.com test files
- **Test Categories**: Religion, Education, Motivation
- **Admin Login**: Available from Profile page (credentials in `login_page.dart`)

### Common Issues
1. **CocoaPods Encoding Error**: Run with `export LANG=en_US.UTF-8` before `pod install`
2. **Download Timeout**: Default 5-minute timeout may need adjustment for large files
3. **Audio Not Playing**: Check that URL is absolute and accessible
4. **iOS/macOS Build Issues**: Ensure CocoaPods are installed (`pod install` in ios/ and macos/)

## Adding New Features

### Adding a New Page
1. Create `new_page.dart` in `lib/`
2. Add route in `hamburger_menu.dart` if needed
3. Add to bottom nav in `main.dart` if it's a primary page
4. Follow navigation pattern: `Navigator.push()` with `PageRouteBuilder`

### Adding Audio to a Page
1. Import: `import 'package:just_audio/just_audio.dart';`
2. Create player: `final AudioPlayer _audioPlayer = AudioPlayer();`
3. Set up streams in `initState()`:
   - `_audioPlayer.playerStateStream.listen(...)`
   - `_audioPlayer.durationStream.listen(...)`
   - `_audioPlayer.positionStream.listen(...)`
4. Dispose in `dispose()`: `_audioPlayer.dispose();`
5. Load audio: `await _audioPlayer.setUrl(url);`

### Adding a New Podcast Category
Categories are defined in `home_page.dart`:
1. Add to `_categories` list in `_HomePageState`
2. Provide: name, image path (asset), color, list of podcasts
3. Add new asset to `pubspec.yaml` if using new image

### Adding Download Capability
Use the `AudioControls` widget:
```dart
AudioControls(
  audioUrl: episode.audioUrl,
  fileName: 'unique_filename.m4a',
  onPlay: () => _playAudio(episode.audioUrl),
)
```

## Dependencies

### Core Dependencies
- `just_audio: ^0.9.36` - Audio streaming and playback
- `audio_session: ^0.1.18` - Audio session management
- `path_provider: ^2.1.2` - File system access
- `http: ^1.2.0` - HTTP requests for downloads

### Unused Dependencies
- `dio: ^5.4.0` - HTTP client (imported but not used)
- `fl_chart: ^0.65.0` - Charting library (imported but not used)

Consider removing unused dependencies or integrating them:
- Use `dio` for more robust HTTP requests with interceptors
- Use `fl_chart` in Profile/Statistics pages for visual data

## Platform-Specific Notes

### iOS
- Minimum deployment target: iOS 12.0 (auto-assigned by CocoaPods)
- Audio session configured for music playback
- Background audio capabilities may need entitlements

### macOS
- CocoaPods integration with custom config warnings (expected)
- Audio works in foreground only by default

### Android
- Android licenses may need acceptance: `flutter doctor --android-licenses`
- Minimum SDK version defined in `android/app/build.gradle`

### Web
- Audio playback supported via `just_audio_web`
- Downloads may behave differently (browser download prompt)
