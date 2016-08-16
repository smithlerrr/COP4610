
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 20 08 00 	movl   $0x820,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 30 04 00 00       	call   453 <printf>
    exit();
  23:	e8 a6 02 00 00       	call   2ce <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 f4 01 00 00       	call   240 <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 aa 02 00 00       	call   2fe <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  62:	e8 67 02 00 00       	call   2ce <exit>

00000067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	57                   	push   %edi
  6b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6f:	8b 55 10             	mov    0x10(%ebp),%edx
  72:	8b 45 0c             	mov    0xc(%ebp),%eax
  75:	89 cb                	mov    %ecx,%ebx
  77:	89 df                	mov    %ebx,%edi
  79:	89 d1                	mov    %edx,%ecx
  7b:	fc                   	cld    
  7c:	f3 aa                	rep stos %al,%es:(%edi)
  7e:	89 ca                	mov    %ecx,%edx
  80:	89 fb                	mov    %edi,%ebx
  82:	89 5d 08             	mov    %ebx,0x8(%ebp)
  85:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  88:	5b                   	pop    %ebx
  89:	5f                   	pop    %edi
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  92:	8b 45 08             	mov    0x8(%ebp),%eax
  95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  98:	90                   	nop
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	88 10                	mov    %dl,(%eax)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	84 c0                	test   %al,%al
  ac:	0f 95 c0             	setne  %al
  af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  b7:	84 c0                	test   %al,%al
  b9:	75 de                	jne    99 <strcpy+0xd>
    ;
  return os;
  bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  be:	c9                   	leave  
  bf:	c3                   	ret    

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c3:	eb 08                	jmp    cd <strcmp+0xd>
    p++, q++;
  c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	84 c0                	test   %al,%al
  d5:	74 10                	je     e7 <strcmp+0x27>
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 10             	movzbl (%eax),%edx
  dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  e0:	0f b6 00             	movzbl (%eax),%eax
  e3:	38 c2                	cmp    %al,%dl
  e5:	74 de                	je     c5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	0f b6 d0             	movzbl %al,%edx
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	0f b6 c0             	movzbl %al,%eax
  f9:	89 d1                	mov    %edx,%ecx
  fb:	29 c1                	sub    %eax,%ecx
  fd:	89 c8                	mov    %ecx,%eax
}
  ff:	5d                   	pop    %ebp
 100:	c3                   	ret    

00000101 <strlen>:

uint
strlen(char *s)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10e:	eb 04                	jmp    114 <strlen+0x13>
 110:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 114:	8b 55 fc             	mov    -0x4(%ebp),%edx
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	01 d0                	add    %edx,%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	84 c0                	test   %al,%al
 121:	75 ed                	jne    110 <strlen+0xf>
    ;
  return n;
 123:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 12e:	8b 45 10             	mov    0x10(%ebp),%eax
 131:	89 44 24 08          	mov    %eax,0x8(%esp)
 135:	8b 45 0c             	mov    0xc(%ebp),%eax
 138:	89 44 24 04          	mov    %eax,0x4(%esp)
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	89 04 24             	mov    %eax,(%esp)
 142:	e8 20 ff ff ff       	call   67 <stosb>
  return dst;
 147:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14a:	c9                   	leave  
 14b:	c3                   	ret    

0000014c <strchr>:

char*
strchr(const char *s, char c)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	83 ec 04             	sub    $0x4,%esp
 152:	8b 45 0c             	mov    0xc(%ebp),%eax
 155:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 158:	eb 14                	jmp    16e <strchr+0x22>
    if(*s == c)
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	0f b6 00             	movzbl (%eax),%eax
 160:	3a 45 fc             	cmp    -0x4(%ebp),%al
 163:	75 05                	jne    16a <strchr+0x1e>
      return (char*)s;
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	eb 13                	jmp    17d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	84 c0                	test   %al,%al
 176:	75 e2                	jne    15a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 178:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17d:	c9                   	leave  
 17e:	c3                   	ret    

