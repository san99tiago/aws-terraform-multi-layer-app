provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      "Owner"  = "Santiago Garcia Arango",
      "Source" = "aws-terraform-multi-layer-app"
    }
  }
}
