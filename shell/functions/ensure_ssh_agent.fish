# This is the originally from repo below, I just renamed the function and added
# logic to skip this if the environment file doesn't exist yet.
# https://github.com/ivakyb/fish_ssh_agent/tree/master

function __ssh_agent_is_started -d "check if ssh agent is already started"
    if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
        source $SSH_ENV > /dev/null
    end

    if test -z "$SSH_AGENT_PID"
        return 1
    end

    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent
    return $status
end

function __ssh_agent_start -d "start a new ssh agent"
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    chmod 600 $SSH_ENV
    source $SSH_ENV > /dev/null
    true  # suppress errors from setenv, i.e. set -gx
end

function ensure_ssh_agent --description "Start ssh-agent if not started yet, or uses already started ssh-agent."
    set -l envfile "$HOME/.ssh/environment"
    if test -z "$SSH_ENV"
        if not test -f "$envfile"
            return 0
        end

        set -xg SSH_ENV "$envfile"
    end

    if not __ssh_agent_is_started
        __ssh_agent_start
    end
end
