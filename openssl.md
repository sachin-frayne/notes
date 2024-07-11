# openssl

## showcerts

```bash
echo | openssl s_client -servername ${ip_or_host} -showcerts -connect ${ip_or_host}:${port} 2>/dev/null | awk '/BEGIN/,/END/'
```
