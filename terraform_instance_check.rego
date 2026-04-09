package terraform.authz

import future.keywords.if

default allow = {
    "status": false,
    "reason": "Región incorrecta o SSH detectado como público (0.0.0.0/0)."
}

# Validación de Región y Seguridad
allow = result if {
    # 1. Validar Región en el provider
    provider := input.configuration.provider_config[_]
    provider.name == "aws"
    provider.expressions.region.constant_value == "us-east-1"

    # 2. Validar que no exista SSH abierto al mundo
    not any_public_ssh

    result := {
        "status": true,
        "reason": "Región us-east-1 y Seguridad SSH validadas correctamente."
    }
}

# Regla auxiliar para detectar SSH público
any_public_ssh if {
    resource := input.resource_changes[_]
    resource.type == "aws_security_group"
    ingress := resource.change.after.ingress[_]
    ingress.from_port == 22
    ingress.cidr_blocks[_] == "0.0.0.0/0"
}