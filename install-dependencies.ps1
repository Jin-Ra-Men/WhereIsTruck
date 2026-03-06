# WhereIsTruck - 필수 기술 스택 의존성 설치 스크립트
# README.md 기술 스택 기준 (Node.js/NestJS, Python/FastAPI, Socket.io 등)

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

# 2. Python (FastAPI) — backend/fastapi
$FastApiPath = Join-Path $ProjectRoot "backend\fastapi"
if (Test-Path $FastApiPath) {
    $ReqFile = Join-Path $FastApiPath "requirements.txt"
    if (Test-Path $ReqFile) {
        if (Get-Command pip -ErrorAction SilentlyContinue) {
            Write-Host "`n[2/2] backend/fastapi — pip install -r requirements.txt 실행 중..." -ForegroundColor Yellow
            Set-Location $FastApiPath; pip install -r requirements.txt; Set-Location $ProjectRoot
            if ($LASTEXITCODE -eq 0) { Write-Host "  FastAPI 패키지 설치 완료." -ForegroundColor Green }
        } elseif (Get-Command pip3 -ErrorAction SilentlyContinue) {
            Write-Host "`n[2/2] backend/fastapi — pip3 install -r requirements.txt 실행 중..." -ForegroundColor Yellow
            Set-Location $FastApiPath; pip3 install -r requirements.txt; Set-Location $ProjectRoot
            if ($LASTEXITCODE -eq 0) { Write-Host "  FastAPI 패키지 설치 완료." -ForegroundColor Green }
        } else {
            Write-Host "`n[2/2] pip을 찾을 수 없습니다. Python을 먼저 설치해 주세요: https://www.python.org/downloads/" -ForegroundColor Red
        }
    }
} else {
    Write-Host "`n[2/2] backend/fastapi 폴더가 없습니다. 건너뜁니다." -ForegroundColor Gray
}

Write-Host "`n=== 설치 스크립트 종료 ===" -ForegroundColor Cyan
Write-Host "PostgreSQL(PostGIS), Map API Key, Firebase 설정은 SETUP.md를 참고하세요." -ForegroundColor Gray
