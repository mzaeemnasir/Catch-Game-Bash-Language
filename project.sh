#!/bin/bash
matrix=('     ' '     ' '     ' '     ' '     ' '     ' '     ' '     ' '     ' '     ' )
basket=('  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' )
index=0
terminal_row=1
terminal_column=0
str="|____|"
pos=0
Score=0
end=$((SECONDS+60))   # Adding Timer - Game play Timer 
Name=" "

#colors 
#ASCII ESCAPE CODES
green="\e[32m"
red='\033[0;31m'
reset='\033[0m'


display_basket() {
    tput cup 10 0
    printf "${basket[*]}"
}

clear_basket() {
basket=('  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' '  -  ' )
}

clear_matrix() {
matrix=('     ' '     ' '     ' '     ' '     ' '     ' '     ' '     ' '     ' '     ' )
}

move_right() {

if [ $pos -eq 9 ]
    then 
        pos=0
        basket[${pos}]=$str
    else
    pos=$((pos+1))   #incrementing +1 in position
    basket[${pos}]=$str
fi
}


move_left() {
if [ $pos -eq 0 ]
    then 
        pos=9
        basket[${pos}]=$str
    else
    pos=$((pos-1))   #incrementing +1 in position
    basket[${pos}]=$str
fi
}


display_matrix(){
tput cup $terminal_row $terminal_column
printf "${matrix[*]}"
terminal_row=$((terminal_row+1))
}



move_basket() {
# initilizing the pos with 0
# this is the postion of our basket
display_basket
read -t 1 -n 1 key
if [[ $key == 'a' ]]  #ddmove left <--
then
clear_basket
move_left
display_basket

    elif [[ $key == 'd' ]]
    then
        clear_basket
        move_right
        display_basket

fi
}



create_random_fruit() {
clear_matrix
index=$((RANDOM%9))

rand=$((RANDOM%2))

if [[ $rand == 0 ]]
then 
    matrix[${index}]="  *  "
else 
    matrix[${index}]="  ${red}#${reset}  "
fi

terminal_row=0

}

calculate_Score(){
    if [ $terminal_row -eq 9 ]
    then
        if [[ $pos == $index && ${matrix[$index]} == "  *  " ]]
        then 
        Score=$((Score+5))
        play -q ./Music/catch.wav
        elif [[ $pos != $index && ${matrix[$index]} == "  ${red}#${reset}  " ]]
        then 
        play -q ./Music/catch.wav
            Score=$((Score+1)) 
        else
        play -q ./Music/loose.wav
            Score=$((Score-4))
        fi
        create_random_fruit
    fi
    tput cup 4 70
        printf "Score: $Score"
        if [ $Score -gt $highscore ]
        then 
        echo $Score >highscore.txt
        fi
}

create_random_fruit

Loading_bar(){
tput cup 7 15
echo -ne "${green}Loading: ######                    (30%)\r"
sleep 1.5
tput cup 7 15
echo -ne 'Loading: ###############           (70%)\r'
sleep 1.5
tput cup 7 15
echo -ne 'Loading: ######################### (100%)\r'
echo -ne "\n ${reset}"
sleep 0.5
play -q ./Music/GameStart.wav
}

#main game 
side_bar()
{
    tput cup 6 70
    printf "${red}Heighest_Score: $highscore $reset"
    tput cup 8 70
    awk -v t=$SECONDS 'BEGIN{t=int(t*1000); printf "Elapsed Time (HH:MM:SS): %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}'
    tput cup 10 70
    echo "TOTAL Time 1:00 minute "
    tput cup 12 70
    printf "Player :  "$Name
    tput cup 14 70
    printf ":: INSTRUCTIONS ::"
    tput cup 16 70 
    printf "${red}#${reset} are Rotten Fruit (-4 Points/+1 Point)"
    tput cup 18 70
    printf "* are Fresh Fruit (+5 Points)"
    tput cup 6 130
    printf " $green Muhammad Bilal Afzal 19F-126 $reset"
    tput cup 8 130
    printf " $green Muhammad Zaeem Nasir 19F-0355 $reset"
    tput cup 10 130
    printf " $green Muhammad Uzair Ramzan 19F-0130 $reset"
}


read -p "Please Enter Your Name:  " Name
clear
toilet -f smblock -F metal Welcome To Catch Game
Loading_bar
clear

while [ $SECONDS -lt $end ];
do
highscore=$(<highscore.txt)
side_bar
calculate_Score
display_matrix
move_basket
clear
done



# when the Game END PRINT The Highest Score : 

toilet -f smblock -F metal "Heighest Score = $highscore"
play -q ./Music/GameOver.mp3
