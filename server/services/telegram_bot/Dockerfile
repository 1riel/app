FROM python:3.12-slim

RUN python -m pip install --upgrade pip

RUN pip install python-telegram-bot 
RUN pip install python-dotenv
RUN pip install ipdb

COPY server/services/telegram_bot/App.py server/services/telegram_bot/App.py
COPY server/utilities/Debug.py server/utilities/Debug.py
COPY server/Environment.py server/Environment.py


CMD [ "python", "server/services/telegram_bot/App.py" ]