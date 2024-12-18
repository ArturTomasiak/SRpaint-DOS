[org 0x100]

section .text

mov AH, 00h
mov AL, 12h
int 10h

call scr_to_white

mov AL, 0
mov DX, 0

menu:

    mov CX, 0
        
    inner_loop_1:
        int 10h
        inc CX
        cmp CX, 641
    jl inner_loop_1

    inc DX
    cmp DX, 50
        
jl menu

mov CX, 630
mov AL, 15
draw_colors:

    mov word [counter], 0
    mov DX, 40
    sub CX, 15
    cmp AL, 8
    jl skip
    mov DX, 25
    jne skip
    mov CX, 630
    skip:

        heigth:

            mov BX, 0
            
            width:
                int 10h
                dec CX
                inc BX
                cmp BX, 15
            jl width

            add CX, 15
            dec DX
            inc word [counter]
            cmp [counter], BX
            
        jl heigth

    dec AL
    cmp AL, 0

jg draw_colors

call update_menu

mov AX, 0001h
int 33h

main_loop:

    mov AH, 01h
    int 16h

    jz empty_buffor

        cmp AH, 10h ; Q
        je quit

        cmp AH, 17h ; I
        je dec_brush_heigth

        cmp AH, 18h ; O
        je inc_brush_heigth

        cmp AH, 25H  ; K
        je dec_brush_width

        cmp AH, 26h  ; L
        je inc_brush_width

        cmp AH, 1Eh  ; A
        je square

        cmp AH, 1Fh  ; S
        je vertical_brush

        cmp AH, 20h  ; D
        je horizontal_brush

        cmp AH, 2Eh  ; C
        jne skip_scr_to_white
        call scr_to_white

        skip_scr_to_white:
        clear_buffor:
        mov AH, 00h
        int 16h

    empty_buffor:

    mov AX, 3
    int 33h
    
    cmp BX, 001b
        je write
    cmp BX, 010b
        je read

jmp main_loop

write: 

    call draw_pixel

jmp main_loop

read: 

    dec CX
    dec DX
    mov AH, 0Dh
    int 10h
    mov byte [color], AL
    call update_menu

jmp main_loop

; for the sake of simplicity, pixels are drawn within the frame
; due to which the position of the cursor cannot be drawn to, which is why the program
; draws to the right left of the cursor and
; ignores the first pixel of the space that was meant to be drawable 

draw_pixel:

    mov AH, 0Ch
    mov AL, [color]
    mov word [counter], 0
    dec DX
    dec CX
    
    outer_loop:      

        mov BX, 0

        cmp DX, 52
            jl end_draw
        cmp DX, 482
            jg skip_inner_loop
        
        inner_loop_3:
            cmp CX, 1
                jl skip_inner_loop
            int 10h
            dec CX
            inc BX
            cmp BX, [brush_width]

        jl inner_loop_3
        
        skip_inner_loop:

        dec DX
        mov BX, [brush_heigth]
        inc word [counter]
        add CX, [brush_width]
        cmp [counter], BX

    jl outer_loop

    end_draw:

ret

inc_brush_width:

    cmp word [brush_width], 0x5F
    jg clear_buffor

    call check_mode

    cmp BX, 0
    je inc_square

    cmp BX, 1
    jne j1
    inc word [vertical_width]
    inc word [brush_width]
    jmp clear_buffor

    j1:
    inc word [horizontal_width]
    inc word [brush_width]

jmp clear_buffor

dec_brush_width:

    cmp word [brush_width], 2
    jl clear_buffor

    call check_mode

    cmp BX, 0
    je dec_square

    cmp BX, 1
    jne j2
    dec word [vertical_width]
    dec word [brush_width]
    jmp clear_buffor

    j2:
    dec word [horizontal_width]
    dec word [brush_width]

jmp clear_buffor

inc_brush_heigth:

    cmp word [brush_heigth], 0x5F
    jg clear_buffor

    call check_mode

    cmp BX, 0
    je inc_square

    cmp BX, 1
    jne j3
    inc word [vertical_heigth]
    inc word [brush_heigth]
    jmp clear_buffor

    j3:
    inc word [horizontal_heigth]
    inc word [brush_heigth]

jmp clear_buffor

dec_brush_heigth:

    cmp word [brush_heigth], 2
    jl clear_buffor

    call check_mode

    cmp BX, 0
    je dec_square

    cmp BX, 1
    jne j4
    dec word [vertical_heigth]
    dec word [brush_heigth]
    jmp clear_buffor

    j4:
    dec word [horizontal_heigth]
    dec word [brush_heigth]

jmp clear_buffor

inc_square:

    inc word [square_size]
    inc word [brush_heigth]
    inc word [brush_width]
    
jmp clear_buffor

dec_square:

    dec word [square_size]
    dec word [brush_heigth]
    dec word [brush_width]
    
jmp clear_buffor

check_mode:

    cmp byte [mode], 1
    jl bx_to_zero
    je bx_to_one
    mov BX, 2

ret

bx_to_zero:

    mov BX, 0

ret

bx_to_one:

    mov BX, 1

ret

square:

    mov AX, [square_size]
    mov byte [mode], 0
    mov [brush_width], AX
    mov [brush_heigth], AX
    call update_menu

jmp clear_buffor

vertical_brush:

    mov AX, [vertical_heigth]
    mov BX, [vertical_width]
    mov byte [mode], 1
    mov [brush_width], AX
    mov [brush_heigth], BX
    call update_menu

jmp clear_buffor

horizontal_brush:

    mov AX, [horizontal_heigth]
    mov BX, [horizontal_width]
    mov byte [mode], 2
    mov word [brush_width], AX
    mov word [brush_heigth], BX
    call update_menu

jmp clear_buffor

update_menu:

    mov AH, 0Ch
    mov AL, 0
    mov DX, 10
    mov BX, 40
    mov [preview_width_start], DX
    mov [preview_width_end], BX

    preview:
    
        mov CX, [preview_width_start]
            
        inner_loop_4:
            int 10h
            inc CX
            cmp CX, [preview_width_end]
        jl inner_loop_4

        inc DX
        cmp DX, BX
            
    jl preview

    cmp AL, [color]
    je skip_preview

    mov AL, [color]
    cmp byte [mode], 1
    jl preview_square
    je preview_vertical_line
    jmp preview_horizontal_line

    skip_preview:

ret

preview_square:

    mov DX, 10
    mov BX, 40

jmp preview

preview_vertical_line:

    mov byte [preview_width_start], 23
    mov byte [preview_width_end], 27
    mov DX, 10
    mov BX, 40

jmp preview

preview_horizontal_line:

    mov byte [preview_width_start], 10
    mov byte [preview_width_end], 40
    mov DX, 23
    mov BX, 27

jmp preview

scr_to_white:

mov AH, 0Ch
mov AL, 15
mov CX, 0
mov DX, 50

    white:

        mov CX, 0
            
        inner_loop_2:
            int 10h
            inc CX
            cmp CX, 641
        jl inner_loop_2

        inc DX
        cmp DX, 481
            
    jl white

ret 

quit:

mov AH, 00h
int 16h

mov AX, 2
int 33h

mov AH, 00h
int 21h

section .bss

preview_width_start  resw 1
preview_width_end    resw 1
counter              resw 1

section .data

color         db 01h
mode          db 00h
brush_width   dw 03h
brush_heigth  dw 03h
square_size   dw 03h
vertical_width dw 08h
vertical_heigth dw 01h
horizontal_width dw 01h
horizontal_heigth dw 08h