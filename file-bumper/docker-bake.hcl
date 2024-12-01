// Expected to be used with https://github.com/rcwbr/dockerfile-partials/blob/main/github-cache-bake.hcl
// For example, docker buildx bake -f github-cache-bake.hcl -f cwd://docker-bake.hcl https://github.com/rcwbr/dockerfile-partials.git#0.1.0

target "default" {
  contexts = {
    base = (
      ("${GITHUB_REF_PROTECTED}" == "true" || "${GITHUB_REF_TYPE}" == "tag" )
      ? "docker-image://${REGISTRY}release-it-docker-conventional-changelog:${VERSION}"
      : "docker-image://${REGISTRY}release-it-docker-conventional-changelog:${VERSION}-${GITHUB_SHA}"
    )
  }
}
