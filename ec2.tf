resource "aws_security_group" "ssh_access" {
  name        = "AUY1105-appiac-SSH"
  description = "Permitir acceso SSH desde mi IPv4"
  vpc_id      = aws_vpc.mi_vpc.id

  ingress {
    description = "SSH desde mi IPv4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["152.230.70.226"] # Permitir desde mi dirección IPv4
  }

  # Corrección Checkov CKV_AWS_382: Se limitó la salida a HTTPS (443) y HTTP (80)
  egress {
    description = "Permitir trafico de salida HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Permitir trafico de salida HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AUY1105-appiac-ssh"
  }
}

# checkov:skip=CKV_AWS_135: El tipo de instancia t2.micro no soporta EBS optimization en AWS.
resource "aws_instance" "AUY1105-appiac-ec2" {
  ami                    = "ami-0ec10929233384c7f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_publica_1.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  # Corrección Checkov CKV_AWS_126: Habilitar monitoreo detallado
  monitoring = true

  # Corrección Checkov CKV_AWS_8: Encriptar el volumen raíz (EBS)
  root_block_device {
    encrypted = true
  }

  # Corrección Checkov CKV_AWS_79: Forzar el uso de IMDSv2 (Metadatos seguros)
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "AUY1105-appiac-ec2"
  }
}