FROM node:22.9.0

RUN npm install -g release-it

COPY .release-it.json /.release-it.json
ENTRYPOINT [ "release-it" ]
