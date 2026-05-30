# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto se adhiere a las buenas prácticas de versionado y revisión de código mediante Pull Requests bajo el estándar de Versionado Semántico (SemVer).

## [2.0.0] - 2026-05-30
### Added
- **Arquitectura Modular:** Orquestación centralizada invocando módulos remotos externos para la capa de Redes (`vpc_module`) y Cómputo (`ec2_module`).
- **Documentación:** Propuesta de `README.md` principal actualizado reflejando la nueva arquitectura orquestada.

### Changed
- **CI/CD:** Modificación del workflow (`cicd.yml`) para activarse temporalmente con el evento `push` hacia la rama `dev` para facilitar pruebas.
- **Infraestructura:** Refactorización de la asignación de la variable `environment` en `main.tf` para estandarizar la nomenclatura de recursos.
- **Configuración:** Formateo del archivo `versions.tf` para mayor coherencia visual y de código.

### Fixed
- **CI/CD (Checkov):** Ajuste en el pipeline (`--download-external-modules ext`) para que Checkov descargue y valide correctamente el contenido de los módulos externos de Terraform.
- **CI/CD (Terraform):** Corrección de compatibilidad en el pipeline limitando la versión requerida de Terraform.
- **Seguridad (Checkov):** Modificación del `main.tf` implementando skips (`CKV_TF_1`, `CKV_TF_2`) para obviar temporalmente las validaciones estrictas de tags/commits al probar en ramas de desarrollo.

### Removed
- **Infraestructura Monolítica:** Eliminación de los archivos locales `vpc.tf` y `ec2.tf`. La lógica fue migrada a sus respectivos repositorios modulares.

---

## [1.0.0] - Historial Evaluación Parcial 1
### Añadido / Modificado / Solucionado

**Pull Request #5 (Requerimiento 4: Definición de Políticas con OPA)**
- **Autoras:** Solange y Mary
- **Cambios:**
  - **Políticas (OPA):** Reincorporación oficial de los archivos de validación `terraform_instance_check.rego` y `terraform_name_check.rego` a la carpeta policies.
  - **Políticas (OPA):** Implementación de la **Regla 1** (Bloqueo de SSH público 0.0.0.0/0 y validación de región `us-east-1`).
  - **Políticas (OPA):** Implementación de la **Regla 2** (Restricción de tipo de instancia a `t2.micro` y validación de nomenclatura `AUY1105-appiac-ec2`).
  - **CI/CD:** Activación (descomentado) de los pasos de instalación y ejecución de Open Policy Agent en el pipeline `cicd.yml`.
  - **CI/CD:** Automatización de la generación de `tfplan.json` y su evaluación inmediata contra las políticas Rego.
  
**Pull Request #4 (Automatización CI/CD, Documentación, Seguridad y Limpieza)**
- **Autoras:** Solange y Mary
- **Cambios:**
  - **CI/CD:** Creación del workflow de GitHub Actions (`cicd.yml`) para validación automática en cada Pull Request hacia `main`.
  - **CI/CD & Seguridad:** Configuración de secretos de repositorio (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` y `MI_IP_ACCESO`) para despliegues seguros.
  - **CI/CD Fix:** Se comentaron temporalmente los pasos de ejecución de OPA en el workflow para permitir el éxito del pipeline mientras se prepara el Pull Request específico del Requerimiento 4.
  - **CI/CD Fix:** Inyección de la variable de entorno `TF_VAR_mi_ip_acceso` en el pipeline para resolver el error de validación de Terraform.
  - **Seguridad (Git):** Actualización del archivo `.gitignore` para excluir archivos de plan de Terraform (`tfplan`, `tfplan.json`) y reportes de Checkov, evitando la fuga de datos sensibles.
  - **Documentación:** Actualización completa del `README.md` con instrucciones del proyecto y mantenimiento del `CHANGELOG.md`.
  - **Refactor (Limpieza):** Eliminación de los archivos `.rego` de esta rama para mantener el orden por requerimientos (serán reintroducidos en su propio PR).
  - **Seguridad (EC2 - Checkov):** Resolución de múltiples hallazgos en `ec2.tf`:
    - Restricción de tráfico de salida (`CKV_AWS_382`).
    - Habilitación de monitoreo detallado (`CKV_AWS_126`).
    - Encriptación de volúmenes EBS (`CKV_AWS_8`).
    - Uso obligatorio de IMDSv2 (`CKV_AWS_79`).
  - **Seguridad (VPC - Checkov):** Resolución de hallazgos en `vpc.tf`:
    - Aseguramiento del Security Group por defecto (`CKV2_AWS_12`).
    - Configuración de retención de logs (`CKV_AWS_338`).
    - Excepciones documentadas para el entorno de AWS Academy (`CKV_AWS_130`, `CKV_AWS_158`).

**Pull Request #3 (Script de Instalación / Preparación)**
- **Autor:** Mary
- **Revisor:** Solange (Comentado y Aprobado)
- **Cambios:**
  - Se añadió el archivo `install.sh` para iniciar la configuración del entorno de pruebas.

**Pull Request #2 (Requerimiento 2: Código de Infraestructura)**
- **Autor:** Solange
- **Revisor:** Mary (Comentado y Aprobado)
- **Cambios:**
  - Creación de los archivos base de Terraform (`provider.tf`, `vpc.tf`, `ec2.tf`) para desplegar la infraestructura.
  - Configuración del proveedor de AWS utilizando la última versión mayor recomendada.
  - Implementación de una VPC (Virtual Private Cloud) con el bloque CIDR `10.1.0.0/16`.
  - Creación de subredes dentro de la VPC con máscara de red `/24`.
  - Configuración de Security Groups con reglas de entrada estrictas (solo se permite tráfico entrante por protocolo SSH).
  - Definición de una instancia EC2 utilizando la imagen Ubuntu 24.04 LTS y de tipo `t2.micro`.
  - Aplicación de nomenclatura estándar para todos los recursos: `<sigla-curso>-<nombre-aplicación>-<tipo-recurso>`.

**Pull Request #1 (Requerimiento 1: Repositorio de Código)**
- **Autor:** Mary
- **Revisor:** Solange (Comentado y Aprobado)
- **Cambios:**
  - Inicialización del repositorio base para almacenar el código de Terraform y la automatización.
  - Initial commit: Creación de la rama `main` y un `README.md` vacío.
  - Creación de la rama `dev` para el flujo de trabajo.
  - Creación del archivo `.gitignore` configurado para excluir archivos no deseados.
  - Creación del archivo `CHANGELOG.md` para documentar todos los cambios realizados sobre el proyecto.
