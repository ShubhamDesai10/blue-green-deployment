FROM python:alpine3.14
RUN apk update
RUN pip install --upgrade pip
RUN pip install flask
COPY ./Flask-App/ /root/Flask-App
WORKDIR /root/Flask-App/
EXPOSE 5000
CMD ["python","app.py"]
