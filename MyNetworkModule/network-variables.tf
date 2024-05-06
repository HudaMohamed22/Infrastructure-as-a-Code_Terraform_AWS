variable vpc_cidr {
  type        = string
  description = "description"
}

variable subnets_details {
  type        = list(object({
    name=string,
    cidr=string,
    type=string

  }))

  description = "description"
}