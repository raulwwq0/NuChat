FROM node:18-alpine3.17 AS build

RUN apk update && apk upgrade && apk add g++ make py3-pip && adduser -D nuchat

USER nuchat

WORKDIR /app

COPY --chown=nuchat:nuchat . /app

RUN npm install && npm install nuxt@3.3.2 && npx nuxt@3.3.2 build

FROM node:18-alpine3.17

RUN apk update && apk upgrade && apk add dumb-init && adduser -D nuchat 

USER nuchat

WORKDIR /app

COPY --chown=nuchat:nuchat --from=build /app/.output ./

EXPOSE 8080


ENV HOST=0.0.0.0 PORT=8080 NODE_ENV=production

CMD ["dumb-init","node","/app/server/index.mjs"]