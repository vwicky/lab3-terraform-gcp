variable "project_id" {
  description = "ID проєкту Google Cloud"
  type        = string
}

variable "region" {
  description = "Регіон для ресурсів"
  type        = string
  default     = "europe-west3" # Аналог eu-central-1 (Франкфурт)
}

variable "zone_a" {
  description = "Зона доступності A"
  type        = string
  default     = "europe-west3-a"
}

variable "zone_b" {
  description = "Зона доступності B"
  type        = string
  default     = "europe-west3-b"
}

variable "student_name" {
  description = "Прізвище та ім'я студента (для неймінгу)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR блок для VPC"
  type        = string
}

variable "subnet_a_cidr" {
  description = "CIDR блок для підмережі A"
  type        = string
}

variable "subnet_b_cidr" {
  description = "CIDR блок для підмережі B"
  type        = string
}

variable "web_port" {
  description = "Кастомний порт для вебсервера"
  type        = string
}