0000017f <gets>:

char*
gets(char *buf, int max)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 185:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18c:	eb 46                	jmp    1d4 <gets+0x55>
    cc = read(0, &c, 1);
 18e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 195:	00 
 196:	8d 45 ef             	lea    -0x11(%ebp),%eax
 199:	89 44 24 04          	mov    %eax,0x4(%esp)
 19d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a4:	e8 3d 01 00 00       	call   2e6 <read>
 1a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b0:	7e 2f                	jle    1e1 <gets+0x62>
      break;
    buf[i++] = c;
 1b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	01 c2                	add    %eax,%edx
 1ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1be:	88 02                	mov    %al,(%edx)
 1c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0a                	cmp    $0xa,%al
 1ca:	74 16                	je     1e2 <gets+0x63>
 1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d0:	3c 0d                	cmp    $0xd,%al
 1d2:	74 0e                	je     1e2 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d7:	83 c0 01             	add    $0x1,%eax
 1da:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1dd:	7c af                	jl     18e <gets+0xf>
 1df:	eb 01                	jmp    1e2 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1e1:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	01 d0                	add    %edx,%eax
 1ea:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f0:	c9                   	leave  
 1f1:	c3                   	ret    

000001f2 <stat>:

int
stat(char *n, struct stat *st)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ff:	00 
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	89 04 24             	mov    %eax,(%esp)
 206:	e8 03 01 00 00       	call   30e <open>
 20b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 212:	79 07                	jns    21b <stat+0x29>
    return -1;
 214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 219:	eb 23                	jmp    23e <stat+0x4c>
  r = fstat(fd, st);
 21b:	8b 45 0c             	mov    0xc(%ebp),%eax
 21e:	89 44 24 04          	mov    %eax,0x4(%esp)
 222:	8b 45 f4             	mov    -0xc(%ebp),%eax
 225:	89 04 24             	mov    %eax,(%esp)
 228:	e8 f9 00 00 00       	call   326 <fstat>
 22d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 230:	8b 45 f4             	mov    -0xc(%ebp),%eax
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 bb 00 00 00       	call   2f6 <close>
  return r;
 23b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23e:	c9                   	leave  
 23f:	c3                   	ret    

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 246:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24d:	eb 23                	jmp    272 <atoi+0x32>
    n = n*10 + *s++ - '0';
 24f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 252:	89 d0                	mov    %edx,%eax
 254:	c1 e0 02             	shl    $0x2,%eax
 257:	01 d0                	add    %edx,%eax
 259:	01 c0                	add    %eax,%eax
 25b:	89 c2                	mov    %eax,%edx
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	0f b6 00             	movzbl (%eax),%eax
 263:	0f be c0             	movsbl %al,%eax
 266:	01 d0                	add    %edx,%eax
 268:	83 e8 30             	sub    $0x30,%eax
 26b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 26e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	3c 2f                	cmp    $0x2f,%al
 27a:	7e 0a                	jle    286 <atoi+0x46>
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 39                	cmp    $0x39,%al
 284:	7e c9                	jle    24f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 286:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 289:	c9                   	leave  
 28a:	c3                   	ret    

0000028b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 297:	8b 45 0c             	mov    0xc(%ebp),%eax
 29a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29d:	eb 13                	jmp    2b2 <memmove+0x27>
    *dst++ = *src++;
 29f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a2:	0f b6 10             	movzbl (%eax),%edx
 2a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a8:	88 10                	mov    %dl,(%eax)
 2aa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2ae:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2b6:	0f 9f c0             	setg   %al
 2b9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2bd:	84 c0                	test   %al,%al
 2bf:	75 de                	jne    29f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c6:	b8 01 00 00 00       	mov    $0x1,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <exit>:
SYSCALL(exit)
 2ce:	b8 02 00 00 00       	mov    $0x2,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <wait>:
SYSCALL(wait)
 2d6:	b8 03 00 00 00       	mov    $0x3,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <pipe>:
