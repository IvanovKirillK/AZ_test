variable "location" {
  type        = string
  default     = "australiasoutheast"
  description = "Set AZ location"
}

variable "tags" {
  type        = map
  description = "A list of tags associated to all resources"
  default = {
    maintained_by = "terraform",
    environment = "competencyTest"
  }
}

variable "CID" {
  type        = string
  description = "Service principal client ID"
}

variable "CS" {
  type        = string
  description = "Service principal client Secret"
}