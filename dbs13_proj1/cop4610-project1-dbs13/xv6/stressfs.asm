
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 6d 09 00 	movl   $0x96d,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 60 05 00 00       	call   5a0 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 19 02 00 00       	call   275 <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 11                	jmp    7a <main+0x7a>
    if(fork() > 0)
  69:	e8 a5 03 00 00       	call   413 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7f 14                	jg     86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  72:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  79:	01 
  7a:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  81:	03 
  82:	7e e5                	jle    69 <main+0x69>
  84:	eb 01                	jmp    87 <main+0x87>
    if(fork() > 0)
      break;
  86:	90                   	nop

  printf(1, "write %d\n", i);
  87:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  92:	c7 44 24 04 80 09 00 	movl   $0x980,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 fa 04 00 00       	call   5a0 <printf>

  path[8] += i;
  a6:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ad:	00 
  ae:	89 c2                	mov    %eax,%edx
  b0:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b7:	01 d0                	add    %edx,%eax
  b9:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  c0:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c7:	00 
  c8:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  cf:	89 04 24             	mov    %eax,(%esp)
  d2:	e8 84 03 00 00       	call   45b <open>
  d7:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  de:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e5:	00 00 00 00 
  e9:	eb 27                	jmp    112 <main+0x112>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  eb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f2:	00 
  f3:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  fb:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 102:	89 04 24             	mov    %eax,(%esp)
 105:	e8 31 03 00 00       	call   43b <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 10a:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 111:	01 
 112:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 119:	13 
 11a:	7e cf                	jle    eb <main+0xeb>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11c:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 123:	89 04 24             	mov    %eax,(%esp)
 126:	e8 18 03 00 00       	call   443 <close>

  printf(1, "read\n");
 12b:	c7 44 24 04 8a 09 00 	movl   $0x98a,0x4(%esp)
 132:	00 
 133:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13a:	e8 61 04 00 00       	call   5a0 <printf>

  fd = open(path, O_RDONLY);
 13f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 146:	00 
 147:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14e:	89 04 24             	mov    %eax,(%esp)
 151:	e8 05 03 00 00       	call   45b <open>
 156:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15d:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 164:	00 00 00 00 
 168:	eb 27                	jmp    191 <main+0x191>
    read(fd, data, sizeof(data));
 16a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 171:	00 
 172:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 176:	89 44 24 04          	mov    %eax,0x4(%esp)
 17a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 181:	89 04 24             	mov    %eax,(%esp)
 184:	e8 aa 02 00 00       	call   433 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 189:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 190:	01 
 191:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 198:	13 
 199:	7e cf                	jle    16a <main+0x16a>
    read(fd, data, sizeof(data));
  close(fd);
 19b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a2:	89 04 24             	mov    %eax,(%esp)
 1a5:	e8 99 02 00 00       	call   443 <close>

  wait();
 1aa:	e8 74 02 00 00       	call   423 <wait>
  
  exit();
 1af:	e8 67 02 00 00       	call   41b <exit>

000001b4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bc:	8b 55 10             	mov    0x10(%ebp),%edx
 1bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c2:	89 cb                	mov    %ecx,%ebx
 1c4:	89 df                	mov    %ebx,%edi
 1c6:	89 d1                	mov    %edx,%ecx
 1c8:	fc                   	cld    
 1c9:	f3 aa                	rep stos %al,%es:(%edi)
 1cb:	89 ca                	mov    %ecx,%edx
 1cd:	89 fb                	mov    %edi,%ebx
 1cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d5:	5b                   	pop    %ebx
 1d6:	5f                   	pop    %edi
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    

000001d9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e5:	90                   	nop
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	0f b6 10             	movzbl (%eax),%edx
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	88 10                	mov    %dl,(%eax)
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	0f b6 00             	movzbl (%eax),%eax
 1f7:	84 c0                	test   %al,%al
 1f9:	0f 95 c0             	setne  %al
 1fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 200:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 204:	84 c0                	test   %al,%al
 206:	75 de                	jne    1e6 <strcpy+0xd>
    ;
  return os;
 208:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20b:	c9                   	leave  
 20c:	c3                   	ret    

