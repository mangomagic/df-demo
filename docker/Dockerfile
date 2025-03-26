#
# Demo Docker App
#

# See official Python images https://hub.docker.com/_/python
ARG PYTHON_IMAGE_TAG="3.10-slim"

FROM python:${PYTHON_IMAGE_TAG}

# Linux packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        locales \
    && rm -rf /var/lib/apt/lists/*

# Locale
RUN echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen \
    && echo "en_GB.UTF-8 UTF-8" >>/etc/locale.gen \
    && locale-gen

# Python config
ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONHASHSEED=random

# Poetry config
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME="/opt/poetry" \
    POETRY_VERSION=1.8.2

# Set the working directory in the container
WORKDIR /app

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - --version ${POETRY_VERSION} \
    && ln -s ${POETRY_HOME}/bin/poetry /usr/local/bin/poetry

# Copy the pyproject.toml and poetry.lock files into the container
COPY /app/pyproject.toml /app/poetry.lock* ./

# Project initialization
RUN poetry install --no-root --no-dev --no-ansi

# Copy the rest of the application code into the container
COPY /app .

# Create a non-root user and switch to that user
ARG ID=1000
ARG USER=appuser
RUN addgroup --gid ${ID} ${USER} \
    && useradd --system --home /app --uid ${ID} --gid ${ID} ${USER} \
    && chown ${USER}:${USER} /app
USER ${USER}

# Expose the port the app runs on
EXPOSE 5050

# Health check
HEALTHCHECK CMD curl --fail http://localhost:5050/ || exit 1

# Command to run the application
CMD ["gunicorn", "--bind", "0.0.0.0:5050", "app:app"]