SYSCALL(pipe)
 2de:	b8 04 00 00 00       	mov    $0x4,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <read>:
SYSCALL(read)
 2e6:	b8 05 00 00 00       	mov    $0x5,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <write>:
SYSCALL(write)
 2ee:	b8 10 00 00 00       	mov    $0x10,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <close>:
SYSCALL(close)
 2f6:	b8 15 00 00 00       	mov    $0x15,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <kill>:
SYSCALL(kill)
 2fe:	b8 06 00 00 00       	mov    $0x6,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <exec>:
SYSCALL(exec)
 306:	b8 07 00 00 00       	mov    $0x7,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <open>:
SYSCALL(open)
 30e:	b8 0f 00 00 00       	mov    $0xf,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <mknod>:
SYSCALL(mknod)
 316:	b8 11 00 00 00       	mov    $0x11,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <unlink>:
SYSCALL(unlink)
 31e:	b8 12 00 00 00       	mov    $0x12,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <fstat>:
SYSCALL(fstat)
 326:	b8 08 00 00 00       	mov    $0x8,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <link>:
SYSCALL(link)
 32e:	b8 13 00 00 00       	mov    $0x13,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <mkdir>:
SYSCALL(mkdir)
 336:	b8 14 00 00 00       	mov    $0x14,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <chdir>:
SYSCALL(chdir)
 33e:	b8 09 00 00 00       	mov    $0x9,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <dup>:
SYSCALL(dup)
 346:	b8 0a 00 00 00       	mov    $0xa,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <getpid>:
SYSCALL(getpid)
 34e:	b8 0b 00 00 00       	mov    $0xb,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <sbrk>:
SYSCALL(sbrk)
 356:	b8 0c 00 00 00       	mov    $0xc,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <sleep>:
SYSCALL(sleep)
 35e:	b8 0d 00 00 00       	mov    $0xd,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <uptime>:
SYSCALL(uptime)
 366:	b8 0e 00 00 00       	mov    $0xe,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <getprocs>:
SYSCALL(getprocs)
 36e:	b8 16 00 00 00       	mov    $0x16,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	83 ec 28             	sub    $0x28,%esp
 37c:	8b 45 0c             	mov    0xc(%ebp),%eax
 37f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 382:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 389:	00 
 38a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38d:	89 44 24 04          	mov    %eax,0x4(%esp)
 391:	8b 45 08             	mov    0x8(%ebp),%eax
 394:	89 04 24             	mov    %eax,(%esp)
 397:	e8 52 ff ff ff       	call   2ee <write>
}
 39c:	c9                   	leave  
 39d:	c3                   	ret    

0000039e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ab:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3af:	74 17                	je     3c8 <printint+0x2a>
 3b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b5:	79 11                	jns    3c8 <printint+0x2a>
    neg = 1;
 3b7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	f7 d8                	neg    %eax
 3c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c6:	eb 06                	jmp    3ce <printint+0x30>
  } else {
    x = xx;
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3db:	ba 00 00 00 00       	mov    $0x0,%edx
 3e0:	f7 f1                	div    %ecx
 3e2:	89 d0                	mov    %edx,%eax
 3e4:	0f b6 80 78 0a 00 00 	movzbl 0xa78(%eax),%eax
 3eb:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3f1:	01 ca                	add    %ecx,%edx
 3f3:	88 02                	mov    %al,(%edx)
 3f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3f9:	8b 55 10             	mov    0x10(%ebp),%edx
 3fc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 402:	ba 00 00 00 00       	mov    $0x0,%edx
 407:	f7 75 d4             	divl   -0x2c(%ebp)
 40a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 411:	75 c2                	jne    3d5 <printint+0x37>
  if(neg)
 413:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 417:	74 2e                	je     447 <printint+0xa9>
    buf[i++] = '-';
 419:	8d 55 dc             	lea    -0x24(%ebp),%edx
 41c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41f:	01 d0                	add    %edx,%eax
 421:	c6 00 2d             	movb   $0x2d,(%eax)
 424:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 428:	eb 1d                	jmp    447 <printint+0xa9>
    putc(fd, buf[i]);
 42a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 430:	01 d0                	add    %edx,%eax
 432:	0f b6 00             	movzbl (%eax),%eax
 435:	0f be c0             	movsbl %al,%eax
 438:	89 44 24 04          	mov    %eax,0x4(%esp)
 43c:	8b 45 08             	mov    0x8(%ebp),%eax
 43f:	89 04 24             	mov    %eax,(%esp)
 442:	e8 2f ff ff ff       	call   376 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 447:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 44b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44f:	79 d9                	jns    42a <printint+0x8c>
    putc(fd, buf[i]);
}
 451:	c9                   	leave  
 452:	c3                   	ret    

