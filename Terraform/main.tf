provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "dynamicAmi" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["*"]  
    }

  filter {
    name   = "architecture"
    values = ["x86_64"]  
  }
}

resource "aws_key_pair" "accessKey" {
  key_name = "access-key"
  public_key = file("/Users/kinchitaggarwal/.ssh/access_key.pub")
}

data "terraform_remote_state" "iam_roles" {
  backend = "local"

  config = {
    path = "terraform.tfstate"
  }
}

resource "aws_instance" "server" {
  ami           = "${data.aws_ami.dynamicAmi.id}"
  instance_type = "t2.micro"  
  security_groups = [aws_security_group.basic.name]
  key_name = aws_key_pair.accessKey.key_name
  iam_instance_profile = "ECRAccessInstanceProfile"
  tags = {
    name = "randomString"
  }



}

resource "aws_security_group" basic {
    name = "sg"
    description = "Allow ICMP only"

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["49.36.184.143/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

output "public_ip" {
    value = aws_instance.server.public_ip 
}