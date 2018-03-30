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
    count=$(git branch -a | grep ticket${ticket} | wc -l | tr -d '[[:space:]]')
    if [[ $count = 0 ]];then
        new_ticket $ticket
    else
        echo "git checkout ticket$ticket";
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
    p=`pwd`
    subpath=${p##*work/}
    if [ -d $HOME/work/$subpath ];then
        rb $subpath
    fi
}

function kill-tmux {
    me=$(whoami)
    kill -9 `ps aux | grep $me|grep "tmux: client" | grep -v grep | awk '{print $2}'`
}

##
# 1u04gp 建立需要變身功能的 alpha site
# $ 1u04gp #FROM_TICKET #TO_TICKET
#

function 1u04gp {
    from_ticket=$1
    to_ticket=$2
    if [[ -z $from_ticket ]] || [[ -z $to_ticket ]];then
        echo "required 2 ticket number"
        return
    fi
    if [[ "master" != $from_ticket ]];then
        from_ticket="ticket$from_ticket"
    fi
    orig=$(pwd)

    echo -e "\033[1;34mfrom $from_ticket to $to_ticket"

    repos=(pixfront pixmainpage2 pixpanel2 pixpanel pixapi/api.pixnet.cc pixadmin pixmember pixpixnetid)
    for repo in $repos
    do
        echo $repo
        echo -e "\033[1;31mdeploy $repo\033[0m"
        cd ~/work/$repo && git checkout $from_ticket && git pull && make deploy TICKET=$to_ticket REASON="我要變身！"
    done
    echo "\033[1;31m請使用 adm.p.pixnet.cc.$to_ticket.alpha.pixnet/account/sudo\033[0m"
    cd $orig
}

rb() { cd $HOME/work/$1; }
compctl -W $HOME/work/ -/ rb

rbv() { vim $HOME/work/$1; }
compctl -W $HOME/work/ -f rbv

rdev() {
    cd $HOME/work/pixdev/user/`whoami`/$1;
}
compctl -W $HOME/work/pixdev/user/`whoami`/ -/ rdev

##
# pixnetlog 切換到 /net/pixnetlog/ 看指定的 log 記錄
##
pixnetlog() { cd /net/pixnetlog/$1; }
compctl -W /net/pixnetlog/ -/ pixnetlog

##
# staging-log 懶得開 irc 的時候可以直接用 staging-log php-err.log 看錯誤訊息
# #

staging-log() {ssh staging "tail -f /home/logs/$1"}

function kill-mosh {
    kill $(pgrep -u `id -u` mosh) > /dev/null 2>&1
}

function gv {
    vim -p $(gst | grep modified | cut -d':' -f2)
}
