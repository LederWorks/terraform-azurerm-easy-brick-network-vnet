################################ Common Variables
variable "subscription_id" {
  description = "(Required) ID of the Subscription"
  type        = any

  validation {
    condition     = can(regex("\\b[0-9a-f]{8}\\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\\b[0-9a-f]{12}\\b", var.subscription_id))
    error_message = "Invalid format for subscription_id. Must be a valid subscription id. Ex: 00000000-0000-0000-0000-000000000000."
  }

}

variable "resource_group_object" {
  description = "(Required) Resource Group Object"
  type        = any

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.resource_group_object))
    error_message = "Invalid format for resource_group_object. It should match the format: /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourcegroupname"
  }

}

variable "tags" {
  description = "(Optional) Your Azure tags, as a map(string)"
  type        = map(string)
  default     = null
}
