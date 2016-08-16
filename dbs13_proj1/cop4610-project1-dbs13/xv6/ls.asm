
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 e3 03 00 00       	call   3f5 <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 04                	jmp    20 <fmtname+0x20>
  1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	3b 45 08             	cmp    0x8(%ebp),%eax
  26:	72 0a                	jb     32 <fmtname+0x32>
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	0f b6 00             	movzbl (%eax),%eax
  2e:	3c 2f                	cmp    $0x2f,%al
  30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
  32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 b4 03 00 00       	call   3f5 <strlen>
  41:	83 f8 0d             	cmp    $0xd,%eax
  44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
  4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 9f 03 00 00       	call   3f5 <strlen>
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  61:	c7 04 24 0c 0e 00 00 	movl   $0xe0c,(%esp)
  68:	e8 12 05 00 00       	call   57f <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 7d 03 00 00       	call   3f5 <strlen>
  78:	ba 0e 00 00 00       	mov    $0xe,%edx
  7d:	89 d3                	mov    %edx,%ebx
  7f:	29 c3                	sub    %eax,%ebx
  81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  84:	89 04 24             	mov    %eax,(%esp)
  87:	e8 69 03 00 00       	call   3f5 <strlen>
  8c:	05 0c 0e 00 00       	add    $0xe0c,%eax
  91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9c:	00 
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 77 03 00 00       	call   41c <memset>
  return buf;
  a5:	b8 0c 0e 00 00       	mov    $0xe0c,%eax
}
  aa:	83 c4 24             	add    $0x24,%esp
  ad:	5b                   	pop    %ebx
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c3:	00 
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 04 24             	mov    %eax,(%esp)
  ca:	e8 33 05 00 00       	call   602 <open>
  cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 44 24 08          	mov    %eax,0x8(%esp)
  df:	c7 44 24 04 14 0b 00 	movl   $0xb14,0x4(%esp)
  e6:	00 
  e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ee:	e8 54 06 00 00       	call   747 <printf>
  f3:	e9 01 02 00 00       	jmp    2f9 <ls+0x249>
    return;
  }
  
  if(fstat(fd, &st) < 0){
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 105:	89 04 24             	mov    %eax,(%esp)
 108:	e8 0d 05 00 00       	call   61a <fstat>
 10d:	85 c0                	test   %eax,%eax
 10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 44 24 08          	mov    %eax,0x8(%esp)
 118:	c7 44 24 04 28 0b 00 	movl   $0xb28,0x4(%esp)
 11f:	00 
 120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 127:	e8 1b 06 00 00       	call   747 <printf>
    close(fd);
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	89 04 24             	mov    %eax,(%esp)
 132:	e8 b3 04 00 00       	call   5ea <close>
 137:	e9 bd 01 00 00       	jmp    2f9 <ls+0x249>
    return;
  }
  
  switch(st.type){
 13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 143:	98                   	cwtl   
 144:	83 f8 01             	cmp    $0x1,%eax
 147:	74 53                	je     19c <ls+0xec>
 149:	83 f8 02             	cmp    $0x2,%eax
 14c:	0f 85 9c 01 00 00    	jne    2ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 165:	0f bf d8             	movswl %ax,%ebx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 8d fe ff ff       	call   0 <fmtname>
 173:	89 7c 24 14          	mov    %edi,0x14(%esp)
 177:	89 74 24 10          	mov    %esi,0x10(%esp)
 17b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17f:	89 44 24 08          	mov    %eax,0x8(%esp)
 183:	c7 44 24 04 3c 0b 00 	movl   $0xb3c,0x4(%esp)
 18a:	00 
 18b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 192:	e8 b0 05 00 00       	call   747 <printf>
    break;
 197:	e9 52 01 00 00       	jmp    2ee <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	89 04 24             	mov    %eax,(%esp)
 1a2:	e8 4e 02 00 00       	call   3f5 <strlen>
 1a7:	83 c0 10             	add    $0x10,%eax
 1aa:	3d 00 02 00 00       	cmp    $0x200,%eax
 1af:	76 19                	jbe    1ca <ls+0x11a>
      printf(1, "ls: path too long\n");
 1b1:	c7 44 24 04 49 0b 00 	movl   $0xb49,0x4(%esp)
 1b8:	00 
 1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c0:	e8 82 05 00 00       	call   747 <printf>
      break;
 1c5:	e9 24 01 00 00       	jmp    2ee <ls+0x23e>
    }
    strcpy(buf, path);
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d7:	89 04 24             	mov    %eax,(%esp)
 1da:	e8 a1 01 00 00       	call   380 <strcpy>
    p = buf+strlen(buf);
 1df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 08 02 00 00       	call   3f5 <strlen>
 1ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f3:	01 d0                	add    %edx,%eax
 1f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fb:	c6 00 2f             	movb   $0x2f,(%eax)
 1fe:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 202:	e9 c0 00 00 00       	jmp    2c7 <ls+0x217>
      if(de.inum == 0)
 207:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 20e:	66 85 c0             	test   %ax,%ax
 211:	0f 84 af 00 00 00    	je     2c6 <ls+0x216>
        continue;
      memmove(p, de.name, DIRSIZ);
 217:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 21e:	00 
 21f:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 225:	83 c0 02             	add    $0x2,%eax
 228:	89 44 24 04          	mov    %eax,0x4(%esp)
 22c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22f:	89 04 24             	mov    %eax,(%esp)
 232:	e8 48 03 00 00       	call   57f <memmove>
      p[DIRSIZ] = 0;
 237:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23a:	83 c0 0e             	add    $0xe,%eax
 23d:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 240:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 246:	89 44 24 04          	mov    %eax,0x4(%esp)
 24a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 250:	89 04 24             	mov    %eax,(%esp)
 253:	e8 8e 02 00 00       	call   4e6 <stat>
 258:	85 c0                	test   %eax,%eax
 25a:	79 20                	jns    27c <ls+0x1cc>
        printf(1, "ls: cannot stat %s\n", buf);
 25c:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 262:	89 44 24 08          	mov    %eax,0x8(%esp)
 266:	c7 44 24 04 28 0b 00 	movl   $0xb28,0x4(%esp)
 26d:	00 
 26e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 275:	e8 cd 04 00 00       	call   747 <printf>
        continue;
 27a:	eb 4b                	jmp    2c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27c:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 282:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 288:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 28f:	0f bf d8             	movswl %ax,%ebx
 292:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 298:	89 04 24             	mov    %eax,(%esp)
 29b:	e8 60 fd ff ff       	call   0 <fmtname>
 2a0:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a4:	89 74 24 10          	mov    %esi,0x10(%esp)
 2a8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2ac:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b0:	c7 44 24 04 3c 0b 00 	movl   $0xb3c,0x4(%esp)
 2b7:	00 
 2b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2bf:	e8 83 04 00 00       	call   747 <printf>
 2c4:	eb 01                	jmp    2c7 <ls+0x217>
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
 2c6:	90                   	nop
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2ce:	00 
 2cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 f6 02 00 00       	call   5da <read>
 2e4:	83 f8 10             	cmp    $0x10,%eax
 2e7:	0f 84 1a ff ff ff    	je     207 <ls+0x157>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2ed:	90                   	nop
  }
  close(fd);
 2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f1:	89 04 24             	mov    %eax,(%esp)
 2f4:	e8 f1 02 00 00       	call   5ea <close>
}
 2f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5f                   	pop    %edi
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    

