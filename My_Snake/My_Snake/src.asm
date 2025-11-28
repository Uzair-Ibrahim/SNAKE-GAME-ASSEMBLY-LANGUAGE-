INCLUDE Irvine32.inc
Beep PROTO stdcall, dwFreq:DWORD, dwDuration:DWORD
.data
X byte 10
Y byte 24
Direction byte 3
Screen BYTE 8100 dup(" ")
AppleX byte 10
AppleY byte 23
BodyX byte 8099 dup(0)
BodyY byte 8099 dup(0)
SpeedX dword 125
SpeedY dword 50
BodySize byte -1

strScore    BYTE "Score: ",0
strRecord   BYTE "Record: ",0
strTime     BYTE "Time:  ",0
strSec      BYTE "s",0
filename    BYTE "record.txt",0
fileHandle  HANDLE ?
HighScore   DWORD 0
StartTime   DWORD 0
buffer      BYTE 16 DUP(0)
ByteCount   DWORD ?

GamePaused     BYTE 0
IsGameOver     BYTE 0
PauseTimeStart DWORD 0

strTitle1   BYTE "                          ____  _    _   _    _  _______   ____    _    __  __ _____ ",0
strTitle2   BYTE "                         / ___|| \ | |  / \  | |/ / ____| / ___|  / \  |  \/  | ____|",0
strTitle3   BYTE "                         \___ \|  \| | / _ \ | ' /|  _|  | |  _  / _ \ | |\/| |  _|  ",0
strTitle4   BYTE "                          ___) | |\  |/ ___ \| . \| |___ | |_| |/ ___ \| |  | | |___ ",0
strTitle5   BYTE "                         |____/|_| \_/_/   \_\_|\_\_____| \____/_/   \_\_|  |_|_____|",0
strMenu1    BYTE "                      1. EASY   (Slow Speed)",0
strMenu2    BYTE "                      2. MEDIUM (Normal Speed)",0
strMenu3    BYTE "                      3. HARD   (Fast Speed)",0
strMenu4    BYTE "                      4. EXIT",0
strPrompt   BYTE "                      Select option (1-4): ",0
strPaused   BYTE "                        *** GAME PAUSED ***",0
strResume   BYTE "                     Press P to Resume or ESC to Quit",0
strGameOverMsg BYTE "                      *** GAME OVER ***",0
strFinal    BYTE "                             Final Score: ",0
strPress    BYTE "                     Press any key to return to menu...",0

.code
Control PROC
    pushad
    call ReadKey
    jz movePart
    cmp al, 'w'
    je UP
    cmp al, 's'
    je DOWN
    cmp al, 'a'
    je LEFT
    cmp al, 'd'
    je RIGHT
    cmp al, 'p'
    je PAUSE_GAME
    cmp al, 'P'
    je PAUSE_GAME
    jmp movePart
PAUSE_GAME:
    call PauseGame
    jmp movePart
UP:
    cmp direction,0
    je movePart
    mov direction, 1
    jmp movePart
DOWN:
    cmp direction,1
    je movePart
    mov direction, 0
    jmp movePart
LEFT:
    cmp direction,3
    je movePart
    mov direction, 2
    jmp movePart
RIGHT:
    cmp direction,2
    je movePart
    mov direction, 3
    jmp movePart
movePart:
    cmp direction, 1
    je DEC_X
    cmp direction, 3
    je INC_Y
    cmp direction, 0
    je INC_X
    cmp direction, 2
    je DEC_Y
    jmp EndLoop
INC_X:
    inc x
    jmp EndLoop
DEC_X:
    dec x
    jmp EndLoop
INC_Y:
    inc y
    jmp EndLoop
DEC_Y:
    dec y
EndLoop:
    popad
    ret
Control ENDP

GenerateApple PROC
    pushad
    call Randomize
    mov eax, 21
    call RandomRange
    add eax,5
    mov AppleX, al
    mov eax, 79
    call RandomRange
    add eax,21
    mov AppleY, al
    inc BodySize
    movzx eax, BodySize
    cmp eax, HighScore
    jle NoRecordUpdate
    mov HighScore, eax
NoRecordUpdate: 
    popad
    ret
GenerateApple ENDP

Collision Proc
    pushad
    mov al,X
    mov bl,Y
    cmp al,AppleX
    jne NOTCONDITION
    cmp bl,AppleY
    jne NOTCONDITION    
    INVOKE Beep, 1000, 100
    call GenerateApple
NOTCONDITION:
    cmp al,4
    je DO_GAMEOVER
    cmp al,26
    je DO_GAMEOVER
    cmp bl,99
    je DO_GAMEOVER
    cmp bl,20
    je DO_GAMEOVER
    jmp NOTOVER
DO_GAMEOVER:
    mov IsGameOver, 1
    call SaveRecord
    call ShowGameOver
    popad
    ret
NOTOVER:
    call HeadCollision
    popad
    ret
Collision endp

HeadCollision proc
    pushad
    movzx eax,X
    movzx ebx,Y
    movzx ecx,BodySize
    cmp ecx,0
    jle skipFun
    mov esi,0
