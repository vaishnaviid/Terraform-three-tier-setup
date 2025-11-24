variable "region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "ap-southeast-2"
}
variable "availability_zones" {
  description = "List of Availability Zones to use"
  type        = list(string)
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "vpc_cidr" {
    description = "CIDR block for the 3-tier VPC"
    type        = string
    default     = "0.0.0.0/16"
}
variable "pub_sub_cidr" {
    description = "CIDR block for the public subnet"
    type        = string
    default     = "10.0.0.0/24"
}
variable "pri_sub_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}
