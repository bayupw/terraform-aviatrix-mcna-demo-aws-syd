output "aws_syd_prod02_instance_id" {
  description = "AWS Sydney Production Services 01 Instance"
  value       = module.aws_syd_prod02_instance.aws_instance.id
}

output "aws_syd_prod02_instance_private_ip" {
  description = "AWS Sydney Production Services 01 Instance Private IP"
  value       = module.aws_syd_prod02_instance.aws_instance.private_ip
}

output "aws_syd_prod02_ssm_session" {
  description = "AWS Sydney Production Services 01 Instance SSM command"
  value       = "aws ssm start-session --region ${data.aws_region.current.name} --target ${module.aws_syd_prod02_instance.aws_instance.id}"
}

output "aws_syd_dev01_instance_id" {
  description = "AWS Sydney Development 01 Instance"
  value       = module.aws_syd_dev01_instance.aws_instance.id
}

output "aws_syd_dev01_instance_private_ip" {
  description = "AWS Sydney Production 01 Instance Private IP"
  value       = module.aws_syd_dev01_instance.aws_instance.private_ip
}

output "aws_syd_dev01_ssm_session" {
  description = "AWS Sydney Production 01 Instance SSM command"
  value       = "aws ssm start-session --region ${data.aws_region.current.name} --target ${module.aws_syd_dev01_instance.aws_instance.id}"
}