
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 74 02 00 00       	call   282 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 fc 02 00 00       	call   31a <sleep>
  exit();
  1e:	e8 67 02 00 00       	call   28a <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  54:	90                   	nop
  55:	8b 45 0c             	mov    0xc(%ebp),%eax
  58:	0f b6 10             	movzbl (%eax),%edx
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	88 10                	mov    %dl,(%eax)
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	0f b6 00             	movzbl (%eax),%eax
  66:	84 c0                	test   %al,%al
  68:	0f 95 c0             	setne  %al
  6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  6f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  73:	84 c0                	test   %al,%al
  75:	75 de                	jne    55 <strcpy+0xd>
    ;
  return os;
  77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7a:	c9                   	leave  
  7b:	c3                   	ret    

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7f:	eb 08                	jmp    89 <strcmp+0xd>
    p++, q++;
  81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  85:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  89:	8b 45 08             	mov    0x8(%ebp),%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	84 c0                	test   %al,%al
  91:	74 10                	je     a3 <strcmp+0x27>
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 10             	movzbl (%eax),%edx
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 00             	movzbl (%eax),%eax
  9f:	38 c2                	cmp    %al,%dl
  a1:	74 de                	je     81 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	0f b6 00             	movzbl (%eax),%eax
  a9:	0f b6 d0             	movzbl %al,%edx
  ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	0f b6 c0             	movzbl %al,%eax
  b5:	89 d1                	mov    %edx,%ecx
  b7:	29 c1                	sub    %eax,%ecx
  b9:	89 c8                	mov    %ecx,%eax
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <strlen>:

uint
strlen(char *s)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ca:	eb 04                	jmp    d0 <strlen+0x13>
  cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	01 d0                	add    %edx,%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 ed                	jne    cc <strlen+0xf>
    ;
  return n;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave  
  e3:	c3                   	ret    

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  ea:	8b 45 10             	mov    0x10(%ebp),%eax
  ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	89 04 24             	mov    %eax,(%esp)
  fe:	e8 20 ff ff ff       	call   23 <stosb>
  return dst;
 103:	8b 45 08             	mov    0x8(%ebp),%eax
}
 106:	c9                   	leave  
 107:	c3                   	ret    

00000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	83 ec 04             	sub    $0x4,%esp
 10e:	8b 45 0c             	mov    0xc(%ebp),%eax
 111:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 114:	eb 14                	jmp    12a <strchr+0x22>
    if(*s == c)
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 11f:	75 05                	jne    126 <strchr+0x1e>
      return (char*)s;
 121:	8b 45 08             	mov    0x8(%ebp),%eax
 124:	eb 13                	jmp    139 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 126:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	0f b6 00             	movzbl (%eax),%eax
 130:	84 c0                	test   %al,%al
 132:	75 e2                	jne    116 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 134:	b8 00 00 00 00       	mov    $0x0,%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <gets>:

char*
gets(char *buf, int max)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 141:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 148:	eb 46                	jmp    190 <gets+0x55>
    cc = read(0, &c, 1);
 14a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 151:	00 
 152:	8d 45 ef             	lea    -0x11(%ebp),%eax
 155:	89 44 24 04          	mov    %eax,0x4(%esp)
 159:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 160:	e8 3d 01 00 00       	call   2a2 <read>
 165:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 168:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 16c:	7e 2f                	jle    19d <gets+0x62>
      break;
    buf[i++] = c;
 16e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	01 c2                	add    %eax,%edx
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	88 02                	mov    %al,(%edx)
 17c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 184:	3c 0a                	cmp    $0xa,%al
 186:	74 16                	je     19e <gets+0x63>
 188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18c:	3c 0d                	cmp    $0xd,%al
 18e:	74 0e                	je     19e <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	8b 45 f4             	mov    -0xc(%ebp),%eax
 193:	83 c0 01             	add    $0x1,%eax
 196:	3b 45 0c             	cmp    0xc(%ebp),%eax
 199:	7c af                	jl     14a <gets+0xf>
 19b:	eb 01                	jmp    19e <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 19d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a1:	8b 45 08             	mov    0x8(%ebp),%eax
 1a4:	01 d0                	add    %edx,%eax
 1a6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ac:	c9                   	leave  
 1ad:	c3                   	ret    

