variable "private_subnet_ids" {
  description = "Private subnet IDs"
}

variable "ami_id" {
  description = "AMI ID for the instances"
}

resource "aws_instance" "app_server1" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = element(var.private_subnet_ids, 0)
  tags = {
    Name = "AppServer1"
  }
}

resource "aws_instance" "app_server2" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = element(var.private_subnet_ids, 1)
  tags = {
    Name = "AppServer2"
  }
}

output "app_server1_private_ip" {
  value = aws_instance.app_server1.private_ip
}

output "app_server2_private_ip" {
  value = aws_instance.app_server2.private_ip
}
