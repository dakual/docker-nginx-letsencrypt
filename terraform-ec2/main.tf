# they are local variables. you must change before apply
locals {
  ami             = "ami-0a5b5c0ea66ec560d"
  instance_type   = "t2.micro"
  security_group  = "sg-095938d5e717361ea"
  key_name        = "mykey"
  region          = "eu-central-1"
  vpc_id          = "vpc-064f43e135e1ecbc0"
  subnet_id       = "subnet-02caf3f4a7dab08f6"
}

# ec2 instance
resource "aws_instance" "docker" {
  ami                         = local.ami
  instance_type               = local.instance_type
  key_name                    = local.key_name
  security_groups             = [ local.security_group ]
  subnet_id                   = local.subnet_id
  associate_public_ip_address = true

  tags = {
    "Name" = "docker-dev"
  }

  # remote ssh connection credentials
  connection {
    type        = "ssh"
    user        = "admin"
    private_key = file("~/.aws/pems/mykey.pem")
    host        = self.public_ip
  }

  # in here we are installing required packages and docker. after creating network and runing application
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ca-certificates curl gnupg lsb-release python3-pip python3-setuptools software-properties-common",
      "sudo mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install docker-ce docker-compose-plugin -y",
      "pip install docker",
      "sudo usermod -aG docker $USER"
    ]
  }
}

