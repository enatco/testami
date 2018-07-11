FROM nginx:alpine
WORKDIR /usr/share/nginx/html
#COPY dist .
ADD gulpfile.js .
ADD index.html .
ADD proxy.conf /etc/nginx/conf.d/ 
