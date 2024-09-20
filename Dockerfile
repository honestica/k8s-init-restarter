FROM honestica/python:3.11-3162
WORKDIR /app

USER root

RUN pip3 install pipenv==2023.7.11
COPY Pipfile /app
COPY Pipfile.lock /app
RUN pipenv sync --clear --bare --system \
 && rm Pipfile Pipfile.lock

COPY src .

USER appuser

CMD ["python", "main.py"]
