data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "nextcloud" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private[0].id
  key_name               = aws_key_pair.nextcloud.key_name
  vpc_security_group_ids = [aws_security_group.nextcloud.id]

  user_data  = local.nextcloud_userdata
  depends_on = [aws_route_table_association.private]
  tags = {
    Name = "${local.user}-${local.tp}-nextcloud"
  }
}


resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public[0].id
  key_name               = aws_key_pair.bastion.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags = {
    Name = "${local.user}-${local.tp}-bastion"
  }
}

resource "aws_db_instance" "nextcloud_db" {
  identifier             = "${local.user}-nextcloud-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  db_name                = "nextcloud"
  username               = "admin"
  password               = "Test123456789"
  parameter_group_name   = "default.mysql8.0"
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.nextcloud_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.nextcloud.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  tags = {
    Name = "${local.user}-nextcloud-db"
  }
}