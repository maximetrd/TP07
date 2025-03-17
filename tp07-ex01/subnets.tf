resource "aws_subnet" "public" {
  count = length(local.azs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnets_cidrs[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${local.azs[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count = length(local.azs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnets_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "private-subnet-${local.azs[count.index]}"
  }
}

resource "aws_db_subnet_group" "nextcloud_db_subnet_group" {
  name       = "${local.user}-nextcloud-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = {
    Name = "Nextcloud DB Subnet Group"
  }
}