#!/bin/bash
# workaround: start the php-fpm service and stop it again, this will do the necessary configuration
service php5.6-fpm start
service php5.6-fpm stop

#fix the nginx conf
echo "$(eval "echo \"$(cat /etc/nginx/api-upstream)\"")" > /etc/nginx/api-upstream

php-fpm5.6 --fpm-config /etc/php/5.6/fpm/php-fpm.conf --nodaemonize &
pid1=$!
nginx &
pid2=$!

function kill_child_processes {
    kill -$1 $pid1 $pid2
}

function trap_with_signal() {
    func="$1" ; shift
    for sig ; do
        trap "$func $sig" "$sig"
    done
}

trap_with_signal kill_child_processes SIGHUP SIGINT SIGTERM

wait $pid1 $pid2
