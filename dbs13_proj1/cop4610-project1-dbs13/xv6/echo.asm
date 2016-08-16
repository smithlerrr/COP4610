
_echo:     file format elf32-i386


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

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 25 08 00 00       	mov    $0x825,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 27 08 00 00       	mov    $0x827,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 29 08 00 	movl   $0x829,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 ff 03 00 00       	call   458 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  67:	e8 67 02 00 00       	call   2d3 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	0f b6 10             	movzbl (%eax),%edx
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	88 10                	mov    %dl,(%eax)
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	84 c0                	test   %al,%al
  b1:	0f 95 c0             	setne  %al
  b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  bc:	84 c0                	test   %al,%al
  be:	75 de                	jne    9e <strcpy+0xd>
    ;
  return os;
  c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c3:	c9                   	leave  
  c4:	c3                   	ret    

000000c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c8:	eb 08                	jmp    d2 <strcmp+0xd>
    p++, q++;
  ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ce:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 00             	movzbl (%eax),%eax
  d8:	84 c0                	test   %al,%al
  da:	74 10                	je     ec <strcmp+0x27>
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 10             	movzbl (%eax),%edx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	38 c2                	cmp    %al,%dl
  ea:	74 de                	je     ca <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 d0             	movzbl %al,%edx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f b6 c0             	movzbl %al,%eax
  fe:	89 d1                	mov    %edx,%ecx
 100:	29 c1                	sub    %eax,%ecx
 102:	89 c8                	mov    %ecx,%eax
}
 104:	5d                   	pop    %ebp
 105:	c3                   	ret    

00000106 <strlen>:

uint
strlen(char *s)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 113:	eb 04                	jmp    119 <strlen+0x13>
 115:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 119:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	01 d0                	add    %edx,%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	84 c0                	test   %al,%al
 126:	75 ed                	jne    115 <strlen+0xf>
    ;
  return n;
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <memset>:

void*
memset(void *dst, int c, uint n)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	89 44 24 08          	mov    %eax,0x8(%esp)
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 44 24 04          	mov    %eax,0x4(%esp)
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	89 04 24             	mov    %eax,(%esp)
 147:	e8 20 ff ff ff       	call   6c <stosb>
  return dst;
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14f:	c9                   	leave  
 150:	c3                   	ret    

00000151 <strchr>:

char*
strchr(const char *s, char c)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 04             	sub    $0x4,%esp
 157:	8b 45 0c             	mov    0xc(%ebp),%eax
 15a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15d:	eb 14                	jmp    173 <strchr+0x22>
    if(*s == c)
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	0f b6 00             	movzbl (%eax),%eax
 165:	3a 45 fc             	cmp    -0x4(%ebp),%al
 168:	75 05                	jne    16f <strchr+0x1e>
      return (char*)s;
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	eb 13                	jmp    182 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	84 c0                	test   %al,%al
 17b:	75 e2                	jne    15f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 17d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 182:	c9                   	leave  
 183:	c3                   	ret    

00000184 <gets>:

char*
gets(char *buf, int max)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 191:	eb 46                	jmp    1d9 <gets+0x55>
    cc = read(0, &c, 1);
 193:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 19a:	00 
 19b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 19e:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a9:	e8 3d 01 00 00       	call   2eb <read>
 1ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b5:	7e 2f                	jle    1e6 <gets+0x62>
      break;
    buf[i++] = c;
 1b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 c2                	add    %eax,%edx
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	88 02                	mov    %al,(%edx)
 1c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cd:	3c 0a                	cmp    $0xa,%al
 1cf:	74 16                	je     1e7 <gets+0x63>
 1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 0e                	je     1e7 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e2:	7c af                	jl     193 <gets+0xf>
 1e4:	eb 01                	jmp    1e7 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1e6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	01 d0                	add    %edx,%eax
 1ef:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <stat>:

int
stat(char *n, struct stat *st)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 204:	00 
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	89 04 24             	mov    %eax,(%esp)
 20b:	e8 03 01 00 00       	call   313 <open>
 210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 217:	79 07                	jns    220 <stat+0x29>
    return -1;
 219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21e:	eb 23                	jmp    243 <stat+0x4c>
  r = fstat(fd, st);
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	89 44 24 04          	mov    %eax,0x4(%esp)
 227:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22a:	89 04 24             	mov    %eax,(%esp)
 22d:	e8 f9 00 00 00       	call   32b <fstat>
 232:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	89 04 24             	mov    %eax,(%esp)
 23b:	e8 bb 00 00 00       	call   2fb <close>
  return r;
 240:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 243:	c9                   	leave  
 244:	c3                   	ret    

