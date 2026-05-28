# ==============================================================================

# Evaluación Parcial 2 - Infraestructura como Código II (AUY1105)

# Orquestador Raíz de Infraestructura Modularizada

# ==============================================================================



# checkov:skip=CKV_TF_1: Ignorar uso de commit hash mientras se prueba en rama dev
# checkov:skip=CKV_TF_2: Ignorar uso de tag mientras se prueba en rama dev
module "redes" {
  source = "git::https://github.com/Solange-sm/terraform-aws-vpc-AUY1105-Grupo-4.git//vpc_module?ref=dev-sm"
  
  mi_ip_acceso = var.mi_ip_acceso
}

# checkov:skip=CKV_TF_1: Ignorar uso de commit hash mientras se prueba en rama dev
# checkov:skip=CKV_TF_2: Ignorar uso de tag mientras se prueba en rama dev
module "computo" {
  source = "git::https://github.com/Solange-sm/terraform-aws-EC2-AUY1105-Grupo-4.git?ref=dev-ma"
  
  subnet_id         = module.redes.public_subnet_ids[0]
  security_group_id = module.redes.security_group_id
  environment       = "AUY1105-appiac"
}
