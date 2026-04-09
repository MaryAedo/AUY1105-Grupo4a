package terraform.authz

import future.keywords.if

default allow = {
    "status": false,
    "reason": "La instancia no cumple con el nombre o el tipo t2.micro."
}

allow = result if {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    
    # Validamos ambos requisitos en una sola regla
    resource.change.after.tags.Name == "AUY1105-appiac-ec2"
    resource.change.after.instance_type == "t2.micro"

    result := {
        "status": true,
        "reason": "Instancia correcta: Nombre y Tipo (t2.micro) validados."
    }
}