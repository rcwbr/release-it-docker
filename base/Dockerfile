FROM base

RUN npm install --global release-it@19.0.6

COPY .release-it.json /.release-it.json
ENTRYPOINT [ "release-it" ]
