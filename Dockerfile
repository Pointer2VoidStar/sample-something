# pull official base image
FROM python:3.10.0-slim

ENV GITHUB_AUTH_TOKEN=""

RUN echo "machine github.com\
      login ${GITHUB_AUTH_TOKEN}" >> /root/.netrc

# set work directory
WORKDIR /usr/src/app

#############################
# set environment variables #
#############################

# Prevents Python from writing pyc files to disc (equivalent to python -B option)
ENV PYTHONDONTWRITEBYTECODE 1

# Prevents Python from buffering stdout and stderr (equivalent to python -u option)
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    git \
    binutils \
    libproj-dev \
    gdal-bin \          
    && rm -rf /var/lib/apt/lists/*



# install dependencies
RUN pip install --upgrade pip

# copy deps
COPY requirements/base.txt .
COPY requirements/production.txt .

# install requirements
RUN pip install -r production.txt

# copy project
COPY . .

EXPOSE ${PORT}

CMD ["bash", "-c", "python manage.py makemigrations && python manage.py collectstatic --noinput && python manage.py migrate && gunicorn --bind :$PORT config.wsgi --access-logfile - --error-logfile -"]