000001ae <stat>:

int
stat(char *n, struct stat *st)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1bb:	00 
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	89 04 24             	mov    %eax,(%esp)
 1c2:	e8 03 01 00 00       	call   2ca <open>
 1c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ce:	79 07                	jns    1d7 <stat+0x29>
    return -1;
 1d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d5:	eb 23                	jmp    1fa <stat+0x4c>
  r = fstat(fd, st);
 1d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1da:	89 44 24 04          	mov    %eax,0x4(%esp)
 1de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 f9 00 00 00       	call   2e2 <fstat>
 1e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ef:	89 04 24             	mov    %eax,(%esp)
 1f2:	e8 bb 00 00 00       	call   2b2 <close>
  return r;
 1f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1fa:	c9                   	leave  
 1fb:	c3                   	ret    

000001fc <atoi>:

int
atoi(const char *s)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 202:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 209:	eb 23                	jmp    22e <atoi+0x32>
    n = n*10 + *s++ - '0';
 20b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20e:	89 d0                	mov    %edx,%eax
 210:	c1 e0 02             	shl    $0x2,%eax
 213:	01 d0                	add    %edx,%eax
 215:	01 c0                	add    %eax,%eax
 217:	89 c2                	mov    %eax,%edx
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	0f be c0             	movsbl %al,%eax
 222:	01 d0                	add    %edx,%eax
 224:	83 e8 30             	sub    $0x30,%eax
 227:	89 45 fc             	mov    %eax,-0x4(%ebp)
 22a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	3c 2f                	cmp    $0x2f,%al
 236:	7e 0a                	jle    242 <atoi+0x46>
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	3c 39                	cmp    $0x39,%al
 240:	7e c9                	jle    20b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 242:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 245:	c9                   	leave  
 246:	c3                   	ret    

00000247 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
 24a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 259:	eb 13                	jmp    26e <memmove+0x27>
    *dst++ = *src++;
 25b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 25e:	0f b6 10             	movzbl (%eax),%edx
 261:	8b 45 fc             	mov    -0x4(%ebp),%eax
 264:	88 10                	mov    %dl,(%eax)
 266:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 26a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 272:	0f 9f c0             	setg   %al
 275:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 279:	84 c0                	test   %al,%al
 27b:	75 de                	jne    25b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 282:	b8 01 00 00 00       	mov    $0x1,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <exit>:
SYSCALL(exit)
 28a:	b8 02 00 00 00       	mov    $0x2,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <wait>:
SYSCALL(wait)
 292:	b8 03 00 00 00       	mov    $0x3,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <pipe>:
SYSCALL(pipe)
 29a:	b8 04 00 00 00       	mov    $0x4,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <read>:
SYSCALL(read)
 2a2:	b8 05 00 00 00       	mov    $0x5,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <write>:
SYSCALL(write)
 2aa:	b8 10 00 00 00       	mov    $0x10,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <close>:
SYSCALL(close)
 2b2:	b8 15 00 00 00       	mov    $0x15,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <kill>:
SYSCALL(kill)
 2ba:	b8 06 00 00 00       	mov    $0x6,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <exec>:
SYSCALL(exec)
 2c2:	b8 07 00 00 00       	mov    $0x7,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <open>:
SYSCALL(open)
 2ca:	b8 0f 00 00 00       	mov    $0xf,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <mknod>:
SYSCALL(mknod)
 2d2:	b8 11 00 00 00       	mov    $0x11,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <unlink>:
SYSCALL(unlink)
 2da:	b8 12 00 00 00       	mov    $0x12,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <fstat>:
