#! /usr/bin/env sh

# Launcher script for the FEREM Downloads server.
#
# This script expects to be located in the "bin" subdirectory of the
# application's distribution. Consequently, the application's working
# directory will point to the parent directory of "bin".

WORKING_DIRECTORY=$0

if [ -L "${WORKING_DIRECTORY}" ];
then
  WORKING_DIRECTORY=`readlink $0`
fi

WORKING_DIRECTORY=`dirname "${WORKING_DIRECTORY}"`
WORKING_DIRECTORY=`readlink -f "${WORKING_DIRECTORY}"/..`

echo "Starting the FEREM Downloads server..."
echo "(Working directory: ${WORKING_DIRECTORY})"

(cd "${WORKING_DIRECTORY}" && \
"${WORKING_DIRECTORY}"/racket/server.rkt "${WORKING_DIRECTORY}")
