# bash

## add a line to a file if it does not exist

```bash
grep -q -F ${line_to_add} ${path_to_file}

if [ $? -ne 0 ]; then
  echo ${line_to_add} | tee -a ${path_to_file} > /dev/null
fi
```

## read lines from a config file ignoring comments

```bash
grep -v "^\s*${comment_char}"
```

## testing

### network latency

```bash
sar -n TCP,ETCP 1
```
