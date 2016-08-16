
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bf 00 00 00       	jmp    d1 <grep+0xd1>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 53                	jmp    74 <grep+0x74>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 c2 01 00 00       	call   1fb <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2e                	je     6b <grep+0x6b>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	83 c0 01             	add    $0x1,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4e:	89 d1                	mov    %edx,%ecx
  50:	29 c1                	sub    %eax,%ecx
  52:	89 c8                	mov    %ecx,%eax
  54:	89 44 24 08          	mov    %eax,0x8(%esp)
  58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  66:	e8 7d 05 00 00       	call   5e8 <write>
      }
      p = q+1;
  6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6e:	83 c0 01             	add    $0x1,%eax
  71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  74:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  7b:	00 
  7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7f:	89 04 24             	mov    %eax,(%esp)
  82:	e8 bf 03 00 00       	call   446 <strchr>
  87:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8e:	75 91                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  90:	81 7d f0 60 0e 00 00 	cmpl   $0xe60,-0x10(%ebp)
  97:	75 07                	jne    a0 <grep+0xa0>
      m = 0;
  99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a4:	7e 2b                	jle    d1 <grep+0xd1>
      m -= p - buf;
  a6:	ba 60 0e 00 00       	mov    $0xe60,%edx
  ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ae:	89 d1                	mov    %edx,%ecx
  b0:	29 c1                	sub    %eax,%ecx
  b2:	89 c8                	mov    %ecx,%eax
  b4:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  c5:	c7 04 24 60 0e 00 00 	movl   $0xe60,(%esp)
  cc:	e8 b4 04 00 00       	call   585 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d4:	ba 00 04 00 00       	mov    $0x400,%edx
  d9:	89 d1                	mov    %edx,%ecx
  db:	29 c1                	sub    %eax,%ecx
  dd:	89 c8                	mov    %ecx,%eax
  df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e2:	81 c2 60 0e 00 00    	add    $0xe60,%edx
  e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	89 04 24             	mov    %eax,(%esp)
  f6:	e8 e5 04 00 00       	call   5e0 <read>
  fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 102:	0f 8f 0a ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 108:	c9                   	leave  
 109:	c3                   	ret    

0000010a <main>:

int
main(int argc, char *argv[])
{
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	83 e4 f0             	and    $0xfffffff0,%esp
 110:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 113:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 117:	7f 19                	jg     132 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 119:	c7 44 24 04 1c 0b 00 	movl   $0xb1c,0x4(%esp)
 120:	00 
 121:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 128:	e8 20 06 00 00       	call   74d <printf>
    exit();
 12d:	e8 96 04 00 00       	call   5c8 <exit>
  }
  pattern = argv[1];
 132:	8b 45 0c             	mov    0xc(%ebp),%eax
 135:	8b 40 04             	mov    0x4(%eax),%eax
 138:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 13c:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 140:	7f 19                	jg     15b <main+0x51>
    grep(pattern, 0);
 142:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 149:	00 
 14a:	8b 44 24 18          	mov    0x18(%esp),%eax
 14e:	89 04 24             	mov    %eax,(%esp)
 151:	e8 aa fe ff ff       	call   0 <grep>
    exit();
 156:	e8 6d 04 00 00       	call   5c8 <exit>
  }

  for(i = 2; i < argc; i++){
 15b:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 162:	00 
 163:	e9 81 00 00 00       	jmp    1e9 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
 168:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 16c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 173:	8b 45 0c             	mov    0xc(%ebp),%eax
 176:	01 d0                	add    %edx,%eax
 178:	8b 00                	mov    (%eax),%eax
 17a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 181:	00 
 182:	89 04 24             	mov    %eax,(%esp)
 185:	e8 7e 04 00 00       	call   608 <open>
 18a:	89 44 24 14          	mov    %eax,0x14(%esp)
 18e:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 193:	79 2f                	jns    1c4 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 195:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 199:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	01 d0                	add    %edx,%eax
 1a5:	8b 00                	mov    (%eax),%eax
 1a7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ab:	c7 44 24 04 3c 0b 00 	movl   $0xb3c,0x4(%esp)
 1b2:	00 
 1b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ba:	e8 8e 05 00 00       	call   74d <printf>
      exit();
 1bf:	e8 04 04 00 00       	call   5c8 <exit>
    }
    grep(pattern, fd);
 1c4:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cc:	8b 44 24 18          	mov    0x18(%esp),%eax
 1d0:	89 04 24             	mov    %eax,(%esp)
 1d3:	e8 28 fe ff ff       	call   0 <grep>
    close(fd);
 1d8:	8b 44 24 14          	mov    0x14(%esp),%eax
 1dc:	89 04 24             	mov    %eax,(%esp)
 1df:	e8 0c 04 00 00       	call   5f0 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1e4:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1e9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1ed:	3b 45 08             	cmp    0x8(%ebp),%eax
 1f0:	0f 8c 72 ff ff ff    	jl     168 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1f6:	e8 cd 03 00 00       	call   5c8 <exit>

