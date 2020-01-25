variable "location" {
  type        = string
  default     = "australiasoutheast"
  description = "Set AZ location"
}

variable "tags" {
  type        = map
  description = "A list of tags associated to all resources"

  default = {
    maintained_by = "terraform"
  }
}