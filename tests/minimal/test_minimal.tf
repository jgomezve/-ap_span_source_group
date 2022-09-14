terraform {
  required_version = ">= 1.0.0"
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source      = "../.."
  name        = "TEST_TF"
  description = "My Test Span Group"
  admin_state = true
  sources = [
    {
      name                = "SRC1"
      description         = "Source1"
      direction           = "both"
      span_drop           = "true"
      tenant              = "TEN1"
      application_profile = "APP1"
      endpoint_group      = "EPG1"
    },
    {
      name   = "SRC2"
      tenant = "TEN1"
      l3out  = "L3OUT1"
      vlan   = 123
    }
  ]
  filter_group = "FILTER1"
  destination = {
    name           = "TEST_DST"
    desdescription = "My Destination"
  }
}

data "aci_rest_managed" "spanSrcGrp" {
  dn         = "uni/infra/srcgrp-TEST_GRP"
  depends_on = [module.main]
}

resource "test_assertions" "spanSrcGrp" {
  component = "spanSrcGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSrcGrp.content.name
    want        = "TEST_GRP"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSrcGrp.content.descr
    want        = ""
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.spanSrcGrp.content.adminSt
    want        = true
  }
}

data "aci_rest_managed" "spanSrc" {
  dn         = "uni/infra/srcgrp-TEST_GRP/src-SR1"
  depends_on = [module.main]
}

resource "test_assertions" "spanSrc" {
  component = "spanSrc"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSrc.content.name
    want        = "SRC1dd"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSrc.content.descr
    want        = "Source1"
  }

  equal "dir" {
    description = "dir"
    got         = data.aci_rest_managed.spanSrc.content.dir
    want        = "both"
  }

  equal "spanOnDrop" {
    description = "spanOnDrop"
    got         = data.aci_rest_managed.spanSrc.content.spanOnDrop
    want        = "trfdue"
  }
}

