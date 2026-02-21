# update and install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install python3-venv python3-pip -y


########## __________ ##########

# create and activate a virtual environment
python3 -m venv .venv_application
source .venv_application/bin/activate

# install required python packages
pip install fastapi[all]
pip install uvicorn
pip install pillow
pip install pymongo
pip install minio
pip install requests
# pip install opencv-python-headless

########## __________ ##########

# create systemd service
SERVICE_NAME=1riel_application
WORKING_DIR=$(pwd)
SOURCE_DIR=$(pwd)/sources_application
# echo ${SERVICE_NAME}
# echo ${WORKING_DIR}
# echo ${SOURCE_DIR}

cat <<EOF | tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null
[Unit]
Description=${SERVICE_NAME}_service
After=network.target

[Service]
User=root
Type=simple
WorkingDirectory=${WORKING_DIR}
ExecStart=/bin/bash -c 'source ${WORKING_DIR}/.venv_application/bin/activate && python ${SOURCE_DIR}/Run.py'
StandardOutput=journal
StandardError=journal
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# start systemd
SERVICE_NAME=1riel_application
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable ${SERVICE_NAME}.service
systemctl start ${SERVICE_NAME}.service

# *[OPTIONAL] check status
# SERVICE_NAME=1riel_application
# systemctl status ${SERVICE_NAME}.service

# ?[OPTIONAL] restart service
# systemctl restart ${SERVICE_NAME}.service
# systemctl status ${SERVICE_NAME}.service

# ?[OPTIONAL] stop service
SERVICE_NAME=1riel_telegram
systemctl stop ${SERVICE_NAME}.service
systemctl disable ${SERVICE_NAME}.service
# ?[OPTIONAL] remove service
rm -rf /etc/systemd/system/${SERVICE_NAME}.service
systemctl daemon-reload




# check port 8000
netstat -tuln | grep 8000