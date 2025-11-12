# Script de Verificación del Pipeline
# Este script verifica que todas las correcciones estén aplicadas

Write-Host "🔍 Verificando correcciones del pipeline..." -ForegroundColor Cyan
Write-Host ""

$errores = 0

# 1. Verificar .dockerignore
Write-Host "1️⃣  Verificando .dockerignore..." -ForegroundColor Yellow
if (Test-Path ".dockerignore") {
    Write-Host "   ✅ .dockerignore existe" -ForegroundColor Green
    $content = Get-Content ".dockerignore" -Raw
    if ($content -match "target/" -and $content -match ".mvn/" -and $content -match "Wallet_") {
        Write-Host "   ✅ Contenido correcto" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Contenido incompleto" -ForegroundColor Red
        $errores++
    }
} else {
    Write-Host "   ❌ .dockerignore NO existe" -ForegroundColor Red
    $errores++
}
Write-Host ""

# 2. Verificar application.properties
Write-Host "2️⃣  Verificando application.properties..." -ForegroundColor Yellow
if (Test-Path "src\main\resources\application.properties") {
    $appProps = Get-Content "src\main\resources\application.properties" -Raw
    
    if ($appProps -match "spring.cloud.config.enabled=false") {
        Write-Host "   ✅ Spring Cloud Config desactivado" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Spring Cloud Config podría causar problemas" -ForegroundColor Yellow
    }
    
    if ($appProps -match "jdbc:h2:mem:testdb" -and $appProps -notmatch "oracle.jdbc") {
        Write-Host "   ✅ Solo configuración H2 (sin Oracle)" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Configuración de base de datos podría tener conflictos" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ❌ application.properties NO existe" -ForegroundColor Red
    $errores++
}
Write-Host ""

# 3. Verificar Dockerfile
Write-Host "3️⃣  Verificando Dockerfile..." -ForegroundColor Yellow
if (Test-Path "Dockerfile") {
    $dockerfile = Get-Content "Dockerfile" -Raw
    
    if ($dockerfile -match "AS builder" -or $dockerfile -match "AS buildstage") {
        Write-Host "   ✅ Multi-stage build configurado" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  No usa multi-stage build" -ForegroundColor Yellow
    }
    
    if ($dockerfile -match "adduser.*spring" -or $dockerfile -match "USER spring") {
        Write-Host "   ✅ Usuario no-root configurado" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Corre como root (problema de seguridad)" -ForegroundColor Yellow
    }
    
    if ($dockerfile -match "HEALTHCHECK") {
        Write-Host "   ✅ Health check configurado" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  Sin health check (opcional)" -ForegroundColor Cyan
    }
} else {
    Write-Host "   ❌ Dockerfile NO existe" -ForegroundColor Red
    $errores++
}
Write-Host ""

# 4. Verificar estructura Maven
Write-Host "4️⃣  Verificando estructura Maven..." -ForegroundColor Yellow
if (Test-Path ".mvn\wrapper\maven-wrapper.jar") {
    Write-Host "   ✅ Maven wrapper completo" -ForegroundColor Green
} else {
    Write-Host "   ❌ Maven wrapper incompleto" -ForegroundColor Red
    $errores++
}
Write-Host ""

# 5. Verificar pipeline
Write-Host "5️⃣  Verificando pipeline CI/CD..." -ForegroundColor Yellow
if (Test-Path ".github\workflows\ci-cd-pipeline.yml") {
    Write-Host "   ✅ Pipeline existe" -ForegroundColor Green
} else {
    Write-Host "   ❌ Pipeline NO existe" -ForegroundColor Red
    $errores++
}
Write-Host ""

# Resultado final
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
if ($errores -eq 0) {
    Write-Host "✅ TODAS LAS VERIFICACIONES PASARON" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Próximos pasos:" -ForegroundColor Cyan
    Write-Host "   1. git add ." -ForegroundColor White
    Write-Host "   2. git commit -m 'fix: corregir pipeline CI/CD'" -ForegroundColor White
    Write-Host "   3. git push origin main" -ForegroundColor White
    Write-Host ""
    Write-Host "📊 El pipeline debería ejecutarse correctamente ahora" -ForegroundColor Green
} else {
    Write-Host "❌ SE ENCONTRARON $errores ERRORES" -ForegroundColor Red
    Write-Host "   Por favor revisa los mensajes arriba" -ForegroundColor Yellow
    exit 1
}
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
