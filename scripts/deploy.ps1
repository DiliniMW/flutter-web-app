param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Message
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

function Resolve-FlutterCommand {
    $knownFlutter = 'C:\dev\flutter\bin\flutter.bat'
    if (Test-Path -LiteralPath $knownFlutter) {
        return $knownFlutter
    }

    return (Get-Command flutter -ErrorAction Stop).Source
}

Push-Location $projectRoot
try {
    $flutter = Resolve-FlutterCommand
    $dart = Join-Path (Split-Path $flutter) 'dart.bat'

    if (-not (Test-Path -LiteralPath $dart)) {
        $dart = (Get-Command dart -ErrorAction Stop).Source
    }

    Write-Host 'Formatting Dart files...'
    & $dart format lib test
    if ($LASTEXITCODE -ne 0) { throw 'Formatting failed.' }

    Write-Host 'Installing dependencies...'
    & $flutter pub get
    if ($LASTEXITCODE -ne 0) { throw 'Dependency installation failed.' }

    Write-Host 'Running static analysis...'
    & $flutter analyze
    if ($LASTEXITCODE -ne 0) { throw 'Static analysis failed.' }

    Write-Host 'Running tests...'
    & $flutter test
    if ($LASTEXITCODE -ne 0) { throw 'Tests failed.' }

    git diff --check
    if ($LASTEXITCODE -ne 0) { throw 'Git found whitespace errors.' }

    $changes = git status --porcelain
    if (-not $changes) {
        Write-Host 'Nothing to deploy.'
        exit 0
    }

    Write-Host 'Committing source changes...'
    git add --all
    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { throw 'Commit failed.' }

    Write-Host 'Pushing to GitHub...'
    git push origin main
    if ($LASTEXITCODE -ne 0) { throw 'Push failed.' }

    Write-Host ''
    Write-Host 'Deployment started: https://github.com/DiliniMW/flutter-web-app/actions'
    Write-Host 'Live site: https://dilinimw.github.io/flutter-web-app/'
}
finally {
    Pop-Location
}
