# ============================================
# 阶段 1: Maven 构建
# ============================================
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /build
COPY pom.xml .
COPY src ./src

# 使用阿里云镜像加速
RUN mvn clean package -DskipTests -q

# ============================================
# 阶段 2: JRE 运行
# ============================================
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
