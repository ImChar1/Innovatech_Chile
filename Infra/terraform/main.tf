terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_iam_role" "labrole" {
  name = "LabRole"
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "innovatech-vpc"
  }
}

# --- GRUPO DE SEGURIDAD UNIFICADO PARA EKS ---
resource "aws_security_group" "eks_sg" {
  name        = "innovatech-eks-sg"
  description = "Security Group para el Cluster EKS y Nodos Workers"
  vpc_id      = aws_vpc.eks_vpc.id

  # Regla 1: Permitir al Pipeline (GitHub Actions) administrar el clúster
  ingress {
    description = "Permitir trafico al API Server desde internet (GitHub Actions)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla 2: Permitir que los nodos y los Pods hablen entre si (Backend -> MySQL)
  ingress {
    description = "Permitir comunicacion interna entre Nodos y Pods"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Regla 3: Permitir que el LoadBalancer de AWS llegue al NGINX (Frontend)
  ingress {
    description = "Permitir trafico del Load Balancer hacia los NodePorts"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = [aws_vpc.eks_vpc.cidr_block]
  }

  # Regla 4: Salida a internet (Obligatorio para descargar imagenes de ECR)
  egress {
    description = "Permitir toda la salida a internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "innovatech-eks-security-group"
  }
}

resource "aws_subnet" "eks_subnet_1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "innovatech-subnet-1"
  }
}

resource "aws_subnet" "eks_subnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "innovatech-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "innovatech-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "innovatech-route-table"
  }
}

resource "aws_route_table_association" "rta_1" {
  subnet_id      = aws_subnet.eks_subnet_1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta_2" {
  subnet_id      = aws_subnet.eks_subnet_2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_eks_cluster" "eks" {
  name     = "innovatech-chile-cluster"
  role_arn = data.aws_iam_role.labrole.arn
  vpc_config {
    subnet_ids = [
      aws_subnet.eks_subnet_1.id,
      aws_subnet.eks_subnet_2.id
    ]
    # Inyectamos el Security Group creado arriba
    security_group_ids = [aws_security_group.eks_sg.id]
  }
}

resource "aws_eks_node_group" "workers" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "workers"
  node_role_arn   = data.aws_iam_role.labrole.arn
  subnet_ids = [
    aws_subnet.eks_subnet_1.id,
    aws_subnet.eks_subnet_2.id
  ]
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"
}

resource "aws_ecr_repository" "ventas_repo" {
  name         = "innovatech-chile-backend-ventas"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = { Name = "backend-ventas" }
}

resource "aws_ecr_repository" "despachos_repo" {
  name         = "innovatech-chile-backend-despachos"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = { Name = "backend-despachos" }
}

resource "aws_ecr_repository" "frontend_repo" {
  name         = "innovatech-frontend"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = { Name = "frontend" }
}

resource "aws_ecr_repository" "mysql_repo" {
  name         = "innovatech-chile-mysql"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = { Name = "mysql-base" }
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "ventas_ecr_url" {
  value = aws_ecr_repository.ventas_repo.repository_url
}

output "despachos_ecr_url" {
  value = aws_ecr_repository.despachos_repo.repository_url
}

output "frontend_ecr_url" {
  value = aws_ecr_repository.frontend_repo.repository_url
}

output "mysql_ecr_url" {
  value = aws_ecr_repository.mysql_repo.repository_url
}