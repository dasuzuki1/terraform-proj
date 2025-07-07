resource "random_id" "random" {
  byte_length = 2
  count       = 2
}
resource "github_repository" "tf_repo" {
  count       = 2
  name        = "tf-repo-${random_id.random[count.index].dec}"
  description = "Code for MTC"
  auto_init   = true
  visibility  = "private"
}

resource "github_repository_file" "readme" {
  count               = 2
  repository          = github_repository.tf_repo[count.index].name
  branch              = "main"
  file                = "README.md"
  content             = "# This repo is for infra devs"
  overwrite_on_create = true

}

resource "github_repository_file" "index" {

  count               = 2
  repository          = github_repository.tf_repo[count.index].name
  branch              = "main"
  file                = "index.html"
  content             = "Hello Terraform!"
  overwrite_on_create = true


}

output "repo-names" {
  value = github_repository.tf_repo[*].name
  description = "Repository Names"
  sensitive = true
}