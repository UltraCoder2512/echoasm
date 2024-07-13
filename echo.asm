bits 64
default rel

section .data
    fmt db "%s", 0xd, 0xa, 0
    err db "Correct usage: echo <string>"

section .text
    extern printf
    extern ExitProcess
    global main

    main:
        ;Set up stack
        push rbp
        mov rbp, rsp
        sub rsp, 32
        
        ;Save cli args in r11 and r12
        mov r13, rcx ;argc
        mov r12, rdx ;argv

        cmp r13, 2
        jl .wrong_num_of_args_error

        mov rbx, 1
        ;Loop through argv
        .loop:
            cmp rbx, r13
            je .end
            mov rdx, [r12 + rbx * 8]
            mov rcx, fmt

            call printf
            add rbx, 1
            cmp rbx, r13
            jl .loop
            jmp .end

        ;Exit
        .end:
            xor rax, rax
            call ExitProcess

        .wrong_num_of_args_error:
            ;Prepare to call printf
            mov rcx, err
            call printf
            
            ;Exit
            xor rax, rax
            call ExitProcess