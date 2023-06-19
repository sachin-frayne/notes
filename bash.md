# bash

### description



## add a line to a file if it does not exist

```bash
grep -q -F ${line_to_add} ${path_to_file}

if [ $? -ne 0 ]; then
  echo ${line_to_add} | tee -a ${path_to_file} > /dev/null
fi
```

## heredoc

### multi-line to file with var

```bash
VAR="baz"
cat <<EOF | tee ${path_to_file}
foo
bar
${VAR}
EOF
```

## netstat

```bash
netstat -tulpn
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
