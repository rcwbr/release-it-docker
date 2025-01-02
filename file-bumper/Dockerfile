FROM base AS config

COPY .release-it.json /file-bumper.json
# Combine the release-it config file from base with the local file
RUN jq --slurp '.[0] * .[1]' /.release-it.json /file-bumper.json | tee /combined-release-it.json
COPY .tag-only-release-it.json /file-bumper-tag-only.json
# Combine the previously-combined config file with the tag-only local file
RUN jq --slurp '.[0] * .[1]' /combined-release-it.json /file-bumper-tag-only.json | tee /combined-release-it-tag-only.json


FROM base

RUN npm install -g @release-it/bumper
COPY --from=config /combined-release-it.json /.release-it.json
COPY --from=config /combined-release-it-tag-only.json /.tag-only-release-it.json
