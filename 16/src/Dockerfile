FROM python:3.9.25-bookworm
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py .
ENV FLASK_APP=app
EXPOSE 5000
CMD ["flask", "run", "--host", "0.0.0.0"]
