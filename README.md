# 🎵 Vibe Music — 全栈音乐平台

> 基于 **Spring Boot 3** + **Vue 3** 的现代化音乐网站，包含服务端、管理后台、音乐客户端三大模块。

---

## 📖 项目简介

Vibe Music 是一个功能完整的在线音乐平台，支持用户浏览/搜索/播放音乐、收藏歌单、发表评论，管理员可通过后台管理系统维护歌曲、歌手、歌单、轮播图等内容。

| 项目 | 技术栈 | 端口 | 说明 |
|------|--------|------|------|
| **vibe-music-server** | Spring Boot 3 + MyBatis-Plus + MySQL + Redis + MinIO + JWT | `8080` | RESTful API 后端服务 |
| **vibe-music-admin** | Vue 3 + Vite + Element Plus + Pinia + Tailwind CSS + ECharts | `8089` | 后台管理系统 |
| **vibe-music-client** | Vue 3 + Vite + Element Plus + Pinia + Tailwind CSS | `5173` | Web 音乐播放器客户端 |
| **vibe-music-data** | MinIO 对象存储 | `9000` | 媒体资源（歌曲/封面/头像） |

---

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────────────┐
│                      浏览器 / 客户端                      │
├──────────────┬──────────────────┬───────────────────────┤
│  Admin :8089 │  Client :5173    │  直接访问 :9000        │
│  (Vue 3)     │  (Vue 3)        │  (静态资源)            │
└──────┬───────┴────────┬─────────┴───────────┬───────────┘
       │                │                     │
       │  /api 代理     │  /api 请求          │  媒体文件
       ▼                ▼                     ▼
┌─────────────────────────────────────────────────────────┐
│                Spring Boot 3 Server :8080               │
│  ┌─────────┐ ┌──────────┐ ┌────────┐ ┌─────────────┐  │
│  │ Controller│ │ Service  │ │ Mapper │ │ JWT Filter  │  │
│  └─────────┘ └──────────┘ └────────┘ └─────────────┘  │
└──────┬──────────────┬────────────────┬─────────────────┘
       │              │                │
       ▼              ▼                ▼