SYSCALL(fstat)
 2e2:	b8 08 00 00 00       	mov    $0x8,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <link>:
SYSCALL(link)
 2ea:	b8 13 00 00 00       	mov    $0x13,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <mkdir>:
SYSCALL(mkdir)
 2f2:	b8 14 00 00 00       	mov    $0x14,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <chdir>:
SYSCALL(chdir)
 2fa:	b8 09 00 00 00       	mov    $0x9,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <dup>:
SYSCALL(dup)
 302:	b8 0a 00 00 00       	mov    $0xa,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <getpid>:
SYSCALL(getpid)
 30a:	b8 0b 00 00 00       	mov    $0xb,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <sbrk>:
SYSCALL(sbrk)
 312:	b8 0c 00 00 00       	mov    $0xc,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <sleep>:
SYSCALL(sleep)
 31a:	b8 0d 00 00 00       	mov    $0xd,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <uptime>:
SYSCALL(uptime)
 322:	b8 0e 00 00 00       	mov    $0xe,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <getprocs>:
SYSCALL(getprocs)
 32a:	b8 16 00 00 00       	mov    $0x16,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 28             	sub    $0x28,%esp
 338:	8b 45 0c             	mov    0xc(%ebp),%eax
 33b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 33e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 345:	00 
 346:	8d 45 f4             	lea    -0xc(%ebp),%eax
 349:	89 44 24 04          	mov    %eax,0x4(%esp)
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	89 04 24             	mov    %eax,(%esp)
 353:	e8 52 ff ff ff       	call   2aa <write>
}
 358:	c9                   	leave  
 359:	c3                   	ret    

0000035a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 360:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 367:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 36b:	74 17                	je     384 <printint+0x2a>
 36d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 371:	79 11                	jns    384 <printint+0x2a>
    neg = 1;
 373:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	f7 d8                	neg    %eax
 37f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 382:	eb 06                	jmp    38a <printint+0x30>
  } else {
    x = xx;
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 38a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 391:	8b 4d 10             	mov    0x10(%ebp),%ecx
 394:	8b 45 ec             	mov    -0x14(%ebp),%eax
 397:	ba 00 00 00 00       	mov    $0x0,%edx
 39c:	f7 f1                	div    %ecx
 39e:	89 d0                	mov    %edx,%eax
 3a0:	0f b6 80 20 0a 00 00 	movzbl 0xa20(%eax),%eax
 3a7:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3ad:	01 ca                	add    %ecx,%edx
 3af:	88 02                	mov    %al,(%edx)
 3b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3b5:	8b 55 10             	mov    0x10(%ebp),%edx
 3b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3be:	ba 00 00 00 00       	mov    $0x0,%edx
 3c3:	f7 75 d4             	divl   -0x2c(%ebp)
 3c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3cd:	75 c2                	jne    391 <printint+0x37>
  if(neg)
 3cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d3:	74 2e                	je     403 <printint+0xa9>
    buf[i++] = '-';
 3d5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3db:	01 d0                	add    %edx,%eax
 3dd:	c6 00 2d             	movb   $0x2d,(%eax)
 3e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 3e4:	eb 1d                	jmp    403 <printint+0xa9>
    putc(fd, buf[i]);
 3e6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ec:	01 d0                	add    %edx,%eax
 3ee:	0f b6 00             	movzbl (%eax),%eax
 3f1:	0f be c0             	movsbl %al,%eax
 3f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	89 04 24             	mov    %eax,(%esp)
 3fe:	e8 2f ff ff ff       	call   332 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 403:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 40b:	79 d9                	jns    3e6 <printint+0x8c>
    putc(fd, buf[i]);
}
 40d:	c9                   	leave  
 40e:	c3                   	ret    

