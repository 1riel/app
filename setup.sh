flutter create client --platforms=web


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



# 
SERVICE_NAME=1riel_telegram
systemctl stop ${SERVICE_NAME}.service
systemctl disable ${SERVICE_NAME}.service
rm /etc/systemd/system/${SERVICE_NAME}.service
systemctl daemon-reexec
systemctl daemon-reload

# check port
netstat -tuln | grep 9000