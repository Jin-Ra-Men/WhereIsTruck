# WhereIsTruck - 필수 기술 스택 의존성 설치 스크립트
# README.md 기술 스택 기준 (Node.js/NestJS, Socket.io, Flutter 등)

$ErrorActionPreference = "Stop"
$ProjectRoot = $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "=== WhereIsTruck 의존성 설치 ===" -ForegroundColor Cyan

# 1. Node.js (NestJS) — backend/nest
$NestPath = Join-Path $ProjectRoot "backend\nest"
if (Test-Path $NestPath) {
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Host "`n[1/2] backend/nest — npm install 실행 중..." -ForegroundColor Yellow
        Set-Location $NestPath; npm install; Set-Location $ProjectRoot
        if ($LASTEXITCODE -eq 0) { Write-Host "  Nest 패키지 설치 완료." -ForegroundColor Green }
    } else {
        Write-Host "`n[1/2] npm을 찾을 수 없습니다. Node.js를 먼저 설치해 주세요: https://nodejs.org/" -ForegroundColor Red
    }
} else {
    Write-Host "`n[1/2] backend/nest 폴더가 없습니다. 건너뜁니다." -ForegroundColor Gray
}

# 2. Flutter (선택) — frontend/mobile-flutter
$FlutterPath = Join-Path $ProjectRoot "frontend\mobile-flutter"
if (Test-Path $FlutterPath) {
    if (Get-Command flutter -ErrorAction SilentlyContinue) {
        $Pubspec = Join-Path $FlutterPath "pubspec.yaml"
        if (Test-Path $Pubspec) {
            Write-Host "`n[2/2] frontend/mobile-flutter — flutter pub get 실행 중..." -ForegroundColor Yellow
            Set-Location $FlutterPath; flutter pub get; Set-Location $ProjectRoot
            if ($LASTEXITCODE -eq 0) { Write-Host "  Flutter 의존성 설치 완료." -ForegroundColor Green }
        }
    } else {
        Write-Host "`n[2/2] flutter를 찾을 수 없습니다. Flutter SDK를 설치해 주세요: https://docs.flutter.dev/get-started/install" -ForegroundColor Red
    }
} else {
    Write-Host "`n[2/2] frontend/mobile-flutter 폴더가 없습니다. 건너뜁니다." -ForegroundColor Gray
}

Write-Host "`n=== 설치 스크립트 종료 ===" -ForegroundColor Cyan
Write-Host "PostgreSQL(PostGIS), Map API Key, Firebase 설정은 SETUP.md를 참고하세요." -ForegroundColor Gray
