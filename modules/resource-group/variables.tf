variable "name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Extra tags merged over the standard demo tags."
  type        = map(string)
  default     = {}
}
