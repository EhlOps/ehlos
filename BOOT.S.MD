# boot.s

As you can see, `boot.s` is written in assembly, which is something that I do not entirely understand. This document aims to explain what `boot.s` really does.

### Command Breakdown

**`.set`**: Declares constant variables for the multiboot header <br/>

- `ALIGN` is set to `1<<0`. This aligns loaded modules on page boundaries
  - The `<<` is the bitwise shift left operator, but it is shifting by `0`
  - This convention is supposedly more clear then writing `.set ALIGN, 1`
- `MEMINFO` is set to `1<<1`, which is equal to `2`
- `FLAGS` is set to `ALIGN | MEMINFO`
  - This is equivalent to `.set FLAGS, 3`
  - `|` is the bitwise OR operation
- `MAGIC` is set to the value of `0x1BADB002`
  - The value `0x1BADB002` is chosen as a unique, identifiable value to use as the multiboot header
  - This lets the bootloader recognize the file as "multiboot compliant"
- `CHECKSUM` is set to `-(MAGIC + FLAGS)` to prove we are in multiboot

**`.section`**: Used to assign or switch to a new section in the assembly code<br/>
**`.multiboot`**: The name of the section being assigned<br/>
**`.align`**: Sets the boundry for future vales<br/>

- In this case, we use `.align 4`
  - This lets the bootloader know that values will be in segments of 4 bytes

**`.long`**: Allocates and initializes space for a 32 bit integer in memeory<br/>
**`stack_bottom`**: A label marking the bottom of the stack<br/>
**`.skip`**: This instuction reserves space in memory but does not initialize it<br/>

- In this case, we skip 16384 bytes, or 16 KB of memory.

**`stack_top`**: This label marks the end of the stack area, or the top of the stack<br/>
**`.text`**: A new section in `boot.s`<br/>
**`.global`**: By declaring a value as global, the value can be accessed outside of `boot.s`<br/>
**`_start`**: The entry point to the kernel<br/>
**`.type`**: Defines a type for a symbol (typically between a function and an object)<br/>
**`@function`**: The function type<br/>
**`cli`**: The Clear Interrupt Flag<br/>

- This instruction disables interrupts, making sure the CPU doesn't listen to interrupt requests

**`1.   hlt`**: Defines a label, `1`, and applies the `hlt` instruction which stops the CPU at the next external interrupt<br/>
**`jmp 1b`**: An intruction that jumps to label `1` in the backwards direction (specified by `b`)<br/>

- This creates an infinite loop where nothing happens
  - Creates a power saving idle loop

**`.size`**: Sets the size of a symbol to a specific value<br/>

- The intruction given, `.size _start, . - _start` sets the size of the `_start` symbol to the current location, `.`, minus the location of its start.
