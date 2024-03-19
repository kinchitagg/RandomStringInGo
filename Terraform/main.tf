provider "aws" {
  region = "us-east-1"
}

provider "aws" {
    alias = "secondary"
    region = "us-east-1"
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

data "aws_availability_zones" "available" {
  provider = aws.secondary
}

#resource "aws_key_pair" "accessKey" {
#  key_name = "access-key"
#  public_key = file("~/.ssh/access_key.pub")
#  provider = aws.secondary
#}



resource "aws_instance" "server" {
  ami = "${data.aws_ami.dynamicAmi.id}"
  instance_type = "t2.micro" 
  availability_zone = data.aws_availability_zones.available.names[0] 
  security_groups = [aws_security_group.basic.name]

  #key_name = aws_key_pair.accessKey.key_name

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
    
    #ingress {
    #    from_port = -1
    #    to_port = -1
    #    protocol = "icmp"
    #    cidr_blocks = ["0.0.0.0/0"]
    #}

    #ingress {
    #    from_port = 22
    #    to_port = 22
    #    protocol = "tcp"
    #    cidr_blocks = ["103.189.173.222/32"]
    #}
    
    ingress {
        from_port = 8081
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

resource "aws_kms_key" "awsKmsKey" {
  provider = aws.secondary
  description         = "KMS Key"
  enable_key_rotation = true
}


resource "aws_ebs_volume" "awsEbsVolume" {
  provider = aws.secondary
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 10
  encrypted         = true
  kms_key_id        = aws_kms_key.awsKmsKey.arn
}

resource "aws_volume_attachment" "awsVolumeAttachment" {
  provider = aws.secondary
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.awsEbsVolume.id
  instance_id = aws_instance.server.id
}

output "public_ip" {
    value = aws_instance.server.public_ip 
}
