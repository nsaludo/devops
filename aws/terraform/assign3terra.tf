provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "e91vpc-p4"
  }
}

resource "aws_subnet" "public-sub-1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "e91vpc_PubSub1"
  }
}

resource "aws_subnet" "public-sub-2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "e91vpc_PubSub2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "e91vpc_IGW"
  }
}

resource "aws_route_table" "public-rt-1" {
    vpc_id = "${aws_vpc.main.id}"
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.igw.id}" 
    }
    
    tags = {
        Name = "prod-public-crt"
    }
}

resource "aws_route_table_association" "public-rt-public-subnet-1"{
  subnet_id = "${aws_subnet.public-sub-1.id}"
  subnet_id = "${aws_subnet.public-sub-2.id}"
  route_table_id = "${aws_route_table.public-rt-1.id}”
}
