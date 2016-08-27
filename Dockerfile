# docker build -t registry.service.mm.consul:5000/mis_mm_auth .
FROM telminov/ubuntu-14.04-python-3.5
MAINTAINER g10k <g10k@soft-way.biz>

EXPOSE 8080

VOLUME /data/
VOLUME /conf/
VOLUME /static/
VOLUME /logs/

RUN apt-get update && \
    apt-get install -y \
                    python3 \
                    python3-pip \
                    git \
                    nginx \
                    vim \
                    supervisor \
                    scons \
                    gcc \
                    libao4 \
                    libao-dev \
                    pkg-config \
                    npm

# install RHVoice
RUN git clone https://github.com/Olga-Yakovleva/RHVoice.git /opt/RHVoice
WORKDIR /opt/RHVoice
RUN scons && scons install && ldconfig
RUN mkdir /var/log/sw_tts && alias python=python3

# copy source
COPY . /opt/sw_tts
WORKDIR /opt/sw_tts

RUN pip3 install -r requirements.txt
RUN cp sw_tts/local_settings.sample.py sw_tts/local_settings.py

RUN npm install

#COPY supervisor/prod.conf /etc/supervisor/conf.d/sw_tts.conf

CMD test "$(ls /conf/local_settings.py)" || cp sw_tts/local_settings.sample.py /conf/local_settings.py; \
    rm sw_tts/local_settings.py;  ln -s /conf/local_settings.py sw_tts/local_settings.py; \
    rm -rf static; ln -s /static static; \
    python3 ./manage.py migrate; \
    python3 ./manage.py collectstatic --noinput; \
    python3 ./manage.py runserver 0.0.0.0:8080