l1:
    cmp al,BodyX[esi]
    jne NotCondition
    cmp bl,BodyY[esi]
    jne NotCondition
    mov IsGameOver, 1
    call SaveRecord
    call ShowGameOver
    popad
    ret
NotCondition:
    inc esi
    loop l1
skipFun:
    popad
    ret
HeadCollision endp

CopyBody Proc
    pushad
    dec ecx
    mov esi,ecx
l1:
    movzx eax,BodyX[esi-1]
    movzx ebx,BodyY[esi-1]
    mov BodyX[esi],al
    mov BodyY[esi],bl
    dec esi
    cmp esi, 0
    jne l1
    popad
    ret
CopyBody endp
GenerateBody PROC
    pushad
    movzx ecx, BodySize
    cmp ecx, 0
    jle FuncComp
    cmp ecx, 1
    je SkipLoop
    call CopyBody
SkipLoop:
    movzx eax, X
    movzx ebx, Y
    mov BodyX[0], al
    mov BodyY[0], bl
FuncComp:
    popad
    ret
GenerateBody ENDP

DisplayScreen Proc
    pushad
    mov eax,0
    mov ebx,0
    mov dh,X
    mov dl,Y
    call gotoxy
    mov al,' '
    call writeChar
    movzx ecx,BodySize
    mov esi,0
    cmp ecx,0
    jle skipLoop
L5:
    mov dh,BodyX[esi]
    mov dl,BodyY[esi]
    call gotoxy
    mov al,' '
    call writeChar
    inc esi
    loop L5
skipLoop:

    call GenerateBody
    call Control
    
    cmp IsGameOver, 1
    je SkipGameLogic
    
    call Collision
    mov dh, X
    mov dl, Y
    call gotoxy
    mov al,02h
    call SetTextColor
    mov al, '$' 
    call writeChar
    mov al,05h
    call SetTextColor
    mov esi,0
    movzx ecx,BodySize
    cmp ecx,0
    jle skipLoop2
l6:
    mov dh,BodyX[esi]
    mov dl,BodyY[esi]
    call gotoxy
    mov al,'0'
    call writeChar
    inc esi
    loop l6
skipLoop2:
    mov dh, AppleX
    mov dl, AppleY
    call gotoxy
    mov al, 0Ch
    call SetTextColor
    mov al, '*'
    call WriteChar

    call DrawDashboard  
    mov dh,29
    mov dl,119
    call gotoxy
    mov eax,speedX
    cmp direction,1
    je speedUpForY
    cmp direction,0
    je speedUpForY
    mov eax,SpeedY
speedUpForY:
    call delay
SkipGameLogic:
    popad
    ret
DisplayScreen Endp

Start proc
    mov eax,0
    mov al,03h
    call SetTextColor
    mov esi,20+120*4
    mov ecx,81
l1:
    mov Screen[esi],"#"
    inc esi
    loop l1
    mov esi, 20+120*5
    mov ecx,22
L3:
    mov Screen[esi],"#"
    mov Screen[esi+80],"#"
    add esi,120
    loop L3
    mov esi,20+120*26
    mov ecx,80
l2:
    mov Screen[esi],"#"
    inc esi
    loop l2
    mov eax,0
    mov ecx,3600
    mov esi,0
DrawBorder:
    mov al,Screen[esi]
    call writeChar
    inc esi
    loop DrawBorder
    ret
Start endp

DrawDashboard PROC
    pushad
    mov al, 0Eh      
    call SetTextColor
    
    mov dh, 28
    mov dl, 20      
    call Gotoxy
    mov edx, OFFSET strScore
    call WriteString
    movzx eax, BodySize
    call WriteDec

    mov dh, 28
    mov dl, 45       
    call Gotoxy
    mov edx, OFFSET strTime
    call WriteString
    call GetMseconds
    sub eax, StartTime
    mov ebx, 1000
    mov edx, 0
    div ebx 
    call WriteDec
    mov edx, OFFSET strSec
    call WriteString
    
    mov dh, 28
    mov dl, 70    
    call Gotoxy
    mov edx, OFFSET strRecord
    call WriteString
    mov eax, HighScore
    call WriteDec
    popad
    ret
DrawDashboard ENDP

LoadRecord PROC
    pushad
    mov edx, OFFSET filename
    call OpenInputFile
    mov fileHandle, eax
    cmp eax, INVALID_HANDLE_VALUE
    je NoFile
    mov edx, OFFSET buffer
    mov ecx, SIZEOF buffer
    call ReadFromFile
    mov ByteCount, eax
    mov eax, fileHandle
    call CloseFile
    mov edx, OFFSET buffer
    mov ecx, ByteCount
    call ParseDecimal32
    mov HighScore, eax
NoFile:
    popad
    ret
LoadRecord ENDP

SaveRecord PROC
    pushad     
    mov edx, OFFSET filename
    call CreateOutputFile
    mov fileHandle, eax
    cmp eax, INVALID_HANDLE_VALUE
    je SaveError
    mov eax, HighScore
    mov ecx, 0
    mov ebx, 10
    mov edi, OFFSET buffer
    add edi, 15
    mov byte ptr [edi], 0 
    dec edi
