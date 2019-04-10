# Allow ingress from trusted networks via ssh
resource "aws_security_group_rule" "bastion_ingress_from_trusted_via_ssh" {
  security_group_id = "${aws_security_group.playground_bastion_sg.id}"
  type = "ingress"
  protocol = "tcp"
  cidr_blocks = "${var.trusted_ingress_networks_ipv4}"
  # ipv6_cidr_blocks = "${var.trusted_ingress_networks_ipv6}"
  from_port = 22
  to_port = 22
}

# Allow ingress from the bastion's public IP via ssh.
#
# We need this because Ansible uses the ssh proxy even when connecting
# to the bastion.
resource "aws_security_group_rule" "bastion_self_ingress" {
  security_group_id = "${aws_security_group.playground_bastion_sg.id}"
  type = "ingress"
  protocol = "tcp"
  cidr_blocks = [
    "${aws_instance.playground_bastion.public_ip}/32"
  ]
  from_port = 22
  to_port = 22
}

# Allow egress to the bastion's public IP via ssh.
#
# We need this because Ansible uses the ssh proxy even when connecting
# to the bastion.
resource "aws_security_group_rule" "bastion_self_egress" {
  security_group_id = "${aws_security_group.playground_bastion_sg.id}"
  type = "egress"
  protocol = "tcp"
  cidr_blocks = [
    "${aws_instance.playground_bastion.public_ip}/32"
  ]
  from_port = 22
  to_port = 22
}

# Allow egress via ssh to the private security group
resource "aws_security_group_rule" "bastion_egress_to_private_sg_via_ssh" {
  security_group_id = "${aws_security_group.playground_bastion_sg.id}"
  type = "egress"
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.playground_private_sg.id}"
  from_port = 22
  to_port = 22
}

# Allow egress via vnc port
resource "aws_security_group_rule" "bastion_egress_for_vnc" {
  security_group_id = "${aws_security_group.playground_bastion_sg.id}"
  type = "egress"
  protocol = "tcp"
  cidr_blocks = [
    "${aws_instance.kali.private_ip}/32"
  ]
  from_port = 5900
  to_port = 5900
}
