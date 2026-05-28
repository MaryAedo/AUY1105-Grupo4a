# ==============================================================================

# Evaluación Parcial 2 - Infraestructura como Código II (AUY1105)

# Orquestador Raíz de Infraestructura Modularizada

# ==============================================================================



# 1. Despliegue de la capa de red (Módulo Externo: Redes)

module "redes" {

 source = "git::https://github.com/Solange-sm/terraform-aws-vpc-AUY1105-Grupo-4.git//vpc_module?ref=dev-sm"

  

 # Parámetro inyectado mediante variables de entorno (GitHub Actions Secrets)

 mi_ip_acceso = var.mi_ip_acceso

}



# 2. Despliegue de la capa de aplicación (Módulo Externo: Cómputo)

module "computo" {

 source = "git::https://github.com/Solange-sm/terraform-aws-EC2-AUY1105-Grupo-4.git?ref=dev-ma"

  

 # Inyección dinámica de dependencias (Outputs del módulo de red hacia EC2)

 # Se extrae el primer elemento del bloque de subredes públicas

 subnet_id     = module.redes.public_subnet_ids[0]

 security_group_id = module.redes.security_group_id

  

 # Estandarización de nomenclatura de recursos

 environment    = "AUY1105-appiac"

}