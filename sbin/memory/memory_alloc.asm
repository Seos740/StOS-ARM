.global UserObtainMemory

.section .text
UserObtainMemory:
    ; Initialize start address for memory scan
    mov r0, #0x19A00000        ; r0 holds the starting address (0x19A00000)

scan_memory:
    cmp r0, #0x20000000         ; Compare current address (r0) with kernel_end (0x20000000)
    bge end_scan                ; If r0 >= kernel_end, jump to end_scan

    ldr r1, [r0]                ; Load the value at memory[r0] into r1
    cmp r1, #0                  ; Check if the value is zero (empty)
    beq found_empty             ; If empty (r1 == 0), jump to found_empty

    add r0, r0, #1              ; Move to the next memory address
    b scan_memory               ; Continue scanning the memory

found_empty:
    ldr r1, [r0]                ; Reload the value from the empty address
    ldr r2, [r0]                ; Load the same value again to r2 (copying it)
    add r1, r1, #1              ; Increment the value in r1
    add r2, r2, #17             ; Add 17 to the value in r2

toMem:
    str r1, [r0]                ; Store the modified r1 back to memory[r0]
    add r0, r0, #1              ; Increment address
    str r2, [r0]                ; Store the modified r2 back to memory[r0]

    mov r1, #0                  ; Set r1 to 0 as per original logic
    bx lr                       ; Return from the function

end_scan:
    mov r1, #1                  ; Set r1 to 1 if the scan reaches the end
    bx lr                       ; Return from the function

.section .data
kernel_start:      .word 0x00000000
kernel_end:        .word 0x20000000
kernel_driver_start: .word 0x20000001
kernel_driver_end: .word 0x22000000
Ring1Driver_start: .word 0x22000001
Ring1Driver_end:   .word 0x24000000
Ring2Driver_start: .word 0x24000001
Ring2Driver_end:   .word 0x26000000
UserSpace_Start:   .word 0x26000001
User_Space_End:    .word 0xF4000000
FreeStart:         .word 0xF4000001
Free_End:          .word 0xFFFFFFFF
