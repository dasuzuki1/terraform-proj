output "clone-urls" {
  /*   value = github_repository.tf_repo[*].name  */
  value = { for i in github_repository.tf_repo : i.name =>
    { ssh_clone_url  = i.ssh_clone_url,
      http_clone_url = i.http_clone_url,
  pages_url = try(i.pages[0].html_url, "no page") } }
  description = "Repository Names and URLS"
  sensitive   = false
}
