
resource "aws_instance" "jenkins-instance" {
    
    ami = "${lookup(var.ECS_AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"
    user_data = <<EOF
        #! /bin/bash
        sudo su
        sudo yum -y install wget zip unzip file
        yum -y update
        vgchange -ay
        mkdir -p /var/lib/jenkins
        echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
        yum -y update
        yum -y install java-1.8.0-openjdk
        sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
        sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
        sudo yum -y install jenkins
        sudo yum -y install docker
        export PATH=/root/.local/bin:$PATH
        sudo yum -y install python36
        wget -q https://bootstrap.pypa.io/get-pip.py
        python3 get-pip.py --user
        pip3 install awscli --user
        curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
        export PATH=/usr/local/bin/:$PATH
        sudo service jenkins start
        sudo chkconfig jenkins on
    EOF
    
    # VPC Subnet
    subnet_id = "${aws_subnet.floor1-public-subnet.id}"

    # Security Group
    security_groups = ["${aws_security_group.jenkins-lab-SEC_Group.id}"]

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


