
resource "aws_instance" "jenkins-instance" {
    
    ami = "${lookup(var.ECS_AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"

    
    # VPC Subnet
    subnet_id = "${aws_subnet.floor1-public-subnet.id}"

    # Security Group
    vpc_security_group_ids = ["${aws_security_group.jenkins-lab-SEC_Group.id}"]

    # Public SSH
    key_name = "${aws_key_pair.adiel-key.key_name}"

    # User Data
    user_data = "${data.template_cloudinit_config.cloudinit-jenkins.rendered}"  
}

resource "aws_ebs_volume" "jenkins-volume" {
        availability_zone = "us-east-2a"
        size = 20
        type = "gp2"
        tags {
                Name = "jenkins-volume"
    }
}

resource "aws_volume_attachment" "jenkins-volume-attachment" {
    device_name = "${var.INSTANCE_DEVICE_NAME}"
    volume_id = "${aws_ebs_volume.jenkins-volume.id}"
    instance_id = "${aws_instance.jenkins-instance.id}"
}


