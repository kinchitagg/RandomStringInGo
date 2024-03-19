provider "aws" {
  region = "us-east-1"
}

provider "aws" {
    alias = "secondary"
    region = "us-west-1"
}

data "aws_ami" "dynamicAmi" {
  most_recent = true
  provider = aws.secondary

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["*ubuntu*"]  
    }

  filter {
    name   = "architecture"
    values = ["x86_64"]  
  }
}

resource "aws_key_pair" "accessKey" {
  key_name = "access-key"
  public_key = file("~/.ssh/access_key.pub")
  provider = aws.secondary
}



resource "aws_instance" "server" {
  ami           = "${data.aws_ami.dynamicAmi.id}"
  instance_type = "t2.micro"  
  security_groups = [aws_security_group.basic.name]
  key_name = aws_key_pair.accessKey.key_name
  iam_instance_profile = "ECRAccessInstanceProfile"
  user_data = file("userdata.sh") 
  provider = aws.secondary
  tags = {
    name = "randomString"
  }



}

resource "aws_security_group" basic {
    name = "sgg"
    description = "Allow ICMP only"
    provider = aws.secondary

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
        cidr_blocks = ["103.189.173.222/32"]
    }

    ingress {
        from_port = 0
        to_port = 8081
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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
