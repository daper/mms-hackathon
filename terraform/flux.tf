# https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/auth
module "gke_auth" {
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version              = ">= 24.0.0"
  project_id           = google_container_cluster.primary.project
  cluster_name         = google_container_cluster.primary.name
  location             = google_container_cluster.primary.location
}

provider "flux" {
  kubernetes = {
    host = module.gke_auth.host
    token = module.gke_auth.token

    client_certificate     = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
    client_key             = base64decode(google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }

  git = {
    url  = "ssh://git@github.com/daper/mms-cloud-skeleton.git"
    author_name = "David Peralta"
    author_email = "david@daper.email"

    ssh = {
      username    = "git"
      private_key = file("${path.module}/../.ssh/id_rsa")
    }
  }
}

resource "flux_bootstrap_git" "this" {
  path = "flux/cluster"
  kustomization_override = file("${path.module}/../flux/bootstrap/kustomization.yaml")
}