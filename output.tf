output "elb" {
  value = "${aws_elb.lab-elb.dns_name}"
}

output "jenkins" {
  value = "${aws_instance.jenkins-instance.public_ip}"
}

output "my_repository" {
  value = "${aws_ecr_repository.nodejs-app.repository_url}"
}