00000304 <main>:

int
main(int argc, char *argv[])
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 e4 f0             	and    $0xfffffff0,%esp
 30a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 30d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 311:	7f 11                	jg     324 <main+0x20>
    ls(".");
 313:	c7 04 24 5c 0b 00 00 	movl   $0xb5c,(%esp)
 31a:	e8 91 fd ff ff       	call   b0 <ls>
    exit();
 31f:	e8 9e 02 00 00       	call   5c2 <exit>
  }
  for(i=1; i<argc; i++)
 324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 32b:	00 
 32c:	eb 1f                	jmp    34d <main+0x49>
    ls(argv[i]);
 32e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	01 d0                	add    %edx,%eax
 33e:	8b 00                	mov    (%eax),%eax
 340:	89 04 24             	mov    %eax,(%esp)
 343:	e8 68 fd ff ff       	call   b0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 34d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 351:	3b 45 08             	cmp    0x8(%ebp),%eax
 354:	7c d8                	jl     32e <main+0x2a>
    ls(argv[i]);
  exit();
 356:	e8 67 02 00 00       	call   5c2 <exit>

0000035b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	57                   	push   %edi
 35f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 360:	8b 4d 08             	mov    0x8(%ebp),%ecx
 363:	8b 55 10             	mov    0x10(%ebp),%edx
 366:	8b 45 0c             	mov    0xc(%ebp),%eax
 369:	89 cb                	mov    %ecx,%ebx
 36b:	89 df                	mov    %ebx,%edi
 36d:	89 d1                	mov    %edx,%ecx
 36f:	fc                   	cld    
 370:	f3 aa                	rep stos %al,%es:(%edi)
 372:	89 ca                	mov    %ecx,%edx
 374:	89 fb                	mov    %edi,%ebx
 376:	89 5d 08             	mov    %ebx,0x8(%ebp)
 379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37c:	5b                   	pop    %ebx
 37d:	5f                   	pop    %edi
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 38c:	90                   	nop
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	0f b6 10             	movzbl (%eax),%edx
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	88 10                	mov    %dl,(%eax)
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 00             	movzbl (%eax),%eax
 39e:	84 c0                	test   %al,%al
 3a0:	0f 95 c0             	setne  %al
 3a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3ab:	84 c0                	test   %al,%al
 3ad:	75 de                	jne    38d <strcpy+0xd>
    ;
  return os;
 3af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b2:	c9                   	leave  
 3b3:	c3                   	ret    