00000453 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 453:	55                   	push   %ebp
 454:	89 e5                	mov    %esp,%ebp
 456:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 459:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 460:	8d 45 0c             	lea    0xc(%ebp),%eax
 463:	83 c0 04             	add    $0x4,%eax
 466:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 469:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 470:	e9 7d 01 00 00       	jmp    5f2 <printf+0x19f>
    c = fmt[i] & 0xff;
 475:	8b 55 0c             	mov    0xc(%ebp),%edx
 478:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47b:	01 d0                	add    %edx,%eax
 47d:	0f b6 00             	movzbl (%eax),%eax
 480:	0f be c0             	movsbl %al,%eax
 483:	25 ff 00 00 00       	and    $0xff,%eax
 488:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48f:	75 2c                	jne    4bd <printf+0x6a>
      if(c == '%'){
 491:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 495:	75 0c                	jne    4a3 <printf+0x50>
        state = '%';
 497:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49e:	e9 4b 01 00 00       	jmp    5ee <printf+0x19b>
      } else {
        putc(fd, c);
 4a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a6:	0f be c0             	movsbl %al,%eax
 4a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	89 04 24             	mov    %eax,(%esp)
 4b3:	e8 be fe ff ff       	call   376 <putc>
 4b8:	e9 31 01 00 00       	jmp    5ee <printf+0x19b>
      }
    } else if(state == '%'){
 4bd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c1:	0f 85 27 01 00 00    	jne    5ee <printf+0x19b>
      if(c == 'd'){
 4c7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cb:	75 2d                	jne    4fa <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d0:	8b 00                	mov    (%eax),%eax
 4d2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d9:	00 
 4da:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4e1:	00 
 4e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 ad fe ff ff       	call   39e <printint>
        ap++;
 4f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f5:	e9 ed 00 00 00       	jmp    5e7 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4fa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fe:	74 06                	je     506 <printf+0xb3>
 500:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 504:	75 2d                	jne    533 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 506:	8b 45 e8             	mov    -0x18(%ebp),%eax
 509:	8b 00                	mov    (%eax),%eax
 50b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 512:	00 
 513:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 51a:	00 
 51b:	89 44 24 04          	mov    %eax,0x4(%esp)
 51f:	8b 45 08             	mov    0x8(%ebp),%eax
 522:	89 04 24             	mov    %eax,(%esp)
 525:	e8 74 fe ff ff       	call   39e <printint>
        ap++;
 52a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52e:	e9 b4 00 00 00       	jmp    5e7 <printf+0x194>
      } else if(c == 's'){
 533:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 537:	75 46                	jne    57f <printf+0x12c>
        s = (char*)*ap;
 539:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53c:	8b 00                	mov    (%eax),%eax
 53e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 541:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 549:	75 27                	jne    572 <printf+0x11f>
          s = "(null)";
 54b:	c7 45 f4 34 08 00 00 	movl   $0x834,-0xc(%ebp)
        while(*s != 0){
 552:	eb 1e                	jmp    572 <printf+0x11f>
          putc(fd, *s);
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	0f b6 00             	movzbl (%eax),%eax
 55a:	0f be c0             	movsbl %al,%eax
 55d:	89 44 24 04          	mov    %eax,0x4(%esp)
 561:	8b 45 08             	mov    0x8(%ebp),%eax
 564:	89 04 24             	mov    %eax,(%esp)
 567:	e8 0a fe ff ff       	call   376 <putc>
          s++;
 56c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 570:	eb 01                	jmp    573 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 572:	90                   	nop
 573:	8b 45 f4             	mov    -0xc(%ebp),%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	84 c0                	test   %al,%al
 57b:	75 d7                	jne    554 <printf+0x101>
 57d:	eb 68                	jmp    5e7 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 583:	75 1d                	jne    5a2 <printf+0x14f>
        putc(fd, *ap);
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	0f be c0             	movsbl %al,%eax
 58d:	89 44 24 04          	mov    %eax,0x4(%esp)
 591:	8b 45 08             	mov    0x8(%ebp),%eax
 594:	89 04 24             	mov    %eax,(%esp)
 597:	e8 da fd ff ff       	call   376 <putc>
        ap++;
 59c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a0:	eb 45                	jmp    5e7 <printf+0x194>
      } else if(c == '%'){
 5a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a6:	75 17                	jne    5bf <printf+0x16c>
        putc(fd, c);
 5a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	89 04 24             	mov    %eax,(%esp)
 5b8:	e8 b9 fd ff ff       	call   376 <putc>
 5bd:	eb 28                	jmp    5e7 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5bf:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c6:	00 
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 a4 fd ff ff       	call   376 <putc>
        putc(fd, c);
 5d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dc:	8b 45 08             	mov    0x8(%ebp),%eax
 5df:	89 04 24             	mov    %eax,(%esp)
 5e2:	e8 8f fd ff ff       	call   376 <putc>
      }
      state = 0;
 5e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ee:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f8:	01 d0                	add    %edx,%eax
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	84 c0                	test   %al,%al
 5ff:	0f 85 70 fe ff ff    	jne    475 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 605:	c9                   	leave  
 606:	c3                   	ret    

00000607 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 607:	55                   	push   %ebp
 608:	89 e5                	mov    %esp,%ebp
 60a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	83 e8 08             	sub    $0x8,%eax
 613:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 616:	a1 94 0a 00 00       	mov    0xa94,%eax
 61b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61e:	eb 24                	jmp    644 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 628:	77 12                	ja     63c <free+0x35>
 62a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 630:	77 24                	ja     656 <free+0x4f>
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63a:	77 1a                	ja     656 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	89 45 fc             	mov    %eax,-0x4(%ebp)
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64a:	76 d4                	jbe    620 <free+0x19>
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 654:	76 ca                	jbe    620 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	8b 40 04             	mov    0x4(%eax),%eax
 65c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	01 c2                	add    %eax,%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	39 c2                	cmp    %eax,%edx
 66f:	75 24                	jne    695 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 671:	8b 45 f8             	mov    -0x8(%ebp),%eax
 674:	8b 50 04             	mov    0x4(%eax),%edx
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	8b 40 04             	mov    0x4(%eax),%eax
 67f:	01 c2                	add    %eax,%edx
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	8b 00                	mov    (%eax),%eax
 68c:	8b 10                	mov    (%eax),%edx
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	89 10                	mov    %edx,(%eax)
 693:	eb 0a                	jmp    69f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 10                	mov    (%eax),%edx
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 40 04             	mov    0x4(%eax),%eax
 6a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	01 d0                	add    %edx,%eax
 6b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b4:	75 20                	jne    6d6 <free+0xcf>
    p->s.size += bp->s.size;
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 50 04             	mov    0x4(%eax),%edx
 6bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bf:	8b 40 04             	mov    0x4(%eax),%eax
 6c2:	01 c2                	add    %eax,%edx
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cd:	8b 10                	mov    (%eax),%edx
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	89 10                	mov    %edx,(%eax)
 6d4:	eb 08                	jmp    6de <free+0xd7>
  } else
    p->s.ptr = bp;
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6dc:	89 10                	mov    %edx,(%eax)
  freep = p;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	a3 94 0a 00 00       	mov    %eax,0xa94
}
 6e6:	c9                   	leave  
 6e7:	c3                   	ret    