0000020d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 210:	eb 08                	jmp    21a <strcmp+0xd>
    p++, q++;
 212:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 216:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 00             	movzbl (%eax),%eax
 220:	84 c0                	test   %al,%al
 222:	74 10                	je     234 <strcmp+0x27>
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	0f b6 10             	movzbl (%eax),%edx
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	0f b6 00             	movzbl (%eax),%eax
 230:	38 c2                	cmp    %al,%dl
 232:	74 de                	je     212 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	0f b6 00             	movzbl (%eax),%eax
 23a:	0f b6 d0             	movzbl %al,%edx
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	0f b6 c0             	movzbl %al,%eax
 246:	89 d1                	mov    %edx,%ecx
 248:	29 c1                	sub    %eax,%ecx
 24a:	89 c8                	mov    %ecx,%eax
}
 24c:	5d                   	pop    %ebp
 24d:	c3                   	ret    

0000024e <strlen>:

uint
strlen(char *s)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25b:	eb 04                	jmp    261 <strlen+0x13>
 25d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 261:	8b 55 fc             	mov    -0x4(%ebp),%edx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	01 d0                	add    %edx,%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	84 c0                	test   %al,%al
 26e:	75 ed                	jne    25d <strlen+0xf>
    ;
  return n;
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <memset>:

void*
memset(void *dst, int c, uint n)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 27b:	8b 45 10             	mov    0x10(%ebp),%eax
 27e:	89 44 24 08          	mov    %eax,0x8(%esp)
 282:	8b 45 0c             	mov    0xc(%ebp),%eax
 285:	89 44 24 04          	mov    %eax,0x4(%esp)
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	89 04 24             	mov    %eax,(%esp)
 28f:	e8 20 ff ff ff       	call   1b4 <stosb>
  return dst;
 294:	8b 45 08             	mov    0x8(%ebp),%eax
}
 297:	c9                   	leave  
 298:	c3                   	ret    

00000299 <strchr>:

char*
strchr(const char *s, char c)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	83 ec 04             	sub    $0x4,%esp
 29f:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2a5:	eb 14                	jmp    2bb <strchr+0x22>
    if(*s == c)
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b0:	75 05                	jne    2b7 <strchr+0x1e>
      return (char*)s;
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	eb 13                	jmp    2ca <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	84 c0                	test   %al,%al
 2c3:	75 e2                	jne    2a7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <gets>:

char*
gets(char *buf, int max)
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d9:	eb 46                	jmp    321 <gets+0x55>
    cc = read(0, &c, 1);
 2db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e2:	00 
 2e3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f1:	e8 3d 01 00 00       	call   433 <read>
 2f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2fd:	7e 2f                	jle    32e <gets+0x62>
      break;
    buf[i++] = c;
 2ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	01 c2                	add    %eax,%edx
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	88 02                	mov    %al,(%edx)
 30d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 311:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 315:	3c 0a                	cmp    $0xa,%al
 317:	74 16                	je     32f <gets+0x63>
 319:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31d:	3c 0d                	cmp    $0xd,%al
 31f:	74 0e                	je     32f <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 321:	8b 45 f4             	mov    -0xc(%ebp),%eax
 324:	83 c0 01             	add    $0x1,%eax
 327:	3b 45 0c             	cmp    0xc(%ebp),%eax
 32a:	7c af                	jl     2db <gets+0xf>
 32c:	eb 01                	jmp    32f <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 32e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 32f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	01 d0                	add    %edx,%eax
 337:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33d:	c9                   	leave  
 33e:	c3                   	ret    

0000033f <stat>:

