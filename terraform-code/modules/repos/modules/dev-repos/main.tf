resource "random_id" "random" {
  byte_length = 2
  count       = var.repo_max

} /*not being used currently */


resource "github_repository" "tf_repo" {

  for_each = var.repos
  name     = "tf-${each.key}-${var.env}"
  /* count       = var.repo_count 
  name        = "tf-repo-${random_id.random[count.index].dec}" */
  description = "${each.value.lang} Code for MTC"
  auto_init   = true
  visibility  = var.env == "prod" ? "public" : "private"
  provisioner "local-exec" {
    command = var.run_provisioners ? "gh repo view ${self.name} --web" : "echo 'skip clone'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.name}"
  }

  /*  dynamic "pages" {
    for_each = each.value.pages ? 1 : []
    content {}
    source {
      branch = "main"
      path = "/"
    }
    }
  } */
}

resource "terraform_data" "repo-clone" {
  for_each   = var.repos
  depends_on = [github_repository_file.main, github_repository_file.readme]
  provisioner "local-exec" {
    command = var.run_provisioners ? "gh repo clone ${github_repository.tf_repo[each.key].name}" : "echo 'skip clone'"
  }

}

resource "github_repository_file" "readme" {
  for_each   = var.repos
  repository = github_repository.tf_repo[each.key].name
  /* count               = var.repo_count
  repository          = github_repository.tf_repo[count.index].name */
  branch = "main"
  file   = "README.md"
  /*   content             = <<-EOT
                        # This is a  ${var.env} ${each.value.lang} repo is for ${each.key} devs. 
                        The infra was last modified by ${data.github_user.current.name}
                        EOT */
  content = templatefile("${path.module}/template/readme.tftpl",
    {
      env        = var.env,
      lang       = each.value.lang,
      repo       = each.key,
      authorname = data.github_user.current.name
  })
  overwrite_on_create = true
  /*   lifecycle {
    ignore_changes = [
      content,
    ]
  } */
}

resource "github_repository_file" "main" {

  for_each   = var.repos
  repository = github_repository.tf_repo[each.key].name
  /*   count               = var.repo_count
  repository          = github_repository.tf_repo[count.index].name */
  file                = each.value.filename
  content             = "//Hello ${each.value.lang}!"
  overwrite_on_create = true
  lifecycle {
    ignore_changes = [
      content,
    ]
  }

}

/* output "clone-urls" {
     //value = github_repository.tf_repo[*].name  
  value       = { for i in github_repository.tf_repo : i.name => [i.ssh_clone_url, i.http_clone_url] }
  description = "Repository Names and URLS"
  sensitive   = false
} */

/* output "varsource" {
  value       = var.varsource
  description = "Source being used to source variable definition."
} */

moved {
  from = github_repository_file.index
  to   = github_repository_file.main
}
