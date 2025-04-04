#key pair login
resource "aws_key_pair" "my-key" {
  key_name   = "terra-second-project-key"
  public_key = file("terra-second-project-key.pub")
}

#vpc & security group
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "my-security-group" {
  name        = "automate-sg"
  description = "this is security group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http Open"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }

  tags = {
    Name = "automate-sg"
  }
}
#ec2 instance

resource "aws_instance" "second-project" {
  key_name               = aws_key_pair.my-key.key_name
  vpc_security_group_ids = [aws_security_group.my-security-group.id]
  instance_type          = var.ec2_instance_type
  ami                    = var.ec2_ami_id

  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = "second-project"
  }
}