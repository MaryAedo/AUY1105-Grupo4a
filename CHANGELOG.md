# Asegurarse de documentar todos los cambios realizados sobre el proyecto.

# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto se adhiere a las buenas prácticas de versionado y revisión de código mediante Pull Requests.

## [Unreleased] - En desarrollo

### Añadido / Modificado

**Pull Request #6 (Corrección de vulnerabilidades VPC - Checkov)**
- **Autor:** Solange
- **Revisor:** Mary (Comentado y Aprobado)
- **Cambios:**
  - Resolución de hallazgos de seguridad en `vpc.tf` detectados por el pipeline.
  - Excepción documentada para `CKV_AWS_130` justificando el uso de IPs públicas en las subredes para el acceso del laboratorio.
  - Corrección de `CKV2_AWS_12` asegurando y restringiendo todo el tráfico en el Security Group por defecto de la VPC.
  - Excepción documentada para `CKV2_AWS_11` (VPC Flow Logs), dado que no es un requerimiento de la arquitectura base solicitada.

**Pull Request #5 (Corrección de vulnerabilidades EC2 - Checkov)**
- **Autor:** Mary
- **Revisor:** Solange (Comentado y Aprobado)
- **Cambios:**
  - Resolución de hallazgos de seguridad en `ec2.tf` detectados por el pipeline.
  - Corrección de `CKV_AWS_382`: Restricción de tráfico de salida en el Security Group solo a los puertos estrictamente necesarios (HTTP/HTTPS).
  - Corrección de `CKV_AWS_126`: Habilitación de monitoreo detallado para la instancia EC2.
  - Corrección de `CKV_AWS_8`: Habilitación de encriptación segura para el volumen raíz de la instancia.
  - Corrección de `CKV_AWS_79`: Se forzó la versión 2 del servicio de metadatos (IMDSv2).
  - Excepciones documentadas para `CKV_AWS_135` (incompatibilidad de EBS con t2.micro) y `CKV2_AWS_41` (Rol IAM no requerido).

**Pull Request #4 (Automatización CI/CD y Documentación - Inicio Req. 3)**
- **Autor:** Solange
- **Revisor:** Mary (Comentado y Aprobado)
- **Cambios:**
  - Creación de un workflow de automatización utilizando GitHub Actions (`cicd.yml` en la ruta `.github/workflows/`).
  - Configuración del disparador (trigger) para que el workflow se active exclusivamente ante peticiones de cambio (*Pull Requests*) hacia la rama `main`.
  - Se actualizó el archivo `README.md` detallando los objetivos del repositorio, instrucciones básicas de uso y su propósito general.

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