000001fb <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	0f b6 00             	movzbl (%eax),%eax
 207:	3c 5e                	cmp    $0x5e,%al
 209:	75 17                	jne    222 <match+0x27>
    return matchhere(re+1, text);
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	8d 50 01             	lea    0x1(%eax),%edx
 211:	8b 45 0c             	mov    0xc(%ebp),%eax
 214:	89 44 24 04          	mov    %eax,0x4(%esp)
 218:	89 14 24             	mov    %edx,(%esp)
 21b:	e8 39 00 00 00       	call   259 <matchhere>
 220:	eb 35                	jmp    257 <match+0x5c>
  do{  // must look at empty string
    if(matchhere(re, text))
 222:	8b 45 0c             	mov    0xc(%ebp),%eax
 225:	89 44 24 04          	mov    %eax,0x4(%esp)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	89 04 24             	mov    %eax,(%esp)
 22f:	e8 25 00 00 00       	call   259 <matchhere>
 234:	85 c0                	test   %eax,%eax
 236:	74 07                	je     23f <match+0x44>
      return 1;
 238:	b8 01 00 00 00       	mov    $0x1,%eax
 23d:	eb 18                	jmp    257 <match+0x5c>
  }while(*text++ != '\0');
 23f:	8b 45 0c             	mov    0xc(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	0f 95 c0             	setne  %al
 24a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 24e:	84 c0                	test   %al,%al
 250:	75 d0                	jne    222 <match+0x27>
  return 0;
 252:	b8 00 00 00 00       	mov    $0x0,%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	84 c0                	test   %al,%al
 267:	75 0a                	jne    273 <matchhere+0x1a>
    return 1;
 269:	b8 01 00 00 00       	mov    $0x1,%eax
 26e:	e9 9b 00 00 00       	jmp    30e <matchhere+0xb5>
  if(re[1] == '*')
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	83 c0 01             	add    $0x1,%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	3c 2a                	cmp    $0x2a,%al
 27e:	75 24                	jne    2a4 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	8d 48 02             	lea    0x2(%eax),%ecx
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	0f be c0             	movsbl %al,%eax
 28f:	8b 55 0c             	mov    0xc(%ebp),%edx
 292:	89 54 24 08          	mov    %edx,0x8(%esp)
 296:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 6e 00 00 00       	call   310 <matchstar>
 2a2:	eb 6a                	jmp    30e <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	0f b6 00             	movzbl (%eax),%eax
 2aa:	3c 24                	cmp    $0x24,%al
 2ac:	75 1d                	jne    2cb <matchhere+0x72>
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	83 c0 01             	add    $0x1,%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	84 c0                	test   %al,%al
 2b9:	75 10                	jne    2cb <matchhere+0x72>
    return *text == '\0';
 2bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	84 c0                	test   %al,%al
 2c3:	0f 94 c0             	sete   %al
 2c6:	0f b6 c0             	movzbl %al,%eax
 2c9:	eb 43                	jmp    30e <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	84 c0                	test   %al,%al
 2d3:	74 34                	je     309 <matchhere+0xb0>
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	3c 2e                	cmp    $0x2e,%al
 2dd:	74 10                	je     2ef <matchhere+0x96>
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	0f b6 10             	movzbl (%eax),%edx
 2e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	38 c2                	cmp    %al,%dl
 2ed:	75 1a                	jne    309 <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f2:	8d 50 01             	lea    0x1(%eax),%edx
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	83 c0 01             	add    $0x1,%eax
 2fb:	89 54 24 04          	mov    %edx,0x4(%esp)
 2ff:	89 04 24             	mov    %eax,(%esp)
 302:	e8 52 ff ff ff       	call   259 <matchhere>
 307:	eb 05                	jmp    30e <matchhere+0xb5>
  return 0;
 309:	b8 00 00 00 00       	mov    $0x0,%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 316:	8b 45 10             	mov    0x10(%ebp),%eax
 319:	89 44 24 04          	mov    %eax,0x4(%esp)
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	89 04 24             	mov    %eax,(%esp)
 323:	e8 31 ff ff ff       	call   259 <matchhere>
 328:	85 c0                	test   %eax,%eax
 32a:	74 07                	je     333 <matchstar+0x23>
      return 1;
 32c:	b8 01 00 00 00       	mov    $0x1,%eax
 331:	eb 2c                	jmp    35f <matchstar+0x4f>
  }while(*text!='\0' && (*text++==c || c=='.'));
 333:	8b 45 10             	mov    0x10(%ebp),%eax
 336:	0f b6 00             	movzbl (%eax),%eax
 339:	84 c0                	test   %al,%al
 33b:	74 1d                	je     35a <matchstar+0x4a>
 33d:	8b 45 10             	mov    0x10(%ebp),%eax
 340:	0f b6 00             	movzbl (%eax),%eax
 343:	0f be c0             	movsbl %al,%eax
 346:	3b 45 08             	cmp    0x8(%ebp),%eax
 349:	0f 94 c0             	sete   %al
 34c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
 350:	84 c0                	test   %al,%al
 352:	75 c2                	jne    316 <matchstar+0x6>
 354:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 358:	74 bc                	je     316 <matchstar+0x6>
  return 0;
 35a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    

