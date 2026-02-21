import os
import sys

sys.path.append(os.getcwd())

# from server.utilities.Debug import debug


from minio import Minio

from server.Environment import *


class Storage(Minio):
    def __init__(self):
        super().__init__(
            endpoint=MINIO_URL,
            access_key=MINIO_ROOT_USER,
            secret_key=MINIO_ROOT_PASSWORD,
            secure=False,
        )

    def object_exists(self, bucket_name: str, object_name: str) -> bool:
        try:
            self.stat_object(bucket_name, object_name)
            return True
        except Exception:
            return False


s3 = Storage()


# create bucket
if not s3.bucket_exists(MINIO_BUCKET_PUBLIC):
    # create bucket
    s3.make_bucket(MINIO_BUCKET_PUBLIC)

    # set bucket policy for public read-only access
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
