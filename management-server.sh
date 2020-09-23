#!/bin/bash

#VARIAVEIS - ALTERAR
#VARS - SET

#SERVER MODE
# - 0: ONLY 1 SERVER (ONE SERVER)
# - 1: 2 SERVERS (TWO SERVERS)
MODE=1 #DEFAULT: 0

#CASE MODE 0
DIR="/shadow" #FULL PATH
LGS="$DIR/lgs/1" #PATH LGS + FILE LGS
GMS="$DIR/gms/2" #PATH GMS + FILE GMS
ZS="$DIR/zs1/3teste" #PATH ZS + FILE ZS

#CASE MODE 1
#ALTERAR SOMENTE SE TIVER DOIS SERVIDORES MIXMASTER
GMS_SERVER_2="$DIR/gms2/2" #PATH GMS 2 + FILE GMS
ZS_SERVER_2="$DIR/zs2/3" #PATH ZS 2 + FILE ZS

######################################## NAO ALTERAR #####################################################################
########################################## NOT SET #######################################################################

IFS='/' read -r -a ARRAYLGS <<< "$LGS"
IND1=$(echo ${#ARRAYLGS[@]})
let IND2=($IND1-2)
IND=1
lgs="/"
while (( $IND <= $IND2 )); do
	LGSDIR="$lgs${ARRAYLGS[$IND]}/"
	lgs=$LGSDIR
	let IND=($IND+1)
done

IFS='/' read -r -a ARRAYGMS <<< "$GMS"
IND1=$(echo ${#ARRAYGMS[@]})
let IND2=($IND1-2)
IND=1
gms="/"
while (( $IND <= $IND2 )); do
	GMSDIR="$gms${ARRAYGMS[$IND]}/"
	gms=$GMSDIR
	let IND=($IND+1)
done

IFS='/' read -r -a ARRAYZS <<< "$ZS"
IND1=$(echo ${#ARRAYZS[@]})
let IND2=($IND1-2)
IND=1
zs="/"
while (( $IND <= $IND2 )); do
	ZSDIR="$zs${ARRAYZS[$IND]}/"
	zs=$ZSDIR
	let IND=($IND+1)
done

if (( $MODE == 1 )); then
	IFS='/' read -r -a ARRAYGMS2 <<< "$GMS_SERVER_2"
	IND1=$(echo ${#ARRAYGMS2[@]})
	let IND2=($IND1-2)
	IND=1
	gms2="/"
	while (( $IND <= $IND2 )); do
		GMSDIR_2="$gms${ARRAYGMS2[$IND]}/"
		gms2=$GMSDIR_2
		let IND=($IND+1)
	done

	IFS='/' read -r -a ARRAYZS2 <<< "$ZS_SERVER_2"
	IND1=$(echo ${#ARRAYZS2[@]})
	let IND2=($IND1-2)
	IND=1
	zs2="/"
	while (( $IND <= $IND2 )); do
		ZSDIR_2="$zs2${ARRAYZS2[$IND]}/"
		zs2=$ZSDIR_2
		let IND=($IND+1)
	done
fi

function options(){
if (( $MODE == 0 )); then
	echo "1. Start Server"
	echo "2. Stop Server"
	echo "3. Restart Server"
	read -p "Option: " OPTION
	case $OPTION in
		1|2|3) confirm;;
		*) echo "Invalid Option"; echo; options;;
	esac
else
	echo "1. Start"
	echo "2. Stop"
	echo "3. Restart"
	read -p "Option: " OPTION
	case $OPTION in
		1|2|3) clear; options2;;
		*) echo "Invalid Option"; echo; options;;
	esac
fi

}
function options2(){
if (( $OPTION == 1 )); then
	echo "!START SERVER!"
	echo "1. Start only 1 server"
	echo "2. Start all servers"
	echo "3. Back"
	read -p "Option: " OPTION2
	case $OPTION2 in
		1) var_select=1; clear; options_select;;
		2) var_select=2; clear; options_select;;
		3) clear; options;;
		*) echo "Invalid Option"; echo; options2;;
	esac
elif (( $OPTION == 2 )); then
	echo "!STOP SERVER!"
	echo "1. Stop only 1 server"
	echo "2. Stop all servers"
	echo "3. Back"
	read -p "Option: " OPTION2
	case $OPTION2 in
		1) var_select=1; clear; options_select;;
		2) var_select=2; clear; options_select;;
		3) clear; options;;
		*) echo "Invalid Option"; echo; options2;;
	esac
