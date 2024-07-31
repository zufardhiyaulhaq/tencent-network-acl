locals {
  allow_all_from_public      = formatlist("ACCEPT#%s#ALL#ALL", var.public_subnets_cidr)
  allow_all_from_utility     = formatlist("ACCEPT#%s#ALL#ALL", var.utility_subnets_cidr)
  allow_all_from_application = formatlist("ACCEPT#%s#ALL#ALL", var.application_subnets_cidr)
  allow_all_from_stateful    = formatlist("ACCEPT#%s#ALL#ALL", var.stateful_subnets_cidr)
  allow_all_From_compliance  = formatlist("ACCEPT#%s#ALL#ALL", var.compliance_subnets_cidr)

  allow_22_tcp_from_utility   = formatlist("ACCEPT#%s#22#TCP", var.utility_subnets_cidr)
  allow_3022_tcp_from_utility = formatlist("ACCEPT#%s#22#TCP", var.utility_subnets_cidr)
  allow_443_tcp_from_utility  = formatlist("ACCEPT#%s#80#TCP", var.utility_subnets_cidr)

  reject_all_from_vpc     = formatlist(["REJECT#0.0.0.0/0#ALL#ALL"], var.vpc_cidr)
  allow_all_from_internet = ["ACCEPT#0.0.0.0/0#ALL#ALL"]

  allow_443_tcp_from_public          = formatlist("ACCEPT#%s#443#TCP", var.public_subnets_cidr)
  allow_80_tcp_from_public           = formatlist("ACCEPT#%s#80#TCP", var.public_subnets_cidr)
  allow_15012_tcp_from_public        = formatlist("ACCEPT#%s#15012#TCP", var.public_subnets_cidr)
  allow_15443_tcp_from_public        = formatlist("ACCEPT#%s#15443#TCP", var.public_subnets_cidr)
  allow_k8s_nodeport_tcp_from_public = formatlist("ACCEPT#%s#30000-32767#TCP", var.public_subnets_cidr)
  allow_all_tcp_from_application     = formatlist("ACCEPT#%s#ALL#TCP", var.application_subnets_cidr)
  allow_9099_tcp_from_public         = formatlist("ACCEPT#%s#9099#TCP", var.public_subnets_cidr)
}

resource "tencentcloud_vpc_acl" "public" {
  vpc_id = var.vpc_id
  name   = "public-network-acl"
  ingress = concat(
    # Allow all port from Public subnet
    local.allow_all_from_public,
    # Allow 22 & 3022 (access management) from Utility subnet
    local.allow_22_tcp_from_utility,
    local.allow_3022_tcp_from_utility,
    # Allow 443 (kubernetes access) from Utility subnet
    local.allow_443_tcp_from_utility,
    # reject rest from VPC but allow access from internet
    local.reject_all_from_vpc,
    local.allow_all_from_internet,
    var.additional_ingress_public_rules,
  )
  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]

  tags = {
    team        = var.label_team
    environment = var.label_environment
  }
}

resource "tencentcloud_vpc_acl_attachment" "public" {
  for_each = toset(var.public_subnets_id)

  acl_id    = tencentcloud_vpc_acl.public.id
  subnet_id = each.value
}

resource "tencentcloud_vpc_acl" "utility" {
  vpc_id = var.vpc_id
  name   = "utility-network-acl"
  ingress = concat(
    # Allow all port from Utility subnet
    local.allow_all_from_utility,
    # reject rest from VPC but allow access from internet
    local.reject_all_from_vpc,
    local.allow_all_from_internet,
    var.additional_ingress_utility_rules,
  )
  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]

  tags = {
    team        = var.label_team
    environment = var.label_environment
  }
}

resource "tencentcloud_vpc_acl_attachment" "utility" {
  for_each = toset(var.utility_subnets_id)

  acl_id    = tencentcloud_vpc_acl.utility.id
  subnet_id = each.value
}

resource "tencentcloud_vpc_acl" "application" {
  vpc_id = var.vpc_id
  name   = "application-network-acl"
  ingress = concat(
    # Allow all port from Application subnet
    local.allow_all_from_application,
    # Allow 22 & 3022 (access management) from Utility subnet
    local.allow_22_tcp_from_utility,
    local.allow_3022_tcp_from_utility,
    # Allow 443 (kubernetes access) from Utility subnet
    local.allow_443_tcp_from_utility,
    # Allow 80 & 443 & 15021 & 15443 from Public subnet
    local.allow_443_tcp_from_public,
    local.allow_80_tcp_from_public,
    local.allow_15012_tcp_from_public,
    local.allow_15443_tcp_from_public,
    # allow kubernetes nodeport from Public subnet
    local.allow_k8s_nodeport_tcp_from_public,
    # reject rest from VPC but allow access from internet
    local.reject_all_from_vpc,
    local.allow_all_from_internet,
    var.additional_ingress_application_rules,
  )
  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]

  tags = {
    team        = var.label_team
    environment = var.label_environment
  }
}

resource "tencentcloud_vpc_acl_attachment" "application" {
  for_each = toset(var.application_subnets_id)

  acl_id    = tencentcloud_vpc_acl.application.id
  subnet_id = each.value
}


resource "tencentcloud_vpc_acl" "stateful" {
  vpc_id = var.vpc_id
  name   = "stateful-network-acl"
  ingress = concat(
    # Allow all port from Stateful subnet
    local.allow_all_from_stateful,
    # Allow 22 & 3022 (access management) from Utility subnet
    local.allow_22_tcp_from_utility,
    local.allow_3022_tcp_from_utility,
    # Allow 9099 (kafka) from Public subnet
    local.allow_9099_tcp_from_public,
    # Allow all TCP from Application subnet
    local.allow_all_tcp_from_application,
    # reject rest from VPC but allow access from internet
    local.reject_all_from_vpc,
    local.allow_all_from_internet,
    var.additional_ingress_stateful_rules,
  )
  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]

  tags = {
    team        = var.label_team
    environment = var.label_environment
  }
}

resource "tencentcloud_vpc_acl_attachment" "stateful" {
  for_each = toset(var.stateful_subnets_id)

  acl_id    = tencentcloud_vpc_acl.stateful.id
  subnet_id = each.value
}


resource "tencentcloud_vpc_acl" "compliance" {
  vpc_id = var.vpc_id
  name   = "compliance-network-acl"
  ingress = concat(
    local.allow_all_From_compliance,
    # reject rest from VPC but allow access from internet
    local.reject_all_from_vpc,
    local.allow_all_from_internet,
    var.additional_ingress_compliance_rules,
  )
  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]

  tags = {
    team        = var.label_team
    environment = var.label_environment
  }
}

resource "tencentcloud_vpc_acl_attachment" "compliance" {
  for_each = toset(var.compliance_subnets_id)

  acl_id    = tencentcloud_vpc_acl.compliance.id
  subnet_id = each.value
}
