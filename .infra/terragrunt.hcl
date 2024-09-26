generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  project       = "release-it-docker"
  region        = "us-west1"
  // Token comes from GOOGLE_OAUTH_ACCESS_TOKEN env var
}
EOF
}