int
stat(char *n, struct stat *st)
{
 33f:	55                   	push   %ebp
 340:	89 e5                	mov    %esp,%ebp
 342:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 345:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 34c:	00 
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	89 04 24             	mov    %eax,(%esp)
 353:	e8 03 01 00 00       	call   45b <open>
 358:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 35b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 35f:	79 07                	jns    368 <stat+0x29>
    return -1;
 361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 366:	eb 23                	jmp    38b <stat+0x4c>
  r = fstat(fd, st);
 368:	8b 45 0c             	mov    0xc(%ebp),%eax
 36b:	89 44 24 04          	mov    %eax,0x4(%esp)
 36f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 372:	89 04 24             	mov    %eax,(%esp)
 375:	e8 f9 00 00 00       	call   473 <fstat>
 37a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 37d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 380:	89 04 24             	mov    %eax,(%esp)
 383:	e8 bb 00 00 00       	call   443 <close>
  return r;
 388:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 38b:	c9                   	leave  
 38c:	c3                   	ret    

0000038d <atoi>:

int
atoi(const char *s)
{
 38d:	55                   	push   %ebp
 38e:	89 e5                	mov    %esp,%ebp
 390:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 393:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 39a:	eb 23                	jmp    3bf <atoi+0x32>
    n = n*10 + *s++ - '0';
 39c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39f:	89 d0                	mov    %edx,%eax
 3a1:	c1 e0 02             	shl    $0x2,%eax
 3a4:	01 d0                	add    %edx,%eax
 3a6:	01 c0                	add    %eax,%eax
 3a8:	89 c2                	mov    %eax,%edx
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
 3ad:	0f b6 00             	movzbl (%eax),%eax
 3b0:	0f be c0             	movsbl %al,%eax
 3b3:	01 d0                	add    %edx,%eax
 3b5:	83 e8 30             	sub    $0x30,%eax
 3b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	3c 2f                	cmp    $0x2f,%al
 3c7:	7e 0a                	jle    3d3 <atoi+0x46>
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 39                	cmp    $0x39,%al
 3d1:	7e c9                	jle    39c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d6:	c9                   	leave  
 3d7:	c3                   	ret    

000003d8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3ea:	eb 13                	jmp    3ff <memmove+0x27>
    *dst++ = *src++;
 3ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ef:	0f b6 10             	movzbl (%eax),%edx
 3f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f5:	88 10                	mov    %dl,(%eax)
 3f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3fb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 403:	0f 9f c0             	setg   %al
 406:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 40a:	84 c0                	test   %al,%al
 40c:	75 de                	jne    3ec <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    

00000413 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 413:	b8 01 00 00 00       	mov    $0x1,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <exit>:
SYSCALL(exit)
 41b:	b8 02 00 00 00       	mov    $0x2,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <wait>:
SYSCALL(wait)
 423:	b8 03 00 00 00       	mov    $0x3,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <pipe>:
SYSCALL(pipe)
 42b:	b8 04 00 00 00       	mov    $0x4,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <read>:
SYSCALL(read)
 433:	b8 05 00 00 00       	mov    $0x5,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <write>:
SYSCALL(write)
 43b:	b8 10 00 00 00       	mov    $0x10,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <close>:
SYSCALL(close)
 443:	b8 15 00 00 00       	mov    $0x15,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <kill>:
SYSCALL(kill)
 44b:	b8 06 00 00 00       	mov    $0x6,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <exec>:
SYSCALL(exec)
 453:	b8 07 00 00 00       	mov    $0x7,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <open>:
SYSCALL(open)
 45b:	b8 0f 00 00 00       	mov    $0xf,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <mknod>:
SYSCALL(mknod)
 463:	b8 11 00 00 00       	mov    $0x11,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <unlink>:
SYSCALL(unlink)
 46b:	b8 12 00 00 00       	mov    $0x12,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <fstat>:
SYSCALL(fstat)
 473:	b8 08 00 00 00       	mov    $0x8,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <link>:
SYSCALL(link)
 47b:	b8 13 00 00 00       	mov    $0x13,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <mkdir>:
SYSCALL(mkdir)
 483:	b8 14 00 00 00       	mov    $0x14,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <chdir>:
SYSCALL(chdir)
 48b:	b8 09 00 00 00       	mov    $0x9,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <dup>:
SYSCALL(dup)
 493:	b8 0a 00 00 00       	mov    $0xa,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <getpid>:
SYSCALL(getpid)
 49b:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <sbrk>:
SYSCALL(sbrk)
 4a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <sleep>:
SYSCALL(sleep)
 4ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <uptime>:
SYSCALL(uptime)
 4b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <getprocs>:
SYSCALL(getprocs)
 4bb:	b8 16 00 00 00       	mov    $0x16,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c3:	55                   	push   %ebp
 4c4:	89 e5                	mov    %esp,%ebp
 4c6:	83 ec 28             	sub    $0x28,%esp
 4c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4cf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d6:	00 
 4d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4da:	89 44 24 04          	mov    %eax,0x4(%esp)
 4de:	8b 45 08             	mov    0x8(%ebp),%eax
 4e1:	89 04 24             	mov    %eax,(%esp)
 4e4:	e8 52 ff ff ff       	call   43b <write>
}
 4e9:	c9                   	leave  
 4ea:	c3                   	ret    

000004eb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4eb:	55                   	push   %ebp
 4ec:	89 e5                	mov    %esp,%ebp
 4ee:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4f8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4fc:	74 17                	je     515 <printint+0x2a>
 4fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 502:	79 11                	jns    515 <printint+0x2a>
    neg = 1;
 504:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 50b:	8b 45 0c             	mov    0xc(%ebp),%eax
 50e:	f7 d8                	neg    %eax
 510:	89 45 ec             	mov    %eax,-0x14(%ebp)
 513:	eb 06                	jmp    51b <printint+0x30>
  } else {
    x = xx;
 515:	8b 45 0c             	mov    0xc(%ebp),%eax
 518:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 51b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 522:	8b 4d 10             	mov    0x10(%ebp),%ecx
 525:	8b 45 ec             	mov    -0x14(%ebp),%eax
 528:	ba 00 00 00 00       	mov    $0x0,%edx
 52d:	f7 f1                	div    %ecx
 52f:	89 d0                	mov    %edx,%eax
 531:	0f b6 80 d4 0b 00 00 	movzbl 0xbd4(%eax),%eax
 538:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 53b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 53e:	01 ca                	add    %ecx,%edx
 540:	88 02                	mov    %al,(%edx)
 542:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 546:	8b 55 10             	mov    0x10(%ebp),%edx
 549:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 54c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54f:	ba 00 00 00 00       	mov    $0x0,%edx
 554:	f7 75 d4             	divl   -0x2c(%ebp)
 557:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55e:	75 c2                	jne    522 <printint+0x37>
  if(neg)
 560:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 564:	74 2e                	je     594 <printint+0xa9>
    buf[i++] = '-';
 566:	8d 55 dc             	lea    -0x24(%ebp),%edx
 569:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56c:	01 d0                	add    %edx,%eax
 56e:	c6 00 2d             	movb   $0x2d,(%eax)
 571:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 575:	eb 1d                	jmp    594 <printint+0xa9>
    putc(fd, buf[i]);
 577:	8d 55 dc             	lea    -0x24(%ebp),%edx
 57a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57d:	01 d0                	add    %edx,%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 2f ff ff ff       	call   4c3 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 594:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 598:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59c:	79 d9                	jns    577 <printint+0x8c>
    putc(fd, buf[i]);
}
 59e:	c9                   	leave  
 59f:	c3                   	ret    

