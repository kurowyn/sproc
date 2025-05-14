# Given a C application that uses the fork() function, generate its 
# corresponding process tree.

file_error() {
	echo -e "ERROR: $1 and $2: one of these does not exist."
	[ -f $1 ] || echo -e "$1: does not exist"
	[ -f $2 ] || echo -e "$2: does not exist"
	echo -e "Exiting."
	exit 1
}

option_error() {
	echo -e "ERROR: invalid kill option."
	echo -e "Valid options are: [kill|nokill]"
	echo -e "Exiting."
	exit 1
}

# Beginning condition: at least 2 args, no more than 3.
# So, equal to 2 or 3.
# This feels like a noobish Bash script.
# If anyone has better ideas, please do not hesitate.
if [ $# -ne 2 -a $# -ne 3 ]; then
	echo -e "usage: bash show_proc_tree.bash (binary) (pidfile) [killopt]"
	echo -e "killopt is \e[3mkill\e[0m by default."
	exit 1
fi

while [ 0 ]; do
	BINARY=$1
	PID_FILE=$2
	KILL_OPT=$3

	[ -f $PID_FILE -a -f $BINARY ] || error $BINARY $PID_FILE
	[ "$KILL_OPT" = "kill" -o "$KILL_OPT" = "nokill" -o "$KILL_OPT" = "" ] || 
		option_error

	echo -e "Listening on file $PID_FILE."

	until [ "$(cat $PID_FILE)" != "" ]; do 
		sleep 1
	done

	echo -e "Process found; PID: $(cat $PID_FILE)"
	[ "$(cat $PID_FILE)" != "" ] && pstree $(cat $PID_FILE)

	PROC_PID_LIST=$(ps -a | grep $BINARY | awk '{print $1}')
	PROC_COUNT=$(echo -e $PROC_PID_LIST | wc -l)

	if [ "$KILL_OPT" = "kill" -o "$KILL_OPT" = ""  ]; then
		for ((i = 1; i <= $PROC_COUNT; ++i)); do
			kill $(echo -e $PROC_PID_LIST | head -$i | tail -1) 2 &> /dev/null
		done
		:> $PID_FILE
	fi

	echo -e "Listening has been paused. Resume listening by pressing on any key."
	read
	clear
done
