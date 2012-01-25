#!/bin/bash
#
# BigCouch
#
# chkconfig: 345 13 87
# description: BigCouch is a dynamo-style distributed database based on Apache CouchDB.
# processname: bigcouch
# pidfile: /var/run/bigcouch.pid
#

# Source function library.
. /etc/init.d/functions

if [ -f /etc/sysconfig/bigcouch ]; then
    . /etc/sysconfig/bigcouch
fi

prog="bigcouch"
pidfile=${PIDFILE-/var/run/bigcouch.pid}
lockfile=${LOCKFILE-/var/lock/subsys/bigcouch}
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
        --pidfile=${pidfile} \
        --user=${user} \
        $RUN_ERL -daemon \
        /tmp/${prog}/ \
        /opt/${prog}/var/log \
        "/opt/${prog}/bin/${prog}"
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch ${lockfile}
    return $RETVAL
}

stop() {
    echo -n $"Stopping $prog: "
    killproc -p ${pidfile} -d ${STOP_TIMEOUT}
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f ${lockfile} ${pidfile}
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
