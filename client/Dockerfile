FROM nginx:stable-alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# remove previous build files
RUN rm -rf /usr/share/nginx/html/*

# copy new build files
COPY client/build/web /usr/share/nginx/html

# expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]