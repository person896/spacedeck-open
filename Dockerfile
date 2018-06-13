FROM spacedeck/docker-baseimage:latest
ENV NODE_ENV development

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN yum update -y
RUN yum install -y rpm
RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
RUN rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
RUN yum install -y ghostscript
RUN yum -y install http://mirror.rackspace.com/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install GraphicsMagick-c++-devel
RUN yum -y install sqlite


WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install
RUN npm update
RUN npm install require-dir
RUN npm install gulp
RUN npm install gulp-rev-replace gulp-clean gulp-fingerprint gulp-rev gulp-rev-all gulp-rev-replace
RUN npm install gulp-sass --save-dev
RUN npm install -g --save-dev gulp
RUN npm install gulp-concat --save-dev

COPY app.js spacedeck.js Dockerfile Gulpfile.js LICENSE /usr/src/app/
COPY config /usr/src/app/config
COPY helpers /usr/src/app/helpers
COPY locales /usr/src/app/locales
COPY middlewares /usr/src/app/middlewares
COPY models /usr/src/app/models
COPY public /usr/src/app/public
COPY routes /usr/src/app/routes
COPY styles /usr/src/app/styles
COPY views /usr/src/app/views

RUN gulp styles
RUN npm cache clean

CMD [ "node", "spacedeck.js" ]

EXPOSE 9666
