# release-it-docker

Docker image wrapper for [release-it](https://github.com/release-it/release-it)

## Usage

To use the image:

```
docker run -it ghcr.io/rcwbr/release-it-docker:0.1.0
```

The container entrypoint is the `release-it` CLI executable.

## Contributing

### Build

The recommended method to build the image is using [Docker Bake](https://docs.docker.com/reference/cli/docker/buildx/bake/) and the [Dockerfile partials GitHub cache bake file](https://github.com/rcwbr/dockerfile-partials/tree/main?tab=readme-ov-file#github-cache-bake-file). The steps to build the image using this method are as follows.

Prepare a [Docker builder with the docker-container driver](https://docs.docker.com/build/builders/drivers/docker-container/):

```bash
docker builder create --use --bootstrap --driver docker-container
```

Authenticate to GitHub container registry (see [instructions](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic)):

```bash
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
```

Build the image:

```bash
REGISTRY=ghcr.io/rcwbr/ IMAGE_NAME=release-it-docker docker buildx bake --file github-cache-bake.hcl 'https://github.com/rcwbr/dockerfile-partials.git#main'
```

### Repo configuration

Configuration for this repo is managed using [OpenTofu](https://opentofu.org/) with a [GCS state backend](https://opentofu.org/docs/language/settings/backends/gcs/). The configuration is managed in the `.infra` folder, and its deployment is automated through the GitHub Actions workflow.

Relevant resources to configure this management system are defined in the [gha-gcp-opentofu repo](https://github.com/rcwbr/gha-gcp-opentofu), and initial provisioning of the infra-as-code was performed per the [documentation there]([url](https://github.com/rcwbr/gha-gcp-opentofu/blob/1-define-initial-opentofu-module/README.md#initial-provisioning)).

#### Repo configuration workflow

TODO
