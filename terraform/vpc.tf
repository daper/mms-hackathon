# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc" {
  name                    = "vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "cluster" {
  name          = "cluster"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "172.27.0.0/21"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "172.27.8.0/21"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "172.27.16.0/21"
  }
}