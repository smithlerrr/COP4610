
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 32 08 00 	movl   $0x832,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 42 04 00 00       	call   465 <printf>
    exit();
  23:	e8 b8 02 00 00       	call   2e0 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 fc 02 00 00       	call   340 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 45 08 00 	movl   $0x845,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 f1 03 00 00       	call   465 <printf>
  exit();
  74:	e8 67 02 00 00       	call   2e0 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  aa:	90                   	nop
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	0f b6 10             	movzbl (%eax),%edx
  b1:	8b 45 08             	mov    0x8(%ebp),%eax
  b4:	88 10                	mov    %dl,(%eax)
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	0f b6 00             	movzbl (%eax),%eax
  bc:	84 c0                	test   %al,%al
  be:	0f 95 c0             	setne  %al
  c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  c9:	84 c0                	test   %al,%al
  cb:	75 de                	jne    ab <strcpy+0xd>
    ;
  return os;
  cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d0:	c9                   	leave  
  d1:	c3                   	ret    

000000d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d2:	55                   	push   %ebp
  d3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d5:	eb 08                	jmp    df <strcmp+0xd>
    p++, q++;
  d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  db:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	84 c0                	test   %al,%al
  e7:	74 10                	je     f9 <strcmp+0x27>
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	0f b6 10             	movzbl (%eax),%edx
  ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	38 c2                	cmp    %al,%dl
  f7:	74 de                	je     d7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	0f b6 d0             	movzbl %al,%edx
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	0f b6 c0             	movzbl %al,%eax
 10b:	89 d1                	mov    %edx,%ecx
 10d:	29 c1                	sub    %eax,%ecx
 10f:	89 c8                	mov    %ecx,%eax
}
 111:	5d                   	pop    %ebp
 112:	c3                   	ret    

00000113 <strlen>:

uint
strlen(char *s)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 120:	eb 04                	jmp    126 <strlen+0x13>
 122:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 126:	8b 55 fc             	mov    -0x4(%ebp),%edx
 129:	8b 45 08             	mov    0x8(%ebp),%eax
 12c:	01 d0                	add    %edx,%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 ed                	jne    122 <strlen+0xf>
    ;
  return n;
 135:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <memset>:

void*
memset(void *dst, int c, uint n)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 140:	8b 45 10             	mov    0x10(%ebp),%eax
 143:	89 44 24 08          	mov    %eax,0x8(%esp)
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	89 44 24 04          	mov    %eax,0x4(%esp)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	89 04 24             	mov    %eax,(%esp)
 154:	e8 20 ff ff ff       	call   79 <stosb>
  return dst;
 159:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <strchr>:

char*
strchr(const char *s, char c)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 04             	sub    $0x4,%esp
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16a:	eb 14                	jmp    180 <strchr+0x22>
    if(*s == c)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	3a 45 fc             	cmp    -0x4(%ebp),%al
 175:	75 05                	jne    17c <strchr+0x1e>
      return (char*)s;
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	eb 13                	jmp    18f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	84 c0                	test   %al,%al
 188:	75 e2                	jne    16c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 18a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <gets>:

char*
gets(char *buf, int max)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 197:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19e:	eb 46                	jmp    1e6 <gets+0x55>
    cc = read(0, &c, 1);
 1a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a7:	00 
 1a8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 1af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b6:	e8 3d 01 00 00       	call   2f8 <read>
 1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c2:	7e 2f                	jle    1f3 <gets+0x62>
      break;
    buf[i++] = c;
 1c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 c2                	add    %eax,%edx
 1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d0:	88 02                	mov    %al,(%edx)
 1d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1da:	3c 0a                	cmp    $0xa,%al
 1dc:	74 16                	je     1f4 <gets+0x63>
 1de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e2:	3c 0d                	cmp    $0xd,%al
 1e4:	74 0e                	je     1f4 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e9:	83 c0 01             	add    $0x1,%eax
 1ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ef:	7c af                	jl     1a0 <gets+0xf>
 1f1:	eb 01                	jmp    1f4 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f3:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	01 d0                	add    %edx,%eax
 1fc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
 202:	c9                   	leave  
 203:	c3                   	ret    

00000204 <stat>:

