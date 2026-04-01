import os
import sys


sys.path.append(os.getcwd())


from glob import glob


from server.utilities.Storage import storage as s3
from server.utilities.Database import database as db
from server.utilities.Converter import converter as cvt
from server.Environment import *

# TODO: create bucket with policy

# create buckets
if not s3.bucket_exists(MINIO_BUCKET_PUBLIC):
    s3.make_bucket(MINIO_BUCKET_PUBLIC)

if not s3.bucket_exists(MINIO_BUCKET_PRIVATE):
    s3.make_bucket(MINIO_BUCKET_PRIVATE)


if not s3.get_bucket_policy(MINIO_BUCKET_PUBLIC):
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
files = glob(root_dir=os.getcwd() + "/server", pathname="assets/*")
# print(files)
for f in files:
    f = f.replace("\\", "/")
    if not s3.object_exists(MINIO_BUCKET_PUBLIC, f):
        s3.fput_object(MINIO_BUCKET_PUBLIC, f, os.getcwd() + "/server/" + f)
        cvt.storage_to_thumbnail(f, 100)
        cvt.storage_to_thumbnail(f, 200)


# TODO: create collection with index
