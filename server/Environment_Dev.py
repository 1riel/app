SERVER_HOST = "localhost"
SERVER_PORT = 7000

DATABASE_NAME = "database"
DATABASE_USERNAME = "stage"
DATABASE_PASSWORD = "stage"
DATABASE_PORT = 27000
# MongoDB connection URL
DATABASE_URL = f"mongodb://{DATABASE_USERNAME}:{DATABASE_PASSWORD}@{SERVER_HOST}:{DATABASE_PORT}"

# secret key for encryption/decryption
SECRET_KEY = "this secret key is used for stage."

# Create one more bot for development and testing
BOT_TOKEN = ""
