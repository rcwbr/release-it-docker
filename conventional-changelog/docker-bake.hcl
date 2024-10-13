// Expected to be used with https://github.com/rcwbr/dockerfile-partials/blob/main/github-cache-bake.hcl
// For example, docker buildx bake -f github-cache-bake.hcl -f cwd://docker-bake.hcl https://github.com/rcwbr/dockerfile-partials.git#main

target "default" {
  contexts = {
    base = (
      "${GITHUB_REF_PROTECTED}" == "true"
      ? "docker-image://${REGISTRY}release-it-docker:${VERSION}"
      : "docker-image://${REGISTRY}release-it-docker:${VERSION}-${GITHUB_SHA}"
    )
  }
}
