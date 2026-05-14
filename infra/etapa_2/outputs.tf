# URL del repositorio ECR para el Frontend
output "frontend_ecr_url" {
  value       = aws_ecr_repository.frontend.repository_url
  description = "URL del repositorio ECR para la imagen del Frontend"
}

# URL del repositorio ECR para el Backend de Despachos
output "backend_despachos_ecr_url" {
  value       = aws_ecr_repository.back_despachos.repository_url
  description = "URL del repositorio ECR para la imagen de Despachos"
}

# URL del repositorio ECR para el Backend de Ventas
output "backend_ventas_ecr_url" {
  value       = aws_ecr_repository.back_ventas.repository_url
  description = "URL del repositorio ECR para la imagen de Ventas"
}

# IP Pública de la base de datos (para entrar por SSH o Workbench si es necesario)
output "mysql_public_ip" {
  value       = aws_instance.db.public_ip
  description = "IP pública de la instancia EC2 con MySQL"
}

# IP Privada de la base de datos (la que usan los backends para conectarse)
output "mysql_private_ip" {
  value       = aws_instance.db.private_ip
  description = "IP privada de la base de datos dentro de la VPC"
}

# Nombre del Cluster de ECS (útil para el script de despliegue)
output "ecs_cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "Nombre del cluster ECS donde corren los servicios"
}