
_mkdir:     file format elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 48 08 00 	movl   $0x848,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 58 04 00 00       	call   47b <printf>
    exit();
  23:	e8 ce 02 00 00       	call   2f6 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4f                	jmp    81 <main+0x81>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 12 03 00 00       	call   35e <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 5f 08 00 	movl   $0x85f,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 01 04 00 00       	call   47b <printf>
      break;
  7a:	eb 0e                	jmp    8a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	3b 45 08             	cmp    0x8(%ebp),%eax
  88:	7c a8                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  8a:	e8 67 02 00 00       	call   2f6 <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	57                   	push   %edi
  93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 10             	mov    0x10(%ebp),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 cb                	mov    %ecx,%ebx
  9f:	89 df                	mov    %ebx,%edi
  a1:	89 d1                	mov    %edx,%ecx
  a3:	fc                   	cld    
  a4:	f3 aa                	rep stos %al,%es:(%edi)
  a6:	89 ca                	mov    %ecx,%edx
  a8:	89 fb                	mov    %edi,%ebx
  aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b0:	5b                   	pop    %ebx
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c0:	90                   	nop
  c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  c4:	0f b6 10             	movzbl (%eax),%edx
  c7:	8b 45 08             	mov    0x8(%ebp),%eax
  ca:	88 10                	mov    %dl,(%eax)
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	0f b6 00             	movzbl (%eax),%eax
  d2:	84 c0                	test   %al,%al
  d4:	0f 95 c0             	setne  %al
  d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  db:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  df:	84 c0                	test   %al,%al
  e1:	75 de                	jne    c1 <strcpy+0xd>
    ;
  return os;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  eb:	eb 08                	jmp    f5 <strcmp+0xd>
    p++, q++;
  ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	84 c0                	test   %al,%al
  fd:	74 10                	je     10f <strcmp+0x27>
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 10             	movzbl (%eax),%edx
 105:	8b 45 0c             	mov    0xc(%ebp),%eax
 108:	0f b6 00             	movzbl (%eax),%eax
 10b:	38 c2                	cmp    %al,%dl
 10d:	74 de                	je     ed <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	0f b6 d0             	movzbl %al,%edx
 118:	8b 45 0c             	mov    0xc(%ebp),%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	0f b6 c0             	movzbl %al,%eax
 121:	89 d1                	mov    %edx,%ecx
 123:	29 c1                	sub    %eax,%ecx
 125:	89 c8                	mov    %ecx,%eax
}
 127:	5d                   	pop    %ebp
 128:	c3                   	ret    

00000129 <strlen>:

uint
strlen(char *s)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
 12c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 136:	eb 04                	jmp    13c <strlen+0x13>
 138:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 13c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	01 d0                	add    %edx,%eax
 144:	0f b6 00             	movzbl (%eax),%eax
 147:	84 c0                	test   %al,%al
 149:	75 ed                	jne    138 <strlen+0xf>
    ;
  return n;
 14b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14e:	c9                   	leave  
 14f:	c3                   	ret    

00000150 <memset>:

void*
memset(void *dst, int c, uint n)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 156:	8b 45 10             	mov    0x10(%ebp),%eax
 159:	89 44 24 08          	mov    %eax,0x8(%esp)
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 44 24 04          	mov    %eax,0x4(%esp)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	89 04 24             	mov    %eax,(%esp)
 16a:	e8 20 ff ff ff       	call   8f <stosb>
  return dst;
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 172:	c9                   	leave  
 173:	c3                   	ret    

00000174 <strchr>:

char*
strchr(const char *s, char c)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	83 ec 04             	sub    $0x4,%esp
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 180:	eb 14                	jmp    196 <strchr+0x22>
    if(*s == c)
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	3a 45 fc             	cmp    -0x4(%ebp),%al
 18b:	75 05                	jne    192 <strchr+0x1e>
      return (char*)s;
 18d:	8b 45 08             	mov    0x8(%ebp),%eax
 190:	eb 13                	jmp    1a5 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 192:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	0f b6 00             	movzbl (%eax),%eax
 19c:	84 c0                	test   %al,%al
 19e:	75 e2                	jne    182 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a5:	c9                   	leave  
 1a6:	c3                   	ret    

