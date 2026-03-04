# Stage 1: Build the WAR using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy source code into the build container
COPY . .

# Build the WAR file (skip tests for speed if desired)
RUN mvn clean package -DskipTests

# Stage 2: Runtime image with only JDK
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the WAR from the builder stage
COPY --from=builder /app/target/javacicdapp-0.0.1-SNAPSHOT.war app.war

# Expose application port
EXPOSE 8082

# Run the WAR directly (works if it's a Spring Boot executable WAR)
CMD ["java", "-jar", "app.war"]