# sudo chmod +x sources_application/terminal_live.sh

SERVICE_NAME=1riel_application

# restart service
sudo systemctl restart ${SERVICE_NAME}.service

# show live log
journalctl -u ${SERVICE_NAME} -f -o short-iso
# -u: specify the service unit
# -f: follow live log output


########## LOG COMMAND ##########

# Live logs
# SERVICE_NAME=gtr_api
# journalctl -u ${SERVICE_NAME} -f

# Today only
# SERVICE_NAME=gtr_api
# journalctl -u ${SERVICE_NAME} --since today

# Last 100 lines
# SERVICE_NAME=gtr_api
# journalctl -u ${SERVICE_NAME} -n 100

# With ISO timestamps
# SERVICE_NAME=gtr_api
# journalctl -u ${SERVICE_NAME} -o short-iso


# save log to file
# WORKING_DIR=/home/msl/gtr_api
# mkdir -p ${WORKING_DIR}/logs
# touch ${WORKING_DIR}/logs/service.log
# journalctl -u ${SERVICE_NAME} -n 10000 -o short-iso > ${WORKING_DIR}/logs/service.log
# journalctl -u ${SERVICE_NAME} -o short-iso > ${WORKING_DIR}/logs/service.log
