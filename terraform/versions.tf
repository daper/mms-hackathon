# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.58.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.19.0"
    }

    flux = {
      source = "fluxcd/flux"
      version = "0.25.3"
    }
  }

  required_version = ">= 0.14"
}