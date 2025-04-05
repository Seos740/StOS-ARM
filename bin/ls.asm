.global _start

.extern fat32_init
.extern FindFileOrDirectory
.extern DisplayFileName
.extern DisplayDirectoryName

.text

_start:
    // Load the address of filename into r0 (first argument for FindFileOrDirectory)
    ldr r0, =filename       // r0 = filename address
    
    // Load the address of directory_start into r1 (second argument for FindFileOrDirectory)
    ldr r1, =directory_start // r1 = directory_start address
    
    // Load the value of max_entries into r2 (third argument for FindFileOrDirectory)
    ldr r2, =max_entries    // r2 = max_entries value

    // Call FindFileOrDirectory
    bl FindFileOrDirectory

    // Call DisplayFileName
    bl DisplayFileName

    // Call DisplayDirectoryName
    bl DisplayDirectoryName

    // Return from the program
    bx lr

// Data section

.data

filename:        .asciz "MyFile.txt"     // null-terminated string
directory_start: .word 0x100000           // starting address of directory
max_entries:     .word 128                // max entries value