elif (( $OPTION == 3 )); then
	echo "!RESTART SERVER!"
	echo "1. Restart only 1 server"
	echo "2. Restart all servers"
	echo "3. Back"
	read -p "Option: " OPTION2
	case $OPTION2 in
		1) var_select=1; clear; options_select;;
		2) var_select=2; clear; options_select;;
		3) clear; options;;
		*) echo "Invalid Option"; echo; options2;;
	esac
fi
}
function options_select(){
if (( $var_select == 1 )); then
	echo "!SELECT SERVER!"
	echo "1. Server 1"
	echo "2. Server 2"
	echo "3. Back"
	read -p "Option: " OPTION3
	case $OPTION3 in
		1) server_select=1; echo; confirm_2;;
		2) server_select=2; echo; confirm_2;;
		3) clear; options2;;
		*) echo "Invalid Option"; echo; options_select;;
	esac
else
	confirm_2
fi
}
function confirm(){
read -p "Confirm? (y/n): " CONFIRM
case $CONFIRM in
        y|Y) check;;
        n|N) clear; exit 0;;
        *) confirm;;
esac
}

function confirm_2(){
read -p "Confirm? (y/n): " CONFIRM
case $CONFIRM in
        y|Y) check_2;;
        n|N) clear; exit 0;;
        *) confirm_2;;
esac
}
function check(){
case $OPTION in
	1) check_start;;
	2) pre_check_stoped;;
	3) pre_check_reboot;;
esac
}
function check_2(){
case $OPTION in
	1) check_start_2;;
	2) pre_check_stop;;
	3) pre_check_restart;;
esac
}
function pre_check_stop(){
read -p "Stop Login Server (LGS)? (y|n): " QUESTION
case $QUESTION in
	y|Y) yesorno=1; check_stop_2;;
	n|N) yesorno=0; check_stop_2;;
	*) echo "Invalid option"; echo; pre_check_stop;;
esac
}
function pre_check_stoped(){
read -p "Stop Login Server (LGS)? (y|n): " QUESTION
case $QUESTION in
	y|Y) yesorno=1; check_stop;;
	n|N) yesorno=0; check_stop;;
	*) echo "Invalid option"; echo; pre_check_stoped;;
esac
}
function pre_check_restart(){
read -p "Restart Login Server (LGS)? (y|n): " QUESTION
case $QUESTION in
	y|Y) yesorno=1; check_restart_stop_2;;
	n|N) yesorno=0; check_restart_stop_2;;
	*) echo "Invalid option"; echo; pre_check_restart;;
esac
}
function pre_check_reboot(){
read -p "Restart Login Server (LGS)? (y|n): " QUESTION
case $QUESTION in
	y|Y) yesorno=1; check_restart_stop;;
	n|N) yesorno=0; check_restart_stop;;
	*) echo "Invalid option"; echo; pre_check_reboot;;
