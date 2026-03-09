FROM python:3.14-bookworm

WORKDIR /app

# install pipenv
RUN pip install pipenv

# copy dependency files first (better layer caching)
COPY Pipfile Pipfile.lock ./

# install dependencies into system
RUN pipenv install --system --deploy

# copy the rest of the project
COPY . .

# expose Flask port
EXPOSE 5000

# run the app
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--chdir", "app", "app:app"]