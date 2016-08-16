
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 51 0f 00 00       	call   f62 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 e0 14 00 00 	mov    0x14e0(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 b4 14 00 00 	movl   $0x14b4,(%esp)
      2b:	e8 2a 03 00 00       	call   35a <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      36:	8b 45 f4             	mov    -0xc(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      exit();
      40:	e8 1d 0f 00 00       	call   f62 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 3d 0f 00 00       	call   f9a <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 bb 14 00 	movl   $0x14bb,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 6c 10 00 00       	call   10e7 <printf>
    break;
      7b:	e9 84 01 00 00       	jmp    204 <runcmd+0x204>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 f6 0e 00 00       	call   f8a <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 f6 0e 00 00       	call   fa2 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 cb 14 00 	movl   $0x14cb,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 19 10 00 00       	call   10e7 <printf>
      exit();
      ce:	e8 8f 0e 00 00       	call   f62 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	89 04 24             	mov    %eax,(%esp)
      dc:	e8 1f ff ff ff       	call   0 <runcmd>
    break;
      e1:	e9 1e 01 00 00       	jmp    204 <runcmd+0x204>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      e6:	8b 45 08             	mov    0x8(%ebp),%eax
      e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      ec:	e8 8f 02 00 00       	call   380 <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 62 0e 00 00       	call   f6a <wait>
    runcmd(lcmd->right);
     108:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10b:	8b 40 08             	mov    0x8(%eax),%eax
     10e:	89 04 24             	mov    %eax,(%esp)
     111:	e8 ea fe ff ff       	call   0 <runcmd>
    break;
     116:	e9 e9 00 00 00       	jmp    204 <runcmd+0x204>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     11b:	8b 45 08             	mov    0x8(%ebp),%eax
     11e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     121:	8d 45 dc             	lea    -0x24(%ebp),%eax
     124:	89 04 24             	mov    %eax,(%esp)
     127:	e8 46 0e 00 00       	call   f72 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 db 14 00 00 	movl   $0x14db,(%esp)
     137:	e8 1e 02 00 00       	call   35a <panic>
    if(fork1() == 0){
     13c:	e8 3f 02 00 00       	call   380 <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 39 0e 00 00       	call   f8a <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 7e 0e 00 00       	call   fda <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 23 0e 00 00       	call   f8a <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 18 0e 00 00       	call   f8a <close>
      runcmd(pcmd->left);
     172:	8b 45 e8             	mov    -0x18(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 fb 01 00 00       	call   380 <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 f5 0d 00 00       	call   f8a <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 3a 0e 00 00       	call   fda <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 df 0d 00 00       	call   f8a <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 d4 0d 00 00       	call   f8a <close>
      runcmd(pcmd->right);
     1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 bb 0d 00 00       	call   f8a <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 b0 0d 00 00       	call   f8a <close>
    wait();
     1da:	e8 8b 0d 00 00       	call   f6a <wait>
    wait();
     1df:	e8 86 0d 00 00       	call   f6a <wait>
    break;
     1e4:	eb 1e                	jmp    204 <runcmd+0x204>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 8f 01 00 00       	call   380 <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	75 0e                	jne    203 <runcmd+0x203>
      runcmd(bcmd->cmd);
     1f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f8:	8b 40 04             	mov    0x4(%eax),%eax
     1fb:	89 04 24             	mov    %eax,(%esp)
     1fe:	e8 fd fd ff ff       	call   0 <runcmd>
    break;
     203:	90                   	nop
  }
  exit();
     204:	e8 59 0d 00 00       	call   f62 <exit>

00000209 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     209:	55                   	push   %ebp
     20a:	89 e5                	mov    %esp,%ebp
     20c:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     20f:	c7 44 24 04 f8 14 00 	movl   $0x14f8,0x4(%esp)
     216:	00 
     217:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     21e:	e8 c4 0e 00 00       	call   10e7 <printf>
  memset(buf, 0, nbuf);
     223:	8b 45 0c             	mov    0xc(%ebp),%eax
     226:	89 44 24 08          	mov    %eax,0x8(%esp)
     22a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     231:	00 
     232:	8b 45 08             	mov    0x8(%ebp),%eax
     235:	89 04 24             	mov    %eax,(%esp)
     238:	e8 7f 0b 00 00       	call   dbc <memset>
  gets(buf, nbuf);
     23d:	8b 45 0c             	mov    0xc(%ebp),%eax
     240:	89 44 24 04          	mov    %eax,0x4(%esp)
     244:	8b 45 08             	mov    0x8(%ebp),%eax
     247:	89 04 24             	mov    %eax,(%esp)
     24a:	e8 c4 0b 00 00       	call   e13 <gets>
  if(buf[0] == 0) // EOF
     24f:	8b 45 08             	mov    0x8(%ebp),%eax
     252:	0f b6 00             	movzbl (%eax),%eax
     255:	84 c0                	test   %al,%al
     257:	75 07                	jne    260 <getcmd+0x57>
    return -1;
     259:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     25e:	eb 05                	jmp    265 <getcmd+0x5c>
  return 0;
     260:	b8 00 00 00 00       	mov    $0x0,%eax
}
     265:	c9                   	leave  
     266:	c3                   	ret    

00000267 <main>:

int
main(void)
{
     267:	55                   	push   %ebp
     268:	89 e5                	mov    %esp,%ebp
     26a:	83 e4 f0             	and    $0xfffffff0,%esp
     26d:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     270:	eb 19                	jmp    28b <main+0x24>
    if(fd >= 3){
     272:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     277:	7e 12                	jle    28b <main+0x24>
      close(fd);
     279:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     27d:	89 04 24             	mov    %eax,(%esp)
     280:	e8 05 0d 00 00       	call   f8a <close>
      break;
     285:	90                   	nop
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     286:	e9 ae 00 00 00       	jmp    339 <main+0xd2>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     28b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     292:	00 
     293:	c7 04 24 fb 14 00 00 	movl   $0x14fb,(%esp)
     29a:	e8 03 0d 00 00       	call   fa2 <open>
     29f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2a3:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2a8:	79 c8                	jns    272 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2aa:	e9 8a 00 00 00       	jmp    339 <main+0xd2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2af:	0f b6 05 60 1a 00 00 	movzbl 0x1a60,%eax
     2b6:	3c 63                	cmp    $0x63,%al
     2b8:	75 5a                	jne    314 <main+0xad>
     2ba:	0f b6 05 61 1a 00 00 	movzbl 0x1a61,%eax
     2c1:	3c 64                	cmp    $0x64,%al
     2c3:	75 4f                	jne    314 <main+0xad>
     2c5:	0f b6 05 62 1a 00 00 	movzbl 0x1a62,%eax
     2cc:	3c 20                	cmp    $0x20,%al
     2ce:	75 44                	jne    314 <main+0xad>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2d0:	c7 04 24 60 1a 00 00 	movl   $0x1a60,(%esp)
     2d7:	e8 b9 0a 00 00       	call   d95 <strlen>
     2dc:	83 e8 01             	sub    $0x1,%eax
     2df:	c6 80 60 1a 00 00 00 	movb   $0x0,0x1a60(%eax)
      if(chdir(buf+3) < 0)
     2e6:	c7 04 24 63 1a 00 00 	movl   $0x1a63,(%esp)
     2ed:	e8 e0 0c 00 00       	call   fd2 <chdir>
     2f2:	85 c0                	test   %eax,%eax
     2f4:	79 42                	jns    338 <main+0xd1>
        printf(2, "cannot cd %s\n", buf+3);
     2f6:	c7 44 24 08 63 1a 00 	movl   $0x1a63,0x8(%esp)
     2fd:	00 
     2fe:	c7 44 24 04 03 15 00 	movl   $0x1503,0x4(%esp)
     305:	00 
     306:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     30d:	e8 d5 0d 00 00       	call   10e7 <printf>
      continue;
     312:	eb 24                	jmp    338 <main+0xd1>
    }
    if(fork1() == 0)
     314:	e8 67 00 00 00       	call   380 <fork1>
     319:	85 c0                	test   %eax,%eax
     31b:	75 14                	jne    331 <main+0xca>
      runcmd(parsecmd(buf));
     31d:	c7 04 24 60 1a 00 00 	movl   $0x1a60,(%esp)
     324:	e8 c9 03 00 00       	call   6f2 <parsecmd>
     329:	89 04 24             	mov    %eax,(%esp)
     32c:	e8 cf fc ff ff       	call   0 <runcmd>
    wait();
     331:	e8 34 0c 00 00       	call   f6a <wait>
     336:	eb 01                	jmp    339 <main+0xd2>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
     338:	90                   	nop
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     339:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     340:	00 
     341:	c7 04 24 60 1a 00 00 	movl   $0x1a60,(%esp)
     348:	e8 bc fe ff ff       	call   209 <getcmd>
     34d:	85 c0                	test   %eax,%eax
     34f:	0f 89 5a ff ff ff    	jns    2af <main+0x48>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     355:	e8 08 0c 00 00       	call   f62 <exit>

0000035a <panic>:
}

void
panic(char *s)
{
     35a:	55                   	push   %ebp
     35b:	89 e5                	mov    %esp,%ebp
     35d:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     360:	8b 45 08             	mov    0x8(%ebp),%eax
     363:	89 44 24 08          	mov    %eax,0x8(%esp)
     367:	c7 44 24 04 11 15 00 	movl   $0x1511,0x4(%esp)
     36e:	00 
     36f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     376:	e8 6c 0d 00 00       	call   10e7 <printf>
  exit();
     37b:	e8 e2 0b 00 00       	call   f62 <exit>

00000380 <fork1>:
}

int
fork1(void)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     386:	e8 cf 0b 00 00       	call   f5a <fork>
     38b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     38e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     392:	75 0c                	jne    3a0 <fork1+0x20>
    panic("fork");
     394:	c7 04 24 15 15 00 00 	movl   $0x1515,(%esp)
     39b:	e8 ba ff ff ff       	call   35a <panic>
  return pid;
     3a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3a3:	c9                   	leave  
     3a4:	c3                   	ret    

000003a5 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3a5:	55                   	push   %ebp
     3a6:	89 e5                	mov    %esp,%ebp
     3a8:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ab:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3b2:	e8 1d 10 00 00       	call   13d4 <malloc>
     3b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3ba:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3c1:	00 
     3c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c9:	00 
     3ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3cd:	89 04 24             	mov    %eax,(%esp)
     3d0:	e8 e7 09 00 00       	call   dbc <memset>
  cmd->type = EXEC;
     3d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     3de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3e1:	c9                   	leave  
     3e2:	c3                   	ret    

000003e3 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3e3:	55                   	push   %ebp
     3e4:	89 e5                	mov    %esp,%ebp
     3e6:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e9:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3f0:	e8 df 0f 00 00       	call   13d4 <malloc>
     3f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3f8:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3ff:	00 
     400:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     407:	00 
     408:	8b 45 f4             	mov    -0xc(%ebp),%eax
     40b:	89 04 24             	mov    %eax,(%esp)
     40e:	e8 a9 09 00 00       	call   dbc <memset>
  cmd->type = REDIR;
     413:	8b 45 f4             	mov    -0xc(%ebp),%eax
     416:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     41c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41f:	8b 55 08             	mov    0x8(%ebp),%edx
     422:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     425:	8b 45 f4             	mov    -0xc(%ebp),%eax
     428:	8b 55 0c             	mov    0xc(%ebp),%edx
     42b:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     42e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     431:	8b 55 10             	mov    0x10(%ebp),%edx
     434:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     437:	8b 45 f4             	mov    -0xc(%ebp),%eax
     43a:	8b 55 14             	mov    0x14(%ebp),%edx
     43d:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     440:	8b 45 f4             	mov    -0xc(%ebp),%eax
     443:	8b 55 18             	mov    0x18(%ebp),%edx
     446:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     449:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     44c:	c9                   	leave  
     44d:	c3                   	ret    

0000044e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     44e:	55                   	push   %ebp
     44f:	89 e5                	mov    %esp,%ebp
     451:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     454:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     45b:	e8 74 0f 00 00       	call   13d4 <malloc>
     460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     463:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     46a:	00 
     46b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     472:	00 
     473:	8b 45 f4             	mov    -0xc(%ebp),%eax
     476:	89 04 24             	mov    %eax,(%esp)
     479:	e8 3e 09 00 00       	call   dbc <memset>
  cmd->type = PIPE;
     47e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     481:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     487:	8b 45 f4             	mov    -0xc(%ebp),%eax
     48a:	8b 55 08             	mov    0x8(%ebp),%edx
     48d:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     490:	8b 45 f4             	mov    -0xc(%ebp),%eax
     493:	8b 55 0c             	mov    0xc(%ebp),%edx
     496:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     499:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     49c:	c9                   	leave  
     49d:	c3                   	ret    

0000049e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     49e:	55                   	push   %ebp
     49f:	89 e5                	mov    %esp,%ebp
     4a1:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     4ab:	e8 24 0f 00 00       	call   13d4 <malloc>
     4b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4b3:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4ba:	00 
     4bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4c2:	00 
     4c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c6:	89 04 24             	mov    %eax,(%esp)
     4c9:	e8 ee 08 00 00       	call   dbc <memset>
  cmd->type = LIST;
     4ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d1:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4da:	8b 55 08             	mov    0x8(%ebp),%edx
     4dd:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e3:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e6:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4ec:	c9                   	leave  
     4ed:	c3                   	ret    

000004ee <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4ee:	55                   	push   %ebp
     4ef:	89 e5                	mov    %esp,%ebp
     4f1:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     4fb:	e8 d4 0e 00 00       	call   13d4 <malloc>
     500:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     503:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     50a:	00 
     50b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     512:	00 
     513:	8b 45 f4             	mov    -0xc(%ebp),%eax
     516:	89 04 24             	mov    %eax,(%esp)
     519:	e8 9e 08 00 00       	call   dbc <memset>
  cmd->type = BACK;
     51e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     521:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     527:	8b 45 f4             	mov    -0xc(%ebp),%eax
     52a:	8b 55 08             	mov    0x8(%ebp),%edx
     52d:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     530:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     533:	c9                   	leave  
     534:	c3                   	ret    

00000535 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     535:	55                   	push   %ebp
     536:	89 e5                	mov    %esp,%ebp
     538:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     53b:	8b 45 08             	mov    0x8(%ebp),%eax
     53e:	8b 00                	mov    (%eax),%eax
     540:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     543:	eb 04                	jmp    549 <gettoken+0x14>
    s++;
     545:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     549:	8b 45 f4             	mov    -0xc(%ebp),%eax
     54c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     54f:	73 1d                	jae    56e <gettoken+0x39>
     551:	8b 45 f4             	mov    -0xc(%ebp),%eax
     554:	0f b6 00             	movzbl (%eax),%eax
     557:	0f be c0             	movsbl %al,%eax
     55a:	89 44 24 04          	mov    %eax,0x4(%esp)
     55e:	c7 04 24 24 1a 00 00 	movl   $0x1a24,(%esp)
     565:	e8 76 08 00 00       	call   de0 <strchr>
     56a:	85 c0                	test   %eax,%eax
     56c:	75 d7                	jne    545 <gettoken+0x10>
    s++;
  if(q)
     56e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     572:	74 08                	je     57c <gettoken+0x47>
    *q = s;
     574:	8b 45 10             	mov    0x10(%ebp),%eax
     577:	8b 55 f4             	mov    -0xc(%ebp),%edx
     57a:	89 10                	mov    %edx,(%eax)
  ret = *s;
     57c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     57f:	0f b6 00             	movzbl (%eax),%eax
     582:	0f be c0             	movsbl %al,%eax
     585:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     588:	8b 45 f4             	mov    -0xc(%ebp),%eax
     58b:	0f b6 00             	movzbl (%eax),%eax
     58e:	0f be c0             	movsbl %al,%eax
     591:	83 f8 3c             	cmp    $0x3c,%eax
     594:	7f 1e                	jg     5b4 <gettoken+0x7f>
     596:	83 f8 3b             	cmp    $0x3b,%eax
     599:	7d 23                	jge    5be <gettoken+0x89>
     59b:	83 f8 29             	cmp    $0x29,%eax
     59e:	7f 3f                	jg     5df <gettoken+0xaa>
     5a0:	83 f8 28             	cmp    $0x28,%eax
     5a3:	7d 19                	jge    5be <gettoken+0x89>
     5a5:	85 c0                	test   %eax,%eax
     5a7:	0f 84 83 00 00 00    	je     630 <gettoken+0xfb>
     5ad:	83 f8 26             	cmp    $0x26,%eax
     5b0:	74 0c                	je     5be <gettoken+0x89>
     5b2:	eb 2b                	jmp    5df <gettoken+0xaa>
     5b4:	83 f8 3e             	cmp    $0x3e,%eax
     5b7:	74 0b                	je     5c4 <gettoken+0x8f>
     5b9:	83 f8 7c             	cmp    $0x7c,%eax
     5bc:	75 21                	jne    5df <gettoken+0xaa>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5c2:	eb 73                	jmp    637 <gettoken+0x102>
  case '>':
    s++;
     5c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cb:	0f b6 00             	movzbl (%eax),%eax
     5ce:	3c 3e                	cmp    $0x3e,%al
     5d0:	75 61                	jne    633 <gettoken+0xfe>
      ret = '+';
     5d2:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     5dd:	eb 54                	jmp    633 <gettoken+0xfe>
  default:
    ret = 'a';
     5df:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5e6:	eb 04                	jmp    5ec <gettoken+0xb7>
      s++;
     5e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f2:	73 42                	jae    636 <gettoken+0x101>
     5f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f7:	0f b6 00             	movzbl (%eax),%eax
     5fa:	0f be c0             	movsbl %al,%eax
     5fd:	89 44 24 04          	mov    %eax,0x4(%esp)
     601:	c7 04 24 24 1a 00 00 	movl   $0x1a24,(%esp)
     608:	e8 d3 07 00 00       	call   de0 <strchr>
     60d:	85 c0                	test   %eax,%eax
     60f:	75 25                	jne    636 <gettoken+0x101>
     611:	8b 45 f4             	mov    -0xc(%ebp),%eax
     614:	0f b6 00             	movzbl (%eax),%eax
     617:	0f be c0             	movsbl %al,%eax
     61a:	89 44 24 04          	mov    %eax,0x4(%esp)
     61e:	c7 04 24 2a 1a 00 00 	movl   $0x1a2a,(%esp)
     625:	e8 b6 07 00 00       	call   de0 <strchr>
     62a:	85 c0                	test   %eax,%eax
     62c:	74 ba                	je     5e8 <gettoken+0xb3>
      s++;
    break;
     62e:	eb 06                	jmp    636 <gettoken+0x101>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     630:	90                   	nop
     631:	eb 04                	jmp    637 <gettoken+0x102>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     633:	90                   	nop
     634:	eb 01                	jmp    637 <gettoken+0x102>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     636:	90                   	nop
  }
  if(eq)
     637:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     63b:	74 0e                	je     64b <gettoken+0x116>
    *eq = s;
     63d:	8b 45 14             	mov    0x14(%ebp),%eax
     640:	8b 55 f4             	mov    -0xc(%ebp),%edx
     643:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     645:	eb 04                	jmp    64b <gettoken+0x116>
    s++;
     647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     651:	73 1d                	jae    670 <gettoken+0x13b>
     653:	8b 45 f4             	mov    -0xc(%ebp),%eax
     656:	0f b6 00             	movzbl (%eax),%eax
     659:	0f be c0             	movsbl %al,%eax
     65c:	89 44 24 04          	mov    %eax,0x4(%esp)
     660:	c7 04 24 24 1a 00 00 	movl   $0x1a24,(%esp)
     667:	e8 74 07 00 00       	call   de0 <strchr>
     66c:	85 c0                	test   %eax,%eax
     66e:	75 d7                	jne    647 <gettoken+0x112>
    s++;
  *ps = s;
     670:	8b 45 08             	mov    0x8(%ebp),%eax
     673:	8b 55 f4             	mov    -0xc(%ebp),%edx
     676:	89 10                	mov    %edx,(%eax)
  return ret;
     678:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     67b:	c9                   	leave  
     67c:	c3                   	ret    

0000067d <peek>:

int
peek(char **ps, char *es, char *toks)
{
     67d:	55                   	push   %ebp
     67e:	89 e5                	mov    %esp,%ebp
     680:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     683:	8b 45 08             	mov    0x8(%ebp),%eax
     686:	8b 00                	mov    (%eax),%eax
     688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     68b:	eb 04                	jmp    691 <peek+0x14>
    s++;
     68d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     691:	8b 45 f4             	mov    -0xc(%ebp),%eax
     694:	3b 45 0c             	cmp    0xc(%ebp),%eax
     697:	73 1d                	jae    6b6 <peek+0x39>
     699:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69c:	0f b6 00             	movzbl (%eax),%eax
     69f:	0f be c0             	movsbl %al,%eax
     6a2:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a6:	c7 04 24 24 1a 00 00 	movl   $0x1a24,(%esp)
     6ad:	e8 2e 07 00 00       	call   de0 <strchr>
     6b2:	85 c0                	test   %eax,%eax
     6b4:	75 d7                	jne    68d <peek+0x10>
    s++;
  *ps = s;
     6b6:	8b 45 08             	mov    0x8(%ebp),%eax
     6b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6bc:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c1:	0f b6 00             	movzbl (%eax),%eax
     6c4:	84 c0                	test   %al,%al
     6c6:	74 23                	je     6eb <peek+0x6e>
     6c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cb:	0f b6 00             	movzbl (%eax),%eax
     6ce:	0f be c0             	movsbl %al,%eax
     6d1:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d5:	8b 45 10             	mov    0x10(%ebp),%eax
     6d8:	89 04 24             	mov    %eax,(%esp)
     6db:	e8 00 07 00 00       	call   de0 <strchr>
     6e0:	85 c0                	test   %eax,%eax
     6e2:	74 07                	je     6eb <peek+0x6e>
     6e4:	b8 01 00 00 00       	mov    $0x1,%eax
     6e9:	eb 05                	jmp    6f0 <peek+0x73>
     6eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6f0:	c9                   	leave  
     6f1:	c3                   	ret    

000006f2 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6f2:	55                   	push   %ebp
     6f3:	89 e5                	mov    %esp,%ebp
     6f5:	53                   	push   %ebx
     6f6:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     6f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6fc:	8b 45 08             	mov    0x8(%ebp),%eax
     6ff:	89 04 24             	mov    %eax,(%esp)
     702:	e8 8e 06 00 00       	call   d95 <strlen>
     707:	01 d8                	add    %ebx,%eax
     709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     70f:	89 44 24 04          	mov    %eax,0x4(%esp)
     713:	8d 45 08             	lea    0x8(%ebp),%eax
     716:	89 04 24             	mov    %eax,(%esp)
     719:	e8 60 00 00 00       	call   77e <parseline>
     71e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     721:	c7 44 24 08 1a 15 00 	movl   $0x151a,0x8(%esp)
     728:	00 
     729:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72c:	89 44 24 04          	mov    %eax,0x4(%esp)
     730:	8d 45 08             	lea    0x8(%ebp),%eax
     733:	89 04 24             	mov    %eax,(%esp)
     736:	e8 42 ff ff ff       	call   67d <peek>
  if(s != es){
     73b:	8b 45 08             	mov    0x8(%ebp),%eax
     73e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     741:	74 27                	je     76a <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     743:	8b 45 08             	mov    0x8(%ebp),%eax
     746:	89 44 24 08          	mov    %eax,0x8(%esp)
     74a:	c7 44 24 04 1b 15 00 	movl   $0x151b,0x4(%esp)
     751:	00 
     752:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     759:	e8 89 09 00 00       	call   10e7 <printf>
    panic("syntax");
     75e:	c7 04 24 2a 15 00 00 	movl   $0x152a,(%esp)
     765:	e8 f0 fb ff ff       	call   35a <panic>
  }
  nulterminate(cmd);
     76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     76d:	89 04 24             	mov    %eax,(%esp)
     770:	e8 a5 04 00 00       	call   c1a <nulterminate>
  return cmd;
     775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     778:	83 c4 24             	add    $0x24,%esp
     77b:	5b                   	pop    %ebx
     77c:	5d                   	pop    %ebp
     77d:	c3                   	ret    

0000077e <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     77e:	55                   	push   %ebp
     77f:	89 e5                	mov    %esp,%ebp
     781:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     784:	8b 45 0c             	mov    0xc(%ebp),%eax
     787:	89 44 24 04          	mov    %eax,0x4(%esp)
     78b:	8b 45 08             	mov    0x8(%ebp),%eax
     78e:	89 04 24             	mov    %eax,(%esp)
     791:	e8 bc 00 00 00       	call   852 <parsepipe>
     796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     799:	eb 30                	jmp    7cb <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     79b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7a2:	00 
     7a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7aa:	00 
     7ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ae:	89 44 24 04          	mov    %eax,0x4(%esp)
     7b2:	8b 45 08             	mov    0x8(%ebp),%eax
     7b5:	89 04 24             	mov    %eax,(%esp)
     7b8:	e8 78 fd ff ff       	call   535 <gettoken>
    cmd = backcmd(cmd);
     7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c0:	89 04 24             	mov    %eax,(%esp)
     7c3:	e8 26 fd ff ff       	call   4ee <backcmd>
     7c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7cb:	c7 44 24 08 31 15 00 	movl   $0x1531,0x8(%esp)
     7d2:	00 
     7d3:	8b 45 0c             	mov    0xc(%ebp),%eax
     7d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     7da:	8b 45 08             	mov    0x8(%ebp),%eax
     7dd:	89 04 24             	mov    %eax,(%esp)
     7e0:	e8 98 fe ff ff       	call   67d <peek>
     7e5:	85 c0                	test   %eax,%eax
     7e7:	75 b2                	jne    79b <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7e9:	c7 44 24 08 33 15 00 	movl   $0x1533,0x8(%esp)
     7f0:	00 
     7f1:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f8:	8b 45 08             	mov    0x8(%ebp),%eax
     7fb:	89 04 24             	mov    %eax,(%esp)
     7fe:	e8 7a fe ff ff       	call   67d <peek>
     803:	85 c0                	test   %eax,%eax
     805:	74 46                	je     84d <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     807:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     80e:	00 
     80f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     816:	00 
     817:	8b 45 0c             	mov    0xc(%ebp),%eax
     81a:	89 44 24 04          	mov    %eax,0x4(%esp)
     81e:	8b 45 08             	mov    0x8(%ebp),%eax
     821:	89 04 24             	mov    %eax,(%esp)
     824:	e8 0c fd ff ff       	call   535 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     829:	8b 45 0c             	mov    0xc(%ebp),%eax
     82c:	89 44 24 04          	mov    %eax,0x4(%esp)
     830:	8b 45 08             	mov    0x8(%ebp),%eax
     833:	89 04 24             	mov    %eax,(%esp)
     836:	e8 43 ff ff ff       	call   77e <parseline>
     83b:	89 44 24 04          	mov    %eax,0x4(%esp)
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	89 04 24             	mov    %eax,(%esp)
     845:	e8 54 fc ff ff       	call   49e <listcmd>
     84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     850:	c9                   	leave  
     851:	c3                   	ret    

00000852 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     852:	55                   	push   %ebp
     853:	89 e5                	mov    %esp,%ebp
     855:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     858:	8b 45 0c             	mov    0xc(%ebp),%eax
     85b:	89 44 24 04          	mov    %eax,0x4(%esp)
     85f:	8b 45 08             	mov    0x8(%ebp),%eax
     862:	89 04 24             	mov    %eax,(%esp)
     865:	e8 68 02 00 00       	call   ad2 <parseexec>
     86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     86d:	c7 44 24 08 35 15 00 	movl   $0x1535,0x8(%esp)
     874:	00 
     875:	8b 45 0c             	mov    0xc(%ebp),%eax
     878:	89 44 24 04          	mov    %eax,0x4(%esp)
     87c:	8b 45 08             	mov    0x8(%ebp),%eax
     87f:	89 04 24             	mov    %eax,(%esp)
     882:	e8 f6 fd ff ff       	call   67d <peek>
     887:	85 c0                	test   %eax,%eax
     889:	74 46                	je     8d1 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     88b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     892:	00 
     893:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     89a:	00 
     89b:	8b 45 0c             	mov    0xc(%ebp),%eax
     89e:	89 44 24 04          	mov    %eax,0x4(%esp)
     8a2:	8b 45 08             	mov    0x8(%ebp),%eax
     8a5:	89 04 24             	mov    %eax,(%esp)
     8a8:	e8 88 fc ff ff       	call   535 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b0:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b4:	8b 45 08             	mov    0x8(%ebp),%eax
     8b7:	89 04 24             	mov    %eax,(%esp)
     8ba:	e8 93 ff ff ff       	call   852 <parsepipe>
     8bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c6:	89 04 24             	mov    %eax,(%esp)
     8c9:	e8 80 fb ff ff       	call   44e <pipecmd>
     8ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8d4:	c9                   	leave  
     8d5:	c3                   	ret    

000008d6 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8d6:	55                   	push   %ebp
     8d7:	89 e5                	mov    %esp,%ebp
     8d9:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8dc:	e9 f6 00 00 00       	jmp    9d7 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     8e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8e8:	00 
     8e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8f0:	00 
     8f1:	8b 45 10             	mov    0x10(%ebp),%eax
     8f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f8:	8b 45 0c             	mov    0xc(%ebp),%eax
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 32 fc ff ff       	call   535 <gettoken>
     903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     906:	8d 45 ec             	lea    -0x14(%ebp),%eax
     909:	89 44 24 0c          	mov    %eax,0xc(%esp)
     90d:	8d 45 f0             	lea    -0x10(%ebp),%eax
     910:	89 44 24 08          	mov    %eax,0x8(%esp)
     914:	8b 45 10             	mov    0x10(%ebp),%eax
     917:	89 44 24 04          	mov    %eax,0x4(%esp)
     91b:	8b 45 0c             	mov    0xc(%ebp),%eax
     91e:	89 04 24             	mov    %eax,(%esp)
     921:	e8 0f fc ff ff       	call   535 <gettoken>
     926:	83 f8 61             	cmp    $0x61,%eax
     929:	74 0c                	je     937 <parseredirs+0x61>
      panic("missing file for redirection");
     92b:	c7 04 24 37 15 00 00 	movl   $0x1537,(%esp)
     932:	e8 23 fa ff ff       	call   35a <panic>
    switch(tok){
     937:	8b 45 f4             	mov    -0xc(%ebp),%eax
     93a:	83 f8 3c             	cmp    $0x3c,%eax
     93d:	74 0f                	je     94e <parseredirs+0x78>
     93f:	83 f8 3e             	cmp    $0x3e,%eax
     942:	74 38                	je     97c <parseredirs+0xa6>
     944:	83 f8 2b             	cmp    $0x2b,%eax
     947:	74 61                	je     9aa <parseredirs+0xd4>
     949:	e9 89 00 00 00       	jmp    9d7 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     94e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     951:	8b 45 f0             	mov    -0x10(%ebp),%eax
     954:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     95b:	00 
     95c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     963:	00 
     964:	89 54 24 08          	mov    %edx,0x8(%esp)
     968:	89 44 24 04          	mov    %eax,0x4(%esp)
     96c:	8b 45 08             	mov    0x8(%ebp),%eax
     96f:	89 04 24             	mov    %eax,(%esp)
     972:	e8 6c fa ff ff       	call   3e3 <redircmd>
     977:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     97a:	eb 5b                	jmp    9d7 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     97c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     982:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     989:	00 
     98a:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     991:	00 
     992:	89 54 24 08          	mov    %edx,0x8(%esp)
     996:	89 44 24 04          	mov    %eax,0x4(%esp)
     99a:	8b 45 08             	mov    0x8(%ebp),%eax
     99d:	89 04 24             	mov    %eax,(%esp)
     9a0:	e8 3e fa ff ff       	call   3e3 <redircmd>
     9a5:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9a8:	eb 2d                	jmp    9d7 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9b0:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     9b7:	00 
     9b8:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     9bf:	00 
     9c0:	89 54 24 08          	mov    %edx,0x8(%esp)
     9c4:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c8:	8b 45 08             	mov    0x8(%ebp),%eax
     9cb:	89 04 24             	mov    %eax,(%esp)
     9ce:	e8 10 fa ff ff       	call   3e3 <redircmd>
     9d3:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9d6:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9d7:	c7 44 24 08 54 15 00 	movl   $0x1554,0x8(%esp)
     9de:	00 
     9df:	8b 45 10             	mov    0x10(%ebp),%eax
     9e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e6:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e9:	89 04 24             	mov    %eax,(%esp)
     9ec:	e8 8c fc ff ff       	call   67d <peek>
     9f1:	85 c0                	test   %eax,%eax
     9f3:	0f 85 e8 fe ff ff    	jne    8e1 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9fc:	c9                   	leave  
     9fd:	c3                   	ret    

000009fe <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9fe:	55                   	push   %ebp
     9ff:	89 e5                	mov    %esp,%ebp
     a01:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a04:	c7 44 24 08 57 15 00 	movl   $0x1557,0x8(%esp)
     a0b:	00 
     a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a13:	8b 45 08             	mov    0x8(%ebp),%eax
     a16:	89 04 24             	mov    %eax,(%esp)
     a19:	e8 5f fc ff ff       	call   67d <peek>
     a1e:	85 c0                	test   %eax,%eax
     a20:	75 0c                	jne    a2e <parseblock+0x30>
    panic("parseblock");
     a22:	c7 04 24 59 15 00 00 	movl   $0x1559,(%esp)
     a29:	e8 2c f9 ff ff       	call   35a <panic>
  gettoken(ps, es, 0, 0);
     a2e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a35:	00 
     a36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a3d:	00 
     a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     a41:	89 44 24 04          	mov    %eax,0x4(%esp)
     a45:	8b 45 08             	mov    0x8(%ebp),%eax
     a48:	89 04 24             	mov    %eax,(%esp)
     a4b:	e8 e5 fa ff ff       	call   535 <gettoken>
  cmd = parseline(ps, es);
     a50:	8b 45 0c             	mov    0xc(%ebp),%eax
     a53:	89 44 24 04          	mov    %eax,0x4(%esp)
     a57:	8b 45 08             	mov    0x8(%ebp),%eax
     a5a:	89 04 24             	mov    %eax,(%esp)
     a5d:	e8 1c fd ff ff       	call   77e <parseline>
     a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a65:	c7 44 24 08 64 15 00 	movl   $0x1564,0x8(%esp)
     a6c:	00 
     a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     a70:	89 44 24 04          	mov    %eax,0x4(%esp)
     a74:	8b 45 08             	mov    0x8(%ebp),%eax
     a77:	89 04 24             	mov    %eax,(%esp)
     a7a:	e8 fe fb ff ff       	call   67d <peek>
     a7f:	85 c0                	test   %eax,%eax
     a81:	75 0c                	jne    a8f <parseblock+0x91>
    panic("syntax - missing )");
     a83:	c7 04 24 66 15 00 00 	movl   $0x1566,(%esp)
     a8a:	e8 cb f8 ff ff       	call   35a <panic>
  gettoken(ps, es, 0, 0);
     a8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a96:	00 
     a97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a9e:	00 
     a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa6:	8b 45 08             	mov    0x8(%ebp),%eax
     aa9:	89 04 24             	mov    %eax,(%esp)
     aac:	e8 84 fa ff ff       	call   535 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
     ab8:	8b 45 08             	mov    0x8(%ebp),%eax
     abb:	89 44 24 04          	mov    %eax,0x4(%esp)
     abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac2:	89 04 24             	mov    %eax,(%esp)
     ac5:	e8 0c fe ff ff       	call   8d6 <parseredirs>
     aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ad0:	c9                   	leave  
     ad1:	c3                   	ret    

00000ad2 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     ad2:	55                   	push   %ebp
     ad3:	89 e5                	mov    %esp,%ebp
     ad5:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     ad8:	c7 44 24 08 57 15 00 	movl   $0x1557,0x8(%esp)
     adf:	00 
     ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae7:	8b 45 08             	mov    0x8(%ebp),%eax
     aea:	89 04 24             	mov    %eax,(%esp)
     aed:	e8 8b fb ff ff       	call   67d <peek>
     af2:	85 c0                	test   %eax,%eax
     af4:	74 17                	je     b0d <parseexec+0x3b>
    return parseblock(ps, es);
     af6:	8b 45 0c             	mov    0xc(%ebp),%eax
     af9:	89 44 24 04          	mov    %eax,0x4(%esp)
     afd:	8b 45 08             	mov    0x8(%ebp),%eax
     b00:	89 04 24             	mov    %eax,(%esp)
     b03:	e8 f6 fe ff ff       	call   9fe <parseblock>
     b08:	e9 0b 01 00 00       	jmp    c18 <parseexec+0x146>

  ret = execcmd();
     b0d:	e8 93 f8 ff ff       	call   3a5 <execcmd>
     b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b18:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     b1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     b22:	8b 45 0c             	mov    0xc(%ebp),%eax
     b25:	89 44 24 08          	mov    %eax,0x8(%esp)
     b29:	8b 45 08             	mov    0x8(%ebp),%eax
     b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
     b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b33:	89 04 24             	mov    %eax,(%esp)
     b36:	e8 9b fd ff ff       	call   8d6 <parseredirs>
     b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b3e:	e9 8e 00 00 00       	jmp    bd1 <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b43:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b46:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
     b51:	8b 45 0c             	mov    0xc(%ebp),%eax
     b54:	89 44 24 04          	mov    %eax,0x4(%esp)
     b58:	8b 45 08             	mov    0x8(%ebp),%eax
     b5b:	89 04 24             	mov    %eax,(%esp)
     b5e:	e8 d2 f9 ff ff       	call   535 <gettoken>
     b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b6a:	0f 84 85 00 00 00    	je     bf5 <parseexec+0x123>
      break;
    if(tok != 'a')
     b70:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b74:	74 0c                	je     b82 <parseexec+0xb0>
      panic("syntax");
     b76:	c7 04 24 2a 15 00 00 	movl   $0x152a,(%esp)
     b7d:	e8 d8 f7 ff ff       	call   35a <panic>
    cmd->argv[argc] = q;
     b82:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b8b:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b95:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b98:	83 c1 08             	add    $0x8,%ecx
     b9b:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b9f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     ba3:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ba7:	7e 0c                	jle    bb5 <parseexec+0xe3>
      panic("too many args");
     ba9:	c7 04 24 79 15 00 00 	movl   $0x1579,(%esp)
     bb0:	e8 a5 f7 ff ff       	call   35a <panic>
    ret = parseredirs(ret, ps, es);
     bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb8:	89 44 24 08          	mov    %eax,0x8(%esp)
     bbc:	8b 45 08             	mov    0x8(%ebp),%eax
     bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
     bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bc6:	89 04 24             	mov    %eax,(%esp)
     bc9:	e8 08 fd ff ff       	call   8d6 <parseredirs>
     bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     bd1:	c7 44 24 08 87 15 00 	movl   $0x1587,0x8(%esp)
     bd8:	00 
     bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
     bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
     be0:	8b 45 08             	mov    0x8(%ebp),%eax
     be3:	89 04 24             	mov    %eax,(%esp)
     be6:	e8 92 fa ff ff       	call   67d <peek>
     beb:	85 c0                	test   %eax,%eax
     bed:	0f 84 50 ff ff ff    	je     b43 <parseexec+0x71>
     bf3:	eb 01                	jmp    bf6 <parseexec+0x124>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     bf5:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bfc:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     c03:	00 
  cmd->eargv[argc] = 0;
     c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c0a:	83 c2 08             	add    $0x8,%edx
     c0d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     c14:	00 
  return ret;
     c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     c18:	c9                   	leave  
     c19:	c3                   	ret    

00000c1a <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     c1a:	55                   	push   %ebp
     c1b:	89 e5                	mov    %esp,%ebp
     c1d:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     c20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c24:	75 0a                	jne    c30 <nulterminate+0x16>
    return 0;
     c26:	b8 00 00 00 00       	mov    $0x0,%eax
     c2b:	e9 c9 00 00 00       	jmp    cf9 <nulterminate+0xdf>
  
  switch(cmd->type){
     c30:	8b 45 08             	mov    0x8(%ebp),%eax
     c33:	8b 00                	mov    (%eax),%eax
     c35:	83 f8 05             	cmp    $0x5,%eax
     c38:	0f 87 b8 00 00 00    	ja     cf6 <nulterminate+0xdc>
     c3e:	8b 04 85 8c 15 00 00 	mov    0x158c(,%eax,4),%eax
     c45:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c47:	8b 45 08             	mov    0x8(%ebp),%eax
     c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c54:	eb 14                	jmp    c6a <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c5c:	83 c2 08             	add    $0x8,%edx
     c5f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c63:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     c66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c70:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c74:	85 c0                	test   %eax,%eax
     c76:	75 de                	jne    c56 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     c78:	eb 7c                	jmp    cf6 <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c7a:	8b 45 08             	mov    0x8(%ebp),%eax
     c7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c83:	8b 40 04             	mov    0x4(%eax),%eax
     c86:	89 04 24             	mov    %eax,(%esp)
     c89:	e8 8c ff ff ff       	call   c1a <nulterminate>
    *rcmd->efile = 0;
     c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c91:	8b 40 0c             	mov    0xc(%eax),%eax
     c94:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c97:	eb 5d                	jmp    cf6 <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c99:	8b 45 08             	mov    0x8(%ebp),%eax
     c9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ca2:	8b 40 04             	mov    0x4(%eax),%eax
     ca5:	89 04 24             	mov    %eax,(%esp)
     ca8:	e8 6d ff ff ff       	call   c1a <nulterminate>
    nulterminate(pcmd->right);
     cad:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cb0:	8b 40 08             	mov    0x8(%eax),%eax
     cb3:	89 04 24             	mov    %eax,(%esp)
     cb6:	e8 5f ff ff ff       	call   c1a <nulterminate>
    break;
     cbb:	eb 39                	jmp    cf6 <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     cbd:	8b 45 08             	mov    0x8(%ebp),%eax
     cc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     cc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cc6:	8b 40 04             	mov    0x4(%eax),%eax
     cc9:	89 04 24             	mov    %eax,(%esp)
     ccc:	e8 49 ff ff ff       	call   c1a <nulterminate>
    nulterminate(lcmd->right);
     cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cd4:	8b 40 08             	mov    0x8(%eax),%eax
     cd7:	89 04 24             	mov    %eax,(%esp)
     cda:	e8 3b ff ff ff       	call   c1a <nulterminate>
    break;
     cdf:	eb 15                	jmp    cf6 <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     ce1:	8b 45 08             	mov    0x8(%ebp),%eax
     ce4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     cea:	8b 40 04             	mov    0x4(%eax),%eax
     ced:	89 04 24             	mov    %eax,(%esp)
     cf0:	e8 25 ff ff ff       	call   c1a <nulterminate>
    break;
     cf5:	90                   	nop
  }
  return cmd;
     cf6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cf9:	c9                   	leave  
     cfa:	c3                   	ret    

00000cfb <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     cfb:	55                   	push   %ebp
     cfc:	89 e5                	mov    %esp,%ebp
     cfe:	57                   	push   %edi
     cff:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     d00:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d03:	8b 55 10             	mov    0x10(%ebp),%edx
     d06:	8b 45 0c             	mov    0xc(%ebp),%eax
     d09:	89 cb                	mov    %ecx,%ebx
     d0b:	89 df                	mov    %ebx,%edi
     d0d:	89 d1                	mov    %edx,%ecx
     d0f:	fc                   	cld    
     d10:	f3 aa                	rep stos %al,%es:(%edi)
     d12:	89 ca                	mov    %ecx,%edx
     d14:	89 fb                	mov    %edi,%ebx
     d16:	89 5d 08             	mov    %ebx,0x8(%ebp)
     d19:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d1c:	5b                   	pop    %ebx
     d1d:	5f                   	pop    %edi
     d1e:	5d                   	pop    %ebp
     d1f:	c3                   	ret    

00000d20 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     d20:	55                   	push   %ebp
     d21:	89 e5                	mov    %esp,%ebp
     d23:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d26:	8b 45 08             	mov    0x8(%ebp),%eax
     d29:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d2c:	90                   	nop
     d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d30:	0f b6 10             	movzbl (%eax),%edx
     d33:	8b 45 08             	mov    0x8(%ebp),%eax
     d36:	88 10                	mov    %dl,(%eax)
     d38:	8b 45 08             	mov    0x8(%ebp),%eax
     d3b:	0f b6 00             	movzbl (%eax),%eax
     d3e:	84 c0                	test   %al,%al
     d40:	0f 95 c0             	setne  %al
     d43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d47:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     d4b:	84 c0                	test   %al,%al
     d4d:	75 de                	jne    d2d <strcpy+0xd>
    ;
  return os;
     d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d52:	c9                   	leave  
     d53:	c3                   	ret    

00000d54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d54:	55                   	push   %ebp
     d55:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d57:	eb 08                	jmp    d61 <strcmp+0xd>
    p++, q++;
     d59:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d5d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     d61:	8b 45 08             	mov    0x8(%ebp),%eax
     d64:	0f b6 00             	movzbl (%eax),%eax
     d67:	84 c0                	test   %al,%al
     d69:	74 10                	je     d7b <strcmp+0x27>
     d6b:	8b 45 08             	mov    0x8(%ebp),%eax
     d6e:	0f b6 10             	movzbl (%eax),%edx
     d71:	8b 45 0c             	mov    0xc(%ebp),%eax
     d74:	0f b6 00             	movzbl (%eax),%eax
     d77:	38 c2                	cmp    %al,%dl
     d79:	74 de                	je     d59 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d7b:	8b 45 08             	mov    0x8(%ebp),%eax
     d7e:	0f b6 00             	movzbl (%eax),%eax
     d81:	0f b6 d0             	movzbl %al,%edx
     d84:	8b 45 0c             	mov    0xc(%ebp),%eax
     d87:	0f b6 00             	movzbl (%eax),%eax
     d8a:	0f b6 c0             	movzbl %al,%eax
     d8d:	89 d1                	mov    %edx,%ecx
     d8f:	29 c1                	sub    %eax,%ecx
     d91:	89 c8                	mov    %ecx,%eax
}
     d93:	5d                   	pop    %ebp
     d94:	c3                   	ret    

00000d95 <strlen>:

uint
strlen(char *s)
{
     d95:	55                   	push   %ebp
     d96:	89 e5                	mov    %esp,%ebp
     d98:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     da2:	eb 04                	jmp    da8 <strlen+0x13>
     da4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     da8:	8b 55 fc             	mov    -0x4(%ebp),%edx
     dab:	8b 45 08             	mov    0x8(%ebp),%eax
     dae:	01 d0                	add    %edx,%eax
     db0:	0f b6 00             	movzbl (%eax),%eax
     db3:	84 c0                	test   %al,%al
     db5:	75 ed                	jne    da4 <strlen+0xf>
    ;
  return n;
     db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     dba:	c9                   	leave  
     dbb:	c3                   	ret    

00000dbc <memset>:

void*
memset(void *dst, int c, uint n)
{
     dbc:	55                   	push   %ebp
     dbd:	89 e5                	mov    %esp,%ebp
     dbf:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     dc2:	8b 45 10             	mov    0x10(%ebp),%eax
     dc5:	89 44 24 08          	mov    %eax,0x8(%esp)
     dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
     dcc:	89 44 24 04          	mov    %eax,0x4(%esp)
     dd0:	8b 45 08             	mov    0x8(%ebp),%eax
     dd3:	89 04 24             	mov    %eax,(%esp)
     dd6:	e8 20 ff ff ff       	call   cfb <stosb>
  return dst;
     ddb:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dde:	c9                   	leave  
     ddf:	c3                   	ret    

00000de0 <strchr>:

char*
strchr(const char *s, char c)
{
     de0:	55                   	push   %ebp
     de1:	89 e5                	mov    %esp,%ebp
     de3:	83 ec 04             	sub    $0x4,%esp
     de6:	8b 45 0c             	mov    0xc(%ebp),%eax
     de9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     dec:	eb 14                	jmp    e02 <strchr+0x22>
    if(*s == c)
     dee:	8b 45 08             	mov    0x8(%ebp),%eax
     df1:	0f b6 00             	movzbl (%eax),%eax
     df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
     df7:	75 05                	jne    dfe <strchr+0x1e>
      return (char*)s;
     df9:	8b 45 08             	mov    0x8(%ebp),%eax
     dfc:	eb 13                	jmp    e11 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     dfe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     e02:	8b 45 08             	mov    0x8(%ebp),%eax
     e05:	0f b6 00             	movzbl (%eax),%eax
     e08:	84 c0                	test   %al,%al
     e0a:	75 e2                	jne    dee <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     e0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e11:	c9                   	leave  
     e12:	c3                   	ret    

00000e13 <gets>:

char*
gets(char *buf, int max)
{
     e13:	55                   	push   %ebp
     e14:	89 e5                	mov    %esp,%ebp
     e16:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e20:	eb 46                	jmp    e68 <gets+0x55>
    cc = read(0, &c, 1);
     e22:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e29:	00 
     e2a:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
     e31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e38:	e8 3d 01 00 00       	call   f7a <read>
     e3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e44:	7e 2f                	jle    e75 <gets+0x62>
      break;
    buf[i++] = c;
     e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e49:	8b 45 08             	mov    0x8(%ebp),%eax
     e4c:	01 c2                	add    %eax,%edx
     e4e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e52:	88 02                	mov    %al,(%edx)
     e54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     e58:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e5c:	3c 0a                	cmp    $0xa,%al
     e5e:	74 16                	je     e76 <gets+0x63>
     e60:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e64:	3c 0d                	cmp    $0xd,%al
     e66:	74 0e                	je     e76 <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e6b:	83 c0 01             	add    $0x1,%eax
     e6e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e71:	7c af                	jl     e22 <gets+0xf>
     e73:	eb 01                	jmp    e76 <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     e75:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e79:	8b 45 08             	mov    0x8(%ebp),%eax
     e7c:	01 d0                	add    %edx,%eax
     e7e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e81:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e84:	c9                   	leave  
     e85:	c3                   	ret    

00000e86 <stat>:

int
stat(char *n, struct stat *st)
{
     e86:	55                   	push   %ebp
     e87:	89 e5                	mov    %esp,%ebp
     e89:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e93:	00 
     e94:	8b 45 08             	mov    0x8(%ebp),%eax
     e97:	89 04 24             	mov    %eax,(%esp)
     e9a:	e8 03 01 00 00       	call   fa2 <open>
     e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     ea2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ea6:	79 07                	jns    eaf <stat+0x29>
    return -1;
     ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ead:	eb 23                	jmp    ed2 <stat+0x4c>
  r = fstat(fd, st);
     eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eb9:	89 04 24             	mov    %eax,(%esp)
     ebc:	e8 f9 00 00 00       	call   fba <fstat>
     ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ec7:	89 04 24             	mov    %eax,(%esp)
     eca:	e8 bb 00 00 00       	call   f8a <close>
  return r;
     ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ed2:	c9                   	leave  
     ed3:	c3                   	ret    

00000ed4 <atoi>:

int
atoi(const char *s)
{
     ed4:	55                   	push   %ebp
     ed5:	89 e5                	mov    %esp,%ebp
     ed7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     eda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     ee1:	eb 23                	jmp    f06 <atoi+0x32>
    n = n*10 + *s++ - '0';
     ee3:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ee6:	89 d0                	mov    %edx,%eax
     ee8:	c1 e0 02             	shl    $0x2,%eax
     eeb:	01 d0                	add    %edx,%eax
     eed:	01 c0                	add    %eax,%eax
     eef:	89 c2                	mov    %eax,%edx
     ef1:	8b 45 08             	mov    0x8(%ebp),%eax
     ef4:	0f b6 00             	movzbl (%eax),%eax
     ef7:	0f be c0             	movsbl %al,%eax
     efa:	01 d0                	add    %edx,%eax
     efc:	83 e8 30             	sub    $0x30,%eax
     eff:	89 45 fc             	mov    %eax,-0x4(%ebp)
     f02:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f06:	8b 45 08             	mov    0x8(%ebp),%eax
     f09:	0f b6 00             	movzbl (%eax),%eax
     f0c:	3c 2f                	cmp    $0x2f,%al
     f0e:	7e 0a                	jle    f1a <atoi+0x46>
     f10:	8b 45 08             	mov    0x8(%ebp),%eax
     f13:	0f b6 00             	movzbl (%eax),%eax
     f16:	3c 39                	cmp    $0x39,%al
     f18:	7e c9                	jle    ee3 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f1d:	c9                   	leave  
     f1e:	c3                   	ret    

00000f1f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f1f:	55                   	push   %ebp
     f20:	89 e5                	mov    %esp,%ebp
     f22:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     f25:	8b 45 08             	mov    0x8(%ebp),%eax
     f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f31:	eb 13                	jmp    f46 <memmove+0x27>
    *dst++ = *src++;
     f33:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f36:	0f b6 10             	movzbl (%eax),%edx
     f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f3c:	88 10                	mov    %dl,(%eax)
     f3e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     f42:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     f4a:	0f 9f c0             	setg   %al
     f4d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     f51:	84 c0                	test   %al,%al
     f53:	75 de                	jne    f33 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f55:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f58:	c9                   	leave  
     f59:	c3                   	ret    

00000f5a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f5a:	b8 01 00 00 00       	mov    $0x1,%eax
     f5f:	cd 40                	int    $0x40
     f61:	c3                   	ret    

00000f62 <exit>:
SYSCALL(exit)
     f62:	b8 02 00 00 00       	mov    $0x2,%eax
     f67:	cd 40                	int    $0x40
     f69:	c3                   	ret    

00000f6a <wait>:
SYSCALL(wait)
     f6a:	b8 03 00 00 00       	mov    $0x3,%eax
     f6f:	cd 40                	int    $0x40
     f71:	c3                   	ret    

00000f72 <pipe>:
SYSCALL(pipe)
     f72:	b8 04 00 00 00       	mov    $0x4,%eax
     f77:	cd 40                	int    $0x40
     f79:	c3                   	ret    

00000f7a <read>:
SYSCALL(read)
     f7a:	b8 05 00 00 00       	mov    $0x5,%eax
     f7f:	cd 40                	int    $0x40
     f81:	c3                   	ret    

00000f82 <write>:
SYSCALL(write)
     f82:	b8 10 00 00 00       	mov    $0x10,%eax
     f87:	cd 40                	int    $0x40
     f89:	c3                   	ret    

00000f8a <close>:
SYSCALL(close)
     f8a:	b8 15 00 00 00       	mov    $0x15,%eax
     f8f:	cd 40                	int    $0x40
     f91:	c3                   	ret    

00000f92 <kill>:
SYSCALL(kill)
     f92:	b8 06 00 00 00       	mov    $0x6,%eax
     f97:	cd 40                	int    $0x40
     f99:	c3                   	ret    

00000f9a <exec>:
SYSCALL(exec)
     f9a:	b8 07 00 00 00       	mov    $0x7,%eax
     f9f:	cd 40                	int    $0x40
     fa1:	c3                   	ret    

00000fa2 <open>:
SYSCALL(open)
     fa2:	b8 0f 00 00 00       	mov    $0xf,%eax
     fa7:	cd 40                	int    $0x40
     fa9:	c3                   	ret    

00000faa <mknod>:
SYSCALL(mknod)
     faa:	b8 11 00 00 00       	mov    $0x11,%eax
     faf:	cd 40                	int    $0x40
     fb1:	c3                   	ret    

00000fb2 <unlink>:
SYSCALL(unlink)
     fb2:	b8 12 00 00 00       	mov    $0x12,%eax
     fb7:	cd 40                	int    $0x40
     fb9:	c3                   	ret    

00000fba <fstat>:
SYSCALL(fstat)
     fba:	b8 08 00 00 00       	mov    $0x8,%eax
     fbf:	cd 40                	int    $0x40
     fc1:	c3                   	ret    

00000fc2 <link>:
SYSCALL(link)
     fc2:	b8 13 00 00 00       	mov    $0x13,%eax
     fc7:	cd 40                	int    $0x40
     fc9:	c3                   	ret    

00000fca <mkdir>:
SYSCALL(mkdir)
     fca:	b8 14 00 00 00       	mov    $0x14,%eax
     fcf:	cd 40                	int    $0x40
     fd1:	c3                   	ret    

00000fd2 <chdir>:
SYSCALL(chdir)
     fd2:	b8 09 00 00 00       	mov    $0x9,%eax
     fd7:	cd 40                	int    $0x40
     fd9:	c3                   	ret    

00000fda <dup>:
SYSCALL(dup)
     fda:	b8 0a 00 00 00       	mov    $0xa,%eax
     fdf:	cd 40                	int    $0x40
     fe1:	c3                   	ret    

00000fe2 <getpid>:
SYSCALL(getpid)
     fe2:	b8 0b 00 00 00       	mov    $0xb,%eax
     fe7:	cd 40                	int    $0x40
     fe9:	c3                   	ret    

00000fea <sbrk>:
SYSCALL(sbrk)
     fea:	b8 0c 00 00 00       	mov    $0xc,%eax
     fef:	cd 40                	int    $0x40
     ff1:	c3                   	ret    

00000ff2 <sleep>:
SYSCALL(sleep)
     ff2:	b8 0d 00 00 00       	mov    $0xd,%eax
     ff7:	cd 40                	int    $0x40
     ff9:	c3                   	ret    

00000ffa <uptime>:
SYSCALL(uptime)
     ffa:	b8 0e 00 00 00       	mov    $0xe,%eax
     fff:	cd 40                	int    $0x40
    1001:	c3                   	ret    

00001002 <getprocs>:
SYSCALL(getprocs)
    1002:	b8 16 00 00 00       	mov    $0x16,%eax
    1007:	cd 40                	int    $0x40
    1009:	c3                   	ret    

0000100a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	83 ec 28             	sub    $0x28,%esp
    1010:	8b 45 0c             	mov    0xc(%ebp),%eax
    1013:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1016:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    101d:	00 
    101e:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1021:	89 44 24 04          	mov    %eax,0x4(%esp)
    1025:	8b 45 08             	mov    0x8(%ebp),%eax
    1028:	89 04 24             	mov    %eax,(%esp)
    102b:	e8 52 ff ff ff       	call   f82 <write>
}
    1030:	c9                   	leave  
    1031:	c3                   	ret    

00001032 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1032:	55                   	push   %ebp
    1033:	89 e5                	mov    %esp,%ebp
    1035:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1038:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    103f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1043:	74 17                	je     105c <printint+0x2a>
    1045:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1049:	79 11                	jns    105c <printint+0x2a>
    neg = 1;
    104b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1052:	8b 45 0c             	mov    0xc(%ebp),%eax
    1055:	f7 d8                	neg    %eax
    1057:	89 45 ec             	mov    %eax,-0x14(%ebp)
    105a:	eb 06                	jmp    1062 <printint+0x30>
  } else {
    x = xx;
    105c:	8b 45 0c             	mov    0xc(%ebp),%eax
    105f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1062:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1069:	8b 4d 10             	mov    0x10(%ebp),%ecx
    106c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    106f:	ba 00 00 00 00       	mov    $0x0,%edx
    1074:	f7 f1                	div    %ecx
    1076:	89 d0                	mov    %edx,%eax
    1078:	0f b6 80 32 1a 00 00 	movzbl 0x1a32(%eax),%eax
    107f:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    1082:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1085:	01 ca                	add    %ecx,%edx
    1087:	88 02                	mov    %al,(%edx)
    1089:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
    108d:	8b 55 10             	mov    0x10(%ebp),%edx
    1090:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    1093:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1096:	ba 00 00 00 00       	mov    $0x0,%edx
    109b:	f7 75 d4             	divl   -0x2c(%ebp)
    109e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10a5:	75 c2                	jne    1069 <printint+0x37>
  if(neg)
    10a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10ab:	74 2e                	je     10db <printint+0xa9>
    buf[i++] = '-';
    10ad:	8d 55 dc             	lea    -0x24(%ebp),%edx
    10b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b3:	01 d0                	add    %edx,%eax
    10b5:	c6 00 2d             	movb   $0x2d,(%eax)
    10b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
    10bc:	eb 1d                	jmp    10db <printint+0xa9>
    putc(fd, buf[i]);
    10be:	8d 55 dc             	lea    -0x24(%ebp),%edx
    10c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10c4:	01 d0                	add    %edx,%eax
    10c6:	0f b6 00             	movzbl (%eax),%eax
    10c9:	0f be c0             	movsbl %al,%eax
    10cc:	89 44 24 04          	mov    %eax,0x4(%esp)
    10d0:	8b 45 08             	mov    0x8(%ebp),%eax
    10d3:	89 04 24             	mov    %eax,(%esp)
    10d6:	e8 2f ff ff ff       	call   100a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    10db:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    10df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10e3:	79 d9                	jns    10be <printint+0x8c>
    putc(fd, buf[i]);
}
    10e5:	c9                   	leave  
    10e6:	c3                   	ret    

000010e7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    10e7:	55                   	push   %ebp
    10e8:	89 e5                	mov    %esp,%ebp
    10ea:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    10f4:	8d 45 0c             	lea    0xc(%ebp),%eax
    10f7:	83 c0 04             	add    $0x4,%eax
    10fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    10fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1104:	e9 7d 01 00 00       	jmp    1286 <printf+0x19f>
    c = fmt[i] & 0xff;
    1109:	8b 55 0c             	mov    0xc(%ebp),%edx
    110c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    110f:	01 d0                	add    %edx,%eax
    1111:	0f b6 00             	movzbl (%eax),%eax
    1114:	0f be c0             	movsbl %al,%eax
    1117:	25 ff 00 00 00       	and    $0xff,%eax
    111c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    111f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1123:	75 2c                	jne    1151 <printf+0x6a>
      if(c == '%'){
    1125:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1129:	75 0c                	jne    1137 <printf+0x50>
        state = '%';
    112b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1132:	e9 4b 01 00 00       	jmp    1282 <printf+0x19b>
      } else {
        putc(fd, c);
    1137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    113a:	0f be c0             	movsbl %al,%eax
    113d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1141:	8b 45 08             	mov    0x8(%ebp),%eax
    1144:	89 04 24             	mov    %eax,(%esp)
    1147:	e8 be fe ff ff       	call   100a <putc>
    114c:	e9 31 01 00 00       	jmp    1282 <printf+0x19b>
      }
    } else if(state == '%'){
    1151:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1155:	0f 85 27 01 00 00    	jne    1282 <printf+0x19b>
      if(c == 'd'){
    115b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    115f:	75 2d                	jne    118e <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1161:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1164:	8b 00                	mov    (%eax),%eax
    1166:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    116d:	00 
    116e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1175:	00 
    1176:	89 44 24 04          	mov    %eax,0x4(%esp)
    117a:	8b 45 08             	mov    0x8(%ebp),%eax
    117d:	89 04 24             	mov    %eax,(%esp)
    1180:	e8 ad fe ff ff       	call   1032 <printint>
        ap++;
    1185:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1189:	e9 ed 00 00 00       	jmp    127b <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    118e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1192:	74 06                	je     119a <printf+0xb3>
    1194:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1198:	75 2d                	jne    11c7 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    119a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    119d:	8b 00                	mov    (%eax),%eax
    119f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    11a6:	00 
    11a7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    11ae:	00 
    11af:	89 44 24 04          	mov    %eax,0x4(%esp)
    11b3:	8b 45 08             	mov    0x8(%ebp),%eax
    11b6:	89 04 24             	mov    %eax,(%esp)
    11b9:	e8 74 fe ff ff       	call   1032 <printint>
        ap++;
    11be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11c2:	e9 b4 00 00 00       	jmp    127b <printf+0x194>
      } else if(c == 's'){
    11c7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    11cb:	75 46                	jne    1213 <printf+0x12c>
        s = (char*)*ap;
    11cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11d0:	8b 00                	mov    (%eax),%eax
    11d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    11d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    11d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11dd:	75 27                	jne    1206 <printf+0x11f>
          s = "(null)";
    11df:	c7 45 f4 a4 15 00 00 	movl   $0x15a4,-0xc(%ebp)
        while(*s != 0){
    11e6:	eb 1e                	jmp    1206 <printf+0x11f>
          putc(fd, *s);
    11e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11eb:	0f b6 00             	movzbl (%eax),%eax
    11ee:	0f be c0             	movsbl %al,%eax
    11f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    11f5:	8b 45 08             	mov    0x8(%ebp),%eax
    11f8:	89 04 24             	mov    %eax,(%esp)
    11fb:	e8 0a fe ff ff       	call   100a <putc>
          s++;
    1200:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1204:	eb 01                	jmp    1207 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1206:	90                   	nop
    1207:	8b 45 f4             	mov    -0xc(%ebp),%eax
    120a:	0f b6 00             	movzbl (%eax),%eax
    120d:	84 c0                	test   %al,%al
    120f:	75 d7                	jne    11e8 <printf+0x101>
    1211:	eb 68                	jmp    127b <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1213:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1217:	75 1d                	jne    1236 <printf+0x14f>
        putc(fd, *ap);
    1219:	8b 45 e8             	mov    -0x18(%ebp),%eax
    121c:	8b 00                	mov    (%eax),%eax
    121e:	0f be c0             	movsbl %al,%eax
    1221:	89 44 24 04          	mov    %eax,0x4(%esp)
    1225:	8b 45 08             	mov    0x8(%ebp),%eax
    1228:	89 04 24             	mov    %eax,(%esp)
    122b:	e8 da fd ff ff       	call   100a <putc>
        ap++;
    1230:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1234:	eb 45                	jmp    127b <printf+0x194>
      } else if(c == '%'){
    1236:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    123a:	75 17                	jne    1253 <printf+0x16c>
        putc(fd, c);
    123c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    123f:	0f be c0             	movsbl %al,%eax
    1242:	89 44 24 04          	mov    %eax,0x4(%esp)
    1246:	8b 45 08             	mov    0x8(%ebp),%eax
    1249:	89 04 24             	mov    %eax,(%esp)
    124c:	e8 b9 fd ff ff       	call   100a <putc>
    1251:	eb 28                	jmp    127b <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1253:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    125a:	00 
    125b:	8b 45 08             	mov    0x8(%ebp),%eax
    125e:	89 04 24             	mov    %eax,(%esp)
    1261:	e8 a4 fd ff ff       	call   100a <putc>
        putc(fd, c);
    1266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1269:	0f be c0             	movsbl %al,%eax
    126c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1270:	8b 45 08             	mov    0x8(%ebp),%eax
    1273:	89 04 24             	mov    %eax,(%esp)
    1276:	e8 8f fd ff ff       	call   100a <putc>
      }
      state = 0;
    127b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1282:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1286:	8b 55 0c             	mov    0xc(%ebp),%edx
    1289:	8b 45 f0             	mov    -0x10(%ebp),%eax
    128c:	01 d0                	add    %edx,%eax
    128e:	0f b6 00             	movzbl (%eax),%eax
    1291:	84 c0                	test   %al,%al
    1293:	0f 85 70 fe ff ff    	jne    1109 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1299:	c9                   	leave  
    129a:	c3                   	ret    

0000129b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    129b:	55                   	push   %ebp
    129c:	89 e5                	mov    %esp,%ebp
    129e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12a1:	8b 45 08             	mov    0x8(%ebp),%eax
    12a4:	83 e8 08             	sub    $0x8,%eax
    12a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12aa:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    12af:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12b2:	eb 24                	jmp    12d8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b7:	8b 00                	mov    (%eax),%eax
    12b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12bc:	77 12                	ja     12d0 <free+0x35>
    12be:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12c4:	77 24                	ja     12ea <free+0x4f>
    12c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c9:	8b 00                	mov    (%eax),%eax
    12cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12ce:	77 1a                	ja     12ea <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d3:	8b 00                	mov    (%eax),%eax
    12d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12de:	76 d4                	jbe    12b4 <free+0x19>
    12e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e3:	8b 00                	mov    (%eax),%eax
    12e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12e8:	76 ca                	jbe    12b4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    12ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ed:	8b 40 04             	mov    0x4(%eax),%eax
    12f0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12fa:	01 c2                	add    %eax,%edx
    12fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12ff:	8b 00                	mov    (%eax),%eax
    1301:	39 c2                	cmp    %eax,%edx
    1303:	75 24                	jne    1329 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1305:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1308:	8b 50 04             	mov    0x4(%eax),%edx
    130b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    130e:	8b 00                	mov    (%eax),%eax
    1310:	8b 40 04             	mov    0x4(%eax),%eax
    1313:	01 c2                	add    %eax,%edx
    1315:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1318:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    131b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    131e:	8b 00                	mov    (%eax),%eax
    1320:	8b 10                	mov    (%eax),%edx
    1322:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1325:	89 10                	mov    %edx,(%eax)
    1327:	eb 0a                	jmp    1333 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1329:	8b 45 fc             	mov    -0x4(%ebp),%eax
    132c:	8b 10                	mov    (%eax),%edx
    132e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1331:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1333:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1336:	8b 40 04             	mov    0x4(%eax),%eax
    1339:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1340:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1343:	01 d0                	add    %edx,%eax
    1345:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1348:	75 20                	jne    136a <free+0xcf>
    p->s.size += bp->s.size;
    134a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    134d:	8b 50 04             	mov    0x4(%eax),%edx
    1350:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1353:	8b 40 04             	mov    0x4(%eax),%eax
    1356:	01 c2                	add    %eax,%edx
    1358:	8b 45 fc             	mov    -0x4(%ebp),%eax
    135b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1361:	8b 10                	mov    (%eax),%edx
    1363:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1366:	89 10                	mov    %edx,(%eax)
    1368:	eb 08                	jmp    1372 <free+0xd7>
  } else
    p->s.ptr = bp;
    136a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    136d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1370:	89 10                	mov    %edx,(%eax)
  freep = p;
    1372:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1375:	a3 cc 1a 00 00       	mov    %eax,0x1acc
}
    137a:	c9                   	leave  
    137b:	c3                   	ret    

0000137c <morecore>:

static Header*
morecore(uint nu)
{
    137c:	55                   	push   %ebp
    137d:	89 e5                	mov    %esp,%ebp
    137f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1382:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1389:	77 07                	ja     1392 <morecore+0x16>
    nu = 4096;
    138b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1392:	8b 45 08             	mov    0x8(%ebp),%eax
    1395:	c1 e0 03             	shl    $0x3,%eax
    1398:	89 04 24             	mov    %eax,(%esp)
    139b:	e8 4a fc ff ff       	call   fea <sbrk>
    13a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    13a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    13a7:	75 07                	jne    13b0 <morecore+0x34>
    return 0;
    13a9:	b8 00 00 00 00       	mov    $0x0,%eax
    13ae:	eb 22                	jmp    13d2 <morecore+0x56>
  hp = (Header*)p;
    13b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    13b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13b9:	8b 55 08             	mov    0x8(%ebp),%edx
    13bc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    13bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13c2:	83 c0 08             	add    $0x8,%eax
    13c5:	89 04 24             	mov    %eax,(%esp)
    13c8:	e8 ce fe ff ff       	call   129b <free>
  return freep;
    13cd:	a1 cc 1a 00 00       	mov    0x1acc,%eax
}
    13d2:	c9                   	leave  
    13d3:	c3                   	ret    

000013d4 <malloc>:

void*
malloc(uint nbytes)
{
    13d4:	55                   	push   %ebp
    13d5:	89 e5                	mov    %esp,%ebp
    13d7:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13da:	8b 45 08             	mov    0x8(%ebp),%eax
    13dd:	83 c0 07             	add    $0x7,%eax
    13e0:	c1 e8 03             	shr    $0x3,%eax
    13e3:	83 c0 01             	add    $0x1,%eax
    13e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    13e9:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    13ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13f5:	75 23                	jne    141a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    13f7:	c7 45 f0 c4 1a 00 00 	movl   $0x1ac4,-0x10(%ebp)
    13fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1401:	a3 cc 1a 00 00       	mov    %eax,0x1acc
    1406:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    140b:	a3 c4 1a 00 00       	mov    %eax,0x1ac4
    base.s.size = 0;
    1410:	c7 05 c8 1a 00 00 00 	movl   $0x0,0x1ac8
    1417:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    141d:	8b 00                	mov    (%eax),%eax
    141f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1422:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1425:	8b 40 04             	mov    0x4(%eax),%eax
    1428:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    142b:	72 4d                	jb     147a <malloc+0xa6>
      if(p->s.size == nunits)
    142d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1430:	8b 40 04             	mov    0x4(%eax),%eax
    1433:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1436:	75 0c                	jne    1444 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1438:	8b 45 f4             	mov    -0xc(%ebp),%eax
    143b:	8b 10                	mov    (%eax),%edx
    143d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1440:	89 10                	mov    %edx,(%eax)
    1442:	eb 26                	jmp    146a <malloc+0x96>
      else {
        p->s.size -= nunits;
    1444:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1447:	8b 40 04             	mov    0x4(%eax),%eax
    144a:	89 c2                	mov    %eax,%edx
    144c:	2b 55 ec             	sub    -0x14(%ebp),%edx
    144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1452:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1455:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1458:	8b 40 04             	mov    0x4(%eax),%eax
    145b:	c1 e0 03             	shl    $0x3,%eax
    145e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1461:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1464:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1467:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    146a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    146d:	a3 cc 1a 00 00       	mov    %eax,0x1acc
      return (void*)(p + 1);
    1472:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1475:	83 c0 08             	add    $0x8,%eax
    1478:	eb 38                	jmp    14b2 <malloc+0xde>
    }
    if(p == freep)
    147a:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    147f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1482:	75 1b                	jne    149f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1484:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1487:	89 04 24             	mov    %eax,(%esp)
    148a:	e8 ed fe ff ff       	call   137c <morecore>
    148f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1496:	75 07                	jne    149f <malloc+0xcb>
        return 0;
    1498:	b8 00 00 00 00       	mov    $0x0,%eax
    149d:	eb 13                	jmp    14b2 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    149f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    14a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a8:	8b 00                	mov    (%eax),%eax
    14aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    14ad:	e9 70 ff ff ff       	jmp    1422 <malloc+0x4e>
}
    14b2:	c9                   	leave  
    14b3:	c3                   	ret    
