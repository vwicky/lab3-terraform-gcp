# 1. Створення ізольованого середовища (VPC)
resource "google_compute_network" "vpc" {
  name                    = "vpc-lab3-${var.student_name}-06"
  auto_create_subnetworks = false # Вимикаємо автостворення, щоб керувати власноруч
}

# 2. Створення підмереж (Subnet A та Subnet B)
resource "google_compute_subnetwork" "subnet_a" {
  name          = "subnet-a-${var.student_name}-06"
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_a_cidr
  region        = var.region
}

resource "google_compute_subnetwork" "subnet_b" {
  name          = "subnet-b-${var.student_name}-06"
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_b_cidr
  region        = var.region
}

# 3. Налаштування безпеки (Firewall / Security Group)
resource "google_compute_firewall" "allow_ssh_web" {
  name    = "fw-allow-ssh-web-06"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", var.web_port] # Відкриваємо SSH та порт 8080
  }

  source_ranges = ["0.0.0.0/0"] # Доступ з будь-якого IP
  target_tags   = ["web-server"]
}

# 4. Динамічний пошук AMI (Образу для Ubuntu 24.04 LTS)
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}

# 5. Розгортання інстансу ВМ
resource "google_compute_instance" "web_vm" {
  name         = "vm-${var.student_name}-06"
  machine_type = "e2-micro"
  zone         = var.zone_a # Розміщуємо в зоні A

  tags = ["web-server"] # Зв'язок з Firewall

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link # Використовуємо знайдений образ
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_a.id
    access_config {
      # Наявність цього порожнього блоку виділяє публічну IP-адресу
    }
  }

  # Тегування ресурсів (Labels у GCP)
  labels = {
    owner   = "zozula-viktor"
    variant = "06"
    env     = "dev"
  }

  # 6. Передача скрипта ініціалізації через templatefile
  # Скрипт ми створимо на наступному кроці, але підключаємо його вже тут
  metadata_startup_script = templatefile("${path.module}/bootstrap.sh.tpl", {
    web_port = var.web_port
  })
}