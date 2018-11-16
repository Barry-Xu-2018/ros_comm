#!/bin/bash

echo ""
echo "TEST UDS 003 ====================="
echo ""
TESTRES=0

set -x

unset ROS_UDS_EXT_ENABLE
rosrun test_rosuds add_two_ints_server_uds >/dev/null 2>&1  &
SERVICE_SERVERPID1=$!
sleep ${SLEEP_TIME}

if [ -S "${UDS_STREAM_PATH}${SERVICE_SERVERPID1}"-* ]; then
        ls -l "${UDS_STREAM_PATH}${SERVICE_SERVERPID1}"-*
        TESTRES=1
fi

if [ -S "${UDS_DATAGRAM_PATH}${SERVICE_SERVERPID1}"-* ]; then
        ls -l "${UDS_DATAGRAM_PATH}${SERVICE_SERVERPID1}"-*
        TESTRES=1
fi

SERVER_STREAM_COUNT=`get_uds_stream_server_count "${SERVICE_SERVERPID1}"`
if [ ${SERVER_STREAM_COUNT} -ne 0 ]; then
        TESTRES=1
fi

SERVER_DATAGRAM_COUNT=`get_uds_datagram_server_count "${SERVICE_SERVERPID1}"`
if [ ${SERVER_DATAGRAM_COUNT} -ne 0 ]; then
        TESTRES=1
fi

set +x

kill -INT ${SERVICE_SERVERPID1}
wait ${SERVICE_SERVERPID1}

echo ""
if [ ${TESTRES} -eq 0 ]; then
        echo "RESULT: OK"
else
        echo "RESULT: NG"
fi
