# release-it-docker

Docker image wrappers for [release-it](https://github.com/release-it/release-it)

## Usage

### Base image usage

The base image includes the release-it tool only. To use the image:

```
docker run -it ghcr.io/rcwbr/release-it-docker:0.1.0
```

The container entrypoint is the `release-it` CLI executable.

### Conventional-changelog image usage

The conventional-changelog image includes the [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog) [release-it plugin](https://github.com/release-it/conventional-changelog). To use the image:

```
docker run -it ghcr.io/rcwbr/release-it-docker-conventional-changelog:0.1.0
```

### Default configurations

Both the base and conventional-changelog images provide a default [release-it configuration](https://github.com/release-it/release-it/blob/main/docs/configuration.md), located at `/.release-it.json`. To use this config, provide an arg to release-it:

```bash
docker run -it ghcr.io/rcwbr/release-it-docker:0.1.0 --config /.release-it.json
```

### GitHub workflow usage

The recommended approach to apply this image in a GitHub workflow is via the reusable [release-it-gh-workflow](https://github.com/rcwbr/release-it-gh-workflow/tree/main).

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

#### Build base image

Build the image:

```bash
cd base
REGISTRY=ghcr.io/rcwbr/ IMAGE_NAME=release-it-docker docker buildx bake --file github-cache-bake.hcl 'https://github.com/rcwbr/dockerfile-partials.git#main'
```

#### Build conventional-changelog image

```bash
cd conventional-changelog
REGISTRY=ghcr.io/rcwbr/ IMAGE_NAME=release-it-docker-conventional-changelog docker buildx bake --file github-cache-bake.hcl --file cwd://docker-bake.hcl 'https://github.com/rcwbr/dockerfile-partials.git#main'
```

### Settings

The GitHub repo settings for this repo are defined as code using the [Probot settings GitHub App](https://probot.github.io/apps/settings/). Settings values are defined in the `.github/settings.yml` file. Enabling automation of settings via this file requires installing the app.
