FROM python:alpine

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY testing-internet-speed.py .

CMD [ "python", "./testing-internet-speed.py" ]
