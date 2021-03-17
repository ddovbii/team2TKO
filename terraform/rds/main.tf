provider "aws" {
  region = var.region
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.medium"
  identifier           = "rds-${var.sandbox_id}"
  name                 = "test"
  username             = random_string.sqlUserIdMaster.result
  password             = random_string.sqlPasswordMaster.result
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "${aws_db_subnet_group.rds.id}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
}

data "aws_vpc" "default" {
  tags = {
    colony-sandbox-id = "${var.sandbox_id}"
  }
}

data "aws_subnet" "app_subnet_0" {
  tags = {
    Name = "app-subnet-0"
    colony-sandbox-id = "${var.sandbox_id}"
  }
}

data "aws_subnet" "app_subnet_1" {
  tags = {
    Name = "app-subnet-1"
    colony-sandbox-id = "${var.sandbox_id}"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-${var.sandbox_id}_sg"
  description = "Allow all inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["${data.aws_vpc.default.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds" {
  name = "rds-${var.sandbox_id}-subnet-group"
  subnet_ids = [data.aws_subnet.app_subnet_0.id, data.aws_subnet.app_subnet_1.id]

  tags = {
    Name = "RDS-subnet-group"
  }
}

resource "random_string" "sqlUserIdMaster" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  number  = false
}

resource "random_string" "sqlPasswordMaster" {
  length  = 19
  special = false
  upper   = true
  lower   = true
}