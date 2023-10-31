#Dependencies
FROM node:18-alpine3.16 as deps 
WORKDIR /app/medusa/
# Copy package.json and yarn.lock to the workdir
COPY /backend/package.json .
COPY /backend/yarn.lock .
# Install depes
RUN yarn install --frozen-lockfile

#Build
FROM node:18-alpine3.16 as builder
WORKDIR /app/medusa/
# Copy cached node_modules from deps
COPY --from=deps /app/medusa/node_modules /app/medusa/node_modules
# Install python and medusa-cli
RUN apk update
RUN apk add python3
RUN yarn global add @medusajs/medusa-cli@latest
# Copy app source code
COPY /backend/ /app/medusa
# Image entrypoint develop
ENTRYPOINT ["/bin/sh", "./start.sh", "develop"]
