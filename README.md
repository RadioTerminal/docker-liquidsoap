# Liquidsoap in Docker
Liquidsoap with aacplus decoder

Run
---

```bash
docker run \
    --name liquidsoap \
    -h liquidsoap \
    -v /opt/liquidsoap:/data:rw \
    --env TZ=Europe/Moscow \
    -p 11333:11333 \
    -p 11334:11334 \
    -d \
    kvaps/liquidsoap
```

Systemd unit
------------

Example of systemd unit: `/etc/systemd/system/liquidsoap.service`

```bash
[Unit]
Description=Liquidsoap
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --name liquidsoap -h liquidsoap -v /opt/liquidsoap:/data --env TZ=Europe/Moscow -p 11334:11334 kvaps/liquidsoap
ExecStop=/usr/bin/docker stop -t 5 liquidsoap ; /usr/bin/docker rm -f liquidsoap

[Install]
WantedBy=multi-user.target
```
