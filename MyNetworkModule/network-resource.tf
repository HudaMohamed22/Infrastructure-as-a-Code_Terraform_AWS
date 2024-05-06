# Step 1: Create VPC
resource "aws_vpc" "my_first_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Step 2: Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_first_vpc.id
}



# Step 3: Create Public & Private Route Table
resource "aws_route_table" "route_tables" {
  count = 2
  vpc_id = aws_vpc.my_first_vpc.id

}

# Step 5: Create Public Route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.route_tables[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}


# Step 6: Create Public & Private Subnet
resource "aws_subnet" "vpc_subnets" {
for_each = { for subnet in var.subnets_details : subnet.name => subnet }
  vpc_id            = aws_vpc.my_first_vpc.id
  cidr_block        = each.value.cidr
}


# Step 9: Attach Route Tables to Subnets
resource "aws_route_table_association" "subnets_association" {
  count = 2        
                       //conditions
  subnet_id      = count.index == 0? aws_subnet.vpc_subnets["public"].id : aws_subnet.vpc_subnets["private1"].id 
  route_table_id =  count.index == 0?  aws_route_table.route_tables[0].id :  aws_route_table.route_tables[1].id
}

