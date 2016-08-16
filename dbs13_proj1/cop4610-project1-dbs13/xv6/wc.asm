
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 57                	jmp    82 <wc+0x82>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 80 0c 00 00       	add    $0xc80,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 80 0c 00 00       	add    $0xc80,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 92 09 00 00 	movl   $0x992,(%esp)
  5b:	e8 5e 02 00 00       	call   2be <strchr>
  60:	85 c0                	test   %eax,%eax
  62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
  6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  71:	75 0b                	jne    7e <wc+0x7e>
        w++;
  73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  88:	7c a1                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  91:	00 
  92:	c7 44 24 04 80 0c 00 	movl   $0xc80,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 b3 03 00 00       	call   458 <read>
  a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b6:	79 19                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  b8:	c7 44 24 04 98 09 00 	movl   $0x998,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 f9 04 00 00       	call   5c5 <printf>
    exit();
  cc:	e8 6f 03 00 00       	call   440 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 44 24 14          	mov    %eax,0x14(%esp)
  d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  db:	89 44 24 10          	mov    %eax,0x10(%esp)
  df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	c7 44 24 04 a8 09 00 	movl   $0x9a8,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 c4 04 00 00       	call   5c5 <printf>
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <main>:

int
main(int argc, char *argv[])
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 e4 f0             	and    $0xfffffff0,%esp
 109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 110:	7f 19                	jg     12b <main+0x28>
    wc(0, "");
 112:	c7 44 24 04 b5 09 00 	movl   $0x9b5,0x4(%esp)
 119:	00 
 11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 121:	e8 da fe ff ff       	call   0 <wc>
    exit();
 126:	e8 15 03 00 00       	call   440 <exit>
  }

  for(i = 1; i < argc; i++){
 12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 132:	00 
 133:	e9 8f 00 00 00       	jmp    1c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
 138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 13c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	8b 00                	mov    (%eax),%eax
 14a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 151:	00 
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 26 03 00 00       	call   480 <open>
 15a:	89 44 24 18          	mov    %eax,0x18(%esp)
 15e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 163:	79 2f                	jns    194 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
 175:	8b 00                	mov    (%eax),%eax
 177:	89 44 24 08          	mov    %eax,0x8(%esp)
 17b:	c7 44 24 04 b6 09 00 	movl   $0x9b6,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 36 04 00 00       	call   5c5 <printf>
      exit();
 18f:	e8 ac 02 00 00       	call   440 <exit>
    }
    wc(fd, argv[i]);
 194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	8b 00                	mov    (%eax),%eax
 1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1aa:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 4a fe ff ff       	call   0 <wc>
    close(fd);
 1b6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ba:	89 04 24             	mov    %eax,(%esp)
 1bd:	e8 a6 02 00 00       	call   468 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cb:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ce:	0f 8c 64 ff ff ff    	jl     138 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1d4:	e8 67 02 00 00       	call   440 <exit>

000001d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	57                   	push   %edi
 1dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1de:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e1:	8b 55 10             	mov    0x10(%ebp),%edx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	89 cb                	mov    %ecx,%ebx
 1e9:	89 df                	mov    %ebx,%edi
 1eb:	89 d1                	mov    %edx,%ecx
 1ed:	fc                   	cld    
 1ee:	f3 aa                	rep stos %al,%es:(%edi)
 1f0:	89 ca                	mov    %ecx,%edx
 1f2:	89 fb                	mov    %edi,%ebx
 1f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fa:	5b                   	pop    %ebx
 1fb:	5f                   	pop    %edi
 1fc:	5d                   	pop    %ebp
 1fd:	c3                   	ret    

