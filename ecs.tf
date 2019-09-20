resource "aws_ecs_cluster" "lab_cluster" {
    name = "lab_cluster"
}

resource "aws_launch_configuration" "ecs-lab-LC" {
    name_prefix = "lab-ecs-instance"
    image_id = "${lookup(var.ECS_AMI, var.AWS_REGION)}"
    instance_type = "${var.INSTANCE_TYPE}"
    key_name = "${aws_key_pair.adiel-key.key_name}"
    iam_instance_profile = "${aws_iam_instance_profile.ecs-ec2-lab-role-profile.id}"
    security_groups = ["${aws_security_group.ecs-lab-SEC_Group.id}"]
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
    lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "ecs-lab-autoscaling" {
    name = "ecs-lab-autoscaling"
    vpc_zone_identifier = ["${aws_subnet.floor1-public-subnet.id}", "${aws_subnet.floor2-public-subnet.id}"]
    launch_configuration = "${aws_launch_configuration.ecs-lab-LC.id}"
    min_size = 2
    max_size = 3
    tag {
            key = "Name"
            value = "lab-ecs-instance"
            propagate_at_launch = true
    }
}



