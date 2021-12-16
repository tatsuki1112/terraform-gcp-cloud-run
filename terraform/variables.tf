variable "project" {}

variable "credentials_file" {}

variable "region" {
  default = "asia-northeast1"
}

variable "zone" {
  default = "asia-northeast1-b"
}

variable "onprem"  {
  type    = list(string)
}

variable "db_user" {}

variable "db_password" {}

variable "db_host" {}
