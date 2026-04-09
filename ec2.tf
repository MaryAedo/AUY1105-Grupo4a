resource "aws_security_group" "ssh_access" {
  name        = "AUY1105-appiac-ssh-sg"
  description = "Permitir acceso SSH desde mi IPv4"
  vpc_id      = aws_vpc.mi_vpc.id

  ingress {
    description = "SSH desde mi IPv4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["152.230.70.226/32"] # Agregado /32 para que sea una IP válida
  }

  egress {
    description = "Permitir trafico de salida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AUY1105-appiac-ssh"
  }
}

# La instancia debe estar FUERA del bloque anterior
resource "aws_instance" "appiac_ec2" {
  ami                    = "ami-0ec10929233384c7f" # Ubuntu 24.04 LTS
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_publica_1.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  # Solución CKV2_AWS_41 para AWS Academy
  iam_instance_profile   = "LabInstanceProfile"

  tags = {
    Name = "AUY1105-appiac-ec2"
  }
}