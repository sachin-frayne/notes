#!/usr/bin/env bash

# TODO

function write_to_readme () {
    cat .notes.md > README.md

    for F in *.md
    do
        if [[  ! ${F} == "README.md" ]]
        then
        echo "  * [${F//.md}](${F})" >> README.md
        fi
    done
}
write_to_readme
cd logstash_examples
write_to_readme
