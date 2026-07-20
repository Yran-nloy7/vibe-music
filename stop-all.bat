@echo off
chcp 65001 >nul
title 停止所有 Vibe Music 服务

echo 正在停止所有 Vibe Music 服务...

:: 文件服务
taskkill /FI "WINDOWTITLE eq Files:9000*" /F 2>nul

:: 前端
taskkill /FI "WINDOWTITLE eq Admin:8089*" /F 2>nul
taskkill /FI "WINDOWTITLE eq Client:8090*" /F 2>nul

:: 后端
taskkill /FI "WINDOWTITLE eq Server:8080*" /F 2>nul

:: 端口级别的强制释放
for %%p in (8080 8089 8090 9000) do (
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%%p.*LISTENING" 2^>nul') do (
        echo 释放端口 %%p (PID: %%a)
        taskkill /PID %%a /F 2>nul
    )
)

echo ✅ 全部已停止
pause
