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
  default     = "527225c6-2d45-4fe5-93ef-b5075cc46da4"
}

variable "CS" {
  type        = string
  description = "Service principal client Secret"
  default     = "1e95a5b0-dc22-4388-8cc9-07d954c38e31"
}

variable "aksVersion" {
  type        = string
  default     = "1.16.4"
  description = "Kube version for AKS cluster"
}

variable "DNSZoneName" {
  type        = string
  default     = "competencyTest_dns.com"
  description = "DNS Zone name"
}