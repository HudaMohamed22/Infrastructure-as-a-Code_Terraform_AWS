

#  Create Security Group allowing SSH from 0.0.0.0/0
resource "aws_security_group" "ssh_from_anywhere" {
  vpc_id = module.network.M-vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    # Egress rule allowing access to anything
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group allowing SSH and Port 3000 from VPC CIDR only
resource "aws_security_group" "ssh_and_port3000_vpc_only" {
  vpc_id = module.network.M-vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.network.M-vpc_cidr_block]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [module.network.M-vpc_cidr_block]
  }

  # Egress rule allowing access to anything
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.my_keypair.public_key_openssh
} 

#  Create EC2 (Bastion) instance in Public Subnet with Security Group from Step 10
resource "aws_instance" "bastion_new" {
  ami                    = var.ec2_details.ami    
  instance_type          = var.ec2_details.type
  subnet_id              = module.network.M-subnets["public"].id
  vpc_security_group_ids     = [aws_security_group.ssh_from_anywhere.id]
  key_name               = var.ec2_details.key_name 
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  mkdir huda    
  mkdir /hudaaaaaaa
  touch /home/ec2-user/key.pem
  echo '${tls_private_key.my_keypair.private_key_pem}' > /home/ec2-user/key.pem
  chmod 400 /home/ec2-user/key.pem
  EOF


}

# Create EC2 (Application) instance in Private Subnet with Security Group 
resource "aws_instance" "application" {
  ami                    = var.ec2_details.ami
  instance_type          = var.ec2_details.type
  subnet_id              = module.network.M-subnets["private1"].id
  vpc_security_group_ids = [aws_security_group.ssh_and_port3000_vpc_only.id]
  key_name               = var.ec2_details.key_name
  provisioner "local-exec" {
    command = "echo Public IP: ${self.private_ip}"
  }
}


