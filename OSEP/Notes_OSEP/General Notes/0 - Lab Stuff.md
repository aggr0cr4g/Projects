## RDP into VMs
To connect to the remote desktop using **xfreerdp**, run a command of the form:
`xfreerdp` `/f` `/u``:USERNAME` `/p``:PASSWORD` `/v``:HOST[:PORT]`
In this command:
-   **/f** is option means to open the remote desktop in full screen mode
-   **/u:USERNAME** is a name of the account on the computer to which we are connecting
-   **/p:PASSWORD** is a password of the specified account
-   **/v:HOST[:PORT]** is an IP address or name of the computer to which the remote table is connected. PORT optional (recommended: “[Windows Computer name: how to change and use](https://miloserdov.org/?p=4247)”)

For example, I want to open a remote computer desktop with IP address **192.168.0.101**, on which there is a **Tester** user with a password of **1234**, and I want to open a remote working collision in full screen mode, then the command is as follows:
`xfreerdp` `/f` `/u``:Tester` `/p``:1234` `/v``:192.168.0.101`
To toggle between full-screen and windowed modes, use the keyboard shortcut **Ctrl+Alt+Enter**.

