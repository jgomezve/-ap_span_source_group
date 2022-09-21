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
  name        = "TEST_FULL"
  description = "My Test Span Group"
  admin_state = true
  sources = [
    {
      name                = "SRC1"
      description         = "Source1"
      direction           = "both"
      span_drop           = "no"
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
    name        = "TEST_DST"
    description = "My Destination"
  }
}

data "aci_rest_managed" "spanSrcGrp" {
  dn         = "uni/infra/srcgrp-TEST_FULL"
  depends_on = [module.main]
}

resource "test_assertions" "spanSrcGrp" {
  component = "spanSrcGrp"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSrcGrp.content.name
    want        = "TEST_FULL"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSrcGrp.content.descr
    want        = "My Test Span Group"
  }

  equal "adminSt" {
    description = "adminSt"
    got         = data.aci_rest_managed.spanSrcGrp.content.adminSt
    want        = "enabled"
  }
}

data "aci_rest_managed" "spanSrc1" {
  dn         = "${data.aci_rest_managed.spanSrcGrp.id}/src-SRC1"
  depends_on = [module.main]
}

resource "test_assertions" "spanSrc1" {
  component = "spanSrc"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSrc1.content.name
    want        = "SRC1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSrc1.content.descr
    want        = "Source1"
  }

  equal "dir" {
    description = "dir"
    got         = data.aci_rest_managed.spanSrc1.content.dir
    want        = "both"
  }

  equal "spanOnDrop" {
    description = "spanOnDrop"
    got         = data.aci_rest_managed.spanSrc1.content.spanOnDrop
    want        = "no"
  }
}

data "aci_rest_managed" "spanRsSrcToEpg" {
  dn         = "${data.aci_rest_managed.spanSrc1.id}/rssrcToEpg"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToEpg" {
  component = "spanRsSrcToEpg"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToEpg.content.tDn
    want        = "uni/tn-TEN1/ap-APP1/epg-EPG1"
  }
}

data "aci_rest_managed" "spanSrc2" {
  dn         = "${data.aci_rest_managed.spanSrcGrp.id}/src-SRC2"
  depends_on = [module.main]
}

resource "test_assertions" "spanSrc2" {
  component = "spanSrc"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSrc2.content.name
    want        = "SRC2"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSrc2.content.descr
    want        = ""
  }

  equal "dir" {
    description = "dir"
    got         = data.aci_rest_managed.spanSrc2.content.dir
    want        = "both"
  }

  equal "spanOnDrop" {
    description = "spanOnDrop"
    got         = data.aci_rest_managed.spanSrc2.content.spanOnDrop
    want        = "no"
  }
}

data "aci_rest_managed" "spanRsSrcToL3extOut" {
  dn         = "${data.aci_rest_managed.spanSrc2.id}/rssrcToL3extOut"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcToL3extOut" {
  component = "spanRsSrcToL3extOut"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcToL3extOut.content.tDn
    want        = "uni/tn-TEN1/out-L3OUT1"
  }

  equal "encap" {
    description = "encap"
    got         = data.aci_rest_managed.spanRsSrcToL3extOut.content.encap
    want        = "vlan-123"
  }

  equal "addr" {
    description = "addr"
    got         = data.aci_rest_managed.spanRsSrcToL3extOut.content.addr
    want        = "0.0.0.0"
  }
}

data "aci_rest_managed" "spanRsSrcGrpToFilterGrp" {
  dn         = "${data.aci_rest_managed.spanSrcGrp.id}/rssrcGrpToFilterGrp"
  depends_on = [module.main]
}

resource "test_assertions" "spanRsSrcGrpToFilterGrp" {
  component = "spanRsSrcGrpToFilterGrp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest_managed.spanRsSrcGrpToFilterGrp.content.tDn
    want        = "uni/infra/filtergrp-FILTER1"
  }
}

data "aci_rest_managed" "spanSpanLbl" {
  dn         = "${data.aci_rest_managed.spanSrcGrp.id}/spanlbl-TEST_DST"
  depends_on = [module.main]
}

resource "test_assertions" "spanSpanLbl" {
  component = "spanSpanLbl"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.spanSpanLbl.content.descr
    want        = "My Destination"
  }

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.spanSpanLbl.content.name
    want        = "TEST_DST"
  }

  equal "tag" {
    description = "tag"
    got         = data.aci_rest_managed.spanSpanLbl.content.tag
    want        = "yellow-green"
  }
}