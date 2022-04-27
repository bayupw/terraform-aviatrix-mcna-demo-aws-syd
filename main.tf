data "aws_region" "current" {}

##############
# AWS Sydney #
##############

module "aws_syd_transit02" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.0.1"

  name                   = "aws-syd-transit02"
  cloud                  = "aws"
  region                 = data.aws_region.current.name
  cidr                   = cidrsubnet(var.supernet, 7, 0)
  account                = var.aws_account
  instance_size          = "t2.micro" #firenet > "c5.xlarge"
  ha_gw                  = false
  single_az_ha           = false
  enable_segmentation    = true
  enable_transit_firenet = false

  local_as_number             = 65001
  learned_cidr_approval       = true
  learned_cidrs_approval_mode = "gateway"
}

module "aws_syd_spoke_prod02" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.1.2"

  name          = "aws-syd-spoke-prod02"
  cloud         = "AWS"
  cidr          = cidrsubnet(var.supernet, 8, 11)
  region        = data.aws_region.current.name
  account       = var.aws_account
  instance_size = "t2.micro"
  single_az_ha  = false
  ha_gw         = false
  #attached      = false
  transit_gw = module.aws_syd_transit02.transit_gateway.gw_name
}

module "aws_syd_spoke_dev01" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.1.2"

  name          = "aws-syd-spoke-dev01"
  cloud         = "AWS"
  cidr          = cidrsubnet(var.supernet, 8, 12)
  region        = data.aws_region.current.name
  account       = var.aws_account
  instance_size = "t2.micro"
  single_az_ha  = false
  ha_gw         = false
  #attached      = false
  transit_gw = module.aws_syd_transit02.transit_gateway.gw_name
}

#############
# Instances #
#############

module "ssm_instance_profile" {
  source  = "bayupw/ssm-instance-profile/aws"
  version = "1.0.0"
}

module "aws_syd_prod02_ssm" {
  source  = "bayupw/ssm-vpc-endpoint/aws"
  version = "1.0.1"

  vpc_id         = module.aws_syd_spoke_prod02.vpc.vpc_id
  vpc_subnet_ids = [module.aws_syd_spoke_prod02.vpc.private_subnets[0].subnet_id]

  depends_on = [module.aws_syd_spoke_prod02]
}

module "aws_syd_prod02_instance" {
  source  = "bayupw/amazon-linux-2/aws"
  version = "1.0.0"

  instance_hostname    = "syd-prod02-instance"
  vpc_id               = module.aws_syd_spoke_prod02.vpc.vpc_id
  subnet_id            = module.aws_syd_spoke_prod02.vpc.private_subnets[0].subnet_id
  key_name             = "ec2_keypair"
  iam_instance_profile = module.ssm_instance_profile.aws_iam_instance_profile

  associate_public_ip_address    = false
  enable_password_authentication = true
  random_password                = false
  instance_username              = var.instance_username
  instance_password              = var.instance_password

  depends_on = [module.aws_syd_spoke_prod02]
}

module "aws_syd_dev01_ssm" {
  source  = "bayupw/ssm-vpc-endpoint/aws"
  version = "1.0.1"

  vpc_id         = module.aws_syd_spoke_dev01.vpc.vpc_id
  vpc_subnet_ids = [module.aws_syd_spoke_dev01.vpc.private_subnets[0].subnet_id]

  depends_on = [module.aws_syd_spoke_dev01]
}

module "aws_syd_dev01_instance" {
  source  = "bayupw/amazon-linux-2/aws"
  version = "1.0.0"

  instance_hostname    = "syd-dev01-instance"
  vpc_id               = module.aws_syd_spoke_dev01.vpc.vpc_id
  subnet_id            = module.aws_syd_spoke_dev01.vpc.private_subnets[0].subnet_id
  key_name             = "ec2_keypair"
  iam_instance_profile = module.ssm_instance_profile.aws_iam_instance_profile

  associate_public_ip_address    = false
  enable_password_authentication = true
  random_password                = false
  instance_username              = var.instance_username
  instance_password              = var.instance_password

  depends_on = [module.aws_syd_spoke_dev01]
}