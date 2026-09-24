# フロントエンドをビルド
FROM node:22-alpine AS frontend
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# API サーバーがビルド済みフロントも配信する
FROM node:22-alpine
WORKDIR /app/server
COPY server/package.json server/package-lock.json ./
RUN npm ci
COPY server/ ./
COPY --from=frontend /app/dist /app/dist
ENV NODE_ENV=production
ENV STATIC_DIR=/app/dist
# Cloud Run が PORT=8080 を渡す
CMD ["npm", "start"]
