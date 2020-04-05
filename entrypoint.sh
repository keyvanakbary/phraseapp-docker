#!/bin/sh

set -e

# Allow the container to be started with `-e UID=`
if [ "$UID" != "" ]; then
    chown -R $UID:$UID /code

    set -- gosu $UID:$UID "$@"
fi

exec "$@"