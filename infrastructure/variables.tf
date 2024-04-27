variable "num_nodes" {
  description = "Number of compute nodes in the cluster"
  type        = number
  default     = 4
}

variable "start_nodes" {
  description = "Boolean to start nodes on creation"
  type        = bool
  default     = true
}
