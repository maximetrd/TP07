locals {
  user = "mtardio"                    # Change this to your own username
  tp   = basename(abspath(path.root)) # Get the name of the current directory
  name = "${local.user}-${local.tp}"  # Concatenate the username and the directory name
  tags = {                            # Define a map of tags to apply to all resources
    Name  = "${local.user}-${local.tp}"
    Owner = local.user
  }
  azs = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]

  private_subnets_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets_cidrs  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  nextcloud_userdata = templatefile("${path.module}/userdata/nextcloud.sh.tftpl",
    {
      efs_dns = aws_efs_file_system.nextcloud_efs.dns_name,
      db_name = aws_db_instance.nextcloud_db.db_name,
      db_host = aws_db_instance.nextcloud_db.address,
      db_user = aws_db_instance.nextcloud_db.username,
      db_pass = "Test123456789",
      fqdn    = aws_route53_record.nextcloud.fqdn,
  })
}