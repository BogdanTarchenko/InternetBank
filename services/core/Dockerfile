FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

COPY gradlew ./
COPY gradle gradle
COPY build.gradle.kts settings.gradle.kts ./
# Исправление CRLF (Windows) -> LF и формата JVM_OPTS для Alpine sh
RUN sed -i 's/\r$//' gradlew && \
    sed -i 's/^DEFAULT_JVM_OPTS=.*/DEFAULT_JVM_OPTS="-Xmx64m -Xms64m"/' gradlew && \
    chmod +x gradlew

RUN ./gradlew dependencies --no-daemon || true

COPY src src

RUN ./gradlew bootJar --no-daemon -x test

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

RUN adduser -D -u 1000 appuser
USER appuser

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