000001a7 <gets>:

char*
gets(char *buf, int max)
{
 1a7:	55                   	push   %ebp
 1a8:	89 e5                	mov    %esp,%ebp
 1aa:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1b4:	eb 46                	jmp    1fc <gets+0x55>
    cc = read(0, &c, 1);
 1b6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1bd:	00 
 1be:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1cc:	e8 3d 01 00 00       	call   30e <read>
 1d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d8:	7e 2f                	jle    209 <gets+0x62>
      break;
    buf[i++] = c;
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 c2                	add    %eax,%edx
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	88 02                	mov    %al,(%edx)
 1e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f0:	3c 0a                	cmp    $0xa,%al
 1f2:	74 16                	je     20a <gets+0x63>
 1f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f8:	3c 0d                	cmp    $0xd,%al
 1fa:	74 0e                	je     20a <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ff:	83 c0 01             	add    $0x1,%eax
 202:	3b 45 0c             	cmp    0xc(%ebp),%eax
 205:	7c af                	jl     1b6 <gets+0xf>
 207:	eb 01                	jmp    20a <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 209:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 20a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	01 d0                	add    %edx,%eax
 212:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <stat>:

int
stat(char *n, struct stat *st)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 220:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 227:	00 
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	89 04 24             	mov    %eax,(%esp)
 22e:	e8 03 01 00 00       	call   336 <open>
 233:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 23a:	79 07                	jns    243 <stat+0x29>
    return -1;
 23c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 241:	eb 23                	jmp    266 <stat+0x4c>
  r = fstat(fd, st);
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	89 44 24 04          	mov    %eax,0x4(%esp)
 24a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24d:	89 04 24             	mov    %eax,(%esp)
 250:	e8 f9 00 00 00       	call   34e <fstat>
 255:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 258:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25b:	89 04 24             	mov    %eax,(%esp)
 25e:	e8 bb 00 00 00       	call   31e <close>
  return r;
 263:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 266:	c9                   	leave  
 267:	c3                   	ret    

00000268 <atoi>:

int
atoi(const char *s)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 26e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 275:	eb 23                	jmp    29a <atoi+0x32>
    n = n*10 + *s++ - '0';
 277:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27a:	89 d0                	mov    %edx,%eax
 27c:	c1 e0 02             	shl    $0x2,%eax
 27f:	01 d0                	add    %edx,%eax
 281:	01 c0                	add    %eax,%eax
 283:	89 c2                	mov    %eax,%edx
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	0f be c0             	movsbl %al,%eax
 28e:	01 d0                	add    %edx,%eax
 290:	83 e8 30             	sub    $0x30,%eax
 293:	89 45 fc             	mov    %eax,-0x4(%ebp)
 296:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	0f b6 00             	movzbl (%eax),%eax
 2a0:	3c 2f                	cmp    $0x2f,%al
 2a2:	7e 0a                	jle    2ae <atoi+0x46>
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	0f b6 00             	movzbl (%eax),%eax
 2aa:	3c 39                	cmp    $0x39,%al
 2ac:	7e c9                	jle    277 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b1:	c9                   	leave  
 2b2:	c3                   	ret    

000002b3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c5:	eb 13                	jmp    2da <memmove+0x27>
    *dst++ = *src++;
 2c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2ca:	0f b6 10             	movzbl (%eax),%edx
 2cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d0:	88 10                	mov    %dl,(%eax)
 2d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2d6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2de:	0f 9f c0             	setg   %al
 2e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2e5:	84 c0                	test   %al,%al
 2e7:	75 de                	jne    2c7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ec:	c9                   	leave  
 2ed:	c3                   	ret    

000002ee <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ee:	b8 01 00 00 00       	mov    $0x1,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <exit>:
SYSCALL(exit)
 2f6:	b8 02 00 00 00       	mov    $0x2,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <wait>:
SYSCALL(wait)
 2fe:	b8 03 00 00 00       	mov    $0x3,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <pipe>:
SYSCALL(pipe)
 306:	b8 04 00 00 00       	mov    $0x4,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <read>:
SYSCALL(read)
 30e:	b8 05 00 00 00       	mov    $0x5,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <write>:
SYSCALL(write)
 316:	b8 10 00 00 00       	mov    $0x10,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <close>:
SYSCALL(close)
 31e:	b8 15 00 00 00       	mov    $0x15,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <kill>:
SYSCALL(kill)
 326:	b8 06 00 00 00       	mov    $0x6,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <exec>:
SYSCALL(exec)
 32e:	b8 07 00 00 00       	mov    $0x7,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <open>:
SYSCALL(open)
 336:	b8 0f 00 00 00       	mov    $0xf,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <mknod>:
SYSCALL(mknod)
 33e:	b8 11 00 00 00       	mov    $0x11,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <unlink>:
SYSCALL(unlink)
 346:	b8 12 00 00 00       	mov    $0x12,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <fstat>:
SYSCALL(fstat)
 34e:	b8 08 00 00 00       	mov    $0x8,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <link>:
SYSCALL(link)
 356:	b8 13 00 00 00       	mov    $0x13,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <mkdir>:
SYSCALL(mkdir)
 35e:	b8 14 00 00 00       	mov    $0x14,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <chdir>:
SYSCALL(chdir)
 366:	b8 09 00 00 00       	mov    $0x9,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <dup>:
SYSCALL(dup)
 36e:	b8 0a 00 00 00       	mov    $0xa,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <getpid>:
SYSCALL(getpid)
 376:	b8 0b 00 00 00       	mov    $0xb,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <sbrk>:
SYSCALL(sbrk)
 37e:	b8 0c 00 00 00       	mov    $0xc,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <sleep>:
SYSCALL(sleep)
 386:	b8 0d 00 00 00       	mov    $0xd,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <uptime>:
SYSCALL(uptime)
 38e:	b8 0e 00 00 00       	mov    $0xe,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <getprocs>:
SYSCALL(getprocs)
 396:	b8 16 00 00 00       	mov    $0x16,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	83 ec 28             	sub    $0x28,%esp
 3a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3aa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b1:	00 
 3b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	89 04 24             	mov    %eax,(%esp)
 3bf:	e8 52 ff ff ff       	call   316 <write>
}
 3c4:	c9                   	leave  
 3c5:	c3                   	ret    