00000245 <atoi>:

int
atoi(const char *s)
{
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 24b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 252:	eb 23                	jmp    277 <atoi+0x32>
    n = n*10 + *s++ - '0';
 254:	8b 55 fc             	mov    -0x4(%ebp),%edx
 257:	89 d0                	mov    %edx,%eax
 259:	c1 e0 02             	shl    $0x2,%eax
 25c:	01 d0                	add    %edx,%eax
 25e:	01 c0                	add    %eax,%eax
 260:	89 c2                	mov    %eax,%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	0f be c0             	movsbl %al,%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	83 e8 30             	sub    $0x30,%eax
 270:	89 45 fc             	mov    %eax,-0x4(%ebp)
 273:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 2f                	cmp    $0x2f,%al
 27f:	7e 0a                	jle    28b <atoi+0x46>
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 39                	cmp    $0x39,%al
 289:	7e c9                	jle    254 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28e:	c9                   	leave  
 28f:	c3                   	ret    

00000290 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 29c:	8b 45 0c             	mov    0xc(%ebp),%eax
 29f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a2:	eb 13                	jmp    2b7 <memmove+0x27>
    *dst++ = *src++;
 2a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a7:	0f b6 10             	movzbl (%eax),%edx
 2aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ad:	88 10                	mov    %dl,(%eax)
 2af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2b3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2bb:	0f 9f c0             	setg   %al
 2be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2c2:	84 c0                	test   %al,%al
 2c4:	75 de                	jne    2a4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    

000002cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cb:	b8 01 00 00 00       	mov    $0x1,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <exit>:
SYSCALL(exit)
 2d3:	b8 02 00 00 00       	mov    $0x2,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <wait>:
SYSCALL(wait)
 2db:	b8 03 00 00 00       	mov    $0x3,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <pipe>:
SYSCALL(pipe)
 2e3:	b8 04 00 00 00       	mov    $0x4,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <read>:
SYSCALL(read)
 2eb:	b8 05 00 00 00       	mov    $0x5,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <write>:
SYSCALL(write)
 2f3:	b8 10 00 00 00       	mov    $0x10,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <close>:
SYSCALL(close)
 2fb:	b8 15 00 00 00       	mov    $0x15,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <kill>:
SYSCALL(kill)
 303:	b8 06 00 00 00       	mov    $0x6,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <exec>:
SYSCALL(exec)
 30b:	b8 07 00 00 00       	mov    $0x7,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <open>:
SYSCALL(open)
 313:	b8 0f 00 00 00       	mov    $0xf,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mknod>:
SYSCALL(mknod)
 31b:	b8 11 00 00 00       	mov    $0x11,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <unlink>:
SYSCALL(unlink)
 323:	b8 12 00 00 00       	mov    $0x12,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <fstat>:
SYSCALL(fstat)
 32b:	b8 08 00 00 00       	mov    $0x8,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <link>:
SYSCALL(link)
 333:	b8 13 00 00 00       	mov    $0x13,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mkdir>:
SYSCALL(mkdir)
 33b:	b8 14 00 00 00       	mov    $0x14,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <chdir>:
SYSCALL(chdir)
 343:	b8 09 00 00 00       	mov    $0x9,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <dup>:
SYSCALL(dup)
 34b:	b8 0a 00 00 00       	mov    $0xa,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <getpid>:
SYSCALL(getpid)
 353:	b8 0b 00 00 00       	mov    $0xb,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sbrk>:
SYSCALL(sbrk)
 35b:	b8 0c 00 00 00       	mov    $0xc,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <sleep>:
SYSCALL(sleep)
 363:	b8 0d 00 00 00       	mov    $0xd,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <uptime>:
SYSCALL(uptime)
 36b:	b8 0e 00 00 00       	mov    $0xe,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getprocs>:
SYSCALL(getprocs)
 373:	b8 16 00 00 00       	mov    $0x16,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	83 ec 28             	sub    $0x28,%esp
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 387:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 38e:	00 
 38f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 392:	89 44 24 04          	mov    %eax,0x4(%esp)
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	89 04 24             	mov    %eax,(%esp)
 39c:	e8 52 ff ff ff       	call   2f3 <write>
}
 3a1:	c9                   	leave  
 3a2:	c3                   	ret    

