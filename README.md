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

Configuration for this repo is managed using [OpenTofu](https://opentofu.org/) with a [GCS state backend](https://opentofu.org/docs/language/settings/backends/gcs/). The configuration is managed in the `.iac` folder, and its deployment is automated through the GitHub Actions workflow.

#### Repo configuration provisioning

Initial provisioning of resources to enable infrastructue-as-code automation requires the following steps:

1. Prepare a GCS project
1. Retrieve a GCP access token
  1. `export GCLOUD_TOKEN=$(docker run --rm -it gcr.io/google.com/cloudsdktool/google-cloud-cli -c 'gcloud auth application-default login && gcloud auth application-default print-access-token')`
1. Plan and apply the provisioning resources from the IaC config:
   1. `docker run --rm -e GCLOUD_TOKEN -v $(pwd)/.infra:/infra -w /infra devopsinfra/docker-terragrunt:ot-1.8.2-tg-0.67.10 -target`
1. Trigger a `main` branch workflow to apply the remaining resources via GitHub Actions

#### Repo configuration workflow

TODO
