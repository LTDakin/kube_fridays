FROM python:3.12

# Set the working directory on the docker instance
WORKDIR /app

# Copy the poetry files to the working directory
COPY pyproject.toml poetry.lock /app/

# Install poetry and the dependencies without a virtual environment
RUN curl -sSL https://install.python-poetry.org | python3 - && \
  export PATH="/root/.local/bin:$PATH" && \
  poetry config virtualenvs.create false && \
  poetry install --no-dev --no-interaction

# Copy the rest of the files to the working directory
COPY . /app/

EXPOSE 80

ENTRYPOINT [ "/usr/local/bin/gunicorn", "mysite.wsgi", "-b", "0.0.0.0:80", "--access-logfile", "-", "--error-logfile", "-", "-k", "gevent", "--timeout", "300", "--workers", "2"]