esac
}
function check_start(){
PSZS=$(ps aux | grep $LGS | grep -v grep | wc -l)
PSGMS=$(ps aux | grep $GMS | grep -v grep | wc -l)
PSLGS=$(ps aux | grep $ZS | grep -v grep | wc -l)
if (( $PSZS > 0 )); then
	echo "Zone Server, Game Server and Login Server is already running"
	exit 0
elif (( $PSGMS > 0 )); then
	echo "Game Server and Login Server is already running"
	exit 0
elif (( $PSLGS > 0 )); then
	echo "Login Server is already running"
	exit 0
else
started
fi

}
function check_start_2(){
if (( $var_select == 1 )); then
	if (( $server_select == 1 )); then
		PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
		PSGMS=$(ps aux | grep $GMS | grep -v grep | wc -l)
		PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
		if (( $PSZS > 0 )); then
			echo "Zone Server, Game Server is already running"
			exit 0
		elif (( $PSGMS > 0 )); then
			echo "Game Server is already running"
			exit 0
		elif (( $PSLGS > 0 )); then
			started_2
		else
			echo "Login Server is not running"
			read -p "Want to start? (y/n)" WANT
			case $WANT in
				Y|y) option_start_lgs=1; started_2;;
				n|n) options;;
				*) check_start_2;;
			esac
		fi
	elif (( $server_select == 2 )); then
		PSZS=$(ps aux | grep $ZS_SERVER_2 | grep -v grep | wc -l)
		PSGMS=$(ps aux | grep $GMS_SERVER_2 | grep -v grep | wc -l)
		PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
		if (( $PSZS > 0 )); then
			echo "Zone Server, Game Server is already running"
			exit 0
		elif (( $PSGMS > 0 )); then
			echo "Game Server is already running"
			exit 0
		elif (( $PSLGS > 0 )); then
			started_2
		else
			echo "Login Server is not running"
			read -p "Want to start? (y/n)" WANT
			case $WANT in
				Y|y) option_start_lgs=1; started_2;;
				n|n) options;;
				*) check_start_2;;
			esac
		fi
	fi
else
	PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
	PSZS2=$(ps aux | grep $ZS_SERVER_2 | grep -v grep | wc -l)
	PSGMS=$(ps aux | grep $GMS | grep -v grep | wc -l)
	PSGMS2=$(ps aux | grep $GMS_SERVER_2 | grep -v grep | wc -l)
	PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
	if (( $PSZS > 0 )); then
		echo "Zone Server 1, Game Server 1 is already running"
		exit 0
	elif (( $PSZS2 > 0 )); then
		echo "Zone Server 2, Game Server 2 is already running"
		exit 0
	elif (( $PSGMS > 0 )); then
		echo "Game Server 1 is already running"
		exit 0
	elif (( $PSGMS2 > 0 )); then
		echo "Game Server 2 is already running"
		exit 0
	elif (( $PSLGS > 0 )); then
		started_2
	else
		echo "Login Server is not running"
		read -p "Want to start? (y/n)" WANT
		case $WANT in
			Y|y) option_start_lgs=1; started_2;;
			n|n) options;;
			*) check_start_2;;
		esac
	fi
