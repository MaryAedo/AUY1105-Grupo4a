# AUY1105-Grupo4

Repositorio principal de la Evaluación Parcial 2 de la asignatura **Infraestructura como Código II (AUY1105)**. Este repositorio actúa como orquestador de una infraestructura modular en AWS construida con Terraform, reutilizando módulos externos de redes y cómputo, y manteniendo la automatización de validación, seguridad y políticas desarrollada en la Evaluación Parcial 1.

## Integrantes

- Marysabel Aedo
- Solange Milla

## Objetivo del repositorio

El objetivo de este repositorio es centralizar la definición de alto nivel de la infraestructura y coordinar el consumo de los módulos desacoplados creados para la Evaluación Parcial.  
Además, este repositorio conserva y adapta el pipeline de integración continua de la Evaluación Parcial 1 para ejecutar validaciones de calidad, seguridad, validación Terraform y evaluación de políticas OPA sobre la infraestructura completa.

## Propósito general

Este proyecto implementa una arquitectura modular en AWS mediante Terraform. La infraestructura se divide en dos módulos reutilizables:

- **Módulo de redes**: encargado de la creación de VPC, subredes, tablas de ruteo, NAT Gateway y security groups.
- **Módulo de cómputo**: encargado de la creación y configuración de la instancia EC2.

El repositorio principal consume ambos módulos mediante referencias remotas desde GitHub y actúa como punto de integración para el despliegue y validación de toda la solución.

## Arquitectura desplegada

La infraestructura orquestada por este repositorio incluye:

- VPC con CIDR `10.1.0.0/16`.
- Dos subredes públicas y dos subredes privadas con máscara `/24`.
- Internet Gateway y NAT Gateway.
- Tablas de ruteo públicas y privadas con sus asociaciones.
- Security Group para la instancia EC2.
- Instancia EC2 Ubuntu 24.04 LTS de tipo `t2.micro`.

## Estructura del proyecto

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── README.md
├── CHANGELOG.md
├── .gitignore
├── policies/
│   ├── region_check.rego
│   └── name_check.rego
└── .github/
    └── workflows/
        └── pipeline.yml
```

## Módulos utilizados

Este repositorio consume los siguientes módulos externos:

- **Módulo de redes**  
  `git::https://github.com/Solange-sm/terraform-aws-vpc-AUY1105-Grupo-4.git//vpc_module?ref=dev-sm` 

- **Módulo de cómputo**  
  `git::https://github.com/Solange-sm/terraform-aws-EC2-AUY1105-Grupo-4.git?ref=dev-ma`

## Requisitos

Para utilizar este proyecto se requiere:

- Terraform compatible con la rama `1.x`.
- Provider AWS configurado de forma consistente entre el repositorio principal y los módulos.
- Credenciales AWS válidas.
- Acceso a GitHub para resolver módulos remotos.
- Variables y secretos correctamente definidos para la ejecución local o en GitHub Actions.

## Variables principales

Las variables más importantes utilizadas por este repositorio son:

- Variable: `mi_ip_acceso` Es la dirección IP pública autorizada para acceso SSH en formato CIDR, por ejemplo `181.23.45.67/32`
- Varialbe: `environment` Prefijo utilizado para construir los nombres de los recursos. En este proyecto se utiliza `AUY1105-appiac`.

## Instrucciones básicas de uso

### 1. Clonar el repositorio

```bash
git clone https://github.com/<usuario>/AUY1105-Grupo4.git
cd AUY1105-Grupo4
```

### 2. Configurar credenciales AWS

Se deben exportar las credenciales de AWS o utilizar un perfil local. Ejemplo:

```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
export AWS_REGION="us-east-1"
```

### 3. Definir la IP de acceso SSH

Se debe definir la variable `mi_ip_acceso` con la IP pública del equipo en formato `/32`.

Ejemplo:

```bash
export TF_VAR_mi_ip_acceso="181.23.45.67/32"
```

### 4. Inicializar Terraform

```bash
terraform init
```

### 5. Validar la configuración

```bash
terraform validate
```

### 6. Revisar el plan de ejecución

```bash
terraform plan
```

### 7. Aplicar la infraestructura

```bash
terraform apply
```

### 8. Eliminar la infraestructura

```bash
terraform destroy
```

## Automatización CI

El workflow de GitHub Actions se ejecuta automáticamente al realizar un `push` a la rama de desarrollo (`dev`) y sobre los `pull requests` hacia la rama principal (`main`), realizando las siguientes etapas:

1. **Análisis estático** con `tflint`.
2. **Análisis de seguridad** con `checkov`.
3. **Validación Terraform** con `terraform validate`.
4. **Generación de plan Terraform**.
5. **Evaluación de políticas OPA** sobre el plan en formato JSON.

## Políticas OPA implementadas

Este repositorio incluye políticas en lenguaje Rego para validar:

- Que la región utilizada sea `us-east-1`.
- Que no exista acceso SSH público desde `0.0.0.0/0`.
- Que la instancia EC2 tenga el nombre esperado `AUY1105-appiac-ec2`.
- Que la instancia EC2 sea de tipo `t2.micro`.

## Seguridad y validaciones

La solución considera controles de seguridad y calidad heredados de la Evaluación Parcial 1 y adaptados al escenario modular de la Evaluación Parcial 2.  
Entre ellos se incluyen validaciones con TFLint, Checkov, Terraform Validate y políticas OPA integradas en el pipeline de CI.

## Convención de nombres

Los recursos siguen la nomenclatura definida por la evaluación:

`<sigla-curso>-<nombre-aplicación>-<tipo-recurso>`

Ejemplo:

- `AUY1105-appiac-vpc`
- `AUY1105-appiac-ec2`
- `AUY1105-appiac-sg`

## Recursos creados

### Recursos de red

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
- Security Group `AUY1105-appiac-sg`

### Recursos de cómputo

- Instancia EC2 `AUY1105-appiac-ec2`

## Salidas esperadas

El repositorio principal consolida outputs provenientes de los módulos, permitiendo consultar identificadores relevantes de la infraestructura, como VPC, subredes, instancia EC2 e IP pública o URL de acceso según corresponda.

## Versionado

Este proyecto sigue buenas prácticas de versionado semántico para facilitar la trazabilidad de cambios y la evolución controlada del código.  
Los cambios relevantes de cada versión deben quedar registrados en `CHANGELOG.md`, incluyendo fecha, versión y tipo de cambio: `Added`, `Changed`, `Fixed` o `Removed`.

## Consideraciones

- Este repositorio no define toda la infraestructura directamente; su función principal es **orquestar módulos desacoplados**.
- Los módulos deben mantenerse versionados, documentados y con ejemplos funcionales según la pauta de la evaluación.
- Para una ejecución correcta del pipeline, las ramas referenciadas en los módulos deben contener los cambios actualizados que consume el repositorio principal.

## Estado de la evaluación

Este repositorio responde a los objetivos de la Evaluación Parcial 2 al actuar como controlador central de la infraestructura modular, conservar la automatización de la Evaluación Parcial 1 y facilitar la integración coherente de los módulos de redes y cómputo.
