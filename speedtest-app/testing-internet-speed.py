#!/usr/bin/env python3

import os
import schedule
import time
import datetime
import speedtest
from influxdb import InfluxDBClient

try:  
   ifuser = os.environ["IF_USER"]
   ifpass = os.environ["IF_PASSWORD"]
   ifdb = os.environ["IF_DB"]
   ifhost = os.environ["IF_HOST"]
   ifport = os.environ["IF_PORT"]
   minterval = int(os.environ["MEASUREMENT_INTERVAL"])
except KeyError: 
   print("Please set the needed environment variables")
   sys.exit(1)

def measure_internet():
  # take a timestamp for this measurement
  time = datetime.datetime.utcnow()
  measurement_name = "internet"  

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

  # write the measurement
  ifclient.write_points(body)

#speedtest configuration
threads = None

#open connection to database
ifclient = InfluxDBClient(ifhost,ifport,ifuser,ifpass,ifdb)

#setup scheduler
schedule.every(minterval).minutes.do(measure_internet)

while 1:
  schedule.run_pending()
  time.sleep(1)