fi
}
function started(){
echo "Turning on Login Server"
cd $LGSDIR
$LGS &
echo
echo "Login Server started"
sleep 3

echo

echo "Turning on Game Server"
cd $GMSDIR
$GMS &
echo
echo "Game Server started"
sleep 3

echo

echo "Turning on Zone Server"
cd $ZSDIR
$ZS &
echo
echo "Zone Server started"
sleep 10

echo

echo "Server ON"
exit 0
}
function started_2(){
if (( $var_select == 1 )); then
	if (( $server_select == 1 )); then
		if (( $option_start_lgs == 1 )); then
			echo "Turning on Login Server"
			cd $LGSDIR
			$LGS &
			echo
			echo "Login Server started"
			sleep 3
			echo
		fi
		echo "Turning on Game Server"
		cd $GMSDIR
		$GMS &
		echo
		echo "Game Server started"
		sleep 3
	
		echo

		echo "Turning on Zone Server"
		cd $ZSDIR
		$ZS &
		echo
		echo "Zone Server started"
		sleep 10
	
		echo
	
		echo "Server ON"
		exit 0
	else
		if (( $option_start_lgs == 1 )); then
			echo "Turning on Login Server"
			cd $LGSDIR
			$LGS &
			echo
			echo "Login Server started"
			sleep 3
			echo
		fi
		echo "Turning on Game Server"
		cd $GMSDIR_2
		$GMS_SERVER_2 &
		echo
		echo "Game Server started"
		sleep 3
	
		echo
		
		echo "Turning on Zone Server"
		cd $ZSDIR_2
		$ZS_SERVER_2 &
		echo
		echo "Zone Server started"
		sleep 10
	
		echo
	
		echo "Server ON"
		exit 0
	fi
else
	if (( $option_start_lgs == 1 )); then
		echo "Turning on Login Server"
		cd $LGSDIR
		$LGS &
		echo
		echo "Login Server started"
		sleep 3
		echo
	fi
	echo "Turning on Game Server 1"
	cd $GMSDIR
	$GMS &
	echo
	echo "Game Server 1 started"
	sleep 3

	echo
	
	echo "Turning on Game Server 2"
	cd $GMSDIR_2
	$GMS_SERVER_2 &
	echo
	echo "Game Server 2 started"
	sleep 3

	echo

	echo "Turning on Zone Server 1"
	cd $ZSDIR
	$ZS &
	echo
	echo "Zone Server 1 started"
	sleep 10
	
	echo
	
	echo "Turning on Zone Server 2"
	cd $ZSDIR_2
	$ZS_SERVER_2 &
	echo
	echo "Zone Server 2 started"
	sleep 10
	echo
	echo "Server ON"
	exit 0
fi
}
function check_stop(){
PS=$(ps aux | grep $DIR | grep -v grep | wc -l)
if (( $PS == 0 )); then
	echo "Server is already Shut down"
	exit 0
fi

PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
PSGMS=$(ps aux | grep $GMS | grep -v grep | wc -l)
PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
if (( $PSZS > 0 )); then
	PIDZS=$(ps aux | pgrep -f $ZS | grep -v grep)
	kill $PIDZS
	echo "Shutting down Zone Server"
	echo "wait"
	I=10
	var=1
	stop_zs
elif (( $PSGMS > 0 )); then
	PIDGMS=$(ps aux | pgrep -f $GMS | grep -v grep)
	kill $PIDGMS
	echo "Shutting down Game Server"
	echo
	echo "Game Server disconnected"
	echo
	check_stop
elif (( $yesorno == 1 )); then
	if (( $PSLGS > 0 )); then
		PIDLGS=$(ps aux | pgrep -f $LGS | grep -v grep)
		kill $PIDLGS
		echo "Shutting down Login Server"
		echo
		echo "Login Server disconnected"
		echo
		echo "Server OFF"
		exit 0
	else
		echo "Server OFF"
		exit 0
	fi
else
	echo "Server OFF"
	exit 0
fi
}
function check_stop_2(){
if (( $var_select == 1 )); then
	if (( $server_select == 1 )); then
		PS_1=$(ps aux | grep $ZS | grep -v grep | wc -l)
		PS_2=$(ps aux | grep $GMS | grep -v grep | wc -l)
		if (( $PS_1 == 0 && $PS_2 == 0 )); then
			echo "Server is already Shut down"
			exit 0
		fi
		PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
		PSGMS=$(ps aux | grep $GMS | grep -v grep | wc -l)
		PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
		if (( $PSZS > 0 )); then
			PIDZS=$(ps aux | pgrep -f $ZS | grep -v grep)
			kill $PIDZS
			echo "Shutting down Zone Server"
			echo "wait"
			I=10
			var=1
			state=1
			stop_zs_2
		elif (( $PSGMS > 0 )); then
			PIDGMS=$(ps aux | pgrep -f $GMS | grep -v grep)
			kill $PIDGMS
			echo "Shutting down Game Server"
			echo
			echo "Game Server disconnected"
			echo
			check_stop_2
		elif (( $yesorno == 1 )); then
			if (( $PSLGS > 0 )); then
				PIDLGS=$(ps aux | pgrep -f $LGS | grep -v grep)
				kill $PIDLGS
				echo "Shutting down Login Server"
				echo
				echo "Login Server disconnected"
				echo
				echo "Server OFF"
				exit 0
			else
				echo "Server OFF"
				exit 0
			fi
		else
			echo "Server OFF"
			exit 0
		fi
	elif (( $server_select == 2 )); then
		PS_1=$(ps aux | grep $ZS_SERVER_2| grep -v grep | wc -l)
		PS_2=$(ps aux | grep $GMS_SERVER_2 | grep -v grep | wc -l)
		if (( $PS_1 == 0 && $PS_2 == 0 )); then
			echo "Server is already Shut down"
			exit 0
		fi
		PSZS=$(ps aux | grep $ZS_SERVER_2 | grep -v grep | wc -l)
		PSGMS=$(ps aux | grep $GMS_SERVER_2 | grep -v grep | wc -l)
		PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
		if (( $PSZS > 0 )); then
			PIDZS=$(ps aux | pgrep -f $ZS_SERVER_2 | grep -v grep)
			kill $PIDZS
			echo "Shutting down Zone Server"
			echo "wait"
			I=10
			var=1
			state=2
			stop_zs_2
		elif (( $PSGMS > 0 )); then
			PIDGMS=$(ps aux | pgrep -f $GMS_SERVER_2 | grep -v grep)
			kill $PIDGMS
			echo "Shutting down Game Server"
			echo
			echo "Game Server disconnected"
			echo
			check_stop_2
		elif (( $yesorno == 1 )); then
			if (( $PSLGS > 0 )); then
				PIDLGS=$(ps aux | pgrep -f $LGS | grep -v grep)
				kill $PIDLGS
				echo "Shutting down Login Server"
				echo
				echo "Login Server disconnected"
				echo
				echo "Server OFF"
				exit 0
			else
				echo "Server OFF"
				exit 0
			fi
		else
			echo "Server OFF"
			exit 0
		fi
	fi
else
	PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
	PSGMS=$(ps aux | grep $GMS | grep -v grep | wc -l)
	PSZS2=$(ps aux | grep $ZS_SERVER_2 | grep -v grep | wc -l)
	PSGMS2=$(ps aux | grep $GMS_SERVER_2 | grep -v grep | wc -l)
	PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
	if (( $PSZS > 0 )); then
		PIDZS=$(ps aux | pgrep -f $ZS | grep -v grep)
		kill $PIDZS
		echo "Shutting down Zone Server 1"
		echo "wait"
		I=10
		var=1
		state=1
		stop_zs_2
	elif (( $PSZS2 > 0 )); then
		PIDZS2=$(ps aux | pgrep -f $ZS_SERVER_2 | grep -v grep)
		kill $PIDZS2
		echo "Shutting down Zone Server 2"
		echo "wait"
		I=10
		var=1
		state=2
		stop_zs_2
	elif (( $PSGMS > 0 )); then
		PIDGMS=$(ps aux | pgrep -f $GMS | grep -v grep)
		kill $PIDGMS
		echo "Shutting down Game Server 1"
		echo
		echo "Game Server 1 disconnected"
		echo
		check_stop_2
	elif (( $PSGMS2 > 0 )); then
		PIDGMS2=$(ps aux | pgrep -f $GMS_SERVER_2 | grep -v grep)
		kill $PIDGMS2
		echo "Shutting down Game Server"
		echo
		echo "Game Server 2 disconnected"
		echo
		check_stop_2
	elif (( $yesorno == 1 )); then
		if (( $PSLGS > 0 )); then
			PIDLGS=$(ps aux | pgrep -f $LGS | grep -v grep)
			kill $PIDLGS
			echo "Shutting down Login Server"
			echo
			echo "Login Server disconnected"
			echo
			echo "Server OFF"
			exit 0
		else
			echo "Server OFF"
			exit 0
		fi
	else
		echo "Server OFF"
		exit 0
	fi
	
fi
}
function stop_zs(){
PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
if (( $PSZS > 0 )); then
	sleep 7
	echo "$I%"
	let I=($I+10)
	stop_zs
else
	echo "Zone Server disconnected"
	echo
	if (( $var == 1 )); then
		check_stop
	elif (( $var == 2 )); then
		check_restart_stop
	fi		
fi
}
function stop_zs_2(){
if (( $state == 1 )); then
	PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
elif (( $state == 2 )); then
	PSZS=$(ps aux | grep $ZS_SERVER_2 | grep -v grep | wc -l)
fi
if (( $PSZS > 0 )); then
	sleep 7
	echo "$I%"
	let I=($I+10)
	stop_zs_2
else
	echo "Zone Server disconnected"
	echo
	if (( $var == 1 )); then
		check_stop_2
	elif (( $var == 2 )); then
		check_restart_stop_2
	fi		
fi
}
function check_restart_stop_2(){
if (( $var_select == 1 )); then
	if (( $server_select == 1 )); then
		PS_1=$(ps aux | grep $ZS | grep -v grep | wc -l)
		PS_2=$(ps aux | grep $GMS | grep -v grep | wc -l)
		if (( $PS_1 == 0 && $PS_2 == 0 )); then
			echo "Server is already Shut down"
		fi
		PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
		PSGMS=$(ps aux | grep $GMS | grep -v grep | wc -l)
		PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
		if (( $PSZS > 0 )); then
			PIDZS=$(ps aux | pgrep -f $ZS | grep -v grep)
			kill $PIDZS
			echo "Shutting down Zone Server"
			echo "wait"
			I=10
			var=2
			state=1
			stop_zs_2
		elif (( $PSGMS > 0 )); then
			PIDGMS=$(ps aux | pgrep -f $GMS | grep -v grep)
			kill $PIDGMS
			echo "Shutting down Game Server"
			echo
			echo "Game Server disconnected"
			echo
			check_restart_stop_2
		elif (( $yesorno == 1 )); then
			if (( $PSLGS > 0 )); then
				PIDLGS=$(ps aux | pgrep -f $LGS | grep -v grep)
				kill $PIDLGS
				echo "Shutting down Login Server"
				echo
				echo "Login Server disconnected"
				echo	
				echo Wait
				echo "Starting Server"
				onlgs=1
				check_restart_start_2
			else
				echo "Login Server already Shutdown"
				echo "Starting Server"
				onlgs=1
				check_restart_start_2
			fi
		elif (( $PSLGS > 0 )); then
			echo Wait
			echo "Starting Server"
			onlgs=0
			check_restart_start_2
		else
			echo "Server is not connected"
			echo "Starting Server"
			onlgs=1
			check_restart_start_2
		fi
	elif (( $server_select == 2 )); then
		PS_1=$(ps aux | grep $ZS_SERVER_2| grep -v grep | wc -l)
		PS_2=$(ps aux | grep $GMS_SERVER_2 | grep -v grep | wc -l)
		if (( $PS_1 == 0 && $PS_2 == 0 )); then
			echo "Server is already Shut down"
		fi
		PSZS=$(ps aux | grep $ZS_SERVER_2 | grep -v grep | wc -l)
		PSGMS=$(ps aux | grep $GMS_SERVER_2 | grep -v grep | wc -l)
		PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
		if (( $PSZS > 0 )); then
			PIDZS=$(ps aux | pgrep -f $ZS_SERVER_2 | grep -v grep)
			kill $PIDZS
			echo "Shutting down Zone Server"
			echo "wait"
			I=10
			var=1
			state=2
			stop_zs_2
		elif (( $PSGMS > 0 )); then
			PIDGMS=$(ps aux | pgrep -f $GMS_SERVER_2 | grep -v grep)
			kill $PIDGMS
			echo "Shutting down Game Server"
			echo
			echo "Game Server disconnected"
			echo
			check_stop_2
		elif (( $yesorno == 1 )); then
			if (( $PSLGS > 0 )); then
				PIDLGS=$(ps aux | pgrep -f $LGS | grep -v grep)
				kill $PIDLGS
				echo "Shutting down Login Server"
				echo
				echo "Login Server disconnected"
				echo	
				echo Wait
				echo "Starting Server"
				onlgs=1
				check_restart_start_2
			else
				echo "Login Server already Shutdown"
				echo "Starting Server"
				onlgs=1
				check_restart_start_2
			fi
		elif (( $PSLGS > 0 )); then
			echo Wait
			echo "Starting Server"
			onlgs=0
			check_restart_start_2
		else
			echo "Login Server is not connected"
			echo "Starting Server"
			onlgs=1
			check_restart_start_2
		fi
	fi
else
	PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
	PSGMS=$(ps aux | grep $GMS | grep -v grep | wc -l)
	PSZS2=$(ps aux | grep $ZS_SERVER_2 | grep -v grep | wc -l)
	PSGMS2=$(ps aux | grep $GMS_SERVER_2 | grep -v grep | wc -l)
	PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
	if (( $PSZS > 0 )); then
		PIDZS=$(ps aux | pgrep -f $ZS | grep -v grep)
		kill $PIDZS
		echo "Shutting down Zone Server 1"
		echo "wait"
		I=10
		var=1
		state=1
		stop_zs_2
	elif (( $PSZS2 > 0 )); then
		PIDZS2=$(ps aux | pgrep -f $ZS_SERVER_2 | grep -v grep)
		kill $PIDZS2
		echo "Shutting down Zone Server 2"
		echo "wait"
		I=10
		var=1
		state=2
		stop_zs_2
	elif (( $PSGMS > 0 )); then
		PIDGMS=$(ps aux | pgrep -f $GMS | grep -v grep)
		kill $PIDGMS
		echo "Shutting down Game Server 1"
		echo
		echo "Game Server 1 disconnected"
		echo
		check_stop_2
	elif (( $PSGMS2 > 0 )); then
		PIDGMS2=$(ps aux | pgrep -f $GMS_SERVER_2 | grep -v grep)
		kill $PIDGMS2
		echo "Shutting down Game Server"
		echo
		echo "Game Server 2 disconnected"
		echo
		check_stop_2
	elif (( $yesorno == 1 )); then
		if (( $PSLGS > 0 )); then
			PIDLGS=$(ps aux | pgrep -f $LGS | grep -v grep)
			kill $PIDLGS
			echo "Shutting down Login Server"
			echo
			echo "Login Server disconnected"
			echo
			echo Wait
			echo "Starting Server"
			onlgs=1
			check_restart_start_2
		else
			echo "Login Server already Shutdown"
			echo "Starting Server"
			onlgs=1
			check_restart_start_2
		fi
	elif (( $PSLGS > 0 )); then
		echo Wait
		echo "Starting Server"
		check_restart_start_2
		onlgs=0
	else
		echo "Login Server is not connected"
		echo "Starting Server"
		check_restart_start_2
		onlgs=1
	fi
	
fi
}
function check_restart_stop(){
PS_1=$(ps aux | grep $ZS | grep -v grep | wc -l)
PS_2=$(ps aux | grep $GMS | grep -v grep | wc -l)
if (( $PS_1 == 0 && $PS_2 == 0 )); then
	echo "Server is already Shut down"
fi
PSZS=$(ps aux | grep $ZS | grep -v grep | wc -l)
PSGMS=$(ps aux | grep $GMS | grep -v grep | wc -l)
PSLGS=$(ps aux | grep $LGS | grep -v grep | wc -l)
if (( $PSZS > 0 )); then
	PIDZS=$(ps aux | pgrep -f $ZS | grep -v grep)
	kill $PIDZS
	echo "Shutting down Zone Server"
	echo "wait"
	I=10
	var=2
	stop_zs
elif (( $PSGMS > 0 )); then
	PIDGMS=$(ps aux | pgrep -f $GMS | grep -v grep)
	kill $PIDGMS
	echo "Shutting down Game Server"
	echo
	echo "Game Server disconnected"
	echo
	check_restart_stop
elif (( $yesorno == 1 )); then
	if (( $PSLGS > 0 )); then
		PIDLGS=$(ps aux | pgrep -f $LGS | grep -v grep)
		kill $PIDLGS
		echo "Shutting down Login Server"
		echo
		echo "Login Server disconnected"
		echo	
		echo Wait
		echo "Starting Server"
		onlgs=1
		check_restart_start
	else
		echo "Login Server already Shutdown"
		echo "Starting Server"
		onlgs=1
		check_restart_start
	fi
elif (( $PSLGS > 0 )); then
	echo Wait
	echo "Starting Server"
	onlgs=0
	check_restart_start
else
	echo "Server is not connected"
	echo "Starting Server"
	onlgs=1
	check_restart_start
fi
}
function check_restart_start(){
if (( $onlgs == 1 )); then
	echo "Turning on Login Server"
	cd $LGSDIR
	$LGS &
	echo
	echo "Login Server started"
	sleep 3
fi
echo

echo "Turning on Game Server"
cd $GMSDIR
$GMS &
echo
echo "Game Server started"
sleep 3

echo

echo "Turning on Zone Server"
cd $ZSDIR
$ZS &
echo
echo "Zone Server started"
sleep 10

echo "Server ON"
}
function check_restart_start_2(){
if (( $var_select == 1 )); then
	if (( $server_select == 1 )); then
		if (( $onlgs == 1 )); then
			echo "Turning on Login Server"
			cd $LGSDIR
			$LGS &
			echo
			echo "Login Server started"
			sleep 3
		fi
		echo

		echo "Turning on Game Server"
		cd $GMSDIR
		$GMS &
		echo
		echo "Game Server started"
		sleep 3

		echo

		echo "Turning on Zone Server"
		cd $ZSDIR
		$ZS &
		echo
		echo "Zone Server started"
		sleep 10
	elif (( $server_select == 2 )); then
		if (( $onlgs == 1 )); then
			echo "Turning on Login Server"
			cd $LGSDIR
			$LGS &
			echo
			echo "Login Server started"
			sleep 3
		fi
		echo

		echo "Turning on Game Server"
		cd $GMSDIR_2
		$GMS_SERVER_2 &
		echo
		echo "Game Server started"
		sleep 3

		echo

		echo "Turning on Zone Server 2"
		cd $ZSDIR_2
		$ZS_SERVER_2 &
		echo
		echo "Zone Server 2 started"
		sleep 10
	fi
else
	if (( $onlgs == 1 )); then
		echo "Turning on Login Server"
		cd $LGSDIR
		$LGS &
		echo
		echo "Login Server started"
		sleep 3
	fi
	echo
	echo "Turning on Game Server 1"
	cd $GMSDIR
	$GMS &
	echo
	echo "Game Server 1 started"
	sleep 3

	echo

	echo "Turning on Game Server 2"
	cd $GMSDIR_2
	$GMS_SERVER_2 &
	echo
	echo "Game Server 2 started"
	sleep 3

	echo

	echo "Turning on Zone Server 1"
	cd $ZSDIR
	$ZS &
	echo
	echo "Zone Server 1 started"
	sleep 10

	echo

	echo "Turning on Zone Server 2"
	cd $ZSDIR_2
	$ZS_SERVER_2 &
	echo
	echo "Zone Server 2 started"
	sleep 10
fi
}
clear
echo --Management MixMaster Server--
echo ---Create by: Gabriel Costa---
echo
echo "#Date: 22/09"
echo "#Email: g.silvafdc@gmail.com"
echo
options