int
stat(char *n, struct stat *st)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 211:	00 
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	89 04 24             	mov    %eax,(%esp)
 218:	e8 03 01 00 00       	call   320 <open>
 21d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 224:	79 07                	jns    22d <stat+0x29>
    return -1;
 226:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22b:	eb 23                	jmp    250 <stat+0x4c>
  r = fstat(fd, st);
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	89 44 24 04          	mov    %eax,0x4(%esp)
 234:	8b 45 f4             	mov    -0xc(%ebp),%eax
 237:	89 04 24             	mov    %eax,(%esp)
 23a:	e8 f9 00 00 00       	call   338 <fstat>
 23f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 242:	8b 45 f4             	mov    -0xc(%ebp),%eax
 245:	89 04 24             	mov    %eax,(%esp)
 248:	e8 bb 00 00 00       	call   308 <close>
  return r;
 24d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <atoi>:

int
atoi(const char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25f:	eb 23                	jmp    284 <atoi+0x32>
    n = n*10 + *s++ - '0';
 261:	8b 55 fc             	mov    -0x4(%ebp),%edx
 264:	89 d0                	mov    %edx,%eax
 266:	c1 e0 02             	shl    $0x2,%eax
 269:	01 d0                	add    %edx,%eax
 26b:	01 c0                	add    %eax,%eax
 26d:	89 c2                	mov    %eax,%edx
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	0f b6 00             	movzbl (%eax),%eax
 275:	0f be c0             	movsbl %al,%eax
 278:	01 d0                	add    %edx,%eax
 27a:	83 e8 30             	sub    $0x30,%eax
 27d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 280:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	0f b6 00             	movzbl (%eax),%eax
 28a:	3c 2f                	cmp    $0x2f,%al
 28c:	7e 0a                	jle    298 <atoi+0x46>
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	3c 39                	cmp    $0x39,%al
 296:	7e c9                	jle    261 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29b:	c9                   	leave  
 29c:	c3                   	ret    

0000029d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2af:	eb 13                	jmp    2c4 <memmove+0x27>
    *dst++ = *src++;
 2b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b4:	0f b6 10             	movzbl (%eax),%edx
 2b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ba:	88 10                	mov    %dl,(%eax)
 2bc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2c0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c8:	0f 9f c0             	setg   %al
 2cb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2cf:	84 c0                	test   %al,%al
 2d1:	75 de                	jne    2b1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d6:	c9                   	leave  
 2d7:	c3                   	ret    

000002d8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d8:	b8 01 00 00 00       	mov    $0x1,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <exit>:
SYSCALL(exit)
 2e0:	b8 02 00 00 00       	mov    $0x2,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <wait>:
SYSCALL(wait)
 2e8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <pipe>:
SYSCALL(pipe)
 2f0:	b8 04 00 00 00       	mov    $0x4,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <read>:
SYSCALL(read)
 2f8:	b8 05 00 00 00       	mov    $0x5,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <write>:
SYSCALL(write)
 300:	b8 10 00 00 00       	mov    $0x10,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <close>:
SYSCALL(close)
 308:	b8 15 00 00 00       	mov    $0x15,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <kill>:
SYSCALL(kill)
 310:	b8 06 00 00 00       	mov    $0x6,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <exec>:
SYSCALL(exec)
 318:	b8 07 00 00 00       	mov    $0x7,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <open>:
SYSCALL(open)
 320:	b8 0f 00 00 00       	mov    $0xf,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <mknod>:
SYSCALL(mknod)
 328:	b8 11 00 00 00       	mov    $0x11,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <unlink>:
SYSCALL(unlink)
 330:	b8 12 00 00 00       	mov    $0x12,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <fstat>:
SYSCALL(fstat)
 338:	b8 08 00 00 00       	mov    $0x8,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <link>:
SYSCALL(link)
 340:	b8 13 00 00 00       	mov    $0x13,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <mkdir>:
SYSCALL(mkdir)
 348:	b8 14 00 00 00       	mov    $0x14,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <chdir>:
SYSCALL(chdir)
 350:	b8 09 00 00 00       	mov    $0x9,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <dup>:
SYSCALL(dup)
 358:	b8 0a 00 00 00       	mov    $0xa,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <getpid>:
SYSCALL(getpid)
 360:	b8 0b 00 00 00       	mov    $0xb,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <sbrk>:
SYSCALL(sbrk)
 368:	b8 0c 00 00 00       	mov    $0xc,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <sleep>:
SYSCALL(sleep)
 370:	b8 0d 00 00 00       	mov    $0xd,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <uptime>:
SYSCALL(uptime)
 378:	b8 0e 00 00 00       	mov    $0xe,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <getprocs>:
SYSCALL(getprocs)
 380:	b8 16 00 00 00       	mov    $0x16,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	83 ec 28             	sub    $0x28,%esp
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 394:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39b:	00 
 39c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39f:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	89 04 24             	mov    %eax,(%esp)
 3a9:	e8 52 ff ff ff       	call   300 <write>
}
 3ae:	c9                   	leave  
 3af:	c3                   	ret    