000003c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c6:	55                   	push   %ebp
 3c7:	89 e5                	mov    %esp,%ebp
 3c9:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d7:	74 17                	je     3f0 <printint+0x2a>
 3d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3dd:	79 11                	jns    3f0 <printint+0x2a>
    neg = 1;
 3df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	f7 d8                	neg    %eax
 3eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ee:	eb 06                	jmp    3f6 <printint+0x30>
  } else {
    x = xx;
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
 400:	8b 45 ec             	mov    -0x14(%ebp),%eax
 403:	ba 00 00 00 00       	mov    $0x0,%edx
 408:	f7 f1                	div    %ecx
 40a:	89 d0                	mov    %edx,%eax
 40c:	0f b6 80 c0 0a 00 00 	movzbl 0xac0(%eax),%eax
 413:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 416:	8b 55 f4             	mov    -0xc(%ebp),%edx
 419:	01 ca                	add    %ecx,%edx
 41b:	88 02                	mov    %al,(%edx)
 41d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 421:	8b 55 10             	mov    0x10(%ebp),%edx
 424:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 427:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42a:	ba 00 00 00 00       	mov    $0x0,%edx
 42f:	f7 75 d4             	divl   -0x2c(%ebp)
 432:	89 45 ec             	mov    %eax,-0x14(%ebp)
 435:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 439:	75 c2                	jne    3fd <printint+0x37>
  if(neg)
 43b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43f:	74 2e                	je     46f <printint+0xa9>
    buf[i++] = '-';
 441:	8d 55 dc             	lea    -0x24(%ebp),%edx
 444:	8b 45 f4             	mov    -0xc(%ebp),%eax
 447:	01 d0                	add    %edx,%eax
 449:	c6 00 2d             	movb   $0x2d,(%eax)
 44c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 450:	eb 1d                	jmp    46f <printint+0xa9>
    putc(fd, buf[i]);
 452:	8d 55 dc             	lea    -0x24(%ebp),%edx
 455:	8b 45 f4             	mov    -0xc(%ebp),%eax
 458:	01 d0                	add    %edx,%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	0f be c0             	movsbl %al,%eax
 460:	89 44 24 04          	mov    %eax,0x4(%esp)
 464:	8b 45 08             	mov    0x8(%ebp),%eax
 467:	89 04 24             	mov    %eax,(%esp)
 46a:	e8 2f ff ff ff       	call   39e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 46f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 477:	79 d9                	jns    452 <printint+0x8c>
    putc(fd, buf[i]);
}
 479:	c9                   	leave  
 47a:	c3                   	ret    

