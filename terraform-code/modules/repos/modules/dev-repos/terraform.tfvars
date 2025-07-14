repo_max = 3
env      = "dev"
#varsource  = "terraform.tfvars"
/* repos = ["dev", "prod"] */

repos = {
  infra = {
    lang     = "terraform",
    filename = "main.tf"
    pages    = true

  },
  backend = {
    lang     = "python",
    filename = "main.py"
    pages    = false
  }
}