000003b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c1:	74 17                	je     3da <printint+0x2a>
 3c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c7:	79 11                	jns    3da <printint+0x2a>
    neg = 1;
 3c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d3:	f7 d8                	neg    %eax
 3d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d8:	eb 06                	jmp    3e0 <printint+0x30>
  } else {
    x = xx;
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ed:	ba 00 00 00 00       	mov    $0x0,%edx
 3f2:	f7 f1                	div    %ecx
 3f4:	89 d0                	mov    %edx,%eax
 3f6:	0f b6 80 9c 0a 00 00 	movzbl 0xa9c(%eax),%eax
 3fd:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 400:	8b 55 f4             	mov    -0xc(%ebp),%edx
 403:	01 ca                	add    %ecx,%edx
 405:	88 02                	mov    %al,(%edx)
 407:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 40b:	8b 55 10             	mov    0x10(%ebp),%edx
 40e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 411:	8b 45 ec             	mov    -0x14(%ebp),%eax
 414:	ba 00 00 00 00       	mov    $0x0,%edx
 419:	f7 75 d4             	divl   -0x2c(%ebp)
 41c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 423:	75 c2                	jne    3e7 <printint+0x37>
  if(neg)
 425:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 429:	74 2e                	je     459 <printint+0xa9>
    buf[i++] = '-';
 42b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 431:	01 d0                	add    %edx,%eax
 433:	c6 00 2d             	movb   $0x2d,(%eax)
 436:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 43a:	eb 1d                	jmp    459 <printint+0xa9>
    putc(fd, buf[i]);
 43c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 442:	01 d0                	add    %edx,%eax
 444:	0f b6 00             	movzbl (%eax),%eax
 447:	0f be c0             	movsbl %al,%eax
 44a:	89 44 24 04          	mov    %eax,0x4(%esp)
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	89 04 24             	mov    %eax,(%esp)
 454:	e8 2f ff ff ff       	call   388 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 459:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 45d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 461:	79 d9                	jns    43c <printint+0x8c>
    putc(fd, buf[i]);
}
 463:	c9                   	leave  
 464:	c3                   	ret    

