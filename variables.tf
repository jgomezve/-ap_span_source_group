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
    description         = optional(string)
    name                = string
    direction           = optional(string)
    span_drop           = optional(string)
    tenant              = optional(string)
    application_profile = optional(string)
    endpoint_group      = optional(string)
    l3out               = optional(string)
    vlan                = optional(number)
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
  description = "SPAN Source Filter Gorup."
  type        = string
  default     = null
}

variable "destination" {
  description = "SPAN Source Destination Gorup."
  type = object({
    description = optional(string)
    name        = string
  })
}