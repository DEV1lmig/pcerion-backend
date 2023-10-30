FROM node:18.17.0 as builder

WORKDIR /

COPY . . 

RUN rm -rf node_modules

RUN apt-get update

RUN apt-get install -y python

RUN npm install -g npm@latest

RUN npm install --loglevel=error
RUN npm install -g cross-env

RUN npm run build


FROM node:18.17.0

WORKDIR /

RUN mkdir dist

COPY package*.json ./ 

COPY develop.sh .

COPY .env .

COPY medusa-config.js .

RUN apt-get update

RUN apt-get install -y python3
# RUN apk add --no-cache python3

RUN npm install -g @medusajs/medusa-cli

RUN npm i --only=production

COPY --from=builder /dist ./dist

EXPOSE 9000

ENTRYPOINT ["./develop.sh", "start"]
