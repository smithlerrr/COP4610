
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 d0 08 00 00 	movl   $0x8d0,(%esp)
  18:	e8 9e 03 00 00       	call   3bb <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 d0 08 00 00 	movl   $0x8d0,(%esp)
  38:	e8 86 03 00 00       	call   3c3 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 d0 08 00 00 	movl   $0x8d0,(%esp)
  4c:	e8 6a 03 00 00       	call   3bb <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 96 03 00 00       	call   3f3 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 8a 03 00 00       	call   3f3 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 d8 08 00 	movl   $0x8d8,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 80 04 00 00       	call   500 <printf>
    pid = fork();
  80:	e8 ee 02 00 00       	call   373 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 eb 08 00 	movl   $0x8eb,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 5c 04 00 00       	call   500 <printf>
      exit();
  a4:	e8 d2 02 00 00       	call   37b <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 60 0b 00 	movl   $0xb60,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 cd 08 00 00 	movl   $0x8cd,(%esp)
  bf:	e8 ef 02 00 00       	call   3b3 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 fe 08 00 	movl   $0x8fe,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 28 04 00 00       	call   500 <printf>
      exit();
  d8:	e8 9e 02 00 00       	call   37b <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 14 09 00 	movl   $0x914,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 0f 04 00 00       	call   500 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f1:	e8 8d 02 00 00       	call   383 <wait>
  f6:	89 44 24 18          	mov    %eax,0x18(%esp)
  fa:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ff:	0f 88 66 ff ff ff    	js     6b <main+0x6b>
 105:	8b 44 24 18          	mov    0x18(%esp),%eax
 109:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 10d:	75 ce                	jne    dd <main+0xdd>
      printf(1, "zombie!\n");
  }
 10f:	e9 57 ff ff ff       	jmp    6b <main+0x6b>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	90                   	nop
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	0f b6 10             	movzbl (%eax),%edx
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	88 10                	mov    %dl,(%eax)
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	84 c0                	test   %al,%al
 159:	0f 95 c0             	setne  %al
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 164:	84 c0                	test   %al,%al
 166:	75 de                	jne    146 <strcpy+0xd>
    ;
  return os;
 168:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16b:	c9                   	leave  
 16c:	c3                   	ret    

0000016d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16d:	55                   	push   %ebp
 16e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 170:	eb 08                	jmp    17a <strcmp+0xd>
    p++, q++;
 172:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 176:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 00             	movzbl (%eax),%eax
 180:	84 c0                	test   %al,%al
 182:	74 10                	je     194 <strcmp+0x27>
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	0f b6 10             	movzbl (%eax),%edx
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	38 c2                	cmp    %al,%dl
 192:	74 de                	je     172 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	0f b6 d0             	movzbl %al,%edx
 19d:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	0f b6 c0             	movzbl %al,%eax
 1a6:	89 d1                	mov    %edx,%ecx
 1a8:	29 c1                	sub    %eax,%ecx
 1aa:	89 c8                	mov    %ecx,%eax
}
 1ac:	5d                   	pop    %ebp
 1ad:	c3                   	ret    

000001ae <strlen>:

uint
strlen(char *s)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1bb:	eb 04                	jmp    1c1 <strlen+0x13>
 1bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	01 d0                	add    %edx,%eax
 1c9:	0f b6 00             	movzbl (%eax),%eax
 1cc:	84 c0                	test   %al,%al
 1ce:	75 ed                	jne    1bd <strlen+0xf>
    ;
  return n;
 1d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d3:	c9                   	leave  
 1d4:	c3                   	ret    

000001d5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1db:	8b 45 10             	mov    0x10(%ebp),%eax
 1de:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 20 ff ff ff       	call   114 <stosb>
  return dst;
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <strchr>:

char*
strchr(const char *s, char c)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 04             	sub    $0x4,%esp
 1ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 202:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 205:	eb 14                	jmp    21b <strchr+0x22>
    if(*s == c)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 210:	75 05                	jne    217 <strchr+0x1e>
      return (char*)s;
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	eb 13                	jmp    22a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 217:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	0f b6 00             	movzbl (%eax),%eax
 221:	84 c0                	test   %al,%al
 223:	75 e2                	jne    207 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 225:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22a:	c9                   	leave  
 22b:	c3                   	ret    

