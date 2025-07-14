locals {
  repos = {
    infra = {
      lang     = "terraform",
      filename = "main.tf"
      pages    = true

    },
   /*  backend = {
      lang     = "python",
      filename = "main.py"
      pages    = false
    } */
  }
  environments = toset(["dev", "prod"])
}

