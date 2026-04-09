#En general todos los recursos creados deben cumplir con la siguiente nomenclatura: 
# <sigla-curso>-<nombre-aplicación>-<tipo-recurso>, donde <tipo-recurso> es una abreviatura que 
# representa el tipo de recurso y <nombre-proyecto> es un nombre asignado por el alumno. 
# Por ejemplo, para la creación de una VPC, del proyecto llamado “duocapp”, el nombre final del recurso es: AUY1105-duocapp-vpc.
# --- VPC PRINCIPAL ---
resource "aws_vpc" "mi_vpc" {
  cidr_block           = "10.1.0.0/16" # Requisito Evaluación [cite: 57, 127]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "AUY1105-appiac-vpc" # Nomenclatura Estándar [cite: 66, 127]
  }
}

# --- CONECTIVIDAD ---
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mi_vpc.id
  tags = {
    Name = "AUY1105-appiac-igw"
  }
}

# --- SUBREDES PÚBLICAS (CORREGIDAS A 10.1.x.x) ---
resource "aws_subnet" "subnet_publica_1" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = "10.1.1.0/24" # Corregido para estar dentro de 10.1.0.0/16
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false # Solución CKV_AWS_130
  tags = {
    Name = "AUY1105-appiac-subnet-publica-1"
  }
}

resource "aws_subnet" "subnet_publica_2" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = "10.1.2.0/24" # Corregido para estar dentro de 10.1.0.0/16
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false # Solución CKV_AWS_130
  tags = {
    Name = "AUY1105-appiac-subnet-publica-2"
  }
}

# --- SUBREDES PRIVADAS (CORREGIDAS A 10.1.x.x) ---
resource "aws_subnet" "subnet_privada_1" {
  vpc_id            = aws_vpc.mi_vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "AUY1105-appiac-subnet-privada-1"
  }
}

resource "aws_subnet" "subnet_privada_2" {
  vpc_id            = aws_vpc.mi_vpc.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "AUY1105-appiac-subnet-privada-2"
  }
}

# --- NAT GATEWAY ---
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "AUY1105-appiac-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_publica_1.id
  tags = {
    Name = "AUY1105-appiac-nat-gw"
  }
}

# --- RUTAS PÚBLICAS ---
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.mi_vpc.id
  tags = {
    Name = "AUY1105-appiac-public-rtb"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.subnet_publica_1.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.subnet_publica_2.id
  route_table_id = aws_route_table.public_rtb.id
}

# --- RUTAS PRIVADAS ---
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.mi_vpc.id
  tags = {
    Name = "AUY1105-appiac-private-rtb"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.subnet_privada_1.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.subnet_privada_2.id
  route_table_id = aws_route_table.private_rtb.id
}

# --- SEGURIDAD Y CUMPLIMIENTO (CHECKS DE SEGURIDAD) ---

# Solución CKV2_AWS_12: Restringir Security Group por defecto
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.mi_vpc.id
}

# Solución CKV2_AWS_11: Flow Logs para Auditoría
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "/aws/vpc/AUY1105-appiac-flow-logs"
  retention_in_days = 7
  tags = {
    Name = "AUY1105-appiac-lg"
  }
}

data "aws_iam_role" "labrole" {
  name = "LabRole" # Rol preexistente en AWS Academy
}

resource "aws_flow_log" "mi_vpc_flow_log" {
  iam_role_arn    = data.aws_iam_role.labrole.arn
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.mi_vpc.id
}