000001fe <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 20a:	90                   	nop
 20b:	8b 45 0c             	mov    0xc(%ebp),%eax
 20e:	0f b6 10             	movzbl (%eax),%edx
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	88 10                	mov    %dl,(%eax)
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	0f b6 00             	movzbl (%eax),%eax
 21c:	84 c0                	test   %al,%al
 21e:	0f 95 c0             	setne  %al
 221:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 225:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 229:	84 c0                	test   %al,%al
 22b:	75 de                	jne    20b <strcpy+0xd>
    ;
  return os;
 22d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 235:	eb 08                	jmp    23f <strcmp+0xd>
    p++, q++;
 237:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	74 10                	je     259 <strcmp+0x27>
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	0f b6 10             	movzbl (%eax),%edx
 24f:	8b 45 0c             	mov    0xc(%ebp),%eax
 252:	0f b6 00             	movzbl (%eax),%eax
 255:	38 c2                	cmp    %al,%dl
 257:	74 de                	je     237 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 259:	8b 45 08             	mov    0x8(%ebp),%eax
 25c:	0f b6 00             	movzbl (%eax),%eax
 25f:	0f b6 d0             	movzbl %al,%edx
 262:	8b 45 0c             	mov    0xc(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	0f b6 c0             	movzbl %al,%eax
 26b:	89 d1                	mov    %edx,%ecx
 26d:	29 c1                	sub    %eax,%ecx
 26f:	89 c8                	mov    %ecx,%eax
}
 271:	5d                   	pop    %ebp
 272:	c3                   	ret    

00000273 <strlen>:

uint
strlen(char *s)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 279:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 280:	eb 04                	jmp    286 <strlen+0x13>
 282:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 286:	8b 55 fc             	mov    -0x4(%ebp),%edx
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	01 d0                	add    %edx,%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	84 c0                	test   %al,%al
 293:	75 ed                	jne    282 <strlen+0xf>
    ;
  return n;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <memset>:

void*
memset(void *dst, int c, uint n)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2a0:	8b 45 10             	mov    0x10(%ebp),%eax
 2a3:	89 44 24 08          	mov    %eax,0x8(%esp)
 2a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	89 04 24             	mov    %eax,(%esp)
 2b4:	e8 20 ff ff ff       	call   1d9 <stosb>
  return dst;
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bc:	c9                   	leave  
 2bd:	c3                   	ret    

000002be <strchr>:

