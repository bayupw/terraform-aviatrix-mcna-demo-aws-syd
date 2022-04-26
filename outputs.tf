output "aws_syd_shared01_instance_id" {
  description = "AWS Sydney Shared01 Instance"
  value       = module.aws_syd_shared01_instance.aws_instance.id
  sensitive   = false
}

output "aws_syd_shared01_ssm_session" {
  description = "AWS Sydney Prod02 Instance"
  value       = "aws ssm start-session --region ${data.aws_region.current.name} --target ${module.aws_syd_shared01_instance.aws_instance.id}"
  sensitive   = false
}

output "aws_syd_prod01_instance_id" {
  description = "AWS Sydney Prod01 Instance"
  value       = module.aws_syd_prod01_instance.aws_instance.id
  sensitive   = false
}

output "aws_syd_prod01_ssm_session" {
  description = "AWS Sydney Prod01 Instance"
  value       = "aws ssm start-session --region ${data.aws_region.current.name} --target ${module.aws_syd_prod01_instance.aws_instance.id}"
  sensitive   = false
}