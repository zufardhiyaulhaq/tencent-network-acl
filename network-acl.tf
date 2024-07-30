locals {
  allow_all_from_public      = formatlist("ACCEPT#%s#ALL#ALL", var.public_subnets_cidr)
  allow_all_from_utility     = formatlist("ACCEPT#%s#ALL#ALL", var.utility_subnets_cidr)
  allow_all_from_application = formatlist("ACCEPT#%s#ALL#ALL", var.application_subnets_cidr)
  allow_all_from_stateful    = formatlist("ACCEPT#%s#ALL#ALL", var.stateful_subnets_cidr)
  allow_all_From_compliance  = formatlist("ACCEPT#%s#ALL#ALL", var.compliance_subnets_cidr)

  allow_22_tcp_from_utility   = formatlist("ACCEPT#%s#22#TCP", var.utility_subnets_cidr)
  allow_3022_tcp_from_utility = formatlist("ACCEPT#%s#22#TCP", var.utility_subnets_cidr)
  allow_443_tcp_from_utility  = formatlist("ACCEPT#%s#80#TCP", var.utility_subnets_cidr)

  allow_443_tcp_from_internet          = ["ACCEPT#0.0.0.0/0#443#TCP"]
  allow_80_tcp_from_internet           = ["ACCEPT#0.0.0.0/0#80#TCP"]
  allow_15012_tcp_from_internet        = ["ACCEPT#0.0.0.0/0#15012#TCP"]
  allow_15443_tcp_from_internet        = ["ACCEPT#0.0.0.0/0#15443#TCP"]
  allow_k8s_nodeport_tcp_from_internet = ["ACCEPT#0.0.0.0/0#30000-32767#TCP"]

  allow_443_tcp_from_public          = formatlist("ACCEPT#%s#443#TCP", var.public_subnets_cidr)
  allow_80_tcp_from_public           = formatlist("ACCEPT#%s#80#TCP", var.public_subnets_cidr)
  allow_15012_tcp_from_public        = formatlist("ACCEPT#%s#15012#TCP", var.public_subnets_cidr)
  allow_15443_tcp_from_public        = formatlist("ACCEPT#%s#15443#TCP", var.public_subnets_cidr)
  allow_k8s_nodeport_tcp_from_public = formatlist("ACCEPT#%s#30000-32767#TCP", var.public_subnets_cidr)

  allow_all_from_tencent_healthcheck = ["ACCEPT#100.64.0.0/10#ALL#ALL"]

  allow_all_tcp_from_application = formatlist("ACCEPT#%s#ALL#TCP", var.application_subnets_cidr)

  allow_9099_tcp_from_public   = formatlist("ACCEPT#%s#9099#TCP", var.public_subnets_cidr)
  allow_9099_tcp_from_internet = ["ACCEPT#0.0.0.0/0#9099#TCP"]
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
    # Allow 80 & 443 & 15021 & 15443 from 0.0.0.0/0
    local.allow_443_tcp_from_internet,
    local.allow_80_tcp_from_internet,
    local.allow_15012_tcp_from_internet,
    local.allow_15443_tcp_from_internet,
    # allow kubernetes nodeport from 0.0.0.0/0
    local.allow_k8s_nodeport_tcp_from_internet,
    # allow all from tencent healthcheck
    local.allow_all_from_tencent_healthcheck,
    # Allow 9099 (kafka) from 0.0.0.0/0
    local.allow_9099_tcp_from_internet,
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
    # Allow 80 & 443 & 15021 & 15443 from 0.0.0.0/0
    local.allow_443_tcp_from_internet,
    local.allow_80_tcp_from_internet,
    local.allow_15012_tcp_from_internet,
    local.allow_15443_tcp_from_internet,
    # allow kubernetes nodeport from 0.0.0.0/0
    local.allow_k8s_nodeport_tcp_from_internet,
    # allow all from tencent healthcheck
    local.allow_all_from_tencent_healthcheck,
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
    # allow all from tencent healthcheck
    local.allow_all_from_tencent_healthcheck,
    # allow kubernetes nodeport from Public subnet
    local.allow_k8s_nodeport_tcp_from_public,
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
    # allow all from tencent healthcheck
    local.allow_all_from_tencent_healthcheck,
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
    # allow all from tencent healthcheck
    local.allow_all_from_tencent_healthcheck,
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
