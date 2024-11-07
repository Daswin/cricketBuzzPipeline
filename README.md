# cricketBuzzPipeline
pipeline uses composure to retrieve data and push to cloud storage, cloud function upon upload triggers dataflow to push to bigquery


bigquery schema (json file) is required by dataflow so build it after creating dataset

also required is a java script user defined function(UDF) that read the data and pushes it to table


both files (json and js) should be uploaded to bucket so dataflow can see them. Please ensure bucket/s and bigquery are all in the same region of region is specified.

service account permissions:
roles/dataflow.admin
roles/dataflow.serviceAgent
roles/compute.networkUser
roles/storage.objectViewer

Weird discovery: Using a service account triggered errors asking for permision. Leaving service account blank causes no issues and job starts successfully. In actuality it uses the default compute service account. the one I have has a large number of permission attached which is why it was successful

