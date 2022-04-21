provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIATXBNBEMYALN2KSOD"
  secret_key = "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"
}

resource "aws_vpc" "test-vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = "${aws_vpc.test-vpc.id}"
  cidr_block = var.public_subnet_cidr_blocks[0]
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true


  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id     = "${aws_vpc.test-vpc.id}"
  cidr_block = var.public_subnet_cidr_blocks[1]
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true


  tags = {
    Name = "public-subnet1"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = "${aws_vpc.test-vpc.id}"
  cidr_block = var.private_subnet_cidr_blocks[0]
  availability_zone = "ap-south-1b"


  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "test-igw" {
  vpc_id = "${aws_vpc.test-vpc.id}"


  tags = {
    Name = "test-igw"
  }
}

resource "aws_route_table" "test-routeTable1" {
  vpc_id = "${aws_vpc.test-vpc.id}"


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-igw.id}"
  }

  tags = {
    Name = "test-routeTable1"
  }
}

resource "aws_route_table_association" "associate" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.test-routeTable1.id}"
}

resource "aws_route_table_association" "associate1" {
  subnet_id      = "${aws_subnet.public-subnet1.id}"
  route_table_id = "${aws_route_table.test-routeTable1.id}"
}


resource "aws_eip" "ip" {
  vpc      = true
  tags = {
    Name = "test-elasticIP"
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = "${aws_eip.ip.id}"
  subnet_id     = "${aws_subnet.public-subnet.id}"


  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_route_table" "test-routeTable-2" {
  vpc_id = "${aws_vpc.test-vpc.id}"


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }

  tags = {
    Name = "test-routeTable-2"
  }
}

 resource "aws_route_table_association" "associate2" {
  subnet_id      = "${aws_subnet.private-subnet.id}"
  route_table_id = "${aws_route_table.test-routeTable-2.id}"
}

resource "aws_security_group" "ssh-allowed" {
    vpc_id = "${aws_vpc.test-vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    	
     }    

	ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"        
        cidr_blocks = ["0.0.0.0/0"]
    
     }

	tags = {
        Name = "ssh-allowed"
    }

}

