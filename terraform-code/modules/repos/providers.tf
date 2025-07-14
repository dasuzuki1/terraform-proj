terraform {
  required_providers {
    github = {
      source = "integrations/github"
      #version = "~> 6.0"
    }
  }
}

# configure the github provide
provider "github" {
  owner = "dasuzuki1"
}