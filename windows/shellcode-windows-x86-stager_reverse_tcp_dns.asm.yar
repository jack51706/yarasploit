
    rule stager_reverse_tcp_dns___start0___x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::__start0__"
    
        /*
            FC                   | .                    | cld
            E882000000           | .....                | call start
        */
    
        strings:
            $a   = { fc e8 82 00 00 00 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_api_call_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::api_call"
    
        /*
            60                   | `                    | pushad
            89E5                 | ..                   | mov ebp, esp
            31C0                 | 1.                   | xor eax, eax
            648B5030             | d.P0                 | mov edx, [fs:eax+48]
            8B520C               | .R.                  | mov edx, [edx+12]
            8B5214               | .R.                  | mov edx, [edx+20]
        */
    
        strings:
            $a   = { 60 89 e5 31 c0 64 8b 50 30 8b 52 0c 8b 52 14 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_next_mod_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::next_mod"
    
        /*
            8B7228               | .r(                  | mov esi, [edx+40]
            0FB74A26             | ..J&                 | movzx ecx, word [edx+38]
            31FF                 | 1.                   | xor edi, edi
        */
    
        strings:
            $a   = { 8b 72 28 0f b7 4a 26 31 ff }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_loop_modname_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::loop_modname"
    
        /*
            AC                   | .                    | lodsb
            3C61                 | <a                   | cmp al, 'a'
            7C02                 | |.                   | jl not_lowercase
            2C20                 | ,                    | sub al, 0x20
        */
    
        strings:
            $a   = { ac 3c 61 7c 02 2c 20 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_not_lowercase_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::not_lowercase"
    
        /*
            C1CF0D               | ...                  | ror edi, 13
            01C7                 | ..                   | add edi, eax
            E2F2                 | ..                   | loop loop_modname
            52                   | R                    | push edx
            57                   | W                    | push edi
            8B5210               | .R.                  | mov edx, [edx+16]
            8B4A3C               | .J<                  | mov ecx, [edx+60]
            8B4C1178             | .L.x                 | mov ecx, [ecx+edx+120]
            E348                 | .H                   | jecxz get_next_mod1
            01D1                 | ..                   | add ecx, edx
            51                   | Q                    | push ecx
            8B5920               | .Y                   | mov ebx, [ecx+32]
            01D3                 | ..                   | add ebx, edx
            8B4918               | .I.                  | mov ecx, [ecx+24]
        */
    
        strings:
            $a   = { c1 cf 0d 01 c7 e2 f2 52 57 8b 52 10 8b 4a 3c 8b 4c 11 78 e3 48 01 d1 51 8b 59 20 01 d3 8b 49 18 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_get_next_func_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::get_next_func"
    
        /*
            E33A                 | .:                   | jecxz get_next_mod
            49                   | I                    | dec ecx
            8B348B               | .4.                  | mov esi, [ebx+ecx*4]
            01D6                 | ..                   | add esi, edx
            31FF                 | 1.                   | xor edi, edi
        */
    
        strings:
            $a   = { e3 3a 49 8b 34 8b 01 d6 31 ff }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_loop_funcname_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::loop_funcname"
    
        /*
            AC                   | .                    | lodsb
            C1CF0D               | ...                  | ror edi, 13
            01C7                 | ..                   | add edi, eax
            38E0                 | 8.                   | cmp al, ah
            75F6                 | u.                   | jne loop_funcname
            037DF8               | .}.                  | add edi, [ebp-8]
            3B7D24               | ;}$                  | cmp edi, [ebp+36]
            75E4                 | u.                   | jnz get_next_func
            58                   | X                    | pop eax
            8B5824               | .X$                  | mov ebx, [eax+36]
            01D3                 | ..                   | add ebx, edx
            668B0C4B             | f..K                 | mov cx, [ebx+2*ecx]
            8B581C               | .X.                  | mov ebx, [eax+28]
            01D3                 | ..                   | add ebx, edx
            8B048B               | ...                  | mov eax, [ebx+4*ecx]
            01D0                 | ..                   | add eax, edx
        */
    
        strings:
            $a   = { ac c1 cf 0d 01 c7 38 e0 75 f6 03 7d f8 3b 7d 24 75 e4 58 8b 58 24 01 d3 66 8b 0c 4b 8b 58 1c 01 d3 8b 04 8b 01 d0 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_finish_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::finish"
    
        /*
            89442424             | .D$$                 | mov [esp+36], eax
            5B                   | [                    | pop ebx
            5B                   | [                    | pop ebx
            61                   | a                    | popad
            59                   | Y                    | pop ecx
            5A                   | Z                    | pop edx
            51                   | Q                    | push ecx
            FFE0                 | ..                   | jmp eax
        */
    
        strings:
            $a   = { 89 44 24 24 5b 5b 61 59 5a 51 ff e0 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_get_next_mod1_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::get_next_mod1"
    
        /*
            5F                   | _                    | pop edi
            5A                   | Z                    | pop edx
            8B12                 | ..                   | mov edx, [edx]
            EB8D                 | ..                   | jmp short next_mod
        */
    
        strings:
            $a   = { 5f 5a 8b 12 eb 8d }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_reverse_tcp_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::reverse_tcp"
    
        /*
            6833320000           | h32..                | push 0x00003233
            687773325F           | hws2_                | push 0x5f327377
            54                   | T                    | push esp
            684C772607           | hLw&.                | push 0x0726774c	; LoadLibraryA
            FFD5                 | ..                   | call ebp
            B890010000           | .....                | mov eax, 0x0190
            29C4                 | ).                   | sub esp, eax
            54                   | T                    | push esp
            50                   | P                    | push eax
            6829806B00           | h).k.                | push 0x006b8029	; WSAStartup
            FFD5                 | ..                   | call ebp
            50                   | P                    | push eax
            50                   | P                    | push eax
            50                   | P                    | push eax
            50                   | P                    | push eax
            40                   | @                    | inc eax
            50                   | P                    | push eax
            40                   | @                    | inc eax
            50                   | P                    | push eax
            68EA0FDFE0           | h....                | push 0xe0df0fea	; WSASocketA
            FFD5                 | ..                   | call ebp
            97                   | .                    | xchg edi, eax
        */
    
        strings:
            $a   = { 68 33 32 00 00 68 77 73 32 5f 54 68 4c 77 26 07 ff d5 b8 90 01 00 00 29 c4 54 50 68 29 80 6b 00 ff d5 50 50 50 50 40 50 40 50 68 ea 0f df e0 ff d5 97 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_got_hostname_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::got_hostname"
    
        /*
            68A9283480           | h.(4.                | push 0x803428a9	; gethostbyname
            FFD5                 | ..                   | call ebp
        */
    
        strings:
            $a   = { 68 a9 28 34 80 ff d5 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_set_address_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::set_address"
    
        /*
            8B401C               | .@.                  | mov eax, [eax+28]
            6A05                 | j.                   | push byte 0x05
            50                   | P                    | push eax
            680200????           | h...\                | push 0x5c110002	; Port
            89E6                 | ..                   | mov esi, esp
        */
    
        strings:
            $a   = { 8b 40 1c 6a 05 50 68 02 00 ?? ?? 89 e6 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_try_connect_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::try_connect"
    
        /*
            6A10                 | j.                   | push byte 16
            56                   | V                    | push esi
            57                   | W                    | push edi
            6899A57461           | h..ta                | push 0x6174a599	; connect
            FFD5                 | ..                   | call ebp
            85C0                 | ..                   | test eax,eax
            740C                 | t.                   | jz short connected
        */
    
        strings:
            $a   = { 6a 10 56 57 68 99 a5 74 61 ff d5 85 c0 74 0c }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_handle_failure_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::handle_failure"
    
        /*
            FF4E08               | .N.                  | dec dword [esi+8]
            75EC                 | u.                   | jnz short try_connect
        */
    
        strings:
            $a   = { ff 4e 08 75 ec }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_failure_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::failure"
    
        /*
            68F0B5A256           | h...V                | push 0x56a2b5f0	; ExitProcess
            FFD5                 | ..                   | call ebp
        */
    
        strings:
            $a   = { 68 f0 b5 a2 56 ff d5 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_recv_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::recv"
    
        /*
            6A00                 | j.                   | push byte 0
            6A04                 | j.                   | push byte 4
            56                   | V                    | push esi
            57                   | W                    | push edi
            6802D9C85F           | h..._                | push 0x5fc8d902	; recv
            FFD5                 | ..                   | call ebp
            8B36                 | .6                   | mov esi, [esi]
            6A40                 | j@                   | push byte 0x40
            6800100000           | h....                | push 0x1000
            56                   | V                    | push esi
            6A00                 | j.                   | push byte 0
            6858A453E5           | hX.S.                | push 0xe553a458	; VirtualAlloc
            FFD5                 | ..                   | call ebp
            93                   | .                    | xchg ebx, eax
            53                   | S                    | push ebx
        */
    
        strings:
            $a   = { 6a 00 6a 04 56 57 68 02 d9 c8 5f ff d5 8b 36 6a 40 68 00 10 00 00 56 6a 00 68 58 a4 53 e5 ff d5 93 53 }
    
        condition:
            any of them
    }
    
    
    rule stager_reverse_tcp_dns_read_more_x86
    {
        meta:
            desc = "Metasploit::windows::x86::stager_reverse_tcp_dns::read_more"
    
        /*
            6A00                 | j.                   | push byte 0
            56                   | V                    | push esi
            53                   | S                    | push ebx
            57                   | W                    | push edi
            6802D9C85F           | h..._                | push 0x5fc8d902	; recv
            FFD5                 | ..                   | call ebp
            01C3                 | ..                   | add ebx, eax
            29C6                 | ).                   | sub esi, eax
            75EE                 | u.                   | jnz read_more
            C3                   | .                    | ret
        */
    
        strings:
            $a   = { 6a 00 56 53 57 68 02 d9 c8 5f ff d5 01 c3 29 c6 75 ee c3 }
    
        condition:
            any of them
    }
    
    