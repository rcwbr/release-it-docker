FROM node:22.9.0

# Install JQ for use in combining config files
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get install --allow-unauthenticated --no-install-recommends -y \
    jq \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g release-it

COPY .release-it.json /.release-it.json
ENTRYPOINT [ "release-it" ]
