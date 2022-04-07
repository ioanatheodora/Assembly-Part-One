section .data
    extern len_cheie, len_haystack

section .text
    global columnar_transposition

section .data
    number_of_columns dw 0

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE
   
    mov     ax, word [len_haystack]
    div     byte[len_cheie]
    inc     ax
    mov     byte[number_of_columns], al

    xor     ecx, ecx


start:
    mov     ax, word [len_cheie]
    mul     word [number_of_columns]

    ;; compare counter with the matrix size
    cmp     ecx, eax
    jge     stop
    xor     eax, eax
    xor     edx, edx

    mov     eax, ecx
    push    ecx ;; keep the counter in the stack
    mov     ecx, [number_of_columns]
    div     cx   ;word [len_cheie]
    pop     ecx
    ;; ax - quoitent, dx - remainder


    push    eax
    push    edx
    pop     eax
    pop     edx 
    ;; eax - remainder edx - quoitent

    push    ecx
    mov     ecx, edx
    mul     word [len_cheie]
    add     eax, [edi + 4 * ecx]
    pop     ecx
    ;; compute the position from plaintext

    cmp     eax, [len_haystack]
    jl      continue
    inc     ecx
    jmp     start

continue:
    mov     edx, [esi + eax]
    mov     byte [ebx], dl ;; we move one byte from haystack
    inc     ebx
    inc     ecx
    jmp     start


stop:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY