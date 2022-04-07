section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implment rotp
    ;; FREESTYLE STARTS HERE

    xor     ebx, ebx

    ;;we reverse the key by using the stack
reverse_key_push:
    mov     al, [edi + ebx];
    inc     ebx
    push    eax
loop reverse_key_push

    mov     ecx, ebx
    xor     ebx, ebx

reverse_key_pop:
    pop     eax
    mov     byte [edi + ebx], al
    inc     ebx
loop reverse_key_pop

    mov     ecx, ebx
    xor     ebx, ebx
    
    ;; compute the result with the given formula
move_ciphertext:
    mov     al, byte [edi + ebx]
    xor     al, byte [esi + ebx]
    mov     byte [edx + ebx], al
    inc     ebx
loop move_ciphertext

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY