variable "public_subnet_ids" {
  description = "Public subnet IDs"
}

variable "ami_id" {
  description = "AMI ID for the instances"
}

variable "vpc_id" {
  description = "VPC ID"
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "web_sg"
  }
}

resource "aws_instance" "web_server1" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = element(var.public_subnet_ids, 0)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer1"
  }
}

resource "aws_instance" "web_server2" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = element(var.public_subnet_ids, 1)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer2"
  }
}

resource "aws_elb" "web_elb" {
  name            = "web-elb"
  security_groups = [aws_security_group.web_sg.id]
  subnets         = var.public_subnet_ids

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  instances = [
    aws_instance.web_server1.id,
    aws_instance.web_server2.id,
  ]

  tags = {
    Name = "WebELB"
  }
}

output "web_server1_public_ip" {
  value = aws_instance.web_server1.public_ip
}

output "web_server2_public_ip" {
  value = aws_instance.web_server2.public_ip
}

output "elb_dns_name" {
  value = aws_elb.web_elb.dns_name
}
