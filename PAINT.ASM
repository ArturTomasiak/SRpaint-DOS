.MODEL small, c
.386
.STACK 400h

.DATA

color         db 01h
mode          db 00h
brush_width   dw 03h
brush_heigth  dw 03h
square_size   dw 03h
vertical_width dw 08h
vertical_heigth dw 01h
horizontal_width dw 01h
horizontal_heigth dw 08h

.DATA?

preview_width_start  dw ?
preview_width_end    dw ?
counter              dw ?

.CODE

start PROC

    push BP
    mov BP, SP
    mov DS, [BP+4]

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
            cmp CX, 640
        jl inner_loop_1

        inc DX
        cmp DX, 50
            
    jl menu

    mov CX, 630
    mov AL, 15
    draw_colors:

        mov word ptr [counter], 0
        mov DX, 40
        sub CX, 15
        cmp AL, 8
        jl skip
        mov DX, 25
        jne skip
        mov CX, 630
        skip:

            draw_heigth:

                mov BX, 0
                
                draw_width:
                    int 10h
                    dec CX
                    inc BX
                    cmp BX, 15
                jl draw_width

                add CX, 15
                dec DX
                inc word ptr [counter]
                cmp word ptr [counter], BX
                
            jl draw_heigth

        dec AL
        cmp AL, 0

    jg draw_colors

    push DS
    call update_menu
    add SP, 2

    mov AX, 0001h
    int 33h

    mov SP, BP
    pop BP
    ret

start ENDP

scr_to_white PROC

    mov AH, 0Ch
    mov AL, 15
    mov DX, 50

        white:

            mov CX, 0
                
            inner_loop_2:
                int 10h
                inc CX
                cmp CX, 640
            jl inner_loop_2

            inc DX
            cmp DX, 480
                
        jl white

    ret

scr_to_white ENDP

update_menu PROC

    push BP
    mov BP, SP
    mov DS, [BP+4]

    mov AH, 0Ch
    mov AL, 0
    mov DX, 10
    mov BX, 40
    mov word ptr [preview_width_start], DX
    mov word ptr [preview_width_end], BX

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
    cmp byte ptr [mode], 1
    jl preview_square
    je preview_vertical_line
    jmp preview_horizontal_line

    skip_preview:

    mov SP, BP
    pop BP
    ret

    preview_square:

    mov DX, 10
    mov BX, 40

    jmp preview

    preview_vertical_line:

        mov word ptr [preview_width_start], 23
        mov word ptr [preview_width_end], 27
        mov DX, 10
        mov BX, 40

    jmp preview

    preview_horizontal_line:

        mov word ptr [preview_width_start], 10
        mov word ptr [preview_width_end], 40
        mov DX, 23
        mov BX, 27

    jmp preview

update_menu ENDP

main PROC

    mov AX, @data
    mov DS, AX

    push DS
    call start
    add SP, 2

    main_loop:

        mov AX, 3
        int 33h

        cmp BX, 001b
        je draw

        cmp BX, 010b
        je read

        after_mouse_input:

        mov AH, 01h
        int 16h

        jz main_loop ; no input used

        push DS

        cmp AH, 10h ; Q
        jne check_i
            call quit
        check_i:

        cmp AH, 17h ; I
        jne check_o
            call dec_brush_heigth
            jmp clear_buffor
        check_o:

        cmp AH, 18h ; O
        jne check_k
            call inc_brush_heigth
            jmp clear_buffor
        check_k:

        cmp AH, 25h ; K
        jne check_l
            call dec_brush_width
            jmp clear_buffor
        check_l:

        cmp AH, 26h ; L
        jne check_a
            call inc_brush_width
            jmp clear_buffor
        check_a:

        cmp AH, 1Eh ; A
        jne check_s
            call mode_zero     ; square
            jmp clear_buffor
        check_s:

        cmp AH, 1Fh ; S
        jne check_d
            call mode_one      ; vertical
            jmp clear_buffor
        check_d:

        cmp AH, 20h ; D
        jne check_c
            call mode_two      ; horizontal
            jmp clear_buffor
        check_c:

        cmp AH, 2Eh ; C
        jne clear_buffor
            call scr_to_white

        clear_buffor:

        add SP, 2    ; clean up sent parameter (DS)
        mov AH, 00h  ; clean keyboard buffor
        int 16h 

        jmp main_loop

draw:

    mov AH, 0Ch
    mov AL, [color]
    mov word ptr [counter], 0
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
        inc word ptr [counter]
        add CX, [brush_width]
        cmp word ptr [counter], BX

    jl outer_loop

    end_draw:

jmp after_mouse_input

read:

    dec CX
    dec DX
    mov AH, 0Dh
    int 10h
    cmp byte ptr [color], AL
    je after_mouse_input

    mov byte ptr [color], AL
    push DS
    call update_menu
    add SP, 2

jmp after_mouse_input

main ENDP

