resource "aws_efs_file_system" "nextcloud_efs" {
  encrypted        = true
  performance_mode = "generalPurpose"

  tags = {
    Name = "${local.user}-${local.tp}-efs"
  }
}

resource "aws_efs_mount_target" "nextcloud_mount_target" {
  count          = length(aws_subnet.private)
  file_system_id = aws_efs_file_system.nextcloud_efs.id
  subnet_id      = aws_subnet.private[count.index].id

  # Seules les instances du SG "nextcloud" pourront accéder à EFS
  security_groups = [aws_security_group.nextcloud.id]
}