char*
strchr(const char *s, char c)
{
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
 2c1:	83 ec 04             	sub    $0x4,%esp
 2c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ca:	eb 14                	jmp    2e0 <strchr+0x22>
    if(*s == c)
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2d5:	75 05                	jne    2dc <strchr+0x1e>
      return (char*)s;
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	eb 13                	jmp    2ef <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	0f b6 00             	movzbl (%eax),%eax
 2e6:	84 c0                	test   %al,%al
 2e8:	75 e2                	jne    2cc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ef:	c9                   	leave  
 2f0:	c3                   	ret    

000002f1 <gets>:

char*
gets(char *buf, int max)
{
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp
 2f4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2fe:	eb 46                	jmp    346 <gets+0x55>
    cc = read(0, &c, 1);
 300:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 307:	00 
 308:	8d 45 ef             	lea    -0x11(%ebp),%eax
 30b:	89 44 24 04          	mov    %eax,0x4(%esp)
 30f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 316:	e8 3d 01 00 00       	call   458 <read>
 31b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 31e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 322:	7e 2f                	jle    353 <gets+0x62>
      break;
    buf[i++] = c;
 324:	8b 55 f4             	mov    -0xc(%ebp),%edx
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	01 c2                	add    %eax,%edx
 32c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 330:	88 02                	mov    %al,(%edx)
 332:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 336:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33a:	3c 0a                	cmp    $0xa,%al
 33c:	74 16                	je     354 <gets+0x63>
 33e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 342:	3c 0d                	cmp    $0xd,%al
 344:	74 0e                	je     354 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 346:	8b 45 f4             	mov    -0xc(%ebp),%eax
 349:	83 c0 01             	add    $0x1,%eax
 34c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 34f:	7c af                	jl     300 <gets+0xf>
 351:	eb 01                	jmp    354 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 353:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 354:	8b 55 f4             	mov    -0xc(%ebp),%edx
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	01 d0                	add    %edx,%eax
 35c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <stat>:

int
stat(char *n, struct stat *st)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 371:	00 
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	89 04 24             	mov    %eax,(%esp)
 378:	e8 03 01 00 00       	call   480 <open>
 37d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 384:	79 07                	jns    38d <stat+0x29>
    return -1;
 386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38b:	eb 23                	jmp    3b0 <stat+0x4c>
  r = fstat(fd, st);
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	89 44 24 04          	mov    %eax,0x4(%esp)
 394:	8b 45 f4             	mov    -0xc(%ebp),%eax
 397:	89 04 24             	mov    %eax,(%esp)
 39a:	e8 f9 00 00 00       	call   498 <fstat>
 39f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a5:	89 04 24             	mov    %eax,(%esp)
 3a8:	e8 bb 00 00 00       	call   468 <close>
  return r;
 3ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b0:	c9                   	leave  
 3b1:	c3                   	ret    

000003b2 <atoi>:

int
atoi(const char *s)
{
 3b2:	55                   	push   %ebp
 3b3:	89 e5                	mov    %esp,%ebp
 3b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3bf:	eb 23                	jmp    3e4 <atoi+0x32>
    n = n*10 + *s++ - '0';
 3c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c4:	89 d0                	mov    %edx,%eax
 3c6:	c1 e0 02             	shl    $0x2,%eax
 3c9:	01 d0                	add    %edx,%eax
 3cb:	01 c0                	add    %eax,%eax
 3cd:	89 c2                	mov    %eax,%edx
 3cf:	8b 45 08             	mov    0x8(%ebp),%eax
 3d2:	0f b6 00             	movzbl (%eax),%eax
 3d5:	0f be c0             	movsbl %al,%eax
 3d8:	01 d0                	add    %edx,%eax
 3da:	83 e8 30             	sub    $0x30,%eax
 3dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3e0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	3c 2f                	cmp    $0x2f,%al
 3ec:	7e 0a                	jle    3f8 <atoi+0x46>
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	3c 39                	cmp    $0x39,%al
 3f6:	7e c9                	jle    3c1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3fb:	c9                   	leave  
 3fc:	c3                   	ret    

000003fd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3fd:	55                   	push   %ebp
 3fe:	89 e5                	mov    %esp,%ebp
 400:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 409:	8b 45 0c             	mov    0xc(%ebp),%eax
 40c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 40f:	eb 13                	jmp    424 <memmove+0x27>
    *dst++ = *src++;
 411:	8b 45 f8             	mov    -0x8(%ebp),%eax
 414:	0f b6 10             	movzbl (%eax),%edx
 417:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41a:	88 10                	mov    %dl,(%eax)
 41c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 420:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 424:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 428:	0f 9f c0             	setg   %al
 42b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 42f:	84 c0                	test   %al,%al
 431:	75 de                	jne    411 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 433:	8b 45 08             	mov    0x8(%ebp),%eax
}
 436:	c9                   	leave  
 437:	c3                   	ret    

00000438 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 438:	b8 01 00 00 00       	mov    $0x1,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <exit>:
SYSCALL(exit)
 440:	b8 02 00 00 00       	mov    $0x2,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <wait>:
SYSCALL(wait)
 448:	b8 03 00 00 00       	mov    $0x3,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <pipe>:
SYSCALL(pipe)
 450:	b8 04 00 00 00       	mov    $0x4,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <read>:
SYSCALL(read)
 458:	b8 05 00 00 00       	mov    $0x5,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <write>:
SYSCALL(write)
 460:	b8 10 00 00 00       	mov    $0x10,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <close>:
SYSCALL(close)
 468:	b8 15 00 00 00       	mov    $0x15,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <kill>:
SYSCALL(kill)
 470:	b8 06 00 00 00       	mov    $0x6,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <exec>:
SYSCALL(exec)
 478:	b8 07 00 00 00       	mov    $0x7,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <open>:
SYSCALL(open)
 480:	b8 0f 00 00 00       	mov    $0xf,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <mknod>:
SYSCALL(mknod)
 488:	b8 11 00 00 00       	mov    $0x11,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <unlink>:
SYSCALL(unlink)
 490:	b8 12 00 00 00       	mov    $0x12,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <fstat>:
SYSCALL(fstat)
 498:	b8 08 00 00 00       	mov    $0x8,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <link>:
SYSCALL(link)
 4a0:	b8 13 00 00 00       	mov    $0x13,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <mkdir>:
SYSCALL(mkdir)
 4a8:	b8 14 00 00 00       	mov    $0x14,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <chdir>:
SYSCALL(chdir)
 4b0:	b8 09 00 00 00       	mov    $0x9,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <dup>:
SYSCALL(dup)
 4b8:	b8 0a 00 00 00       	mov    $0xa,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <getpid>:
SYSCALL(getpid)
 4c0:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <sbrk>:
SYSCALL(sbrk)
 4c8:	b8 0c 00 00 00       	mov    $0xc,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <sleep>:
SYSCALL(sleep)
 4d0:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <uptime>:
SYSCALL(uptime)
 4d8:	b8 0e 00 00 00       	mov    $0xe,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <getprocs>:
SYSCALL(getprocs)
 4e0:	b8 16 00 00 00       	mov    $0x16,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e8:	55                   	push   %ebp
 4e9:	89 e5                	mov    %esp,%ebp
 4eb:	83 ec 28             	sub    $0x28,%esp
 4ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4fb:	00 
 4fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	89 04 24             	mov    %eax,(%esp)
 509:	e8 52 ff ff ff       	call   460 <write>
}
 50e:	c9                   	leave  
 50f:	c3                   	ret    

00000510 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 516:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 51d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 521:	74 17                	je     53a <printint+0x2a>
 523:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 527:	79 11                	jns    53a <printint+0x2a>
    neg = 1;
 529:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 530:	8b 45 0c             	mov    0xc(%ebp),%eax
 533:	f7 d8                	neg    %eax
 535:	89 45 ec             	mov    %eax,-0x14(%ebp)
 538:	eb 06                	jmp    540 <printint+0x30>
  } else {
    x = xx;
 53a:	8b 45 0c             	mov    0xc(%ebp),%eax
 53d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 540:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 547:	8b 4d 10             	mov    0x10(%ebp),%ecx
 54a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54d:	ba 00 00 00 00       	mov    $0x0,%edx
 552:	f7 f1                	div    %ecx
 554:	89 d0                	mov    %edx,%eax
 556:	0f b6 80 30 0c 00 00 	movzbl 0xc30(%eax),%eax
 55d:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 560:	8b 55 f4             	mov    -0xc(%ebp),%edx
 563:	01 ca                	add    %ecx,%edx
 565:	88 02                	mov    %al,(%edx)
 567:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 56b:	8b 55 10             	mov    0x10(%ebp),%edx
 56e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 571:	8b 45 ec             	mov    -0x14(%ebp),%eax
 574:	ba 00 00 00 00       	mov    $0x0,%edx
 579:	f7 75 d4             	divl   -0x2c(%ebp)
 57c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 583:	75 c2                	jne    547 <printint+0x37>
  if(neg)
 585:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 589:	74 2e                	je     5b9 <printint+0xa9>
    buf[i++] = '-';
 58b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 58e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 591:	01 d0                	add    %edx,%eax
 593:	c6 00 2d             	movb   $0x2d,(%eax)
 596:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 59a:	eb 1d                	jmp    5b9 <printint+0xa9>
    putc(fd, buf[i]);
 59c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 59f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a2:	01 d0                	add    %edx,%eax
 5a4:	0f b6 00             	movzbl (%eax),%eax
 5a7:	0f be c0             	movsbl %al,%eax
 5aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	89 04 24             	mov    %eax,(%esp)
 5b4:	e8 2f ff ff ff       	call   4e8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5b9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c1:	79 d9                	jns    59c <printint+0x8c>
    putc(fd, buf[i]);
}
 5c3:	c9                   	leave  
 5c4:	c3                   	ret    

