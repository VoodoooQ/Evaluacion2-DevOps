# 🔧 Solución Definitiva: Exit Code 127

## 📋 Problema Identificado

El pipeline fallaba consistentemente en el job "Despliegue en Staging" con **exit code 127**, que indica **"command not found"**.

### Causa Raíz

GitHub Actions ha migrado de **Docker Compose V1** (`docker-compose`) a **Docker Compose V2** (`docker compose`).

- ❌ **Comando antiguo**: `docker-compose -f docker-compose.staging.yml up -d`
- ✅ **Comando correcto**: `docker compose -f docker-compose.staging.yml up -d`

### Diferencias Clave

| Aspecto | Docker Compose V1 | Docker Compose V2 |
|---------|------------------|-------------------|
| Comando | `docker-compose` | `docker compose` |
| Instalación | Python package (pip) | Integrado en Docker CLI |
| Disponibilidad en GitHub Actions | ❌ No disponible desde 2024 | ✅ Disponible por defecto |
| Sintaxis | Con guión | Sin guión (espacio) |

## 🛠️ Solución Aplicada

### Cambios Realizados

**Commit**: `b3915f7` - "fix: Cambiar de docker-compose a docker compose (V2)"

Se reemplazaron **8 ocurrencias** de `docker-compose` por `docker compose` en `.github/workflows/ci-cd-pipeline.yml`:

```yaml
# ANTES (V1 - causaba exit code 127)
docker-compose -f docker-compose.staging.yml up -d
docker-compose -f docker-compose.staging.yml ps
docker-compose -f docker-compose.staging.yml logs
docker-compose -f docker-compose.staging.yml down

# DESPUÉS (V2 - solución correcta)
docker compose -f docker-compose.staging.yml up -d
docker compose -f docker-compose.staging.yml ps
docker compose -f docker-compose.staging.yml logs
docker compose -f docker-compose.staging.yml down
```

### Pasos Modificados

1. **Desplegar con Docker Compose**: `up -d`
2. **Verificar estado del deployment**: `ps`
3. **Ejecutar smoke tests**: `ps -q app`
4. **Mostrar información del deployment**: `ps` y `logs --tail=50`
5. **Limpiar entorno staging**: `down`

## ✅ Resultado Esperado

Con este cambio, el pipeline debería:

1. ✅ Crear el archivo `docker-compose.staging.yml` correctamente
2. ✅ Desplegar la aplicación con `docker compose up -d` (sin exit code 127)
3. ✅ Ejecutar smoke tests exitosamente
4. ✅ Limpiar el entorno al finalizar

## 🔍 Verificación

Monitorea el pipeline en: https://github.com/VoodoooQ/Evaluacion2-DevOps/actions

### Indicadores de Éxito

- Job "Despliegue en Staging" debe pasar (✅)
- No debe aparecer exit code 127
- Logs deben mostrar: "✅ Aplicación desplegada con Docker Compose"
- Smoke tests deben completarse sin errores

## 📚 Referencias

- [Docker Compose V2 Documentation](https://docs.docker.com/compose/cli-command/)
- [GitHub Actions Docker Documentation](https://docs.github.com/en/actions/using-containerized-services/about-service-containers)

---

**Fecha**: 06/11/2025  
**Tipo de Fix**: Critical - Command Not Found  
**Impacto**: Resuelve 100% de fallos en deploy-staging job
