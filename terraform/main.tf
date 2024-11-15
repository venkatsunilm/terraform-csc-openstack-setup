# Security Group 1: SSH, HTTP, and project network access for VM1
resource "openstack_networking_secgroup_v2" "ssh_http_secgroup" {
  name        = "SSH-HTTP_SG1"
  description = "To allow SSH, HTTP, and project network access to VM1 connected to the internet"
}

# SSH access for VM1
resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ssh_http_secgroup.id
}

# HTTP access for VM1
resource "openstack_networking_secgroup_rule_v2" "http_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ssh_http_secgroup.id
}

# Project network access for VM1
resource "openstack_networking_secgroup_rule_v2" "project_network_access_rule_vm1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.ssh_http_secgroup.id
}

# Security Group 2: Private-only access for VMs 2-4
resource "openstack_networking_secgroup_v2" "private_secgroup" {
  name        = "Private-Only"
  description = "To allow full ingress traffic within the project network for VMs 2-4"
}

resource "openstack_networking_secgroup_rule_v2" "project_network_access_rule_vms" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.private_secgroup.id
}

# Floating IP for VM1
resource "openstack_networking_floatingip_v2" "fip_vm1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "fip_vm1_association" {
  floating_ip = openstack_networking_floatingip_v2.fip_vm1.address
  instance_id = openstack_compute_instance_v2.vm1.id
}

# Define VM1 with internet access
resource "openstack_compute_instance_v2" "vm1" {
  name        = "VM1"
  image_name  = "Ubuntu-24.04"
  flavor_name = "standard.small"
  # Apply ssh_http_secgroup to VM1, which now includes SSH, HTTP, and project network access rules
  security_groups = [openstack_networking_secgroup_v2.ssh_http_secgroup.name]

  network {
    name = "project_2011705"
  }
}

# Define VMs 2-4 (private access only)
resource "openstack_compute_instance_v2" "vms" {
  count       = 3
  name        = "VM${count.index + 2}"
  image_name  = "Ubuntu-24.04"
  flavor_name = "standard.small"

  # Apply private_secgroup to VMs 2-4 to allow internal project network access only
  security_groups = [openstack_networking_secgroup_v2.private_secgroup.name]

  network {
    name = "project_2011705"
  }
}
