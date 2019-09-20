resource "aws_key_pair" "adiel-key" {
    key_name = "adiel-key"
    public_key = "${file(var.adiel_public)}"
    lifecycle {
        ignore_changes = ["public_key"]
    }  
}
