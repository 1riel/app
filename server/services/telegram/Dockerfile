# Use an official Python runtime as a parent image
FROM python:3.9-slim-bullseye

# WORKDIR 
WORKDIR /root

# Copy the current directory contents into the container at /app
COPY server /root/server

# Install any needed packages specified in requirements.txt
RUN pip install --upgrade pip 
RUN pip install python-dotenv 
RUN pip install python-telegram-bot

# Make port 8000 available to the world outside this container
# EXPOSE 8000

# Run python script when the container launches
CMD ["python", "server/services/telegram/Application.py"]