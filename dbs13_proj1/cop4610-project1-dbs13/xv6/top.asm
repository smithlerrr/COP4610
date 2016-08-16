
_top:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"


int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 20 07 00 00    	sub    $0x720,%esp
	struct uproc table[64];
	int max = 64;
   c:	c7 84 24 1c 07 00 00 	movl   $0x40,0x71c(%esp)
  13:	40 00 00 00 

  	int proc_count = getprocs(max, table);
  17:	8d 44 24 18          	lea    0x18(%esp),%eax
  1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  1f:	8b 84 24 1c 07 00 00 	mov    0x71c(%esp),%eax
  26:	89 04 24             	mov    %eax,(%esp)
  29:	e8 32 03 00 00       	call   360 <getprocs>
  2e:	89 84 24 18 07 00 00 	mov    %eax,0x718(%esp)
  	printf(1, "Number of Processes: %d\n", proc_count);
  35:	8b 84 24 18 07 00 00 	mov    0x718(%esp),%eax
  3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  40:	c7 44 24 04 12 08 00 	movl   $0x812,0x4(%esp)
  47:	00 
  48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4f:	e8 f1 03 00 00       	call   445 <printf>

	exit();
  54:	e8 67 02 00 00       	call   2c0 <exit>

00000059 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	57                   	push   %edi
  5d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  61:	8b 55 10             	mov    0x10(%ebp),%edx
  64:	8b 45 0c             	mov    0xc(%ebp),%eax
  67:	89 cb                	mov    %ecx,%ebx
  69:	89 df                	mov    %ebx,%edi
  6b:	89 d1                	mov    %edx,%ecx
  6d:	fc                   	cld    
  6e:	f3 aa                	rep stos %al,%es:(%edi)
  70:	89 ca                	mov    %ecx,%edx
  72:	89 fb                	mov    %edi,%ebx
  74:	89 5d 08             	mov    %ebx,0x8(%ebp)
  77:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  7a:	5b                   	pop    %ebx
  7b:	5f                   	pop    %edi
  7c:	5d                   	pop    %ebp
  7d:	c3                   	ret    

0000007e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  84:	8b 45 08             	mov    0x8(%ebp),%eax
  87:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  8a:	90                   	nop
  8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  8e:	0f b6 10             	movzbl (%eax),%edx
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	88 10                	mov    %dl,(%eax)
  96:	8b 45 08             	mov    0x8(%ebp),%eax
  99:	0f b6 00             	movzbl (%eax),%eax
  9c:	84 c0                	test   %al,%al
  9e:	0f 95 c0             	setne  %al
  a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  a9:	84 c0                	test   %al,%al
  ab:	75 de                	jne    8b <strcpy+0xd>
    ;
  return os;
  ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b0:	c9                   	leave  
  b1:	c3                   	ret    

000000b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b2:	55                   	push   %ebp
  b3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  b5:	eb 08                	jmp    bf <strcmp+0xd>
    p++, q++;
  b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  bb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  bf:	8b 45 08             	mov    0x8(%ebp),%eax
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	84 c0                	test   %al,%al
  c7:	74 10                	je     d9 <strcmp+0x27>
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	0f b6 10             	movzbl (%eax),%edx
  cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	38 c2                	cmp    %al,%dl
  d7:	74 de                	je     b7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d9:	8b 45 08             	mov    0x8(%ebp),%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	0f b6 d0             	movzbl %al,%edx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 c0             	movzbl %al,%eax
  eb:	89 d1                	mov    %edx,%ecx
  ed:	29 c1                	sub    %eax,%ecx
  ef:	89 c8                	mov    %ecx,%eax
}
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    

000000f3 <strlen>:

uint
strlen(char *s)
{
  f3:	55                   	push   %ebp
  f4:	89 e5                	mov    %esp,%ebp
  f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 100:	eb 04                	jmp    106 <strlen+0x13>
 102:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 106:	8b 55 fc             	mov    -0x4(%ebp),%edx
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	01 d0                	add    %edx,%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	84 c0                	test   %al,%al
 113:	75 ed                	jne    102 <strlen+0xf>
    ;
  return n;
 115:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 118:	c9                   	leave  
 119:	c3                   	ret    

0000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 120:	8b 45 10             	mov    0x10(%ebp),%eax
 123:	89 44 24 08          	mov    %eax,0x8(%esp)
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	89 44 24 04          	mov    %eax,0x4(%esp)
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	89 04 24             	mov    %eax,(%esp)
 134:	e8 20 ff ff ff       	call   59 <stosb>
  return dst;
 139:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <strchr>:

char*
strchr(const char *s, char c)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	83 ec 04             	sub    $0x4,%esp
 144:	8b 45 0c             	mov    0xc(%ebp),%eax
 147:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14a:	eb 14                	jmp    160 <strchr+0x22>
    if(*s == c)
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	0f b6 00             	movzbl (%eax),%eax
 152:	3a 45 fc             	cmp    -0x4(%ebp),%al
 155:	75 05                	jne    15c <strchr+0x1e>
      return (char*)s;
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	eb 13                	jmp    16f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	0f b6 00             	movzbl (%eax),%eax
 166:	84 c0                	test   %al,%al
 168:	75 e2                	jne    14c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 16a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <gets>:

char*
gets(char *buf, int max)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
 174:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17e:	eb 46                	jmp    1c6 <gets+0x55>
    cc = read(0, &c, 1);
 180:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 187:	00 
 188:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18b:	89 44 24 04          	mov    %eax,0x4(%esp)
 18f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 196:	e8 3d 01 00 00       	call   2d8 <read>
 19b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a2:	7e 2f                	jle    1d3 <gets+0x62>
      break;
    buf[i++] = c;
 1a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	01 c2                	add    %eax,%edx
 1ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b0:	88 02                	mov    %al,(%edx)
 1b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	3c 0a                	cmp    $0xa,%al
 1bc:	74 16                	je     1d4 <gets+0x63>
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0d                	cmp    $0xd,%al
 1c4:	74 0e                	je     1d4 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c9:	83 c0 01             	add    $0x1,%eax
 1cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1cf:	7c af                	jl     180 <gets+0xf>
 1d1:	eb 01                	jmp    1d4 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d3:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	01 d0                	add    %edx,%eax
 1dc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e2:	c9                   	leave  
 1e3:	c3                   	ret    

000001e4 <stat>:

int
stat(char *n, struct stat *st)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f1:	00 
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	89 04 24             	mov    %eax,(%esp)
 1f8:	e8 03 01 00 00       	call   300 <open>
 1fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 200:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 204:	79 07                	jns    20d <stat+0x29>
    return -1;
 206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20b:	eb 23                	jmp    230 <stat+0x4c>
  r = fstat(fd, st);
 20d:	8b 45 0c             	mov    0xc(%ebp),%eax
 210:	89 44 24 04          	mov    %eax,0x4(%esp)
 214:	8b 45 f4             	mov    -0xc(%ebp),%eax
 217:	89 04 24             	mov    %eax,(%esp)
 21a:	e8 f9 00 00 00       	call   318 <fstat>
 21f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 222:	8b 45 f4             	mov    -0xc(%ebp),%eax
 225:	89 04 24             	mov    %eax,(%esp)
 228:	e8 bb 00 00 00       	call   2e8 <close>
  return r;
 22d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <atoi>:

int
atoi(const char *s)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 238:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23f:	eb 23                	jmp    264 <atoi+0x32>
    n = n*10 + *s++ - '0';
 241:	8b 55 fc             	mov    -0x4(%ebp),%edx
 244:	89 d0                	mov    %edx,%eax
 246:	c1 e0 02             	shl    $0x2,%eax
 249:	01 d0                	add    %edx,%eax
 24b:	01 c0                	add    %eax,%eax
 24d:	89 c2                	mov    %eax,%edx
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	0f b6 00             	movzbl (%eax),%eax
 255:	0f be c0             	movsbl %al,%eax
 258:	01 d0                	add    %edx,%eax
 25a:	83 e8 30             	sub    $0x30,%eax
 25d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 260:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	0f b6 00             	movzbl (%eax),%eax
 26a:	3c 2f                	cmp    $0x2f,%al
 26c:	7e 0a                	jle    278 <atoi+0x46>
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	0f b6 00             	movzbl (%eax),%eax
 274:	3c 39                	cmp    $0x39,%al
 276:	7e c9                	jle    241 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 278:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27b:	c9                   	leave  
 27c:	c3                   	ret    

0000027d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 27d:	55                   	push   %ebp
 27e:	89 e5                	mov    %esp,%ebp
 280:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 289:	8b 45 0c             	mov    0xc(%ebp),%eax
 28c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 28f:	eb 13                	jmp    2a4 <memmove+0x27>
    *dst++ = *src++;
 291:	8b 45 f8             	mov    -0x8(%ebp),%eax
 294:	0f b6 10             	movzbl (%eax),%edx
 297:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29a:	88 10                	mov    %dl,(%eax)
 29c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2a0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2a8:	0f 9f c0             	setg   %al
 2ab:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2af:	84 c0                	test   %al,%al
 2b1:	75 de                	jne    291 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b8:	b8 01 00 00 00       	mov    $0x1,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <exit>:
SYSCALL(exit)
 2c0:	b8 02 00 00 00       	mov    $0x2,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <wait>:
SYSCALL(wait)
 2c8:	b8 03 00 00 00       	mov    $0x3,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <pipe>:
SYSCALL(pipe)
 2d0:	b8 04 00 00 00       	mov    $0x4,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <read>:
SYSCALL(read)
 2d8:	b8 05 00 00 00       	mov    $0x5,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <write>:
SYSCALL(write)
 2e0:	b8 10 00 00 00       	mov    $0x10,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <close>:
SYSCALL(close)
 2e8:	b8 15 00 00 00       	mov    $0x15,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <kill>:
SYSCALL(kill)
 2f0:	b8 06 00 00 00       	mov    $0x6,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <exec>:
SYSCALL(exec)
 2f8:	b8 07 00 00 00       	mov    $0x7,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <open>:
SYSCALL(open)
 300:	b8 0f 00 00 00       	mov    $0xf,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <mknod>:
SYSCALL(mknod)
 308:	b8 11 00 00 00       	mov    $0x11,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <unlink>:
SYSCALL(unlink)
 310:	b8 12 00 00 00       	mov    $0x12,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <fstat>:
SYSCALL(fstat)
 318:	b8 08 00 00 00       	mov    $0x8,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <link>:
SYSCALL(link)
 320:	b8 13 00 00 00       	mov    $0x13,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <mkdir>:
SYSCALL(mkdir)
 328:	b8 14 00 00 00       	mov    $0x14,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <chdir>:
SYSCALL(chdir)
 330:	b8 09 00 00 00       	mov    $0x9,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <dup>:
SYSCALL(dup)
 338:	b8 0a 00 00 00       	mov    $0xa,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <getpid>:
SYSCALL(getpid)
 340:	b8 0b 00 00 00       	mov    $0xb,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <sbrk>:
SYSCALL(sbrk)
 348:	b8 0c 00 00 00       	mov    $0xc,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sleep>:
SYSCALL(sleep)
 350:	b8 0d 00 00 00       	mov    $0xd,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <uptime>:
SYSCALL(uptime)
 358:	b8 0e 00 00 00       	mov    $0xe,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <getprocs>:
SYSCALL(getprocs)
 360:	b8 16 00 00 00       	mov    $0x16,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	83 ec 28             	sub    $0x28,%esp
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 374:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 37b:	00 
 37c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37f:	89 44 24 04          	mov    %eax,0x4(%esp)
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	89 04 24             	mov    %eax,(%esp)
 389:	e8 52 ff ff ff       	call   2e0 <write>
}
 38e:	c9                   	leave  
 38f:	c3                   	ret    

00000390 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 396:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a1:	74 17                	je     3ba <printint+0x2a>
 3a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a7:	79 11                	jns    3ba <printint+0x2a>
    neg = 1;
 3a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b3:	f7 d8                	neg    %eax
 3b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b8:	eb 06                	jmp    3c0 <printint+0x30>
  } else {
    x = xx;
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cd:	ba 00 00 00 00       	mov    $0x0,%edx
 3d2:	f7 f1                	div    %ecx
 3d4:	89 d0                	mov    %edx,%eax
 3d6:	0f b6 80 70 0a 00 00 	movzbl 0xa70(%eax),%eax
 3dd:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3e3:	01 ca                	add    %ecx,%edx
 3e5:	88 02                	mov    %al,(%edx)
 3e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3eb:	8b 55 10             	mov    0x10(%ebp),%edx
 3ee:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f4:	ba 00 00 00 00       	mov    $0x0,%edx
 3f9:	f7 75 d4             	divl   -0x2c(%ebp)
 3fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 403:	75 c2                	jne    3c7 <printint+0x37>
  if(neg)
 405:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 409:	74 2e                	je     439 <printint+0xa9>
    buf[i++] = '-';
 40b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 40e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 411:	01 d0                	add    %edx,%eax
 413:	c6 00 2d             	movb   $0x2d,(%eax)
 416:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 41a:	eb 1d                	jmp    439 <printint+0xa9>
    putc(fd, buf[i]);
 41c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 41f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 422:	01 d0                	add    %edx,%eax
 424:	0f b6 00             	movzbl (%eax),%eax
 427:	0f be c0             	movsbl %al,%eax
 42a:	89 44 24 04          	mov    %eax,0x4(%esp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	89 04 24             	mov    %eax,(%esp)
 434:	e8 2f ff ff ff       	call   368 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 439:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 43d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 441:	79 d9                	jns    41c <printint+0x8c>
    putc(fd, buf[i]);
}
 443:	c9                   	leave  
 444:	c3                   	ret    

00000445 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 44b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 452:	8d 45 0c             	lea    0xc(%ebp),%eax
 455:	83 c0 04             	add    $0x4,%eax
 458:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 45b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 462:	e9 7d 01 00 00       	jmp    5e4 <printf+0x19f>
    c = fmt[i] & 0xff;
 467:	8b 55 0c             	mov    0xc(%ebp),%edx
 46a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46d:	01 d0                	add    %edx,%eax
 46f:	0f b6 00             	movzbl (%eax),%eax
 472:	0f be c0             	movsbl %al,%eax
 475:	25 ff 00 00 00       	and    $0xff,%eax
 47a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 47d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 481:	75 2c                	jne    4af <printf+0x6a>
      if(c == '%'){
 483:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 487:	75 0c                	jne    495 <printf+0x50>
        state = '%';
 489:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 490:	e9 4b 01 00 00       	jmp    5e0 <printf+0x19b>
      } else {
        putc(fd, c);
 495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 498:	0f be c0             	movsbl %al,%eax
 49b:	89 44 24 04          	mov    %eax,0x4(%esp)
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	89 04 24             	mov    %eax,(%esp)
 4a5:	e8 be fe ff ff       	call   368 <putc>
 4aa:	e9 31 01 00 00       	jmp    5e0 <printf+0x19b>
      }
    } else if(state == '%'){
 4af:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b3:	0f 85 27 01 00 00    	jne    5e0 <printf+0x19b>
      if(c == 'd'){
 4b9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4bd:	75 2d                	jne    4ec <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c2:	8b 00                	mov    (%eax),%eax
 4c4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4cb:	00 
 4cc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d3:	00 
 4d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	89 04 24             	mov    %eax,(%esp)
 4de:	e8 ad fe ff ff       	call   390 <printint>
        ap++;
 4e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e7:	e9 ed 00 00 00       	jmp    5d9 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4ec:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f0:	74 06                	je     4f8 <printf+0xb3>
 4f2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f6:	75 2d                	jne    525 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fb:	8b 00                	mov    (%eax),%eax
 4fd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 504:	00 
 505:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 50c:	00 
 50d:	89 44 24 04          	mov    %eax,0x4(%esp)
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	89 04 24             	mov    %eax,(%esp)
 517:	e8 74 fe ff ff       	call   390 <printint>
        ap++;
 51c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 520:	e9 b4 00 00 00       	jmp    5d9 <printf+0x194>
      } else if(c == 's'){
 525:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 529:	75 46                	jne    571 <printf+0x12c>
        s = (char*)*ap;
 52b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52e:	8b 00                	mov    (%eax),%eax
 530:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53b:	75 27                	jne    564 <printf+0x11f>
          s = "(null)";
 53d:	c7 45 f4 2b 08 00 00 	movl   $0x82b,-0xc(%ebp)
        while(*s != 0){
 544:	eb 1e                	jmp    564 <printf+0x11f>
          putc(fd, *s);
 546:	8b 45 f4             	mov    -0xc(%ebp),%eax
 549:	0f b6 00             	movzbl (%eax),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 0a fe ff ff       	call   368 <putc>
          s++;
 55e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 562:	eb 01                	jmp    565 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 564:	90                   	nop
 565:	8b 45 f4             	mov    -0xc(%ebp),%eax
 568:	0f b6 00             	movzbl (%eax),%eax
 56b:	84 c0                	test   %al,%al
 56d:	75 d7                	jne    546 <printf+0x101>
 56f:	eb 68                	jmp    5d9 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 571:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 575:	75 1d                	jne    594 <printf+0x14f>
        putc(fd, *ap);
 577:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57a:	8b 00                	mov    (%eax),%eax
 57c:	0f be c0             	movsbl %al,%eax
 57f:	89 44 24 04          	mov    %eax,0x4(%esp)
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	89 04 24             	mov    %eax,(%esp)
 589:	e8 da fd ff ff       	call   368 <putc>
        ap++;
 58e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 592:	eb 45                	jmp    5d9 <printf+0x194>
      } else if(c == '%'){
 594:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 598:	75 17                	jne    5b1 <printf+0x16c>
        putc(fd, c);
 59a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59d:	0f be c0             	movsbl %al,%eax
 5a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
 5a7:	89 04 24             	mov    %eax,(%esp)
 5aa:	e8 b9 fd ff ff       	call   368 <putc>
 5af:	eb 28                	jmp    5d9 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b8:	00 
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	89 04 24             	mov    %eax,(%esp)
 5bf:	e8 a4 fd ff ff       	call   368 <putc>
        putc(fd, c);
 5c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 8f fd ff ff       	call   368 <putc>
      }
      state = 0;
 5d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5e4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ea:	01 d0                	add    %edx,%eax
 5ec:	0f b6 00             	movzbl (%eax),%eax
 5ef:	84 c0                	test   %al,%al
 5f1:	0f 85 70 fe ff ff    	jne    467 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f7:	c9                   	leave  
 5f8:	c3                   	ret    

000005f9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f9:	55                   	push   %ebp
 5fa:	89 e5                	mov    %esp,%ebp
 5fc:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ff:	8b 45 08             	mov    0x8(%ebp),%eax
 602:	83 e8 08             	sub    $0x8,%eax
 605:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 608:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 60d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 610:	eb 24                	jmp    636 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 612:	8b 45 fc             	mov    -0x4(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61a:	77 12                	ja     62e <free+0x35>
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 622:	77 24                	ja     648 <free+0x4f>
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62c:	77 1a                	ja     648 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	89 45 fc             	mov    %eax,-0x4(%ebp)
 636:	8b 45 f8             	mov    -0x8(%ebp),%eax
 639:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63c:	76 d4                	jbe    612 <free+0x19>
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 646:	76 ca                	jbe    612 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 648:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64b:	8b 40 04             	mov    0x4(%eax),%eax
 64e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	01 c2                	add    %eax,%edx
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	39 c2                	cmp    %eax,%edx
 661:	75 24                	jne    687 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	8b 50 04             	mov    0x4(%eax),%edx
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	8b 40 04             	mov    0x4(%eax),%eax
 671:	01 c2                	add    %eax,%edx
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	8b 10                	mov    (%eax),%edx
 680:	8b 45 f8             	mov    -0x8(%ebp),%eax
 683:	89 10                	mov    %edx,(%eax)
 685:	eb 0a                	jmp    691 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	8b 10                	mov    (%eax),%edx
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 40 04             	mov    0x4(%eax),%eax
 697:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	01 d0                	add    %edx,%eax
 6a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a6:	75 20                	jne    6c8 <free+0xcf>
    p->s.size += bp->s.size;
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 50 04             	mov    0x4(%eax),%edx
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	8b 40 04             	mov    0x4(%eax),%eax
 6b4:	01 c2                	add    %eax,%edx
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bf:	8b 10                	mov    (%eax),%edx
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	89 10                	mov    %edx,(%eax)
 6c6:	eb 08                	jmp    6d0 <free+0xd7>
  } else
    p->s.ptr = bp;
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ce:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	a3 8c 0a 00 00       	mov    %eax,0xa8c
}
 6d8:	c9                   	leave  
 6d9:	c3                   	ret    

000006da <morecore>:

static Header*
morecore(uint nu)
{
 6da:	55                   	push   %ebp
 6db:	89 e5                	mov    %esp,%ebp
 6dd:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6e0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e7:	77 07                	ja     6f0 <morecore+0x16>
    nu = 4096;
 6e9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6f0:	8b 45 08             	mov    0x8(%ebp),%eax
 6f3:	c1 e0 03             	shl    $0x3,%eax
 6f6:	89 04 24             	mov    %eax,(%esp)
 6f9:	e8 4a fc ff ff       	call   348 <sbrk>
 6fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 701:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 705:	75 07                	jne    70e <morecore+0x34>
    return 0;
 707:	b8 00 00 00 00       	mov    $0x0,%eax
 70c:	eb 22                	jmp    730 <morecore+0x56>
  hp = (Header*)p;
 70e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 711:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 714:	8b 45 f0             	mov    -0x10(%ebp),%eax
 717:	8b 55 08             	mov    0x8(%ebp),%edx
 71a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 71d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 720:	83 c0 08             	add    $0x8,%eax
 723:	89 04 24             	mov    %eax,(%esp)
 726:	e8 ce fe ff ff       	call   5f9 <free>
  return freep;
 72b:	a1 8c 0a 00 00       	mov    0xa8c,%eax
}
 730:	c9                   	leave  
 731:	c3                   	ret    

00000732 <malloc>:

void*
malloc(uint nbytes)
{
 732:	55                   	push   %ebp
 733:	89 e5                	mov    %esp,%ebp
 735:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 738:	8b 45 08             	mov    0x8(%ebp),%eax
 73b:	83 c0 07             	add    $0x7,%eax
 73e:	c1 e8 03             	shr    $0x3,%eax
 741:	83 c0 01             	add    $0x1,%eax
 744:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 747:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 74c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 753:	75 23                	jne    778 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 755:	c7 45 f0 84 0a 00 00 	movl   $0xa84,-0x10(%ebp)
 75c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75f:	a3 8c 0a 00 00       	mov    %eax,0xa8c
 764:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 769:	a3 84 0a 00 00       	mov    %eax,0xa84
    base.s.size = 0;
 76e:	c7 05 88 0a 00 00 00 	movl   $0x0,0xa88
 775:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	8b 00                	mov    (%eax),%eax
 77d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 780:	8b 45 f4             	mov    -0xc(%ebp),%eax
 783:	8b 40 04             	mov    0x4(%eax),%eax
 786:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 789:	72 4d                	jb     7d8 <malloc+0xa6>
      if(p->s.size == nunits)
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 794:	75 0c                	jne    7a2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 10                	mov    (%eax),%edx
 79b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79e:	89 10                	mov    %edx,(%eax)
 7a0:	eb 26                	jmp    7c8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8b 40 04             	mov    0x4(%eax),%eax
 7a8:	89 c2                	mov    %eax,%edx
 7aa:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	8b 40 04             	mov    0x4(%eax),%eax
 7b9:	c1 e0 03             	shl    $0x3,%eax
 7bc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cb:	a3 8c 0a 00 00       	mov    %eax,0xa8c
      return (void*)(p + 1);
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	83 c0 08             	add    $0x8,%eax
 7d6:	eb 38                	jmp    810 <malloc+0xde>
    }
    if(p == freep)
 7d8:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 7dd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7e0:	75 1b                	jne    7fd <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e5:	89 04 24             	mov    %eax,(%esp)
 7e8:	e8 ed fe ff ff       	call   6da <morecore>
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f4:	75 07                	jne    7fd <malloc+0xcb>
        return 0;
 7f6:	b8 00 00 00 00       	mov    $0x0,%eax
 7fb:	eb 13                	jmp    810 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	89 45 f0             	mov    %eax,-0x10(%ebp)
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 00                	mov    (%eax),%eax
 808:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 80b:	e9 70 ff ff ff       	jmp    780 <malloc+0x4e>
}
 810:	c9                   	leave  
 811:	c3                   	ret    
