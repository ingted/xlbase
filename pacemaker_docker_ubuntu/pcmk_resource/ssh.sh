#!/bin/bash

test -x /usr/sbin/sshd || exit 0

. /lib/lsb/init-functions

function action {
    echo "$1"
    shift
    $@
}
function success {
    echo -n "Success"
}
function failure {
    echo -n "Failed"
}

check_for_upstart() {
    if init_is_upstart; then
        exit $1
    fi
}

check_privsep_dir() {
    if [ ! -d /var/run/sshd ]; then
        mkdir /var/run/sshd
        chmod 0755 /var/run/sshd
    fi
}

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

case "$1" in
    start)
        check_for_upstart 1
        check_privsep_dir
        log_daemon_msg "Starting SSH Server" "sshd" || true
        if start-stop-daemon --start --quiet --oknodo --pidfile /var/run/sshd.pid --exec /usr/sbin/sshd; then
            log_end_msg 0 || true
        else
            log_end_msg 1 || true
        fi
        ;;
    stop)
        check_for_upstart 0
        log_daemon_msg "Stopping SSH Server" "sshd" || true
        if start-stop-daemon --stop --quiet --oknodo --pidfile /var/run/sshd.pid; then
            log_end_msg 0 || true
        else
            log_end_msg 1 || true
        fi
        ;;
    status)
        check_for_upstart 1
        status_of_proc -p /var/run/sshd.pid /usr/sbin/sshd sshd && exit 0 || exit $?
        ;;
    *)
        echo "Usage : ssh.sh {start|stop|status}"
        exit 1

esac

exit 0



