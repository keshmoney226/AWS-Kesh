#aws.tf
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

provider "aws" {
	region     = "us-east-1"
	access_key = "${var.AWS_ACCESS_KEY}"
	secret_key = "${var.AWS_SECRET_KEY}"
}

resource "aws_default_vpc" "default"{}

resource "aws_key_pair" "kesh-key" {
	key_name   = "kesh-key"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJVY9bpcpajHXA/WHEdfHc/mMXcdId+oMTd2U2j/IymJM23sy7CGNDxlhX7rPcN2Mq+xsFOs6L3hhUuJjsjyVDVH8WGv3+AGm6rpwezplEgHycUdJHujaLMDOl1qanKmOcNeOLnpuJ9K2MFtckzPX7zmCZ3UBOldaDe9zF8yY0gRxcGrKoFnF7LzTgPbURyOMhvMmE7/idNC3c/+Gcdpgf8k4C0XRYNY6VojeDPE7e9iOayXgByFreGIR7qj1H+SNmdWn1qqwIH+VdwP7cG/kL+hxli7oYLkJPSCZ2CEWP4dkJnZj0L365K93nU5TA0l0J5g7DU47Nir1fg6k1VliR kesh@Kesh-ubuntu-01"
}
resource "aws_instance" "bastion" {
	ami             = "ami-0fc61db8544a617ed"
	instance_type   = "t2.micro"
	key_name        = "${aws_key_pair.kesh-key.key_name}"
	tags {
		Name = "Bastion_instance"
	}
	security_groups = ["${aws_security_group.bastion-sg.name}"]
	associate_public_ip_address = true
}

resource "aws_security_group" "bastion-sg" {
	name   = "bastion-security-group"
	vpc_id = "${aws_default_vpc.default.id}"

	ingress {
	 protocol       = "tcp"
	 from_port	= 22
	 to_port	= 22
	 cidr_blocks	= ["0.0.0.0/0"]
	}
	
	egress {
	 protocol	= -1
	 from_port	= 0
	 to_port	= 0
	 cidr_blocks	= ["0.0.0.0/0"]
	}
}

output "bastion_public_ip" {
	value = "${aws_instance.bastion.public_ip}"
	}

