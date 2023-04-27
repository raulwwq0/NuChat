FROM node:18-alpine3.17 as build

RUN apk update && apk upgrade && adduser -D nuchat

USER nuchat

WORKDIR /app

COPY --chown=nuchat:nuchat . /app

RUN npm install && npx nuxt build

FROM node:18-alpine3.17

RUN apk update && apk upgrade && apk add dumb-init && adduser -D nuchat 

USER nuchat

WORKDIR /app

COPY --chown=nuchat:nuchat --from=build /app/.output ./

EXPOSE 8080


ENV HOST=0.0.0.0 PORT=8080 NODE_ENV=production

CMD ["dumb-init","node","/app/server/index.mjs"]