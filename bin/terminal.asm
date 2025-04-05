.global _start

.text

_start:
    // Set the color palette
    mov r0, #0x03        // AL = 0x03 (color)
    mov r1, #0x03C8      // Port 0x03C8
    bl outb              // Call outb to output to port

    // Set up memory addresses
    ldr r1, =0xB8000     // EDI = 0xB8000 (Text memory)
    ldr r2, =msg         // ESI = msg (string pointer)

print_char:
    ldrb r0, [r2]        // AL = *ESI (load byte from msg)
    cmp r0, #0           // Compare AL with 0 (end of string)
    beq read_keyboard    // Jump if zero (end of string)

    mov r3, #0x0F       // AH = 0x0F (white color)
    orr r1, r3, r0      // AX = AH + AL (combine AH and AL into r1)
    strh r1, [r1]       // Store word in video memory (EDI)
    add r1, r1, #2      // Move to the next character in video memory
    add r2, r2, #1      // Move to the next character in the string
    b print_char        // Repeat

msg:
    .asciz "Welcome to StOS!\r\nStOS $ "

newcommand:
    .asciz "\r\nStOS $ "

read_keyboard:
    // Here, we would check if the Enter key was pressed
    // ARM doesn't directly support outb or iret in the same way as x86,
    // so we will need a mechanism to read from the keyboard.
    // We'll assume we check the value from the keyboard or some interrupt.
    
    // If the Enter key was pressed (just an example of a keyboard read)
    mov r0, #0x1C       // 0x1C = Enter key scan code
    cmp r0, #0x1C
    beq print_new_command

    // Default action: print character
    mov r3, #0x0F       // AH = 0x0F (white text color)
    strh r3, [r1]       // Store the character into video memory
    add r1, r1, #2      // Prepare for next character

    // Loop back to wait for the next character
    b read_keyboard

print_new_command:
    ldr r2, =newcommand  // Load address of newcommand
new_command_loop:
    ldrb r0, [r2]        // AL = *ESI (load byte from newcommand)
    cmp r0, #0           // Compare AL with 0 (end of string)
    beq read_keyboard    // Jump back to reading keyboard if end of new command

    mov r3, #0x0F        // AH = 0x0F (white text color)
    orr r1, r3, r0       // AX = AH + AL (combine AH and AL into r1)
    strh r1, [r1]        // Store word in video memory
    add r1, r1, #2       // Move to next character in video memory
    add r2, r2, #1       // Move to next character in the new command string
    b new_command_loop   // Repeat for next character

// Output byte to the port (simulate outb in x86)
outb:
    // In ARM, we would write to memory-mapped I/O or a system-specific output
    // Here, this is a stub for simulation purposes.
    bx lr

