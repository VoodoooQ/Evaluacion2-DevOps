# 🚀 Spring Boot - Pipeline CI/CD

## 📋 Descripción

API REST con **Spring Boot 3.3.7** y **Java 17** para gestión de estudiantes. Incluye pipeline CI/CD completo con análisis de seguridad, pruebas automatizadas y despliegue con Docker Compose.

### Características:
- ✅ API REST CRUD completa
- ✅ Base de datos H2 con consola web
- ✅ Pipeline CI/CD automatizado (GitHub Actions)
- ✅ Análisis de seguridad con Snyk
- ✅ Cobertura de pruebas con JaCoCo (≥50%)
- ✅ Orquestación con Docker Compose

## 🛠️ Tecnologías

**Java 17** | **Spring Boot 3.3.7** | **H2 Database** | **Maven** | **Docker** | **GitHub Actions** | **JaCoCo** | **Snyk**

---

## ⚡ Inicio Rápido

### Docker Compose (Recomendado)
```bash
docker-compose up -d
docker-compose logs -f springboot-app
docker-compose down
```

### Maven Local
```bash
mvn test                # Pruebas
mvn spring-boot:run     # Ejecutar
mvn clean package       # Empaquetar
```

### 🌐 Endpoints

**API REST**: `http://localhost:8080/students`
- `GET /students` - Listar todos
- `POST /students` - Crear
- `GET /students/{id}` - Obtener
- `PUT /students/{id}` - Actualizar
- `DELETE /students/{id}` - Eliminar

**H2 Console**: `http://localhost:8080/h2-console/`
- JDBC: `jdbc:h2:mem:testdb` | Usuario: `SA` | Contraseña: _(vacío)_

---

## 📊 Pipeline CI/CD

Pipeline automático en 5 etapas:

### 1️⃣ Tests
- Ejecuta `mvn clean test`
- JaCoCo: cobertura mínima 50%
- Artifacts con reportes

### 2️⃣ Seguridad
- **Snyk**: Escanea CVEs en dependencias
- **Bloqueo**: Vulnerabilidades HIGH/CRITICAL

### 3️⃣ Build Docker
- Imagen multi-stage optimizada
- Tags: `sha-{commit}` + `latest`
- Push a Docker Hub

### 4️⃣ Deploy Staging
- Despliega con Docker Compose
- Smoke tests de endpoints
- Validación de funcionamiento

### 5️⃣ Notificaciones
- Estado del pipeline
- Versión desplegada

### 🔍 Trazabilidad

Cada cambio es completamente trazable:

| Componente | Cómo se Traza |
|------------|---------------|
| **Código** | Git commit (autor, fecha, mensaje) |
| **Imagen** | Docker tag con SHA del commit |
| **Reportes** | Artifacts en GitHub Actions |
| **Ejecución** | Logs completos en Actions |
| **Despliegue** | Tag indica exactamente qué código corre |

**Ejemplo**:
```bash
# Ver qué commit está desplegado
docker inspect springboot-app:sha-abc123f

# Buscar en Git
git show abc123f

# Ver reportes
GitHub → Actions → Run → Artifacts
```

### ✅ Garantías de Calidad

| Capa | Herramienta | Verifica | Bloquea |
|------|-------------|----------|---------|
| **Tests** | JUnit + JaCoCo | Cobertura ≥50% | ✅ Sí |
| **Seguridad** | Snyk | CVEs en deps | ✅ Sí |
| **Build** | Maven | Compilación | ✅ Sí |
| **Deploy** | Smoke Tests | Endpoints | ✅ Sí |
| **Deps** | Dependabot | Actualizaciones | ⚠️ PR |

**Niveles**:
- 🛑 **Crítico**: Pipeline se detiene
- ⚠️ **Advertencia**: Continúa con reporte
- 📊 **Informativo**: Solo registra

---

## 🐳 Docker Compose

```bash
# Iniciar
docker-compose up -d

# Escalar
docker-compose up -d --scale springboot-app=3

# Logs
docker-compose logs -f

# Detener
docker-compose down
```

**Servicios**:
- `springboot-app`: Puerto 8080, health checks, auto-restart
- `nginx` (opcional): Load balancer

---

## ⚙️ Configuración GitHub

### 1. Crear repo y subir código
```bash
git init
git add .
git commit -m "feat: Implementación inicial"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/springboot-app.git
git push -u origin main
```

### 2. Configurar Secrets

**Settings → Secrets and variables → Actions**:

```
DOCKER_USERNAME: tu-usuario-docker
DOCKER_PASSWORD: tu-token-docker
SNYK_TOKEN: tu-token-snyk
```

---

## 📁 Estructura

```
springboot-app/
├── .github/workflows/ci-cd-pipeline.yml
├── src/main/java/com/example/bdget/
├── Dockerfile
├── docker-compose.yml
├── pom.xml
└── README.md
```

---

## 🆘 Problemas Comunes

**Pipeline falla**:
```bash
mvn clean test
mvn jacoco:report
```

**Puerto ocupado**:
```yaml
# docker-compose.yml
ports:
  - "8081:8080"
```

**H2 Console no accesible**:
- URL: `http://localhost:8080/h2-console/`
- JDBC: `jdbc:h2:mem:testdb`

---

## 🤝 Contribuir

```bash
git checkout -b feature/nueva-funcionalidad
git commit -m 'feat: Nueva funcionalidad'
git push origin feature/nueva-funcionalidad
# Abrir Pull Request
```

---

## 👥 Autor

**Maximiliano Andres Diaz Caro**

## 📄 Licencia

MIT License
