    .section .text
    .global _start

_start:
    /* Set video mode */
    /* For simplicity, we'll assume the video mode is set through an ARM-specific system call or hardware interface */
    mov r0, #0x13        /* Set mode to 0x13 (320x200, 256 colors) */
    bl set_video_mode    /* Call a function to set the video mode (ARM-specific) */

    /* Set pointer to the start of video memory */
    mov r1, #0xA0000     /* VGA memory start */

    /* Square drawing loop - starting at (50, 50) */
    mov r2, #50          /* X position */
    mov r3, #50          /* Y position */

draw_square_y:
    mov r4, #50          /* Width of the square (X loop counter) */
    mov r5, r3           /* Y position (stored in r5) */
    
    /* Calculate the offset in video memory (Y * 320 + X) */
    mul r6, r5, #320     /* Y * 320 */
    add r6, r6, r2       /* Add X offset */

    mov r2, #50          /* Reset X position (for each row) */

draw_square_x:
    /* Add the offset to the base video memory address */
    add r7, r1, r6       /* Video memory base + offset */
    
    /* Set the pixel (white color = 0x0F) */
    movb r8, #0x0F       /* Set color to white (0x0F) */
    strb r8, [r7]        /* Store the byte at the calculated address */

    /* Increment X position and continue the loop */
    add r2, r2, #1       /* Increment X */
    add r6, r6, #1       /* Increment offset for next pixel */
    subs r4, r4, #1      /* Decrement X counter */
    bne draw_square_x    /* Continue loop if not done */

    /* Increment Y position and continue the loop */
    add r3, r3, #1       /* Increment Y position */
    cmp r3, #100         /* Check if we've finished 100 rows (50x50 square) */
    blt draw_square_y    /* Continue Y loop if not done */

    b end                 /* Jump to end */

set_video_mode:
    /* ARM-specific code to set the video mode. This is a placeholder and
       would depend on your system's method of changing the display mode. */
    bx lr

end:
    b end                 /* Infinite loop to end the program */
