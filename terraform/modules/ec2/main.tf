resource "aws_instance" "myec2" {
  ami           = var.image_id
  instance_type = var.instance_type
}
