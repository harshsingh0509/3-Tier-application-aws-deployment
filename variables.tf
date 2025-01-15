variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "my-key-pair"
}

variable "ami_id" {
  description = "AMI ID for the instances"
  default     = "ami-05576a079321f21f8"  # Your AMI ID
}