0000022c <gets>:

char*
gets(char *buf, int max)
{
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 232:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 239:	eb 46                	jmp    281 <gets+0x55>
    cc = read(0, &c, 1);
 23b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 242:	00 
 243:	8d 45 ef             	lea    -0x11(%ebp),%eax
 246:	89 44 24 04          	mov    %eax,0x4(%esp)
 24a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 251:	e8 3d 01 00 00       	call   393 <read>
 256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25d:	7e 2f                	jle    28e <gets+0x62>
      break;
    buf[i++] = c;
 25f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	01 c2                	add    %eax,%edx
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	88 02                	mov    %al,(%edx)
 26d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 271:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 275:	3c 0a                	cmp    $0xa,%al
 277:	74 16                	je     28f <gets+0x63>
 279:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27d:	3c 0d                	cmp    $0xd,%al
 27f:	74 0e                	je     28f <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 281:	8b 45 f4             	mov    -0xc(%ebp),%eax
 284:	83 c0 01             	add    $0x1,%eax
 287:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28a:	7c af                	jl     23b <gets+0xf>
 28c:	eb 01                	jmp    28f <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	01 d0                	add    %edx,%eax
 297:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <stat>:

int
stat(char *n, struct stat *st)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2ac:	00 
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	89 04 24             	mov    %eax,(%esp)
 2b3:	e8 03 01 00 00       	call   3bb <open>
 2b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2bf:	79 07                	jns    2c8 <stat+0x29>
    return -1;
 2c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c6:	eb 23                	jmp    2eb <stat+0x4c>
  r = fstat(fd, st);
 2c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 f9 00 00 00       	call   3d3 <fstat>
 2da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e0:	89 04 24             	mov    %eax,(%esp)
 2e3:	e8 bb 00 00 00       	call   3a3 <close>
  return r;
 2e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <atoi>:

int
atoi(const char *s)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fa:	eb 23                	jmp    31f <atoi+0x32>
    n = n*10 + *s++ - '0';
 2fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ff:	89 d0                	mov    %edx,%eax
 301:	c1 e0 02             	shl    $0x2,%eax
 304:	01 d0                	add    %edx,%eax
 306:	01 c0                	add    %eax,%eax
 308:	89 c2                	mov    %eax,%edx
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	0f b6 00             	movzbl (%eax),%eax
 310:	0f be c0             	movsbl %al,%eax
 313:	01 d0                	add    %edx,%eax
 315:	83 e8 30             	sub    $0x30,%eax
 318:	89 45 fc             	mov    %eax,-0x4(%ebp)
 31b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	3c 2f                	cmp    $0x2f,%al
 327:	7e 0a                	jle    333 <atoi+0x46>
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	0f b6 00             	movzbl (%eax),%eax
 32f:	3c 39                	cmp    $0x39,%al
 331:	7e c9                	jle    2fc <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 333:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 336:	c9                   	leave  
 337:	c3                   	ret    

00000338 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 344:	8b 45 0c             	mov    0xc(%ebp),%eax
 347:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 34a:	eb 13                	jmp    35f <memmove+0x27>
    *dst++ = *src++;
 34c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34f:	0f b6 10             	movzbl (%eax),%edx
 352:	8b 45 fc             	mov    -0x4(%ebp),%eax
 355:	88 10                	mov    %dl,(%eax)
 357:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 35b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 363:	0f 9f c0             	setg   %al
 366:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 36a:	84 c0                	test   %al,%al
 36c:	75 de                	jne    34c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 371:	c9                   	leave  
 372:	c3                   	ret    

00000373 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 373:	b8 01 00 00 00       	mov    $0x1,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <exit>:
SYSCALL(exit)
 37b:	b8 02 00 00 00       	mov    $0x2,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <wait>:
SYSCALL(wait)
 383:	b8 03 00 00 00       	mov    $0x3,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <pipe>:
SYSCALL(pipe)
 38b:	b8 04 00 00 00       	mov    $0x4,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <read>:
SYSCALL(read)
 393:	b8 05 00 00 00       	mov    $0x5,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <write>:
SYSCALL(write)
 39b:	b8 10 00 00 00       	mov    $0x10,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <close>:
SYSCALL(close)
 3a3:	b8 15 00 00 00       	mov    $0x15,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <kill>:
SYSCALL(kill)
 3ab:	b8 06 00 00 00       	mov    $0x6,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <exec>:
SYSCALL(exec)
 3b3:	b8 07 00 00 00       	mov    $0x7,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <open>:
SYSCALL(open)
 3bb:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <mknod>:
SYSCALL(mknod)
 3c3:	b8 11 00 00 00       	mov    $0x11,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <unlink>:
SYSCALL(unlink)
 3cb:	b8 12 00 00 00       	mov    $0x12,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <fstat>:
SYSCALL(fstat)
 3d3:	b8 08 00 00 00       	mov    $0x8,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <link>:
SYSCALL(link)
 3db:	b8 13 00 00 00       	mov    $0x13,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <mkdir>:
SYSCALL(mkdir)
 3e3:	b8 14 00 00 00       	mov    $0x14,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <chdir>:
SYSCALL(chdir)
 3eb:	b8 09 00 00 00       	mov    $0x9,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <dup>:
SYSCALL(dup)
 3f3:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <getpid>:
SYSCALL(getpid)
 3fb:	b8 0b 00 00 00       	mov    $0xb,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <sbrk>:
SYSCALL(sbrk)
 403:	b8 0c 00 00 00       	mov    $0xc,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <sleep>:
SYSCALL(sleep)
 40b:	b8 0d 00 00 00       	mov    $0xd,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <uptime>:
SYSCALL(uptime)
 413:	b8 0e 00 00 00       	mov    $0xe,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <getprocs>:
SYSCALL(getprocs)
 41b:	b8 16 00 00 00       	mov    $0x16,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 423:	55                   	push   %ebp
 424:	89 e5                	mov    %esp,%ebp
 426:	83 ec 28             	sub    $0x28,%esp
 429:	8b 45 0c             	mov    0xc(%ebp),%eax
 42c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 42f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 436:	00 
 437:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43a:	89 44 24 04          	mov    %eax,0x4(%esp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	89 04 24             	mov    %eax,(%esp)
 444:	e8 52 ff ff ff       	call   39b <write>
}
 449:	c9                   	leave  
 44a:	c3                   	ret    

0000044b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44b:	55                   	push   %ebp
 44c:	89 e5                	mov    %esp,%ebp
 44e:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 451:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 458:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45c:	74 17                	je     475 <printint+0x2a>
 45e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 462:	79 11                	jns    475 <printint+0x2a>
    neg = 1;
 464:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46b:	8b 45 0c             	mov    0xc(%ebp),%eax
 46e:	f7 d8                	neg    %eax
 470:	89 45 ec             	mov    %eax,-0x14(%ebp)
 473:	eb 06                	jmp    47b <printint+0x30>
  } else {
    x = xx;
 475:	8b 45 0c             	mov    0xc(%ebp),%eax
 478:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 47b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 482:	8b 4d 10             	mov    0x10(%ebp),%ecx
 485:	8b 45 ec             	mov    -0x14(%ebp),%eax
 488:	ba 00 00 00 00       	mov    $0x0,%edx
 48d:	f7 f1                	div    %ecx
 48f:	89 d0                	mov    %edx,%eax
 491:	0f b6 80 68 0b 00 00 	movzbl 0xb68(%eax),%eax
 498:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 49b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 49e:	01 ca                	add    %ecx,%edx
 4a0:	88 02                	mov    %al,(%edx)
 4a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 4a6:	8b 55 10             	mov    0x10(%ebp),%edx
 4a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4af:	ba 00 00 00 00       	mov    $0x0,%edx
 4b4:	f7 75 d4             	divl   -0x2c(%ebp)
 4b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4be:	75 c2                	jne    482 <printint+0x37>
  if(neg)
 4c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c4:	74 2e                	je     4f4 <printint+0xa9>
    buf[i++] = '-';
 4c6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	c6 00 2d             	movb   $0x2d,(%eax)
 4d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 4d5:	eb 1d                	jmp    4f4 <printint+0xa9>
    putc(fd, buf[i]);
 4d7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4dd:	01 d0                	add    %edx,%eax
 4df:	0f b6 00             	movzbl (%eax),%eax
 4e2:	0f be c0             	movsbl %al,%eax
 4e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ec:	89 04 24             	mov    %eax,(%esp)
 4ef:	e8 2f ff ff ff       	call   423 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fc:	79 d9                	jns    4d7 <printint+0x8c>
    putc(fd, buf[i]);
}
 4fe:	c9                   	leave  
 4ff:	c3                   	ret    

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 506:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 50d:	8d 45 0c             	lea    0xc(%ebp),%eax
 510:	83 c0 04             	add    $0x4,%eax
 513:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 516:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 51d:	e9 7d 01 00 00       	jmp    69f <printf+0x19f>
    c = fmt[i] & 0xff;
 522:	8b 55 0c             	mov    0xc(%ebp),%edx
 525:	8b 45 f0             	mov    -0x10(%ebp),%eax
 528:	01 d0                	add    %edx,%eax
 52a:	0f b6 00             	movzbl (%eax),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	25 ff 00 00 00       	and    $0xff,%eax
 535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 538:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53c:	75 2c                	jne    56a <printf+0x6a>
      if(c == '%'){
 53e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 542:	75 0c                	jne    550 <printf+0x50>
        state = '%';
 544:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 54b:	e9 4b 01 00 00       	jmp    69b <printf+0x19b>
      } else {
        putc(fd, c);
 550:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 553:	0f be c0             	movsbl %al,%eax
 556:	89 44 24 04          	mov    %eax,0x4(%esp)
 55a:	8b 45 08             	mov    0x8(%ebp),%eax
 55d:	89 04 24             	mov    %eax,(%esp)
 560:	e8 be fe ff ff       	call   423 <putc>
 565:	e9 31 01 00 00       	jmp    69b <printf+0x19b>
      }
    } else if(state == '%'){
 56a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 56e:	0f 85 27 01 00 00    	jne    69b <printf+0x19b>
      if(c == 'd'){
 574:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 578:	75 2d                	jne    5a7 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 57a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57d:	8b 00                	mov    (%eax),%eax
 57f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 586:	00 
 587:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 58e:	00 
 58f:	89 44 24 04          	mov    %eax,0x4(%esp)
 593:	8b 45 08             	mov    0x8(%ebp),%eax
 596:	89 04 24             	mov    %eax,(%esp)
 599:	e8 ad fe ff ff       	call   44b <printint>
        ap++;
 59e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a2:	e9 ed 00 00 00       	jmp    694 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 5a7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ab:	74 06                	je     5b3 <printf+0xb3>
 5ad:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5b1:	75 2d                	jne    5e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b6:	8b 00                	mov    (%eax),%eax
 5b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5bf:	00 
 5c0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5c7:	00 
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 74 fe ff ff       	call   44b <printint>
        ap++;
 5d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5db:	e9 b4 00 00 00       	jmp    694 <printf+0x194>
      } else if(c == 's'){
 5e0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e4:	75 46                	jne    62c <printf+0x12c>
        s = (char*)*ap;
 5e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f6:	75 27                	jne    61f <printf+0x11f>
          s = "(null)";
 5f8:	c7 45 f4 1d 09 00 00 	movl   $0x91d,-0xc(%ebp)
        while(*s != 0){
 5ff:	eb 1e                	jmp    61f <printf+0x11f>
          putc(fd, *s);
 601:	8b 45 f4             	mov    -0xc(%ebp),%eax
 604:	0f b6 00             	movzbl (%eax),%eax
 607:	0f be c0             	movsbl %al,%eax
 60a:	89 44 24 04          	mov    %eax,0x4(%esp)
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	89 04 24             	mov    %eax,(%esp)
 614:	e8 0a fe ff ff       	call   423 <putc>
          s++;
 619:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 61d:	eb 01                	jmp    620 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 61f:	90                   	nop
 620:	8b 45 f4             	mov    -0xc(%ebp),%eax
 623:	0f b6 00             	movzbl (%eax),%eax
 626:	84 c0                	test   %al,%al
 628:	75 d7                	jne    601 <printf+0x101>
 62a:	eb 68                	jmp    694 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 630:	75 1d                	jne    64f <printf+0x14f>
        putc(fd, *ap);
 632:	8b 45 e8             	mov    -0x18(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	0f be c0             	movsbl %al,%eax
 63a:	89 44 24 04          	mov    %eax,0x4(%esp)
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	89 04 24             	mov    %eax,(%esp)
 644:	e8 da fd ff ff       	call   423 <putc>
        ap++;
 649:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64d:	eb 45                	jmp    694 <printf+0x194>
      } else if(c == '%'){
 64f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 653:	75 17                	jne    66c <printf+0x16c>
        putc(fd, c);
 655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 658:	0f be c0             	movsbl %al,%eax
 65b:	89 44 24 04          	mov    %eax,0x4(%esp)
 65f:	8b 45 08             	mov    0x8(%ebp),%eax
 662:	89 04 24             	mov    %eax,(%esp)
 665:	e8 b9 fd ff ff       	call   423 <putc>
 66a:	eb 28                	jmp    694 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 673:	00 
 674:	8b 45 08             	mov    0x8(%ebp),%eax
 677:	89 04 24             	mov    %eax,(%esp)
 67a:	e8 a4 fd ff ff       	call   423 <putc>
        putc(fd, c);
 67f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 682:	0f be c0             	movsbl %al,%eax
 685:	89 44 24 04          	mov    %eax,0x4(%esp)
 689:	8b 45 08             	mov    0x8(%ebp),%eax
 68c:	89 04 24             	mov    %eax,(%esp)
 68f:	e8 8f fd ff ff       	call   423 <putc>
      }
      state = 0;
 694:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 69f:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a5:	01 d0                	add    %edx,%eax
 6a7:	0f b6 00             	movzbl (%eax),%eax
 6aa:	84 c0                	test   %al,%al
 6ac:	0f 85 70 fe ff ff    	jne    522 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b2:	c9                   	leave  
 6b3:	c3                   	ret    

000006b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b4:	55                   	push   %ebp
 6b5:	89 e5                	mov    %esp,%ebp
 6b7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	83 e8 08             	sub    $0x8,%eax
 6c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c3:	a1 84 0b 00 00       	mov    0xb84,%eax
 6c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cb:	eb 24                	jmp    6f1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d5:	77 12                	ja     6e9 <free+0x35>
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6dd:	77 24                	ja     703 <free+0x4f>
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	8b 00                	mov    (%eax),%eax
 6e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e7:	77 1a                	ja     703 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f7:	76 d4                	jbe    6cd <free+0x19>
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 701:	76 ca                	jbe    6cd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	8b 40 04             	mov    0x4(%eax),%eax
 709:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	01 c2                	add    %eax,%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	39 c2                	cmp    %eax,%edx
 71c:	75 24                	jne    742 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	8b 50 04             	mov    0x4(%eax),%edx
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	8b 40 04             	mov    0x4(%eax),%eax
 72c:	01 c2                	add    %eax,%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
 740:	eb 0a                	jmp    74c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 10                	mov    (%eax),%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 40 04             	mov    0x4(%eax),%eax
 752:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	01 d0                	add    %edx,%eax
 75e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 761:	75 20                	jne    783 <free+0xcf>
    p->s.size += bp->s.size;
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 50 04             	mov    0x4(%eax),%edx
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	01 c2                	add    %eax,%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	8b 10                	mov    (%eax),%edx
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	89 10                	mov    %edx,(%eax)
 781:	eb 08                	jmp    78b <free+0xd7>
  } else
    p->s.ptr = bp;
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 55 f8             	mov    -0x8(%ebp),%edx
 789:	89 10                	mov    %edx,(%eax)
  freep = p;
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	a3 84 0b 00 00       	mov    %eax,0xb84
}
 793:	c9                   	leave  
 794:	c3                   	ret    

00000795 <morecore>:

static Header*
morecore(uint nu)
{
 795:	55                   	push   %ebp
 796:	89 e5                	mov    %esp,%ebp
 798:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a2:	77 07                	ja     7ab <morecore+0x16>
    nu = 4096;
 7a4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
 7ae:	c1 e0 03             	shl    $0x3,%eax
 7b1:	89 04 24             	mov    %eax,(%esp)
 7b4:	e8 4a fc ff ff       	call   403 <sbrk>
 7b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7bc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c0:	75 07                	jne    7c9 <morecore+0x34>
    return 0;
 7c2:	b8 00 00 00 00       	mov    $0x0,%eax
 7c7:	eb 22                	jmp    7eb <morecore+0x56>
  hp = (Header*)p;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d2:	8b 55 08             	mov    0x8(%ebp),%edx
 7d5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7db:	83 c0 08             	add    $0x8,%eax
 7de:	89 04 24             	mov    %eax,(%esp)
 7e1:	e8 ce fe ff ff       	call   6b4 <free>
  return freep;
 7e6:	a1 84 0b 00 00       	mov    0xb84,%eax
}
 7eb:	c9                   	leave  
 7ec:	c3                   	ret    

000007ed <malloc>:

void*
malloc(uint nbytes)
{
 7ed:	55                   	push   %ebp
 7ee:	89 e5                	mov    %esp,%ebp
 7f0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f3:	8b 45 08             	mov    0x8(%ebp),%eax
 7f6:	83 c0 07             	add    $0x7,%eax
 7f9:	c1 e8 03             	shr    $0x3,%eax
 7fc:	83 c0 01             	add    $0x1,%eax
 7ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 802:	a1 84 0b 00 00       	mov    0xb84,%eax
 807:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 80e:	75 23                	jne    833 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 810:	c7 45 f0 7c 0b 00 00 	movl   $0xb7c,-0x10(%ebp)
 817:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81a:	a3 84 0b 00 00       	mov    %eax,0xb84
 81f:	a1 84 0b 00 00       	mov    0xb84,%eax
 824:	a3 7c 0b 00 00       	mov    %eax,0xb7c
    base.s.size = 0;
 829:	c7 05 80 0b 00 00 00 	movl   $0x0,0xb80
 830:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	8b 00                	mov    (%eax),%eax
 838:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	8b 40 04             	mov    0x4(%eax),%eax
 841:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 844:	72 4d                	jb     893 <malloc+0xa6>
      if(p->s.size == nunits)
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 40 04             	mov    0x4(%eax),%eax
 84c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84f:	75 0c                	jne    85d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	8b 10                	mov    (%eax),%edx
 856:	8b 45 f0             	mov    -0x10(%ebp),%eax
 859:	89 10                	mov    %edx,(%eax)
 85b:	eb 26                	jmp    883 <malloc+0x96>
      else {
        p->s.size -= nunits;
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 40 04             	mov    0x4(%eax),%eax
 863:	89 c2                	mov    %eax,%edx
 865:	2b 55 ec             	sub    -0x14(%ebp),%edx
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	8b 40 04             	mov    0x4(%eax),%eax
 874:	c1 e0 03             	shl    $0x3,%eax
 877:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 880:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 883:	8b 45 f0             	mov    -0x10(%ebp),%eax
 886:	a3 84 0b 00 00       	mov    %eax,0xb84
      return (void*)(p + 1);
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	83 c0 08             	add    $0x8,%eax
 891:	eb 38                	jmp    8cb <malloc+0xde>
    }
    if(p == freep)
 893:	a1 84 0b 00 00       	mov    0xb84,%eax
 898:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 89b:	75 1b                	jne    8b8 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 89d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a0:	89 04 24             	mov    %eax,(%esp)
 8a3:	e8 ed fe ff ff       	call   795 <morecore>
 8a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8af:	75 07                	jne    8b8 <malloc+0xcb>
        return 0;
 8b1:	b8 00 00 00 00       	mov    $0x0,%eax
 8b6:	eb 13                	jmp    8cb <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	8b 00                	mov    (%eax),%eax
 8c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8c6:	e9 70 ff ff ff       	jmp    83b <malloc+0x4e>
}
 8cb:	c9                   	leave  
 8cc:	c3                   	ret    
