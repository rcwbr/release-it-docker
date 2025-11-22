// Expected to be used with https://github.com/rcwbr/dockerfile-partials/blob/main/github-cache-bake.hcl
// For example, docker buildx bake -f github-cache-bake.hcl -f cwd://docker-bake.hcl https://github.com/rcwbr/dockerfile-partials.git#0.1.0

target "docker-client" {
  dockerfile = "docker-client/Dockerfile"
  contexts = {
    base_context = "docker-image://node:24.11.1"
    docker_image = "docker-image://docker:28.5.2-cli"
  }

  // Adapted from https://github.com/rcwbr/dockerfile-partials/blob/main/github-cache-bake.hcl
  cache-from = [
    // Always pull cache from main
    "type=registry,ref=${IMAGE_REF}-cache-docker-client:main",
    "type=registry,ref=${IMAGE_REF}-cache-docker-client:${VERSION}"
  ]
  cache-to = [
    "type=registry,rewrite-timestamp=true,mode=max,ref=${IMAGE_REF}-cache-docker-client:${VERSION}"
  ]
  output = []
}

target "default" {
  contexts = {
    base = "target:docker-client"
  }
}