000003a3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a3:	55                   	push   %ebp
 3a4:	89 e5                	mov    %esp,%ebp
 3a6:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b4:	74 17                	je     3cd <printint+0x2a>
 3b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ba:	79 11                	jns    3cd <printint+0x2a>
    neg = 1;
 3bc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c6:	f7 d8                	neg    %eax
 3c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cb:	eb 06                	jmp    3d3 <printint+0x30>
  } else {
    x = xx;
 3cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3da:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e0:	ba 00 00 00 00       	mov    $0x0,%edx
 3e5:	f7 f1                	div    %ecx
 3e7:	89 d0                	mov    %edx,%eax
 3e9:	0f b6 80 74 0a 00 00 	movzbl 0xa74(%eax),%eax
 3f0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3f6:	01 ca                	add    %ecx,%edx
 3f8:	88 02                	mov    %al,(%edx)
 3fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3fe:	8b 55 10             	mov    0x10(%ebp),%edx
 401:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 404:	8b 45 ec             	mov    -0x14(%ebp),%eax
 407:	ba 00 00 00 00       	mov    $0x0,%edx
 40c:	f7 75 d4             	divl   -0x2c(%ebp)
 40f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 412:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 416:	75 c2                	jne    3da <printint+0x37>
  if(neg)
 418:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41c:	74 2e                	je     44c <printint+0xa9>
    buf[i++] = '-';
 41e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 421:	8b 45 f4             	mov    -0xc(%ebp),%eax
 424:	01 d0                	add    %edx,%eax
 426:	c6 00 2d             	movb   $0x2d,(%eax)
 429:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 42d:	eb 1d                	jmp    44c <printint+0xa9>
    putc(fd, buf[i]);
 42f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 432:	8b 45 f4             	mov    -0xc(%ebp),%eax
 435:	01 d0                	add    %edx,%eax
 437:	0f b6 00             	movzbl (%eax),%eax
 43a:	0f be c0             	movsbl %al,%eax
 43d:	89 44 24 04          	mov    %eax,0x4(%esp)
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	89 04 24             	mov    %eax,(%esp)
 447:	e8 2f ff ff ff       	call   37b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 44c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 450:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 454:	79 d9                	jns    42f <printint+0x8c>
    putc(fd, buf[i]);
}
 456:	c9                   	leave  
 457:	c3                   	ret    

