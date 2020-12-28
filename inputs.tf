variable "bucket_name" {
  type        = string
  description = "The name of the bucket to be created for import staging."
}

variable "create_group" {
  type        = bool
  description = "Create a group with authority to assume the linuxkit role"
  default     = false
}