000003b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b7:	eb 08                	jmp    3c1 <strcmp+0xd>
    p++, q++;
 3b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	0f b6 00             	movzbl (%eax),%eax
 3c7:	84 c0                	test   %al,%al
 3c9:	74 10                	je     3db <strcmp+0x27>
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	0f b6 10             	movzbl (%eax),%edx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	38 c2                	cmp    %al,%dl
 3d9:	74 de                	je     3b9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	0f b6 00             	movzbl (%eax),%eax
 3e1:	0f b6 d0             	movzbl %al,%edx
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	0f b6 c0             	movzbl %al,%eax
 3ed:	89 d1                	mov    %edx,%ecx
 3ef:	29 c1                	sub    %eax,%ecx
 3f1:	89 c8                	mov    %ecx,%eax
}
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    

000003f5 <strlen>:

uint
strlen(char *s)
{
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 402:	eb 04                	jmp    408 <strlen+0x13>
 404:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 408:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	01 d0                	add    %edx,%eax
 410:	0f b6 00             	movzbl (%eax),%eax
 413:	84 c0                	test   %al,%al
 415:	75 ed                	jne    404 <strlen+0xf>
    ;
  return n;
 417:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <memset>:

void*
memset(void *dst, int c, uint n)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 422:	8b 45 10             	mov    0x10(%ebp),%eax
 425:	89 44 24 08          	mov    %eax,0x8(%esp)
 429:	8b 45 0c             	mov    0xc(%ebp),%eax
 42c:	89 44 24 04          	mov    %eax,0x4(%esp)
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	89 04 24             	mov    %eax,(%esp)
 436:	e8 20 ff ff ff       	call   35b <stosb>
  return dst;
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43e:	c9                   	leave  
 43f:	c3                   	ret    

00000440 <strchr>:

char*
strchr(const char *s, char c)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	83 ec 04             	sub    $0x4,%esp
 446:	8b 45 0c             	mov    0xc(%ebp),%eax
 449:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 44c:	eb 14                	jmp    462 <strchr+0x22>
    if(*s == c)
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	0f b6 00             	movzbl (%eax),%eax
 454:	3a 45 fc             	cmp    -0x4(%ebp),%al
 457:	75 05                	jne    45e <strchr+0x1e>
      return (char*)s;
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	eb 13                	jmp    471 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 45e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	0f b6 00             	movzbl (%eax),%eax
 468:	84 c0                	test   %al,%al
 46a:	75 e2                	jne    44e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 46c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 471:	c9                   	leave  
 472:	c3                   	ret    

00000473 <gets>:

char*
gets(char *buf, int max)
{
 473:	55                   	push   %ebp
 474:	89 e5                	mov    %esp,%ebp
 476:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 479:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 480:	eb 46                	jmp    4c8 <gets+0x55>
    cc = read(0, &c, 1);
 482:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 489:	00 
 48a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 48d:	89 44 24 04          	mov    %eax,0x4(%esp)
 491:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 498:	e8 3d 01 00 00       	call   5da <read>
 49d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a4:	7e 2f                	jle    4d5 <gets+0x62>
      break;
    buf[i++] = c;
 4a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	01 c2                	add    %eax,%edx
 4ae:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b2:	88 02                	mov    %al,(%edx)
 4b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 4b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4bc:	3c 0a                	cmp    $0xa,%al
 4be:	74 16                	je     4d6 <gets+0x63>
 4c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c4:	3c 0d                	cmp    $0xd,%al
 4c6:	74 0e                	je     4d6 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cb:	83 c0 01             	add    $0x1,%eax
 4ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4d1:	7c af                	jl     482 <gets+0xf>
 4d3:	eb 01                	jmp    4d6 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4d5:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	01 d0                	add    %edx,%eax
 4de:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e4:	c9                   	leave  
 4e5:	c3                   	ret    

000004e6 <stat>:

int
stat(char *n, struct stat *st)
{
 4e6:	55                   	push   %ebp
 4e7:	89 e5                	mov    %esp,%ebp
 4e9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4f3:	00 
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	89 04 24             	mov    %eax,(%esp)
 4fa:	e8 03 01 00 00       	call   602 <open>
 4ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 506:	79 07                	jns    50f <stat+0x29>
    return -1;
 508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 50d:	eb 23                	jmp    532 <stat+0x4c>
  r = fstat(fd, st);
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	89 44 24 04          	mov    %eax,0x4(%esp)
 516:	8b 45 f4             	mov    -0xc(%ebp),%eax
 519:	89 04 24             	mov    %eax,(%esp)
 51c:	e8 f9 00 00 00       	call   61a <fstat>
 521:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 524:	8b 45 f4             	mov    -0xc(%ebp),%eax
 527:	89 04 24             	mov    %eax,(%esp)
 52a:	e8 bb 00 00 00       	call   5ea <close>
  return r;
 52f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 532:	c9                   	leave  
 533:	c3                   	ret    

00000534 <atoi>:

int
atoi(const char *s)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 53a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 541:	eb 23                	jmp    566 <atoi+0x32>
    n = n*10 + *s++ - '0';
 543:	8b 55 fc             	mov    -0x4(%ebp),%edx
 546:	89 d0                	mov    %edx,%eax
 548:	c1 e0 02             	shl    $0x2,%eax
 54b:	01 d0                	add    %edx,%eax
 54d:	01 c0                	add    %eax,%eax
 54f:	89 c2                	mov    %eax,%edx
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	0f b6 00             	movzbl (%eax),%eax
 557:	0f be c0             	movsbl %al,%eax
 55a:	01 d0                	add    %edx,%eax
 55c:	83 e8 30             	sub    $0x30,%eax
 55f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 562:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 566:	8b 45 08             	mov    0x8(%ebp),%eax
 569:	0f b6 00             	movzbl (%eax),%eax
 56c:	3c 2f                	cmp    $0x2f,%al
 56e:	7e 0a                	jle    57a <atoi+0x46>
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	3c 39                	cmp    $0x39,%al
 578:	7e c9                	jle    543 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 57a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 57d:	c9                   	leave  
 57e:	c3                   	ret    

0000057f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 57f:	55                   	push   %ebp
 580:	89 e5                	mov    %esp,%ebp
 582:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 58b:	8b 45 0c             	mov    0xc(%ebp),%eax
 58e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 591:	eb 13                	jmp    5a6 <memmove+0x27>
    *dst++ = *src++;
 593:	8b 45 f8             	mov    -0x8(%ebp),%eax
 596:	0f b6 10             	movzbl (%eax),%edx
 599:	8b 45 fc             	mov    -0x4(%ebp),%eax
 59c:	88 10                	mov    %dl,(%eax)
 59e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5a2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5aa:	0f 9f c0             	setg   %al
 5ad:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5b1:	84 c0                	test   %al,%al
 5b3:	75 de                	jne    593 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b8:	c9                   	leave  
 5b9:	c3                   	ret    

000005ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ba:	b8 01 00 00 00       	mov    $0x1,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <exit>:
SYSCALL(exit)
 5c2:	b8 02 00 00 00       	mov    $0x2,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <wait>:
SYSCALL(wait)
 5ca:	b8 03 00 00 00       	mov    $0x3,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <pipe>:
SYSCALL(pipe)
 5d2:	b8 04 00 00 00       	mov    $0x4,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <read>:
SYSCALL(read)
 5da:	b8 05 00 00 00       	mov    $0x5,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <write>:
SYSCALL(write)
 5e2:	b8 10 00 00 00       	mov    $0x10,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <close>:
SYSCALL(close)
 5ea:	b8 15 00 00 00       	mov    $0x15,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <kill>:
SYSCALL(kill)
 5f2:	b8 06 00 00 00       	mov    $0x6,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <exec>:
SYSCALL(exec)
 5fa:	b8 07 00 00 00       	mov    $0x7,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <open>:
SYSCALL(open)
 602:	b8 0f 00 00 00       	mov    $0xf,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <mknod>:
SYSCALL(mknod)
 60a:	b8 11 00 00 00       	mov    $0x11,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <unlink>:
SYSCALL(unlink)
 612:	b8 12 00 00 00       	mov    $0x12,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <fstat>:
SYSCALL(fstat)
 61a:	b8 08 00 00 00       	mov    $0x8,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <link>:
SYSCALL(link)
 622:	b8 13 00 00 00       	mov    $0x13,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <mkdir>:
SYSCALL(mkdir)
 62a:	b8 14 00 00 00       	mov    $0x14,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <chdir>:
SYSCALL(chdir)
 632:	b8 09 00 00 00       	mov    $0x9,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <dup>:
SYSCALL(dup)
 63a:	b8 0a 00 00 00       	mov    $0xa,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <getpid>:
SYSCALL(getpid)
 642:	b8 0b 00 00 00       	mov    $0xb,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <sbrk>:
SYSCALL(sbrk)
 64a:	b8 0c 00 00 00       	mov    $0xc,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <sleep>:
SYSCALL(sleep)
 652:	b8 0d 00 00 00       	mov    $0xd,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <uptime>:
SYSCALL(uptime)
 65a:	b8 0e 00 00 00       	mov    $0xe,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <getprocs>:
SYSCALL(getprocs)
 662:	b8 16 00 00 00       	mov    $0x16,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 66a:	55                   	push   %ebp
 66b:	89 e5                	mov    %esp,%ebp
 66d:	83 ec 28             	sub    $0x28,%esp
 670:	8b 45 0c             	mov    0xc(%ebp),%eax
 673:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 676:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 67d:	00 
 67e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 681:	89 44 24 04          	mov    %eax,0x4(%esp)
 685:	8b 45 08             	mov    0x8(%ebp),%eax
 688:	89 04 24             	mov    %eax,(%esp)
 68b:	e8 52 ff ff ff       	call   5e2 <write>
}
 690:	c9                   	leave  
 691:	c3                   	ret    

00000692 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 692:	55                   	push   %ebp
 693:	89 e5                	mov    %esp,%ebp
 695:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 698:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 69f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6a3:	74 17                	je     6bc <printint+0x2a>
 6a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6a9:	79 11                	jns    6bc <printint+0x2a>
    neg = 1;
 6ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b5:	f7 d8                	neg    %eax
 6b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6ba:	eb 06                	jmp    6c2 <printint+0x30>
  } else {
    x = xx;
 6bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6cf:	ba 00 00 00 00       	mov    $0x0,%edx
 6d4:	f7 f1                	div    %ecx
 6d6:	89 d0                	mov    %edx,%eax
 6d8:	0f b6 80 f8 0d 00 00 	movzbl 0xdf8(%eax),%eax
 6df:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6e5:	01 ca                	add    %ecx,%edx
 6e7:	88 02                	mov    %al,(%edx)
 6e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 6ed:	8b 55 10             	mov    0x10(%ebp),%edx
 6f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f6:	ba 00 00 00 00       	mov    $0x0,%edx
 6fb:	f7 75 d4             	divl   -0x2c(%ebp)
 6fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
 701:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 705:	75 c2                	jne    6c9 <printint+0x37>
  if(neg)
 707:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70b:	74 2e                	je     73b <printint+0xa9>
    buf[i++] = '-';
 70d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 710:	8b 45 f4             	mov    -0xc(%ebp),%eax
 713:	01 d0                	add    %edx,%eax
 715:	c6 00 2d             	movb   $0x2d,(%eax)
 718:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 71c:	eb 1d                	jmp    73b <printint+0xa9>
    putc(fd, buf[i]);
 71e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 721:	8b 45 f4             	mov    -0xc(%ebp),%eax
 724:	01 d0                	add    %edx,%eax
 726:	0f b6 00             	movzbl (%eax),%eax
 729:	0f be c0             	movsbl %al,%eax
 72c:	89 44 24 04          	mov    %eax,0x4(%esp)
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	89 04 24             	mov    %eax,(%esp)
 736:	e8 2f ff ff ff       	call   66a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 73b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 73f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 743:	79 d9                	jns    71e <printint+0x8c>
    putc(fd, buf[i]);
}
 745:	c9                   	leave  
 746:	c3                   	ret    

00000747 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 747:	55                   	push   %ebp
 748:	89 e5                	mov    %esp,%ebp
 74a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 74d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 754:	8d 45 0c             	lea    0xc(%ebp),%eax
 757:	83 c0 04             	add    $0x4,%eax
 75a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 75d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 764:	e9 7d 01 00 00       	jmp    8e6 <printf+0x19f>
    c = fmt[i] & 0xff;
 769:	8b 55 0c             	mov    0xc(%ebp),%edx
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	01 d0                	add    %edx,%eax
 771:	0f b6 00             	movzbl (%eax),%eax
 774:	0f be c0             	movsbl %al,%eax
 777:	25 ff 00 00 00       	and    $0xff,%eax
 77c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 77f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 783:	75 2c                	jne    7b1 <printf+0x6a>
      if(c == '%'){
 785:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 789:	75 0c                	jne    797 <printf+0x50>
        state = '%';
 78b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 792:	e9 4b 01 00 00       	jmp    8e2 <printf+0x19b>
      } else {
        putc(fd, c);
 797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 79a:	0f be c0             	movsbl %al,%eax
 79d:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a1:	8b 45 08             	mov    0x8(%ebp),%eax
 7a4:	89 04 24             	mov    %eax,(%esp)
 7a7:	e8 be fe ff ff       	call   66a <putc>
 7ac:	e9 31 01 00 00       	jmp    8e2 <printf+0x19b>
      }
    } else if(state == '%'){
 7b1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7b5:	0f 85 27 01 00 00    	jne    8e2 <printf+0x19b>
      if(c == 'd'){
 7bb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7bf:	75 2d                	jne    7ee <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7cd:	00 
 7ce:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7d5:	00 
 7d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 7da:	8b 45 08             	mov    0x8(%ebp),%eax
 7dd:	89 04 24             	mov    %eax,(%esp)
 7e0:	e8 ad fe ff ff       	call   692 <printint>
        ap++;
 7e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e9:	e9 ed 00 00 00       	jmp    8db <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 7ee:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7f2:	74 06                	je     7fa <printf+0xb3>
 7f4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7f8:	75 2d                	jne    827 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7fd:	8b 00                	mov    (%eax),%eax
 7ff:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 806:	00 
 807:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 80e:	00 
 80f:	89 44 24 04          	mov    %eax,0x4(%esp)
 813:	8b 45 08             	mov    0x8(%ebp),%eax
 816:	89 04 24             	mov    %eax,(%esp)
 819:	e8 74 fe ff ff       	call   692 <printint>
        ap++;
 81e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 822:	e9 b4 00 00 00       	jmp    8db <printf+0x194>
      } else if(c == 's'){
 827:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 82b:	75 46                	jne    873 <printf+0x12c>
        s = (char*)*ap;
 82d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 835:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83d:	75 27                	jne    866 <printf+0x11f>
          s = "(null)";
 83f:	c7 45 f4 5e 0b 00 00 	movl   $0xb5e,-0xc(%ebp)
        while(*s != 0){
 846:	eb 1e                	jmp    866 <printf+0x11f>
          putc(fd, *s);
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	0f b6 00             	movzbl (%eax),%eax
 84e:	0f be c0             	movsbl %al,%eax
 851:	89 44 24 04          	mov    %eax,0x4(%esp)
 855:	8b 45 08             	mov    0x8(%ebp),%eax
 858:	89 04 24             	mov    %eax,(%esp)
 85b:	e8 0a fe ff ff       	call   66a <putc>
          s++;
 860:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 864:	eb 01                	jmp    867 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 866:	90                   	nop
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	0f b6 00             	movzbl (%eax),%eax
 86d:	84 c0                	test   %al,%al
 86f:	75 d7                	jne    848 <printf+0x101>
 871:	eb 68                	jmp    8db <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 873:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 877:	75 1d                	jne    896 <printf+0x14f>
        putc(fd, *ap);
 879:	8b 45 e8             	mov    -0x18(%ebp),%eax
 87c:	8b 00                	mov    (%eax),%eax
 87e:	0f be c0             	movsbl %al,%eax
 881:	89 44 24 04          	mov    %eax,0x4(%esp)
 885:	8b 45 08             	mov    0x8(%ebp),%eax
 888:	89 04 24             	mov    %eax,(%esp)
 88b:	e8 da fd ff ff       	call   66a <putc>
        ap++;
 890:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 894:	eb 45                	jmp    8db <printf+0x194>
      } else if(c == '%'){
 896:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 89a:	75 17                	jne    8b3 <printf+0x16c>
        putc(fd, c);
 89c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 89f:	0f be c0             	movsbl %al,%eax
 8a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a6:	8b 45 08             	mov    0x8(%ebp),%eax
 8a9:	89 04 24             	mov    %eax,(%esp)
 8ac:	e8 b9 fd ff ff       	call   66a <putc>
 8b1:	eb 28                	jmp    8db <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8b3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8ba:	00 
 8bb:	8b 45 08             	mov    0x8(%ebp),%eax
 8be:	89 04 24             	mov    %eax,(%esp)
 8c1:	e8 a4 fd ff ff       	call   66a <putc>
        putc(fd, c);
 8c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c9:	0f be c0             	movsbl %al,%eax
 8cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d0:	8b 45 08             	mov    0x8(%ebp),%eax
 8d3:	89 04 24             	mov    %eax,(%esp)
 8d6:	e8 8f fd ff ff       	call   66a <putc>
      }
      state = 0;
 8db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8e2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8e6:	8b 55 0c             	mov    0xc(%ebp),%edx
 8e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ec:	01 d0                	add    %edx,%eax
 8ee:	0f b6 00             	movzbl (%eax),%eax
 8f1:	84 c0                	test   %al,%al
 8f3:	0f 85 70 fe ff ff    	jne    769 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8f9:	c9                   	leave  
 8fa:	c3                   	ret    

000008fb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fb:	55                   	push   %ebp
 8fc:	89 e5                	mov    %esp,%ebp
 8fe:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 901:	8b 45 08             	mov    0x8(%ebp),%eax
 904:	83 e8 08             	sub    $0x8,%eax
 907:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90a:	a1 24 0e 00 00       	mov    0xe24,%eax
 90f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 912:	eb 24                	jmp    938 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 914:	8b 45 fc             	mov    -0x4(%ebp),%eax
 917:	8b 00                	mov    (%eax),%eax
 919:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91c:	77 12                	ja     930 <free+0x35>
 91e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 921:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 924:	77 24                	ja     94a <free+0x4f>
 926:	8b 45 fc             	mov    -0x4(%ebp),%eax
 929:	8b 00                	mov    (%eax),%eax
 92b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 92e:	77 1a                	ja     94a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 930:	8b 45 fc             	mov    -0x4(%ebp),%eax
 933:	8b 00                	mov    (%eax),%eax
 935:	89 45 fc             	mov    %eax,-0x4(%ebp)
 938:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 93e:	76 d4                	jbe    914 <free+0x19>
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 948:	76 ca                	jbe    914 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 94a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94d:	8b 40 04             	mov    0x4(%eax),%eax
 950:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 957:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95a:	01 c2                	add    %eax,%edx
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8b 00                	mov    (%eax),%eax
 961:	39 c2                	cmp    %eax,%edx
 963:	75 24                	jne    989 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 965:	8b 45 f8             	mov    -0x8(%ebp),%eax
 968:	8b 50 04             	mov    0x4(%eax),%edx
 96b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96e:	8b 00                	mov    (%eax),%eax
 970:	8b 40 04             	mov    0x4(%eax),%eax
 973:	01 c2                	add    %eax,%edx
 975:	8b 45 f8             	mov    -0x8(%ebp),%eax
 978:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 97b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97e:	8b 00                	mov    (%eax),%eax
 980:	8b 10                	mov    (%eax),%edx
 982:	8b 45 f8             	mov    -0x8(%ebp),%eax
 985:	89 10                	mov    %edx,(%eax)
 987:	eb 0a                	jmp    993 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 989:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98c:	8b 10                	mov    (%eax),%edx
 98e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 991:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 993:	8b 45 fc             	mov    -0x4(%ebp),%eax
 996:	8b 40 04             	mov    0x4(%eax),%eax
 999:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a3:	01 d0                	add    %edx,%eax
 9a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9a8:	75 20                	jne    9ca <free+0xcf>
    p->s.size += bp->s.size;
 9aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ad:	8b 50 04             	mov    0x4(%eax),%edx
 9b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b3:	8b 40 04             	mov    0x4(%eax),%eax
 9b6:	01 c2                	add    %eax,%edx
 9b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c1:	8b 10                	mov    (%eax),%edx
 9c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c6:	89 10                	mov    %edx,(%eax)
 9c8:	eb 08                	jmp    9d2 <free+0xd7>
  } else
    p->s.ptr = bp;
 9ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9d0:	89 10                	mov    %edx,(%eax)
  freep = p;
 9d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d5:	a3 24 0e 00 00       	mov    %eax,0xe24
}
 9da:	c9                   	leave  
 9db:	c3                   	ret    

