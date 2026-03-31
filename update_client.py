import os
import time
import paramiko
from tqdm import tqdm
from dotenv import load_dotenv

# load environment variables
load_dotenv(".env")

# build client
os.system("cd client && python build.py")


# git commit and push
os.system("git add .")
os.system(f'git commit -m "update"')
os.system("git push")


# delay for 10 seconds
for _ in tqdm(range(100), desc="Waiting", unit="s"):
    time.sleep(0.1)


# create SSH client
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# connect to the server
client.connect(
    hostname=os.getenv("SERVER_HOST"),
    port=22,
    username=os.getenv("SERVER_USERNAME"),
    password=os.getenv("SERVER_PASSWORD"),
)

# single line commands
command = [
    "cd /root/1riel",
    # "echo 'Current working directory: ' && pwd",
    "git pull",
    # "echo 'Pulling latest code from GitHub... Done!'",
    "docker-compose -f docker-compose.yml up -d --build client",
    # "echo 'Restarting server... Done!'",
]

# execute commands
stdin, stdout, stderr = client.exec_command(" && ".join(command))
print(stdout.read().decode())


print("Update successfully!")

client.close()
