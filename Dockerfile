
FROM node:19.2-alpine3.17 as dependencies
WORKDIR /app
COPY package.json ./
RUN npm install


FROM node:19.2-alpine3.17 as build
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM nginx:1.23.3 as prod
EXPOSE 80
COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=build /app/assets /usr/share/nginx/html/assets
RUN rm /etc/nginx/conf.d/default.conf
COPY --from=build /app/nginx/default.conf /etc/nginx/conf.d
CMD ["nginx","-g","daemon off;"]