000009dc <morecore>:

static Header*
morecore(uint nu)
{
 9dc:	55                   	push   %ebp
 9dd:	89 e5                	mov    %esp,%ebp
 9df:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9e2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9e9:	77 07                	ja     9f2 <morecore+0x16>
    nu = 4096;
 9eb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9f2:	8b 45 08             	mov    0x8(%ebp),%eax
 9f5:	c1 e0 03             	shl    $0x3,%eax
 9f8:	89 04 24             	mov    %eax,(%esp)
 9fb:	e8 4a fc ff ff       	call   64a <sbrk>
 a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a03:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a07:	75 07                	jne    a10 <morecore+0x34>
    return 0;
 a09:	b8 00 00 00 00       	mov    $0x0,%eax
 a0e:	eb 22                	jmp    a32 <morecore+0x56>
  hp = (Header*)p;
 a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a19:	8b 55 08             	mov    0x8(%ebp),%edx
 a1c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a22:	83 c0 08             	add    $0x8,%eax
 a25:	89 04 24             	mov    %eax,(%esp)
 a28:	e8 ce fe ff ff       	call   8fb <free>
  return freep;
 a2d:	a1 24 0e 00 00       	mov    0xe24,%eax
}
 a32:	c9                   	leave  
 a33:	c3                   	ret    

