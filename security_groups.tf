resource "aws_security_group" "lb-sg" {
  provider    = aws.region-master
  name        = "lb-sg"
  description = "Allow 443 and traffic to Jenkins SG"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins-sg" {
  provider    = aws.region-master
  name        = "jenkins-sg"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description     = "allow load balancer sg on web server port"
    from_port       = var.webserver-port
    to_port         = var.webserver-port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  ingress {
    description = "allow traffic from us-east-2"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins-sg-ohio" {
  provider = aws.region-worker

  name        = "jenkins-sg-ohio"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = aws_vpc.vpc_master_ohio.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description = "Allow traffic from us-east-1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}