0000040f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp
 412:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 415:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 41c:	8d 45 0c             	lea    0xc(%ebp),%eax
 41f:	83 c0 04             	add    $0x4,%eax
 422:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 42c:	e9 7d 01 00 00       	jmp    5ae <printf+0x19f>
    c = fmt[i] & 0xff;
 431:	8b 55 0c             	mov    0xc(%ebp),%edx
 434:	8b 45 f0             	mov    -0x10(%ebp),%eax
 437:	01 d0                	add    %edx,%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	0f be c0             	movsbl %al,%eax
 43f:	25 ff 00 00 00       	and    $0xff,%eax
 444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 447:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44b:	75 2c                	jne    479 <printf+0x6a>
      if(c == '%'){
 44d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 451:	75 0c                	jne    45f <printf+0x50>
        state = '%';
 453:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 45a:	e9 4b 01 00 00       	jmp    5aa <printf+0x19b>
      } else {
        putc(fd, c);
 45f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 462:	0f be c0             	movsbl %al,%eax
 465:	89 44 24 04          	mov    %eax,0x4(%esp)
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	89 04 24             	mov    %eax,(%esp)
 46f:	e8 be fe ff ff       	call   332 <putc>
 474:	e9 31 01 00 00       	jmp    5aa <printf+0x19b>
      }
    } else if(state == '%'){
 479:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 47d:	0f 85 27 01 00 00    	jne    5aa <printf+0x19b>
      if(c == 'd'){
 483:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 487:	75 2d                	jne    4b6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 489:	8b 45 e8             	mov    -0x18(%ebp),%eax
 48c:	8b 00                	mov    (%eax),%eax
 48e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 495:	00 
 496:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 49d:	00 
 49e:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	89 04 24             	mov    %eax,(%esp)
 4a8:	e8 ad fe ff ff       	call   35a <printint>
        ap++;
 4ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4b1:	e9 ed 00 00 00       	jmp    5a3 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4b6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ba:	74 06                	je     4c2 <printf+0xb3>
 4bc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4c0:	75 2d                	jne    4ef <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c5:	8b 00                	mov    (%eax),%eax
 4c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4ce:	00 
 4cf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4d6:	00 
 4d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	89 04 24             	mov    %eax,(%esp)
 4e1:	e8 74 fe ff ff       	call   35a <printint>
        ap++;
 4e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ea:	e9 b4 00 00 00       	jmp    5a3 <printf+0x194>
      } else if(c == 's'){
 4ef:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f3:	75 46                	jne    53b <printf+0x12c>
        s = (char*)*ap;
 4f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f8:	8b 00                	mov    (%eax),%eax
 4fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 505:	75 27                	jne    52e <printf+0x11f>
          s = "(null)";
 507:	c7 45 f4 dc 07 00 00 	movl   $0x7dc,-0xc(%ebp)
        while(*s != 0){
 50e:	eb 1e                	jmp    52e <printf+0x11f>
          putc(fd, *s);
 510:	8b 45 f4             	mov    -0xc(%ebp),%eax
 513:	0f b6 00             	movzbl (%eax),%eax
 516:	0f be c0             	movsbl %al,%eax
 519:	89 44 24 04          	mov    %eax,0x4(%esp)
 51d:	8b 45 08             	mov    0x8(%ebp),%eax
 520:	89 04 24             	mov    %eax,(%esp)
 523:	e8 0a fe ff ff       	call   332 <putc>
          s++;
 528:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 52c:	eb 01                	jmp    52f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 52e:	90                   	nop
 52f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 532:	0f b6 00             	movzbl (%eax),%eax
 535:	84 c0                	test   %al,%al
 537:	75 d7                	jne    510 <printf+0x101>
 539:	eb 68                	jmp    5a3 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 53f:	75 1d                	jne    55e <printf+0x14f>
        putc(fd, *ap);
 541:	8b 45 e8             	mov    -0x18(%ebp),%eax
 544:	8b 00                	mov    (%eax),%eax
 546:	0f be c0             	movsbl %al,%eax
 549:	89 44 24 04          	mov    %eax,0x4(%esp)
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	89 04 24             	mov    %eax,(%esp)
 553:	e8 da fd ff ff       	call   332 <putc>
        ap++;
 558:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55c:	eb 45                	jmp    5a3 <printf+0x194>
      } else if(c == '%'){
 55e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 562:	75 17                	jne    57b <printf+0x16c>
        putc(fd, c);
 564:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 567:	0f be c0             	movsbl %al,%eax
 56a:	89 44 24 04          	mov    %eax,0x4(%esp)
 56e:	8b 45 08             	mov    0x8(%ebp),%eax
 571:	89 04 24             	mov    %eax,(%esp)
 574:	e8 b9 fd ff ff       	call   332 <putc>
 579:	eb 28                	jmp    5a3 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 582:	00 
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	89 04 24             	mov    %eax,(%esp)
 589:	e8 a4 fd ff ff       	call   332 <putc>
        putc(fd, c);
 58e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	89 44 24 04          	mov    %eax,0x4(%esp)
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	89 04 24             	mov    %eax,(%esp)
 59e:	e8 8f fd ff ff       	call   332 <putc>
      }
      state = 0;
 5a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5aa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b4:	01 d0                	add    %edx,%eax
 5b6:	0f b6 00             	movzbl (%eax),%eax
 5b9:	84 c0                	test   %al,%al
 5bb:	0f 85 70 fe ff ff    	jne    431 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c1:	c9                   	leave  
 5c2:	c3                   	ret    

000005c3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c3:	55                   	push   %ebp
 5c4:	89 e5                	mov    %esp,%ebp
 5c6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	83 e8 08             	sub    $0x8,%eax
 5cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d2:	a1 3c 0a 00 00       	mov    0xa3c,%eax
 5d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5da:	eb 24                	jmp    600 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5df:	8b 00                	mov    (%eax),%eax
 5e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e4:	77 12                	ja     5f8 <free+0x35>
 5e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ec:	77 24                	ja     612 <free+0x4f>
 5ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f1:	8b 00                	mov    (%eax),%eax
 5f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f6:	77 1a                	ja     612 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fb:	8b 00                	mov    (%eax),%eax
 5fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 600:	8b 45 f8             	mov    -0x8(%ebp),%eax
 603:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 606:	76 d4                	jbe    5dc <free+0x19>
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 610:	76 ca                	jbe    5dc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	8b 40 04             	mov    0x4(%eax),%eax
 618:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	01 c2                	add    %eax,%edx
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	39 c2                	cmp    %eax,%edx
 62b:	75 24                	jne    651 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 62d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 630:	8b 50 04             	mov    0x4(%eax),%edx
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	8b 40 04             	mov    0x4(%eax),%eax
 63b:	01 c2                	add    %eax,%edx
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	8b 10                	mov    (%eax),%edx
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	89 10                	mov    %edx,(%eax)
 64f:	eb 0a                	jmp    65b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 10                	mov    (%eax),%edx
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	01 d0                	add    %edx,%eax
 66d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 670:	75 20                	jne    692 <free+0xcf>
    p->s.size += bp->s.size;
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 50 04             	mov    0x4(%eax),%edx
 678:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67b:	8b 40 04             	mov    0x4(%eax),%eax
 67e:	01 c2                	add    %eax,%edx
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
 690:	eb 08                	jmp    69a <free+0xd7>
  } else
    p->s.ptr = bp;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 55 f8             	mov    -0x8(%ebp),%edx
 698:	89 10                	mov    %edx,(%eax)
  freep = p;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	a3 3c 0a 00 00       	mov    %eax,0xa3c
}
 6a2:	c9                   	leave  
 6a3:	c3                   	ret    

