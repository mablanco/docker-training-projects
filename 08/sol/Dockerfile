FROM python:3.6-alpine3.6
WORKDIR /app
COPY app.py .
COPY requirements.txt .
RUN pip install -r requirements.txt
EXPOSE 5000
CMD ["/usr/local/bin/python", "app.py"]
