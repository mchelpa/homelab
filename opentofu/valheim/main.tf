terraform {
    required_providers {
        hcloud = {
            source = "hetznercloud/hcloud"
            version = "~> 1.48"
        }
    }
}

variable "hcloud_token" {
    sensitive = true
}

provider "hcloud" {
    token = var.hcloud_token
}

resource "hcloud_ssh_key" "valheim_ssh_key" {
    name       = "Valheim_MBP_ssh_key"
    public_key = file("../../.ssh/valheim/mbp_id_rsa.pub")
    labels = {
        "project" : "valheim"
    }
}

resource "hcloud_primary_ip" "valheim_primary_ip" {
    name          = "valheim_primary_ip"
    datacenter    = "hel1-dc2"
    type          = "ipv4"
    assignee_type = "server"
    auto_delete   = true
    labels = {
        "project" : "valheim"
    }
}

resource "hcloud_server" "valheim_server" {
    name        = "valheim-srv"
    image       = "ubuntu-24.04"
    server_type = "cx22"
    datacenter  = "hel1-dc2"
    labels = {
        "project" : "valheim"
    }
    ssh_keys = [
        hcloud_ssh_key.valheim_ssh_key.id
    ]
    public_net {
        ipv4_enabled = true
        ipv4 = hcloud_primary_ip.valheim_primary_ip.id
        ipv6_enabled = false
    }
}