00000361 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	57                   	push   %edi
 365:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 366:	8b 4d 08             	mov    0x8(%ebp),%ecx
 369:	8b 55 10             	mov    0x10(%ebp),%edx
 36c:	8b 45 0c             	mov    0xc(%ebp),%eax
 36f:	89 cb                	mov    %ecx,%ebx
 371:	89 df                	mov    %ebx,%edi
 373:	89 d1                	mov    %edx,%ecx
 375:	fc                   	cld    
 376:	f3 aa                	rep stos %al,%es:(%edi)
 378:	89 ca                	mov    %ecx,%edx
 37a:	89 fb                	mov    %edi,%ebx
 37c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 37f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 382:	5b                   	pop    %ebx
 383:	5f                   	pop    %edi
 384:	5d                   	pop    %ebp
 385:	c3                   	ret    

00000386 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 392:	90                   	nop
 393:	8b 45 0c             	mov    0xc(%ebp),%eax
 396:	0f b6 10             	movzbl (%eax),%edx
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	88 10                	mov    %dl,(%eax)
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	84 c0                	test   %al,%al
 3a6:	0f 95 c0             	setne  %al
 3a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3ad:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3b1:	84 c0                	test   %al,%al
 3b3:	75 de                	jne    393 <strcpy+0xd>
    ;
  return os;
 3b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b8:	c9                   	leave  
 3b9:	c3                   	ret    

000003ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3bd:	eb 08                	jmp    3c7 <strcmp+0xd>
    p++, q++;
 3bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	84 c0                	test   %al,%al
 3cf:	74 10                	je     3e1 <strcmp+0x27>
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	0f b6 10             	movzbl (%eax),%edx
 3d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	38 c2                	cmp    %al,%dl
 3df:	74 de                	je     3bf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	0f b6 00             	movzbl (%eax),%eax
 3e7:	0f b6 d0             	movzbl %al,%edx
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	0f b6 00             	movzbl (%eax),%eax
 3f0:	0f b6 c0             	movzbl %al,%eax
 3f3:	89 d1                	mov    %edx,%ecx
 3f5:	29 c1                	sub    %eax,%ecx
 3f7:	89 c8                	mov    %ecx,%eax
}
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    

000003fb <strlen>:

uint
strlen(char *s)
{
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 401:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 408:	eb 04                	jmp    40e <strlen+0x13>
 40a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 40e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	01 d0                	add    %edx,%eax
 416:	0f b6 00             	movzbl (%eax),%eax
 419:	84 c0                	test   %al,%al
 41b:	75 ed                	jne    40a <strlen+0xf>
    ;
  return n;
 41d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <memset>:

void*
memset(void *dst, int c, uint n)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 428:	8b 45 10             	mov    0x10(%ebp),%eax
 42b:	89 44 24 08          	mov    %eax,0x8(%esp)
 42f:	8b 45 0c             	mov    0xc(%ebp),%eax
 432:	89 44 24 04          	mov    %eax,0x4(%esp)
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	89 04 24             	mov    %eax,(%esp)
 43c:	e8 20 ff ff ff       	call   361 <stosb>
  return dst;
 441:	8b 45 08             	mov    0x8(%ebp),%eax
}
 444:	c9                   	leave  
 445:	c3                   	ret    

00000446 <strchr>:

char*
strchr(const char *s, char c)
{
 446:	55                   	push   %ebp
 447:	89 e5                	mov    %esp,%ebp
 449:	83 ec 04             	sub    $0x4,%esp
 44c:	8b 45 0c             	mov    0xc(%ebp),%eax
 44f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 452:	eb 14                	jmp    468 <strchr+0x22>
    if(*s == c)
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	0f b6 00             	movzbl (%eax),%eax
 45a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 45d:	75 05                	jne    464 <strchr+0x1e>
      return (char*)s;
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	eb 13                	jmp    477 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 464:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	0f b6 00             	movzbl (%eax),%eax
 46e:	84 c0                	test   %al,%al
 470:	75 e2                	jne    454 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 472:	b8 00 00 00 00       	mov    $0x0,%eax
}
 477:	c9                   	leave  
 478:	c3                   	ret    

