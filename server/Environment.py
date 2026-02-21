import os
import sys

sys.path.append(os.getcwd())


# from server.utilities.Debug import debug

from dotenv import load_dotenv

# ? load environment variables
load_dotenv(".env")


# ? General configuration for the application
TITLE = os.getenv("TITLE", "1Riel Application Stage")


# ? Database configuration for the application
MONGO_HOST = "msl-t470"  # if not os.path.isfile("/.dockerenv") else os.getenv("MONGO_HOST", "mongo_stage")
MONGO_PORT = os.getenv("MONGO_PORT", "27027")
MONGO_INITDB_ROOT_USERNAME = os.getenv("MONGO_INITDB_ROOT_USERNAME", "admin")
MONGO_INITDB_ROOT_PASSWORD = os.getenv("MONGO_INITDB_ROOT_PASSWORD", "adminadmin")
MONGO_DATABASE = "database"
MONGO_URL = f"mongodb://{MONGO_INITDB_ROOT_USERNAME}:{MONGO_INITDB_ROOT_PASSWORD}@{MONGO_HOST}:{MONGO_PORT}"


# ? MinIO configuration for the application
MINIO_HOST = "msl-t470"  # if not os.path.isfile("/.dockerenv") else os.getenv("MINIO_HOST", "minio_stage")
MINIO_PORT = os.getenv("MINIO_PORT", "9900")
MINIO_CONSOLE_PORT = os.getenv("MINIO_CONSOLE_PORT", "9901")
MINIO_ROOT_USER = os.getenv("MINIO_ROOT_USER", "admin")
MINIO_ROOT_PASSWORD = os.getenv("MINIO_ROOT_PASSWORD", "adminadmin")
MINIO_BUCKET_PUBLIC = "public"
MINIO_URL = f"{MINIO_HOST}:{MINIO_PORT}"


# ? Telegram Bot configuration
BOT_TOKEN = os.getenv("BOT_TOKEN", "")  # Telegram bot token from environment variable
TELEGRAM_API_URL = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"


# ? Secret key for security purposes
SECRET_KEY = "this_is_a_secret_key_for_1riel_production"


MAX_IMAGE_UPLOAD_SIZE = 10 * 1024 * 1024  # 10 MB
