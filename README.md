<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-access-span-source-group/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-scaffolding/actions/workflows/test.yml)

# Terraform ACI Access Span Source Group

Description

Location in GUI:
`Tenants` » `XXX`

## Examples

```hcl
module "aci_scaffolding" {
  source  = "netascode/scaffolding/aci"
  version = ">= 0.0.1"

  name        = "ABC"
  alias       = "ABC-ALIAS"
  description = "My Description"
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | SPAN Source Group name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | SPAN Source Group description. | `string` | `""` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | SPAN Source Group Administrative state. | `bool` | `false` | no |
| <a name="input_sources"></a> [sources](#input\_sources) | List of SPAN sources. Default value `direction`: `both`. Default value `span_drop`: `false`. | <pre>list(object({<br>    description         = optional(string)<br>    name                = string<br>    direction           = optional(bool)<br>    span_drop           = optional(bool)<br>    tenant              = optional(bool)<br>    application_profile = optional(bool)<br>    endpoint_group      = optional(bool)<br>    l3out               = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_filter_group"></a> [filter\_group](#input\_filter\_group) | SPAN Source Filter Gorup. | `string` | `null` | no |
| <a name="input_destination"></a> [destination](#input\_destination) | SPAN Source Destination Gorup. | <pre>object({<br>    description = optional(string)<br>    name        = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `spanSrcGrp` object. |
| <a name="output_name"></a> [name](#output\_name) | SPAN Source Group name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest_managed.spanRsSrcGrpToFilterGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToEpg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanRsSrcToL3extOut](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSpanLbl](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSrc](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spanSrcGrp](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
<!-- END_TF_DOCS -->