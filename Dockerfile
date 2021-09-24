FROM node:14-alpine as builder

ARG PORT

COPY package.json yarn.lock ./

RUN yarn install && mkdir /meu-site && mv ./node_modules ./meu-site

WORKDIR /meu-site

COPY . .

RUN yarn run build && yarn export


FROM nginx:alpine

COPY ./.nginx/nginx.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /meu-site/out /usr/share/nginx/html

EXPOSE 80

CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
