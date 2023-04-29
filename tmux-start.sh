#!/bin/sh


# keep session alive at all cose probeing location helps keepine session alive
cat /dev/location > /dev/null &


session1="ipad"
session2="j6"

tmux new-session -d -s $session1
tmux new-session -d -s $session2

window1=0

# window 0 is special, it's already created with a session
# ! so we rename it instead of creating.
tmux rename-window -t $session1:$window1 'man';
tmux send-keys -t $session1:$window1 'top' C-m;
tmux split-window -t $session1:$window1;
tmux send-keys -t $session1:$window1 'man tmux' C-m;

window1=1
tmux new-window -t $session1:$window1 -n 'git'
tmux send-keys -t $session1:$window1 'cd ~/ish' C-m
tmux send-keys -t $session1:$window1 'git fetch --prune --all' C-m

window1=2
tmux new-window -t $session1:$window1 -n 'vim'
tmux send-keys -t $session1:$window1 'vim tmux-start.sh' C-m


###################################################
# Create win in 2nd `session2`
###################################################
window2=0
tmux rename-window -t $session2:$window2 'ssh';
tmux send-keys -t $session2:$window2 'ssh j6' C-m;
# tmux send-keys -t $session2:$window2 'ls -al' C-m;


tmux attach-session -t $session1
