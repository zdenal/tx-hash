FROM node:9.4.0-alpine as client

WORKDIR /usr/app/client/

ADD yarn.lock ./yarn.lock
ADD package.json ./package.json


RUN yarn install
COPY . ./

EXPOSE 3000
CMD ["yarn", "start"]
