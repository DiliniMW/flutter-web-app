# Dilini's Portfolio

A responsive, terminal-inspired Flutter web portfolio.

## Development

```powershell
flutter pub get
flutter run -d chrome
```

## Deploy

Run the release helper from the project root with a short description:

```powershell
.\scripts\deploy.ps1 -Message "Update project descriptions"
```

The script formats the Dart source, installs dependencies, runs analysis and
tests, commits the changes, and pushes `main`. GitHub Actions then builds and
publishes the site automatically.

- Live site: <https://dilinimw.github.io/flutter-web-app/>
- Deployment status: <https://github.com/DiliniMW/flutter-web-app/actions>

### Manual equivalent

```powershell
C:\dev\flutter\bin\dart.bat format lib test
flutter pub get
flutter analyze
flutter test
git add --all
git commit -m "Describe the change"
git push origin main
```
