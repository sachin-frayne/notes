# bash

## add a line to a file if it does not exist

```bash
function write_line_to_file() {
    if [[ ! -n "$(cat "$2" | grep "$1")" ]]
    then
        echo "${1}" | tee -a "${2}" > /dev/null
    fi
}

write_line_to_file 'line to write' "/path/to/file"
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

## looping

### while

```bash
input="/path/to/file"

while IFS= read -r line; do
  echo "${line}"
done <"${input}"
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
