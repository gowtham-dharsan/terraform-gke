resource "google_container_cluster" "default" {
  name        = var.name
  project     = var.project
  description = "Demo GKE Cluster"
  location    = var.location

  remove_default_node_pool = false
  initial_node_count       = var.initial_node_count
  
  release_channel {
    channel = "REGULAR"
    # RAPID, REGULAR, STABLE & UNSPECIFIED - Not setting, take default
  }
  
  enable_shielded_nodes = true
  enable_binary_authorization = false
  
  network policy {
    provider = PROVIDER_UNSPECIFIED
    enabled = false
  }
  
  addons_config{
    http_load_balancing {
      disabled = false 
    }
    horizontal_pod_autoscaling {
      disabled = true
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }
  logging_service = "none"
  monitoring_service = "none"
  
  
  
  
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "default" {
  name       = "${var.name}-node-pool"
  project    = var.project
  location   = var.location
  cluster    = google_container_cluster.default.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

