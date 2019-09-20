resource "aws_security_group" "ecs-lab-SEC_Group" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    name = "ecs-lab"
    description = "This I SG for ECS"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" # ALL protocol
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        security_groups = ["${aws_security_group.elb-lab-SEC_Group.id}"] # Security Group Of LB
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "Security Group Of Ecs"
    }
}

# Security Group For ELB (Load Balancer)
resource "aws_security_group" "elb-lab-SEC_Group" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    name = "elb-lab"
    description = "This is Security Group For ELB"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    tags {
        Name = "elb-lab"
    }
}

resource "aws_security_group" "jenkins-lab-SEC_Group" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    name = "jenkins-lab"
    description = " This is Security Group for Jenkins"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }        
    tags {
        Name = "jenkins-lab-secgroup"
    }
}