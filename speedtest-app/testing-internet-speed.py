#!/usr/bin/env python3

import os
import datetime
import speedtest
from influxdb import InfluxDBClient

try:  
   ifuser = os.environ["IF_USER"]
   ifpass = os.environ["IF_PASSWORD"]
   ifdb = os.environ["IF_DB"]
   ifhost = os.environ["IF_HOST"]
   ifport = os.environ["IF_PORT"]
except KeyError: 
   print("Please set the needed environment variables")
   sys.exit(1)

measurement_name = "internet"

#speedtest configuration
threads = None

# take a timestamp for this measurement
time = datetime.datetime.utcnow()

s = speedtest.Speedtest()
s.get_best_server()
s.download(threads=threads)
s.upload(threads=threads)
res = s.results.dict()

# format the data as a single measurement for influxdb
body = [
    {
        "measurement": measurement_name,
        "time": time,
        "fields": {
            "download": res["download"],
            "upload": res["upload"],
            "ping": res["ping"]
        }
    }
]

# connect to influx
ifclient = InfluxDBClient(ifhost,ifport,ifuser,ifpass,ifdb)

# write the measurement
ifclient.write_points(body)
