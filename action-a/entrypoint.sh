#! /bin/bash

pwd
find . -type f \( -name "*.sh" -or -name "*.bash" \)

shellcheck ./action-a/entrypoint.sh
exit $?
