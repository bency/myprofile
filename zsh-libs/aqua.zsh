function new_ticket {
    if [[ -z "$1" ]] ;then
        echo "new_ticket: No ticket number specified!";
        echo "usage: new_ticket [TICKET_NUM] [checkout]";
    else
        echo "git push origin master:ticket$1";
        git push origin master:ticket$1;
        if [[ -z "$2" ]] ;then
            git checkout ticket$1;
        fi
    fi
}

function rm_ticket {
    if [[ -z "$1" ]] ;then
        ticket=$(tmux display-message -p '#S');
        echo "rm_ticket: No ticket number specified!";
        echo "use current tmux session name $ticket";
    else
        ticket=$1;
    fi
    echo "git push origin :ticket$ticket";
    git push origin :ticket$ticket;
    echo "git branch -d ticket$ticket";
    git branch -d ticket$ticket;
}

function got_ticket {
    if [[ -z "$1" ]] ;then
        ticket=$(tmux display-message -p '#S');
        echo "No ticket number specified!";
        echo "use current tmux session name $ticket";
    else
        ticket=$1;
    fi
    echo "git checkout ticket$ticket";
    count=$(git branch -a | grep ticket${ticket}$ | wc -l)
    if [[ $count = 0 ]];then
        new_ticket $ticket
    else
        git checkout ticket$ticket;
    fi
}

function new_tag {

    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    branch=${ref#refs/heads/};

    if [ "$branch" != "master" ]; then
        echo "Not in master";
        echo "checkout master";
        git checkout master
    fi

    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    new_branch=${ref#refs/heads/};

    if [ "$new_branch" != "master" ]; then
        echo "Checkout master failed!";
        return;
    fi

    if [[ -z "$1" ]];then
        ticket=$(tmux display-message -p '#S');
        echo "No ticket number specified!";
        echo "use current tmux session name $ticket";
    else
        ticket=$1;
    fi
    echo "git tag -a before$ticket";
    git tag before$ticket -m bofore$ticket;
    echo "git push origin before$ticket";
    git push origin before$ticket;
}

function to_date {
    if [[ -z "$1" ]] ;then
        echo "No unixtime specified!";
    else
        date -jf '%s' "$1" +"%Y-%m-%d %H:%M:%S"
    fi
}

function to_unix {
    date -jf '%Y%m%d%H%M%S' "$1" +%s;
}

function towork {
    repo=$(tmux display-message -p '#W')
    if [ -d $HOME/work/$repo ];then
        rb $repo
    fi
}

rb() { cd $HOME/work/$1; }
compctl -W $HOME/work/ -/ rb