00000479 <gets>:

char*
gets(char *buf, int max)
{
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 47f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 486:	eb 46                	jmp    4ce <gets+0x55>
    cc = read(0, &c, 1);
 488:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48f:	00 
 490:	8d 45 ef             	lea    -0x11(%ebp),%eax
 493:	89 44 24 04          	mov    %eax,0x4(%esp)
 497:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 49e:	e8 3d 01 00 00       	call   5e0 <read>
 4a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4aa:	7e 2f                	jle    4db <gets+0x62>
      break;
    buf[i++] = c;
 4ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	01 c2                	add    %eax,%edx
 4b4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b8:	88 02                	mov    %al,(%edx)
 4ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 4be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c2:	3c 0a                	cmp    $0xa,%al
 4c4:	74 16                	je     4dc <gets+0x63>
 4c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4ca:	3c 0d                	cmp    $0xd,%al
 4cc:	74 0e                	je     4dc <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d1:	83 c0 01             	add    $0x1,%eax
 4d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4d7:	7c af                	jl     488 <gets+0xf>
 4d9:	eb 01                	jmp    4dc <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4db:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	01 d0                	add    %edx,%eax
 4e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ea:	c9                   	leave  
 4eb:	c3                   	ret    

000004ec <stat>:

int
stat(char *n, struct stat *st)
{
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4f9:	00 
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	89 04 24             	mov    %eax,(%esp)
 500:	e8 03 01 00 00       	call   608 <open>
 505:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50c:	79 07                	jns    515 <stat+0x29>
    return -1;
 50e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 513:	eb 23                	jmp    538 <stat+0x4c>
  r = fstat(fd, st);
 515:	8b 45 0c             	mov    0xc(%ebp),%eax
 518:	89 44 24 04          	mov    %eax,0x4(%esp)
 51c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51f:	89 04 24             	mov    %eax,(%esp)
 522:	e8 f9 00 00 00       	call   620 <fstat>
 527:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 52a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52d:	89 04 24             	mov    %eax,(%esp)
 530:	e8 bb 00 00 00       	call   5f0 <close>
  return r;
 535:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 538:	c9                   	leave  
 539:	c3                   	ret    

0000053a <atoi>:

int
atoi(const char *s)
{
 53a:	55                   	push   %ebp
 53b:	89 e5                	mov    %esp,%ebp
 53d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 540:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 547:	eb 23                	jmp    56c <atoi+0x32>
    n = n*10 + *s++ - '0';
 549:	8b 55 fc             	mov    -0x4(%ebp),%edx
 54c:	89 d0                	mov    %edx,%eax
 54e:	c1 e0 02             	shl    $0x2,%eax
 551:	01 d0                	add    %edx,%eax
 553:	01 c0                	add    %eax,%eax
 555:	89 c2                	mov    %eax,%edx
 557:	8b 45 08             	mov    0x8(%ebp),%eax
 55a:	0f b6 00             	movzbl (%eax),%eax
 55d:	0f be c0             	movsbl %al,%eax
 560:	01 d0                	add    %edx,%eax
 562:	83 e8 30             	sub    $0x30,%eax
 565:	89 45 fc             	mov    %eax,-0x4(%ebp)
 568:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	0f b6 00             	movzbl (%eax),%eax
 572:	3c 2f                	cmp    $0x2f,%al
 574:	7e 0a                	jle    580 <atoi+0x46>
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	0f b6 00             	movzbl (%eax),%eax
 57c:	3c 39                	cmp    $0x39,%al
 57e:	7e c9                	jle    549 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 580:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 583:	c9                   	leave  
 584:	c3                   	ret    

00000585 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 585:	55                   	push   %ebp
 586:	89 e5                	mov    %esp,%ebp
 588:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 591:	8b 45 0c             	mov    0xc(%ebp),%eax
 594:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 597:	eb 13                	jmp    5ac <memmove+0x27>
    *dst++ = *src++;
 599:	8b 45 f8             	mov    -0x8(%ebp),%eax
 59c:	0f b6 10             	movzbl (%eax),%edx
 59f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a2:	88 10                	mov    %dl,(%eax)
 5a4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5a8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5b0:	0f 9f c0             	setg   %al
 5b3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5b7:	84 c0                	test   %al,%al
 5b9:	75 de                	jne    599 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5be:	c9                   	leave  
 5bf:	c3                   	ret    

000005c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5c0:	b8 01 00 00 00       	mov    $0x1,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <exit>:
SYSCALL(exit)
 5c8:	b8 02 00 00 00       	mov    $0x2,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <wait>:
SYSCALL(wait)
 5d0:	b8 03 00 00 00       	mov    $0x3,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <pipe>:
SYSCALL(pipe)
 5d8:	b8 04 00 00 00       	mov    $0x4,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <read>:
SYSCALL(read)
 5e0:	b8 05 00 00 00       	mov    $0x5,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <write>:
SYSCALL(write)
 5e8:	b8 10 00 00 00       	mov    $0x10,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <close>:
SYSCALL(close)
 5f0:	b8 15 00 00 00       	mov    $0x15,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <kill>:
SYSCALL(kill)
 5f8:	b8 06 00 00 00       	mov    $0x6,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <exec>:
SYSCALL(exec)
 600:	b8 07 00 00 00       	mov    $0x7,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <open>:
SYSCALL(open)
 608:	b8 0f 00 00 00       	mov    $0xf,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <mknod>:
SYSCALL(mknod)
 610:	b8 11 00 00 00       	mov    $0x11,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <unlink>:
SYSCALL(unlink)
 618:	b8 12 00 00 00       	mov    $0x12,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <fstat>:
SYSCALL(fstat)
 620:	b8 08 00 00 00       	mov    $0x8,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <link>:
SYSCALL(link)
 628:	b8 13 00 00 00       	mov    $0x13,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <mkdir>:
SYSCALL(mkdir)
 630:	b8 14 00 00 00       	mov    $0x14,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <chdir>:
SYSCALL(chdir)
 638:	b8 09 00 00 00       	mov    $0x9,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <dup>:
SYSCALL(dup)
 640:	b8 0a 00 00 00       	mov    $0xa,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <getpid>:
SYSCALL(getpid)
 648:	b8 0b 00 00 00       	mov    $0xb,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <sbrk>:
SYSCALL(sbrk)
 650:	b8 0c 00 00 00       	mov    $0xc,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <sleep>:
SYSCALL(sleep)
 658:	b8 0d 00 00 00       	mov    $0xd,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <uptime>:
SYSCALL(uptime)
 660:	b8 0e 00 00 00       	mov    $0xe,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <getprocs>:
SYSCALL(getprocs)
 668:	b8 16 00 00 00       	mov    $0x16,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	83 ec 28             	sub    $0x28,%esp
 676:	8b 45 0c             	mov    0xc(%ebp),%eax
 679:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 67c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 683:	00 
 684:	8d 45 f4             	lea    -0xc(%ebp),%eax
 687:	89 44 24 04          	mov    %eax,0x4(%esp)
 68b:	8b 45 08             	mov    0x8(%ebp),%eax
 68e:	89 04 24             	mov    %eax,(%esp)
 691:	e8 52 ff ff ff       	call   5e8 <write>
}
 696:	c9                   	leave  
 697:	c3                   	ret    

00000698 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 698:	55                   	push   %ebp
 699:	89 e5                	mov    %esp,%ebp
 69b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 69e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6a5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6a9:	74 17                	je     6c2 <printint+0x2a>
 6ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6af:	79 11                	jns    6c2 <printint+0x2a>
    neg = 1;
 6b1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bb:	f7 d8                	neg    %eax
 6bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c0:	eb 06                	jmp    6c8 <printint+0x30>
  } else {
    x = xx;
 6c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d5:	ba 00 00 00 00       	mov    $0x0,%edx
 6da:	f7 f1                	div    %ecx
 6dc:	89 d0                	mov    %edx,%eax
 6de:	0f b6 80 18 0e 00 00 	movzbl 0xe18(%eax),%eax
 6e5:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6eb:	01 ca                	add    %ecx,%edx
 6ed:	88 02                	mov    %al,(%edx)
 6ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 6f3:	8b 55 10             	mov    0x10(%ebp),%edx
 6f6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6fc:	ba 00 00 00 00       	mov    $0x0,%edx
 701:	f7 75 d4             	divl   -0x2c(%ebp)
 704:	89 45 ec             	mov    %eax,-0x14(%ebp)
 707:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 70b:	75 c2                	jne    6cf <printint+0x37>
  if(neg)
 70d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 711:	74 2e                	je     741 <printint+0xa9>
    buf[i++] = '-';
 713:	8d 55 dc             	lea    -0x24(%ebp),%edx
 716:	8b 45 f4             	mov    -0xc(%ebp),%eax
 719:	01 d0                	add    %edx,%eax
 71b:	c6 00 2d             	movb   $0x2d,(%eax)
 71e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 722:	eb 1d                	jmp    741 <printint+0xa9>
    putc(fd, buf[i]);
 724:	8d 55 dc             	lea    -0x24(%ebp),%edx
 727:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72a:	01 d0                	add    %edx,%eax
 72c:	0f b6 00             	movzbl (%eax),%eax
 72f:	0f be c0             	movsbl %al,%eax
 732:	89 44 24 04          	mov    %eax,0x4(%esp)
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	89 04 24             	mov    %eax,(%esp)
 73c:	e8 2f ff ff ff       	call   670 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 741:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 745:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 749:	79 d9                	jns    724 <printint+0x8c>
    putc(fd, buf[i]);
}
 74b:	c9                   	leave  
 74c:	c3                   	ret    

0000074d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 753:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 75a:	8d 45 0c             	lea    0xc(%ebp),%eax
 75d:	83 c0 04             	add    $0x4,%eax
 760:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 76a:	e9 7d 01 00 00       	jmp    8ec <printf+0x19f>
    c = fmt[i] & 0xff;
 76f:	8b 55 0c             	mov    0xc(%ebp),%edx
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	01 d0                	add    %edx,%eax
 777:	0f b6 00             	movzbl (%eax),%eax
 77a:	0f be c0             	movsbl %al,%eax
 77d:	25 ff 00 00 00       	and    $0xff,%eax
 782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 785:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 789:	75 2c                	jne    7b7 <printf+0x6a>
      if(c == '%'){
 78b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 78f:	75 0c                	jne    79d <printf+0x50>
        state = '%';
 791:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 798:	e9 4b 01 00 00       	jmp    8e8 <printf+0x19b>
      } else {
        putc(fd, c);
 79d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a0:	0f be c0             	movsbl %al,%eax
 7a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a7:	8b 45 08             	mov    0x8(%ebp),%eax
 7aa:	89 04 24             	mov    %eax,(%esp)
 7ad:	e8 be fe ff ff       	call   670 <putc>
 7b2:	e9 31 01 00 00       	jmp    8e8 <printf+0x19b>
      }
    } else if(state == '%'){
 7b7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7bb:	0f 85 27 01 00 00    	jne    8e8 <printf+0x19b>
      if(c == 'd'){
 7c1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7c5:	75 2d                	jne    7f4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7d3:	00 
 7d4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7db:	00 
 7dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e0:	8b 45 08             	mov    0x8(%ebp),%eax
 7e3:	89 04 24             	mov    %eax,(%esp)
 7e6:	e8 ad fe ff ff       	call   698 <printint>
        ap++;
 7eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ef:	e9 ed 00 00 00       	jmp    8e1 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 7f4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7f8:	74 06                	je     800 <printf+0xb3>
 7fa:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7fe:	75 2d                	jne    82d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 800:	8b 45 e8             	mov    -0x18(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 80c:	00 
 80d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 814:	00 
 815:	89 44 24 04          	mov    %eax,0x4(%esp)
 819:	8b 45 08             	mov    0x8(%ebp),%eax
 81c:	89 04 24             	mov    %eax,(%esp)
 81f:	e8 74 fe ff ff       	call   698 <printint>
        ap++;
 824:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 828:	e9 b4 00 00 00       	jmp    8e1 <printf+0x194>
      } else if(c == 's'){
 82d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 831:	75 46                	jne    879 <printf+0x12c>
        s = (char*)*ap;
 833:	8b 45 e8             	mov    -0x18(%ebp),%eax
 836:	8b 00                	mov    (%eax),%eax
 838:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 83b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 83f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 843:	75 27                	jne    86c <printf+0x11f>
          s = "(null)";
 845:	c7 45 f4 52 0b 00 00 	movl   $0xb52,-0xc(%ebp)
        while(*s != 0){
 84c:	eb 1e                	jmp    86c <printf+0x11f>
          putc(fd, *s);
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	0f b6 00             	movzbl (%eax),%eax
 854:	0f be c0             	movsbl %al,%eax
 857:	89 44 24 04          	mov    %eax,0x4(%esp)
 85b:	8b 45 08             	mov    0x8(%ebp),%eax
 85e:	89 04 24             	mov    %eax,(%esp)
 861:	e8 0a fe ff ff       	call   670 <putc>
          s++;
 866:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 86a:	eb 01                	jmp    86d <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 86c:	90                   	nop
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	0f b6 00             	movzbl (%eax),%eax
 873:	84 c0                	test   %al,%al
 875:	75 d7                	jne    84e <printf+0x101>
 877:	eb 68                	jmp    8e1 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 879:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 87d:	75 1d                	jne    89c <printf+0x14f>
        putc(fd, *ap);
 87f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 882:	8b 00                	mov    (%eax),%eax
 884:	0f be c0             	movsbl %al,%eax
 887:	89 44 24 04          	mov    %eax,0x4(%esp)
 88b:	8b 45 08             	mov    0x8(%ebp),%eax
 88e:	89 04 24             	mov    %eax,(%esp)
 891:	e8 da fd ff ff       	call   670 <putc>
        ap++;
 896:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 89a:	eb 45                	jmp    8e1 <printf+0x194>
      } else if(c == '%'){
 89c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8a0:	75 17                	jne    8b9 <printf+0x16c>
        putc(fd, c);
 8a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a5:	0f be c0             	movsbl %al,%eax
 8a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ac:	8b 45 08             	mov    0x8(%ebp),%eax
 8af:	89 04 24             	mov    %eax,(%esp)
 8b2:	e8 b9 fd ff ff       	call   670 <putc>
 8b7:	eb 28                	jmp    8e1 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8b9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8c0:	00 
 8c1:	8b 45 08             	mov    0x8(%ebp),%eax
 8c4:	89 04 24             	mov    %eax,(%esp)
 8c7:	e8 a4 fd ff ff       	call   670 <putc>
        putc(fd, c);
 8cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8cf:	0f be c0             	movsbl %al,%eax
 8d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d6:	8b 45 08             	mov    0x8(%ebp),%eax
 8d9:	89 04 24             	mov    %eax,(%esp)
 8dc:	e8 8f fd ff ff       	call   670 <putc>
      }
      state = 0;
 8e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8e8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8ec:	8b 55 0c             	mov    0xc(%ebp),%edx
 8ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f2:	01 d0                	add    %edx,%eax
 8f4:	0f b6 00             	movzbl (%eax),%eax
 8f7:	84 c0                	test   %al,%al
 8f9:	0f 85 70 fe ff ff    	jne    76f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8ff:	c9                   	leave  
 900:	c3                   	ret    

00000901 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 901:	55                   	push   %ebp
 902:	89 e5                	mov    %esp,%ebp
 904:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 907:	8b 45 08             	mov    0x8(%ebp),%eax
 90a:	83 e8 08             	sub    $0x8,%eax
 90d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 910:	a1 48 0e 00 00       	mov    0xe48,%eax
 915:	89 45 fc             	mov    %eax,-0x4(%ebp)
 918:	eb 24                	jmp    93e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91d:	8b 00                	mov    (%eax),%eax
 91f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 922:	77 12                	ja     936 <free+0x35>
 924:	8b 45 f8             	mov    -0x8(%ebp),%eax
 927:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 92a:	77 24                	ja     950 <free+0x4f>
 92c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92f:	8b 00                	mov    (%eax),%eax
 931:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 934:	77 1a                	ja     950 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 936:	8b 45 fc             	mov    -0x4(%ebp),%eax
 939:	8b 00                	mov    (%eax),%eax
 93b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 93e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 941:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 944:	76 d4                	jbe    91a <free+0x19>
 946:	8b 45 fc             	mov    -0x4(%ebp),%eax
 949:	8b 00                	mov    (%eax),%eax
 94b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94e:	76 ca                	jbe    91a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 950:	8b 45 f8             	mov    -0x8(%ebp),%eax
 953:	8b 40 04             	mov    0x4(%eax),%eax
 956:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 95d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 960:	01 c2                	add    %eax,%edx
 962:	8b 45 fc             	mov    -0x4(%ebp),%eax
 965:	8b 00                	mov    (%eax),%eax
 967:	39 c2                	cmp    %eax,%edx
 969:	75 24                	jne    98f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 96b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96e:	8b 50 04             	mov    0x4(%eax),%edx
 971:	8b 45 fc             	mov    -0x4(%ebp),%eax
 974:	8b 00                	mov    (%eax),%eax
 976:	8b 40 04             	mov    0x4(%eax),%eax
 979:	01 c2                	add    %eax,%edx
 97b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 981:	8b 45 fc             	mov    -0x4(%ebp),%eax
 984:	8b 00                	mov    (%eax),%eax
 986:	8b 10                	mov    (%eax),%edx
 988:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98b:	89 10                	mov    %edx,(%eax)
 98d:	eb 0a                	jmp    999 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 98f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 992:	8b 10                	mov    (%eax),%edx
 994:	8b 45 f8             	mov    -0x8(%ebp),%eax
 997:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 999:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99c:	8b 40 04             	mov    0x4(%eax),%eax
 99f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a9:	01 d0                	add    %edx,%eax
 9ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ae:	75 20                	jne    9d0 <free+0xcf>
    p->s.size += bp->s.size;
 9b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b3:	8b 50 04             	mov    0x4(%eax),%edx
 9b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b9:	8b 40 04             	mov    0x4(%eax),%eax
 9bc:	01 c2                	add    %eax,%edx
 9be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c7:	8b 10                	mov    (%eax),%edx
 9c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cc:	89 10                	mov    %edx,(%eax)
 9ce:	eb 08                	jmp    9d8 <free+0xd7>
  } else
    p->s.ptr = bp;
 9d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9d6:	89 10                	mov    %edx,(%eax)
  freep = p;
 9d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9db:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 9e0:	c9                   	leave  
 9e1:	c3                   	ret    

000009e2 <morecore>:

static Header*
morecore(uint nu)
{
 9e2:	55                   	push   %ebp
 9e3:	89 e5                	mov    %esp,%ebp
 9e5:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9e8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9ef:	77 07                	ja     9f8 <morecore+0x16>
    nu = 4096;
 9f1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9f8:	8b 45 08             	mov    0x8(%ebp),%eax
 9fb:	c1 e0 03             	shl    $0x3,%eax
 9fe:	89 04 24             	mov    %eax,(%esp)
 a01:	e8 4a fc ff ff       	call   650 <sbrk>
 a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a09:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a0d:	75 07                	jne    a16 <morecore+0x34>
    return 0;
 a0f:	b8 00 00 00 00       	mov    $0x0,%eax
 a14:	eb 22                	jmp    a38 <morecore+0x56>
  hp = (Header*)p;
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1f:	8b 55 08             	mov    0x8(%ebp),%edx
 a22:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a28:	83 c0 08             	add    $0x8,%eax
 a2b:	89 04 24             	mov    %eax,(%esp)
 a2e:	e8 ce fe ff ff       	call   901 <free>
  return freep;
 a33:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a38:	c9                   	leave  
 a39:	c3                   	ret    

00000a3a <malloc>:

void*
malloc(uint nbytes)
{
 a3a:	55                   	push   %ebp
 a3b:	89 e5                	mov    %esp,%ebp
 a3d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a40:	8b 45 08             	mov    0x8(%ebp),%eax
 a43:	83 c0 07             	add    $0x7,%eax
 a46:	c1 e8 03             	shr    $0x3,%eax
 a49:	83 c0 01             	add    $0x1,%eax
 a4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a4f:	a1 48 0e 00 00       	mov    0xe48,%eax
 a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a5b:	75 23                	jne    a80 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a5d:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a67:	a3 48 0e 00 00       	mov    %eax,0xe48
 a6c:	a1 48 0e 00 00       	mov    0xe48,%eax
 a71:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a76:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 a7d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a83:	8b 00                	mov    (%eax),%eax
 a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8b:	8b 40 04             	mov    0x4(%eax),%eax
 a8e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a91:	72 4d                	jb     ae0 <malloc+0xa6>
      if(p->s.size == nunits)
 a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a96:	8b 40 04             	mov    0x4(%eax),%eax
 a99:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a9c:	75 0c                	jne    aaa <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa1:	8b 10                	mov    (%eax),%edx
 aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa6:	89 10                	mov    %edx,(%eax)
 aa8:	eb 26                	jmp    ad0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aad:	8b 40 04             	mov    0x4(%eax),%eax
 ab0:	89 c2                	mov    %eax,%edx
 ab2:	2b 55 ec             	sub    -0x14(%ebp),%edx
 ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abe:	8b 40 04             	mov    0x4(%eax),%eax
 ac1:	c1 e0 03             	shl    $0x3,%eax
 ac4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aca:	8b 55 ec             	mov    -0x14(%ebp),%edx
 acd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad3:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adb:	83 c0 08             	add    $0x8,%eax
 ade:	eb 38                	jmp    b18 <malloc+0xde>
    }
    if(p == freep)
 ae0:	a1 48 0e 00 00       	mov    0xe48,%eax
 ae5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ae8:	75 1b                	jne    b05 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aed:	89 04 24             	mov    %eax,(%esp)
 af0:	e8 ed fe ff ff       	call   9e2 <morecore>
 af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 af8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 afc:	75 07                	jne    b05 <malloc+0xcb>
        return 0;
 afe:	b8 00 00 00 00       	mov    $0x0,%eax
 b03:	eb 13                	jmp    b18 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b08:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0e:	8b 00                	mov    (%eax),%eax
 b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b13:	e9 70 ff ff ff       	jmp    a88 <malloc+0x4e>
}
 b18:	c9                   	leave  
 b19:	c3                   	ret    