00000a34 <malloc>:

void*
malloc(uint nbytes)
{
 a34:	55                   	push   %ebp
 a35:	89 e5                	mov    %esp,%ebp
 a37:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a3a:	8b 45 08             	mov    0x8(%ebp),%eax
 a3d:	83 c0 07             	add    $0x7,%eax
 a40:	c1 e8 03             	shr    $0x3,%eax
 a43:	83 c0 01             	add    $0x1,%eax
 a46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a49:	a1 24 0e 00 00       	mov    0xe24,%eax
 a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a55:	75 23                	jne    a7a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a57:	c7 45 f0 1c 0e 00 00 	movl   $0xe1c,-0x10(%ebp)
 a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a61:	a3 24 0e 00 00       	mov    %eax,0xe24
 a66:	a1 24 0e 00 00       	mov    0xe24,%eax
 a6b:	a3 1c 0e 00 00       	mov    %eax,0xe1c
    base.s.size = 0;
 a70:	c7 05 20 0e 00 00 00 	movl   $0x0,0xe20
 a77:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7d:	8b 00                	mov    (%eax),%eax
 a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a85:	8b 40 04             	mov    0x4(%eax),%eax
 a88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a8b:	72 4d                	jb     ada <malloc+0xa6>
      if(p->s.size == nunits)
 a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a90:	8b 40 04             	mov    0x4(%eax),%eax
 a93:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a96:	75 0c                	jne    aa4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9b:	8b 10                	mov    (%eax),%edx
 a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa0:	89 10                	mov    %edx,(%eax)
 aa2:	eb 26                	jmp    aca <malloc+0x96>
      else {
        p->s.size -= nunits;
 aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa7:	8b 40 04             	mov    0x4(%eax),%eax
 aaa:	89 c2                	mov    %eax,%edx
 aac:	2b 55 ec             	sub    -0x14(%ebp),%edx
 aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab8:	8b 40 04             	mov    0x4(%eax),%eax
 abb:	c1 e0 03             	shl    $0x3,%eax
 abe:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ac7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acd:	a3 24 0e 00 00       	mov    %eax,0xe24
      return (void*)(p + 1);
 ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad5:	83 c0 08             	add    $0x8,%eax
 ad8:	eb 38                	jmp    b12 <malloc+0xde>
    }
    if(p == freep)
 ada:	a1 24 0e 00 00       	mov    0xe24,%eax
 adf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ae2:	75 1b                	jne    aff <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ae7:	89 04 24             	mov    %eax,(%esp)
 aea:	e8 ed fe ff ff       	call   9dc <morecore>
 aef:	89 45 f4             	mov    %eax,-0xc(%ebp)
 af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 af6:	75 07                	jne    aff <malloc+0xcb>
        return 0;
 af8:	b8 00 00 00 00       	mov    $0x0,%eax
 afd:	eb 13                	jmp    b12 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b08:	8b 00                	mov    (%eax),%eax
 b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b0d:	e9 70 ff ff ff       	jmp    a82 <malloc+0x4e>
}
 b12:	c9                   	leave  
 b13:	c3                   	ret    
