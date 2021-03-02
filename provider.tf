provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

