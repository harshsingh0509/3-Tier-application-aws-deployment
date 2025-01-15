provider "aws" {
  region = var.region
}

module "network" {
  source = "./network"
}

module "web_server" {
  source            = "./web_server"
  public_subnet_ids = module.network.public_subnet_ids
  vpc_id            = module.network.vpc_id  # Pass VPC ID
  ami_id            = var.ami_id
}

module "app_server" {
  source             = "./app_server"
  private_subnet_ids = module.network.private_subnet_ids
  ami_id             = var.ami_id
}

module "database" {
  source             = "./database"
  private_subnet_ids = module.network.private_subnet_ids
  vpc_id             = module.network.vpc_id  # Pass VPC ID
}
