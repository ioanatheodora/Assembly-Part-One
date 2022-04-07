;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS

section .text
    global load

section .data
    TAG dd 0
    OFFSET dd 0
    var1 db 0X69
    var2 dw 0xabcd
    var3 db 0x12


;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE
    mov     [OFFSET], byte 0
    mov     [TAG], dword 0    
 
    ;; compute the value of the tag
    mov     eax, edx
    shr     eax, OFFSET_BITS
    mov     [TAG], eax

    ;; compute the value of the offset
    shl     eax, OFFSET_BITS
    sub     edx, eax
    mov     [OFFSET], edx

    xor     ecx, ecx ;; counter

find_tag:
    ;; verify whether the tag already exists
    ;; iterate through the matrix of tags
    mov     eax, [TAG]
    mov     ebx, [ebp + 12]
    push    eax
    mov     eax, ecx
    mov     edx, CACHE_LINE_SIZE
    mul     edx
    add     ebx, eax
    pop     eax

    ;; the tag is found
    cmp     eax, [ebx]
    je      compute_register

    ;; searched in the matrix and the tag was not found
    cmp     ecx, CACHE_LINES
    jge     not_find

    ;; the search is not finished
    inc     ecx
    jmp     find_tag

compute_register:
    mov     ebx, ecx        ;; position to be added on
    mov     ecx, [ebp + 16] ;; cache
    add     ecx, [OFFSET]
    mov     eax, [ecx + CACHE_LINE_SIZE * ebx]
    jmp     stop

not_find:
    mov     ecx, [ebp + 16]  ;; cache
    shl     eax, OFFSET_BITS
    push    eax

    ;; get the right row to add the values of the tags
    mov     eax, edi        ;; to_replace
    mov     ebx, CACHE_LINE_SIZE
    mul     ebx
    add     ecx, eax
    pop     eax
    xor     edx, edx


add_tags:   
    ;; adding the values to cache
    cmp     edx, CACHE_LINE_SIZE
    jge     done_adding_tags

    mov     ebx, [ebp + 12]

    mov     bl, byte [eax]
    mov     byte [ecx + edx] , bl

    inc     eax
    inc     edx

    jmp     add_tags


done_adding_tags:
    ;; adding the tag to the list of tags
    mov     ebx, [ebp + 12]
    mov     eax, edi
    mov     edx, 8
    mul     edx
    add     ebx, eax ;; add the tag to the right row
    mov     eax, [TAG]
    mov     [ebx], eax 

    ;; computing the register
    mov     ecx, [ebp + 16] ;; cache
    mov     eax, edi
    mov     ebx, CACHE_LINE_SIZE
    mul     ebx
    add     ecx, eax
    add     ecx, [OFFSET]
    mov     eax, [ebp + CACHE_LINE_SIZE]
    mov     ebx, [ecx]
    mov     [eax], ebx

stop:
    
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


