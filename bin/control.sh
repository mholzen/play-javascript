#!/bin/sh

function setup {
    EXE=play
    root="$( cd "$( dirname "$0" )"/.. && pwd )"
}

function start {
    cd $root
    echo "Starting '$EXE'"

    bin/$EXE >> run/$EXE.stdout 2> run/$EXE.stderr &
    local pid=$!

    echo $pid > run/$EXE.pid
    echo "Running at $pid"
}

function stop {
    cd $root
    echo "Stopping $EXE"
    local pid=$(cat run/$EXE.pid)
    kill -9 $pid
    echo "Killed $pid"
}

function status {
    cd $root
    local pid=$(cat run/$EXE.pid)

    echo "Status of $pid"
    ps -p $pid -f
    # TODO: display uptime
}

function log {
    cd $root
    echo "Logging $EXE.stdout $EXE.stderr"
    tail -f run/$EXE.stdout | sed 's/^/stdout: /' & 
    tail -f run/$EXE.stderr | sed 's/^/stderr: /' 
}

setup
$1