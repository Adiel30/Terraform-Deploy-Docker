resource "aws_vpc" "main-vpc" {
    cidr_block = "172.16.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink_dns_support = "false"
    tags {
        Name= "main-vpc"
    }
}

resource "aws_subnet" "floor1-public-subnet" {
    vpc_id = "${aws_vpc.main-vpc.id}"    
    cidr_block = "172.16.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2a"

    tags {
        Name = "floor1-public-subnet"
    }
}

resource "aws_subnet" "floor2-public-subnet" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    cidr_block = "172.16.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2b"

    tags {
        Name = "floor2-public-subnet"
    }
}
resource "aws_subnet" "floor3-public-subnet" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    cidr_block = "172.16.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-2c"

    tags {
        Name = "floor3-public-subnet"
    }
}

resource "aws_subnet" "floor1-private-subnet" {
    vpc_id = "${aws_vpc.main-vpc.id}"    
    cidr_block = "172.16.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-2a"

    tags {
        Name = "floor1-private-subnet"
    }
}

resource "aws_subnet" "floor2-private-subnet" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    cidr_block = "172.16.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-2b"

    tags {
        Name = "floor2-private-subnet"
    }
}

resource "aws_subnet" "floor3-private-subnet" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    cidr_block = "172.16.6.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-2c"

    tags {
        Name = "floor3-private-subnet"
    }
}

# Gateway

resource "aws_internet_gateway" "lab-gw" {
    vpc_id = "${aws_vpc.main-vpc.id}"

    tags {
        Name = "lab-gw"
    }
}

# route table

resource "aws_route_table" "lab-public" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.lab-gw.id}"
    }
}

resource "aws_route_table_association" "floor1-route-table" {
    subnet_id = "${aws_subnet.floor1-public-subnet.id}"
    route_table_id = "${aws_route_table.lab-public.id}"
}

resource "aws_route_table_association" "floor2-route-table" {
    subnet_id = "${aws_subnet.floor2-public-subnet.id}"
    route_table_id = "${aws_route_table.lab-public.id}"
}

resource "aws_route_table_association" "floor3-route-table" {
    subnet_id = "${aws_subnet.floor3-public-subnet.id}"
    route_table_id = "${aws_route_table.lab-public.id}"
}