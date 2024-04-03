terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-16"
    prefix = "terraform/state"
  }
}