# Speedtest Monitoring (stm)

## Grafana

DataSource InfluxDB

```bash
http://influxdb:8086
```

## Checking Services

```bash
curl -G "http://127.0.0.1:8086/query?pretty=true" --data-urlencode "q=show databases"
```
