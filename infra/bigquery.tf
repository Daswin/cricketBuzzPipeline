resource "google_bigquery_dataset" "cricket"{
    dataset_id = "cricket"
    friendly_name = "cricket_dataset"
    description = "Holds cricket data"
    location = var.region
    default_table_expiration_ms = 3600000
    delete_contents_on_destroy = true

    labels = {
        env = "default"
    }
}

resource "google_bigquery_table" "cricket_table"{
    dataset_id = "cricket" #google_bigquery_dataset.cricket.id using the id route triggers a length error
    table_id =  "icc_odi_rankings"

    labels = {
        env = "default"
    }

    deletion_protection = false
}