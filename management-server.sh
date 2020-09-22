#!/bin/bash

#VARS - ALTERAR
LGS="/mixmaster/lgs/1"
GMS="/mixmaster/gms/2"
ZS="/mixmaster/zs1/3teste"
LGSDIR="/mixmaster/lgs"
GMSDIR="/mixmaster/gms"
ZSDIR="/mixmaster/zs1"

#SCRIPT
function options(){
echo "1. Start Server"
echo "2. Stop Server"
echo "3. Restart Server"
read -p "Option: " OPTION
case $OPTION in
	1|2|3) confirm;;
	*) echo "Invalid Option"; echo; options;;
esac
}
function confirm(){
read -p "Confirm? (y/n): " CONFIRM
case $CONFIRM in
        y|Y) check;;
        n|N) clear; exit 0;;
        *) confirm;;
esac
}
function check(){
case $OPTION in
	1) check_start;;
	2) check_stop;;
	3) check_restart_stop;;
esac
}
function check_start(){
PS=$(ps aux | grep shadow | grep -v grep | wc -l)
if (( $PS > 0 )); then
	PSZS=$(ps aux | grep zs1 | grep -v grep | wc -l)
	if (( $PSZS == 1 )); then
		echo "Zone Server, Game Server and Login Server is already running"
		exit 0
	else
		PSGMS=$(ps aux | grep gms | grep -v grep | wc -l)
		if (( $PSGMS == 1 )); then
			echo "Game Server and Login Server is already running"
			exit 0
		else
			echo "Login Server is already running"
		fi
		
	fi
else
	started
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
function check_stop(){
PS=$(ps aux | grep shadow | grep -v grep | wc -l)
if (( $PS > 0 )); then
	PSZS=$(ps aux | grep zs1 | grep -v grep | wc -l)
	if (( $PSZS > 0 )); then
		PIDZS=$(ps aux | pgrep -f zs1 | grep -v grep)
		echo "Shutting down Zone Server"
		kill $PIDZS
		echo Wait; sleep 5; echo .; sleep 5; echo .; sleep 5; echo .; sleep 5; echo .; sleep 5; echo .; sleep 5; echo .; sleep 5; echo .;
		echo
		echo "Zone Server disconnected"
		echo
		check_stop
	else
		PSGMS=$(ps aux | grep gms | grep -v grep | wc -l)
		if (( $PSGMS > 0 )); then
			PIDGMS=$(ps aux | pgrep -f gms | grep -v grep)
			echo "Shutting down Game Server"
			kill $PIDGMS
			echo
			echo "Game Server disconnected"
			echo
			check_stop
		else
			PIDLGS=$(ps aux | pgrep -f lgs | grep -v grep)
			echo "Shutting down Login Server"
			kill $PIDLGS
			echo
			echo "Login Server disconnected"
			echo
			echo "Server OFF"
			exit 0
		fi
		
	fi
else
	echo "Server is already stopped"
	exit 0
fi
}
function check_restart_stop(){
PS=$(ps aux | grep shadow | grep -v grep | wc -l)
if (( $PS > 0 )); then
	PSZS=$(ps aux | grep zs1 | grep -v grep | wc -l)
	if (( $PSZS > 0 )); then
		PIDZS=$(ps aux | pgrep -f zs1 | grep -v grep)
		echo "Shutting down Zone Server"
		kill $PIDZS
		echo Wait; sleep 10; echo . && sleep 10 && echo . && sleep 10 && echo . && sleep 10 && echo . && sleep 10; echo . && sleep 10 && echo . && sleep 3
		echo
		echo "Zone Server disconnected"
		echo
		check_restart_stop
	else
		PSGMS=$(ps aux | grep gms | grep -v grep | wc -l)
		if (( $PSGMS > 0 )); then
			PIDGMS=$(ps aux | pgrep -f gms | grep -v grep)
			echo "Shutting down Game Server"
			kill $PIDGMS
			echo
			echo "Game Server disconnected"
			echo
			check_restart_stop
		else
			PIDLGS=$(ps aux | pgrep -f LGS | grep -v grep)
			echo "Shutting down Login Server"
			kill $PIDLGS
			echo
			echo "Login Server disconnected"
			echo
			echo "Server OFF"
			echo "Wait, Turn on Server"
			check_restart_start
		fi
		
	fi
else
	echo "Server is already stopped"
	echo "Wait, Turn on Server"
	check_restart_start
fi
}

function check_restart_start(){
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
}
clear
echo --Management MixMaster Server--
echo ---Create by: Gabriel Costa---
echo
echo "#Date: 22/09"
echo "#Email: g.silvafdc@gmail.com"
echo
options
