import os
import sys

sys.path.append(os.getcwd())


from dotenv import load_dotenv

# ? load environment variables
load_dotenv(".env")


# ? General configuration for the application
TITLE = os.getenv("TITLE")


# ? Database configuration for the application
MONGO_HOST = os.getenv("MONGO_HOST") if not os.path.isfile("/.dockerenv") else "mongodb"
MONGO_PORT = 27017
MONGO_INITDB_ROOT_USERNAME = os.getenv("MONGO_INITDB_ROOT_USERNAME")
MONGO_INITDB_ROOT_PASSWORD = os.getenv("MONGO_INITDB_ROOT_PASSWORD")

MONGO_DATABASE = os.getenv("MONGO_DATABASE")
MONGO_URL = f"mongodb://{MONGO_INITDB_ROOT_USERNAME}:{MONGO_INITDB_ROOT_PASSWORD}@{MONGO_HOST}:{MONGO_PORT}"


# ? MinIO configuration for the application
MINIO_HOST = os.getenv("MINIO_HOST") if not os.path.isfile("/.dockerenv") else "minio"
MINIO_PORT = 9000
MINIO_CONSOLE_PORT = 9001
MINIO_ROOT_USER = os.getenv("MINIO_ROOT_USER")
MINIO_ROOT_PASSWORD = os.getenv("MINIO_ROOT_PASSWORD")
MINIO_BUCKET_PUBLIC = "public"
MINIO_BUCKET_PRIVATE = "private"
MINIO_URL = f"{MINIO_HOST}:{MINIO_PORT}"


# ? Telegram Bot configuration
BOT_TOKEN = os.getenv("BOT_TOKEN")  # Telegram bot token from server.Environment variable
TELEGRAM_API_URL = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"


# ? Secret key for security purposes
SECRET_KEY = os.getenv("SECRET_KEY")


MAX_IMAGE_UPLOAD_SIZE = 10 * 1024 * 1024  # 10 MB
