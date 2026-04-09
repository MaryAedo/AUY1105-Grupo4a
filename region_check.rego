package terraform.authz

import future.keywords.if

default allow = {
    "status": false,
    "reason": "Error: Región no es us-east-1 o existe acceso SSH abierto (0.0.0.0/0)."
}

allow = result if {
    # Validación 1: Región us-east-1
    provider := input.configuration.provider_config[_]
    provider.name == "aws"
    provider.expressions.region.constant_value == "us-east-1"

    # Validación 2: Que NO exista SSH público
    not any_public_ssh

    result := {
        "status": true,
        "reason": "Región correcta y SSH restringido exitosamente."
    }
}

# Regla de apoyo para detectar el SSH abierto
any_public_ssh if {
    resource := input.resource_changes[_]
    resource.type == "aws_security_group"
    ingress := resource.change.after.ingress[_]
    ingress.from_port == 22
    ingress.cidr_blocks[_] == "0.0.0.0/0"
}