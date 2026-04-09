package terraform.authz

import future.keywords.if

default allow = {
    "status": false,
    "reason": "La instancia no cumple con el nombre obligatorio o no es tipo t2.micro."
}

allow = result if {
    some i
    resource := input.resource_changes[i]
    resource.type == "aws_instance"
    
    # Validación 1: Nombre (Nomenclatura examen)
    resource.change.after.tags.Name == "AUY1105-appiac-ec2"
    
    # Validación 2: Tipo de instancia (Requisito examen)
    resource.change.after.instance_type == "t2.micro"

    result := {
        "status": true,
        "reason": "Nombre y Tipo de instancia (t2.micro) correctos."
    }
}