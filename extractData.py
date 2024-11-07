import requests
import csv
from google.cloud import storage



def pullData():
    url = "https://cricbuzz-cricket.p.rapidapi.com/stats/v1/rankings/batsmen"

    querystring = {"formatType":"odi"}

    headers = {
        "x-rapidapi-key": "37f57654b3msh18dc51fe82df67fp19750djsnac68533accee",
        "x-rapidapi-host": "cricbuzz-cricket.p.rapidapi.com"
    }

    response = requests.get(url, headers=headers, params=querystring)
    return response


def uploadToCloudStorage(csv_filename):
    bucket_name = 'project-6032-cricket-data'
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    destination_blob_name = f'{csv_filename}' #the path to data

    blob = bucket.blob(destination_blob_name)
    blob.upload_from_filename(csv_filename)

    print('Successful upload to bucket')


def main():
    response = pullData()
    
    if response.status_code==200:
        data = response.json().get('rank',[])
        csv_filename = 'batsmen_rankings.csv'

        if data:
            field_names = ['rank','name','country']

            #write data to csv file using specifiv fields
            with open(csv_filename,'w',newline = '',encoding='utf-8') as csvfile:
                writer = csv.DictWriter(csvfile,fieldnames=field_names)
                
                for entry in data:
                    writer.writerow({field:entry.get(field)for field in field_names})

            print(f"Data fetched successfully and written to '{csv_filename}'")

            uploadToCloudStorage(csv_filename)

        else:
            print('No data available for API.')
    else:
        print('Failed to fetch data:', response.status_code)


main()
# uploadToCloudStorage('batsmen_rankings.csv')
