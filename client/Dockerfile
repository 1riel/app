FROM nginx:1.24.0-alpine

# remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# copy new build files
COPY client/build/web /usr/share/nginx/html

# expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]