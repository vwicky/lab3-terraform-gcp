terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Використовуємо стабільну 5-ту версію
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}