000005a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ad:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b0:	83 c0 04             	add    $0x4,%eax
 5b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5bd:	e9 7d 01 00 00       	jmp    73f <printf+0x19f>
    c = fmt[i] & 0xff;
 5c2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c8:	01 d0                	add    %edx,%eax
 5ca:	0f b6 00             	movzbl (%eax),%eax
 5cd:	0f be c0             	movsbl %al,%eax
 5d0:	25 ff 00 00 00       	and    $0xff,%eax
 5d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5dc:	75 2c                	jne    60a <printf+0x6a>
      if(c == '%'){
 5de:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e2:	75 0c                	jne    5f0 <printf+0x50>
        state = '%';
 5e4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5eb:	e9 4b 01 00 00       	jmp    73b <printf+0x19b>
      } else {
        putc(fd, c);
 5f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	89 04 24             	mov    %eax,(%esp)
 600:	e8 be fe ff ff       	call   4c3 <putc>
 605:	e9 31 01 00 00       	jmp    73b <printf+0x19b>
      }
    } else if(state == '%'){
 60a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 60e:	0f 85 27 01 00 00    	jne    73b <printf+0x19b>
      if(c == 'd'){
 614:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 618:	75 2d                	jne    647 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 61a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 626:	00 
 627:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 62e:	00 
 62f:	89 44 24 04          	mov    %eax,0x4(%esp)
 633:	8b 45 08             	mov    0x8(%ebp),%eax
 636:	89 04 24             	mov    %eax,(%esp)
 639:	e8 ad fe ff ff       	call   4eb <printint>
        ap++;
 63e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 642:	e9 ed 00 00 00       	jmp    734 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 647:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 64b:	74 06                	je     653 <printf+0xb3>
 64d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 651:	75 2d                	jne    680 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 653:	8b 45 e8             	mov    -0x18(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 65f:	00 
 660:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 667:	00 
 668:	89 44 24 04          	mov    %eax,0x4(%esp)
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	89 04 24             	mov    %eax,(%esp)
 672:	e8 74 fe ff ff       	call   4eb <printint>
        ap++;
 677:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67b:	e9 b4 00 00 00       	jmp    734 <printf+0x194>
      } else if(c == 's'){
 680:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 684:	75 46                	jne    6cc <printf+0x12c>
        s = (char*)*ap;
 686:	8b 45 e8             	mov    -0x18(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 68e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 696:	75 27                	jne    6bf <printf+0x11f>
          s = "(null)";
 698:	c7 45 f4 90 09 00 00 	movl   $0x990,-0xc(%ebp)
        while(*s != 0){
 69f:	eb 1e                	jmp    6bf <printf+0x11f>
          putc(fd, *s);
 6a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a4:	0f b6 00             	movzbl (%eax),%eax
 6a7:	0f be c0             	movsbl %al,%eax
 6aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ae:	8b 45 08             	mov    0x8(%ebp),%eax
 6b1:	89 04 24             	mov    %eax,(%esp)
 6b4:	e8 0a fe ff ff       	call   4c3 <putc>
          s++;
 6b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 6bd:	eb 01                	jmp    6c0 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6bf:	90                   	nop
 6c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c3:	0f b6 00             	movzbl (%eax),%eax
 6c6:	84 c0                	test   %al,%al
 6c8:	75 d7                	jne    6a1 <printf+0x101>
 6ca:	eb 68                	jmp    734 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d0:	75 1d                	jne    6ef <printf+0x14f>
        putc(fd, *ap);
 6d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d5:	8b 00                	mov    (%eax),%eax
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	89 44 24 04          	mov    %eax,0x4(%esp)
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	89 04 24             	mov    %eax,(%esp)
 6e4:	e8 da fd ff ff       	call   4c3 <putc>
        ap++;
 6e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ed:	eb 45                	jmp    734 <printf+0x194>
      } else if(c == '%'){
 6ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f3:	75 17                	jne    70c <printf+0x16c>
        putc(fd, c);
 6f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f8:	0f be c0             	movsbl %al,%eax
 6fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ff:	8b 45 08             	mov    0x8(%ebp),%eax
 702:	89 04 24             	mov    %eax,(%esp)
 705:	e8 b9 fd ff ff       	call   4c3 <putc>
 70a:	eb 28                	jmp    734 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 713:	00 
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	89 04 24             	mov    %eax,(%esp)
 71a:	e8 a4 fd ff ff       	call   4c3 <putc>
        putc(fd, c);
 71f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 722:	0f be c0             	movsbl %al,%eax
 725:	89 44 24 04          	mov    %eax,0x4(%esp)
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	89 04 24             	mov    %eax,(%esp)
 72f:	e8 8f fd ff ff       	call   4c3 <putc>
      }
      state = 0;
 734:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 73b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 73f:	8b 55 0c             	mov    0xc(%ebp),%edx
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	01 d0                	add    %edx,%eax
 747:	0f b6 00             	movzbl (%eax),%eax
 74a:	84 c0                	test   %al,%al
 74c:	0f 85 70 fe ff ff    	jne    5c2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 752:	c9                   	leave  
 753:	c3                   	ret    

00000754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	83 e8 08             	sub    $0x8,%eax
 760:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 763:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 768:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76b:	eb 24                	jmp    791 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 00                	mov    (%eax),%eax
 772:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 775:	77 12                	ja     789 <free+0x35>
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77d:	77 24                	ja     7a3 <free+0x4f>
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 787:	77 1a                	ja     7a3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 791:	8b 45 f8             	mov    -0x8(%ebp),%eax
 794:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 797:	76 d4                	jbe    76d <free+0x19>
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a1:	76 ca                	jbe    76d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	01 c2                	add    %eax,%edx
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8b 00                	mov    (%eax),%eax
 7ba:	39 c2                	cmp    %eax,%edx
 7bc:	75 24                	jne    7e2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	8b 50 04             	mov    0x4(%eax),%edx
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	01 c2                	add    %eax,%edx
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	89 10                	mov    %edx,(%eax)
 7e0:	eb 0a                	jmp    7ec <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 10                	mov    (%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	01 d0                	add    %edx,%eax
 7fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 801:	75 20                	jne    823 <free+0xcf>
    p->s.size += bp->s.size;
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	8b 50 04             	mov    0x4(%eax),%edx
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	8b 40 04             	mov    0x4(%eax),%eax
 80f:	01 c2                	add    %eax,%edx
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	8b 10                	mov    (%eax),%edx
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81f:	89 10                	mov    %edx,(%eax)
 821:	eb 08                	jmp    82b <free+0xd7>
  } else
    p->s.ptr = bp;
 823:	8b 45 fc             	mov    -0x4(%ebp),%eax
 826:	8b 55 f8             	mov    -0x8(%ebp),%edx
 829:	89 10                	mov    %edx,(%eax)
  freep = p;
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	a3 f0 0b 00 00       	mov    %eax,0xbf0
}
 833:	c9                   	leave  
 834:	c3                   	ret    

00000835 <morecore>:

static Header*
morecore(uint nu)
{
 835:	55                   	push   %ebp
 836:	89 e5                	mov    %esp,%ebp
 838:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 83b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 842:	77 07                	ja     84b <morecore+0x16>
    nu = 4096;
 844:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 84b:	8b 45 08             	mov    0x8(%ebp),%eax
 84e:	c1 e0 03             	shl    $0x3,%eax
 851:	89 04 24             	mov    %eax,(%esp)
 854:	e8 4a fc ff ff       	call   4a3 <sbrk>
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 85c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 860:	75 07                	jne    869 <morecore+0x34>
    return 0;
 862:	b8 00 00 00 00       	mov    $0x0,%eax
 867:	eb 22                	jmp    88b <morecore+0x56>
  hp = (Header*)p;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 872:	8b 55 08             	mov    0x8(%ebp),%edx
 875:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	83 c0 08             	add    $0x8,%eax
 87e:	89 04 24             	mov    %eax,(%esp)
 881:	e8 ce fe ff ff       	call   754 <free>
  return freep;
 886:	a1 f0 0b 00 00       	mov    0xbf0,%eax
}
 88b:	c9                   	leave  
 88c:	c3                   	ret    

0000088d <malloc>:

void*
malloc(uint nbytes)
{
 88d:	55                   	push   %ebp
 88e:	89 e5                	mov    %esp,%ebp
 890:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 893:	8b 45 08             	mov    0x8(%ebp),%eax
 896:	83 c0 07             	add    $0x7,%eax
 899:	c1 e8 03             	shr    $0x3,%eax
 89c:	83 c0 01             	add    $0x1,%eax
 89f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a2:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 8a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ae:	75 23                	jne    8d3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b0:	c7 45 f0 e8 0b 00 00 	movl   $0xbe8,-0x10(%ebp)
 8b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ba:	a3 f0 0b 00 00       	mov    %eax,0xbf0
 8bf:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 8c4:	a3 e8 0b 00 00       	mov    %eax,0xbe8
    base.s.size = 0;
 8c9:	c7 05 ec 0b 00 00 00 	movl   $0x0,0xbec
 8d0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d6:	8b 00                	mov    (%eax),%eax
 8d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	8b 40 04             	mov    0x4(%eax),%eax
 8e1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e4:	72 4d                	jb     933 <malloc+0xa6>
      if(p->s.size == nunits)
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	8b 40 04             	mov    0x4(%eax),%eax
 8ec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ef:	75 0c                	jne    8fd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	8b 10                	mov    (%eax),%edx
 8f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f9:	89 10                	mov    %edx,(%eax)
 8fb:	eb 26                	jmp    923 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 40 04             	mov    0x4(%eax),%eax
 903:	89 c2                	mov    %eax,%edx
 905:	2b 55 ec             	sub    -0x14(%ebp),%edx
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	8b 40 04             	mov    0x4(%eax),%eax
 914:	c1 e0 03             	shl    $0x3,%eax
 917:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 920:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 923:	8b 45 f0             	mov    -0x10(%ebp),%eax
 926:	a3 f0 0b 00 00       	mov    %eax,0xbf0
      return (void*)(p + 1);
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	83 c0 08             	add    $0x8,%eax
 931:	eb 38                	jmp    96b <malloc+0xde>
    }
    if(p == freep)
 933:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 938:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 93b:	75 1b                	jne    958 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 93d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 940:	89 04 24             	mov    %eax,(%esp)
 943:	e8 ed fe ff ff       	call   835 <morecore>
 948:	89 45 f4             	mov    %eax,-0xc(%ebp)
 94b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94f:	75 07                	jne    958 <malloc+0xcb>
        return 0;
 951:	b8 00 00 00 00       	mov    $0x0,%eax
 956:	eb 13                	jmp    96b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 958:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	8b 00                	mov    (%eax),%eax
 963:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 966:	e9 70 ff ff ff       	jmp    8db <malloc+0x4e>
}
 96b:	c9                   	leave  
 96c:	c3                   	ret    
