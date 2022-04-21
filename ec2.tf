resource "aws_instance" "demo-instance-1" {
ami                    = var.aws_ami
instance_type          = "t2.micro" 
key_name               = "new"
monitoring             = true
vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
subnet_id	       = "${aws_subnet.public-subnet.id}"

	tags = {
	    Name = "test-1"

	}

}

resource "aws_instance" "demo-instance-2" {
ami                    = var.aws_ami
instance_type          = "t2.micro"
key_name               = "new"
monitoring             = true
vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
subnet_id              = "${aws_subnet.private-subnet.id}"

        tags = {
            Name = "test-2"

        }

}

resource "aws_instance" "demo-instance-3" {
ami                    = var.aws_ami
instance_type          = "t2.micro"
key_name               = "new"
monitoring             = true
vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
subnet_id	       = "${aws_subnet.public-subnet.id}"

	tags = {
	    Name = "test-3"

	}

}

