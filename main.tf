# ==============================================================================
# Evaluación Parcial 2 - Infraestructura como Código II (AUY1105)
# Orquestador Raíz de Infraestructura Modularizada
# ==============================================================================

module "redes" {
  # Apuntando a la versión semántica oficial exigida por la rúbrica
  source = "git::https://github.com/Solange-sm/terraform-aws-vpc-AUY1105-Grupo-4.git//vpc_module?ref=v1.0.0"
  
  mi_ip_acceso = var.mi_ip_acceso
}

module "computo" {
  # Apuntando a la versión semántica oficial exigida por la rúbrica
  source = "git::https://github.com/Solange-sm/terraform-aws-EC2-AUY1105-Grupo-4.git?ref=v1.0.0"
  
  subnet_id         = module.redes.public_subnet_ids[0]
  security_group_id = module.redes.security_group_id
  environment       = "AUY1105-appiac"
}
