# docker

## cleanup

```bash
docker container rm $(docker container ls -a -q)
docker network prune
docker volume prune
```

### also clean images

```bash
docker image rm $(docker image ls -a -q)
```

## create ipv6 network

```bash
sudo tee /etc/docker/daemon.json <<-'EOF' >/dev/null
{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8::/64"
}

EOF

sudo docker network create --ipv6 --subnet "2001:db8:1::/64" bridge6
```

## memory

```bash
for i in `awk '{print$1}' ps.txt `; do
  grep -m1 $i stats_samples.txt | tr  '\n' '\t' ;  grep $i  ps.txt | awk '{print$NF}' ;
done
```

```bash
docker stats --all --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```