000006e8 <morecore>:

static Header*
morecore(uint nu)
{
 6e8:	55                   	push   %ebp
 6e9:	89 e5                	mov    %esp,%ebp
 6eb:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ee:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f5:	77 07                	ja     6fe <morecore+0x16>
    nu = 4096;
 6f7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fe:	8b 45 08             	mov    0x8(%ebp),%eax
 701:	c1 e0 03             	shl    $0x3,%eax
 704:	89 04 24             	mov    %eax,(%esp)
 707:	e8 4a fc ff ff       	call   356 <sbrk>
 70c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 713:	75 07                	jne    71c <morecore+0x34>
    return 0;
 715:	b8 00 00 00 00       	mov    $0x0,%eax
 71a:	eb 22                	jmp    73e <morecore+0x56>
  hp = (Header*)p;
 71c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 722:	8b 45 f0             	mov    -0x10(%ebp),%eax
 725:	8b 55 08             	mov    0x8(%ebp),%edx
 728:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 72b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72e:	83 c0 08             	add    $0x8,%eax
 731:	89 04 24             	mov    %eax,(%esp)
 734:	e8 ce fe ff ff       	call   607 <free>
  return freep;
 739:	a1 94 0a 00 00       	mov    0xa94,%eax
}
 73e:	c9                   	leave  
 73f:	c3                   	ret    