0000047b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47b:	55                   	push   %ebp
 47c:	89 e5                	mov    %esp,%ebp
 47e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 481:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 488:	8d 45 0c             	lea    0xc(%ebp),%eax
 48b:	83 c0 04             	add    $0x4,%eax
 48e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 491:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 498:	e9 7d 01 00 00       	jmp    61a <printf+0x19f>
    c = fmt[i] & 0xff;
 49d:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a3:	01 d0                	add    %edx,%eax
 4a5:	0f b6 00             	movzbl (%eax),%eax
 4a8:	0f be c0             	movsbl %al,%eax
 4ab:	25 ff 00 00 00       	and    $0xff,%eax
 4b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b7:	75 2c                	jne    4e5 <printf+0x6a>
      if(c == '%'){
 4b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4bd:	75 0c                	jne    4cb <printf+0x50>
        state = '%';
 4bf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c6:	e9 4b 01 00 00       	jmp    616 <printf+0x19b>
      } else {
        putc(fd, c);
 4cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ce:	0f be c0             	movsbl %al,%eax
 4d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d5:	8b 45 08             	mov    0x8(%ebp),%eax
 4d8:	89 04 24             	mov    %eax,(%esp)
 4db:	e8 be fe ff ff       	call   39e <putc>
 4e0:	e9 31 01 00 00       	jmp    616 <printf+0x19b>
      }
    } else if(state == '%'){
 4e5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e9:	0f 85 27 01 00 00    	jne    616 <printf+0x19b>
      if(c == 'd'){
 4ef:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f3:	75 2d                	jne    522 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f8:	8b 00                	mov    (%eax),%eax
 4fa:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 501:	00 
 502:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 509:	00 
 50a:	89 44 24 04          	mov    %eax,0x4(%esp)
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	89 04 24             	mov    %eax,(%esp)
 514:	e8 ad fe ff ff       	call   3c6 <printint>
        ap++;
 519:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51d:	e9 ed 00 00 00       	jmp    60f <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 522:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 526:	74 06                	je     52e <printf+0xb3>
 528:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52c:	75 2d                	jne    55b <printf+0xe0>
        printint(fd, *ap, 16, 0);
 52e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 531:	8b 00                	mov    (%eax),%eax
 533:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 53a:	00 
 53b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 542:	00 
 543:	89 44 24 04          	mov    %eax,0x4(%esp)
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	89 04 24             	mov    %eax,(%esp)
 54d:	e8 74 fe ff ff       	call   3c6 <printint>
        ap++;
 552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 556:	e9 b4 00 00 00       	jmp    60f <printf+0x194>
      } else if(c == 's'){
 55b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 55f:	75 46                	jne    5a7 <printf+0x12c>
        s = (char*)*ap;
 561:	8b 45 e8             	mov    -0x18(%ebp),%eax
 564:	8b 00                	mov    (%eax),%eax
 566:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 569:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 56d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 571:	75 27                	jne    59a <printf+0x11f>
          s = "(null)";
 573:	c7 45 f4 7b 08 00 00 	movl   $0x87b,-0xc(%ebp)
        while(*s != 0){
 57a:	eb 1e                	jmp    59a <printf+0x11f>
          putc(fd, *s);
 57c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 0a fe ff ff       	call   39e <putc>
          s++;
 594:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 598:	eb 01                	jmp    59b <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 59a:	90                   	nop
 59b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59e:	0f b6 00             	movzbl (%eax),%eax
 5a1:	84 c0                	test   %al,%al
 5a3:	75 d7                	jne    57c <printf+0x101>
 5a5:	eb 68                	jmp    60f <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ab:	75 1d                	jne    5ca <printf+0x14f>
        putc(fd, *ap);
 5ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b0:	8b 00                	mov    (%eax),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	89 04 24             	mov    %eax,(%esp)
 5bf:	e8 da fd ff ff       	call   39e <putc>
        ap++;
 5c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c8:	eb 45                	jmp    60f <printf+0x194>
      } else if(c == '%'){
 5ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ce:	75 17                	jne    5e7 <printf+0x16c>
        putc(fd, c);
 5d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d3:	0f be c0             	movsbl %al,%eax
 5d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	89 04 24             	mov    %eax,(%esp)
 5e0:	e8 b9 fd ff ff       	call   39e <putc>
 5e5:	eb 28                	jmp    60f <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5ee:	00 
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	89 04 24             	mov    %eax,(%esp)
 5f5:	e8 a4 fd ff ff       	call   39e <putc>
        putc(fd, c);
 5fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fd:	0f be c0             	movsbl %al,%eax
 600:	89 44 24 04          	mov    %eax,0x4(%esp)
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	89 04 24             	mov    %eax,(%esp)
 60a:	e8 8f fd ff ff       	call   39e <putc>
      }
      state = 0;
 60f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 616:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 61a:	8b 55 0c             	mov    0xc(%ebp),%edx
 61d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 620:	01 d0                	add    %edx,%eax
 622:	0f b6 00             	movzbl (%eax),%eax
 625:	84 c0                	test   %al,%al
 627:	0f 85 70 fe ff ff    	jne    49d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 62d:	c9                   	leave  
 62e:	c3                   	ret    

0000062f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	83 e8 08             	sub    $0x8,%eax
 63b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63e:	a1 dc 0a 00 00       	mov    0xadc,%eax
 643:	89 45 fc             	mov    %eax,-0x4(%ebp)
 646:	eb 24                	jmp    66c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 650:	77 12                	ja     664 <free+0x35>
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 658:	77 24                	ja     67e <free+0x4f>
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 662:	77 1a                	ja     67e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 672:	76 d4                	jbe    648 <free+0x19>
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67c:	76 ca                	jbe    648 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	8b 40 04             	mov    0x4(%eax),%eax
 684:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	01 c2                	add    %eax,%edx
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	39 c2                	cmp    %eax,%edx
 697:	75 24                	jne    6bd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	8b 50 04             	mov    0x4(%eax),%edx
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	8b 40 04             	mov    0x4(%eax),%eax
 6a7:	01 c2                	add    %eax,%edx
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	8b 10                	mov    (%eax),%edx
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	89 10                	mov    %edx,(%eax)
 6bb:	eb 0a                	jmp    6c7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 10                	mov    (%eax),%edx
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 40 04             	mov    0x4(%eax),%eax
 6cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	01 d0                	add    %edx,%eax
 6d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6dc:	75 20                	jne    6fe <free+0xcf>
    p->s.size += bp->s.size;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 50 04             	mov    0x4(%eax),%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	8b 40 04             	mov    0x4(%eax),%eax
 6ea:	01 c2                	add    %eax,%edx
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 10                	mov    (%eax),%edx
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	89 10                	mov    %edx,(%eax)
 6fc:	eb 08                	jmp    706 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 55 f8             	mov    -0x8(%ebp),%edx
 704:	89 10                	mov    %edx,(%eax)
  freep = p;
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	a3 dc 0a 00 00       	mov    %eax,0xadc
}
 70e:	c9                   	leave  
 70f:	c3                   	ret    

00000710 <morecore>:

static Header*
morecore(uint nu)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 716:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71d:	77 07                	ja     726 <morecore+0x16>
    nu = 4096;
 71f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 726:	8b 45 08             	mov    0x8(%ebp),%eax
 729:	c1 e0 03             	shl    $0x3,%eax
 72c:	89 04 24             	mov    %eax,(%esp)
 72f:	e8 4a fc ff ff       	call   37e <sbrk>
 734:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 737:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 73b:	75 07                	jne    744 <morecore+0x34>
    return 0;
 73d:	b8 00 00 00 00       	mov    $0x0,%eax
 742:	eb 22                	jmp    766 <morecore+0x56>
  hp = (Header*)p;
 744:	8b 45 f4             	mov    -0xc(%ebp),%eax
 747:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 74a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74d:	8b 55 08             	mov    0x8(%ebp),%edx
 750:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	83 c0 08             	add    $0x8,%eax
 759:	89 04 24             	mov    %eax,(%esp)
 75c:	e8 ce fe ff ff       	call   62f <free>
  return freep;
 761:	a1 dc 0a 00 00       	mov    0xadc,%eax
}
 766:	c9                   	leave  
 767:	c3                   	ret    

