import os
import sys


sys.path.append(os.getcwd())

from glob import glob

from utilities.Database import database as db
from utilities.Storage import storage as s3
from utilities.Converter import converter as cvt
from Environment import *


# create buckets
if not s3.bucket_exists(MINIO_BUCKET_PUBLIC):
    s3.make_bucket(MINIO_BUCKET_PUBLIC)

if not s3.bucket_exists(MINIO_BUCKET_PRIVATE):
    s3.make_bucket(MINIO_BUCKET_PRIVATE)


# set bucket policy
policy = f"""{{
    "Version": "2012-10-17",
    "Statement": [
        {{
            "Effect": "Allow",
            "Principal": {{"AWS": ["*"]}},
            "Action": ["s3:GetObject"],
            "Resource": ["arn:aws:s3:::{MINIO_BUCKET_PUBLIC}/*"]
        }},
        {{
            "Effect": "Allow",
            "Principal": {{"AWS": ["*"]}},
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::{MINIO_BUCKET_PUBLIC}"]
        }}
    ]
}}"""


s3.set_bucket_policy(MINIO_BUCKET_PUBLIC, policy)


# TODO: add sample data to storage


# read all file
files = glob("assets/*")
for f in files:
    s3.fput_object(MINIO_BUCKET_PUBLIC, f.replace("\\", "/"), f.replace("\\", "/"))
    cvt.file_to_thumbnail(f.replace("\\", "/"), 100)
    cvt.file_to_thumbnail(f.replace("\\", "/"), 200)
