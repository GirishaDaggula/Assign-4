# Stage 1: Build the application
FROM node:16-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production  # Install production dependencies only

# Copy only what's needed
COPY src/ ./src/
COPY . .  # Be careful with this - it may copy unwanted files

# Stage 2: Production image
FROM node:16-alpine
WORKDIR /app
COPY --from=builder /app .

ENV PORT=80
EXPOSE 80

CMD ["npm", "start"]
