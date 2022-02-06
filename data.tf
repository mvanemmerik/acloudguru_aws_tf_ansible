data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

# Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Get Linux AMI ID using SSM Parameter endpoint in us-east-2
data "aws_ssm_parameter" "linuxAmiOhio" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_route53_zone" "dns" {
  provider = aws.region-master
  name     = var.dns-name
}

