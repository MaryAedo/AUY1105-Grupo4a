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

  egress {
    description = "Permitir trafico de salida a cualquier lugar"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AUY1105-appiac-ssh"
  }
}

resource "aws_instance" "AUY1105-appiac-ec2" {
  ami                    = "ami-0ec10929233384c7f"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_publica_1.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "AUY1105-appiac-ec2"
  }
}