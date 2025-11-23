# release-it-docker

Docker image wrappers for [release-it](https://github.com/release-it/release-it)

## Usage

### Base image usage

To specify release-it configuration for the base image, apply this to the repo `.release-it.json`:

```json
{
  "extends": [
    "github:rcwbr/release-it-docker/base#0.7.1"
  ]
}
```

The base image includes the release-it tool only. To use the image:

```bash
docker run -it ghcr.io/rcwbr/release-it-docker:0.7.1
```

The container entrypoint is the `release-it` CLI executable.

### Conventional-changelog image usage

The conventional-changelog image includes the [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog) [release-it plugin](https://github.com/release-it/conventional-changelog).

To specify release-it configuration for conventional-changelog, apply this to the repo `.release-it.json`:

```json
{
  "extends": [
    "github:rcwbr/release-it-docker/conventional-changelog#0.7.1"
  ]
}
```

To use the image:

```bash
docker run -it ghcr.io/rcwbr/release-it-docker-conventional-changelog:0.7.1
```

### File bumper image usage

The file-bumper image includes the [bumper release-it plugin](https://github.com/release-it/bumper).

To specify release-it configuration for file-bumper, apply this to the repo `.release-it.json`:

```json
{
  "extends": [
    "github:rcwbr/release-it-docker/file-bumper#0.7.1"
  ]
}
```

To use the image:

```bash
docker run -it -v $(pwd):$(pwd) -w $(pwd) ghcr.io/rcwbr/release-it-docker-file-bumper:0.7.1
```

If using the [default configuration](#default-configurations), it is configured to bump versions in a plaintext `VERSION` file in the repository root, as well as any references to the version in the `README.md` file. By default, it will replace the entire contents of the file with the version number.

> :warning: Unlike the other images, the bumper release-it default configuration sets `git.commit` true (as the version bump changes must be committed). This results in a commit for the release on the default branch.

#### File bumper tag-only config usage

To support avoiding the above-mentioned behavior including a commit to the default branch, the file-bumper image includes a configuration file that directs release-it to apply the push the commit only as the release tag, not to any branch. It sets `git.pushArgs` to `["tags"]` so as to push the tag only and not commit to the default branch. It also configures `git.getLatestTagFromAllRefs` true so that the latest tag may still be discovered despite not being associated with a commit on the default branch.

> :warning: This configuration outputs only to the `VERSION` file, not `README.md`, and replaces the entire file contents (vs. just the version pattern).

To use this configuration option, apply this to the repo `.release-it.json`:

```json
{
  "extends": [
    "github:rcwbr/release-it-docker/file-bumper/tag-only#0.7.1"
  ]
}
```

### Custom hooks usage

To support use of any tool in [release-it custom hooks](https://github.com/release-it/release-it?tab=readme-ov-file#hooks), each image contains the Docker CLI. By mounting the Docker socket to the release-it-docker container, hooks may themselves launch Docker containers. For example:

```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):$(pwd) -w $(pwd) ghcr.io/rcwbr/release-it-docker-file-bumper:0.7.1
```

with configuration:

```json
{
  "extends": [
    "github:rcwbr/release-it-docker/file-bumper#0.7.1"
  ],
  "hooks": {
    "after:bump": [
      "docker run --rm -v $(pwd):$(pwd) -w $(pwd) ghcr.io/astral-sh/uv:0.9.11-python3.12-trixie-slim uv version ${version}"
    ]
  }
}
```

allows release-it to delegate the version bump for a [uv](https://github.com/astral-sh/uv) Python project to the `uv` tool and ensure appriopriate lockfile contents.

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
