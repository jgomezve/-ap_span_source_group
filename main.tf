resource "aci_rest_managed" "spanSrcGrp" {
  dn         = "uni/infra/srcgrp-${var.name}"
  class_name = "spanSrcGrp"
  content = {
    adminSt = var.admin_state == false ? "disabled" : "enabled"
    descr   = var.description
    name    = var.name
  }
}

resource "aci_rest_managed" "spanSrc" {
  for_each   = { for source in var.sources : source.name => source }
  dn         = "${aci_rest_managed.spanSrcGrp.dn}/src-${each.value.name}"
  class_name = "spanSrc"
  content = {
    name       = each.value.name
    descr      = each.value.description != null ? each.value.description : ""
    dir        = each.value.direction != null ? each.value.direction : "both"
    spanOnDrop = each.value.span_drop != null ? each.value.span_drop : "no"
  }
}

resource "aci_rest_managed" "spanRsSrcToEpg" {
  for_each   = { for source in var.sources : source.name => source if source.tenant != null && source.application_profile != null && source.endpoint_group != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.name].dn}/rssrcToEpg"
  class_name = "spanRsSrcToEpg"
  content = {
    tDn = "uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.endpoint_group}"
  }
}

resource "aci_rest_managed" "spanRsSrcToL3extOut" {
  for_each   = { for source in var.sources : source.name => source if source.tenant != null && source.l3out != null && source.vlan != null }
  dn         = "${aci_rest_managed.spanSrc[each.value.name].dn}/rssrcToL3extOut"
  class_name = "spanRsSrcToL3extOut"
  content = {
    addr  = "0.0.0.0"
    encap = "vlan-${each.value.vlan}"
    tDn   = "uni/tn-${each.value.tenant}/out-${each.value.l3out}"
  }
}

resource "aci_rest_managed" "spanRsSrcGrpToFilterGrp" {
  count      = var.filter_group != null ? 1 : 0
  dn         = "${aci_rest_managed.spanSrcGrp.dn}/rssrcGrpToFilterGrp"
  class_name = "spanRsSrcGrpToFilterGrp"
  content = {
    tDn = "uni/infra/filtergrp-${var.filter_group}"
  }
}

resource "aci_rest_managed" "spanSpanLbl" {
  dn         = "${aci_rest_managed.spanSrcGrp.dn}/spanlbl-${var.destination.name}"
  class_name = "spanSpanLbl"
  content = {
    descr = var.destination.description != null ? var.destination.description : ""
    name  = var.destination.name
    tag   = "yellow-green"
  }
}