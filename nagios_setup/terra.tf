provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIATR6RABBVTOLYWNFV"
  secret_key = "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"
}



resource "aws_instance" "instance1" {
ami = "ami-0af25d0df86db00c1"
instance_type = "t2.micro"
key_name               = "bantu"
monitoring             = true
vpc_security_group_ids = ["sg-0b216027383eb7f8c"]
subnet_id              = "subnet-a0160dc8"

tags = {
Name = "Ansible-server"
}
}



resource "aws_instance" "instance3" {
ami = "ami-0af25d0df86db00c1"
instance_type = "t2.micro"
key_name               = "bantu"
monitoring             = true
vpc_security_group_ids = ["sg-0b216027383eb7f8c"]
subnet_id              = "subnet-a0160dc8"


tags = {
Name = "Mysql-server"
}
}


resource "aws_instance" "instance2" {
ami = "ami-0af25d0df86db00c1"
instance_type = "t2.micro"
key_name               = "bantu"
monitoring             = true
vpc_security_group_ids = ["sg-0b216027383eb7f8c"]
subnet_id              = "subnet-a0160dc8"


tags = {
Name = "Nagios-server"
}
}


