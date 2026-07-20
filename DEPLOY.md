# Vibe Music 本地部署完整流程

## 0. 前置环境

| 软件 | 路径 | 验证命令 |
|------|------|----------|
| JDK 21 | `D:\JavaScript\idea\IntelliJ IDEA 2025.2.2\jbr` | `D:\JavaScript\...\jbr\bin\java -version` |
| Node.js 24 | `D:\nodejs` | `node --version` |
| pnpm | `D:\nodejs\node_global` | `pnpm --version` |
| Git | `D:\Git\bin` | `git --version` |
| MySQL 8 | 开机自启 :3306 | 任务管理器 → 服务 → MySQL80 |
| Redis | `D:\Redis 5.0.14.1\...\redis-server.exe` | 手动启动 |
| Maven | 项目自带 `mvnw.cmd`，无需全局安装 | — |

---

## 1. 配置 IDEA 的 Maven

**这一步是解决 100 个编译错误的关键！**

1. 打开 IntelliJ IDEA
2. `File` → `Settings` (Ctrl+Alt+S)
3. 左侧搜索 `Maven`
4. 确认两项：
   - **Maven home path**: IDEA 自带的即可
   - **User settings file**: `C:\Users\14269\.m2\settings.xml` ✅ (勾选 Override)
   - **Local repository**: `C:\Users\14269\.m2\repository`
5. 点击 `OK`

> `settings.xml` 已配置阿里云镜像加速，否则 Maven 中央仓库在国内极慢/超时。

---

## 2. 编译并启动后端

### 命令行方式（推荐，100% 成功）

打开 **PowerShell 或 cmd**（普通终端，不要用 IDE 内置终端）：

```powershell
# 设置 Java 环境
set JAVA_HOME=D:\JavaScript\idea\IntelliJ IDEA 2025.2.2\jbr
set PATH=%JAVA_HOME%\bin;%PATH%

# 进入后端目录
cd e:\vibe-music\vibe-music-server

# 清缓存 + 编译 + 启动（一条命令）
mvnw.cmd clean compile spring-boot:run -DskipTests
```

看到 `Started VibeMusicServerApplication` 即成功。

### IDEA 方式

1. 右侧 **Maven** 面板 → **Reload** (🔄)
2. **Lifecycle** → 双击 **clean**
3. **Lifecycle** → 双击 **compile** (此时不应有错误)
4. 找到 `VibeMusicServerApplication.java` → 右键 → Run

> **编译报错 100 个？** 必杀技：
> ```
> 删除 C:\Users\14269\.m2\repository 整个文件夹
> 然后 IDEA → Maven 面板 → Reload → compile
> ```

---

## 3. 启动基础服务

```powershell
# Redis（每次开机后执行）
start "" "D:\Redis 5.0.14.1\Redis-8.0.1-Windows-x64-cygwin\redis-server.exe"

# 文件服务 :9000（MinIO 替代）
cd e:\
npx http-server -p 9000 --cors -c-1
```

> 或者直接双击 `e:\vibe-music\start-all.bat` 一键启动全部。

---

## 4. 启动前端

```powershell
# 管理端 :8089
cd e:\vibe-music\vibe-music-admin
pnpm install   # 仅首次
pnpm dev

# 客户端 :8090
cd e:\vibe-music\vibe-music-client
pnpm install   # 仅首次
pnpm dev
```

---

## 5. 验证

| 服务 | 地址 | 预期 |
|------|------|------|
| 后端 | `http://localhost:8080/admin/login` | POST 返回 JSON |
| 文件 | `http://localhost:9000/vibe-music-data/songs/` | 文件列表 |
| 管理端 | `http://localhost:8089` | 登录页 |
| 客户端 | `http://localhost:8090` | 首页能看到曲目 |

### 登录测试

| 端 | 账号 |
|----|------|
| 管理端 | `admin_1` / `123456abc` |
| 客户端 | `user909@example.com` / `123456abc` |

---

## 6. 常见问题

| 问题 | 解决 |
|------|------|
| `ClassNotFoundException` | 没编译，先执行 `mvnw compile` |
| Maven 100 个错误 | 删 `C:\Users\14269\.m2\repository`，确认 settings.xml 有阿里云镜像 |
| 前端空白/无数据 | 后端未启动或未编译 |
| 歌曲无法播放 | 文件服务 :9000 未启动 |
| Redis 报错 | 启动 `redis-server.exe` |
| 端口被占用 | 双击 `stop-all.bat` 释放端口 |

---

## 7. 一键脚本

| 脚本 | 用途 |
|------|------|
| `start-all.bat` | 启动全部服务（Redis + MySQL + 文件 + 后端 + 两个前端） |
| `stop-all.bat` | 停止全部 + 释放端口 |