00000465 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 465:	55                   	push   %ebp
 466:	89 e5                	mov    %esp,%ebp
 468:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 46b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 472:	8d 45 0c             	lea    0xc(%ebp),%eax
 475:	83 c0 04             	add    $0x4,%eax
 478:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 47b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 482:	e9 7d 01 00 00       	jmp    604 <printf+0x19f>
    c = fmt[i] & 0xff;
 487:	8b 55 0c             	mov    0xc(%ebp),%edx
 48a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 48d:	01 d0                	add    %edx,%eax
 48f:	0f b6 00             	movzbl (%eax),%eax
 492:	0f be c0             	movsbl %al,%eax
 495:	25 ff 00 00 00       	and    $0xff,%eax
 49a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 49d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a1:	75 2c                	jne    4cf <printf+0x6a>
      if(c == '%'){
 4a3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a7:	75 0c                	jne    4b5 <printf+0x50>
        state = '%';
 4a9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b0:	e9 4b 01 00 00       	jmp    600 <printf+0x19b>
      } else {
        putc(fd, c);
 4b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b8:	0f be c0             	movsbl %al,%eax
 4bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
 4c2:	89 04 24             	mov    %eax,(%esp)
 4c5:	e8 be fe ff ff       	call   388 <putc>
 4ca:	e9 31 01 00 00       	jmp    600 <printf+0x19b>
      }
    } else if(state == '%'){
 4cf:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4d3:	0f 85 27 01 00 00    	jne    600 <printf+0x19b>
      if(c == 'd'){
 4d9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4dd:	75 2d                	jne    50c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e2:	8b 00                	mov    (%eax),%eax
 4e4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4eb:	00 
 4ec:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f3:	00 
 4f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
 4fb:	89 04 24             	mov    %eax,(%esp)
 4fe:	e8 ad fe ff ff       	call   3b0 <printint>
        ap++;
 503:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 507:	e9 ed 00 00 00       	jmp    5f9 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 50c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 510:	74 06                	je     518 <printf+0xb3>
 512:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 516:	75 2d                	jne    545 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 518:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51b:	8b 00                	mov    (%eax),%eax
 51d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 524:	00 
 525:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 52c:	00 
 52d:	89 44 24 04          	mov    %eax,0x4(%esp)
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	89 04 24             	mov    %eax,(%esp)
 537:	e8 74 fe ff ff       	call   3b0 <printint>
        ap++;
 53c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 540:	e9 b4 00 00 00       	jmp    5f9 <printf+0x194>
      } else if(c == 's'){
 545:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 549:	75 46                	jne    591 <printf+0x12c>
        s = (char*)*ap;
 54b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 553:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55b:	75 27                	jne    584 <printf+0x11f>
          s = "(null)";
 55d:	c7 45 f4 59 08 00 00 	movl   $0x859,-0xc(%ebp)
        while(*s != 0){
 564:	eb 1e                	jmp    584 <printf+0x11f>
          putc(fd, *s);
 566:	8b 45 f4             	mov    -0xc(%ebp),%eax
 569:	0f b6 00             	movzbl (%eax),%eax
 56c:	0f be c0             	movsbl %al,%eax
 56f:	89 44 24 04          	mov    %eax,0x4(%esp)
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	89 04 24             	mov    %eax,(%esp)
 579:	e8 0a fe ff ff       	call   388 <putc>
          s++;
 57e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 582:	eb 01                	jmp    585 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 584:	90                   	nop
 585:	8b 45 f4             	mov    -0xc(%ebp),%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	84 c0                	test   %al,%al
 58d:	75 d7                	jne    566 <printf+0x101>
 58f:	eb 68                	jmp    5f9 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 591:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 595:	75 1d                	jne    5b4 <printf+0x14f>
        putc(fd, *ap);
 597:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59a:	8b 00                	mov    (%eax),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	89 04 24             	mov    %eax,(%esp)
 5a9:	e8 da fd ff ff       	call   388 <putc>
        ap++;
 5ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b2:	eb 45                	jmp    5f9 <printf+0x194>
      } else if(c == '%'){
 5b4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b8:	75 17                	jne    5d1 <printf+0x16c>
        putc(fd, c);
 5ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	89 04 24             	mov    %eax,(%esp)
 5ca:	e8 b9 fd ff ff       	call   388 <putc>
 5cf:	eb 28                	jmp    5f9 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d8:	00 
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	89 04 24             	mov    %eax,(%esp)
 5df:	e8 a4 fd ff ff       	call   388 <putc>
        putc(fd, c);
 5e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	89 04 24             	mov    %eax,(%esp)
 5f4:	e8 8f fd ff ff       	call   388 <putc>
      }
      state = 0;
 5f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 600:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 604:	8b 55 0c             	mov    0xc(%ebp),%edx
 607:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60a:	01 d0                	add    %edx,%eax
 60c:	0f b6 00             	movzbl (%eax),%eax
 60f:	84 c0                	test   %al,%al
 611:	0f 85 70 fe ff ff    	jne    487 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 617:	c9                   	leave  
 618:	c3                   	ret    

00000619 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 619:	55                   	push   %ebp
 61a:	89 e5                	mov    %esp,%ebp
 61c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	83 e8 08             	sub    $0x8,%eax
 625:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 628:	a1 b8 0a 00 00       	mov    0xab8,%eax
 62d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 630:	eb 24                	jmp    656 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63a:	77 12                	ja     64e <free+0x35>
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 642:	77 24                	ja     668 <free+0x4f>
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64c:	77 1a                	ja     668 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	89 45 fc             	mov    %eax,-0x4(%ebp)
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65c:	76 d4                	jbe    632 <free+0x19>
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 666:	76 ca                	jbe    632 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	8b 40 04             	mov    0x4(%eax),%eax
 66e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	01 c2                	add    %eax,%edx
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	39 c2                	cmp    %eax,%edx
 681:	75 24                	jne    6a7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	8b 50 04             	mov    0x4(%eax),%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	8b 40 04             	mov    0x4(%eax),%eax
 691:	01 c2                	add    %eax,%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	8b 10                	mov    (%eax),%edx
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	89 10                	mov    %edx,(%eax)
 6a5:	eb 0a                	jmp    6b1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 10                	mov    (%eax),%edx
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 40 04             	mov    0x4(%eax),%eax
 6b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	01 d0                	add    %edx,%eax
 6c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c6:	75 20                	jne    6e8 <free+0xcf>
    p->s.size += bp->s.size;
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 50 04             	mov    0x4(%eax),%edx
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	8b 40 04             	mov    0x4(%eax),%eax
 6d4:	01 c2                	add    %eax,%edx
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	8b 10                	mov    (%eax),%edx
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	89 10                	mov    %edx,(%eax)
 6e6:	eb 08                	jmp    6f0 <free+0xd7>
  } else
    p->s.ptr = bp;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ee:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	a3 b8 0a 00 00       	mov    %eax,0xab8
}
 6f8:	c9                   	leave  
 6f9:	c3                   	ret    