┌──────────┐  ┌────────────┐  ┌──────────────┐
│ MySQL :3306│ │ Redis :6379 │  │ MinIO :9000  │
│ 业务数据   │ │ 缓存/Session│  │ 文件存储      │
└──────────┘  └────────────┘  └──────────────┘
```

---

## 🗂️ 项目结构

### vibe-music-server（Spring Boot 3）

```
vibe-music-server/
├── pom.xml                              # Maven 依赖配置
├── mvnw / mvnw.cmd                      # Maven Wrapper
├── sql/
│   └── vibe_music.sql                   # 数据库初始化脚本（12 张表，2496 条数据）
├── img/                                 # 架构图 & 效果图
└── src/main/java/cn/edu/seig/vibemusic/
    ├── VibeMusicServerApplication.java  # 主启动类
    ├── config/                          # 7 个配置类
    │   ├── MinioConfig.java             # MinIO 客户端配置
    │   ├── CorsConfig.java              # CORS 跨域配置
    │   ├── WebConfig.java               # Spring MVC 配置
    │   ├── MyBatisPlusConfig.java       # MyBatis-Plus 分页插件
    │   ├── RedisConfig.java             # Redis 序列化配置
    │   ├── RolePathPermissionsConfig.java  # 角色路径权限读取
    │   └── RolePermissionManager.java   # 权限管理器
    ├── controller/                      # 12 个控制器（REST API）
    │   ├── AdminController.java         # 管理员：登录/登出/列表
    │   ├── UserController.java          # 用户：注册/登录/信息/头像
    │   ├── ArtistController.java        # 歌手：CRUD + 列表查询
    │   ├── SongController.java          # 歌曲：CRUD + 封面/音频上传
    │   ├── PlaylistController.java      # 歌单：CRUD + 封面上传
    │   ├── BannerController.java        # 轮播图：CRUD
    │   ├── CommentController.java       # 评论：发表/查看/删除
    │   ├── FeedbackController.java      # 反馈：提交/查看/处理
    │   ├── GenreController.java         # 流派：歌曲-风格关联
    │   ├── StyleController.java         # 风格：音乐风格字典
    │   ├── PlaylistBindingController.java  # 歌单-歌曲绑定
    │   └── UserFavoriteController.java  # 用户收藏
    ├── service/ & service/impl/         # 14 个服务接口 + 14 个实现
    │   ├── IAdminService / AdminServiceImpl
    │   ├── IUserService / UserServiceImpl
    │   ├── IArtistService / ArtistServiceImpl
    │   ├── ISongService / SongServiceImpl
    │   ├── IPlaylistService / PlaylistServiceImpl
    │   ├── IBannerService / BannerServiceImpl
    │   ├── ICommentService / CommentServiceImpl
    │   ├── IFeedbackService / FeedbackServiceImpl
    │   ├── IUserFavoriteService / UserFavoriteServiceImpl
    │   ├── IGenreService / GenreServiceImpl
    │   ├── IStyleService / StyleServiceImpl
    │   ├── IPlaylistBindingService / PlaylistBindingServiceImpl
    │   ├── MinioService / MinioServiceImpl     # 文件上传/删除
    │   └── EmailService / EmailServiceImpl     # 邮件发送
    ├── mapper/                          # 12 个 MyBatis-Plus Mapper
    ├── model/                           # 数据模型（DTO / Entity / VO）
    │   ├── dto/          (22 个)        # 数据传输对象（请求体）
    │   ├── entity/       (12 个)        # 数据库实体映射
    │   └── vo/           (12 个)        # 视图对象（响应体）
    ├── enumeration/                     # 6 个枚举类
    │   ├── RoleEnum.java                # 角色：ROLE_ADMIN / ROLE_USER
    │   ├── UserStatusEnum.java          # 用户状态：启用/禁用
    │   ├── BannerStatusEnum.java        # 轮播图状态
    │   ├── CommentTypeEnum.java         # 评论类型：歌曲/歌单
    │   ├── FavoriteTypeEnum.java        # 收藏类型
    │   └── LikeStatusEnum.java          # 点赞状态
    ├── result/                          # 统一响应封装
    │   ├── Result.java                  # 泛型响应 {code, message, data}
    │   └── PageResult.java              # 分页响应封装
    ├── handler/                         # 全局异常处理
    │   └── GlobalExceptionHandler.java  # @ControllerAdvice
    ├── interceptor/                     # 登录拦截器
    │   └── LoginInterceptor.java        # JWT Token 验证
    ├── constant/                        # 3 个常量类
    │   ├── JwtClaimsConstant.java       # JWT claims 键名
    │   ├── MessageConstant.java         # 业务消息常量
    │   └── PathConstant.java            # API 路径常量
    └── utils/                           # 工具类
        ├── JwtUtils.java                # JWT 令牌生成/解析
        └── MailUtils.java               # 邮件发送工具

