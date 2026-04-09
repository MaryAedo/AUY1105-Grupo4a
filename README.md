# AUY1105-Grupo4
Integrantes:
Marysabel Aedo
Solange Milla

# Se debe detallar los objetivos del repositorio, instrucciones básicas de uso y propósito general. Además de la definición del código Terraform.
El proyecto consiste en implementar una infraestructura automatizada utilizando Terraform en el proveedor de AWS. 
El objetivo es establecer un pipeline de Integración Continua (CI) mediante GitHub Actions que integre herramientas de análisis de calidad, seguridad y cumplimiento normativo.

# Los recursos definidos en Terraform cumplen con los siguientes requisitos técnicos:
- VPC: Rango CIDR 10.1.0.0/16.
- Subredes: Segmentos con máscara /24 dentro de la VPC.
- Seguridad: Grupos de seguridad que permiten únicamente el protocolo SSH de entrada.
- Cómputo: Instancia EC2 con Ubuntu 24.04 LTS de tipo t2.micro.
- Nomenclatura: Todos los recursos utilizan el formato requerido para la evaluación sigla del curso- nombre de aplicación- tipo de recurso.

# Requisitos

- Terraform `1.14.8`
- Proveedor AWS `~> 6.40.0`
- Credenciales AWS configuradas localmente (por ejemplo, mediante `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY` o el archivo `~/.aws/credentials`)

## Proveedor

- AWS
- Región configurada en `provider.tf`: `us-east-1`

# Automatización y Políticas 
El workflow de GitHub Actions ejecuta tres etapas secuenciales: 
- Análisis Estático: Uso de tflint para asegurar mejores prácticas.
- Análisis de Seguridad: Uso de checkov para buscar configuraciones riesgosas.
- Validación: Comando terraform validate para confirmar la integridad del código.

# Políticas OPA ImplementadasSe incluyen reglas en lenguaje Rego para validar:
- Prohibición de SSH público: No se permite el acceso desde 0.0.0.0/0.
- Restricción de Tipo: Solo se permite la creación de instancias t2.micro.
- Requisitos de InstalaciónPara preparar el entorno local (Laboratorio TAITE 09), ejecute el script de ayuda proporcionado:Bashchmod +x install.sh
./install.sh

## Uso

1. Inicializar Terraform:
```bash
terraform init
```
2. Revisar el plan:
```bash
terraform plan
```
3. Aplicar la infraestructura:
```bash
terraform apply
```
4. Eliminar la infraestructura:
```bash
terraform destroy
```

## Recursos creados

- VPC `AUY1105-appiac-vpc`
- Internet Gateway `AUY1105-appiac-igw`
- Subred pública `AUY1105-appiac-subnet-publica-1`
- Subred pública `AUY1105-appiac-subnet-publica-2`
- Subred privada `AUY1105-appiac-subnet-privada-1`
- Subred privada `AUY1105-appiac-subnet-privada-2`
- Elastic IP `AUY1105-appiac-nat-eip`
- NAT Gateway `AUY1105-appiac-nat-gw`
- Tabla de ruteo pública `AUY1105-appiac-public-rtb`
- Tabla de ruteo privada `AUY1105-appiac-private-rtb`
- Asociaciones de tablas de ruteo públicas y privadas
- Grupo de seguridad `AUY1105-appiac-sg-ssh`
- Instancia EC2 `AUY1105-appiac-ec2`