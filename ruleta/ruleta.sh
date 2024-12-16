#!/bin/bash

#Colours 
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#variables globales
declare -i contador=0
declare -i dineroTotal=0
line_num=1

function mostrarTitular(){
  tput cup 0 0
  echo -e "\t\t\t\t\t Dinero total: $dineroTotal \t\t\t\t\t\t\t\t Contador: $contador"
}

function ctrl_c(){
  tput cup $((line_num)) 0
  echo -e "\n\n${redColour}[+] Saliendo...${endColour}\n"
  tput cnorm; exit 1
}

function martingala(){
  echo -en "\n${grayColour} Ingrese la apuesta -> ${endColour}" && read bet_size
  echo -en "\n${grayColour} Seleccione pares/impares -> ${endColour}" && read par_impar 
 
  clear
  mostrarTitular



  while true; do
    tput civis
    rand_number="$(echo $(($RANDOM % 37)))"
    
    if [ "$par_impar" == "pares" ]; then
      tput cup $((line_num + 1)) 0
      echo -e "\n\t${grayColour} Apostando ${endColour}${blueColour}$bet_size ${endColour}${grayColour} euros a los numeros ${endColour}${blueColour}$par_impar${endColour}${grayColour} :${endColour}"
      if [ "$(($rand_number % 2))" -eq 0 ]; then
        if [ "$rand_number" -eq 0 ]; then
          echo -e "\t\t${grayColour}Salio el numero${endColour} $rand_number${endColour}${grayColour}, por lo tanto ${endColour}${redColour}PERDEMOS ${endColour}${grayColour}:´(${endColour}\n\n"
          let contador+=1
        else
          echo -e "\t\t${grayColour}Salio el numero${endColour} $rand_number ${endColour}${grayColour}que es par${endColour} ${greenColour}GANAMOS${endColour}${grayColour}!${endColour}\n\n"
          let contador+=1
        fi
    
      else
        echo -e "\t\t${grayColour}Salio el numero${endColour} $rand_number ${endColour}${grayColour}que es impar, por lo tanto ${endColour}${redColour}PERDEMOS ${endColour}${grayColour}:´(${endColour}\n\n"
        let contador+=1
      fi
    
    elif [ "$par_impar" == "impares" ]; then
      echo "\nimpares seleccionados\n"
      tput cnorm; exit 1
    else
      echo "\nseleccion de apuesta erronea\n"
      tput cnorm; exit 1
    fi
    tput cup 0 0
    mostrarTitular

    line_num=$((line_num + 3))
    sleep 0.4

  done
}

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
  echo -e "\t${blueColour}m)${endColour}${grayColour} Cantidad de dinero para jugar -> ${endColour}"
  echo -e "\t${blueColour}t)${endColour}${grayColour} Tecnica a utilizar.${endColour}${blueColour} (${endColour}${purpleColour}martingala${endColour}${blueColour}/${endColour}${purpleColour}labrouchere${endColour}${blueColour})${endColour}"
  echo -e "\t${blueColour}h)${endColour}${grayColour} Mostrar este panel de ayuda..${endColour}"
}
trap ctrl_c INT

while getopts "m:t:h" arg; do
  case $arg in
    m)money=$OPTARG;;
    t)technique=$OPTARG;;
    h);;
  esac
done

if [ $money ] && [ $technique ]; then
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con ${endColour}${blueColour}$money ${endColour}${grayColour}de dinero y usaremos la tecnica ${endColour}${purpleColour}$technique${endColour}${grayColour}.${endColour}"
  dineroTotal=$money
  martingala
else
  helpPanel
fi
