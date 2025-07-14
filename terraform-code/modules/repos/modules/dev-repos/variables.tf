variable "repo_max" {
  type        = number
  description = "Number of repos"
  default     = 2

  validation {
    condition     = var.repo_max <= 10
    error_message = "Do not deploy more than 10 repos"
  }
}

variable "env" {
  type        = string
  description = "Deployment env"

  validation {
    /* condition = var.env == "dev" || var.env == "prod"  */
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Env must be 'dev' or 'prod'"
  }
}

variable "repos" {
  /*   type        = set(string) */
  type        = map(map(string))
  description = "name of repos"

  validation {
    condition     = length(var.repos) < var.repo_max
    error_message = "please do not deploy more repos than allowed"
  }
}

variable "run_provisioners" {
  type    = bool
  default = false
}



/* variable "visibility" {
  type = string
  description = "visibility of repo"
} */
/* variable "varsource" {
  type        = string
  description = "Source used to define variables"
  default     = "variables.tf"


} */