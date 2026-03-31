# ssh to server
ssh root@msl-t470


apt update && apt upgrade -y
apt install python3-venv -y
apt install python3-pip -y
apt install git -y
apt install nano -y
apt install docker.io -y



# clone project from github to a specific directory
git clone https://github.com/1riel/server.git /root/1riel_server


# cd to project directory
cd /root/1riel_server


# write .env file
touch .env


nano .env
# paste

# linux
python3 -m venv /.venv
source /.venv/bin/activate

# windows
python -m venv .venv
.venv\Scripts\activate

# upgrade pip
python -m pip install --upgrade pip


pip install fastapi[all]
pip install uvicorn
pip install pymongo
pip install minio
pip install requests
pip install ipdb
pip install python-dotenv

pip install pillow
pip install matplotlib
pip install python-telegram-bot

#
pip install opencv-python-headless
pip install insightface
pip install onnxruntime


# development dependencies
pip install jupyter
pip install paramiko

