# syntax=docker/dockerfile:1
FROM node:26.13.0-alpine3.24
WORKDIR /app
ENV NODE_ENV=production

# Copy only the dependency files first, so that changes in the code do not
# invalidate the cache of the dependency installation
COPY package.json package-lock.json ./

# npm ci installs exactly what the lock file says. The cache mount keeps npm's
# download cache between builds, outside the image
RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

COPY server.js ./

# The node user (UID 1000) comes with the base image
USER 1000:1000
EXPOSE 3000
CMD ["node", "server.js"]
