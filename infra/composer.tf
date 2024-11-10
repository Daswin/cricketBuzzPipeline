resource "google_composer_environment" "test" {
  name   = "composer1"
  region = var.region
  
  config {

    software_config {
      image_version = "composer-2.9.9-airflow-2.9.3"
    }

    workloads_config {
      scheduler {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
        count      = 1
      }
      web_server {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
      }
      worker {
        cpu = 0.5
        memory_gb  = 1.875
        storage_gb = 1
        min_count  = 1
        max_count  = 3
      }


    }
    environment_size = "ENVIRONMENT_SIZE_SMALL"

    node_config {
      service_account = var.service_account
    }
  }
}
