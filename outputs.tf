# ==============================================================================
# Evaluación Parcial 2 - Infraestructura como Código II (AUY1105)
# Outputs del Orquestador Raíz
# ==============================================================================

output "vpc_id_desplegada" {
  description = "El ID de la VPC que fue creada por el módulo externo de redes"
  value       = module.redes.vpc_id
}

output "instancia_computo_id" {
  description = "El ID de la instancia EC2 creada por el módulo externo de cómputo"
  value       = module.computo.instance_id
}

output "url_servidor_web" {
  description = "La dirección IP pública de la instancia EC2 para acceder al Web Server"
  value       = module.computo.instance_ip
}