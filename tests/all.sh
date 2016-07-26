#!/bin/bash

BASEDIR=$(dirname "$0")
LOG=$(mktemp)
STATUS=0

for file in ${BASEDIR}/*.php
do
    echo -n "Running ${file}... "

    rm -f "${LOG}"
    php "${file}" 1>"${LOG}" 2>&1

    if [ $? -ne 0 ]; then
        STATUS=1
        echo "FAIL"
    else
        echo "OK"
    fi

    if [ -f "${LOG}" ]; then
        sed -e 's/^/|  /' "${LOG}"
    fi
done

echo ""

if [ ${STATUS} -ne 0 ]; then
    echo "[!] Tests failed."
    exit ${STATUS}
else
    echo "[*] All tests completed successfully."
fi
