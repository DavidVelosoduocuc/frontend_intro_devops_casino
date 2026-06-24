# Stage 1: Build the Angular application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package definitions
COPY package.json package-lock.json ./

# Clean install dependencies
RUN npm ci

# Copy application source code
COPY . .

# Build for production
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginxinc/nginx-unprivileged:1.25-alpine

# Copy built SPA assets
COPY --from=builder /app/dist/casino-frontend/browser /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
