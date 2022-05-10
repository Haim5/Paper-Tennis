#!/bin/bash

#variables
p1_win="PLAYER 1 WINS !"
p2_win="PLAYER 2 WINS !"
play=true
declare -i p1=50
declare -i p2=50
declare -i p1_serve=0
declare -i p2_serve=0
declare -i ball=0

#draw the ball part of the board
draw_ball() {
    case $1 in 

    3)
        echo " |       |       #       |       |O"
        ;;

    2)
        echo " |       |       #       |   O   | "
        ;;

    1)
        echo " |       |       #   O   |       | "
        ;;

    0)
        echo " |       |       O       |       | "
        ;;

    -1)
        echo " |       |   O   #       |       | "
        ;;

    -2)
        echo " |   O   |       #       |       | "
        ;;

    -3)
        echo "O|       |       #       |       | "
        ;;
    esac
}

#print points left
points_left() {
    echo -e " Player 1: ${1}         Player 2: ${2} "
}

#print last play
points_played() {
    echo -e "       Player 1 played: ${1}\n       Player 2 played: ${2}\n\n"
}

#draw the game board
draw_board() {
    points_left $1 $2;
    echo " --------------------------------- ";
    echo " |       |       #       |       | ";
    echo " |       |       #       |       | ";
    draw_ball $3;
    echo " |       |       #       |       | ";
    echo " |       |       #       |       | ";
    echo " --------------------------------- ";
    if [ "$4" = true ]; then
        points_played $5 $6;
    fi
}

#get points from user
get_points() {
    re='^[0-9]+$'
    should_run=true
    invalid="NOT A VALID MOVE !"
    while [ "$should_run" = true ]; do
	echo "PLAYER ${1} PICK A NUMBER: "
	read -s temp
        case $1 in 

        1)          
            p1_serve=$temp
            ;;

        2)
            p2_serve=$temp
            ;;

        esac

        if ! [[ $temp =~ $re ]] ; then
            echo $invalid;
            else if [ $temp -le $2 ]; then
		should_run=false
		else echo $invalid
		fi  
	fi       
    done
}

#calculate where the ball should be - help function
calc_ball_position() {
    if [ "$1" = true ]; then
        if [ $ball -ge 0 ]; then  
            ball=$(( $ball + 1 ));
            else ball=1
        fi
        else if [ $ball -le 0 ]; then 
            ball=$(( $ball - 1 ));
            else ball=-1
        fi
    fi
}

#change ball position accordingly if needed
ball_position() {
    if [ $p1_serve -ne $p2_serve ]; then
        if [ $p1_serve -gt $p2_serve ]; then
            calc_ball_position true;
        else
            calc_ball_position false;
        fi
    fi
}

#handle the case of 0:0
no_points_both() {
    play=false
    if [ $ball -eq 0 ]; then
    echo "IT'S A DRAW !"
    else if [ $ball -gt 0 ]; then
        echo $p1_win
        else echo $p2_win
        fi 
    fi
}

#handle the case only one player ran out of points
no_points() {
    play=false
    if [ $p1 -gt 0 ]; then
        echo $p1_win
        else echo $p2_win
    fi
}

#handle the case of ball out of bounds
out() {
    play=false
    if [ $ball -eq 3 ]; then
        echo $p1_win
        else echo $p2_win
    fi
}

#check if the game should end and print message accordingly
should_end() {
    if [[ $ball -eq 3 || $ball -eq -3 ]]; then
        out
        return
    fi
    if [[ $p1 -eq 0 && $p2 -gt 0 ]]; then 
	no_points
	return
    fi
    if [[ $p2 -eq 0 && $p1 -gt 0 ]]; then 
	no_points
	return
    fi
    if [[ $p1 -eq 0 && $p2 -eq 0 ]]; then
        no_points_both
    fi
}

#main
draw_board $p1 $p2 $ball false
while [[ "$play" = true ]]; do
    get_points 1 $p1
    get_points 2 $p2
    ball_position
    p1=$(( $p1 - $p1_serve ))
    p2=$(( $p2 - $p2_serve ))
    draw_board $p1 $p2 $ball true $p1_serve $p2_serve 
    should_end
done
