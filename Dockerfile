FROM node:20 AS build

WORKDIR /opt/node_app

ARG VITE_APP_WS_SERVER_URL
ARG VITE_APP_DISABLE_TRACKING

RUN git clone --depth 1 https://github.com/excalidraw/excalidraw.git .

RUN yarn --network-timeout 600000

ENV NODE_ENV=production
RUN yarn build:app:docker

FROM nginx:1.27-alpine

COPY --from=build /opt/node_app/excalidraw-app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