00000740 <malloc>:

void*
malloc(uint nbytes)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 746:	8b 45 08             	mov    0x8(%ebp),%eax
 749:	83 c0 07             	add    $0x7,%eax
 74c:	c1 e8 03             	shr    $0x3,%eax
 74f:	83 c0 01             	add    $0x1,%eax
 752:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 755:	a1 94 0a 00 00       	mov    0xa94,%eax
 75a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 761:	75 23                	jne    786 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 763:	c7 45 f0 8c 0a 00 00 	movl   $0xa8c,-0x10(%ebp)
 76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76d:	a3 94 0a 00 00       	mov    %eax,0xa94
 772:	a1 94 0a 00 00       	mov    0xa94,%eax
 777:	a3 8c 0a 00 00       	mov    %eax,0xa8c
    base.s.size = 0;
 77c:	c7 05 90 0a 00 00 00 	movl   $0x0,0xa90
 783:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	8b 00                	mov    (%eax),%eax
 78b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	8b 40 04             	mov    0x4(%eax),%eax
 794:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 797:	72 4d                	jb     7e6 <malloc+0xa6>
      if(p->s.size == nunits)
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a2:	75 0c                	jne    7b0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	8b 10                	mov    (%eax),%edx
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	89 10                	mov    %edx,(%eax)
 7ae:	eb 26                	jmp    7d6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	89 c2                	mov    %eax,%edx
 7b8:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	8b 40 04             	mov    0x4(%eax),%eax
 7c7:	c1 e0 03             	shl    $0x3,%eax
 7ca:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d9:	a3 94 0a 00 00       	mov    %eax,0xa94
      return (void*)(p + 1);
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	83 c0 08             	add    $0x8,%eax
 7e4:	eb 38                	jmp    81e <malloc+0xde>
    }
    if(p == freep)
 7e6:	a1 94 0a 00 00       	mov    0xa94,%eax
 7eb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ee:	75 1b                	jne    80b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f3:	89 04 24             	mov    %eax,(%esp)
 7f6:	e8 ed fe ff ff       	call   6e8 <morecore>
 7fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 802:	75 07                	jne    80b <malloc+0xcb>
        return 0;
 804:	b8 00 00 00 00       	mov    $0x0,%eax
 809:	eb 13                	jmp    81e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 819:	e9 70 ff ff ff       	jmp    78e <malloc+0x4e>
}
 81e:	c9                   	leave  
 81f:	c3                   	ret    