000006fa <morecore>:

static Header*
morecore(uint nu)
{
 6fa:	55                   	push   %ebp
 6fb:	89 e5                	mov    %esp,%ebp
 6fd:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 700:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 707:	77 07                	ja     710 <morecore+0x16>
    nu = 4096;
 709:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 710:	8b 45 08             	mov    0x8(%ebp),%eax
 713:	c1 e0 03             	shl    $0x3,%eax
 716:	89 04 24             	mov    %eax,(%esp)
 719:	e8 4a fc ff ff       	call   368 <sbrk>
 71e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 721:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 725:	75 07                	jne    72e <morecore+0x34>
    return 0;
 727:	b8 00 00 00 00       	mov    $0x0,%eax
 72c:	eb 22                	jmp    750 <morecore+0x56>
  hp = (Header*)p;
 72e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 731:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 734:	8b 45 f0             	mov    -0x10(%ebp),%eax
 737:	8b 55 08             	mov    0x8(%ebp),%edx
 73a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	83 c0 08             	add    $0x8,%eax
 743:	89 04 24             	mov    %eax,(%esp)
 746:	e8 ce fe ff ff       	call   619 <free>
  return freep;
 74b:	a1 b8 0a 00 00       	mov    0xab8,%eax
}
 750:	c9                   	leave  
 751:	c3                   	ret    

00000752 <malloc>:

void*
malloc(uint nbytes)
{
 752:	55                   	push   %ebp
 753:	89 e5                	mov    %esp,%ebp
 755:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 758:	8b 45 08             	mov    0x8(%ebp),%eax
 75b:	83 c0 07             	add    $0x7,%eax
 75e:	c1 e8 03             	shr    $0x3,%eax
 761:	83 c0 01             	add    $0x1,%eax
 764:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 767:	a1 b8 0a 00 00       	mov    0xab8,%eax
 76c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 76f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 773:	75 23                	jne    798 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 775:	c7 45 f0 b0 0a 00 00 	movl   $0xab0,-0x10(%ebp)
 77c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77f:	a3 b8 0a 00 00       	mov    %eax,0xab8
 784:	a1 b8 0a 00 00       	mov    0xab8,%eax
 789:	a3 b0 0a 00 00       	mov    %eax,0xab0
    base.s.size = 0;
 78e:	c7 05 b4 0a 00 00 00 	movl   $0x0,0xab4
 795:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	8b 00                	mov    (%eax),%eax
 79d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a9:	72 4d                	jb     7f8 <malloc+0xa6>
      if(p->s.size == nunits)
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b4:	75 0c                	jne    7c2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	89 10                	mov    %edx,(%eax)
 7c0:	eb 26                	jmp    7e8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	89 c2                	mov    %eax,%edx
 7ca:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	8b 40 04             	mov    0x4(%eax),%eax
 7d9:	c1 e0 03             	shl    $0x3,%eax
 7dc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	a3 b8 0a 00 00       	mov    %eax,0xab8
      return (void*)(p + 1);
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	83 c0 08             	add    $0x8,%eax
 7f6:	eb 38                	jmp    830 <malloc+0xde>
    }
    if(p == freep)
 7f8:	a1 b8 0a 00 00       	mov    0xab8,%eax
 7fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 800:	75 1b                	jne    81d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 802:	8b 45 ec             	mov    -0x14(%ebp),%eax
 805:	89 04 24             	mov    %eax,(%esp)
 808:	e8 ed fe ff ff       	call   6fa <morecore>
 80d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 814:	75 07                	jne    81d <malloc+0xcb>
        return 0;
 816:	b8 00 00 00 00       	mov    $0x0,%eax
 81b:	eb 13                	jmp    830 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	89 45 f0             	mov    %eax,-0x10(%ebp)
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 00                	mov    (%eax),%eax
 828:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 82b:	e9 70 ff ff ff       	jmp    7a0 <malloc+0x4e>
}
 830:	c9                   	leave  
 831:	c3                   	ret    
