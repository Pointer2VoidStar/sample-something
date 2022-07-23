# pull official base image
FROM python:3.10.0-slim

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
    && rm -rf /var/lib/apt/lists/*



# install dependencies
RUN pip install --upgrade pip

# copy deps
COPY requirements/base.txt .
COPY requirements/local.txt .

# install requirements
RUN pip install -r local.txt

# copy project
COPY . .

EXPOSE 8000

CMD ["bash", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
