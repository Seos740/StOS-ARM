.global _start

.section .text
_start:
    /* Setup for 32-bit mode */
    
    /* Set up the stack pointer */
    ldr sp, =0x8000

    /* Disable interrupts */
    cpsid if

    /* Setup a basic memory model (for ARM architecture) */
    /* In ARM, you do not need to define segments as in x86. We just set up memory space. */

    /* Start video mode (this is for illustrative purposes; not necessary for real ARM bootloading) */
    ldr r0, =0x40000000    /* Some framebuffer or memory-mapped IO address */
    mov r1, #0x13          /* Mode number, similar to the x86 code */
    swi 0                  /* Software interrupt (similar to int 0x10 in x86 for video) */

    /* Set up a simple loop to print "Welcome to ARM OS" */
    ldr r0, =message
print_char:
    ldrb r1, [r0], #1      /* Load byte and increment pointer */
    cmp r1, #0             /* Check for null terminator */
    beq end_message        /* If null terminator, end the message */
    
    mov r2, #0x0F          /* Color or attributes for text */
    /* In real code, you would use a specific function to write the character to a console or framebuffer */
    /* For now, assume we just output to a location */
    strb r1, [r0, #0x100]  /* Fake storing to an I/O memory-mapped location for video memory */
    b print_char

end_message:
    /* Now jumping to a simple memory address for protected mode setup (just as an example) */
    ldr r0, =0x10000        /* Address in higher memory */
    bx r0                    /* Branch to that address (effectively jumps into protected mode or further code) */

.section .data
message:
    .asciz "Welcome to ARM OS\n"

