# Stage 1: Build the application
FROM node:16-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production  # Install production dependencies only

# Copy application files
COPY src/ ./src/
COPY spec/ ./spec/  # Only if you need tests in the image
COPY . .

# Stage 2: Create lightweight production image
FROM node:16-alpine

WORKDIR /app
# Copy production dependencies and built application
COPY --from=builder /app .

# Ensure your app listens on the correct port (must match ContainerPort in CloudFormation)
ENV PORT=80
EXPOSE 80

# Use node process manager for better reliability
RUN npm install -g pm2
CMD ["pm2-runtime", "start", "package.json"]
