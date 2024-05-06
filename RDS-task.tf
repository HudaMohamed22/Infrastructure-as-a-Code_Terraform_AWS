

# Create RDS DB Subnet Group
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [module.network.M-subnets["private1"].id ,module.network.M-subnets["private2"].id] # Specify private subnet ID
}

#  Create RDS DB Instance
resource "aws_db_instance" "my_db_instance" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "my-db-instance"
  username             = "admin"
  password             = "password123"
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name //(create subnet group in case i need by DB on more that one private subnet )
  skip_final_snapshot  = true
}


# Create Elasticache Subnet Group
resource "aws_elasticache_subnet_group" "my_elasticache_subnet_group" {
  name       = "my-elasticache-subnet-group"
  subnet_ids = [module.network.M-subnets["private1"].id] # Specify private subnet ID
}

#  Create ElastiCache Cluster
resource "aws_elasticache_cluster" "my_elasticache_cluster" {
  cluster_id               = "my-elasticache-cluster"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.my_elasticache_subnet_group.name
}

