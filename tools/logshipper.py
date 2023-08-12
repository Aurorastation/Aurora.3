import os
import time
import shutil
import logging
import datetime
import zipfile
import boto3
from boto3.s3.transfer import TransferConfig
from boto3.s3.transfer import S3Transfer
import click

@click.command()
@click.option('--log_folder', '-l', required=False, default='./data/logs/', help='The path where the logs are stored')
@click.option('--time_diff_minutes', required=False, default=30, help='How many minutes to wait since the last written log\
  before considering the round ended')
@click.option('--bucket_name', '-b', required=True, help='The name of the bucket')
@click.option('--s3_endpoint', '-e', required=True, help='The S3 endpoint, in format protocol://URL:PORT')
@click.option('--s3_access_key', '-a', required=True, help='The S3 public access key')
@click.option('--s3_secret_key', '-s', required=True, help='The S3 secret key')
@click.option('--max_bandwidth_mb', '-mb', type=float, required=False, default=1000, help='The S3 secret key')
@click.option('--verbose', '-v', type=bool, is_flag=True, required=False, help='Run the script in verbose mode')
def main(log_folder: str, bucket_name: str, s3_endpoint: str, s3_access_key: str, s3_secret_key: str, time_diff_minutes: int = 30, verbose: bool = False, max_bandwidth_mb: float = 1000):
    logging.basicConfig(filename=f'{log_folder}/logshipper.log',
                        encoding='utf-8',
                        level=logging.DEBUG if(verbose) else logging.INFO)

    logging.info(
      'Initiating a logshipper run at %s with base directory %s against %s',
      datetime.datetime.now(),
      log_folder,
      s3_endpoint)


    #A list of folders whose rounds have ended, ie no logs has been written for over 30 minutes into
    ended_rounds = list_ended_round_logs(log_folder, time_diff_minutes)

    #For each ended round, zip the folder, upload it, then delete the zip and the original folder
    for item in ended_rounds:
        full_log_path = os.path.join(log_folder, item)
        try:
            logging.debug('Initiating shipping of %s', item)
            zip_folder(full_log_path, f'{full_log_path}.zip')

            upload_archive(
              path=f'{full_log_path}.zip',
              bucket_name=f'{bucket_name}',
              s3_key=f'{item}.zip',
              s3_endpoint=f'{s3_endpoint}',
              s3_access_key=f'{s3_access_key}',
              s3_secret_key=f'{s3_secret_key}',
              max_bandwidth_mb=max_bandwidth_mb)

            logging.debug('%s shipped', item)

            logging.debug('Initiating deletion of %s and %s', f'{full_log_path}.zip', full_log_path)
            os.remove(f'{full_log_path}.zip')
            shutil.rmtree(full_log_path)
            logging.debug('%s and %s deleted', f'{full_log_path}.zip', full_log_path)

            logging.info('Log %s was shipped to destination', item)

        except Exception as exc:
            logging.error('Exception %s encountered while shipping %s', exc, item)

    logging.info('Logshipper completed the run, uploading the following: %s', ended_rounds)


def list_ended_round_logs(path: str, time_diff_minutes: int):
    ended_rounds = list()

    round_log_folders = os.listdir(path)

    for item in round_log_folders:
        full_round_log_path = os.path.join(path, item)

        if(os.path.isdir(full_round_log_path)):
            if(check_last_written_log(full_round_log_path, time_diff_minutes)):
                ended_rounds.append(item)

    print(ended_rounds)
    return ended_rounds



def zip_folder(folder_path, output_path):
    logging.debug('Zipping %s to %s', folder_path, output_path)

    with zipfile.ZipFile(output_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, _, files in os.walk(folder_path):
            for file in files:
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, folder_path)
                zipf.write(file_path, arcname)

    logging.debug('%s successfully zipped to %s', folder_path, output_path)


def upload_archive(path: str, bucket_name: str, s3_key: str, s3_endpoint, s3_access_key, s3_secret_key, max_bandwidth_mb):

    logging.debug('Initiating log upload to %s: %s', bucket_name, path)

    #Creates a session using the S3 credentials
    session = boto3.Session(
        aws_access_key_id=s3_access_key,
        aws_secret_access_key=s3_secret_key
    )

    transfer_config = TransferConfig(
      max_bandwidth=max_bandwidth_mb*1024
    )

    #Opens the client, pointing to the endpoint, and upload the file at the specified path
    s3_client = session.client('s3', endpoint_url=s3_endpoint)
    # s3_client.upload_file(path, bucket_name, s3_key)
    s3_transfer = S3Transfer(s3_client, config=transfer_config)
    s3_transfer.upload_file(path, bucket_name, s3_key)

    logging.debug('Log %s successfully uploaded to %s', path, bucket_name)


def check_last_written_log(path: str, time_diff_minutes: int = 30):
    current_time = time.time()

    #Skip empty folders
    if(not os.listdir(path)):
        return False

    #Checks the files and subfolders (recursively) to determine if every log was last touched more than `time_diff_minutes` ago
    for file in os.listdir(path):
        full_path = os.path.join(path, file)
        if(os.path.isdir(full_path)):
            if(check_last_written_log(full_path, time_diff_minutes)):
                return True

        elif(((current_time - os.path.getmtime(full_path)) / 60) <= time_diff_minutes):
            logging.debug('File %s was found to be less than %s minutes old, item %s will be considered active',
                          file,
                          time_diff_minutes,
                          path)
            return False
    return True


if __name__ == '__main__':
    exit(main())