00000458 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 458:	55                   	push   %ebp
 459:	89 e5                	mov    %esp,%ebp
 45b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 465:	8d 45 0c             	lea    0xc(%ebp),%eax
 468:	83 c0 04             	add    $0x4,%eax
 46b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 475:	e9 7d 01 00 00       	jmp    5f7 <printf+0x19f>
    c = fmt[i] & 0xff;
 47a:	8b 55 0c             	mov    0xc(%ebp),%edx
 47d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 480:	01 d0                	add    %edx,%eax
 482:	0f b6 00             	movzbl (%eax),%eax
 485:	0f be c0             	movsbl %al,%eax
 488:	25 ff 00 00 00       	and    $0xff,%eax
 48d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 490:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 494:	75 2c                	jne    4c2 <printf+0x6a>
      if(c == '%'){
 496:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 49a:	75 0c                	jne    4a8 <printf+0x50>
        state = '%';
 49c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a3:	e9 4b 01 00 00       	jmp    5f3 <printf+0x19b>
      } else {
        putc(fd, c);
 4a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ab:	0f be c0             	movsbl %al,%eax
 4ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	89 04 24             	mov    %eax,(%esp)
 4b8:	e8 be fe ff ff       	call   37b <putc>
 4bd:	e9 31 01 00 00       	jmp    5f3 <printf+0x19b>
      }
    } else if(state == '%'){
 4c2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c6:	0f 85 27 01 00 00    	jne    5f3 <printf+0x19b>
      if(c == 'd'){
 4cc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d0:	75 2d                	jne    4ff <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d5:	8b 00                	mov    (%eax),%eax
 4d7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4de:	00 
 4df:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4e6:	00 
 4e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4eb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ee:	89 04 24             	mov    %eax,(%esp)
 4f1:	e8 ad fe ff ff       	call   3a3 <printint>
        ap++;
 4f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4fa:	e9 ed 00 00 00       	jmp    5ec <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4ff:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 503:	74 06                	je     50b <printf+0xb3>
 505:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 509:	75 2d                	jne    538 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 50b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50e:	8b 00                	mov    (%eax),%eax
 510:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 517:	00 
 518:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 51f:	00 
 520:	89 44 24 04          	mov    %eax,0x4(%esp)
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	89 04 24             	mov    %eax,(%esp)
 52a:	e8 74 fe ff ff       	call   3a3 <printint>
        ap++;
 52f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 533:	e9 b4 00 00 00       	jmp    5ec <printf+0x194>
      } else if(c == 's'){
 538:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 53c:	75 46                	jne    584 <printf+0x12c>
        s = (char*)*ap;
 53e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 541:	8b 00                	mov    (%eax),%eax
 543:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 546:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 54a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54e:	75 27                	jne    577 <printf+0x11f>
          s = "(null)";
 550:	c7 45 f4 2e 08 00 00 	movl   $0x82e,-0xc(%ebp)
        while(*s != 0){
 557:	eb 1e                	jmp    577 <printf+0x11f>
          putc(fd, *s);
 559:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	0f be c0             	movsbl %al,%eax
 562:	89 44 24 04          	mov    %eax,0x4(%esp)
 566:	8b 45 08             	mov    0x8(%ebp),%eax
 569:	89 04 24             	mov    %eax,(%esp)
 56c:	e8 0a fe ff ff       	call   37b <putc>
          s++;
 571:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 575:	eb 01                	jmp    578 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 577:	90                   	nop
 578:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57b:	0f b6 00             	movzbl (%eax),%eax
 57e:	84 c0                	test   %al,%al
 580:	75 d7                	jne    559 <printf+0x101>
 582:	eb 68                	jmp    5ec <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 584:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 588:	75 1d                	jne    5a7 <printf+0x14f>
        putc(fd, *ap);
 58a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58d:	8b 00                	mov    (%eax),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	89 44 24 04          	mov    %eax,0x4(%esp)
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	89 04 24             	mov    %eax,(%esp)
 59c:	e8 da fd ff ff       	call   37b <putc>
        ap++;
 5a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a5:	eb 45                	jmp    5ec <printf+0x194>
      } else if(c == '%'){
 5a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ab:	75 17                	jne    5c4 <printf+0x16c>
        putc(fd, c);
 5ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 b9 fd ff ff       	call   37b <putc>
 5c2:	eb 28                	jmp    5ec <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5cb:	00 
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 a4 fd ff ff       	call   37b <putc>
        putc(fd, c);
 5d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5da:	0f be c0             	movsbl %al,%eax
 5dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
 5e4:	89 04 24             	mov    %eax,(%esp)
 5e7:	e8 8f fd ff ff       	call   37b <putc>
      }
      state = 0;
 5ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fd:	01 d0                	add    %edx,%eax
 5ff:	0f b6 00             	movzbl (%eax),%eax
 602:	84 c0                	test   %al,%al
 604:	0f 85 70 fe ff ff    	jne    47a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 60a:	c9                   	leave  
 60b:	c3                   	ret    

0000060c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60c:	55                   	push   %ebp
 60d:	89 e5                	mov    %esp,%ebp
 60f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	83 e8 08             	sub    $0x8,%eax
 618:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61b:	a1 90 0a 00 00       	mov    0xa90,%eax
 620:	89 45 fc             	mov    %eax,-0x4(%ebp)
 623:	eb 24                	jmp    649 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	77 12                	ja     641 <free+0x35>
 62f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 632:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 635:	77 24                	ja     65b <free+0x4f>
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63f:	77 1a                	ja     65b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	89 45 fc             	mov    %eax,-0x4(%ebp)
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64f:	76 d4                	jbe    625 <free+0x19>
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 659:	76 ca                	jbe    625 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	01 c2                	add    %eax,%edx
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	39 c2                	cmp    %eax,%edx
 674:	75 24                	jne    69a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	8b 50 04             	mov    0x4(%eax),%edx
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	8b 40 04             	mov    0x4(%eax),%eax
 684:	01 c2                	add    %eax,%edx
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	8b 10                	mov    (%eax),%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	89 10                	mov    %edx,(%eax)
 698:	eb 0a                	jmp    6a4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 40 04             	mov    0x4(%eax),%eax
 6aa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	01 d0                	add    %edx,%eax
 6b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b9:	75 20                	jne    6db <free+0xcf>
    p->s.size += bp->s.size;
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 50 04             	mov    0x4(%eax),%edx
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	8b 40 04             	mov    0x4(%eax),%eax
 6c7:	01 c2                	add    %eax,%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	89 10                	mov    %edx,(%eax)
 6d9:	eb 08                	jmp    6e3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	a3 90 0a 00 00       	mov    %eax,0xa90
}
 6eb:	c9                   	leave  
 6ec:	c3                   	ret    

000006ed <morecore>:

static Header*
morecore(uint nu)
{
 6ed:	55                   	push   %ebp
 6ee:	89 e5                	mov    %esp,%ebp
 6f0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6fa:	77 07                	ja     703 <morecore+0x16>
    nu = 4096;
 6fc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	c1 e0 03             	shl    $0x3,%eax
 709:	89 04 24             	mov    %eax,(%esp)
 70c:	e8 4a fc ff ff       	call   35b <sbrk>
 711:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 714:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 718:	75 07                	jne    721 <morecore+0x34>
    return 0;
 71a:	b8 00 00 00 00       	mov    $0x0,%eax
 71f:	eb 22                	jmp    743 <morecore+0x56>
  hp = (Header*)p;
 721:	8b 45 f4             	mov    -0xc(%ebp),%eax
 724:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 727:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72a:	8b 55 08             	mov    0x8(%ebp),%edx
 72d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 730:	8b 45 f0             	mov    -0x10(%ebp),%eax
 733:	83 c0 08             	add    $0x8,%eax
 736:	89 04 24             	mov    %eax,(%esp)
 739:	e8 ce fe ff ff       	call   60c <free>
  return freep;
 73e:	a1 90 0a 00 00       	mov    0xa90,%eax
}
 743:	c9                   	leave  
 744:	c3                   	ret    

00000745 <malloc>:

void*
malloc(uint nbytes)
{
 745:	55                   	push   %ebp
 746:	89 e5                	mov    %esp,%ebp
 748:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74b:	8b 45 08             	mov    0x8(%ebp),%eax
 74e:	83 c0 07             	add    $0x7,%eax
 751:	c1 e8 03             	shr    $0x3,%eax
 754:	83 c0 01             	add    $0x1,%eax
 757:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 75a:	a1 90 0a 00 00       	mov    0xa90,%eax
 75f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 762:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 766:	75 23                	jne    78b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 768:	c7 45 f0 88 0a 00 00 	movl   $0xa88,-0x10(%ebp)
 76f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 772:	a3 90 0a 00 00       	mov    %eax,0xa90
 777:	a1 90 0a 00 00       	mov    0xa90,%eax
 77c:	a3 88 0a 00 00       	mov    %eax,0xa88
    base.s.size = 0;
 781:	c7 05 8c 0a 00 00 00 	movl   $0x0,0xa8c
 788:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78e:	8b 00                	mov    (%eax),%eax
 790:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	8b 40 04             	mov    0x4(%eax),%eax
 799:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79c:	72 4d                	jb     7eb <malloc+0xa6>
      if(p->s.size == nunits)
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	8b 40 04             	mov    0x4(%eax),%eax
 7a4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a7:	75 0c                	jne    7b5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	8b 10                	mov    (%eax),%edx
 7ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b1:	89 10                	mov    %edx,(%eax)
 7b3:	eb 26                	jmp    7db <malloc+0x96>
      else {
        p->s.size -= nunits;
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	8b 40 04             	mov    0x4(%eax),%eax
 7bb:	89 c2                	mov    %eax,%edx
 7bd:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	c1 e0 03             	shl    $0x3,%eax
 7cf:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7de:	a3 90 0a 00 00       	mov    %eax,0xa90
      return (void*)(p + 1);
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	83 c0 08             	add    $0x8,%eax
 7e9:	eb 38                	jmp    823 <malloc+0xde>
    }
    if(p == freep)
 7eb:	a1 90 0a 00 00       	mov    0xa90,%eax
 7f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f3:	75 1b                	jne    810 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f8:	89 04 24             	mov    %eax,(%esp)
 7fb:	e8 ed fe ff ff       	call   6ed <morecore>
 800:	89 45 f4             	mov    %eax,-0xc(%ebp)
 803:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 807:	75 07                	jne    810 <malloc+0xcb>
        return 0;
 809:	b8 00 00 00 00       	mov    $0x0,%eax
 80e:	eb 13                	jmp    823 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	89 45 f0             	mov    %eax,-0x10(%ebp)
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 00                	mov    (%eax),%eax
 81b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 81e:	e9 70 ff ff ff       	jmp    793 <malloc+0x4e>
}
 823:	c9                   	leave  
 824:	c3                   	ret    
