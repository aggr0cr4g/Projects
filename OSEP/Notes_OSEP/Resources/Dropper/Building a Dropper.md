### Overall Process
- First, we will pick a payload from `msfvenom` and generate shellcode for the selected staged or non-staged payload
- Adding that payload to `dropper.cpp`
- executing on victim for reverseshell... or whatever the payload is

### Building Shellcode using msfvenom

First of all, select the payload that you want to transform into shellcode.You can see a list of all the Metasploit payloads by using **msfvenom -l payloads**


