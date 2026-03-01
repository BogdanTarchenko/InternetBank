FROM gradle:8-jdk21 AS builder
WORKDIR /app

ENV GRADLE_OPTS="-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+UseParallelGC"

COPY build.gradle settings.gradle .
COPY src src
RUN gradle bootJar --no-daemon --parallel --max-workers=4 -x test

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
