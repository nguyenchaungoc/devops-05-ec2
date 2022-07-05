# Khai báo provider và xác thực
# https://registry.terraform.io/providers/hashicorp/aws/latest
terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "4.20.1"

	}
	}
}

provider "aws" {
	region = "ap-southeast-1" # Singapore region
}


# Tạo EC2
resource "aws_instance" "web" {
	ami = "ami-0d058fe428540cd89"
	instance_type = "t2.micro"
	subnet_id = "subnet-06bd3efb50b455906"
	key_name = aws_key_pair.dev.key_name
	vpc_security_group_ids = [aws_security_group.allow_ssh.id]
	tags = {
		Name = "web-01"
	}
}

# Tạo ssh keypair

resource "aws_key_pair" "dev" {
  key_name   = "dev-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWL+1q0mO6HoeteIqMZeZpani1J3BmnjIwHbfweEUgqCuL7c4wq3xPXMDNL8EJmJUydcjxTZdVVAZcAfBb0AAYh1FZ6TYpbGUeoW8hbEwl9t66xV+NnmTVdUJyMTf7Gcnz9KsQBlSgYS94Zw1oOQ4kp+/6ComFcM5hkRmiCBBk5/oSExqdfzGUMy6LveCP/vfZuUlkn0HmeKANuG8tnuxOdKP7a88DpiRBOYlMHILUhDO2qpd393SJYsQ76XD8cNi2jJDgVBhgz/94lPpiCaaA5Rox8JArpjV4iJ1FNesuI5XsG6e9knvl3kOjcfl24Xqp3UiiRPE6VX2pGHx97/1zutNRaFza31o/DxnlJmX2oeszFoZHMQibKVUxPruciR6BPIeL/RbGDY0iV+DGzonp6NhTnANRfr8JzK/0ANtThe6ssbNOF1PFEsmtQuczvGxFFs8lxEra1+4rxHfepUaViws1AsNTrG10PCuksWt6Qnpk45bgEgbpTljRe2Ees4c="
}

# Tạo security group allow ssh

resource "aws_security_group" "allow_ssh" {
	name = "allow_ssh"
	description = "Allow SSH inbound traffic"
	vpc_id = "vpc-0a569dc5a4f091a81"

	ingress {
		description = "SSH from specify IPs"
		from_port = 22
		to_port = 22
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

# in ra public ip của ec2 instance

output "ec2_instance_public_ips" {
	value = aws_instance.web.*.public_ip
}