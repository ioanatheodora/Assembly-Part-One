; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

    xor     ebx, ebx ;; ebx - index 

start:
    cmp     ebx, edx
    jnl    stop ;; compare idx to the number of people

    ;; [esi + 4] - current year
    mov     eax, [edi + 8 * ebx + 4] ;; the current person's year

    cmp [esi + 4], eax ;;compare the years
    jng year_greater
    
    ;; compare the months
    mov     ax, word [edi + 8 * ebx + 2]
    cmp     ax, word [esi + 2]
    jg    days_months_greater

    cmp     word [esi + 2], ax
    jg    days_months_less  

    ;; compare the days
    mov     ax, word [edi + 8 * ebx]
    cmp     ax, word [esi]
    jg    days_months_greater

    cmp     word [esi], ax
    jge    days_months_less  

    jmp     continue

;; it goes to this label whether the current month
;; is less than the month of birth of if the months are 
;; equal and the current day is less or equal to the day of birth
days_months_less:
    mov     eax, [esi + 4]
    ;; calculate the age with the formula of current_year - year_of_birth 
    sub     eax, [edi + 8 * ebx + 4]
    mov     [ecx + 4 * ebx], eax
    jmp     continue

;; it goes to this label whether the current month
;; is greater than the month of birth of if the months are 
;; equal and the current day is greater than the day of birth
days_months_greater:
    mov     eax, [esi + 4]
    ;; calculate the age with the formula of current_year - year_of_birth - 1  
    sub     eax, [edi + 8 * ebx + 4]
    dec     eax
    mov     [ecx + 4 * ebx], eax
    jmp     continue

year_greater:
    mov     dword[ecx + 4 * ebx], 0
    jmp     continue

continue:    
    inc     ebx
    jmp     start

stop:    

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
