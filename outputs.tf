output "web_server1_public_ip" {
  description = "Public IP of the first web server"
  value       = module.web_server.web_server1_public_ip
}

output "web_server2_public_ip" {
  description = "Public IP of the second web server"
  value       = module.web_server.web_server2_public_ip
}

output "app_server1_private_ip" {
  description = "Private IP of the first application server"
  value       = module.app_server.app_server1_private_ip
}

output "app_server2_private_ip" {
  description = "Private IP of the second application server"
  value       = module.app_server.app_server2_private_ip
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.database_endpoint
}

output "elb_dns_name" {
  description = "DNS name of the Elastic Load Balancer"
  value       = module.web_server.elb_dns_name
}
