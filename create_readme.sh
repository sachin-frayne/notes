#!/usr/bin/env bash

# TODO

function write_to_readme () {
    cat .notes.md > readme.md

    for F in *.md
    do
        if [[  ! ${F} == "readme.md" ]]
        then
        echo "  * [${F//.md}](${F})" >> readme.md
        fi
    done
}
write_to_readme
cd elasticsearch_examples
write_to_readme
cd ../logstash_examples
write_to_readme