总计：122 个 Java 源文件
```

### vibe-music-admin（Vue 3 管理端）

```
vibe-music-admin/
├── package.json                         # 依赖 & 脚本
├── vite.config.ts                       # Vite 配置（代理+插件）
├── tailwind.config.ts                   # Tailwind CSS 配置
├── .env / .env.development              # 环境变量
├── index.html                           # 入口 HTML
└── src/
    ├── main.ts                          # 应用入口
    ├── App.vue                          # 根组件
    ├── api/                             # API 接口
    │   ├── user.ts                      # 登录/登出/用户信息
    │   ├── data.ts                      # 数据统计
    │   ├── routes.ts                    # 动态路由
    │   └── system.ts                    # 系统管理
    ├── store/                           # Pinia 状态管理
    │   └── modules/
    │       ├── user.ts                  # 用户状态
    │       ├── permission.ts            # 权限状态
    │       └── app.ts                   # 应用设置
    ├── router/                          # Vue Router
    │   ├── index.ts                     # 路由配置
    │   └── utils.ts                     # 路由工具
    ├── layout/                          # 布局组件
    │   ├── index.vue                    # 主布局
    │   ├── components/                  # 侧边栏/顶部栏/标签页
    │   └── hooks/                       # 布局逻辑 hooks
    ├── views/                           # 页面组件
    │   ├── login/index.vue              # 登录页
    │   ├── welcome/index.vue            # 仪表盘（统计图表）
    │   ├── user/index.vue               # 用户管理
    │   ├── artist/
    │   │   ├── index.vue                # 歌手列表
    │   │   └── form/index.vue           # 歌手表单
    │   ├── song/
    │   │   ├── index.vue                # 歌曲列表（左树右表）
    │   │   ├── tree.vue                 # 歌手选择树
    │   │   └── form/
    │   │       ├── index.vue            # 歌曲表单
    │   │       ├── preview.vue          # 音频预览
    │   │       └── upload.vue           # 音频上传
    │   ├── playlist/
    │   │   ├── index.vue                # 歌单列表
    │   │   └── form/index.vue           # 歌单表单
    │   ├── banner/index.vue             # 轮播图管理
    │   ├── feedback/index.vue           # 反馈管理
    │   └── error/                       # 错误页面 (403/404/500)
    ├── components/                      # 公共组件
    │   ├── ReIcon/                      # 图标组件
    │   ├── ReDialog/                    # 弹窗组件
    │   ├── ReCountTo/                   # 数字动画
    │   ├── RePureTableBar/              # 表格工具栏
    │   └── ...
    ├── utils/                           # 工具函数
    │   ├── http/index.ts                # Axios 封装（请求/响应拦截）
    │   ├── auth.ts                      # Token 管理
    │   └── progress.ts                  # NProgress 进度条
    └── style/                           # 全局样式
```

### vibe-music-client（Vue 3 音乐客户端）

```
vibe-music-client/
├── package.json                         # 依赖 & 脚本
├── vite.config.ts                       # Vite 配置
├── tailwind.config.ts                   # Tailwind CSS 配置
├── .env / .env.development / .env.production / .env.test
├── index.html                           # 入口 HTML
└── src/
    ├── main.ts                          # 应用入口
    ├── App.vue                          # 根组件
    ├── api/                             # API 接口层
    │   ├── index.ts                     # 复合 API 导出
    │   ├── interface.ts                 # API 类型定义
    │   └── system.ts                    # 系统 API（轮播图/流派/反馈）
    ├── stores/                          # Pinia 状态管理（持久化）
    │   └── modules/
    │       ├── audio.ts                 # 播放器：当前歌曲/队列/播放状态
    │       ├── user.ts                  # 用户：登录态/信息/Token
    │       ├── artist.ts               # 歌手数据
    │       ├── playlist.ts              # 歌单数据
    │       ├── library.ts               # 歌曲库
    │       ├── favorite.ts              # 收藏状态
    │       ├── theme.ts                 # 暗黑/亮色主题
    │       ├── setting.ts               # 应用设置
    │       └── menu.ts                  # 导航菜单
    ├── routers/                         # Vue Router 路由
    │   └── index.ts                     # 路由表
    ├── pages/                           # 页面组件
    │   ├── index.vue                    # 首页：轮播图 + 推荐
    │   ├── library/index.vue            # 歌曲库/搜索
    │   ├── artist/
    │   │   ├── index.vue                # 歌手浏览列表
    │   │   └── [id].vue                 # 歌手详情页
    │   ├── playlist/
    │   │   ├── index.vue                # 歌单浏览
    │   │   └── [id].vue                 # 歌单详情（含歌曲列表）
    │   ├── like/index.vue               # 我的收藏
    │   └── user/index.vue               # 个人中心/设置
    ├── layout/                          # 布局
    │   ├── index.vue                    # 根布局
    │   ├── components/
    │   │   ├── aside/                   # 侧边导航栏
    │   │   ├── header/                  # 顶栏（用户头像/登录入口）
    │   │   ├── footer/                  # 底部播放栏（播放控制 + 进度条）
    │   │   ├── main/                    # 主内容区
    │   │   └── bg/                      # 背景样式（毛玻璃效果）
    ├── components/                      # 公共组件
    │   ├── Artplayer.vue                # 音频播放器（基于 Artplayer）
    │   ├── Table.vue                    # 通用数据表格
    │   ├── Auth/
    │   │   ├── LoginForm.vue            # 登录表单
    │   │   ├── RegisterForm.vue         # 注册表单
    │   │   ├── ResetPasswordForm.vue    # 密码重置表单
    │   │   ├── AuthTabs.vue             # 登录/注册切换
    │   │   └── AuthGuard.vue            # 路由鉴权守卫
    │   ├── Common/
    │   │   └── FeedbackDialog.vue       # 用户反馈弹窗
    │   └── DrawerMusic/
    │       ├── index.vue                # 歌曲详情抽屉
    │       ├── left.vue                 # 歌曲信息/歌词
    │       └── right.vue                # 相关推荐
    ├── hooks/                           # 组合式函数
    │   ├── useAudioPlayer.ts            # 音频播放逻辑
    │   └── interface.ts                 # Hook 类型定义
    ├── utils/                           # 工具函数
    │   ├── http.ts                      # Axios 封装
    │   ├── dateUtils.ts                 # 日期格式化
    │   ├── enum.ts                      # 枚举常量
    │   ├── parsedLyrics.ts              # LRC 歌词解析器
    │   ├── themeTools.ts                # 主题切换工具
    │   └── index.ts                     # 通用工具集
    └── assets/                          # 静态资源（图标/图片）
