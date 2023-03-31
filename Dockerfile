#Use base image for node application 
FROM node:19-alpine as builder
# Set working directory to /app inside the container image 
WORKDIR /app 
# Copy app files 
COPY . .

# ====== BUILD ===== 
# Install dependencies 
RUN npm ci 
# Build the app 
RUN npm run build 

# ===== RUN =====

# Bundle static assets with nginx. nginx is used for serving application that are large scale
FROM nginx:1.21.0-alpine as production

# Set the env to production 
ENV NODE_ENV production 

# Copy built assets from `builder` image. The image build on first stage. Copy data from source to destination path 
COPY --from=builder /app/build /usr/share/nginx/html 


# Expose the port on which the app will be running 
EXPOSE 80

#Start the app for base image serving command 
# CMD ["npx", "serve", "build"]

CMD ["nginx", "-g", "daemon off;"]

