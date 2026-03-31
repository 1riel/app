from utilities.Storage import storage as s3
from Environment import *


# create bucket
if not s3.bucket_exists(MINIO_BUCKET_PUBLIC):
    s3.make_bucket(MINIO_BUCKET_PUBLIC)

if not s3.bucket_exists(MINIO_BUCKET_PRIVATE):
    s3.make_bucket(MINIO_BUCKET_PRIVATE)


# Check if bucket has no policy before setting it
try:
    existing_policy = s3.get_bucket_policy(MINIO_BUCKET_PUBLIC)
    if not existing_policy:
        raise ValueError("No policy found")
except:
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