```

### vibe-music-data（媒体资源）

```
e:\vibe-music-data\
├── songs/         501 首 MP3 歌曲（3.3 GB）
├── songCovers/    271 张歌曲封面（378 MB）
├── artists/       123 张歌手照片（11 MB）
├── playlists/     17 张歌单封面（22 MB）
├── banners/       10 张首页轮播图（7 MB）
└── users/         2 张用户头像（0.5 MB）

总计：924 个文件，3.7 GB
```

---

## 🗄️ 数据库设计（12 张表，2496 条初始数据）

| 表名 | 说明 | 关键字段 | 关联 |
|------|------|----------|------|
| `tb_admin` | 管理员账号 | id, username, password | - |
| `tb_user` | 用户 | id, username, password, phone, email, user_avatar, introduction, status | - |
| `tb_artist` | 歌手 | id, name, gender, avatar, birth, area, introduction | - |
| `tb_song` | 歌曲 | id, name, album, lyric, duration, cover_url, audio_url, release_time | → `tb_artist` |
| `tb_style` | 音乐风格字典 | id, name (乡村/华语流行/古典/摇滚/欧美流行/电子/粤语流行…) | - |
| `tb_genre` | 歌曲-风格关联 | song_id, style_id (多对多中间表) | → `tb_song`, `tb_style` |
| `tb_playlist` | 歌单 | id, title, cover_url, introduction, style | - |
| `tb_playlist_binding` | 歌单-歌曲关联 | playlist_id, song_id (多对多中间表) | → `tb_playlist`, `tb_song` |
| `tb_banner` | 首页轮播图 | id, banner_url, status (0=启用/1=禁用) | - |
| `tb_comment` | 评论 | id, content, type (0=歌曲/1=歌单), like_count | → `tb_user`, `tb_song`, `tb_playlist` |
| `tb_feedback` | 用户反馈 | id, user_id, feedback, create_time | → `tb_user` |
| `tb_user_favorite` | 用户收藏 | id, type (0=歌曲/1=歌单), song_id, playlist_id | → `tb_user`, `tb_song`, `tb_playlist` |

**实体关系图：**

```
tb_user ──┬── tb_comment (评论)
          ├── tb_feedback (反馈)
          └── tb_user_favorite (收藏)
                 ├── tb_song (收藏歌曲)
                 └── tb_playlist (收藏歌单)

tb_artist ── tb_song (歌手歌曲)
tb_song ──┬── tb_genre ── tb_style (歌曲风格多对多)
           └── tb_playlist_binding ── tb_playlist (歌单歌曲多对多)
```

---

## 🐳 Docker 一键部署（推荐）

```bash
# 1. 安装 Docker Desktop
#    https://www.docker.com/products/docker-desktop

# 2. 确保 vibe-music-data 媒体文件在项目根目录
#    e:\vibe-music\vibe-music-data\  (3.7GB，百度网盘下载)

