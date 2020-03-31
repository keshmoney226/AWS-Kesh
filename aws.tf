#aws.tf
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

provider "aws" {
	region = "us-east-1"
	access_key = "${var.AWS_ACCESS_KEY}"
	secret_key = "${var.AWS_SECRET_KEY}"
}

resource "aws_key_pair" "kesh-key" {
	key_name = "kesh-key"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJVY9bpcpajHXA/WHEdfHc/mMXcdId+oMTd2U2j/IymJM23sy7CGNDxlhX7rPcN2Mq+xsFOs6L3hhUuJjsjyVDVH8WGv3+AGm6rpwezplEgHycUdJHujaLMDOl1qanKmOcNeOLnpuJ9K2MFtckzPX7zmCZ3UBOldaDe9zF8yY0gRxcGrKoFnF7LzTgPbURyOMhvMmE7/idNC3c/+Gcdpgf8k4C0XRYNY6VojeDPE7e9iOayXgByFreGIR7qj1H+SNmdWn1qqwIH+VdwP7cG/kL+hxli7oYLkJPSCZ2CEWP4dkJnZj0L365K93nU5TA0l0J5g7DU47Nir1fg6k1VliR kesh@Kesh-ubuntu-01"
}
resource "aws_instance" "web" {
	ami = "ami-04ac550b78324f651"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.kesh-key.key_name}"
	tags {
		Name = "Test_instance"
	}
}
