output "M-subnets" {
    value = aws_subnet.vpc_subnets
  
}

output "M-vpc_id" {

    value = aws_vpc.my_first_vpc.id
  
}

output "M-vpc_cidr_block" {
     value =  aws_vpc.my_first_vpc.cidr_block
}
