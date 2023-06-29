print:
    push %cs
    pop  %ds
    .loop:
        lodsb
        cmp  $0x00, %al
        je   .loop_done
        movb $0x0e, %ah
        mov  $0x0f, %bl
        mov  $0x00, %bh
        int  $0x10
        jne .loop
    .loop_done:
    ret

print_int:
    push %cs
    pop  %ds
    push %bp
    mov  %sp, %bp

    .print_int_loop:
        mov %ax, %cx
        call mod_ten

        add $0x30, %al
        mov $0x0e, %ah
        mov $0x0f, %bl
        mov $0x00, %bh
        int $0x10

        mov %cx, %ax
        mov $0x0a, %bx
        div %bx
        mov %ah, %al
        mov $0x00, %ah


        add $0x30, %al
        mov $0x0e, %ah
        mov $0x0f, %bl
        mov $0x00, %bh
        int $0x10

        #cmp $0x00, %al
        #jne .print_int_loop

    mov %bp, %sp
    pop %bp

    ret


mod_ten:
    push %bp
    mov  %sp, %bp

    mov %al, %cl
    mov $0x00, %ah
    mov $0x0a, %bl
    div %bl
    #mov %ah, %al
    sub %cl, %al

    mov %bp, %sp
    pop %bp
    ret 

clear_screen:
    call reset_cursor
    mov $0x00, %ah
    mov $0x13, %al
    int $0x10
    ret
    
chbg:
    pop %dx
    pop %cx
    mov $0xA000, %ax
    mov %ax, %es
    mov $0x00, %bx
    .lp:
        mov %cx, %es:(%bx)
        inc %bx
        cmp $64000, %bx
        jne .lp
    # mprint dbg
    push %dx
    ret

chbg_user:
    call clear_screen
    mprint bg_inst_in
    mov $0x00, %ah
    int $0x16
    sub $0x30, %al 
    push %ax
    call chbg
    ret

drawText:
    call reset_cursor
    cld
    mprint text
    mprint bg_inst
    mprint flag_inst
    mprint image_inst
    ret

reset_cursor:
    mov $0x02, %ah
    mov $0x00, %bh
    mov $0x00, %dh
    mov $0x00, %dl
    int $0x10
    ret

draw_image:
# cx -> x
# dx -> y
    mov %ax, %bx
    mov 0(%bx), %ax
    mov %ax, imgwidth
    #loaded to global var imgwidth
    mov 1(%bx), %ax
    mov %ax, imgheight
    # loaded to global var imgheight
    leaw 2(%bx), %si
    mov offsety, %dx
    #mov $0x00, %dx
    pimgy:
        mov offsetx, %cx
        #mov $0x00, %cx
        pimgx:
            lodsb
            mov $0x0c, %ah
            mov $0x00, %bx
            int $0x10
            inc %cx
            mov imgwidth, %bl
            add offsetx, %bl
            mov $0x00, %bh
            cmp %bx, %cx
            jl pimgx
        inc %dx
        mov imgheight, %bl
        add offsety, %bl
        mov $0x00, %bh
        cmp %bx, %dx
        jl pimgy
    ret
