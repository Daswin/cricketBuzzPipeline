from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash.operator import BashOperator
from airflow.util.dates import days_ago

default_args = {
    'owner':'airlfow',
    'start_date':datetime(2024,11,8),
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG('fetch_cricket_stats',
          default_args = default_args,
          description = 'Runs an external Python script to pull cricket odi stat data',
          schedule_interval = '@daily',
          catchup = False)

with dag:
    run_script_task = BashOperator(
        task_id = 'run_upload_script',
        bash_command = 'python /home/airflow/gcs/scripts/extractData.py'
    )