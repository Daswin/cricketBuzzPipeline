terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.18.0"
    }
  }
}

provider "google"{
    project = var.project
    region = var.region
    zone = var.zone
}


# create buckets
resource "google_storage_bucket" "bucket1"{
    name = var.bucket_name1
    location = var.region
    force_destroy = true
    storage_class = "STANDARD" # Optional: Use STANDARD class for regional storage
}

resource "google_storage_bucket" "bucket2"{
    name = var.bucket_name2
    location = var.region
    force_destroy = true
    storage_class = "STANDARD"
}

#UPLOAD FILES
resource "google_storage_bucket_object" "etl_sctipt"{
    bucket = google_storage_bucket.bucket1.id
    name = "extractData.py"
    source = "../extractData.py"
}

resource "google_storage_bucket_object" "json_file"{
    bucket = google_storage_bucket.bucket1.id
    name = "bqSchema.json"
    source = "../bqschema.json"
}

resource "google_storage_bucket_object" "js_file"{
    bucket = google_storage_bucket.bucket1.id
    name = "udf.js"
    source = "../udf.js"
}


# zip folder for load
data "archive_file" "function"{
    type = "zip"
    output_path = "cloud-function.zip"
    source_dir = "../cloud-function-code/"
}

#add to bucket
resource "google_storage_bucket_object" "function"{
    name = "cloud-function.zip"
    bucket = google_storage_bucket.bucket1.name
    source = data.archive_file.function.output_path
}


# cloud function creation
resource "google_cloudfunctions2_function" default {
    name = "dataupload"
    location = var.region
    description = "launches dataflow to push into bigquery"

    build_config{
        runtime = "python39"
        entry_point = "loadData"
        
        source{
            storage_source{
                bucket = google_storage_bucket.bucket1.name
                object = google_storage_bucket_object.function.name
            }
        }
    }

    service_config{
        max_instance_count = 1
        available_memory = "256M"
        timeout_seconds = 60
    }

    event_trigger{
            event_type = "google.cloud.storage.object.v1.finalized"
            service_account_email = var.service_account

            event_filters {
              attribute = "bucket"
              value = google_storage_bucket.bucket2.name
            }
        }

}

