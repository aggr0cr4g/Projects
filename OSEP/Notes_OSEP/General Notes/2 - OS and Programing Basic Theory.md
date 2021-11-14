## Programing Theory
CPU preforms actions based on OPCODES based on code that is compiled. The OPCODES are translated to assembly and normally contains data they will process, in the form of operands. Each instruction, mapped to an OPCODE, can be found in the OPCODE Table. 
- `C` and `C++`, for example, are converted to OPCODES when compiled and executed directly by the CPU and must preform their own memory management. 
	- Memory Management in low level langs in the responsiblity of the programer. When you create a var like: `char d[16];` or `int a`.  The variables are created in the "stack". The stack is nice because it's automatic, but it also has two drawbacks:
		- The compiler needs to know in advance how big the variables are
		- The stack space is somewhat limited. For example: in Windows, under default settings for the Microsoft linker, the stack is set to 1 MB
	- The Heap is where you can manually define size of and array of struct, however, if you fail to free it when no longer used it will cause a leak. 

When using programing languages like C# or Java code is compiled into bytecode first. The bytecode is processed by an installed virtual machine. Java uses Java Virtual Machine (JVM) and C# uses Common Language Runtime (CLR) which is part of .NET. The benifit is the heap gets cleaned up on its own or "garbage collection" occours. Either or, once the bytecode is compiled and processed by the VM it is converted to OPCODES and passed to the CPU for execution.