000006a4 <morecore>:

static Header*
morecore(uint nu)
{
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6aa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6b1:	77 07                	ja     6ba <morecore+0x16>
    nu = 4096;
 6b3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	c1 e0 03             	shl    $0x3,%eax
 6c0:	89 04 24             	mov    %eax,(%esp)
 6c3:	e8 4a fc ff ff       	call   312 <sbrk>
 6c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6cb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6cf:	75 07                	jne    6d8 <morecore+0x34>
    return 0;
 6d1:	b8 00 00 00 00       	mov    $0x0,%eax
 6d6:	eb 22                	jmp    6fa <morecore+0x56>
  hp = (Header*)p;
 6d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e1:	8b 55 08             	mov    0x8(%ebp),%edx
 6e4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ea:	83 c0 08             	add    $0x8,%eax
 6ed:	89 04 24             	mov    %eax,(%esp)
 6f0:	e8 ce fe ff ff       	call   5c3 <free>
  return freep;
 6f5:	a1 3c 0a 00 00       	mov    0xa3c,%eax
}
 6fa:	c9                   	leave  
 6fb:	c3                   	ret    

000006fc <malloc>:

void*
malloc(uint nbytes)
{
 6fc:	55                   	push   %ebp
 6fd:	89 e5                	mov    %esp,%ebp
 6ff:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	83 c0 07             	add    $0x7,%eax
 708:	c1 e8 03             	shr    $0x3,%eax
 70b:	83 c0 01             	add    $0x1,%eax
 70e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 711:	a1 3c 0a 00 00       	mov    0xa3c,%eax
 716:	89 45 f0             	mov    %eax,-0x10(%ebp)
 719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71d:	75 23                	jne    742 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 71f:	c7 45 f0 34 0a 00 00 	movl   $0xa34,-0x10(%ebp)
 726:	8b 45 f0             	mov    -0x10(%ebp),%eax
 729:	a3 3c 0a 00 00       	mov    %eax,0xa3c
 72e:	a1 3c 0a 00 00       	mov    0xa3c,%eax
 733:	a3 34 0a 00 00       	mov    %eax,0xa34
    base.s.size = 0;
 738:	c7 05 38 0a 00 00 00 	movl   $0x0,0xa38
 73f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 74a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74d:	8b 40 04             	mov    0x4(%eax),%eax
 750:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 753:	72 4d                	jb     7a2 <malloc+0xa6>
      if(p->s.size == nunits)
 755:	8b 45 f4             	mov    -0xc(%ebp),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75e:	75 0c                	jne    76c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 760:	8b 45 f4             	mov    -0xc(%ebp),%eax
 763:	8b 10                	mov    (%eax),%edx
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	89 10                	mov    %edx,(%eax)
 76a:	eb 26                	jmp    792 <malloc+0x96>
      else {
        p->s.size -= nunits;
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	89 c2                	mov    %eax,%edx
 774:	2b 55 ec             	sub    -0x14(%ebp),%edx
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8b 40 04             	mov    0x4(%eax),%eax
 783:	c1 e0 03             	shl    $0x3,%eax
 786:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 78f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 792:	8b 45 f0             	mov    -0x10(%ebp),%eax
 795:	a3 3c 0a 00 00       	mov    %eax,0xa3c
      return (void*)(p + 1);
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	83 c0 08             	add    $0x8,%eax
 7a0:	eb 38                	jmp    7da <malloc+0xde>
    }
    if(p == freep)
 7a2:	a1 3c 0a 00 00       	mov    0xa3c,%eax
 7a7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7aa:	75 1b                	jne    7c7 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7af:	89 04 24             	mov    %eax,(%esp)
 7b2:	e8 ed fe ff ff       	call   6a4 <morecore>
 7b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7be:	75 07                	jne    7c7 <malloc+0xcb>
        return 0;
 7c0:	b8 00 00 00 00       	mov    $0x0,%eax
 7c5:	eb 13                	jmp    7da <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 00                	mov    (%eax),%eax
 7d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7d5:	e9 70 ff ff ff       	jmp    74a <malloc+0x4e>
}
 7da:	c9                   	leave  
 7db:	c3                   	ret    