# 3. 一键启动全部 6 个服务
cd e:\vibe-music
docker compose up -d

# 4. 等待启动完成（首次需要 5-10 分钟构建）
docker compose logs -f server  # 查看后端日志
```

启动后访问：

| 服务 | 地址 | 账号 |
|------|------|------|
| 🎵 音乐客户端 | http://localhost:8090 | 注册即用 |
| 📊 管理后台 | http://localhost:8089 | `admin_1` / `123456abc` |
| 📁 文件服务 | http://localhost:9000 | 媒体资源 |

常用命令：

```bash
docker compose up -d          # 启动
docker compose down           # 停止
docker compose logs -f        # 查看所有日志
docker compose restart server # 重启后端
docker compose build --no-cache  # 强制重新构建
```

---

## 🚀 本地运行指南（手动）

### 环境要求

| 软件 | 版本 | 说明 |
|------|------|------|
| **JDK** | 17+ | 推荐 21 (IntelliJ 自带 JBR) |
| **Maven** | 3.6+ | 可使用项目自带 mvnw |
| **MySQL** | 8.0+ | 端口 3306 |
| **Redis** | 6.0+ | 端口 6379 |
| **Node.js** | 18+ | 推荐 24 LTS |
| **pnpm** | 9+ | 前端包管理器 |

### 1. 启动基础服务

```bash
# MySQL（确保已启动并创建数据库）
mysql -u root -p
CREATE DATABASE vibe_music CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 导入数据
mysql -u root -p vibe_music < sql/vibe_music.sql

# Redis
redis-server

# MinIO（或用 http-server 替代）
# 如果使用 http-server 作为文件服务：
npm install -g http-server
http-server e:\vibe-music-data -p 9000 --cors

# 如果使用 MinIO：
minio server e:\vibe-music-data
```

### 2. 配置后端

修改 `src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/vibe_music?useUnicode=true&characterEncoding=utf-8&useSSL=false
    username: root        # 你的 MySQL 用户名
    password: "123456"    # 你的 MySQL 密码
  data:
    redis:
      host: 127.0.0.1
      port: 6379

minio:
  endpoint: http://localhost:9000
  accessKey: minioadmin
  secretKey: minioadmin
  bucket: vibe-music-data
```

### 3. 启动后端

```bash
cd vibe-music-server
./mvnw spring-boot:run
# 或者在 IntelliJ IDEA 中右键运行 VibeMusicServerApplication.java

# 启动成功标志：
# Started VibeMusicServerApplication in X.XXX seconds
```

### 4. 启动管理端

```bash
cd vibe-music-admin
pnpm install
pnpm dev
# 访问 http://localhost:8089
# 默认账号：admin_1 / 123456abc
```

### 5. 启动音乐客户端

```bash
cd vibe-music-client
pnpm install
pnpm dev
# 访问 http://localhost:5173
```

---

## 🔌 API 接口概览

### 管理员模块 `/admin`
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/admin/login` | 管理员登录 |
| POST | `/admin/logout` | 管理员登出 |
| GET | `/admin/list` | 管理员列表 |

### 用户模块 `/user`
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/user/register` | 用户注册 |
| POST | `/user/login` | 用户登录 |
| PUT | `/user/update` | 更新个人信息 |
| PUT | `/user/avatar` | 上传头像 |
| GET | `/user/list` | 用户列表（管理员） |

### 歌手模块 `/artist`
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/artist/list` | 歌手列表 |
| POST | `/artist/add` | 添加歌手 |
| PUT | `/artist/update` | 更新歌手 |
| DELETE | `/artist/delete/{id}` | 删除歌手 |

### 歌曲模块 `/song`
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/song/list` | 歌曲列表（分页/筛选） |
| GET | `/song/{id}` | 歌曲详情 |
| POST | `/song/add` | 添加歌曲 |
| PUT | `/song/update` | 更新歌曲 |
| DELETE | `/song/delete/{id}` | 删除歌曲 |
| PUT | `/song/cover/{id}` | 上传歌曲封面 |
| PUT | `/song/audio/{id}` | 上传歌曲音频 |

### 歌单模块 `/playlist`
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/playlist/list` | 歌单列表 |
| POST | `/playlist/add` | 创建歌单 |
| PUT | `/playlist/update` | 更新歌单 |
| DELETE | `/playlist/delete/{id}` | 删除歌单 |
| PUT | `/playlist/cover/{id}` | 上传歌单封面 |

