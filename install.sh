#!/bin/bash



# Función para manejar errores

handle_error() {

  echo "Error: Falló la instalación en el paso $1."

  exit 1

}



# Definir versiones y URLs

TERRAFORM_DOCS_VERSION="v0.19.0"

TERRAFORM_DOCS_URL="https://terraform-docs.io/dl/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-$(uname -s | tr '[:upper:]' '[:lower:]')-amd64.tar.gz"

OPA_URL="https://openpolicyagent.org/downloads/latest/opa_linux_amd64"



echo "Iniciando instalación de herramientas para Evaluación Parcial 1..."



# 1. Instalar pip para Python 3 (Requerido para Checkov)

echo "Instalando pip para Python 3..."

sudo yum install -y python3-pip || handle_error "1 (sudo yum install -y python3-pip)"



# 2. Instalar Checkov usando pip

echo "Instalando Checkov..."

pip3 install checkov || handle_error "2 (pip3 install checkov)"



# 3. Instalar yum-utils y repositorio de HashiCorp

echo "Instalando yum-utils..."

sudo yum install -y yum-utils || handle_error "3.1 (sudo yum install -y yum-utils)"

echo "Configurando repositorio de HashiCorp..."
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo || handle_error "3.2 (sudo yum-config-manager --add-repo)"



# 4. Instalar Terraform (Requerimiento 3.3: Validación terraform)

echo "Instalando Terraform..."

sudo yum -y install terraform || handle_error "4 (sudo yum install terraform)"



# 5. Instalar TFLint (Requerimiento 3.1: Análisis estático)

echo "Instalando TFLint..."

curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash || handle_error "5 (Instalación de TFLint)"



# 6. Instalar OPA (Requerimiento 4: Definición de políticas)

echo "Instalando OPA..."

curl -L -o opa "$OPA_URL" || handle_error "6.1 (descarga de OPA)"

chmod +x opa || handle_error "6.2 (asignar permisos a OPA)"

sudo mv opa /usr/local/bin/ || handle_error "6.3 (mover OPA a /usr/local/bin)"



# 7. Instalar Terraform-Docs (Para soporte de documentación IL1.3)

echo "Instalando Terraform-Docs..."

curl -sSLo terraform-docs.tar.gz "$TERRAFORM_DOCS_URL" || handle_error "7.1 (descarga de terraform-docs)"

tar -xzf terraform-docs.tar.gz || handle_error "7.2 (extracción de terraform-docs)"

chmod +x terraform-docs || handle_error "7.3 (asignar permisos a terraform-docs)"

sudo mv terraform-docs /usr/local/bin/ || handle_error "7.4 (mover terraform-docs a /usr/local/bin)"

rm -rf terraform-docs.tar.gz README.md LICENSE || handle_error "7.5 (limpieza de archivos temporales)"



echo "Instalación completada con éxito."

echo "Herramientas listas: terraform, tflint, checkov, opa, terraform-docs."