FROM node:22-alpine3.21 AS builder 
WORKDIR /app

# copy lock files first to leverage Docker cache
COPY package*.json ./

# install ONLY prod dependencies – no dev/test tooling is kept ⤵︎
RUN npm ci --omit=dev                   

# bring the rest of the source and (optionally) compile / transpile
ENV NODE_ENV=production \
    PORT=3000

EXPOSE 3000
CMD ["node","./index.js"]