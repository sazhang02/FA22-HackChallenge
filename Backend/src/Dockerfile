FROM python:3.9.12

RUN mkdir usr/app
WORKDIR usr/app

COPY . .

RUN pip3 install -r requirements.txt

CMD python3 app.py