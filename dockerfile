FROM dorowu/ubuntu-desktop-lxde-vnc:latest

# Remove broken chrome repo
RUN rm -f /etc/apt/sources.list.d/google-chrome.list

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    python3 python3-pip python3-venv python3-dev \
    libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev \
    libportmidi-dev libswscale-dev libavformat-dev libavcodec-dev \
    libfreetype6-dev \
    python3-gevent && \
    rm -rf /var/lib/apt/lists/*

# Environment settings for pygame
ENV DISPLAY=:1
ENV SDL_VIDEODRIVER=x11
ENV SDL_AUDIODRIVER=dummy


WORKDIR /app
COPY . /app

# Create virtual environment
RUN python3 -m venv /app/venv

# Install python packages
RUN /app/venv/bin/pip install --upgrade pip && \
    /app/venv/bin/pip install -r requirements.txt

ENV PATH="/app/venv/bin:$PATH"

# Create startup script for the game
RUN echo '#!/bin/bash\n\
sleep 5\n\
cd /app\n\
source venv/bin/activate\n\
python main.py\n' > /app/start-game.sh

RUN chmod +x /app/start-game.sh

# Start game after LXDE starts
RUN echo "/app/start-game.sh &" >> /etc/xdg/lxsession/LXDE/autostart

EXPOSE 80

CMD ["/startup.sh"]
