#! /bin/bash

pwd
echo 'XX $PWD YY'

find . -type f \( -name "*.sh" -or -name "*.bash" \)

shellcheck ./my-ps1.sh
exit $?
