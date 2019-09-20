data "template_file" "adielapp-task-definition-template" {
  template = "${file("templates/app.json.tpl")}"
  vars {
    REPOSITORY_URL = "${replace("${aws_ecr_repository.nodejs-app.repository_url}", "https://", "")}"
    APP_VERSION = "${var.LAB_VERSION}"
  }
}

resource "aws_ecs_task_definition" "adielapp-task-definition" {
    family = "nodejs-app"
    container_definitions = "${data.template_file.adielapp-task-definition-template.rendered}"
}

resource "aws_ecs_service" "adielapp-lab-ecs-service" {
    count = "${var.LAB_SERVICE_ENABLE}"
    name = "nodejs-app"
    cluster = "${aws_ecs_cluster.lab_cluster.id}"
    task_definition = "${aws_ecs_task_definition.adielapp-task-definition.arn}"
    desired_count = 3
    iam_role = "${aws_iam_role.ecs-service-lab-role.arn}"
    depends_on = ["aws_iam_policy_attachment.ecs-service-lab-attach1"]

    load_balancer {
        elb_name = "${aws_elb.lab-elb.name}"
        container_name = "nodejs-app"
        container_port = 3000
    }
    lifecycle { ignore_changes = ["task_definition"] }
}

resource "aws_elb" "lab-elb" {
    name = "lab-elb"
    listener {
        instance_port = 3000
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 30
    target = "HTTP:3000/"
    interval = 60
  }

    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400

    subnets = [
        "${aws_subnet.floor1-public-subnet.id}",
        "${aws_subnet.floor2-public-subnet.id}"]
    security_groups = ["${aws_security_group.elb-lab-SEC_Group.id}"]

    tags {
        Name = "nodejs-app"
    }
}
