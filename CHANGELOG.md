# Asegurarse de documentar todos los cambios realizados sobre el proyecto.

# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto se adhiere a las buenas prácticas de versionado y revisión de código mediante Pull Requests.

## [Unreleased] - En desarrollo

### Añadido / Modificado / Solucionado

**Pull Request #4 (Automatización CI/CD, Documentación, Seguridad y Políticas)**
- **Autoras:** Solange y Mary
- **Cambios:**
  - **CI/CD:** Creación de un workflow de automatización utilizando GitHub Actions (`cicd.yml` en la ruta `.github/workflows/`).
  - **CI/CD:** Configuración del disparador (trigger) para que el workflow se active exclusivamente ante peticiones de cambio (*Pull Requests*) hacia la rama `main`.
  - **CI/CD & Seguridad:** Configuración de 4 secretos de repositorio (GitHub Secrets) para despliegue seguro e inyección de variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` y `MI_IP_ACCESO`.
  - **Políticas (OPA):** Creación e integración de los archivos de validación `terraform_instance_check.rego` y `terraform_name_check.rego` para asegurar el cumplimiento de la infraestructura.
  - **Documentación:** Se actualizó el archivo `README.md` detallando los objetivos del repositorio, instrucciones básicas de uso y su propósito general.
  - **Documentación:** Actualización general del `CHANGELOG.md`.
  - **Seguridad (EC2):** Resolución de múltiples hallazgos de Checkov en `ec2.tf` para permitir la ejecución del pipeline: 
    - Restricción de tráfico de salida a HTTP/HTTPS (`CKV_AWS_382`).
    - Habilitación de monitoreo detallado (`CKV_AWS_126`).
    - Encriptación segura para el volumen raíz (`CKV_AWS_8`).
    - Uso forzado de IMDSv2 (`CKV_AWS_79`).
    - Inclusión del rol de instancia de LabAcademy (`CKV2_AWS_41`).
    - Excepción documentada para incompatibilidad de EBS con t2.micro (`CKV_AWS_135`).
  - **Seguridad (VPC):** Resolución de hallazgos de Checkov en `vpc.tf`:
    - Restricción de todo el tráfico en el Security Group por defecto (`CKV2_AWS_12`).
    - Configuración de retención de 365 días para Flow Logs (`CKV_AWS_338`).
    - Excepciones documentadas para uso de IPs públicas en laboratorio (`CKV_AWS_130`) y llaves KMS restringidas en AWS Academy (`CKV_AWS_158`).
  - **Pipeline Fix:** Corrección del error de compilación `terraform validate`, abstrayendo la IP de acceso SSH mediante variables y secretos.
  
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

---

### Pendiente de Implementar (Próximos pasos a registrar)

**Requerimiento 4: Definición de Políticas**
- Implementación de políticas de configuración utilizando Open Policy Agent (OPA).
  - Regla 1: Política de seguridad que impide el acceso SSH público (`0.0.0.0/0`) hacia la instancia EC2.
  - Regla 2: Política de restricción de recursos que solo permite la creación de instancias EC2 del tipo `t2.micro`.