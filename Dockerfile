###############################################################################
# ── Build stage ── (full Debian image with compilers & libc-dev)        #
###############################################################################
FROM node:22-alpine3.21 AS builder 
WORKDIR /app

# copy lock files first to leverage Docker cache
COPY package*.json ./

# install ONLY prod dependencies – no dev/test tooling is kept ⤵︎
RUN npm ci --omit=dev                     # faster + smaller than "npm install"

# bring the rest of the source and (optionally) compile / transpile
COPY . .
# RUN npm run build                       # include if you have a build step

###############################################################################
# ── Runtime stage ── (minimal Alpine image)                             #
###############################################################################
FROM node:22-alpine3.21
WORKDIR /app

# copy the application *without* dev deps or build artifacts we don’t need
COPY --from=builder /app .

# helpful defaults for prod Node apps
ENV NODE_ENV=production \
    PORT=3000

EXPOSE 3000
CMD ["node","./index.js"]
