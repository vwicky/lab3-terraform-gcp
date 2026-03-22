output "vm_name" {
  description = "Ім'я віртуальної машини"
  value       = google_compute_instance.web_vm.name
}

output "vm_ip_address" {
  description = "Публічна IP-адреса ВМ"
  value       = google_compute_instance.web_vm.network_interface[0].access_config[0].nat_ip
}

output "image_used" {
  description = "Ім'я використаного образу ОС"
  value       = data.google_compute_image.ubuntu.name
}

output "website_url" {
  description = "URL для доступу до налаштованого сервісу"
  value       = "http://${google_compute_instance.web_vm.network_interface[0].access_config[0].nat_ip}:${var.web_port}"
}