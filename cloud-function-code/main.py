import functions_framework
from googleapiclient.discovery import build

# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def loadData(cloud_event):
    service = build('dataflow', 'v1b3')
    project = "project-practice-439802"

    template_path = "gs://dataflow-templates-us-central1/latest/GCS_Text_to_BigQuery"

    template_body = {
        "jobName": "bq-load",  # Provide a unique name for the job
        "parameters": {
        "javascriptTextTransformGcsPath": "gs://practice-6032-central/udf.js",
        "JSONPath": "gs://practice-6032-central/bqSchema.json",
        "javascriptTextTransformFunctionName": "transform",
        "outputTable": "project-practice-439802.cricket.icc_odi_rankings",
        "inputFilePattern": "gs://project-6032-cricket-data/batsmen_rankings.csv",
        "bigQueryLoadingTemporaryDirectory": "gs://practice-6032-central/temp",
        }
    }

    request = service.projects().templates().launch(projectId=project,gcsPath=template_path, body=template_body)
    response = request.execute()
    print(response)