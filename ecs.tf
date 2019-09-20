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
    user_data = "#!/bin/bash\necho 'ECS_CLUSTER=lab_cluster' > /etc/ecs/ecs.config\nstart ecs"
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