ConvertLoop:
    mov edx, 0
    div ebx
    add dl, '0' 
    mov [edi], dl
    dec edi
    inc ecx
    cmp eax, 0
    jne ConvertLoop
    inc edi
    mov edx, edi     
    mov eax, fileHandle
    call WriteToFile
    mov eax, fileHandle
    call CloseFile
SaveError:
    popad
    ret
SaveRecord ENDP

ShowMainMenu PROC
    pushad
    call Clrscr
    mov al, 0Eh
    call SetTextColor
    
    mov dh, 3
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET strTitle1
    call WriteString
    
    mov dh, 4
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET strTitle2
    call WriteString
    
    mov dh, 5
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET strTitle3
    call WriteString
    
    mov dh, 6
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET strTitle4
    call WriteString
    
    mov dh, 7
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET strTitle5
    call WriteString
    
    mov al, 0Bh
    call SetTextColor
    
    mov dh, 11
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strMenu1
    call WriteString
    
    mov dh, 13
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strMenu2
    call WriteString
    
    mov dh, 15
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strMenu3
    call WriteString
    
    mov dh, 17
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strMenu4
    call WriteString
    
    mov al, 0Fh
    call SetTextColor
    mov dh, 20
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strPrompt
    call WriteString
    popad
    ret
ShowMainMenu ENDP

SetDifficulty PROC
    pushad
    cmp al, '1'
    je EasyMode
    cmp al, '2'
    je MediumMode
    cmp al, '3'
    je HardMode
    jmp EndSetDiff
    
EasyMode:
    mov SpeedX, 200
    mov SpeedY, 80
    jmp EndSetDiff
    
MediumMode:
    mov SpeedX, 125
    mov SpeedY, 50
    jmp EndSetDiff
    
HardMode:
    mov SpeedX, 60
    mov SpeedY, 25
    
EndSetDiff:
    popad
    ret
SetDifficulty ENDP

ResetGame PROC
    pushad
    mov X, 10
    mov Y, 24
    mov Direction, 3
    mov AppleX, 10
    mov AppleY, 23    
    mov BodySize, -1
    mov IsGameOver, 0
    mov GamePaused, 0
    mov ecx, 8099
    mov esi, 0
ClearBodyLoop:
    mov BodyX[esi], 0
    mov BodyY[esi], 0
    inc esi
    loop ClearBodyLoop
    mov ecx, 8100
    mov esi, 0
ClearScreenLoop:
    mov Screen[esi], ' '
    inc esi
    loop ClearScreenLoop
    call Clrscr
    popad
    ret
ResetGame ENDP

PauseGame PROC
    pushad
    mov GamePaused, 1
    call GetMseconds
    mov PauseTimeStart, eax
PauseLoop:
    mov al, 0Eh
    call SetTextColor
    mov dh, 14
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET strPaused
    call WriteString
    mov al, 0Fh
    call SetTextColor
    mov dh, 16
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET strResume
    call WriteString
    
    call ReadKey
    jz PauseLoop
    cmp al, 'p'
    je ResumeGame
    cmp al, 'P'
    je ResumeGame
    cmp al, 27
    je QuitToMenu
    jmp PauseLoop
    
ResumeGame:
    mov GamePaused, 0
    call GetMseconds
    sub eax, PauseTimeStart 
    add StartTime, eax      
    
    call Clrscr
    call Start
    jmp EndPause
    
QuitToMenu:
    mov IsGameOver, 1
    call SaveRecord
    
EndPause:
    popad
    ret
PauseGame ENDP

ShowGameOver PROC
    pushad
    mov eax, 100
    call Delay
    mov al, 0Ch
    call SetTextColor
    mov dh, 14
    mov dl, 32
    call Gotoxy
    mov edx, OFFSET strGameOverMsg
    call WriteString
    
    mov al, 0Eh
    call SetTextColor
    mov dh, 16
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET strFinal
    call WriteString
    movzx eax, BodySize
    call WriteDec
    
    mov al, 0Fh
    call SetTextColor
    mov dh, 19
    mov dl, 22
    call Gotoxy
    mov edx, OFFSET strPress
    call WriteString

    call ReadChar
    popad
    ret
ShowGameOver ENDP
main proc
    call LoadRecord
MainMenuLoop:
    call ShowMainMenu
    call ReadChar
    cmp al, '1'
    je StartGame
    cmp al, '2'
    je StartGame
    cmp al, '3'
    je StartGame
    cmp al, '4'
    je ExitGame
    jmp MainMenuLoop
StartGame:
    call SetDifficulty
    call ResetGame
    call GetMseconds
    mov StartTime, eax
    call Start
    call GenerateApple
GameLoop:
    call DisplayScreen
    cmp IsGameOver, 1
    je MainMenuLoop
    jmp GameLoop
ExitGame:
    call Clrscr
    exit
main endp
END main