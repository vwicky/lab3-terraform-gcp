terraform {
  backend "gcs" {
    bucket = "tf-state-lab3-zozula-viktor-06"
    prefix = "env/dev/var-06" # GCP автоматично додасть .tfstate до файлу в бакеті
  }
}