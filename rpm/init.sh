#!/bin/bash
#
# BigCouch
#
# chkconfig: 345 13 87
# description: BigCouch is a dynamo-style distributed database based on Apache CouchDB.
# processname: bigcouch
#

# Source function library.
. /etc/init.d/functions

if [ -f /etc/sysconfig/bigcouch ]; then
    . /etc/sysconfig/bigcouch
fi

prog="bigcouch"
user=${USER-bigcouch}
RETVAL=0
STOP_TIMEOUT=${STOP_TIMEOUT-10}

# Check that networking is up.
if [ "$NETWORKING" = "no" ]; then
    exit 0
fi

[ -f /opt/bigcouch/bin/bigcouch ] || exit 0

start() {
    echo -n $"Starting $prog: "

    export HOME=/home/${prog}
    mkdir -p /tmp/${prog}
    chown ${prog}:${prog} /tmp/${prog}

    RUN_ERL=`find /opt/${prog} -name 'run_erl'`
    daemon \
        --user=${user} \
        $RUN_ERL -daemon \
        /tmp/${prog}/ \
        /opt/${prog}/var/log \
        "/opt/${prog}/bin/${prog}"
    RETVAL=$?
    echo
    return $RETVAL
}

stop() {
    echo -n $"Stopping $prog: "
    for PID in `ps --no-headers -u ${prog} -opid`
    do
        kill $PID
    done
    RETVAL=$?
    echo "OK"
    return $RETVAL
}

restart() {
    stop
    start
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart|reload)
        restart
        ;;
    *)
        echo $"Usage: $0 (start|stop|restart)"
        exit 1
esac

exit $?
