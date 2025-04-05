.global _start

.text

_start:
    // Jump to the address 0x1000 (simulated behavior similar to x86)
    ldr r0, =0x1000       // Load the target address (0x1000) into r0
    bx r0                 // Jump to the address stored in r0

    // Fill the rest of the bootloader with padding (to make it 512 bytes)
    .space 510            // Add 510 bytes of padding

    // Bootloader signature (similar to the x86 0xAA55)
    .word 0xAA55          // Signature for bootloader (0xAA55)

