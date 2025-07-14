data "terraform_remote_state" "repos" {
  backend = "remote"
  config = {
    organization = "testing-2121235"
    workspaces = {
      name = "tf-repos"
    }
  }

}

locals {
  repos = { for k, v in data.terraform_remote_state.repos.outputs.clone_urls["prod"].clone_urls : k => v}
}

resource "github_repository" "this" {
  name        = "tf_info_page"
  description = "Repository info"
  visibility  = "public"
  auto_init   = true
  /*  pages  */
  //provisioner doesnt stop terraform apply even if it fails
  provisioner "local-exec" {
    when    = create
    command = var.run_provisioners ? "gh repo view ${self.name} --web" : "echo 'skip repo view'"
  }
}

data "github_user" "current" {
  username = ""
}

resource "time_static" "this" {}

resource "github_repository_file" "this" {
  repository = github_repository.this.name

  branch              = "main"
  file                = "index.tftpl"
  overwrite_on_create = true
  content = templatefile("${path.module}/template/index.tftpl",
    {
      avatar = data.github_user.current.avatar_url
      name   = data.github_user.current.name
      date   = time_static.this.year
      //repos  = var.repos
      repos = local.repos
  })


}

