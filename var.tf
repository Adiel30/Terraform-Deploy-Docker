variable "AWS_REGION" {
    default = "us-east-2"
}

variable "adiel_private" {
    default = "adiel"
}

variable "adiel_public" {
    default = "adiel.pub"
}

variable "INSTANCE_TYPE" {
    default = "t2.micro"
}

variable "ECS_AMI" {
    default = {
        us-east-2 = "ami-035a1bdaf0e4bf265"
        eu-west-1 = "ami-02bf9e90a6e30dc74"
        eu-west-3 = "ami-084e49fa6ca9c8794"
    }
}

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}

variable "JENKINS_VERSION" {
  default = "2.73.2"
}



