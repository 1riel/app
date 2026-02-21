
# ssh to server
ssh root@gtr-server


# clone project from github to a specific directory
cd /root
git clone https://github.com/1riel/app.git 1riel_app

# cd to project directory
cd /root/1riel_app


touch .env

# write environment variables to .env file

nano .env

# NOTE: copy and paste the following content to .env file, then save and exit