resource "aws_s3_bucket" "terraform-bucket-lab" {
    bucket = "terraform-bucket-lab"
    acl = "private"

    tags {
        Name = "terraform-bucket-lab"
    }
}