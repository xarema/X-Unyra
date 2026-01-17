# Frontend (Flutter) — Android + Web

## Bootstrap (recommended)

1) Make sure Flutter SDK is installed.
2) Create a Flutter project (Android + Web):

```bash
cd frontend
flutter create . --platforms=android,web
```

If Flutter complains the folder isn’t empty, do this instead:

```bash
flutter create couple_frontend --platforms=android,web
# then copy this repo's `frontend/lib/` and `frontend/pubspec.yaml` into that generated folder
```

3) Install dependencies:

```bash
flutter pub get
```

4) Run:

```bash
flutter run -d chrome
flutter run -d android
```

## Configure API base URL
Edit `lib/core/config.dart`:
- `apiBaseUrl` should point to your cPanel domain, e.g. `https://example.com/api/`

## How "live" works (Option A)
The app polls `GET /api/sync/changes?since=...` while a tab is open.
When something changed, it refreshes that tab’s data.
