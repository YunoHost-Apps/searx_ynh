#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies="git build-essential libxslt-dev python-dev python-virtualenv python-cffi virtualenv python-babel zlib1g-dev libffi-dev libssl-dev python-lxml uwsgi uwsgi-plugin-python"

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================

# Start (or other actions) a service,  print a log in case of failure and optionnaly wait until the service is completely started
#
# usage: ynh_systemd_action [-n service_name] [-a action] [ [-l "line to match"] [-p log_path] [-t timeout] [-e length] ]
# | arg: -n, --service_name= - Name of the service to reload. Default : $app
# | arg: -a, --action=       - Action to perform with systemctl. Default: start
# | arg: -l, --line_match=   - Line to match - The line to find in the log to attest the service have finished to boot.
#                              If not defined it don't wait until the service is completely started.
#                              WARNING: When using --line_match, you should always add `ynh_clean_check_starting` into your
#                                `ynh_clean_setup` at the beginning of the script. Otherwise, tail will not stop in case of failure
#                                of the script. The script will then hang forever.
# | arg: -p, --log_path=     - Log file - Path to the log file. Default : /var/log/$app/$app.log
# | arg: -t, --timeout=      - Timeout - The maximum time to wait before ending the watching. Default : 300 seconds.
# | arg: -e, --length=       - Length of the error log : Default : 20
ynh_systemd_action() {
    # Declare an array to define the options of this helper.
    declare -Ar args_array=( [n]=service_name= [a]=action= [l]=line_match= [p]=log_path= [t]=timeout= [e]=length= )
    local service_name
    local action
    local line_match
    local length
    local log_path
    local timeout

    # Manage arguments with getopts
    ynh_handle_getopts_args "$@"

    local service_name="${service_name:-$app}"
    local action=${action:-start}
    local log_path="${log_path:-/var/log/$service_name/$service_name.log}"
    local length=${length:-20}
    local timeout=${timeout:-300}

    # Start to read the log
    if [[ -n "${line_match:-}" ]]
    then
        local templog="$(mktemp)"
        # Following the starting of the app in its log
        if [ "$log_path" == "systemd" ] ; then
            # Read the systemd journal
            journalctl --unit=$service_name --follow --since=-0 --quiet > "$templog" &
            # Get the PID of the journalctl command
            local pid_tail=$!
        else
            # Read the specified log file
            tail -F -n0 "$log_path" 2>&1 > "$templog" &
            # Get the PID of the tail command
            local pid_tail=$!
        fi
    fi

    ynh_print_info "${action^} the service $service_name"
    systemctl $action $service_name \
        || ( journalctl --no-pager --lines=$length -u $service_name >&2 \
        ; test -e "$log_path" && echo "--" >&2 && tail --lines=$length "$log_path" >&2 \
        ; false )

    # Start the timeout and try to find line_match
    if [[ -n "${line_match:-}" ]]
    then
        local i=0
        for i in $(seq 1 $timeout)
        do
            # Read the log until the sentence is found, that means the app finished to start. Or run until the timeout
            if grep --quiet "$line_match" "$templog"
            then
                ynh_print_info "The service $service_name has correctly started."
                break
            fi
            if [ $i -eq 3 ]; then
                echo -n "Please wait, the service $service_name is ${action}ing" >&2
            fi
            if [ $i -ge 3 ]; then
                echo -n "." >&2
            fi
            sleep 1
        done
        if [ $i -ge 3 ]; then
            echo "" >&2
        fi
        if [ $i -eq $timeout ]
        then
            ynh_print_warn "The service $service_name didn't fully started before the timeout."
            ynh_print_warn "Please find here an extract of the end of the log of the service $service_name:"
            journalctl --no-pager --lines=$length -u $service_name >&2
            test -e "$log_path" && echo "--" >&2 && tail --lines=$length "$log_path" >&2
        fi
        ynh_clean_check_starting
    fi
}

# Clean temporary process and file used by ynh_check_starting
# (usually used in ynh_clean_setup scripts)
#
# usage: ynh_clean_check_starting
ynh_clean_check_starting () {
	# Stop the execution of tail.
	kill -s 15 $pid_tail 2>&1
	ynh_secure_remove "$templog" 2>&1
}
