variable "subscription_id" {
  type        = string
  description = "account subscription_id"
}

variable "tenant_id" {
  type        = string
  description = "account tenant_id"
}

variable "region" {
  type    = string
  default = "francecentral"
}

variable "cloudflare_api_token" {
  sensitive   = true
  ephemeral   = true
  description = "Cloudflare API token, DNS edit on assfah.me only."
  type        = string
  default     = null
  nullable    = true
}