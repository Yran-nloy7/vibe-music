@echo off
chcp 65001 >nul
title 🎵 Vibe Music — 一键启动

echo ========================================
echo   Vibe Music 全栈启动
echo ========================================
echo.

:: ===== 环境变量 =====
set "JAVA_HOME=D:\JavaScript\idea\IntelliJ IDEA 2025.2.2\jbr"
set "PATH=%JAVA_HOME%\bin;D:\nodejs;D:\nodejs\node_global;D:\Git\bin;%PATH%"

:: ===== 1. Redis =====
echo [1/5] 启动 Redis ...
start "Redis" /MIN "D:\Redis 5.0.14.1\Redis-8.0.1-Windows-x64-cygwin\redis-server.exe"
echo        Redis 已启动
timeout /t 2 /nobreak >nul

:: ===== 2. MySQL 检测 =====
echo [2/5] 检测 MySQL ...
sc query MySQL80 | find "RUNNING" >nul
if %errorlevel%==0 (
    echo        MySQL 已在运行
) else (
    echo        尝试启动 MySQL ...
    net start MySQL80 2>nul
    if %errorlevel%==0 (echo MySQL 已启动) else (echo MySQL 启动失败，请手动启动)
)
timeout /t 2 /nobreak >nul

:: ===== 3. 文件服务 =====
echo [3/5] 启动文件服务 :9000 ...
start "Files:9000" /MIN cmd /c "http-server e:\ -p 9000 --cors -c-1"
echo        文件服务 :9000 已启动
timeout /t 2 /nobreak >nul

:: ===== 4. 后端 Server =====
echo [4/5] 启动后端 :8080 (首次编译需等待) ...
cd /d e:\vibe-music\vibe-music-server
start "Server:8080" /MIN cmd /c "set JAVA_HOME=D:\JavaScript\idea\IntelliJ IDEA 2025.2.2\jbr&& set PATH=%JAVA_HOME%\bin;%PATH%&& mvnw.cmd spring-boot:run"
echo        后端正在启动，等待 "Started VibeMusicServerApplication" 即可
timeout /t 5 /nobreak >nul

:: ===== 5. 前端 Admin + Client =====
echo [5/5] 启动前端 ...
cd /d e:\vibe-music\vibe-music-admin
start "Admin:8089" /MIN cmd /c "set PATH=D:\nodejs;D:\nodejs\node_global;%%PATH%%&& pnpm dev"
cd /d e:\vibe-music\vibe-music-client
start "Client:8090" /MIN cmd /c "set PATH=D:\nodejs;D:\nodejs\node_global;%%PATH%%&& pnpm dev"
echo        管理端 :8089 + 客户端 :8090 已启动

echo.
echo ========================================
echo   ✅ 启动完成！
echo ========================================
echo.
echo   🎵 客户端    http://localhost:8090
echo   📊 管理端    http://localhost:8089  (admin_1 / 123456abc)
echo   🔧 后端 API  http://localhost:8080  (等待编译完成)
echo.
echo   按任意键关闭此窗口（服务不受影响）
pause >nul