00000768 <malloc>:

void*
malloc(uint nbytes)
{
 768:	55                   	push   %ebp
 769:	89 e5                	mov    %esp,%ebp
 76b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76e:	8b 45 08             	mov    0x8(%ebp),%eax
 771:	83 c0 07             	add    $0x7,%eax
 774:	c1 e8 03             	shr    $0x3,%eax
 777:	83 c0 01             	add    $0x1,%eax
 77a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 77d:	a1 dc 0a 00 00       	mov    0xadc,%eax
 782:	89 45 f0             	mov    %eax,-0x10(%ebp)
 785:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 789:	75 23                	jne    7ae <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 78b:	c7 45 f0 d4 0a 00 00 	movl   $0xad4,-0x10(%ebp)
 792:	8b 45 f0             	mov    -0x10(%ebp),%eax
 795:	a3 dc 0a 00 00       	mov    %eax,0xadc
 79a:	a1 dc 0a 00 00       	mov    0xadc,%eax
 79f:	a3 d4 0a 00 00       	mov    %eax,0xad4
    base.s.size = 0;
 7a4:	c7 05 d8 0a 00 00 00 	movl   $0x0,0xad8
 7ab:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b1:	8b 00                	mov    (%eax),%eax
 7b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 40 04             	mov    0x4(%eax),%eax
 7bc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bf:	72 4d                	jb     80e <malloc+0xa6>
      if(p->s.size == nunits)
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	8b 40 04             	mov    0x4(%eax),%eax
 7c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ca:	75 0c                	jne    7d8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	8b 10                	mov    (%eax),%edx
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	89 10                	mov    %edx,(%eax)
 7d6:	eb 26                	jmp    7fe <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8b 40 04             	mov    0x4(%eax),%eax
 7de:	89 c2                	mov    %eax,%edx
 7e0:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	c1 e0 03             	shl    $0x3,%eax
 7f2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7fb:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 801:	a3 dc 0a 00 00       	mov    %eax,0xadc
      return (void*)(p + 1);
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	83 c0 08             	add    $0x8,%eax
 80c:	eb 38                	jmp    846 <malloc+0xde>
    }
    if(p == freep)
 80e:	a1 dc 0a 00 00       	mov    0xadc,%eax
 813:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 816:	75 1b                	jne    833 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 818:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81b:	89 04 24             	mov    %eax,(%esp)
 81e:	e8 ed fe ff ff       	call   710 <morecore>
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
 826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 82a:	75 07                	jne    833 <malloc+0xcb>
        return 0;
 82c:	b8 00 00 00 00       	mov    $0x0,%eax
 831:	eb 13                	jmp    846 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	89 45 f0             	mov    %eax,-0x10(%ebp)
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	8b 00                	mov    (%eax),%eax
 83e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 841:	e9 70 ff ff ff       	jmp    7b6 <malloc+0x4e>
}
 846:	c9                   	leave  
 847:	c3                   	ret    
