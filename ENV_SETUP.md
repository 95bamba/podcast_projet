# Environment Variables Setup Guide

This project uses environment variables to manage API configurations. This approach allows you to easily change the API endpoint without modifying the source code.

## Quick Start

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Update the `.env` file with your API configuration:**
   ```env
   API_BASE_URL=http://your-api-url:port
   API_CONNECT_TIMEOUT=30
   API_RECEIVE_TIMEOUT=30
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Environment Variables

### `API_BASE_URL`
- **Description:** The base URL for your API server
- **Default:** `http://51.254.204.25:2000`
- **Example:** `http://localhost:3000` or `https://api.yourdomain.com`

### `API_CONNECT_TIMEOUT`
- **Description:** Connection timeout in seconds
- **Default:** `30`
- **Example:** `60` for slower connections

### `API_RECEIVE_TIMEOUT`
- **Description:** Response receive timeout in seconds
- **Default:** `30`
- **Example:** `60` for slower responses

## File Structure

```
.
├── .env                  # Your local environment variables (NOT committed to git)
├── .env.example          # Template file (committed to git)
└── ENV_SETUP.md          # This file
```

## Important Notes

- **DO NOT commit `.env` to version control** - It's already added to `.gitignore`
- **Always commit `.env.example`** - It serves as a template for other developers
- The app will use default values if environment variables are not found
- Changes to `.env` require restarting the app

## How It Works

The environment variables are loaded in `lib/main.dart` at app startup:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // ... rest of the app initialization
}
```

The API services (`lib/services/api_service.dart` and `lib/services/media_service.dart`) then access these variables:

```dart
static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://51.254.204.25:2000';
```

## Troubleshooting

### Error: "Unable to load asset: .env"
**Solution:** Make sure you've created the `.env` file by copying `.env.example`:
```bash
cp .env.example .env
```

### API calls failing
**Solution:**
1. Check that `API_BASE_URL` in `.env` is correct
2. Ensure the API server is running
3. Verify network connectivity
4. Check timeout values if the API is slow

### Changes not taking effect
**Solution:**
1. Stop the app completely
2. Run `flutter clean`
3. Run `flutter pub get`
4. Restart the app with `flutter run`

## Different Environments

You can create multiple environment files for different setups:

```bash
.env.development    # Local development
.env.staging        # Staging server
.env.production     # Production server
```

To use a specific environment file, modify the `main.dart`:

```dart
await dotenv.load(fileName: ".env.development");
```

## Security Best Practices

1. Never commit sensitive credentials to `.env`
2. Use different API URLs for development, staging, and production
3. Rotate API keys regularly
4. Use HTTPS in production
5. Keep `.env` file permissions restrictive on your machine
