FROM node:24 AS dependencias

WORKDIR /usr/app

RUN corepack enable

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

RUN pnpm install --frozen-lockfile

FROM dependencias AS construccion

COPY nest-cli.json tsconfig*.json ./
COPY src ./src

RUN pnpm run build

FROM node:24-alpine AS dependencias-produccion

WORKDIR /usr/app

RUN corepack enable

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

RUN pnpm install --prod --frozen-lockfile

FROM node:24-alpine AS publicacion

WORKDIR /usr/app

COPY package.json ./
COPY --from=dependencias-produccion /usr/app/node_modules ./node_modules
COPY --from=construccion /usr/app/dist ./dist

EXPOSE 3000

USER node

CMD ["node", "dist/main.js"]
