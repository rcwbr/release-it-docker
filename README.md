# release-it-docker

Docker image wrappers for [release-it](https://github.com/release-it/release-it)

## Usage

### Base image usage

The base image includes the release-it tool only. To use the image:

```
docker run -it ghcr.io/rcwbr/release-it-docker:0.6.0
```

The container entrypoint is the `release-it` CLI executable.

### Conventional-changelog image usage

The conventional-changelog image includes the [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog) [release-it plugin](https://github.com/release-it/conventional-changelog). To use the image:

```
docker run -it ghcr.io/rcwbr/release-it-docker-conventional-changelog:0.6.0
```

### File bumper image usage

The file-bumper image includes the [bumper release-it plugin](https://github.com/release-it/bumper). To use the image:

```
docker run -it ghcr.io/rcwbr/release-it-docker-file-bumper:0.6.0
```

If using the [default configuration](#default-configurations), it is configured to bump versions in a plaintext `VERSION` file in the repository root, as well as any references to the version in the `README.md` file. By default, it will replace the entire contents of the file with the version number.

> :warning: Unlike the other images, the bumper release-it default configuration sets `git.commit` true (as the version bump changes must be committed). This results in a commit for the release on the default branch.

#### File bumper tag-only config usage

To support avoiding the above-mentioned behavior including a commit to the default branch, the file-bumper image includes a configuration file that directs release-it to apply the push the commit only as the release tag, not to any branch. It sets `git.pushArgs` to `["tags"]` so as to push the tag only and not commit to the default branch. It also configures `git.getLatestTagFromAllRefs` true so that the latest tag may still be discovered despite not being associated with a commit on the default branch.

> :warning: This configuration outputs only to the `VERSION` file, not `README.md`, and replaces the entire file contents (vs. just the version pattern).

To use this configuration option, specify the config file path as `/.tag-only-release-it.json`. For example:

```bash
docker run -it ghcr.io/rcwbr/release-it-docker-file-bumper:0.6.0 --config /.tag-only-release-it.json
```

Or using the [release-it-gh-workflow](https://github.com/rcwbr/release-it-gh-workflow/tree/main):

```yaml
jobs:
  release-it-workflow:
    uses: rcwbr/release-it-gh-workflow/.github/workflows/release-it-workflow.yaml@0.1.0
    with:
      release-it-config: /.tag-only-release-it.json
```

### Default configurations

Both the base and conventional-changelog images provide a default [release-it configuration](https://github.com/release-it/release-it/blob/main/docs/configuration.md), located at `/.release-it.json`. To use this config, provide an arg to release-it:

```bash
docker run -it ghcr.io/rcwbr/release-it-docker:0.6.0 --config /.release-it.json
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

### CI/CD

This repo uses the [release-it-gh-workflow](https://github.com/rcwbr/release-it-gh-workflow), with the conventional-changelog image defined at any given ref, as its automation.

### Settings

The GitHub repo settings for this repo are defined as code using the [Probot settings GitHub App](https://probot.github.io/apps/settings/). Settings values are defined in the `.github/settings.yml` file. Enabling automation of settings via this file requires installing the app.

The settings applied are as recommended in the [release-it-gh-workflow usage](https://github.com/rcwbr/release-it-gh-workflow/blob/4dea4eaf328b60f92dab1b5bd2a63daefa85404b/README.md?plain=1#L58), including tag and branch protections, GitHub App and environment authentication, and required checks.
