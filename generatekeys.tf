
resource "tls_private_key" "my_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename = "./Key/terraformPrivateKey.pem"  
  content  = tls_private_key.my_keypair.private_key_pem  
}




