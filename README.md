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

## Development

### building your own speedtest from source

```bash
docker build ./speedtest-app -f Dockerfile -t payback159/speedtest:latest
```
