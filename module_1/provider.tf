provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      "Terraform" = "True"
      "course" = "aws-sa-associate"
    }
  }
}