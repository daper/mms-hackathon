resource "google_service_account" "cluster-nodes" {
  account_id   = "cluster-node"
  display_name = "Cluster Node Service Account"
}

resource "google_project_iam_binding" "cluster-nodes" {
  project = var.project_id
  role    = "roles/container.nodeServiceAccount"

  members = [
    "serviceAccount:${google_service_account.cluster-nodes.account_id}@${var.project_id}.iam.gserviceaccount.com",
  ]
}

module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  project_id = var.project_id
  name = "cluster"
  region = var.region
  network = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.cluster.name
  ip_range_pods = "pods"
  ip_range_services = "services"

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-micro"
      min_count                 = 1
      max_count                 = 3
      service_account           = "${google_service_account.cluster-nodes.account_id}@${var.project_id}.iam.gserviceaccount.com"
      initial_node_count        = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  grant_registry_access = true
  enable_private_endpoint = false
}