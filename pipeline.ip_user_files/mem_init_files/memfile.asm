E3A01007  // MOV R1, #7        ; R1 = 7
E3A02064  // MOV R2, #100      ; R2 = 100
E2811003  // ADD R1, R1, #3    ; R1 = R1 + 3 (R1 = 10)
E2422005  // SUB R2, R2, #5    ; R2 = R2 - 5 (R2 = 95)
E1A03001  // MOV R3, R1        ; R3 = R1 (R3 = 10)
E0834002  // ADD R4, R3, R2    ; R4 = R3 + R2 (R4 = 105)
E0435002  // SUB R5, R3, R2    ; R5 = R3 - R2 (R5 = -85, en complemento a 2)
E2036003  // AND R6, R3, R3    ; R6 = R3 & R3 (R6 = 10)
E3837004  // ORR R7, R3, #4    ; R7 = R3 | 4 (R7 = 14)
E1A08007  // MOV R8, R7        ; R8 = R7 (R8 = 14)
E3A090FF  // MOV R9, #255      ; R9 = 255
E1A0A009  // MOV R10, R9       ; R10 = R9 (R10 = 255)
E1540008  // CMP R4, R8        ; Compare R4 with R8 (flags set, R4 and R8 unchanged)
E0840001  // ADD R4, R4, R1    ; R4 = R4 + R1
E0841002  // ADD R1, R4, R2    ; R1 = R4 + R2
E0043005  // ADD R3, R4, R5    ; R3 = R4 + R5
E3A0B00A  // MOV R11, #10      ; R11 = 10
E1A0C00B  // MOV R12, R11      ; R12 = R11 (R12 = 10)
E1A0D00C  // MOV R13, R12      ; R13 = R12 (R13 = 10)
E1A0E00D  // MOV R14, R13      ; R14 = R13 (R14 = 10)
E150000E  // CMP R0, R14       ; Compare R0 with R14 (flags set, R0 and R14 unchanged)
E0854002  // ADD R4, R5, R2    ; R4 = R5 + R2
E0453006  // SUB R3, R5, R6    ; R3 = R5 - R6
E1A0F00E  // MOV R15, R14      ; R15 = R14 (R15 = 10)
E1A0F000  // NOP (mov R15, R0) ; No operación
