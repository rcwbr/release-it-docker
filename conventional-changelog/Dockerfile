FROM base AS config

COPY .release-it.json /conventional-changelog-release-it.json
# Combine the release-it config file from base with the local file
RUN jq --slurp '.[0] * .[1]' /.release-it.json /conventional-changelog-release-it.json | tee /combined-release-it.json


FROM base

RUN npm install -g @release-it/conventional-changelog
COPY --from=config /combined-release-it.json /.release-it.json
