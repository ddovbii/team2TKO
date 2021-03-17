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
  name                 = "test-${var.sandbox_id}"
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

data "aws_subnet_ids" "apps_subnets" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "app-subnet*"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-${var.sandbox_id}_sg"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

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
  subnet_ids = ["${data.aws_subnet_ids.apps_subnets.ids}"]

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