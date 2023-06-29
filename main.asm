.code16
.text
.globl _start;
_start:
    jmp _boot
text: .asciz "LinuxSeller OS It's size is only 4Kb!\n\r"
.macro mprint str
    leaw \str, %si
    call print
.endm
_boot:
    xor %ax, %ax    # make sure ds is set to 0
    mov %ax, %ds
    cld
# start putting in values:
    mov $0x02, %ah # int13h function 2
    mov $0x10, %al # we want to read 63 sectors
    mov $0x00, %ch # from cylinder number 0
    mov $0x02, %cl # the sector number 2 - second sector (starts from 1, not 0)
    mov $0x00, %dh # head number 0
    xor %bx, %bx    
    mov %bx, %es     # es should be 0
    mov $0x7e00, %bx # 512bytes from origin address 7c00h
    int $0x13
    jmp 0x7e00     # jump to the next sector

end:
    . = _start + 510
    .byte 0x55
    .byte 0xaa
sector2:
jmp main
.include "functions.s"


main:
mov $0x00, %ah
mov $0x13, %al
int $0x10


#call clear_screen
.main_loop:
    call drawText
    mov $0x00, %ah
    int $0x16
    cmp $'b, %al # bg change
    je .chbg_cl
    cmp $'f, %al
    je .flag_cl
    cmp $'p, %al
    je .image_cl
    .flag_cl:
    movb $50, offsetx
    movb $50, offsety
    mov $flagw, %ax 
    call draw_image
    jmp .continue
    .image_cl:
    movb $0, offsetx
    movb $0, offsety
    mov $tnx, %ax
    call draw_image
    mov $0x00, %ah
    int $0x16
    jmp .continue
    .chbg_cl:
    call chbg_user
    jmp .continue
    .continue:
    jmp .main_loop

.data
bg_inst: .asciz "To change BG press <b>.\n\r"
bg_inst_in: .asciz "Press any button from 0 to 9"
flag_inst: .asciz "To print flag press <f>.\n\r"
image_inst: .asciz "To print picture press <p>"
dbg: .asciz "   !!! DEBUG !!!    "
imgwidth: .word 0
imgheight: .word 0

user_data:
offsetx: .word 0
offsety: .word 0

flagw: .byte 0x06
flagh: .byte 0x03
flag: .byte 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04
dddx: .byte 10
dddy: .byte 10
ddd_image: .byte 15, 15, 15, 15, 15, 15, 11, 15, 15, 11, 15, 15, 15, 11, 15, 15, 15, 15, 15, 2, 3, 15, 15, 15, 2, 2, 11, 15, 15, 11, 11, 11, 15, 11, 15, 15, 15, 11, 15, 3, 2, 15, 11, 11, 15, 15, 15, 3, 15, 15, 15, 15, 11, 11, 11, 15, 2, 2, 15, 2, 2, 15, 15, 11, 15, 11, 2, 2, 2, 2, 15, 15, 15, 15, 15, 15, 7, 15, 3, 15, 15 
.include "image.s"