dec_brush_heigth PROC

    push BP
    mov BP, SP
    mov DS, [BP+4]

    cmp word ptr [brush_heigth], 2
    jl jmp2ret1

    push DS
    push BX
    call check_mode
    add SP, 4

    cmp BX, 0
    jne not_mode1_1
        dec word ptr [square_size]
        dec word ptr [brush_heigth]
        dec word ptr [brush_width]
        jmp jmp2ret1
    not_mode1_1:

    cmp BX, 1
    jne not_mode2_1
    dec word ptr [vertical_heigth]
    dec word ptr [brush_heigth]
    jmp jmp2ret1
    not_mode2_1:

    dec word ptr [vertical_heigth]
    dec word ptr [brush_heigth]

    jmp2ret1:
    mov SP, BP
    pop BP
    ret

dec_brush_heigth ENDP

inc_brush_heigth PROC
    
    push BP
    mov BP, SP
    mov DS, [BP+4]

    cmp word ptr [brush_heigth], 5Fh
    jg jmp2ret2

    push DS
    push BX
    call check_mode
    add SP, 4

    cmp BX, 0
    jne not_mode1_2
        inc word ptr [square_size]
        inc word ptr [brush_heigth]
        inc word ptr [brush_width]
        jmp jmp2ret2
    not_mode1_2:

    cmp BX, 1
    jne not_mode2_2
        inc word ptr [vertical_heigth]
        inc word ptr [brush_heigth]
        jmp jmp2ret2
    not_mode2_2:

    inc word ptr [vertical_heigth]
    inc word ptr [brush_heigth]

    jmp2ret2:
    mov SP, BP
    pop BP
    ret

inc_brush_heigth ENDP

dec_brush_width PROC

    push BP
    mov BP, SP
    mov DS, [BP+4]

    cmp word ptr [brush_width], 2
    jl jmp2ret3

    push DS
    push BX
    call check_mode
    add SP, 4

    cmp BX, 0
    jne not_mode1_3
        dec word ptr [square_size]
        dec word ptr [brush_heigth]
        dec word ptr [brush_width]
        jmp jmp2ret3
    not_mode1_3:

    cmp BX, 1
    jne not_mode2_3
        dec word ptr [vertical_width]
        dec word ptr [brush_width]
        jmp jmp2ret3
    not_mode2_3:

    dec word ptr [horizontal_width]
    dec word ptr [brush_width]

    jmp2ret3:
    mov SP, BP
    pop BP
    ret

dec_brush_width ENDP

inc_brush_width PROC

    push BP
    mov BP, SP
    mov DS, [BP+4]

    cmp word ptr [brush_width], 5Fh
    jg jmp2ret4

    push DS
    push BX
    call check_mode
    add SP, 4

    cmp BX, 0
    jne not_mode1_4
        inc word ptr [square_size]
        inc word ptr [brush_heigth]
        inc word ptr [brush_width]
        jmp jmp2ret4
    not_mode1_4:

    cmp BX, 1
    jne not_mode2_4
        inc word ptr [vertical_width]
        inc word ptr [brush_width]
        jmp jmp2ret4
    not_mode2_4:

    inc word ptr [horizontal_width]
    inc word ptr [brush_width]

    jmp2ret4:
    mov SP, BP
    pop BP
    ret

inc_brush_width ENDP

check_mode PROC

    push BP
    mov BP, SP
    mov BX, [BP+4]
    mov DS, [BP+6]

    cmp byte ptr [mode], 1
    jl bx_to_zero
    je bx_to_one
    mov BX, 2
    mov sp, bp
    pop BP
    ret

    bx_to_zero:
        mov BX, 0
    mov sp, bp
    pop BP
    ret

    bx_to_one:
        mov BX, 1
    mov sp, bp
    pop BP
    ret

check_mode ENDP

mode_zero PROC

    push BP
    mov BP, SP
    mov DS, [BP+4]

    mov AX, [square_size]
    mov byte ptr [mode], 0
    mov word ptr [brush_width], AX
    mov word ptr [brush_heigth], AX

    push DS
    call update_menu
    add SP, 2
    mov sp, bp
    pop BP
    ret

mode_zero ENDP

mode_one PROC

    push BP
    mov BP, SP
    mov DS, [BP+4]

    mov AX, [vertical_heigth]
    mov BX, [vertical_width]
    mov byte ptr [mode], 1
    mov word ptr [brush_width], AX
    mov word ptr [brush_heigth], BX

    push DS
    call update_menu
    add SP, 2
    mov sp, bp
    pop BP
    ret

mode_one ENDP

mode_two PROC

    push BP
    mov BP, SP
    mov DS, [BP+4]

    mov AX, [horizontal_heigth]
    mov BX, [horizontal_width]
    mov byte ptr [mode], 2
    mov word ptr [brush_width], AX
    mov word ptr [brush_heigth], BX

    push DS
    call update_menu
    add SP, 2
    mov sp, bp
    pop BP
    ret

mode_two ENDP

quit PROC

    mov AH, 00h
    int 16h

    mov AX, 2
    int 33h

    mov AH, 4Ch
    int 21h
    
quit ENDP

END main