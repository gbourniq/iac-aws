resource "aws_security_group" "dynamic_sg" {
  name        = "dynamic-sg"
  description = "Allowed ingress ports"
  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = var.tags
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-sg"
  description = "SSH access"
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpn_ip]
  }
  tags = var.tags
}