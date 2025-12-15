provider "aws" {
  region     = "us-east-1"
  profile = "piyush_terraform_user"
  default_tags {
    tags = {
      practice = "terraform"
    }
  }
}