### 评论模块 `/comment`
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/comment/list` | 评论列表 |
| POST | `/comment/add` | 发表评论 |
| DELETE | `/comment/delete/{id}` | 删除评论 |

### 收藏模块 `/favorite`
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/favorite/add` | 添加收藏 |
| DELETE | `/favorite/remove` | 取消收藏 |
| GET | `/favorite/list/{userId}` | 用户收藏列表 |

---

## 🎯 核心功能

### 管理端（Admin）

- **仪表盘**：用户/歌手/歌曲/歌单数量统计 + ECharts 图表
- **用户管理**：查看/禁用/启用用户
- **歌手管理**：CRUD + 照片上传（支持国籍/性别/流派筛选）
- **歌曲管理**：CRUD + 封面/音频上传 + 音频预览（左侧歌手树筛选）
- **歌单管理**：CRUD + 封面上传
- **轮播图管理**：首页轮播图 CRUD
- **反馈管理**：查看/处理用户反馈
- **JWT 认证**：登录态管理 + Token 自动刷新
- **暗黑模式**：亮色/暗色主题切换

### 音乐客户端（Client）

- **浏览发现**：首页轮播图 + 推荐歌单/歌手/歌曲
- **搜索**：关键词搜索歌曲/歌手/歌单
- **音乐播放**：播放控制（播放/暂停/上一首/下一首）+ 进度条 + 音量
- **用户系统**：注册/登录/注销/个人资料编辑/头像上传
- **评论互动**：发表/查看/点赞评论
- **收藏**：收藏歌曲和歌单
- **暗黑模式**：亮色/暗色主题切换

---

## 🛠️ 技术亮点

### 后端
- **Spring Boot 3.3.7** + Java 17 — 最新稳定版框架
- **MyBatis-Plus 3.5.9** — 强大的 ORM + 分页插件
- **JWT 认证** — 无状态 Token 认证 + 角色权限拦截
- **MinIO** — 高性能对象存储，支持大文件上传（100MB）
- **Redis** — 缓存热点数据，10 分钟 TTL
- **Druid** — 数据库连接池 + SQL 监控
- **AOP 权限拦截** — 基于注解的角色路径权限控制
- **统一响应** — `Result<T>` 泛型封装，code + message + data

### 管理端
- **Vue 3 + TypeScript** — Composition API + 类型安全
- **vue-pure-admin** — 企业级后台模板
- **Element Plus** — 成熟的 UI 组件库
- **Tailwind CSS** — 原子化 CSS 框架
- **ECharts 5** — 数据可视化图表（饼图/柱状图/折线图）
- **Pinia** — 轻量级状态管理
- **Vite 6** — 极速开发构建
- **动态路由** — 基于角色的菜单/路由生成

### 音乐客户端
- **Vue 3 + TypeScript** — 现代化前端框架
- **自定义播放器** — 底部固定播放栏 + 播放列表管理
- **玻璃拟态 UI** — 现代毛玻璃设计风格
- **响应式设计** — 适配桌面端和移动端
- **Pinia 播放器状态** — 全局播放状态管理

---

## 📝 默认账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | `admin_1` | `123456abc` |
| 管理员 | `admin_888` | `123456abc` |

---

## 📄 许可证

本项目使用 [MIT License](LICENSE)。

---

## 🙏 致谢

- [vue-pure-admin](https://github.com/pure-admin/vue-pure-admin) — 管理端模板
- [GlassMusicPlayer](https://github.com/XiangZi7/GlassMusicPlayer) — 客户端 UI 灵感
- [Spring Boot](https://spring.io/projects/spring-boot) — 后端框架
- [MyBatis-Plus](https://baomidou.com/) — ORM 增强工具
- [MinIO](https://min.io/) — 对象存储

---

> 📅 最后更新：2026-07-17
