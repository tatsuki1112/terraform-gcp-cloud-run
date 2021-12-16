terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = var.region
  template {
    spec {
      containers {
        image = "asia.gcr.io/canvas-primacy-335013/laravel-cloud-run"
        env {
          name  = "DB_HOST"
          value = "127.0.0.1"
        }
        env {
          name  = "DB_SOCKET"
          value = "/cloudsql/${google_sql_database_instance.master.connection_name}"
        }
        env {
          name  = "LOG_SOCKET"
          value = "stderr"
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1000"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.master.connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
}


resource "google_sql_database_instance" "master" {
  name             = "mysql-database-laravel"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      dynamic "authorized_networks" {
        for_each = var.onprem
        iterator = var.onprem
        content {
          name  = "onprem-${var.onprem.key}"
          value = var.onprem.value
        }
      }
    }
  }
}

resource "google_sql_database" "database" {
  name     = "laravel"
  instance = google_sql_database_instance.master.name
}

resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.master.name
  host     = var.db_host
  password = var.db_password
}