000005c5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5c5:	55                   	push   %ebp
 5c6:	89 e5                	mov    %esp,%ebp
 5c8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d2:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d5:	83 c0 04             	add    $0x4,%eax
 5d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e2:	e9 7d 01 00 00       	jmp    764 <printf+0x19f>
    c = fmt[i] & 0xff;
 5e7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ed:	01 d0                	add    %edx,%eax
 5ef:	0f b6 00             	movzbl (%eax),%eax
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	25 ff 00 00 00       	and    $0xff,%eax
 5fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 601:	75 2c                	jne    62f <printf+0x6a>
      if(c == '%'){
 603:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 607:	75 0c                	jne    615 <printf+0x50>
        state = '%';
 609:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 610:	e9 4b 01 00 00       	jmp    760 <printf+0x19b>
      } else {
        putc(fd, c);
 615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 618:	0f be c0             	movsbl %al,%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 be fe ff ff       	call   4e8 <putc>
 62a:	e9 31 01 00 00       	jmp    760 <printf+0x19b>
      }
    } else if(state == '%'){
 62f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 633:	0f 85 27 01 00 00    	jne    760 <printf+0x19b>
      if(c == 'd'){
 639:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 63d:	75 2d                	jne    66c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 63f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 642:	8b 00                	mov    (%eax),%eax
 644:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 64b:	00 
 64c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 653:	00 
 654:	89 44 24 04          	mov    %eax,0x4(%esp)
 658:	8b 45 08             	mov    0x8(%ebp),%eax
 65b:	89 04 24             	mov    %eax,(%esp)
 65e:	e8 ad fe ff ff       	call   510 <printint>
        ap++;
 663:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 667:	e9 ed 00 00 00       	jmp    759 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 66c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 670:	74 06                	je     678 <printf+0xb3>
 672:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 676:	75 2d                	jne    6a5 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 678:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 684:	00 
 685:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 68c:	00 
 68d:	89 44 24 04          	mov    %eax,0x4(%esp)
 691:	8b 45 08             	mov    0x8(%ebp),%eax
 694:	89 04 24             	mov    %eax,(%esp)
 697:	e8 74 fe ff ff       	call   510 <printint>
        ap++;
 69c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a0:	e9 b4 00 00 00       	jmp    759 <printf+0x194>
      } else if(c == 's'){
 6a5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6a9:	75 46                	jne    6f1 <printf+0x12c>
        s = (char*)*ap;
 6ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6bb:	75 27                	jne    6e4 <printf+0x11f>
          s = "(null)";
 6bd:	c7 45 f4 ca 09 00 00 	movl   $0x9ca,-0xc(%ebp)
        while(*s != 0){
 6c4:	eb 1e                	jmp    6e4 <printf+0x11f>
          putc(fd, *s);
 6c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c9:	0f b6 00             	movzbl (%eax),%eax
 6cc:	0f be c0             	movsbl %al,%eax
 6cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	89 04 24             	mov    %eax,(%esp)
 6d9:	e8 0a fe ff ff       	call   4e8 <putc>
          s++;
 6de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 6e2:	eb 01                	jmp    6e5 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e4:	90                   	nop
 6e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e8:	0f b6 00             	movzbl (%eax),%eax
 6eb:	84 c0                	test   %al,%al
 6ed:	75 d7                	jne    6c6 <printf+0x101>
 6ef:	eb 68                	jmp    759 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6f1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6f5:	75 1d                	jne    714 <printf+0x14f>
        putc(fd, *ap);
 6f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	0f be c0             	movsbl %al,%eax
 6ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	89 04 24             	mov    %eax,(%esp)
 709:	e8 da fd ff ff       	call   4e8 <putc>
        ap++;
 70e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 712:	eb 45                	jmp    759 <printf+0x194>
      } else if(c == '%'){
 714:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 718:	75 17                	jne    731 <printf+0x16c>
        putc(fd, c);
 71a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71d:	0f be c0             	movsbl %al,%eax
 720:	89 44 24 04          	mov    %eax,0x4(%esp)
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	89 04 24             	mov    %eax,(%esp)
 72a:	e8 b9 fd ff ff       	call   4e8 <putc>
 72f:	eb 28                	jmp    759 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 731:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 738:	00 
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 a4 fd ff ff       	call   4e8 <putc>
        putc(fd, c);
 744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 747:	0f be c0             	movsbl %al,%eax
 74a:	89 44 24 04          	mov    %eax,0x4(%esp)
 74e:	8b 45 08             	mov    0x8(%ebp),%eax
 751:	89 04 24             	mov    %eax,(%esp)
 754:	e8 8f fd ff ff       	call   4e8 <putc>
      }
      state = 0;
 759:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 760:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 764:	8b 55 0c             	mov    0xc(%ebp),%edx
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	01 d0                	add    %edx,%eax
 76c:	0f b6 00             	movzbl (%eax),%eax
 76f:	84 c0                	test   %al,%al
 771:	0f 85 70 fe ff ff    	jne    5e7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 777:	c9                   	leave  
 778:	c3                   	ret    

00000779 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 779:	55                   	push   %ebp
 77a:	89 e5                	mov    %esp,%ebp
 77c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	83 e8 08             	sub    $0x8,%eax
 785:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 788:	a1 68 0c 00 00       	mov    0xc68,%eax
 78d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 790:	eb 24                	jmp    7b6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79a:	77 12                	ja     7ae <free+0x35>
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a2:	77 24                	ja     7c8 <free+0x4f>
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ac:	77 1a                	ja     7c8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	8b 00                	mov    (%eax),%eax
 7b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bc:	76 d4                	jbe    792 <free+0x19>
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c6:	76 ca                	jbe    792 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	01 c2                	add    %eax,%edx
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 00                	mov    (%eax),%eax
 7df:	39 c2                	cmp    %eax,%edx
 7e1:	75 24                	jne    807 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	8b 50 04             	mov    0x4(%eax),%edx
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	01 c2                	add    %eax,%edx
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	8b 10                	mov    (%eax),%edx
 800:	8b 45 f8             	mov    -0x8(%ebp),%eax
 803:	89 10                	mov    %edx,(%eax)
 805:	eb 0a                	jmp    811 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 10                	mov    (%eax),%edx
 80c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	01 d0                	add    %edx,%eax
 823:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 826:	75 20                	jne    848 <free+0xcf>
    p->s.size += bp->s.size;
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 50 04             	mov    0x4(%eax),%edx
 82e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	01 c2                	add    %eax,%edx
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 83c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83f:	8b 10                	mov    (%eax),%edx
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	89 10                	mov    %edx,(%eax)
 846:	eb 08                	jmp    850 <free+0xd7>
  } else
    p->s.ptr = bp;
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 84e:	89 10                	mov    %edx,(%eax)
  freep = p;
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 858:	c9                   	leave  
 859:	c3                   	ret    

0000085a <morecore>:

static Header*
morecore(uint nu)
{
 85a:	55                   	push   %ebp
 85b:	89 e5                	mov    %esp,%ebp
 85d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 860:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 867:	77 07                	ja     870 <morecore+0x16>
    nu = 4096;
 869:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 870:	8b 45 08             	mov    0x8(%ebp),%eax
 873:	c1 e0 03             	shl    $0x3,%eax
 876:	89 04 24             	mov    %eax,(%esp)
 879:	e8 4a fc ff ff       	call   4c8 <sbrk>
 87e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 881:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 885:	75 07                	jne    88e <morecore+0x34>
    return 0;
 887:	b8 00 00 00 00       	mov    $0x0,%eax
 88c:	eb 22                	jmp    8b0 <morecore+0x56>
  hp = (Header*)p;
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 894:	8b 45 f0             	mov    -0x10(%ebp),%eax
 897:	8b 55 08             	mov    0x8(%ebp),%edx
 89a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	83 c0 08             	add    $0x8,%eax
 8a3:	89 04 24             	mov    %eax,(%esp)
 8a6:	e8 ce fe ff ff       	call   779 <free>
  return freep;
 8ab:	a1 68 0c 00 00       	mov    0xc68,%eax
}
 8b0:	c9                   	leave  
 8b1:	c3                   	ret    

000008b2 <malloc>:

void*
malloc(uint nbytes)
{
 8b2:	55                   	push   %ebp
 8b3:	89 e5                	mov    %esp,%ebp
 8b5:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b8:	8b 45 08             	mov    0x8(%ebp),%eax
 8bb:	83 c0 07             	add    $0x7,%eax
 8be:	c1 e8 03             	shr    $0x3,%eax
 8c1:	83 c0 01             	add    $0x1,%eax
 8c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8c7:	a1 68 0c 00 00       	mov    0xc68,%eax
 8cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d3:	75 23                	jne    8f8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8d5:	c7 45 f0 60 0c 00 00 	movl   $0xc60,-0x10(%ebp)
 8dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8df:	a3 68 0c 00 00       	mov    %eax,0xc68
 8e4:	a1 68 0c 00 00       	mov    0xc68,%eax
 8e9:	a3 60 0c 00 00       	mov    %eax,0xc60
    base.s.size = 0;
 8ee:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 8f5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fb:	8b 00                	mov    (%eax),%eax
 8fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 909:	72 4d                	jb     958 <malloc+0xa6>
      if(p->s.size == nunits)
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	8b 40 04             	mov    0x4(%eax),%eax
 911:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 914:	75 0c                	jne    922 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	8b 10                	mov    (%eax),%edx
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	89 10                	mov    %edx,(%eax)
 920:	eb 26                	jmp    948 <malloc+0x96>
      else {
        p->s.size -= nunits;
 922:	8b 45 f4             	mov    -0xc(%ebp),%eax
 925:	8b 40 04             	mov    0x4(%eax),%eax
 928:	89 c2                	mov    %eax,%edx
 92a:	2b 55 ec             	sub    -0x14(%ebp),%edx
 92d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 930:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	8b 40 04             	mov    0x4(%eax),%eax
 939:	c1 e0 03             	shl    $0x3,%eax
 93c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	8b 55 ec             	mov    -0x14(%ebp),%edx
 945:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 948:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94b:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 950:	8b 45 f4             	mov    -0xc(%ebp),%eax
 953:	83 c0 08             	add    $0x8,%eax
 956:	eb 38                	jmp    990 <malloc+0xde>
    }
    if(p == freep)
 958:	a1 68 0c 00 00       	mov    0xc68,%eax
 95d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 960:	75 1b                	jne    97d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 962:	8b 45 ec             	mov    -0x14(%ebp),%eax
 965:	89 04 24             	mov    %eax,(%esp)
 968:	e8 ed fe ff ff       	call   85a <morecore>
 96d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 974:	75 07                	jne    97d <malloc+0xcb>
        return 0;
 976:	b8 00 00 00 00       	mov    $0x0,%eax
 97b:	eb 13                	jmp    990 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 980:	89 45 f0             	mov    %eax,-0x10(%ebp)
 983:	8b 45 f4             	mov    -0xc(%ebp),%eax
 986:	8b 00                	mov    (%eax),%eax
 988:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 98b:	e9 70 ff ff ff       	jmp    900 <malloc+0x4e>
}
 990:	c9                   	leave  
 991:	c3                   	ret    
