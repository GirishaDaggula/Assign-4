# Stage 1: Build
FROM node:16-alpine AS builder
WORKDIR /app

# Copy only what's needed for dependency installation
COPY package*.json ./
RUN npm ci --only=production

# Copy application files
COPY src/ ./src/

# Stage 2: Runtime
FROM node:16-alpine
WORKDIR /app
COPY --from=builder /app .

ENV PORT=80
EXPOSE 80
CMD ["npm", "start"]
