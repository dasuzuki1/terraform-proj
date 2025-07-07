resource "github_repository" "tf_repo" {
  name        = "tf-repo"
  description = "Code for MTC"
  auto_init   = true
  visibility  = "private"
}

resource "github_repository_file" "readme" {
  repository          = github_repository.tf_repo.name
  branch              = "main"
  file                = "README.md"
  content             = "# This repo is for infra devs"
  overwrite_on_create = true

}

resource "github_repository_file" "index" {
  repository          = github_repository.tf_repo.name
  branch              = "main"
  file                = "index.html"
  content             = "Hello Terraform!"
  overwrite_on_create = true


}