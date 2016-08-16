
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 81 03 00 00       	call   3a4 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 5e 03 00 00       	call   39c <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 d6 08 00 	movl   $0x8d6,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 a8 04 00 00       	call   509 <printf>
    exit();
  61:	e8 1e 03 00 00       	call   384 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 fc 02 00 00       	call   384 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 79                	jmp    10b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 10 03 00 00       	call   3c4 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 e7 08 00 	movl   $0x8e7,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 20 04 00 00       	call   509 <printf>
      exit();
  e9:	e8 96 02 00 00       	call   384 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 a6 02 00 00       	call   3ac <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 10b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10f:	3b 45 08             	cmp    0x8(%ebp),%eax
 112:	0f 8c 7a ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 118:	e8 67 02 00 00       	call   384 <exit>

0000011d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 122:	8b 4d 08             	mov    0x8(%ebp),%ecx
 125:	8b 55 10             	mov    0x10(%ebp),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	89 cb                	mov    %ecx,%ebx
 12d:	89 df                	mov    %ebx,%edi
 12f:	89 d1                	mov    %edx,%ecx
 131:	fc                   	cld    
 132:	f3 aa                	rep stos %al,%es:(%edi)
 134:	89 ca                	mov    %ecx,%edx
 136:	89 fb                	mov    %edi,%ebx
 138:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13e:	5b                   	pop    %ebx
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14e:	90                   	nop
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	0f b6 10             	movzbl (%eax),%edx
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	88 10                	mov    %dl,(%eax)
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	0f b6 00             	movzbl (%eax),%eax
 160:	84 c0                	test   %al,%al
 162:	0f 95 c0             	setne  %al
 165:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 169:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 16d:	84 c0                	test   %al,%al
 16f:	75 de                	jne    14f <strcpy+0xd>
    ;
  return os;
 171:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 174:	c9                   	leave  
 175:	c3                   	ret    

00000176 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 179:	eb 08                	jmp    183 <strcmp+0xd>
    p++, q++;
 17b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	84 c0                	test   %al,%al
 18b:	74 10                	je     19d <strcmp+0x27>
 18d:	8b 45 08             	mov    0x8(%ebp),%eax
 190:	0f b6 10             	movzbl (%eax),%edx
 193:	8b 45 0c             	mov    0xc(%ebp),%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	38 c2                	cmp    %al,%dl
 19b:	74 de                	je     17b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	0f b6 d0             	movzbl %al,%edx
 1a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a9:	0f b6 00             	movzbl (%eax),%eax
 1ac:	0f b6 c0             	movzbl %al,%eax
 1af:	89 d1                	mov    %edx,%ecx
 1b1:	29 c1                	sub    %eax,%ecx
 1b3:	89 c8                	mov    %ecx,%eax
}
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    

000001b7 <strlen>:

