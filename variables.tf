variable "name" {
  description = "SPAN Source Group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "SPAN Source Group description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "admin_state" {
  description = "SPAN Source Group Administrative state."
  type        = bool
  default     = false
}

variable "sources" {
  description = "List of SPAN sources. Default value `direction`: `both`. Default value `span_drop`: `false`."
  type = list(object({
    description         = optional(string, "")
    name                = string
    direction           = optional(string, "both")
    span_drop           = optional(bool, false)
    tenant              = optional(string)
    application_profile = optional(string)
    endpoint_group      = optional(string)
    l3out               = optional(string)
    vlan                = optional(number)
    access_paths = optional(list(object({
      node_id  = number
      node2_id = optional(number)
      fex_id   = optional(number)
      fex2_id  = optional(number)
      pod_id   = optional(number, 1)
      port     = optional(number)
      sub_port = optional(number)
      module   = optional(number, 1)
      channel  = optional(string)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.sources : s.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", s.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "filter_group" {
  description = "SPAN Source Filter Group."
  type        = string
  default     = null
}

variable "destination" {
  description = "SPAN Source Destination Group."
  type = object({
    description = optional(string, "")
    name        = string
  })
}
