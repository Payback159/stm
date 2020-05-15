#!/usr/bin/env python3

import datetime
import speedtest
from influxdb import InfluxDBClient

# influx configuration
ifuser = "stmuser"
ifpass = "password"
ifdb   = "speedtest"
ifhost = "127.0.0.1"
ifport = 8086
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
