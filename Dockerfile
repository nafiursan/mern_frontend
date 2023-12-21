# Stage 1: Build stage
FROM node:18 as builder

# Set the working directory inside the container
WORKDIR /app

COPY package*.json ./
RUN npm install
RUN npm install @mui/material @emotion/react @emotion/styled @material-ui/core @material-ui/icons --legacy-peer-deps
RUN npm install @mui/icons-material --legacy-peer-deps

# Clone your GitHub repository
COPY . /app

# Install dependencies for the root project
#RUN npm install
#RUN npm install @mui/material @emotion/react @emotion/styled @material-ui/core @material-ui/icons --legacy-peer-deps
#RUN npm install @mui/icons-material --legacy-peer-deps

# Build the application
RUN npm run build

# Stage 2: Run stage
FROM nginx:latest

# Copy the build output from the builder stage to the nginx public directory
COPY ./backend-proxy.conf /etc/nginx/conf.d/
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

