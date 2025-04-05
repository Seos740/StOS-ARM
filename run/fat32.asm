.global fat32_init, CompareFilenames, FindFileOrDirectory

    .section .text

; FAT32 Boot Sector Definition
FAT32_BootSector:
    .byte 0xEB, 0x58, 0x90         ; Jump instruction to bootloader
    .asciz "MSWIN4.1"               ; OEM Name
    .short 0x0200                   ; Bytes per sector
    .byte 0x08                      ; Sectors per cluster
    .short 0x0001                   ; Reserved sectors
    .byte 0x02                      ; Number of FATs
    .short 0x003F                   ; Max root directory entries
    .short 0x003F                   ; Sectors per FAT
    .byte 0xF8                      ; Media descriptor
    .short 0x0000                   ; FAT1
    .short 0x0000                   ; FAT2
    .short 0x0000                   ; FAT3
    .int 0x00000000                 ; Sectors per track
    .int 0x00000000                 ; Heads per cylinder

; Read Sector Function (using a generic syscall or memory-mapped I/O)
ReadSector:
    ; Assume a syscall to read sector (use appropriate ARM syscall or I/O for disk access)
    mov r0, #0x02           ; AH = 0x02 (Read disk sector)
    mov r1, #0x13           ; BIOS Disk Interrupt or appropriate system call for ARM
    svc 0x01                ; Call system interrupt (you'll need an appropriate syscall for disk access)
    cmp r0, #0              ; Check for error
    bne ReadError
    bx lr                   ; Return from function if no error

ReadError:
    b ReadError             ; Hang if there's an error (loop)

; FAT32 Initialization Function
fat32_init:
    mov r0, #0x80           ; Disk drive number (0x80 for the first hard disk)
    mov r1, #0              ; Cylinder (CH)
    mov r2, #2              ; Sector (CL)
    mov r3, #0              ; Head (DH)
    mov r4, #1              ; AL = 1 (Number of sectors to read)
    bl ReadSector           ; Call ReadSector
    bx lr                   ; Return from function

; Directory Entry (for use later)
FAT32_DirectoryEntry:
    .asciz "MYFILE  TXT"     ; 8.3 file name format

; File Search Function
FindFileOrDirectory:
    ldr r0, =directory_start ; Load starting address of the directory
    ldr r1, =file_name       ; Load address of the file name to search for
    mov r2, #0               ; Initialize directory entry counter

SearchLoop:
    ldrb r3, [r0]            ; Load a byte from the directory entry
    cmp r3, #0x00            ; Check if it's the end of the directory
    beq NoFileFound          ; If zero byte, no file found

    cmp r3, #0xE5            ; Check if it's a deleted entry (0xE5)
    beq SkipEntry

    ldr r4, =FAT32_DirectoryEntry
    bl CompareFilenames      ; Compare with the file name
    cmp r0, #0               ; If filenames match (return value in r0)
    beq FileFound            ; Jump to file found handler

    add r0, r0, #32          ; Move to next entry (each entry is 32 bytes)
    add r2, r2, #1           ; Increment entry counter
    cmp r2, #10              ; Check if we have reached the maximum number of entries
    blt SearchLoop           ; If not, continue the loop
    b NoFileFound            ; Otherwise, no file found

SkipEntry:
    add r0, r0, #32          ; Skip deleted entry
    b SearchLoop             ; Continue the search loop

NoFileFound:
    bx lr                    ; Return if file not found

FileFound:
    ldrb r5, [r0, #11]       ; Check the attribute byte for file type (byte 11)
    cmp r5, #0x10            ; Check if it's a directory (0x10 is directory attribute)
    beq DirectoryFound       ; Jump if it's a directory
    bl DisplayFileName       ; Display file name if it's a regular file
    bx lr                    ; Return from function

DirectoryFound:
    bl DisplayDirectoryName  ; Display directory name if it's a directory
    bx lr                    ; Return from function

; Display File Name Function (to be implemented)
DisplayFileName:
    bx lr                    ; Placeholder for file name display

; Display Directory Name Function (to be implemented)
DisplayDirectoryName:
    bx lr                    ; Placeholder for directory name display

; Compare Filenames Function (compares 8.3 filenames)
CompareFilenames:
    ldrb r2, [r1]            ; Load byte from file name
    ldrb r3, [r0]            ; Load byte from directory entry
    cmp r2, r3               ; Compare the bytes
    bne FilenamesDoNotMatch  ; If not equal, filenames don't match
    add r1, r1, #1           ; Move to next byte in file name
    add r0, r0, #1           ; Move to next byte in directory entry
    cmp r2, #0               ; Check if end of file name
    beq FilenamesMatch       ; If file name ends, match found
    b CompareFilenames       ; Otherwise, continue comparing

FilenamesDoNotMatch:
    mov r0, #1               ; Return 1 if filenames don't match
    bx lr                    ; Return from function

FilenamesMatch:
    mov r0, #0               ; Return 0 if filenames match
    bx lr                    ; Return from function

; Maximum number of entries for directory search
max_entries:
    .word 10                 ; Maximum directory entries to search

; Starting directory (hardcoded for example)
directory_start:
    .asciz "/proc"

; File to search for (hardcoded for example)
file_name:
    .asciz "proc_table.txt"
