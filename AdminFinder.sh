#!/bin/bash
r="\033[1;31m"
g="\033[1;32m"
c="\033[1;36m"
b="\033[1;34m"
n="\033[0m"


banner() {
    echo -en "\n${g}░█████╗░██████╗░███╗░░░███╗██╗███╗░░██╗\n██╔══██╗██╔══██╗████╗░████║██║████╗░██║\n███████║██║░░██║██╔████╔██║██║██╔██╗██║\n██╔══██║██║░░██║██║╚██╔╝██║██║██║╚████║\n██║░░██║██████╔╝██║░╚═╝░██║██║██║░╚███║\n╚═╝░░╚═╝╚═════╝░╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝\n\n███████╗██╗███╗░░██╗██████╗░███████╗██████╗░\n██╔════╝██║████╗░██║██╔══██╗██╔════╝██╔══██╗\n█████╗░░██║██╔██╗██║██║░░██║█████╗░░██████╔╝\n██╔══╝░░██║██║╚████║██║░░██║██╔══╝░░██╔══██╗\n██║░░░░░██║██║░╚███║██████╔╝███████╗██║░░██║\n╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═════╝░╚══════╝╚═╝░░╚═╝\n${c}by ${g}RUR999+\n\n${n}"
}
banner


final() {
    if [ -f ok.txt ];
    then
    clear; banner
    echo -e "\n\n\n"
    while read -r result; do
    echo -en "\n${n}[${c}*${g}FOUND${c}*${n}]${c} Site${n}: ${g} ${result}${n}\n"
    done < "ok.txt"
    if [ -f redirect.txt ];
    then
    while read -r result; do
    echo -en "\n${n}[${c}+${g}REDIRECT${c}+${n}]${c} Site${n}: ${g} ${result}${n}\n"
    done < "redirect.txt"
    else
    echo ""
    fi     
    else
    echo ""
    fi
}

trap ctrl_c INT

ctrl_c() {
    echo -en "\n${n}[${g}*${n}] ${g}Stop Finding...${n}"
    sleep 3
    final
    exit
}

find() {
    rm -rf ok.txt redirect.txt
    clear; banner
    echo -en "${n}\n\n[${g}*${n}] ${c}TARGET${n}:${g} ${link}\n\n\n${n}"
    while read -r list; do
    result=$(curl --write-out '%{http_code}' --silent  --output /dev/null "${link}/${list}")
    if [[ ${result} -ge 200 && ${result} -le 299 ]];
    then
    echo -en "\n${n}[${c}*${g}FOUND${c}*${n}] ${c}Site: ${g}${link}/${list}\n${n}"
    echo "${link}/${list}" >> ok.txt 
    fi
    if [[ ${result} -ge 300 && ${result} -le 399 ]];
    then
    echo -en "\n${n}[${c}+${b}REDIRECT${c}+${n}] ${c}Site: ${g}${link}/${list}\n${n}"
    echo "${link}/${list}" >> redirect.txt 
    fi
    if [[ ${result} -ge 400 && ${result} -le 499 ]];
    then
    echo -en "\n${n}[${c}!${r}ERROR${c}!${n}] ${c}Site: ${r}${link}/${list}${n}\n"
    fi
    done < "list.txt"
    final
    exit
}


main() {
    if [[ $(command -v curl) ]];
    then
    echo ""
    else
    echo -en "${n}[${r}!${n}] ${r}curl ${c}Not Installed. \n${g} Wait For Installing curl${n}"
    pkg install curl -y
    fi
    if [ -f list.txt ];
    then
    echo ""
    else
    echo -en "${n}[${r}!${n}] ${r}Not Found File\n${n}[${g}*${n}] ${g} Wait Downloading List File...\n${n}"
    curl -s -o list.txt https://raw.githubusercontent.com/DH-Alamin/AdminFinder/main/list.txt
    fi
    clear; banner
    echo -en "\n${n}[${g}*${n}] ${c}Enter Site Link ${n}(${c}ex: https://target.com${n}) : ${g}"
    read link
    if [[ -n ${link} ]];
    then
    echo -en ""
    else
    echo -en "\n${n}[${r}-${n}] ${r}You Didn't Enter Anything!!!\n\n${c}"
    echo -en "${n}[${g}*${n}]${g} Press Enter To Continue...\n${n}"
    read -r -s -p $""
    main
    fi
    if curl --output /dev/null --silent --head --fail "${link}";
    then
    find
    else
    echo -en "\n\n${n}[${r}!${n}] ${c}Site: ${r}${link} Site Not Found\n\n\n${n}[${g} +${n} ] ${g}Check URL & Try Again\n\n${c}"
    echo -en "${n}[${g}*${n}]${g} Press Enter To Continue...\n${n}"
    read -r -s -p $""
    main
    fi
}


main
