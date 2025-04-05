.global _start
.extern fat32_init, FindFileOrDirectory, DisplayFileName, DisplayDirectoryName, LoadFileIntoMemory

.section .text

_start:
    ; Call fat32_init to initialize the FAT32 file system
    bl fat32_init 

    ; Set up for FindFileOrDirectory
    ldr r0, =filename       ; Load the address of the filename into r0
    ldr r1, =directory_start ; Load the address of the directory start into r1
    ldr r2, =max_entries    ; Load max_entries value into r2
    bl FindFileOrDirectory  ; Call the external function

    ; Set up for LoadFileIntoMemory
    ldr r0, =filename       ; Load the address of the filename into r0
    ldr r1, =load_address   ; Load the load address into r1
    bl LoadFileIntoMemory   ; Call the external function

    ; Jump to the loaded address to execute the file
    ldr r0, =load_address   ; Load the load address again
    ldr r0, [r0]            ; Dereference the load address to get the real address
    bx r0                   ; Branch to the loaded file's entry point

.section .data

filename: 
    .asciz "/bin/terminal.bin"  ; Null-terminated filename

directory_start: 
    .word 0x100000             ; Directory start address

max_entries: 
    .word 128                  ; Max number of directory entries to search

load_address: 
    .word 0x200000             ; Memory address to load the file into