uint
strlen(char *s)
{
 1b7:	55                   	push   %ebp
 1b8:	89 e5                	mov    %esp,%ebp
 1ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c4:	eb 04                	jmp    1ca <strlen+0x13>
 1c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	01 d0                	add    %edx,%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	84 c0                	test   %al,%al
 1d7:	75 ed                	jne    1c6 <strlen+0xf>
    ;
  return n;
 1d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1dc:	c9                   	leave  
 1dd:	c3                   	ret    

000001de <memset>:

void*
memset(void *dst, int c, uint n)
{
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1e4:	8b 45 10             	mov    0x10(%ebp),%eax
 1e7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	89 04 24             	mov    %eax,(%esp)
 1f8:	e8 20 ff ff ff       	call   11d <stosb>
  return dst;
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 200:	c9                   	leave  
 201:	c3                   	ret    

00000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 04             	sub    $0x4,%esp
 208:	8b 45 0c             	mov    0xc(%ebp),%eax
 20b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20e:	eb 14                	jmp    224 <strchr+0x22>
    if(*s == c)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	3a 45 fc             	cmp    -0x4(%ebp),%al
 219:	75 05                	jne    220 <strchr+0x1e>
      return (char*)s;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	eb 13                	jmp    233 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 220:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	84 c0                	test   %al,%al
 22c:	75 e2                	jne    210 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 22e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 233:	c9                   	leave  
 234:	c3                   	ret    

00000235 <gets>:

char*
gets(char *buf, int max)
{
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 242:	eb 46                	jmp    28a <gets+0x55>
    cc = read(0, &c, 1);
 244:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 24b:	00 
 24c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24f:	89 44 24 04          	mov    %eax,0x4(%esp)
 253:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 25a:	e8 3d 01 00 00       	call   39c <read>
 25f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 262:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 266:	7e 2f                	jle    297 <gets+0x62>
      break;
    buf[i++] = c;
 268:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	01 c2                	add    %eax,%edx
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	88 02                	mov    %al,(%edx)
 276:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 27a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27e:	3c 0a                	cmp    $0xa,%al
 280:	74 16                	je     298 <gets+0x63>
 282:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 286:	3c 0d                	cmp    $0xd,%al
 288:	74 0e                	je     298 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28d:	83 c0 01             	add    $0x1,%eax
 290:	3b 45 0c             	cmp    0xc(%ebp),%eax
 293:	7c af                	jl     244 <gets+0xf>
 295:	eb 01                	jmp    298 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 297:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 298:	8b 55 f4             	mov    -0xc(%ebp),%edx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	01 d0                	add    %edx,%eax
 2a0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a6:	c9                   	leave  
 2a7:	c3                   	ret    

000002a8 <stat>:

int
stat(char *n, struct stat *st)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b5:	00 
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	89 04 24             	mov    %eax,(%esp)
 2bc:	e8 03 01 00 00       	call   3c4 <open>
 2c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c8:	79 07                	jns    2d1 <stat+0x29>
    return -1;
 2ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cf:	eb 23                	jmp    2f4 <stat+0x4c>
  r = fstat(fd, st);
 2d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2db:	89 04 24             	mov    %eax,(%esp)
 2de:	e8 f9 00 00 00       	call   3dc <fstat>
 2e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e9:	89 04 24             	mov    %eax,(%esp)
 2ec:	e8 bb 00 00 00       	call   3ac <close>
  return r;
 2f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <atoi>:

int
atoi(const char *s)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 303:	eb 23                	jmp    328 <atoi+0x32>
    n = n*10 + *s++ - '0';
 305:	8b 55 fc             	mov    -0x4(%ebp),%edx
 308:	89 d0                	mov    %edx,%eax
 30a:	c1 e0 02             	shl    $0x2,%eax
 30d:	01 d0                	add    %edx,%eax
 30f:	01 c0                	add    %eax,%eax
 311:	89 c2                	mov    %eax,%edx
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	0f be c0             	movsbl %al,%eax
 31c:	01 d0                	add    %edx,%eax
 31e:	83 e8 30             	sub    $0x30,%eax
 321:	89 45 fc             	mov    %eax,-0x4(%ebp)
 324:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	3c 2f                	cmp    $0x2f,%al
 330:	7e 0a                	jle    33c <atoi+0x46>
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	0f b6 00             	movzbl (%eax),%eax
 338:	3c 39                	cmp    $0x39,%al
 33a:	7e c9                	jle    305 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 33c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33f:	c9                   	leave  
 340:	c3                   	ret    

00000341 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp
 344:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 34d:	8b 45 0c             	mov    0xc(%ebp),%eax
 350:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 353:	eb 13                	jmp    368 <memmove+0x27>
    *dst++ = *src++;
 355:	8b 45 f8             	mov    -0x8(%ebp),%eax
 358:	0f b6 10             	movzbl (%eax),%edx
 35b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35e:	88 10                	mov    %dl,(%eax)
 360:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 364:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 368:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 36c:	0f 9f c0             	setg   %al
 36f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 373:	84 c0                	test   %al,%al
 375:	75 de                	jne    355 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 377:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37c:	b8 01 00 00 00       	mov    $0x1,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <exit>:
SYSCALL(exit)
 384:	b8 02 00 00 00       	mov    $0x2,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <wait>:
SYSCALL(wait)
 38c:	b8 03 00 00 00       	mov    $0x3,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <pipe>:
SYSCALL(pipe)
 394:	b8 04 00 00 00       	mov    $0x4,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <read>:
SYSCALL(read)
 39c:	b8 05 00 00 00       	mov    $0x5,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <write>:
SYSCALL(write)
 3a4:	b8 10 00 00 00       	mov    $0x10,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <close>:
SYSCALL(close)
 3ac:	b8 15 00 00 00       	mov    $0x15,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <kill>:
SYSCALL(kill)
 3b4:	b8 06 00 00 00       	mov    $0x6,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <exec>:
SYSCALL(exec)
 3bc:	b8 07 00 00 00       	mov    $0x7,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <open>:
SYSCALL(open)
 3c4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <mknod>:
SYSCALL(mknod)
 3cc:	b8 11 00 00 00       	mov    $0x11,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <unlink>:
SYSCALL(unlink)
 3d4:	b8 12 00 00 00       	mov    $0x12,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <fstat>:
SYSCALL(fstat)
 3dc:	b8 08 00 00 00       	mov    $0x8,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <link>:
SYSCALL(link)
 3e4:	b8 13 00 00 00       	mov    $0x13,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <mkdir>:
SYSCALL(mkdir)
 3ec:	b8 14 00 00 00       	mov    $0x14,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <chdir>:
SYSCALL(chdir)
 3f4:	b8 09 00 00 00       	mov    $0x9,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <dup>:
SYSCALL(dup)
 3fc:	b8 0a 00 00 00       	mov    $0xa,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <getpid>:
SYSCALL(getpid)
 404:	b8 0b 00 00 00       	mov    $0xb,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sbrk>:
SYSCALL(sbrk)
 40c:	b8 0c 00 00 00       	mov    $0xc,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <sleep>:
SYSCALL(sleep)
 414:	b8 0d 00 00 00       	mov    $0xd,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <uptime>:
SYSCALL(uptime)
 41c:	b8 0e 00 00 00       	mov    $0xe,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <getprocs>:
SYSCALL(getprocs)
 424:	b8 16 00 00 00       	mov    $0x16,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 28             	sub    $0x28,%esp
 432:	8b 45 0c             	mov    0xc(%ebp),%eax
 435:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 438:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 43f:	00 
 440:	8d 45 f4             	lea    -0xc(%ebp),%eax
 443:	89 44 24 04          	mov    %eax,0x4(%esp)
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	89 04 24             	mov    %eax,(%esp)
 44d:	e8 52 ff ff ff       	call   3a4 <write>
}
 452:	c9                   	leave  
 453:	c3                   	ret    

00000454 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 45a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 461:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 465:	74 17                	je     47e <printint+0x2a>
 467:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 46b:	79 11                	jns    47e <printint+0x2a>
    neg = 1;
 46d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 474:	8b 45 0c             	mov    0xc(%ebp),%eax
 477:	f7 d8                	neg    %eax
 479:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47c:	eb 06                	jmp    484 <printint+0x30>
  } else {
    x = xx;
 47e:	8b 45 0c             	mov    0xc(%ebp),%eax
 481:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 484:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 48b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 48e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 491:	ba 00 00 00 00       	mov    $0x0,%edx
 496:	f7 f1                	div    %ecx
 498:	89 d0                	mov    %edx,%eax
 49a:	0f b6 80 60 0b 00 00 	movzbl 0xb60(%eax),%eax
 4a1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a7:	01 ca                	add    %ecx,%edx
 4a9:	88 02                	mov    %al,(%edx)
 4ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 4af:	8b 55 10             	mov    0x10(%ebp),%edx
 4b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b8:	ba 00 00 00 00       	mov    $0x0,%edx
 4bd:	f7 75 d4             	divl   -0x2c(%ebp)
 4c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c7:	75 c2                	jne    48b <printint+0x37>
  if(neg)
 4c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4cd:	74 2e                	je     4fd <printint+0xa9>
    buf[i++] = '-';
 4cf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d5:	01 d0                	add    %edx,%eax
 4d7:	c6 00 2d             	movb   $0x2d,(%eax)
 4da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 4de:	eb 1d                	jmp    4fd <printint+0xa9>
    putc(fd, buf[i]);
 4e0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e6:	01 d0                	add    %edx,%eax
 4e8:	0f b6 00             	movzbl (%eax),%eax
 4eb:	0f be c0             	movsbl %al,%eax
 4ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f2:	8b 45 08             	mov    0x8(%ebp),%eax
 4f5:	89 04 24             	mov    %eax,(%esp)
 4f8:	e8 2f ff ff ff       	call   42c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4fd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 505:	79 d9                	jns    4e0 <printint+0x8c>
    putc(fd, buf[i]);
}
 507:	c9                   	leave  
 508:	c3                   	ret    

00000509 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 50f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 516:	8d 45 0c             	lea    0xc(%ebp),%eax
 519:	83 c0 04             	add    $0x4,%eax
 51c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 51f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 526:	e9 7d 01 00 00       	jmp    6a8 <printf+0x19f>
    c = fmt[i] & 0xff;
 52b:	8b 55 0c             	mov    0xc(%ebp),%edx
 52e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 531:	01 d0                	add    %edx,%eax
 533:	0f b6 00             	movzbl (%eax),%eax
 536:	0f be c0             	movsbl %al,%eax
 539:	25 ff 00 00 00       	and    $0xff,%eax
 53e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 541:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 545:	75 2c                	jne    573 <printf+0x6a>
      if(c == '%'){
 547:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 54b:	75 0c                	jne    559 <printf+0x50>
        state = '%';
 54d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 554:	e9 4b 01 00 00       	jmp    6a4 <printf+0x19b>
      } else {
        putc(fd, c);
 559:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	89 44 24 04          	mov    %eax,0x4(%esp)
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	89 04 24             	mov    %eax,(%esp)
 569:	e8 be fe ff ff       	call   42c <putc>
 56e:	e9 31 01 00 00       	jmp    6a4 <printf+0x19b>
      }
    } else if(state == '%'){
 573:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 577:	0f 85 27 01 00 00    	jne    6a4 <printf+0x19b>
      if(c == 'd'){
 57d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 581:	75 2d                	jne    5b0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 583:	8b 45 e8             	mov    -0x18(%ebp),%eax
 586:	8b 00                	mov    (%eax),%eax
 588:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 58f:	00 
 590:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 597:	00 
 598:	89 44 24 04          	mov    %eax,0x4(%esp)
 59c:	8b 45 08             	mov    0x8(%ebp),%eax
 59f:	89 04 24             	mov    %eax,(%esp)
 5a2:	e8 ad fe ff ff       	call   454 <printint>
        ap++;
 5a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ab:	e9 ed 00 00 00       	jmp    69d <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 5b0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b4:	74 06                	je     5bc <printf+0xb3>
 5b6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ba:	75 2d                	jne    5e9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bf:	8b 00                	mov    (%eax),%eax
 5c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5c8:	00 
 5c9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5d0:	00 
 5d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	89 04 24             	mov    %eax,(%esp)
 5db:	e8 74 fe ff ff       	call   454 <printint>
        ap++;
 5e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e4:	e9 b4 00 00 00       	jmp    69d <printf+0x194>
      } else if(c == 's'){
 5e9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ed:	75 46                	jne    635 <printf+0x12c>
        s = (char*)*ap;
 5ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ff:	75 27                	jne    628 <printf+0x11f>
          s = "(null)";
 601:	c7 45 f4 fc 08 00 00 	movl   $0x8fc,-0xc(%ebp)
        while(*s != 0){
 608:	eb 1e                	jmp    628 <printf+0x11f>
          putc(fd, *s);
 60a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60d:	0f b6 00             	movzbl (%eax),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	89 44 24 04          	mov    %eax,0x4(%esp)
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	89 04 24             	mov    %eax,(%esp)
 61d:	e8 0a fe ff ff       	call   42c <putc>
          s++;
 622:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 626:	eb 01                	jmp    629 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 628:	90                   	nop
 629:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62c:	0f b6 00             	movzbl (%eax),%eax
 62f:	84 c0                	test   %al,%al
 631:	75 d7                	jne    60a <printf+0x101>
 633:	eb 68                	jmp    69d <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 635:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 639:	75 1d                	jne    658 <printf+0x14f>
        putc(fd, *ap);
 63b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	0f be c0             	movsbl %al,%eax
 643:	89 44 24 04          	mov    %eax,0x4(%esp)
 647:	8b 45 08             	mov    0x8(%ebp),%eax
 64a:	89 04 24             	mov    %eax,(%esp)
 64d:	e8 da fd ff ff       	call   42c <putc>
        ap++;
 652:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 656:	eb 45                	jmp    69d <printf+0x194>
      } else if(c == '%'){
 658:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 65c:	75 17                	jne    675 <printf+0x16c>
        putc(fd, c);
 65e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	89 44 24 04          	mov    %eax,0x4(%esp)
 668:	8b 45 08             	mov    0x8(%ebp),%eax
 66b:	89 04 24             	mov    %eax,(%esp)
 66e:	e8 b9 fd ff ff       	call   42c <putc>
 673:	eb 28                	jmp    69d <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 675:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 67c:	00 
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 a4 fd ff ff       	call   42c <putc>
        putc(fd, c);
 688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68b:	0f be c0             	movsbl %al,%eax
 68e:	89 44 24 04          	mov    %eax,0x4(%esp)
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	89 04 24             	mov    %eax,(%esp)
 698:	e8 8f fd ff ff       	call   42c <putc>
      }
      state = 0;
 69d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ae:	01 d0                	add    %edx,%eax
 6b0:	0f b6 00             	movzbl (%eax),%eax
 6b3:	84 c0                	test   %al,%al
 6b5:	0f 85 70 fe ff ff    	jne    52b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6bb:	c9                   	leave  
 6bc:	c3                   	ret    

000006bd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6bd:	55                   	push   %ebp
 6be:	89 e5                	mov    %esp,%ebp
 6c0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c3:	8b 45 08             	mov    0x8(%ebp),%eax
 6c6:	83 e8 08             	sub    $0x8,%eax
 6c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cc:	a1 88 0b 00 00       	mov    0xb88,%eax
 6d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d4:	eb 24                	jmp    6fa <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6de:	77 12                	ja     6f2 <free+0x35>
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e6:	77 24                	ja     70c <free+0x4f>
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f0:	77 1a                	ja     70c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 00                	mov    (%eax),%eax
 6f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 700:	76 d4                	jbe    6d6 <free+0x19>
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70a:	76 ca                	jbe    6d6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	8b 40 04             	mov    0x4(%eax),%eax
 712:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	01 c2                	add    %eax,%edx
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	39 c2                	cmp    %eax,%edx
 725:	75 24                	jne    74b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	8b 50 04             	mov    0x4(%eax),%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	8b 40 04             	mov    0x4(%eax),%eax
 735:	01 c2                	add    %eax,%edx
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	8b 00                	mov    (%eax),%eax
 742:	8b 10                	mov    (%eax),%edx
 744:	8b 45 f8             	mov    -0x8(%ebp),%eax
 747:	89 10                	mov    %edx,(%eax)
 749:	eb 0a                	jmp    755 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 10                	mov    (%eax),%edx
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	01 d0                	add    %edx,%eax
 767:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76a:	75 20                	jne    78c <free+0xcf>
    p->s.size += bp->s.size;
 76c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76f:	8b 50 04             	mov    0x4(%eax),%edx
 772:	8b 45 f8             	mov    -0x8(%ebp),%eax
 775:	8b 40 04             	mov    0x4(%eax),%eax
 778:	01 c2                	add    %eax,%edx
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 780:	8b 45 f8             	mov    -0x8(%ebp),%eax
 783:	8b 10                	mov    (%eax),%edx
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	89 10                	mov    %edx,(%eax)
 78a:	eb 08                	jmp    794 <free+0xd7>
  } else
    p->s.ptr = bp;
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 792:	89 10                	mov    %edx,(%eax)
  freep = p;
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 79c:	c9                   	leave  
 79d:	c3                   	ret    

0000079e <morecore>:

static Header*
morecore(uint nu)
{
 79e:	55                   	push   %ebp
 79f:	89 e5                	mov    %esp,%ebp
 7a1:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ab:	77 07                	ja     7b4 <morecore+0x16>
    nu = 4096;
 7ad:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b4:	8b 45 08             	mov    0x8(%ebp),%eax
 7b7:	c1 e0 03             	shl    $0x3,%eax
 7ba:	89 04 24             	mov    %eax,(%esp)
 7bd:	e8 4a fc ff ff       	call   40c <sbrk>
 7c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c9:	75 07                	jne    7d2 <morecore+0x34>
    return 0;
 7cb:	b8 00 00 00 00       	mov    $0x0,%eax
 7d0:	eb 22                	jmp    7f4 <morecore+0x56>
  hp = (Header*)p;
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7db:	8b 55 08             	mov    0x8(%ebp),%edx
 7de:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	83 c0 08             	add    $0x8,%eax
 7e7:	89 04 24             	mov    %eax,(%esp)
 7ea:	e8 ce fe ff ff       	call   6bd <free>
  return freep;
 7ef:	a1 88 0b 00 00       	mov    0xb88,%eax
}
 7f4:	c9                   	leave  
 7f5:	c3                   	ret    

000007f6 <malloc>:

void*
malloc(uint nbytes)
{
 7f6:	55                   	push   %ebp
 7f7:	89 e5                	mov    %esp,%ebp
 7f9:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fc:	8b 45 08             	mov    0x8(%ebp),%eax
 7ff:	83 c0 07             	add    $0x7,%eax
 802:	c1 e8 03             	shr    $0x3,%eax
 805:	83 c0 01             	add    $0x1,%eax
 808:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 80b:	a1 88 0b 00 00       	mov    0xb88,%eax
 810:	89 45 f0             	mov    %eax,-0x10(%ebp)
 813:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 817:	75 23                	jne    83c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 819:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
 820:	8b 45 f0             	mov    -0x10(%ebp),%eax
 823:	a3 88 0b 00 00       	mov    %eax,0xb88
 828:	a1 88 0b 00 00       	mov    0xb88,%eax
 82d:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 832:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 839:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	8b 00                	mov    (%eax),%eax
 841:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84d:	72 4d                	jb     89c <malloc+0xa6>
      if(p->s.size == nunits)
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	8b 40 04             	mov    0x4(%eax),%eax
 855:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 858:	75 0c                	jne    866 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	8b 10                	mov    (%eax),%edx
 85f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 862:	89 10                	mov    %edx,(%eax)
 864:	eb 26                	jmp    88c <malloc+0x96>
      else {
        p->s.size -= nunits;
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	89 c2                	mov    %eax,%edx
 86e:	2b 55 ec             	sub    -0x14(%ebp),%edx
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 40 04             	mov    0x4(%eax),%eax
 87d:	c1 e0 03             	shl    $0x3,%eax
 880:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	8b 55 ec             	mov    -0x14(%ebp),%edx
 889:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 88c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88f:	a3 88 0b 00 00       	mov    %eax,0xb88
      return (void*)(p + 1);
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	83 c0 08             	add    $0x8,%eax
 89a:	eb 38                	jmp    8d4 <malloc+0xde>
    }
    if(p == freep)
 89c:	a1 88 0b 00 00       	mov    0xb88,%eax
 8a1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a4:	75 1b                	jne    8c1 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a9:	89 04 24             	mov    %eax,(%esp)
 8ac:	e8 ed fe ff ff       	call   79e <morecore>
 8b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b8:	75 07                	jne    8c1 <malloc+0xcb>
        return 0;
 8ba:	b8 00 00 00 00       	mov    $0x0,%eax
 8bf:	eb 13                	jmp    8d4 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	8b 00                	mov    (%eax),%eax
 8cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8cf:	e9 70 ff ff ff       	jmp    844 <malloc+0x4e>
}
 8d4:	c9                   	leave  
 8d5:	c3                   	ret    
