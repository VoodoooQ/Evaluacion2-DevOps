# Multi-stage Dockerfile optimizado para Spring Boot + H2
# Etapa 1: Build
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

# Instalar Maven
RUN apk add --no-cache maven

# Copiar solo pom.xml primero (para aprovechar cache de dependencias)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiar código fuente
COPY src ./src

# Compilar aplicación (sin ejecutar tests, ya que se ejecutan en el pipeline)
RUN mvn clean package -DskipTests -B

# Etapa 2: Runtime
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copiar el JAR desde la etapa de build
COPY --from=builder /app/target/*.jar app.jar

# Crear usuario no-root para seguridad
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Puerto de la aplicación
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/students || exit 1

# Ejecutar aplicación con optimizaciones de JVM
ENTRYPOINT ["java", \
    "-XX:+UseContainerSupport", \
    "-XX:MaxRAMPercentage=75.0", \
    "-Djava.security.egd=file:/dev/./urandom", \
    "-jar", "app.jar"]
