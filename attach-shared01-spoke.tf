# Attach AWS Sydney Prod Spoke to AWS Sydney Transit 01

resource "aviatrix_spoke_transit_attachment" "aws_syd_prod01_to_transit01" {
  spoke_gw_name   = module.aws_syd_spoke_prod01.spoke_gateway.gw_name
  transit_gw_name = module.aws_syd_transit01.transit_gateway.gw_name

  depends_on = [module.aws_syd_transit01, module.aws_syd_spoke_prod01]
}