/* terraform {
  backend "local" {
    path = "../state/terraform.tfstate"
  }
} */

/* terraform {
  cloud {

    organization = "testing-2121235"
    workspaces {
      name = "dev"
    }
  }
} */
terraform {
  cloud {

    organization = "testing-2121235"
    workspaces {
      name = "tf-repos"
      
    }
  }
}
