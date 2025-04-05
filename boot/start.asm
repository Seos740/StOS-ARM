.global _start

.text
_start:
    // Initialize video mode (for simplicity, we'll assume a generic framebuffer-based display)
    // On ARM, you would typically have a framebuffer at a specific address.
    // Let's assume it's at 0x40000000 (this address will vary depending on your platform).
    
    ldr r0, =0x40000000  // Load address of the framebuffer
    mov r1, #320         // Screen width
    mov r2, #200         // Screen height
    mov r3, #0           // Initial color (black)

    // Draw a pattern (similar to the 320x200 graphics on x86)
draw_loop:
    cmp r2, #0           // Check if we've reached the end of the height
    beq done_draw        // If so, exit the loop

    mov r4, r1           // Set screen width to start row
    mov r5, r3           // Set the color for drawing

draw_row:
    cmp r4, #0           // Check if we've reached the end of the width
    beq next_row         // If so, go to the next row
    str r5, [r0], #4     // Store the color to framebuffer and move pointer (4 bytes per pixel)
    sub r4, r4, #1       // Decrement width counter
    b draw_row           // Loop again

next_row:
    sub r2, r2, #1       // Decrement height counter
    add r3, r3, #1       // Change the color for the next row (could be a simple color change)
    b draw_loop          // Continue drawing

done_draw:
    // Wait for keypress (this part is platform-dependent)
    // On ARM, we would typically use an input method like UART or GPIO for simple key press detection.
    // This is just a placeholder as actual input handling depends on the platform you're working with.
    // Here, we'll just wait for a few seconds.

    // Jump to address 0x2000 (simulating jumping to a different location, similar to x86 behavior)
    ldr r0, =0x2000      // Load the jump target address
    bx r0                // Jump to the new address

