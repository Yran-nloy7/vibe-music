# ============================================
# 阶段 1: Node.js 构建
# ============================================
FROM node:24-alpine AS builder

WORKDIR /build
RUN corepack enable && corepack prepare pnpm@latest --activate
RUN npm config set registry https://registry.npmmirror.com

COPY package.json ./
RUN pnpm install --no-frozen-lockfile

COPY . .
RUN pnpm build

# ============================================
# 阶段 2: Nginx 托管
# ============================================
FROM nginx:alpine

COPY --from=builder /build/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
