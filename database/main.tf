variable "private_subnet_ids" {
  description = "Private subnet IDs"
}

variable "vpc_id" {
  description = "VPC ID"
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow MySQL traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "main"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  master_username         = "admin"
  master_password         = "password"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  skip_final_snapshot     = true

  tags = {
    Name = "AuroraCluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_instance1" {
  identifier              = "aurora-instance-1"
  cluster_identifier      = aws_rds_cluster.aurora.id
  instance_class          = "db.t3.medium"
  engine                  = "aurora-mysql"
  db_subnet_group_name    = aws_db_subnet_group.main.name

  tags = {
    Name = "AuroraInstance1"
  }
}

resource "aws_rds_cluster_instance" "aurora_instance2" {
  identifier              = "aurora-instance-2"
  cluster_identifier      = aws_rds_cluster.aurora.id
  instance_class          = "db.t3.medium"
  engine                  = "aurora-mysql"
  db_subnet_group_name    = aws_db_subnet_group.main.name

  tags = {
    Name = "AuroraInstance2"
  }
}

output "database_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}
