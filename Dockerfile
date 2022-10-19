# pull official base image
FROM ubuntu:18.04

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ARG DEBIAN_FRONTEND=noninteractive

# install psycopg2 dependencies
RUN apt-get update && apt-get install -y bash curl python3.7 build-essential python-psycopg2 python3.7-dev netcat python3.7-distutils libpq-dev python-dev

# install dependencies
COPY requirements.txt .

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN update-alternatives --set python /usr/bin/python3.7

RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py --force-reinstall && \
    rm get-pip.py

RUN pip3 install -r requirements.txt

COPY . .

# CMD python manage.py migrate && uwsgi --socket=0.0.0.0:8002 --module=wsgi.py --processes=5
CMD python manage.py migrate && python manage.py runserver 0.0.0.0:8002