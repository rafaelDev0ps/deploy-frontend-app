FROM node:14-alpine as builder

COPY package.json yarn.lock ./

RUN yarn install && mkdir /meu-site && mv ./node_modules ./meu-site

WORKDIR /meu-site

COPY . .

RUN yarn run build && yarn export




FROM nginx:alpine

COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /meu-site/out /usr/share/nginx/html

EXPOSE 3000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
