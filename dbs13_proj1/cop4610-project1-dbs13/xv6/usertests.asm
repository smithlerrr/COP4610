
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
       6:	a1 e4 62 00 00       	mov    0x62e4,%eax
       b:	c7 44 24 04 3e 44 00 	movl   $0x443e,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 40 40 00 00       	call   405b <printf>

  if(mkdir("iputdir") < 0){
      1b:	c7 04 24 49 44 00 00 	movl   $0x4449,(%esp)
      22:	e8 17 3f 00 00       	call   3f3e <mkdir>
      27:	85 c0                	test   %eax,%eax
      29:	79 1a                	jns    45 <iputtest+0x45>
    printf(stdout, "mkdir failed\n");
      2b:	a1 e4 62 00 00       	mov    0x62e4,%eax
      30:	c7 44 24 04 51 44 00 	movl   $0x4451,0x4(%esp)
      37:	00 
      38:	89 04 24             	mov    %eax,(%esp)
      3b:	e8 1b 40 00 00       	call   405b <printf>
    exit();
      40:	e8 91 3e 00 00       	call   3ed6 <exit>
  }
  if(chdir("iputdir") < 0){
      45:	c7 04 24 49 44 00 00 	movl   $0x4449,(%esp)
      4c:	e8 f5 3e 00 00       	call   3f46 <chdir>
      51:	85 c0                	test   %eax,%eax
      53:	79 1a                	jns    6f <iputtest+0x6f>
    printf(stdout, "chdir iputdir failed\n");
      55:	a1 e4 62 00 00       	mov    0x62e4,%eax
      5a:	c7 44 24 04 5f 44 00 	movl   $0x445f,0x4(%esp)
      61:	00 
      62:	89 04 24             	mov    %eax,(%esp)
      65:	e8 f1 3f 00 00       	call   405b <printf>
    exit();
      6a:	e8 67 3e 00 00       	call   3ed6 <exit>
  }
  if(unlink("../iputdir") < 0){
      6f:	c7 04 24 75 44 00 00 	movl   $0x4475,(%esp)
      76:	e8 ab 3e 00 00       	call   3f26 <unlink>
      7b:	85 c0                	test   %eax,%eax
      7d:	79 1a                	jns    99 <iputtest+0x99>
    printf(stdout, "unlink ../iputdir failed\n");
      7f:	a1 e4 62 00 00       	mov    0x62e4,%eax
      84:	c7 44 24 04 80 44 00 	movl   $0x4480,0x4(%esp)
      8b:	00 
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 c7 3f 00 00       	call   405b <printf>
    exit();
      94:	e8 3d 3e 00 00       	call   3ed6 <exit>
  }
  if(chdir("/") < 0){
      99:	c7 04 24 9a 44 00 00 	movl   $0x449a,(%esp)
      a0:	e8 a1 3e 00 00       	call   3f46 <chdir>
      a5:	85 c0                	test   %eax,%eax
      a7:	79 1a                	jns    c3 <iputtest+0xc3>
    printf(stdout, "chdir / failed\n");
      a9:	a1 e4 62 00 00       	mov    0x62e4,%eax
      ae:	c7 44 24 04 9c 44 00 	movl   $0x449c,0x4(%esp)
      b5:	00 
      b6:	89 04 24             	mov    %eax,(%esp)
      b9:	e8 9d 3f 00 00       	call   405b <printf>
    exit();
      be:	e8 13 3e 00 00       	call   3ed6 <exit>
  }
  printf(stdout, "iput test ok\n");
      c3:	a1 e4 62 00 00       	mov    0x62e4,%eax
      c8:	c7 44 24 04 ac 44 00 	movl   $0x44ac,0x4(%esp)
      cf:	00 
      d0:	89 04 24             	mov    %eax,(%esp)
      d3:	e8 83 3f 00 00       	call   405b <printf>
}
      d8:	c9                   	leave  
      d9:	c3                   	ret    

000000da <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      da:	55                   	push   %ebp
      db:	89 e5                	mov    %esp,%ebp
      dd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e0:	a1 e4 62 00 00       	mov    0x62e4,%eax
      e5:	c7 44 24 04 ba 44 00 	movl   $0x44ba,0x4(%esp)
      ec:	00 
      ed:	89 04 24             	mov    %eax,(%esp)
      f0:	e8 66 3f 00 00       	call   405b <printf>

  pid = fork();
      f5:	e8 d4 3d 00 00       	call   3ece <fork>
      fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
      fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     101:	79 1a                	jns    11d <exitiputtest+0x43>
    printf(stdout, "fork failed\n");
     103:	a1 e4 62 00 00       	mov    0x62e4,%eax
     108:	c7 44 24 04 c9 44 00 	movl   $0x44c9,0x4(%esp)
     10f:	00 
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 43 3f 00 00       	call   405b <printf>
    exit();
     118:	e8 b9 3d 00 00       	call   3ed6 <exit>
  }
  if(pid == 0){
     11d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     121:	0f 85 83 00 00 00    	jne    1aa <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     127:	c7 04 24 49 44 00 00 	movl   $0x4449,(%esp)
     12e:	e8 0b 3e 00 00       	call   3f3e <mkdir>
     133:	85 c0                	test   %eax,%eax
     135:	79 1a                	jns    151 <exitiputtest+0x77>
      printf(stdout, "mkdir failed\n");
     137:	a1 e4 62 00 00       	mov    0x62e4,%eax
     13c:	c7 44 24 04 51 44 00 	movl   $0x4451,0x4(%esp)
     143:	00 
     144:	89 04 24             	mov    %eax,(%esp)
     147:	e8 0f 3f 00 00       	call   405b <printf>
      exit();
     14c:	e8 85 3d 00 00       	call   3ed6 <exit>
    }
    if(chdir("iputdir") < 0){
     151:	c7 04 24 49 44 00 00 	movl   $0x4449,(%esp)
     158:	e8 e9 3d 00 00       	call   3f46 <chdir>
     15d:	85 c0                	test   %eax,%eax
     15f:	79 1a                	jns    17b <exitiputtest+0xa1>
      printf(stdout, "child chdir failed\n");
     161:	a1 e4 62 00 00       	mov    0x62e4,%eax
     166:	c7 44 24 04 d6 44 00 	movl   $0x44d6,0x4(%esp)
     16d:	00 
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 e5 3e 00 00       	call   405b <printf>
      exit();
     176:	e8 5b 3d 00 00       	call   3ed6 <exit>
    }
    if(unlink("../iputdir") < 0){
     17b:	c7 04 24 75 44 00 00 	movl   $0x4475,(%esp)
     182:	e8 9f 3d 00 00       	call   3f26 <unlink>
     187:	85 c0                	test   %eax,%eax
     189:	79 1a                	jns    1a5 <exitiputtest+0xcb>
      printf(stdout, "unlink ../iputdir failed\n");
     18b:	a1 e4 62 00 00       	mov    0x62e4,%eax
     190:	c7 44 24 04 80 44 00 	movl   $0x4480,0x4(%esp)
     197:	00 
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 bb 3e 00 00       	call   405b <printf>
      exit();
     1a0:	e8 31 3d 00 00       	call   3ed6 <exit>
    }
    exit();
     1a5:	e8 2c 3d 00 00       	call   3ed6 <exit>
  }
  wait();
     1aa:	e8 2f 3d 00 00       	call   3ede <wait>
  printf(stdout, "exitiput test ok\n");
     1af:	a1 e4 62 00 00       	mov    0x62e4,%eax
     1b4:	c7 44 24 04 ea 44 00 	movl   $0x44ea,0x4(%esp)
     1bb:	00 
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 97 3e 00 00       	call   405b <printf>
}
     1c4:	c9                   	leave  
     1c5:	c3                   	ret    

000001c6 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c6:	55                   	push   %ebp
     1c7:	89 e5                	mov    %esp,%ebp
     1c9:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cc:	a1 e4 62 00 00       	mov    0x62e4,%eax
     1d1:	c7 44 24 04 fc 44 00 	movl   $0x44fc,0x4(%esp)
     1d8:	00 
     1d9:	89 04 24             	mov    %eax,(%esp)
     1dc:	e8 7a 3e 00 00       	call   405b <printf>
  if(mkdir("oidir") < 0){
     1e1:	c7 04 24 0b 45 00 00 	movl   $0x450b,(%esp)
     1e8:	e8 51 3d 00 00       	call   3f3e <mkdir>
     1ed:	85 c0                	test   %eax,%eax
     1ef:	79 1a                	jns    20b <openiputtest+0x45>
    printf(stdout, "mkdir oidir failed\n");
     1f1:	a1 e4 62 00 00       	mov    0x62e4,%eax
     1f6:	c7 44 24 04 11 45 00 	movl   $0x4511,0x4(%esp)
     1fd:	00 
     1fe:	89 04 24             	mov    %eax,(%esp)
     201:	e8 55 3e 00 00       	call   405b <printf>
    exit();
     206:	e8 cb 3c 00 00       	call   3ed6 <exit>
  }
  pid = fork();
     20b:	e8 be 3c 00 00       	call   3ece <fork>
     210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     217:	79 1a                	jns    233 <openiputtest+0x6d>
    printf(stdout, "fork failed\n");
     219:	a1 e4 62 00 00       	mov    0x62e4,%eax
     21e:	c7 44 24 04 c9 44 00 	movl   $0x44c9,0x4(%esp)
     225:	00 
     226:	89 04 24             	mov    %eax,(%esp)
     229:	e8 2d 3e 00 00       	call   405b <printf>
    exit();
     22e:	e8 a3 3c 00 00       	call   3ed6 <exit>
  }
  if(pid == 0){
     233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     237:	75 3c                	jne    275 <openiputtest+0xaf>
    int fd = open("oidir", O_RDWR);
     239:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     240:	00 
     241:	c7 04 24 0b 45 00 00 	movl   $0x450b,(%esp)
     248:	e8 c9 3c 00 00       	call   3f16 <open>
     24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     254:	78 1a                	js     270 <openiputtest+0xaa>
      printf(stdout, "open directory for write succeeded\n");
     256:	a1 e4 62 00 00       	mov    0x62e4,%eax
     25b:	c7 44 24 04 28 45 00 	movl   $0x4528,0x4(%esp)
     262:	00 
     263:	89 04 24             	mov    %eax,(%esp)
     266:	e8 f0 3d 00 00       	call   405b <printf>
      exit();
     26b:	e8 66 3c 00 00       	call   3ed6 <exit>
    }
    exit();
     270:	e8 61 3c 00 00       	call   3ed6 <exit>
  }
  sleep(1);
     275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     27c:	e8 e5 3c 00 00       	call   3f66 <sleep>
  if(unlink("oidir") != 0){
     281:	c7 04 24 0b 45 00 00 	movl   $0x450b,(%esp)
     288:	e8 99 3c 00 00       	call   3f26 <unlink>
     28d:	85 c0                	test   %eax,%eax
     28f:	74 1a                	je     2ab <openiputtest+0xe5>
    printf(stdout, "unlink failed\n");
     291:	a1 e4 62 00 00       	mov    0x62e4,%eax
     296:	c7 44 24 04 4c 45 00 	movl   $0x454c,0x4(%esp)
     29d:	00 
     29e:	89 04 24             	mov    %eax,(%esp)
     2a1:	e8 b5 3d 00 00       	call   405b <printf>
    exit();
     2a6:	e8 2b 3c 00 00       	call   3ed6 <exit>
  }
  wait();
     2ab:	e8 2e 3c 00 00       	call   3ede <wait>
  printf(stdout, "openiput test ok\n");
     2b0:	a1 e4 62 00 00       	mov    0x62e4,%eax
     2b5:	c7 44 24 04 5b 45 00 	movl   $0x455b,0x4(%esp)
     2bc:	00 
     2bd:	89 04 24             	mov    %eax,(%esp)
     2c0:	e8 96 3d 00 00       	call   405b <printf>
}
     2c5:	c9                   	leave  
     2c6:	c3                   	ret    

000002c7 <opentest>:

// simple file system tests

void
opentest(void)
{
     2c7:	55                   	push   %ebp
     2c8:	89 e5                	mov    %esp,%ebp
     2ca:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
     2cd:	a1 e4 62 00 00       	mov    0x62e4,%eax
     2d2:	c7 44 24 04 6d 45 00 	movl   $0x456d,0x4(%esp)
     2d9:	00 
     2da:	89 04 24             	mov    %eax,(%esp)
     2dd:	e8 79 3d 00 00       	call   405b <printf>
  fd = open("echo", 0);
     2e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2e9:	00 
     2ea:	c7 04 24 28 44 00 00 	movl   $0x4428,(%esp)
     2f1:	e8 20 3c 00 00       	call   3f16 <open>
     2f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     2f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2fd:	79 1a                	jns    319 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     2ff:	a1 e4 62 00 00       	mov    0x62e4,%eax
     304:	c7 44 24 04 78 45 00 	movl   $0x4578,0x4(%esp)
     30b:	00 
     30c:	89 04 24             	mov    %eax,(%esp)
     30f:	e8 47 3d 00 00       	call   405b <printf>
    exit();
     314:	e8 bd 3b 00 00       	call   3ed6 <exit>
  }
  close(fd);
     319:	8b 45 f4             	mov    -0xc(%ebp),%eax
     31c:	89 04 24             	mov    %eax,(%esp)
     31f:	e8 da 3b 00 00       	call   3efe <close>
  fd = open("doesnotexist", 0);
     324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     32b:	00 
     32c:	c7 04 24 8b 45 00 00 	movl   $0x458b,(%esp)
     333:	e8 de 3b 00 00       	call   3f16 <open>
     338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     33b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     33f:	78 1a                	js     35b <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
     341:	a1 e4 62 00 00       	mov    0x62e4,%eax
     346:	c7 44 24 04 98 45 00 	movl   $0x4598,0x4(%esp)
     34d:	00 
     34e:	89 04 24             	mov    %eax,(%esp)
     351:	e8 05 3d 00 00       	call   405b <printf>
    exit();
     356:	e8 7b 3b 00 00       	call   3ed6 <exit>
  }
  printf(stdout, "open test ok\n");
     35b:	a1 e4 62 00 00       	mov    0x62e4,%eax
     360:	c7 44 24 04 b6 45 00 	movl   $0x45b6,0x4(%esp)
     367:	00 
     368:	89 04 24             	mov    %eax,(%esp)
     36b:	e8 eb 3c 00 00       	call   405b <printf>
}
     370:	c9                   	leave  
     371:	c3                   	ret    

00000372 <writetest>:

void
writetest(void)
{
     372:	55                   	push   %ebp
     373:	89 e5                	mov    %esp,%ebp
     375:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     378:	a1 e4 62 00 00       	mov    0x62e4,%eax
     37d:	c7 44 24 04 c4 45 00 	movl   $0x45c4,0x4(%esp)
     384:	00 
     385:	89 04 24             	mov    %eax,(%esp)
     388:	e8 ce 3c 00 00       	call   405b <printf>
  fd = open("small", O_CREATE|O_RDWR);
     38d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     394:	00 
     395:	c7 04 24 d5 45 00 00 	movl   $0x45d5,(%esp)
     39c:	e8 75 3b 00 00       	call   3f16 <open>
     3a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3a8:	78 21                	js     3cb <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
     3aa:	a1 e4 62 00 00       	mov    0x62e4,%eax
     3af:	c7 44 24 04 db 45 00 	movl   $0x45db,0x4(%esp)
     3b6:	00 
     3b7:	89 04 24             	mov    %eax,(%esp)
     3ba:	e8 9c 3c 00 00       	call   405b <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3c6:	e9 a0 00 00 00       	jmp    46b <writetest+0xf9>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     3cb:	a1 e4 62 00 00       	mov    0x62e4,%eax
     3d0:	c7 44 24 04 f6 45 00 	movl   $0x45f6,0x4(%esp)
     3d7:	00 
     3d8:	89 04 24             	mov    %eax,(%esp)
     3db:	e8 7b 3c 00 00       	call   405b <printf>
    exit();
     3e0:	e8 f1 3a 00 00       	call   3ed6 <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     3ec:	00 
     3ed:	c7 44 24 04 12 46 00 	movl   $0x4612,0x4(%esp)
     3f4:	00 
     3f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3f8:	89 04 24             	mov    %eax,(%esp)
     3fb:	e8 f6 3a 00 00       	call   3ef6 <write>
     400:	83 f8 0a             	cmp    $0xa,%eax
     403:	74 21                	je     426 <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     405:	a1 e4 62 00 00       	mov    0x62e4,%eax
     40a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     40d:	89 54 24 08          	mov    %edx,0x8(%esp)
     411:	c7 44 24 04 20 46 00 	movl   $0x4620,0x4(%esp)
     418:	00 
     419:	89 04 24             	mov    %eax,(%esp)
     41c:	e8 3a 3c 00 00       	call   405b <printf>
      exit();
     421:	e8 b0 3a 00 00       	call   3ed6 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     426:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     42d:	00 
     42e:	c7 44 24 04 44 46 00 	movl   $0x4644,0x4(%esp)
     435:	00 
     436:	8b 45 f0             	mov    -0x10(%ebp),%eax
     439:	89 04 24             	mov    %eax,(%esp)
     43c:	e8 b5 3a 00 00       	call   3ef6 <write>
     441:	83 f8 0a             	cmp    $0xa,%eax
     444:	74 21                	je     467 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     446:	a1 e4 62 00 00       	mov    0x62e4,%eax
     44b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     44e:	89 54 24 08          	mov    %edx,0x8(%esp)
     452:	c7 44 24 04 50 46 00 	movl   $0x4650,0x4(%esp)
     459:	00 
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 f9 3b 00 00       	call   405b <printf>
      exit();
     462:	e8 6f 3a 00 00       	call   3ed6 <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     467:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     46b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     46f:	0f 8e 70 ff ff ff    	jle    3e5 <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     475:	a1 e4 62 00 00       	mov    0x62e4,%eax
     47a:	c7 44 24 04 74 46 00 	movl   $0x4674,0x4(%esp)
     481:	00 
     482:	89 04 24             	mov    %eax,(%esp)
     485:	e8 d1 3b 00 00       	call   405b <printf>
  close(fd);
     48a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     48d:	89 04 24             	mov    %eax,(%esp)
     490:	e8 69 3a 00 00       	call   3efe <close>
  fd = open("small", O_RDONLY);
     495:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     49c:	00 
     49d:	c7 04 24 d5 45 00 00 	movl   $0x45d5,(%esp)
     4a4:	e8 6d 3a 00 00       	call   3f16 <open>
     4a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4b0:	78 3e                	js     4f0 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
     4b2:	a1 e4 62 00 00       	mov    0x62e4,%eax
     4b7:	c7 44 24 04 7f 46 00 	movl   $0x467f,0x4(%esp)
     4be:	00 
     4bf:	89 04 24             	mov    %eax,(%esp)
     4c2:	e8 94 3b 00 00       	call   405b <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4c7:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     4ce:	00 
     4cf:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     4d6:	00 
     4d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4da:	89 04 24             	mov    %eax,(%esp)
     4dd:	e8 0c 3a 00 00       	call   3eee <read>
     4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     4e5:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     4ec:	74 1c                	je     50a <writetest+0x198>
     4ee:	eb 4c                	jmp    53c <writetest+0x1ca>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     4f0:	a1 e4 62 00 00       	mov    0x62e4,%eax
     4f5:	c7 44 24 04 98 46 00 	movl   $0x4698,0x4(%esp)
     4fc:	00 
     4fd:	89 04 24             	mov    %eax,(%esp)
     500:	e8 56 3b 00 00       	call   405b <printf>
    exit();
     505:	e8 cc 39 00 00       	call   3ed6 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     50a:	a1 e4 62 00 00       	mov    0x62e4,%eax
     50f:	c7 44 24 04 b3 46 00 	movl   $0x46b3,0x4(%esp)
     516:	00 
     517:	89 04 24             	mov    %eax,(%esp)
     51a:	e8 3c 3b 00 00       	call   405b <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     522:	89 04 24             	mov    %eax,(%esp)
     525:	e8 d4 39 00 00       	call   3efe <close>

  if(unlink("small") < 0){
     52a:	c7 04 24 d5 45 00 00 	movl   $0x45d5,(%esp)
     531:	e8 f0 39 00 00       	call   3f26 <unlink>
     536:	85 c0                	test   %eax,%eax
     538:	78 1c                	js     556 <writetest+0x1e4>
     53a:	eb 34                	jmp    570 <writetest+0x1fe>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     53c:	a1 e4 62 00 00       	mov    0x62e4,%eax
     541:	c7 44 24 04 c6 46 00 	movl   $0x46c6,0x4(%esp)
     548:	00 
     549:	89 04 24             	mov    %eax,(%esp)
     54c:	e8 0a 3b 00 00       	call   405b <printf>
    exit();
     551:	e8 80 39 00 00       	call   3ed6 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     556:	a1 e4 62 00 00       	mov    0x62e4,%eax
     55b:	c7 44 24 04 d3 46 00 	movl   $0x46d3,0x4(%esp)
     562:	00 
     563:	89 04 24             	mov    %eax,(%esp)
     566:	e8 f0 3a 00 00       	call   405b <printf>
    exit();
     56b:	e8 66 39 00 00       	call   3ed6 <exit>
  }
  printf(stdout, "small file test ok\n");
     570:	a1 e4 62 00 00       	mov    0x62e4,%eax
     575:	c7 44 24 04 e8 46 00 	movl   $0x46e8,0x4(%esp)
     57c:	00 
     57d:	89 04 24             	mov    %eax,(%esp)
     580:	e8 d6 3a 00 00       	call   405b <printf>
}
     585:	c9                   	leave  
     586:	c3                   	ret    

00000587 <writetest1>:

void
writetest1(void)
{
     587:	55                   	push   %ebp
     588:	89 e5                	mov    %esp,%ebp
     58a:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     58d:	a1 e4 62 00 00       	mov    0x62e4,%eax
     592:	c7 44 24 04 fc 46 00 	movl   $0x46fc,0x4(%esp)
     599:	00 
     59a:	89 04 24             	mov    %eax,(%esp)
     59d:	e8 b9 3a 00 00       	call   405b <printf>

  fd = open("big", O_CREATE|O_RDWR);
     5a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     5a9:	00 
     5aa:	c7 04 24 0c 47 00 00 	movl   $0x470c,(%esp)
     5b1:	e8 60 39 00 00       	call   3f16 <open>
     5b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5bd:	79 1a                	jns    5d9 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     5bf:	a1 e4 62 00 00       	mov    0x62e4,%eax
     5c4:	c7 44 24 04 10 47 00 	movl   $0x4710,0x4(%esp)
     5cb:	00 
     5cc:	89 04 24             	mov    %eax,(%esp)
     5cf:	e8 87 3a 00 00       	call   405b <printf>
    exit();
     5d4:	e8 fd 38 00 00       	call   3ed6 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     5d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     5e0:	eb 51                	jmp    633 <writetest1+0xac>
    ((int*)buf)[0] = i;
     5e2:	b8 c0 8a 00 00       	mov    $0x8ac0,%eax
     5e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5ea:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     5ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     5f3:	00 
     5f4:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     5fb:	00 
     5fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ff:	89 04 24             	mov    %eax,(%esp)
     602:	e8 ef 38 00 00       	call   3ef6 <write>
     607:	3d 00 02 00 00       	cmp    $0x200,%eax
     60c:	74 21                	je     62f <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     60e:	a1 e4 62 00 00       	mov    0x62e4,%eax
     613:	8b 55 f4             	mov    -0xc(%ebp),%edx
     616:	89 54 24 08          	mov    %edx,0x8(%esp)
     61a:	c7 44 24 04 2a 47 00 	movl   $0x472a,0x4(%esp)
     621:	00 
     622:	89 04 24             	mov    %eax,(%esp)
     625:	e8 31 3a 00 00       	call   405b <printf>
      exit();
     62a:	e8 a7 38 00 00       	call   3ed6 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     62f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     633:	8b 45 f4             	mov    -0xc(%ebp),%eax
     636:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     63b:	76 a5                	jbe    5e2 <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     63d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     640:	89 04 24             	mov    %eax,(%esp)
     643:	e8 b6 38 00 00       	call   3efe <close>

  fd = open("big", O_RDONLY);
     648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     64f:	00 
     650:	c7 04 24 0c 47 00 00 	movl   $0x470c,(%esp)
     657:	e8 ba 38 00 00       	call   3f16 <open>
     65c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     65f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     663:	79 1a                	jns    67f <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
     665:	a1 e4 62 00 00       	mov    0x62e4,%eax
     66a:	c7 44 24 04 48 47 00 	movl   $0x4748,0x4(%esp)
     671:	00 
     672:	89 04 24             	mov    %eax,(%esp)
     675:	e8 e1 39 00 00       	call   405b <printf>
    exit();
     67a:	e8 57 38 00 00       	call   3ed6 <exit>
  }

  n = 0;
     67f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     686:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     68d:	00 
     68e:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     695:	00 
     696:	8b 45 ec             	mov    -0x14(%ebp),%eax
     699:	89 04 24             	mov    %eax,(%esp)
     69c:	e8 4d 38 00 00       	call   3eee <read>
     6a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6a8:	75 2e                	jne    6d8 <writetest1+0x151>
      if(n == MAXFILE - 1){
     6aa:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6b1:	0f 85 8c 00 00 00    	jne    743 <writetest1+0x1bc>
        printf(stdout, "read only %d blocks from big", n);
     6b7:	a1 e4 62 00 00       	mov    0x62e4,%eax
     6bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
     6bf:	89 54 24 08          	mov    %edx,0x8(%esp)
     6c3:	c7 44 24 04 61 47 00 	movl   $0x4761,0x4(%esp)
     6ca:	00 
     6cb:	89 04 24             	mov    %eax,(%esp)
     6ce:	e8 88 39 00 00       	call   405b <printf>
        exit();
     6d3:	e8 fe 37 00 00       	call   3ed6 <exit>
      }
      break;
    } else if(i != 512){
     6d8:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     6df:	74 21                	je     702 <writetest1+0x17b>
      printf(stdout, "read failed %d\n", i);
     6e1:	a1 e4 62 00 00       	mov    0x62e4,%eax
     6e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6e9:	89 54 24 08          	mov    %edx,0x8(%esp)
     6ed:	c7 44 24 04 7e 47 00 	movl   $0x477e,0x4(%esp)
     6f4:	00 
     6f5:	89 04 24             	mov    %eax,(%esp)
     6f8:	e8 5e 39 00 00       	call   405b <printf>
      exit();
     6fd:	e8 d4 37 00 00       	call   3ed6 <exit>
    }
    if(((int*)buf)[0] != n){
     702:	b8 c0 8a 00 00       	mov    $0x8ac0,%eax
     707:	8b 00                	mov    (%eax),%eax
     709:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     70c:	74 2c                	je     73a <writetest1+0x1b3>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     70e:	b8 c0 8a 00 00       	mov    $0x8ac0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     713:	8b 10                	mov    (%eax),%edx
     715:	a1 e4 62 00 00       	mov    0x62e4,%eax
     71a:	89 54 24 0c          	mov    %edx,0xc(%esp)
     71e:	8b 55 f0             	mov    -0x10(%ebp),%edx
     721:	89 54 24 08          	mov    %edx,0x8(%esp)
     725:	c7 44 24 04 90 47 00 	movl   $0x4790,0x4(%esp)
     72c:	00 
     72d:	89 04 24             	mov    %eax,(%esp)
     730:	e8 26 39 00 00       	call   405b <printf>
             n, ((int*)buf)[0]);
      exit();
     735:	e8 9c 37 00 00       	call   3ed6 <exit>
    }
    n++;
     73a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     73e:	e9 43 ff ff ff       	jmp    686 <writetest1+0xff>
    if(i == 0){
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
     743:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     744:	8b 45 ec             	mov    -0x14(%ebp),%eax
     747:	89 04 24             	mov    %eax,(%esp)
     74a:	e8 af 37 00 00       	call   3efe <close>
  if(unlink("big") < 0){
     74f:	c7 04 24 0c 47 00 00 	movl   $0x470c,(%esp)
     756:	e8 cb 37 00 00       	call   3f26 <unlink>
     75b:	85 c0                	test   %eax,%eax
     75d:	79 1a                	jns    779 <writetest1+0x1f2>
    printf(stdout, "unlink big failed\n");
     75f:	a1 e4 62 00 00       	mov    0x62e4,%eax
     764:	c7 44 24 04 b0 47 00 	movl   $0x47b0,0x4(%esp)
     76b:	00 
     76c:	89 04 24             	mov    %eax,(%esp)
     76f:	e8 e7 38 00 00       	call   405b <printf>
    exit();
     774:	e8 5d 37 00 00       	call   3ed6 <exit>
  }
  printf(stdout, "big files ok\n");
     779:	a1 e4 62 00 00       	mov    0x62e4,%eax
     77e:	c7 44 24 04 c3 47 00 	movl   $0x47c3,0x4(%esp)
     785:	00 
     786:	89 04 24             	mov    %eax,(%esp)
     789:	e8 cd 38 00 00       	call   405b <printf>
}
     78e:	c9                   	leave  
     78f:	c3                   	ret    

00000790 <createtest>:

void
createtest(void)
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     796:	a1 e4 62 00 00       	mov    0x62e4,%eax
     79b:	c7 44 24 04 d4 47 00 	movl   $0x47d4,0x4(%esp)
     7a2:	00 
     7a3:	89 04 24             	mov    %eax,(%esp)
     7a6:	e8 b0 38 00 00       	call   405b <printf>

  name[0] = 'a';
     7ab:	c6 05 c0 aa 00 00 61 	movb   $0x61,0xaac0
  name[2] = '\0';
     7b2:	c6 05 c2 aa 00 00 00 	movb   $0x0,0xaac2
  for(i = 0; i < 52; i++){
     7b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7c0:	eb 31                	jmp    7f3 <createtest+0x63>
    name[1] = '0' + i;
     7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c5:	83 c0 30             	add    $0x30,%eax
     7c8:	a2 c1 aa 00 00       	mov    %al,0xaac1
    fd = open(name, O_CREATE|O_RDWR);
     7cd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7d4:	00 
     7d5:	c7 04 24 c0 aa 00 00 	movl   $0xaac0,(%esp)
     7dc:	e8 35 37 00 00       	call   3f16 <open>
     7e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7e7:	89 04 24             	mov    %eax,(%esp)
     7ea:	e8 0f 37 00 00       	call   3efe <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     7ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7f3:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     7f7:	7e c9                	jle    7c2 <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     7f9:	c6 05 c0 aa 00 00 61 	movb   $0x61,0xaac0
  name[2] = '\0';
     800:	c6 05 c2 aa 00 00 00 	movb   $0x0,0xaac2
  for(i = 0; i < 52; i++){
     807:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     80e:	eb 1b                	jmp    82b <createtest+0x9b>
    name[1] = '0' + i;
     810:	8b 45 f4             	mov    -0xc(%ebp),%eax
     813:	83 c0 30             	add    $0x30,%eax
     816:	a2 c1 aa 00 00       	mov    %al,0xaac1
    unlink(name);
     81b:	c7 04 24 c0 aa 00 00 	movl   $0xaac0,(%esp)
     822:	e8 ff 36 00 00       	call   3f26 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     827:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     82b:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     82f:	7e df                	jle    810 <createtest+0x80>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     831:	a1 e4 62 00 00       	mov    0x62e4,%eax
     836:	c7 44 24 04 fc 47 00 	movl   $0x47fc,0x4(%esp)
     83d:	00 
     83e:	89 04 24             	mov    %eax,(%esp)
     841:	e8 15 38 00 00       	call   405b <printf>
}
     846:	c9                   	leave  
     847:	c3                   	ret    

00000848 <dirtest>:

void dirtest(void)
{
     848:	55                   	push   %ebp
     849:	89 e5                	mov    %esp,%ebp
     84b:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     84e:	a1 e4 62 00 00       	mov    0x62e4,%eax
     853:	c7 44 24 04 22 48 00 	movl   $0x4822,0x4(%esp)
     85a:	00 
     85b:	89 04 24             	mov    %eax,(%esp)
     85e:	e8 f8 37 00 00       	call   405b <printf>

  if(mkdir("dir0") < 0){
     863:	c7 04 24 2e 48 00 00 	movl   $0x482e,(%esp)
     86a:	e8 cf 36 00 00       	call   3f3e <mkdir>
     86f:	85 c0                	test   %eax,%eax
     871:	79 1a                	jns    88d <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     873:	a1 e4 62 00 00       	mov    0x62e4,%eax
     878:	c7 44 24 04 51 44 00 	movl   $0x4451,0x4(%esp)
     87f:	00 
     880:	89 04 24             	mov    %eax,(%esp)
     883:	e8 d3 37 00 00       	call   405b <printf>
    exit();
     888:	e8 49 36 00 00       	call   3ed6 <exit>
  }

  if(chdir("dir0") < 0){
     88d:	c7 04 24 2e 48 00 00 	movl   $0x482e,(%esp)
     894:	e8 ad 36 00 00       	call   3f46 <chdir>
     899:	85 c0                	test   %eax,%eax
     89b:	79 1a                	jns    8b7 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     89d:	a1 e4 62 00 00       	mov    0x62e4,%eax
     8a2:	c7 44 24 04 33 48 00 	movl   $0x4833,0x4(%esp)
     8a9:	00 
     8aa:	89 04 24             	mov    %eax,(%esp)
     8ad:	e8 a9 37 00 00       	call   405b <printf>
    exit();
     8b2:	e8 1f 36 00 00       	call   3ed6 <exit>
  }

  if(chdir("..") < 0){
     8b7:	c7 04 24 46 48 00 00 	movl   $0x4846,(%esp)
     8be:	e8 83 36 00 00       	call   3f46 <chdir>
     8c3:	85 c0                	test   %eax,%eax
     8c5:	79 1a                	jns    8e1 <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     8c7:	a1 e4 62 00 00       	mov    0x62e4,%eax
     8cc:	c7 44 24 04 49 48 00 	movl   $0x4849,0x4(%esp)
     8d3:	00 
     8d4:	89 04 24             	mov    %eax,(%esp)
     8d7:	e8 7f 37 00 00       	call   405b <printf>
    exit();
     8dc:	e8 f5 35 00 00       	call   3ed6 <exit>
  }

  if(unlink("dir0") < 0){
     8e1:	c7 04 24 2e 48 00 00 	movl   $0x482e,(%esp)
     8e8:	e8 39 36 00 00       	call   3f26 <unlink>
     8ed:	85 c0                	test   %eax,%eax
     8ef:	79 1a                	jns    90b <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     8f1:	a1 e4 62 00 00       	mov    0x62e4,%eax
     8f6:	c7 44 24 04 5a 48 00 	movl   $0x485a,0x4(%esp)
     8fd:	00 
     8fe:	89 04 24             	mov    %eax,(%esp)
     901:	e8 55 37 00 00       	call   405b <printf>
    exit();
     906:	e8 cb 35 00 00       	call   3ed6 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     90b:	a1 e4 62 00 00       	mov    0x62e4,%eax
     910:	c7 44 24 04 6e 48 00 	movl   $0x486e,0x4(%esp)
     917:	00 
     918:	89 04 24             	mov    %eax,(%esp)
     91b:	e8 3b 37 00 00       	call   405b <printf>
}
     920:	c9                   	leave  
     921:	c3                   	ret    

00000922 <exectest>:

void
exectest(void)
{
     922:	55                   	push   %ebp
     923:	89 e5                	mov    %esp,%ebp
     925:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     928:	a1 e4 62 00 00       	mov    0x62e4,%eax
     92d:	c7 44 24 04 7d 48 00 	movl   $0x487d,0x4(%esp)
     934:	00 
     935:	89 04 24             	mov    %eax,(%esp)
     938:	e8 1e 37 00 00       	call   405b <printf>
  if(exec("echo", echoargv) < 0){
     93d:	c7 44 24 04 d0 62 00 	movl   $0x62d0,0x4(%esp)
     944:	00 
     945:	c7 04 24 28 44 00 00 	movl   $0x4428,(%esp)
     94c:	e8 bd 35 00 00       	call   3f0e <exec>
     951:	85 c0                	test   %eax,%eax
     953:	79 1a                	jns    96f <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     955:	a1 e4 62 00 00       	mov    0x62e4,%eax
     95a:	c7 44 24 04 88 48 00 	movl   $0x4888,0x4(%esp)
     961:	00 
     962:	89 04 24             	mov    %eax,(%esp)
     965:	e8 f1 36 00 00       	call   405b <printf>
    exit();
     96a:	e8 67 35 00 00       	call   3ed6 <exit>
  }
}
     96f:	c9                   	leave  
     970:	c3                   	ret    

00000971 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     971:	55                   	push   %ebp
     972:	89 e5                	mov    %esp,%ebp
     974:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     977:	8d 45 d8             	lea    -0x28(%ebp),%eax
     97a:	89 04 24             	mov    %eax,(%esp)
     97d:	e8 64 35 00 00       	call   3ee6 <pipe>
     982:	85 c0                	test   %eax,%eax
     984:	74 19                	je     99f <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     986:	c7 44 24 04 9a 48 00 	movl   $0x489a,0x4(%esp)
     98d:	00 
     98e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     995:	e8 c1 36 00 00       	call   405b <printf>
    exit();
     99a:	e8 37 35 00 00       	call   3ed6 <exit>
  }
  pid = fork();
     99f:	e8 2a 35 00 00       	call   3ece <fork>
     9a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     9ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9b2:	0f 85 86 00 00 00    	jne    a3e <pipe1+0xcd>
    close(fds[0]);
     9b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
     9bb:	89 04 24             	mov    %eax,(%esp)
     9be:	e8 3b 35 00 00       	call   3efe <close>
    for(n = 0; n < 5; n++){
     9c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     9ca:	eb 67                	jmp    a33 <pipe1+0xc2>
      for(i = 0; i < 1033; i++)
     9cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     9d3:	eb 16                	jmp    9eb <pipe1+0x7a>
        buf[i] = seq++;
     9d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
     9db:	81 c2 c0 8a 00 00    	add    $0x8ac0,%edx
     9e1:	88 02                	mov    %al,(%edx)
     9e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     9e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     9eb:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     9f2:	7e e1                	jle    9d5 <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     9f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     9f7:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     9fe:	00 
     9ff:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     a06:	00 
     a07:	89 04 24             	mov    %eax,(%esp)
     a0a:	e8 e7 34 00 00       	call   3ef6 <write>
     a0f:	3d 09 04 00 00       	cmp    $0x409,%eax
     a14:	74 19                	je     a2f <pipe1+0xbe>
        printf(1, "pipe1 oops 1\n");
     a16:	c7 44 24 04 a9 48 00 	movl   $0x48a9,0x4(%esp)
     a1d:	00 
     a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a25:	e8 31 36 00 00       	call   405b <printf>
        exit();
     a2a:	e8 a7 34 00 00       	call   3ed6 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a2f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a33:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a37:	7e 93                	jle    9cc <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a39:	e8 98 34 00 00       	call   3ed6 <exit>
  } else if(pid > 0){
     a3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a42:	0f 8e fc 00 00 00    	jle    b44 <pipe1+0x1d3>
    close(fds[1]);
     a48:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a4b:	89 04 24             	mov    %eax,(%esp)
     a4e:	e8 ab 34 00 00       	call   3efe <close>
    total = 0;
     a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     a5a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a61:	eb 6b                	jmp    ace <pipe1+0x15d>
      for(i = 0; i < n; i++){
     a63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a6a:	eb 40                	jmp    aac <pipe1+0x13b>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a6f:	05 c0 8a 00 00       	add    $0x8ac0,%eax
     a74:	0f b6 00             	movzbl (%eax),%eax
     a77:	0f be c0             	movsbl %al,%eax
     a7a:	33 45 f4             	xor    -0xc(%ebp),%eax
     a7d:	25 ff 00 00 00       	and    $0xff,%eax
     a82:	85 c0                	test   %eax,%eax
     a84:	0f 95 c0             	setne  %al
     a87:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a8b:	84 c0                	test   %al,%al
     a8d:	74 19                	je     aa8 <pipe1+0x137>
          printf(1, "pipe1 oops 2\n");
     a8f:	c7 44 24 04 b7 48 00 	movl   $0x48b7,0x4(%esp)
     a96:	00 
     a97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a9e:	e8 b8 35 00 00       	call   405b <printf>
     aa3:	e9 b5 00 00 00       	jmp    b5d <pipe1+0x1ec>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     aa8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aaf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     ab2:	7c b8                	jl     a6c <pipe1+0xfb>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ab7:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     aba:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ac0:	3d 00 20 00 00       	cmp    $0x2000,%eax
     ac5:	76 07                	jbe    ace <pipe1+0x15d>
        cc = sizeof(buf);
     ac7:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     ace:	8b 45 d8             	mov    -0x28(%ebp),%eax
     ad1:	8b 55 e8             	mov    -0x18(%ebp),%edx
     ad4:	89 54 24 08          	mov    %edx,0x8(%esp)
     ad8:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     adf:	00 
     ae0:	89 04 24             	mov    %eax,(%esp)
     ae3:	e8 06 34 00 00       	call   3eee <read>
     ae8:	89 45 ec             	mov    %eax,-0x14(%ebp)
     aeb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     aef:	0f 8f 6e ff ff ff    	jg     a63 <pipe1+0xf2>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     af5:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     afc:	74 20                	je     b1e <pipe1+0x1ad>
      printf(1, "pipe1 oops 3 total %d\n", total);
     afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b01:	89 44 24 08          	mov    %eax,0x8(%esp)
     b05:	c7 44 24 04 c5 48 00 	movl   $0x48c5,0x4(%esp)
     b0c:	00 
     b0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b14:	e8 42 35 00 00       	call   405b <printf>
      exit();
     b19:	e8 b8 33 00 00       	call   3ed6 <exit>
    }
    close(fds[0]);
     b1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b21:	89 04 24             	mov    %eax,(%esp)
     b24:	e8 d5 33 00 00       	call   3efe <close>
    wait();
     b29:	e8 b0 33 00 00       	call   3ede <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b2e:	c7 44 24 04 dc 48 00 	movl   $0x48dc,0x4(%esp)
     b35:	00 
     b36:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b3d:	e8 19 35 00 00       	call   405b <printf>
     b42:	eb 19                	jmp    b5d <pipe1+0x1ec>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b44:	c7 44 24 04 e6 48 00 	movl   $0x48e6,0x4(%esp)
     b4b:	00 
     b4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b53:	e8 03 35 00 00       	call   405b <printf>
    exit();
     b58:	e8 79 33 00 00       	call   3ed6 <exit>
  }
  printf(1, "pipe1 ok\n");
}
     b5d:	c9                   	leave  
     b5e:	c3                   	ret    

00000b5f <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b5f:	55                   	push   %ebp
     b60:	89 e5                	mov    %esp,%ebp
     b62:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b65:	c7 44 24 04 f5 48 00 	movl   $0x48f5,0x4(%esp)
     b6c:	00 
     b6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b74:	e8 e2 34 00 00       	call   405b <printf>
  pid1 = fork();
     b79:	e8 50 33 00 00       	call   3ece <fork>
     b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     b81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b85:	75 02                	jne    b89 <preempt+0x2a>
    for(;;)
      ;
     b87:	eb fe                	jmp    b87 <preempt+0x28>

  pid2 = fork();
     b89:	e8 40 33 00 00       	call   3ece <fork>
     b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     b91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b95:	75 02                	jne    b99 <preempt+0x3a>
    for(;;)
      ;
     b97:	eb fe                	jmp    b97 <preempt+0x38>

  pipe(pfds);
     b99:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b9c:	89 04 24             	mov    %eax,(%esp)
     b9f:	e8 42 33 00 00       	call   3ee6 <pipe>
  pid3 = fork();
     ba4:	e8 25 33 00 00       	call   3ece <fork>
     ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bb0:	75 4c                	jne    bfe <preempt+0x9f>
    close(pfds[0]);
     bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bb5:	89 04 24             	mov    %eax,(%esp)
     bb8:	e8 41 33 00 00       	call   3efe <close>
    if(write(pfds[1], "x", 1) != 1)
     bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bc0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bc7:	00 
     bc8:	c7 44 24 04 ff 48 00 	movl   $0x48ff,0x4(%esp)
     bcf:	00 
     bd0:	89 04 24             	mov    %eax,(%esp)
     bd3:	e8 1e 33 00 00       	call   3ef6 <write>
     bd8:	83 f8 01             	cmp    $0x1,%eax
     bdb:	74 14                	je     bf1 <preempt+0x92>
      printf(1, "preempt write error");
     bdd:	c7 44 24 04 01 49 00 	movl   $0x4901,0x4(%esp)
     be4:	00 
     be5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bec:	e8 6a 34 00 00       	call   405b <printf>
    close(pfds[1]);
     bf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf4:	89 04 24             	mov    %eax,(%esp)
     bf7:	e8 02 33 00 00       	call   3efe <close>
    for(;;)
      ;
     bfc:	eb fe                	jmp    bfc <preempt+0x9d>
  }

  close(pfds[1]);
     bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c01:	89 04 24             	mov    %eax,(%esp)
     c04:	e8 f5 32 00 00       	call   3efe <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c0c:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     c13:	00 
     c14:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     c1b:	00 
     c1c:	89 04 24             	mov    %eax,(%esp)
     c1f:	e8 ca 32 00 00       	call   3eee <read>
     c24:	83 f8 01             	cmp    $0x1,%eax
     c27:	74 16                	je     c3f <preempt+0xe0>
    printf(1, "preempt read error");
     c29:	c7 44 24 04 15 49 00 	movl   $0x4915,0x4(%esp)
     c30:	00 
     c31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c38:	e8 1e 34 00 00       	call   405b <printf>
     c3d:	eb 77                	jmp    cb6 <preempt+0x157>
    return;
  }
  close(pfds[0]);
     c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c42:	89 04 24             	mov    %eax,(%esp)
     c45:	e8 b4 32 00 00       	call   3efe <close>
  printf(1, "kill... ");
     c4a:	c7 44 24 04 28 49 00 	movl   $0x4928,0x4(%esp)
     c51:	00 
     c52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c59:	e8 fd 33 00 00       	call   405b <printf>
  kill(pid1);
     c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c61:	89 04 24             	mov    %eax,(%esp)
     c64:	e8 9d 32 00 00       	call   3f06 <kill>
  kill(pid2);
     c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6c:	89 04 24             	mov    %eax,(%esp)
     c6f:	e8 92 32 00 00       	call   3f06 <kill>
  kill(pid3);
     c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c77:	89 04 24             	mov    %eax,(%esp)
     c7a:	e8 87 32 00 00       	call   3f06 <kill>
  printf(1, "wait... ");
     c7f:	c7 44 24 04 31 49 00 	movl   $0x4931,0x4(%esp)
     c86:	00 
     c87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c8e:	e8 c8 33 00 00       	call   405b <printf>
  wait();
     c93:	e8 46 32 00 00       	call   3ede <wait>
  wait();
     c98:	e8 41 32 00 00       	call   3ede <wait>
  wait();
     c9d:	e8 3c 32 00 00       	call   3ede <wait>
  printf(1, "preempt ok\n");
     ca2:	c7 44 24 04 3a 49 00 	movl   $0x493a,0x4(%esp)
     ca9:	00 
     caa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cb1:	e8 a5 33 00 00       	call   405b <printf>
}
     cb6:	c9                   	leave  
     cb7:	c3                   	ret    

00000cb8 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     cb8:	55                   	push   %ebp
     cb9:	89 e5                	mov    %esp,%ebp
     cbb:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cc5:	eb 53                	jmp    d1a <exitwait+0x62>
    pid = fork();
     cc7:	e8 02 32 00 00       	call   3ece <fork>
     ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     ccf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cd3:	79 16                	jns    ceb <exitwait+0x33>
      printf(1, "fork failed\n");
     cd5:	c7 44 24 04 c9 44 00 	movl   $0x44c9,0x4(%esp)
     cdc:	00 
     cdd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ce4:	e8 72 33 00 00       	call   405b <printf>
      return;
     ce9:	eb 49                	jmp    d34 <exitwait+0x7c>
    }
    if(pid){
     ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cef:	74 20                	je     d11 <exitwait+0x59>
      if(wait() != pid){
     cf1:	e8 e8 31 00 00       	call   3ede <wait>
     cf6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     cf9:	74 1b                	je     d16 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     cfb:	c7 44 24 04 46 49 00 	movl   $0x4946,0x4(%esp)
     d02:	00 
     d03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d0a:	e8 4c 33 00 00       	call   405b <printf>
        return;
     d0f:	eb 23                	jmp    d34 <exitwait+0x7c>
      }
    } else {
      exit();
     d11:	e8 c0 31 00 00       	call   3ed6 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d16:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d1a:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d1e:	7e a7                	jle    cc7 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d20:	c7 44 24 04 56 49 00 	movl   $0x4956,0x4(%esp)
     d27:	00 
     d28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d2f:	e8 27 33 00 00       	call   405b <printf>
}
     d34:	c9                   	leave  
     d35:	c3                   	ret    

00000d36 <mem>:

void
mem(void)
{
     d36:	55                   	push   %ebp
     d37:	89 e5                	mov    %esp,%ebp
     d39:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d3c:	c7 44 24 04 63 49 00 	movl   $0x4963,0x4(%esp)
     d43:	00 
     d44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d4b:	e8 0b 33 00 00       	call   405b <printf>
  ppid = getpid();
     d50:	e8 01 32 00 00       	call   3f56 <getpid>
     d55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     d58:	e8 71 31 00 00       	call   3ece <fork>
     d5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d64:	0f 85 aa 00 00 00    	jne    e14 <mem+0xde>
    m1 = 0;
     d6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     d71:	eb 0e                	jmp    d81 <mem+0x4b>
      *(char**)m2 = m1;
     d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d79:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     d7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     d81:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     d88:	e8 bb 35 00 00       	call   4348 <malloc>
     d8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
     d90:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d94:	75 dd                	jne    d73 <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     d96:	eb 19                	jmp    db1 <mem+0x7b>
      m2 = *(char**)m1;
     d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9b:	8b 00                	mov    (%eax),%eax
     d9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     da3:	89 04 24             	mov    %eax,(%esp)
     da6:	e8 64 34 00 00       	call   420f <free>
      m1 = m2;
     dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     db5:	75 e1                	jne    d98 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     db7:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     dbe:	e8 85 35 00 00       	call   4348 <malloc>
     dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     dca:	75 24                	jne    df0 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     dcc:	c7 44 24 04 6d 49 00 	movl   $0x496d,0x4(%esp)
     dd3:	00 
     dd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ddb:	e8 7b 32 00 00       	call   405b <printf>
      kill(ppid);
     de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     de3:	89 04 24             	mov    %eax,(%esp)
     de6:	e8 1b 31 00 00       	call   3f06 <kill>
      exit();
     deb:	e8 e6 30 00 00       	call   3ed6 <exit>
    }
    free(m1);
     df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df3:	89 04 24             	mov    %eax,(%esp)
     df6:	e8 14 34 00 00       	call   420f <free>
    printf(1, "mem ok\n");
     dfb:	c7 44 24 04 87 49 00 	movl   $0x4987,0x4(%esp)
     e02:	00 
     e03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e0a:	e8 4c 32 00 00       	call   405b <printf>
    exit();
     e0f:	e8 c2 30 00 00       	call   3ed6 <exit>
  } else {
    wait();
     e14:	e8 c5 30 00 00       	call   3ede <wait>
  }
}
     e19:	c9                   	leave  
     e1a:	c3                   	ret    

00000e1b <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e1b:	55                   	push   %ebp
     e1c:	89 e5                	mov    %esp,%ebp
     e1e:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e21:	c7 44 24 04 8f 49 00 	movl   $0x498f,0x4(%esp)
     e28:	00 
     e29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e30:	e8 26 32 00 00       	call   405b <printf>

  unlink("sharedfd");
     e35:	c7 04 24 9e 49 00 00 	movl   $0x499e,(%esp)
     e3c:	e8 e5 30 00 00       	call   3f26 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e41:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e48:	00 
     e49:	c7 04 24 9e 49 00 00 	movl   $0x499e,(%esp)
     e50:	e8 c1 30 00 00       	call   3f16 <open>
     e55:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     e58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e5c:	79 19                	jns    e77 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     e5e:	c7 44 24 04 a8 49 00 	movl   $0x49a8,0x4(%esp)
     e65:	00 
     e66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e6d:	e8 e9 31 00 00       	call   405b <printf>
     e72:	e9 a0 01 00 00       	jmp    1017 <sharedfd+0x1fc>
    return;
  }
  pid = fork();
     e77:	e8 52 30 00 00       	call   3ece <fork>
     e7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     e83:	75 07                	jne    e8c <sharedfd+0x71>
     e85:	b8 63 00 00 00       	mov    $0x63,%eax
     e8a:	eb 05                	jmp    e91 <sharedfd+0x76>
     e8c:	b8 70 00 00 00       	mov    $0x70,%eax
     e91:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     e98:	00 
     e99:	89 44 24 04          	mov    %eax,0x4(%esp)
     e9d:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ea0:	89 04 24             	mov    %eax,(%esp)
     ea3:	e8 88 2e 00 00       	call   3d30 <memset>
  for(i = 0; i < 1000; i++){
     ea8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eaf:	eb 39                	jmp    eea <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     eb1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     eb8:	00 
     eb9:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
     ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ec3:	89 04 24             	mov    %eax,(%esp)
     ec6:	e8 2b 30 00 00       	call   3ef6 <write>
     ecb:	83 f8 0a             	cmp    $0xa,%eax
     ece:	74 16                	je     ee6 <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     ed0:	c7 44 24 04 d4 49 00 	movl   $0x49d4,0x4(%esp)
     ed7:	00 
     ed8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     edf:	e8 77 31 00 00       	call   405b <printf>
      break;
     ee4:	eb 0d                	jmp    ef3 <sharedfd+0xd8>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     ee6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     eea:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     ef1:	7e be                	jle    eb1 <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     ef3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ef7:	75 05                	jne    efe <sharedfd+0xe3>
    exit();
     ef9:	e8 d8 2f 00 00       	call   3ed6 <exit>
  else
    wait();
     efe:	e8 db 2f 00 00       	call   3ede <wait>
  close(fd);
     f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f06:	89 04 24             	mov    %eax,(%esp)
     f09:	e8 f0 2f 00 00       	call   3efe <close>
  fd = open("sharedfd", 0);
     f0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f15:	00 
     f16:	c7 04 24 9e 49 00 00 	movl   $0x499e,(%esp)
     f1d:	e8 f4 2f 00 00       	call   3f16 <open>
     f22:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f25:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f29:	79 19                	jns    f44 <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f2b:	c7 44 24 04 f4 49 00 	movl   $0x49f4,0x4(%esp)
     f32:	00 
     f33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f3a:	e8 1c 31 00 00       	call   405b <printf>
     f3f:	e9 d3 00 00 00       	jmp    1017 <sharedfd+0x1fc>
    return;
  }
  nc = np = 0;
     f44:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f51:	eb 3b                	jmp    f8e <sharedfd+0x173>
    for(i = 0; i < sizeof(buf); i++){
     f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f5a:	eb 2a                	jmp    f86 <sharedfd+0x16b>
      if(buf[i] == 'c')
     f5c:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f62:	01 d0                	add    %edx,%eax
     f64:	0f b6 00             	movzbl (%eax),%eax
     f67:	3c 63                	cmp    $0x63,%al
     f69:	75 04                	jne    f6f <sharedfd+0x154>
        nc++;
     f6b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     f6f:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f75:	01 d0                	add    %edx,%eax
     f77:	0f b6 00             	movzbl (%eax),%eax
     f7a:	3c 70                	cmp    $0x70,%al
     f7c:	75 04                	jne    f82 <sharedfd+0x167>
        np++;
     f7e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     f82:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f89:	83 f8 09             	cmp    $0x9,%eax
     f8c:	76 ce                	jbe    f5c <sharedfd+0x141>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f8e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f95:	00 
     f96:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f99:	89 44 24 04          	mov    %eax,0x4(%esp)
     f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fa0:	89 04 24             	mov    %eax,(%esp)
     fa3:	e8 46 2f 00 00       	call   3eee <read>
     fa8:	89 45 e0             	mov    %eax,-0x20(%ebp)
     fab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     faf:	7f a2                	jg     f53 <sharedfd+0x138>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fb4:	89 04 24             	mov    %eax,(%esp)
     fb7:	e8 42 2f 00 00       	call   3efe <close>
  unlink("sharedfd");
     fbc:	c7 04 24 9e 49 00 00 	movl   $0x499e,(%esp)
     fc3:	e8 5e 2f 00 00       	call   3f26 <unlink>
  if(nc == 10000 && np == 10000){
     fc8:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     fcf:	75 1f                	jne    ff0 <sharedfd+0x1d5>
     fd1:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     fd8:	75 16                	jne    ff0 <sharedfd+0x1d5>
    printf(1, "sharedfd ok\n");
     fda:	c7 44 24 04 1f 4a 00 	movl   $0x4a1f,0x4(%esp)
     fe1:	00 
     fe2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fe9:	e8 6d 30 00 00       	call   405b <printf>
     fee:	eb 27                	jmp    1017 <sharedfd+0x1fc>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ff3:	89 44 24 0c          	mov    %eax,0xc(%esp)
     ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ffa:	89 44 24 08          	mov    %eax,0x8(%esp)
     ffe:	c7 44 24 04 2c 4a 00 	movl   $0x4a2c,0x4(%esp)
    1005:	00 
    1006:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    100d:	e8 49 30 00 00       	call   405b <printf>
    exit();
    1012:	e8 bf 2e 00 00       	call   3ed6 <exit>
  }
}
    1017:	c9                   	leave  
    1018:	c3                   	ret    

00001019 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1019:	55                   	push   %ebp
    101a:	89 e5                	mov    %esp,%ebp
    101c:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    101f:	c7 45 c8 41 4a 00 00 	movl   $0x4a41,-0x38(%ebp)
    1026:	c7 45 cc 44 4a 00 00 	movl   $0x4a44,-0x34(%ebp)
    102d:	c7 45 d0 47 4a 00 00 	movl   $0x4a47,-0x30(%ebp)
    1034:	c7 45 d4 4a 4a 00 00 	movl   $0x4a4a,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    103b:	c7 44 24 04 4d 4a 00 	movl   $0x4a4d,0x4(%esp)
    1042:	00 
    1043:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    104a:	e8 0c 30 00 00       	call   405b <printf>

  for(pi = 0; pi < 4; pi++){
    104f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1056:	e9 fc 00 00 00       	jmp    1157 <fourfiles+0x13e>
    fname = names[pi];
    105b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    105e:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    1062:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    1065:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1068:	89 04 24             	mov    %eax,(%esp)
    106b:	e8 b6 2e 00 00       	call   3f26 <unlink>

    pid = fork();
    1070:	e8 59 2e 00 00       	call   3ece <fork>
    1075:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(pid < 0){
    1078:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    107c:	79 19                	jns    1097 <fourfiles+0x7e>
      printf(1, "fork failed\n");
    107e:	c7 44 24 04 c9 44 00 	movl   $0x44c9,0x4(%esp)
    1085:	00 
    1086:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    108d:	e8 c9 2f 00 00       	call   405b <printf>
      exit();
    1092:	e8 3f 2e 00 00       	call   3ed6 <exit>
    }

    if(pid == 0){
    1097:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    109b:	0f 85 b2 00 00 00    	jne    1153 <fourfiles+0x13a>
      fd = open(fname, O_CREATE | O_RDWR);
    10a1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10a8:	00 
    10a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10ac:	89 04 24             	mov    %eax,(%esp)
    10af:	e8 62 2e 00 00       	call   3f16 <open>
    10b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(fd < 0){
    10b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    10bb:	79 19                	jns    10d6 <fourfiles+0xbd>
        printf(1, "create failed\n");
    10bd:	c7 44 24 04 5d 4a 00 	movl   $0x4a5d,0x4(%esp)
    10c4:	00 
    10c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10cc:	e8 8a 2f 00 00       	call   405b <printf>
        exit();
    10d1:	e8 00 2e 00 00       	call   3ed6 <exit>
      }
      
      memset(buf, '0'+pi, 512);
    10d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10d9:	83 c0 30             	add    $0x30,%eax
    10dc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    10e3:	00 
    10e4:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e8:	c7 04 24 c0 8a 00 00 	movl   $0x8ac0,(%esp)
    10ef:	e8 3c 2c 00 00       	call   3d30 <memset>
      for(i = 0; i < 12; i++){
    10f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10fb:	eb 4b                	jmp    1148 <fourfiles+0x12f>
        if((n = write(fd, buf, 500)) != 500){
    10fd:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    1104:	00 
    1105:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    110c:	00 
    110d:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1110:	89 04 24             	mov    %eax,(%esp)
    1113:	e8 de 2d 00 00       	call   3ef6 <write>
    1118:	89 45 d8             	mov    %eax,-0x28(%ebp)
    111b:	81 7d d8 f4 01 00 00 	cmpl   $0x1f4,-0x28(%ebp)
    1122:	74 20                	je     1144 <fourfiles+0x12b>
          printf(1, "write failed %d\n", n);
    1124:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1127:	89 44 24 08          	mov    %eax,0x8(%esp)
    112b:	c7 44 24 04 6c 4a 00 	movl   $0x4a6c,0x4(%esp)
    1132:	00 
    1133:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    113a:	e8 1c 2f 00 00       	call   405b <printf>
          exit();
    113f:	e8 92 2d 00 00       	call   3ed6 <exit>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    1144:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1148:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    114c:	7e af                	jle    10fd <fourfiles+0xe4>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    114e:	e8 83 2d 00 00       	call   3ed6 <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    1153:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1157:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    115b:	0f 8e fa fe ff ff    	jle    105b <fourfiles+0x42>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1161:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1168:	eb 09                	jmp    1173 <fourfiles+0x15a>
    wait();
    116a:	e8 6f 2d 00 00       	call   3ede <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    116f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1173:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1177:	7e f1                	jle    116a <fourfiles+0x151>
    wait();
  }

  for(i = 0; i < 2; i++){
    1179:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1180:	e9 dc 00 00 00       	jmp    1261 <fourfiles+0x248>
    fname = names[i];
    1185:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1188:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    118c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    118f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1196:	00 
    1197:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    119a:	89 04 24             	mov    %eax,(%esp)
    119d:	e8 74 2d 00 00       	call   3f16 <open>
    11a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    total = 0;
    11a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11ac:	eb 4c                	jmp    11fa <fourfiles+0x1e1>
      for(j = 0; j < n; j++){
    11ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11b5:	eb 35                	jmp    11ec <fourfiles+0x1d3>
        if(buf[j] != '0'+i){
    11b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11ba:	05 c0 8a 00 00       	add    $0x8ac0,%eax
    11bf:	0f b6 00             	movzbl (%eax),%eax
    11c2:	0f be c0             	movsbl %al,%eax
    11c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11c8:	83 c2 30             	add    $0x30,%edx
    11cb:	39 d0                	cmp    %edx,%eax
    11cd:	74 19                	je     11e8 <fourfiles+0x1cf>
          printf(1, "wrong char\n");
    11cf:	c7 44 24 04 7d 4a 00 	movl   $0x4a7d,0x4(%esp)
    11d6:	00 
    11d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11de:	e8 78 2e 00 00       	call   405b <printf>
          exit();
    11e3:	e8 ee 2c 00 00       	call   3ed6 <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    11e8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    11ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11ef:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    11f2:	7c c3                	jl     11b7 <fourfiles+0x19e>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    11f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
    11f7:	01 45 ec             	add    %eax,-0x14(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11fa:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1201:	00 
    1202:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    1209:	00 
    120a:	8b 45 dc             	mov    -0x24(%ebp),%eax
    120d:	89 04 24             	mov    %eax,(%esp)
    1210:	e8 d9 2c 00 00       	call   3eee <read>
    1215:	89 45 d8             	mov    %eax,-0x28(%ebp)
    1218:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    121c:	7f 90                	jg     11ae <fourfiles+0x195>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    121e:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1221:	89 04 24             	mov    %eax,(%esp)
    1224:	e8 d5 2c 00 00       	call   3efe <close>
    if(total != 12*500){
    1229:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1230:	74 20                	je     1252 <fourfiles+0x239>
      printf(1, "wrong length %d\n", total);
    1232:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1235:	89 44 24 08          	mov    %eax,0x8(%esp)
    1239:	c7 44 24 04 89 4a 00 	movl   $0x4a89,0x4(%esp)
    1240:	00 
    1241:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1248:	e8 0e 2e 00 00       	call   405b <printf>
      exit();
    124d:	e8 84 2c 00 00       	call   3ed6 <exit>
    }
    unlink(fname);
    1252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1255:	89 04 24             	mov    %eax,(%esp)
    1258:	e8 c9 2c 00 00       	call   3f26 <unlink>

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    125d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1261:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    1265:	0f 8e 1a ff ff ff    	jle    1185 <fourfiles+0x16c>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    126b:	c7 44 24 04 9a 4a 00 	movl   $0x4a9a,0x4(%esp)
    1272:	00 
    1273:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    127a:	e8 dc 2d 00 00       	call   405b <printf>
}
    127f:	c9                   	leave  
    1280:	c3                   	ret    

00001281 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1281:	55                   	push   %ebp
    1282:	89 e5                	mov    %esp,%ebp
    1284:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1287:	c7 44 24 04 a8 4a 00 	movl   $0x4aa8,0x4(%esp)
    128e:	00 
    128f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1296:	e8 c0 2d 00 00       	call   405b <printf>

  for(pi = 0; pi < 4; pi++){
    129b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12a2:	e9 f4 00 00 00       	jmp    139b <createdelete+0x11a>
    pid = fork();
    12a7:	e8 22 2c 00 00       	call   3ece <fork>
    12ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    12af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12b3:	79 19                	jns    12ce <createdelete+0x4d>
      printf(1, "fork failed\n");
    12b5:	c7 44 24 04 c9 44 00 	movl   $0x44c9,0x4(%esp)
    12bc:	00 
    12bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c4:	e8 92 2d 00 00       	call   405b <printf>
      exit();
    12c9:	e8 08 2c 00 00       	call   3ed6 <exit>
    }

    if(pid == 0){
    12ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12d2:	0f 85 bf 00 00 00    	jne    1397 <createdelete+0x116>
      name[0] = 'p' + pi;
    12d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12db:	83 c0 70             	add    $0x70,%eax
    12de:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    12e1:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    12e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12ec:	e9 97 00 00 00       	jmp    1388 <createdelete+0x107>
        name[1] = '0' + i;
    12f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f4:	83 c0 30             	add    $0x30,%eax
    12f7:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    12fa:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1301:	00 
    1302:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1305:	89 04 24             	mov    %eax,(%esp)
    1308:	e8 09 2c 00 00       	call   3f16 <open>
    130d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    1310:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1314:	79 19                	jns    132f <createdelete+0xae>
          printf(1, "create failed\n");
    1316:	c7 44 24 04 5d 4a 00 	movl   $0x4a5d,0x4(%esp)
    131d:	00 
    131e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1325:	e8 31 2d 00 00       	call   405b <printf>
          exit();
    132a:	e8 a7 2b 00 00       	call   3ed6 <exit>
        }
        close(fd);
    132f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1332:	89 04 24             	mov    %eax,(%esp)
    1335:	e8 c4 2b 00 00       	call   3efe <close>
        if(i > 0 && (i % 2 ) == 0){
    133a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    133e:	7e 44                	jle    1384 <createdelete+0x103>
    1340:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1343:	83 e0 01             	and    $0x1,%eax
    1346:	85 c0                	test   %eax,%eax
    1348:	75 3a                	jne    1384 <createdelete+0x103>
          name[1] = '0' + (i / 2);
    134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134d:	89 c2                	mov    %eax,%edx
    134f:	c1 ea 1f             	shr    $0x1f,%edx
    1352:	01 d0                	add    %edx,%eax
    1354:	d1 f8                	sar    %eax
    1356:	83 c0 30             	add    $0x30,%eax
    1359:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    135c:	8d 45 c8             	lea    -0x38(%ebp),%eax
    135f:	89 04 24             	mov    %eax,(%esp)
    1362:	e8 bf 2b 00 00       	call   3f26 <unlink>
    1367:	85 c0                	test   %eax,%eax
    1369:	79 19                	jns    1384 <createdelete+0x103>
            printf(1, "unlink failed\n");
    136b:	c7 44 24 04 4c 45 00 	movl   $0x454c,0x4(%esp)
    1372:	00 
    1373:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    137a:	e8 dc 2c 00 00       	call   405b <printf>
            exit();
    137f:	e8 52 2b 00 00       	call   3ed6 <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    1384:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1388:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    138c:	0f 8e 5f ff ff ff    	jle    12f1 <createdelete+0x70>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    1392:	e8 3f 2b 00 00       	call   3ed6 <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    1397:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    139b:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    139f:	0f 8e 02 ff ff ff    	jle    12a7 <createdelete+0x26>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13ac:	eb 09                	jmp    13b7 <createdelete+0x136>
    wait();
    13ae:	e8 2b 2b 00 00       	call   3ede <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13b3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13b7:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13bb:	7e f1                	jle    13ae <createdelete+0x12d>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13bd:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13c1:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13c5:	88 45 c9             	mov    %al,-0x37(%ebp)
    13c8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13cc:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13d6:	e9 bb 00 00 00       	jmp    1496 <createdelete+0x215>
    for(pi = 0; pi < 4; pi++){
    13db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13e2:	e9 a1 00 00 00       	jmp    1488 <createdelete+0x207>
      name[0] = 'p' + pi;
    13e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13ea:	83 c0 70             	add    $0x70,%eax
    13ed:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    13f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f3:	83 c0 30             	add    $0x30,%eax
    13f6:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    13f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1400:	00 
    1401:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1404:	89 04 24             	mov    %eax,(%esp)
    1407:	e8 0a 2b 00 00       	call   3f16 <open>
    140c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    140f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1413:	74 06                	je     141b <createdelete+0x19a>
    1415:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1419:	7e 26                	jle    1441 <createdelete+0x1c0>
    141b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    141f:	79 20                	jns    1441 <createdelete+0x1c0>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1421:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1424:	89 44 24 08          	mov    %eax,0x8(%esp)
    1428:	c7 44 24 04 bc 4a 00 	movl   $0x4abc,0x4(%esp)
    142f:	00 
    1430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1437:	e8 1f 2c 00 00       	call   405b <printf>
        exit();
    143c:	e8 95 2a 00 00       	call   3ed6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1445:	7e 2c                	jle    1473 <createdelete+0x1f2>
    1447:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    144b:	7f 26                	jg     1473 <createdelete+0x1f2>
    144d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1451:	78 20                	js     1473 <createdelete+0x1f2>
        printf(1, "oops createdelete %s did exist\n", name);
    1453:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1456:	89 44 24 08          	mov    %eax,0x8(%esp)
    145a:	c7 44 24 04 e0 4a 00 	movl   $0x4ae0,0x4(%esp)
    1461:	00 
    1462:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1469:	e8 ed 2b 00 00       	call   405b <printf>
        exit();
    146e:	e8 63 2a 00 00       	call   3ed6 <exit>
      }
      if(fd >= 0)
    1473:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1477:	78 0b                	js     1484 <createdelete+0x203>
        close(fd);
    1479:	8b 45 e8             	mov    -0x18(%ebp),%eax
    147c:	89 04 24             	mov    %eax,(%esp)
    147f:	e8 7a 2a 00 00       	call   3efe <close>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    1484:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1488:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    148c:	0f 8e 55 ff ff ff    	jle    13e7 <createdelete+0x166>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    1492:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1496:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    149a:	0f 8e 3b ff ff ff    	jle    13db <createdelete+0x15a>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14a7:	eb 34                	jmp    14dd <createdelete+0x25c>
    for(pi = 0; pi < 4; pi++){
    14a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14b0:	eb 21                	jmp    14d3 <createdelete+0x252>
      name[0] = 'p' + i;
    14b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b5:	83 c0 70             	add    $0x70,%eax
    14b8:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14be:	83 c0 30             	add    $0x30,%eax
    14c1:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14c4:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14c7:	89 04 24             	mov    %eax,(%esp)
    14ca:	e8 57 2a 00 00       	call   3f26 <unlink>
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14cf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14d3:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14d7:	7e d9                	jle    14b2 <createdelete+0x231>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14dd:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14e1:	7e c6                	jle    14a9 <createdelete+0x228>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    14e3:	c7 44 24 04 00 4b 00 	movl   $0x4b00,0x4(%esp)
    14ea:	00 
    14eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14f2:	e8 64 2b 00 00       	call   405b <printf>
}
    14f7:	c9                   	leave  
    14f8:	c3                   	ret    

000014f9 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    14f9:	55                   	push   %ebp
    14fa:	89 e5                	mov    %esp,%ebp
    14fc:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    14ff:	c7 44 24 04 11 4b 00 	movl   $0x4b11,0x4(%esp)
    1506:	00 
    1507:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    150e:	e8 48 2b 00 00       	call   405b <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1513:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    151a:	00 
    151b:	c7 04 24 22 4b 00 00 	movl   $0x4b22,(%esp)
    1522:	e8 ef 29 00 00       	call   3f16 <open>
    1527:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    152a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    152e:	79 19                	jns    1549 <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    1530:	c7 44 24 04 2d 4b 00 	movl   $0x4b2d,0x4(%esp)
    1537:	00 
    1538:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    153f:	e8 17 2b 00 00       	call   405b <printf>
    exit();
    1544:	e8 8d 29 00 00       	call   3ed6 <exit>
  }
  write(fd, "hello", 5);
    1549:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1550:	00 
    1551:	c7 44 24 04 47 4b 00 	movl   $0x4b47,0x4(%esp)
    1558:	00 
    1559:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155c:	89 04 24             	mov    %eax,(%esp)
    155f:	e8 92 29 00 00       	call   3ef6 <write>
  close(fd);
    1564:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1567:	89 04 24             	mov    %eax,(%esp)
    156a:	e8 8f 29 00 00       	call   3efe <close>

  fd = open("unlinkread", O_RDWR);
    156f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1576:	00 
    1577:	c7 04 24 22 4b 00 00 	movl   $0x4b22,(%esp)
    157e:	e8 93 29 00 00       	call   3f16 <open>
    1583:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    158a:	79 19                	jns    15a5 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    158c:	c7 44 24 04 4d 4b 00 	movl   $0x4b4d,0x4(%esp)
    1593:	00 
    1594:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    159b:	e8 bb 2a 00 00       	call   405b <printf>
    exit();
    15a0:	e8 31 29 00 00       	call   3ed6 <exit>
  }
  if(unlink("unlinkread") != 0){
    15a5:	c7 04 24 22 4b 00 00 	movl   $0x4b22,(%esp)
    15ac:	e8 75 29 00 00       	call   3f26 <unlink>
    15b1:	85 c0                	test   %eax,%eax
    15b3:	74 19                	je     15ce <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    15b5:	c7 44 24 04 65 4b 00 	movl   $0x4b65,0x4(%esp)
    15bc:	00 
    15bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c4:	e8 92 2a 00 00       	call   405b <printf>
    exit();
    15c9:	e8 08 29 00 00       	call   3ed6 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15ce:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    15d5:	00 
    15d6:	c7 04 24 22 4b 00 00 	movl   $0x4b22,(%esp)
    15dd:	e8 34 29 00 00       	call   3f16 <open>
    15e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    15e5:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    15ec:	00 
    15ed:	c7 44 24 04 7f 4b 00 	movl   $0x4b7f,0x4(%esp)
    15f4:	00 
    15f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f8:	89 04 24             	mov    %eax,(%esp)
    15fb:	e8 f6 28 00 00       	call   3ef6 <write>
  close(fd1);
    1600:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1603:	89 04 24             	mov    %eax,(%esp)
    1606:	e8 f3 28 00 00       	call   3efe <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    160b:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1612:	00 
    1613:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    161a:	00 
    161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161e:	89 04 24             	mov    %eax,(%esp)
    1621:	e8 c8 28 00 00       	call   3eee <read>
    1626:	83 f8 05             	cmp    $0x5,%eax
    1629:	74 19                	je     1644 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    162b:	c7 44 24 04 83 4b 00 	movl   $0x4b83,0x4(%esp)
    1632:	00 
    1633:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    163a:	e8 1c 2a 00 00       	call   405b <printf>
    exit();
    163f:	e8 92 28 00 00       	call   3ed6 <exit>
  }
  if(buf[0] != 'h'){
    1644:	0f b6 05 c0 8a 00 00 	movzbl 0x8ac0,%eax
    164b:	3c 68                	cmp    $0x68,%al
    164d:	74 19                	je     1668 <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    164f:	c7 44 24 04 9a 4b 00 	movl   $0x4b9a,0x4(%esp)
    1656:	00 
    1657:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    165e:	e8 f8 29 00 00       	call   405b <printf>
    exit();
    1663:	e8 6e 28 00 00       	call   3ed6 <exit>
  }
  if(write(fd, buf, 10) != 10){
    1668:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    166f:	00 
    1670:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    1677:	00 
    1678:	8b 45 f4             	mov    -0xc(%ebp),%eax
    167b:	89 04 24             	mov    %eax,(%esp)
    167e:	e8 73 28 00 00       	call   3ef6 <write>
    1683:	83 f8 0a             	cmp    $0xa,%eax
    1686:	74 19                	je     16a1 <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    1688:	c7 44 24 04 b1 4b 00 	movl   $0x4bb1,0x4(%esp)
    168f:	00 
    1690:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1697:	e8 bf 29 00 00       	call   405b <printf>
    exit();
    169c:	e8 35 28 00 00       	call   3ed6 <exit>
  }
  close(fd);
    16a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16a4:	89 04 24             	mov    %eax,(%esp)
    16a7:	e8 52 28 00 00       	call   3efe <close>
  unlink("unlinkread");
    16ac:	c7 04 24 22 4b 00 00 	movl   $0x4b22,(%esp)
    16b3:	e8 6e 28 00 00       	call   3f26 <unlink>
  printf(1, "unlinkread ok\n");
    16b8:	c7 44 24 04 ca 4b 00 	movl   $0x4bca,0x4(%esp)
    16bf:	00 
    16c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16c7:	e8 8f 29 00 00       	call   405b <printf>
}
    16cc:	c9                   	leave  
    16cd:	c3                   	ret    

000016ce <linktest>:

void
linktest(void)
{
    16ce:	55                   	push   %ebp
    16cf:	89 e5                	mov    %esp,%ebp
    16d1:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    16d4:	c7 44 24 04 d9 4b 00 	movl   $0x4bd9,0x4(%esp)
    16db:	00 
    16dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16e3:	e8 73 29 00 00       	call   405b <printf>

  unlink("lf1");
    16e8:	c7 04 24 e3 4b 00 00 	movl   $0x4be3,(%esp)
    16ef:	e8 32 28 00 00       	call   3f26 <unlink>
  unlink("lf2");
    16f4:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    16fb:	e8 26 28 00 00       	call   3f26 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1700:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1707:	00 
    1708:	c7 04 24 e3 4b 00 00 	movl   $0x4be3,(%esp)
    170f:	e8 02 28 00 00       	call   3f16 <open>
    1714:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1717:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    171b:	79 19                	jns    1736 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    171d:	c7 44 24 04 eb 4b 00 	movl   $0x4beb,0x4(%esp)
    1724:	00 
    1725:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    172c:	e8 2a 29 00 00       	call   405b <printf>
    exit();
    1731:	e8 a0 27 00 00       	call   3ed6 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1736:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    173d:	00 
    173e:	c7 44 24 04 47 4b 00 	movl   $0x4b47,0x4(%esp)
    1745:	00 
    1746:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1749:	89 04 24             	mov    %eax,(%esp)
    174c:	e8 a5 27 00 00       	call   3ef6 <write>
    1751:	83 f8 05             	cmp    $0x5,%eax
    1754:	74 19                	je     176f <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    1756:	c7 44 24 04 fe 4b 00 	movl   $0x4bfe,0x4(%esp)
    175d:	00 
    175e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1765:	e8 f1 28 00 00       	call   405b <printf>
    exit();
    176a:	e8 67 27 00 00       	call   3ed6 <exit>
  }
  close(fd);
    176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1772:	89 04 24             	mov    %eax,(%esp)
    1775:	e8 84 27 00 00       	call   3efe <close>

  if(link("lf1", "lf2") < 0){
    177a:	c7 44 24 04 e7 4b 00 	movl   $0x4be7,0x4(%esp)
    1781:	00 
    1782:	c7 04 24 e3 4b 00 00 	movl   $0x4be3,(%esp)
    1789:	e8 a8 27 00 00       	call   3f36 <link>
    178e:	85 c0                	test   %eax,%eax
    1790:	79 19                	jns    17ab <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    1792:	c7 44 24 04 10 4c 00 	movl   $0x4c10,0x4(%esp)
    1799:	00 
    179a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17a1:	e8 b5 28 00 00       	call   405b <printf>
    exit();
    17a6:	e8 2b 27 00 00       	call   3ed6 <exit>
  }
  unlink("lf1");
    17ab:	c7 04 24 e3 4b 00 00 	movl   $0x4be3,(%esp)
    17b2:	e8 6f 27 00 00       	call   3f26 <unlink>

  if(open("lf1", 0) >= 0){
    17b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17be:	00 
    17bf:	c7 04 24 e3 4b 00 00 	movl   $0x4be3,(%esp)
    17c6:	e8 4b 27 00 00       	call   3f16 <open>
    17cb:	85 c0                	test   %eax,%eax
    17cd:	78 19                	js     17e8 <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    17cf:	c7 44 24 04 28 4c 00 	movl   $0x4c28,0x4(%esp)
    17d6:	00 
    17d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17de:	e8 78 28 00 00       	call   405b <printf>
    exit();
    17e3:	e8 ee 26 00 00       	call   3ed6 <exit>
  }

  fd = open("lf2", 0);
    17e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17ef:	00 
    17f0:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    17f7:	e8 1a 27 00 00       	call   3f16 <open>
    17fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    17ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1803:	79 19                	jns    181e <linktest+0x150>
    printf(1, "open lf2 failed\n");
    1805:	c7 44 24 04 4d 4c 00 	movl   $0x4c4d,0x4(%esp)
    180c:	00 
    180d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1814:	e8 42 28 00 00       	call   405b <printf>
    exit();
    1819:	e8 b8 26 00 00       	call   3ed6 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    181e:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1825:	00 
    1826:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    182d:	00 
    182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1831:	89 04 24             	mov    %eax,(%esp)
    1834:	e8 b5 26 00 00       	call   3eee <read>
    1839:	83 f8 05             	cmp    $0x5,%eax
    183c:	74 19                	je     1857 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    183e:	c7 44 24 04 5e 4c 00 	movl   $0x4c5e,0x4(%esp)
    1845:	00 
    1846:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    184d:	e8 09 28 00 00       	call   405b <printf>
    exit();
    1852:	e8 7f 26 00 00       	call   3ed6 <exit>
  }
  close(fd);
    1857:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185a:	89 04 24             	mov    %eax,(%esp)
    185d:	e8 9c 26 00 00       	call   3efe <close>

  if(link("lf2", "lf2") >= 0){
    1862:	c7 44 24 04 e7 4b 00 	movl   $0x4be7,0x4(%esp)
    1869:	00 
    186a:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    1871:	e8 c0 26 00 00       	call   3f36 <link>
    1876:	85 c0                	test   %eax,%eax
    1878:	78 19                	js     1893 <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    187a:	c7 44 24 04 6f 4c 00 	movl   $0x4c6f,0x4(%esp)
    1881:	00 
    1882:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1889:	e8 cd 27 00 00       	call   405b <printf>
    exit();
    188e:	e8 43 26 00 00       	call   3ed6 <exit>
  }

  unlink("lf2");
    1893:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    189a:	e8 87 26 00 00       	call   3f26 <unlink>
  if(link("lf2", "lf1") >= 0){
    189f:	c7 44 24 04 e3 4b 00 	movl   $0x4be3,0x4(%esp)
    18a6:	00 
    18a7:	c7 04 24 e7 4b 00 00 	movl   $0x4be7,(%esp)
    18ae:	e8 83 26 00 00       	call   3f36 <link>
    18b3:	85 c0                	test   %eax,%eax
    18b5:	78 19                	js     18d0 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    18b7:	c7 44 24 04 90 4c 00 	movl   $0x4c90,0x4(%esp)
    18be:	00 
    18bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18c6:	e8 90 27 00 00       	call   405b <printf>
    exit();
    18cb:	e8 06 26 00 00       	call   3ed6 <exit>
  }

  if(link(".", "lf1") >= 0){
    18d0:	c7 44 24 04 e3 4b 00 	movl   $0x4be3,0x4(%esp)
    18d7:	00 
    18d8:	c7 04 24 b3 4c 00 00 	movl   $0x4cb3,(%esp)
    18df:	e8 52 26 00 00       	call   3f36 <link>
    18e4:	85 c0                	test   %eax,%eax
    18e6:	78 19                	js     1901 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    18e8:	c7 44 24 04 b5 4c 00 	movl   $0x4cb5,0x4(%esp)
    18ef:	00 
    18f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18f7:	e8 5f 27 00 00       	call   405b <printf>
    exit();
    18fc:	e8 d5 25 00 00       	call   3ed6 <exit>
  }

  printf(1, "linktest ok\n");
    1901:	c7 44 24 04 d1 4c 00 	movl   $0x4cd1,0x4(%esp)
    1908:	00 
    1909:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1910:	e8 46 27 00 00       	call   405b <printf>
}
    1915:	c9                   	leave  
    1916:	c3                   	ret    

00001917 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1917:	55                   	push   %ebp
    1918:	89 e5                	mov    %esp,%ebp
    191a:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    191d:	c7 44 24 04 de 4c 00 	movl   $0x4cde,0x4(%esp)
    1924:	00 
    1925:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    192c:	e8 2a 27 00 00       	call   405b <printf>
  file[0] = 'C';
    1931:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1935:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1939:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1940:	e9 f7 00 00 00       	jmp    1a3c <concreate+0x125>
    file[1] = '0' + i;
    1945:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1948:	83 c0 30             	add    $0x30,%eax
    194b:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    194e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1951:	89 04 24             	mov    %eax,(%esp)
    1954:	e8 cd 25 00 00       	call   3f26 <unlink>
    pid = fork();
    1959:	e8 70 25 00 00       	call   3ece <fork>
    195e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    1961:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1965:	74 3a                	je     19a1 <concreate+0x8a>
    1967:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    196a:	ba 56 55 55 55       	mov    $0x55555556,%edx
    196f:	89 c8                	mov    %ecx,%eax
    1971:	f7 ea                	imul   %edx
    1973:	89 c8                	mov    %ecx,%eax
    1975:	c1 f8 1f             	sar    $0x1f,%eax
    1978:	29 c2                	sub    %eax,%edx
    197a:	89 d0                	mov    %edx,%eax
    197c:	01 c0                	add    %eax,%eax
    197e:	01 d0                	add    %edx,%eax
    1980:	89 ca                	mov    %ecx,%edx
    1982:	29 c2                	sub    %eax,%edx
    1984:	83 fa 01             	cmp    $0x1,%edx
    1987:	75 18                	jne    19a1 <concreate+0x8a>
      link("C0", file);
    1989:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    198c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1990:	c7 04 24 ee 4c 00 00 	movl   $0x4cee,(%esp)
    1997:	e8 9a 25 00 00       	call   3f36 <link>
    199c:	e9 87 00 00 00       	jmp    1a28 <concreate+0x111>
    } else if(pid == 0 && (i % 5) == 1){
    19a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19a5:	75 3a                	jne    19e1 <concreate+0xca>
    19a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19aa:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19af:	89 c8                	mov    %ecx,%eax
    19b1:	f7 ea                	imul   %edx
    19b3:	d1 fa                	sar    %edx
    19b5:	89 c8                	mov    %ecx,%eax
    19b7:	c1 f8 1f             	sar    $0x1f,%eax
    19ba:	29 c2                	sub    %eax,%edx
    19bc:	89 d0                	mov    %edx,%eax
    19be:	c1 e0 02             	shl    $0x2,%eax
    19c1:	01 d0                	add    %edx,%eax
    19c3:	89 ca                	mov    %ecx,%edx
    19c5:	29 c2                	sub    %eax,%edx
    19c7:	83 fa 01             	cmp    $0x1,%edx
    19ca:	75 15                	jne    19e1 <concreate+0xca>
      link("C0", file);
    19cc:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19cf:	89 44 24 04          	mov    %eax,0x4(%esp)
    19d3:	c7 04 24 ee 4c 00 00 	movl   $0x4cee,(%esp)
    19da:	e8 57 25 00 00       	call   3f36 <link>
    19df:	eb 47                	jmp    1a28 <concreate+0x111>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19e1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    19e8:	00 
    19e9:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19ec:	89 04 24             	mov    %eax,(%esp)
    19ef:	e8 22 25 00 00       	call   3f16 <open>
    19f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    19f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19fb:	79 20                	jns    1a1d <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    19fd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a00:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a04:	c7 44 24 04 f1 4c 00 	movl   $0x4cf1,0x4(%esp)
    1a0b:	00 
    1a0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a13:	e8 43 26 00 00       	call   405b <printf>
        exit();
    1a18:	e8 b9 24 00 00       	call   3ed6 <exit>
      }
      close(fd);
    1a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1a20:	89 04 24             	mov    %eax,(%esp)
    1a23:	e8 d6 24 00 00       	call   3efe <close>
    }
    if(pid == 0)
    1a28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a2c:	75 05                	jne    1a33 <concreate+0x11c>
      exit();
    1a2e:	e8 a3 24 00 00       	call   3ed6 <exit>
    else
      wait();
    1a33:	e8 a6 24 00 00       	call   3ede <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1a38:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a3c:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a40:	0f 8e ff fe ff ff    	jle    1945 <concreate+0x2e>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1a46:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    1a4d:	00 
    1a4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a55:	00 
    1a56:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a59:	89 04 24             	mov    %eax,(%esp)
    1a5c:	e8 cf 22 00 00       	call   3d30 <memset>
  fd = open(".", 0);
    1a61:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a68:	00 
    1a69:	c7 04 24 b3 4c 00 00 	movl   $0x4cb3,(%esp)
    1a70:	e8 a1 24 00 00       	call   3f16 <open>
    1a75:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a7f:	e9 a7 00 00 00       	jmp    1b2b <concreate+0x214>
    if(de.inum == 0)
    1a84:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a88:	66 85 c0             	test   %ax,%ax
    1a8b:	0f 84 99 00 00 00    	je     1b2a <concreate+0x213>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a91:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1a95:	3c 43                	cmp    $0x43,%al
    1a97:	0f 85 8e 00 00 00    	jne    1b2b <concreate+0x214>
    1a9d:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1aa1:	84 c0                	test   %al,%al
    1aa3:	0f 85 82 00 00 00    	jne    1b2b <concreate+0x214>
      i = de.name[1] - '0';
    1aa9:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1aad:	0f be c0             	movsbl %al,%eax
    1ab0:	83 e8 30             	sub    $0x30,%eax
    1ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1aba:	78 08                	js     1ac4 <concreate+0x1ad>
    1abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1abf:	83 f8 27             	cmp    $0x27,%eax
    1ac2:	76 23                	jbe    1ae7 <concreate+0x1d0>
        printf(1, "concreate weird file %s\n", de.name);
    1ac4:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ac7:	83 c0 02             	add    $0x2,%eax
    1aca:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ace:	c7 44 24 04 0d 4d 00 	movl   $0x4d0d,0x4(%esp)
    1ad5:	00 
    1ad6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1add:	e8 79 25 00 00       	call   405b <printf>
        exit();
    1ae2:	e8 ef 23 00 00       	call   3ed6 <exit>
      }
      if(fa[i]){
    1ae7:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aed:	01 d0                	add    %edx,%eax
    1aef:	0f b6 00             	movzbl (%eax),%eax
    1af2:	84 c0                	test   %al,%al
    1af4:	74 23                	je     1b19 <concreate+0x202>
        printf(1, "concreate duplicate file %s\n", de.name);
    1af6:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1af9:	83 c0 02             	add    $0x2,%eax
    1afc:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b00:	c7 44 24 04 26 4d 00 	movl   $0x4d26,0x4(%esp)
    1b07:	00 
    1b08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b0f:	e8 47 25 00 00       	call   405b <printf>
        exit();
    1b14:	e8 bd 23 00 00       	call   3ed6 <exit>
      }
      fa[i] = 1;
    1b19:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b1f:	01 d0                	add    %edx,%eax
    1b21:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b24:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1b28:	eb 01                	jmp    1b2b <concreate+0x214>
  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    1b2a:	90                   	nop
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b2b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1b32:	00 
    1b33:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b36:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b3d:	89 04 24             	mov    %eax,(%esp)
    1b40:	e8 a9 23 00 00       	call   3eee <read>
    1b45:	85 c0                	test   %eax,%eax
    1b47:	0f 8f 37 ff ff ff    	jg     1a84 <concreate+0x16d>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b50:	89 04 24             	mov    %eax,(%esp)
    1b53:	e8 a6 23 00 00       	call   3efe <close>

  if(n != 40){
    1b58:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b5c:	74 19                	je     1b77 <concreate+0x260>
    printf(1, "concreate not enough files in directory listing\n");
    1b5e:	c7 44 24 04 44 4d 00 	movl   $0x4d44,0x4(%esp)
    1b65:	00 
    1b66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b6d:	e8 e9 24 00 00       	call   405b <printf>
    exit();
    1b72:	e8 5f 23 00 00       	call   3ed6 <exit>
  }

  for(i = 0; i < 40; i++){
    1b77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b7e:	e9 2d 01 00 00       	jmp    1cb0 <concreate+0x399>
    file[1] = '0' + i;
    1b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b86:	83 c0 30             	add    $0x30,%eax
    1b89:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b8c:	e8 3d 23 00 00       	call   3ece <fork>
    1b91:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b98:	79 19                	jns    1bb3 <concreate+0x29c>
      printf(1, "fork failed\n");
    1b9a:	c7 44 24 04 c9 44 00 	movl   $0x44c9,0x4(%esp)
    1ba1:	00 
    1ba2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ba9:	e8 ad 24 00 00       	call   405b <printf>
      exit();
    1bae:	e8 23 23 00 00       	call   3ed6 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1bb3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bb6:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bbb:	89 c8                	mov    %ecx,%eax
    1bbd:	f7 ea                	imul   %edx
    1bbf:	89 c8                	mov    %ecx,%eax
    1bc1:	c1 f8 1f             	sar    $0x1f,%eax
    1bc4:	29 c2                	sub    %eax,%edx
    1bc6:	89 d0                	mov    %edx,%eax
    1bc8:	01 c0                	add    %eax,%eax
    1bca:	01 d0                	add    %edx,%eax
    1bcc:	89 ca                	mov    %ecx,%edx
    1bce:	29 c2                	sub    %eax,%edx
    1bd0:	85 d2                	test   %edx,%edx
    1bd2:	75 06                	jne    1bda <concreate+0x2c3>
    1bd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bd8:	74 28                	je     1c02 <concreate+0x2eb>
       ((i % 3) == 1 && pid != 0)){
    1bda:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bdd:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1be2:	89 c8                	mov    %ecx,%eax
    1be4:	f7 ea                	imul   %edx
    1be6:	89 c8                	mov    %ecx,%eax
    1be8:	c1 f8 1f             	sar    $0x1f,%eax
    1beb:	29 c2                	sub    %eax,%edx
    1bed:	89 d0                	mov    %edx,%eax
    1bef:	01 c0                	add    %eax,%eax
    1bf1:	01 d0                	add    %edx,%eax
    1bf3:	89 ca                	mov    %ecx,%edx
    1bf5:	29 c2                	sub    %eax,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1bf7:	83 fa 01             	cmp    $0x1,%edx
    1bfa:	75 74                	jne    1c70 <concreate+0x359>
       ((i % 3) == 1 && pid != 0)){
    1bfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c00:	74 6e                	je     1c70 <concreate+0x359>
      close(open(file, 0));
    1c02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c09:	00 
    1c0a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c0d:	89 04 24             	mov    %eax,(%esp)
    1c10:	e8 01 23 00 00       	call   3f16 <open>
    1c15:	89 04 24             	mov    %eax,(%esp)
    1c18:	e8 e1 22 00 00       	call   3efe <close>
      close(open(file, 0));
    1c1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c24:	00 
    1c25:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c28:	89 04 24             	mov    %eax,(%esp)
    1c2b:	e8 e6 22 00 00       	call   3f16 <open>
    1c30:	89 04 24             	mov    %eax,(%esp)
    1c33:	e8 c6 22 00 00       	call   3efe <close>
      close(open(file, 0));
    1c38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c3f:	00 
    1c40:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c43:	89 04 24             	mov    %eax,(%esp)
    1c46:	e8 cb 22 00 00       	call   3f16 <open>
    1c4b:	89 04 24             	mov    %eax,(%esp)
    1c4e:	e8 ab 22 00 00       	call   3efe <close>
      close(open(file, 0));
    1c53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c5a:	00 
    1c5b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c5e:	89 04 24             	mov    %eax,(%esp)
    1c61:	e8 b0 22 00 00       	call   3f16 <open>
    1c66:	89 04 24             	mov    %eax,(%esp)
    1c69:	e8 90 22 00 00       	call   3efe <close>
    1c6e:	eb 2c                	jmp    1c9c <concreate+0x385>
    } else {
      unlink(file);
    1c70:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c73:	89 04 24             	mov    %eax,(%esp)
    1c76:	e8 ab 22 00 00       	call   3f26 <unlink>
      unlink(file);
    1c7b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c7e:	89 04 24             	mov    %eax,(%esp)
    1c81:	e8 a0 22 00 00       	call   3f26 <unlink>
      unlink(file);
    1c86:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c89:	89 04 24             	mov    %eax,(%esp)
    1c8c:	e8 95 22 00 00       	call   3f26 <unlink>
      unlink(file);
    1c91:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c94:	89 04 24             	mov    %eax,(%esp)
    1c97:	e8 8a 22 00 00       	call   3f26 <unlink>
    }
    if(pid == 0)
    1c9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ca0:	75 05                	jne    1ca7 <concreate+0x390>
      exit();
    1ca2:	e8 2f 22 00 00       	call   3ed6 <exit>
    else
      wait();
    1ca7:	e8 32 22 00 00       	call   3ede <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1cac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cb0:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1cb4:	0f 8e c9 fe ff ff    	jle    1b83 <concreate+0x26c>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1cba:	c7 44 24 04 75 4d 00 	movl   $0x4d75,0x4(%esp)
    1cc1:	00 
    1cc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cc9:	e8 8d 23 00 00       	call   405b <printf>
}
    1cce:	c9                   	leave  
    1ccf:	c3                   	ret    

00001cd0 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cd0:	55                   	push   %ebp
    1cd1:	89 e5                	mov    %esp,%ebp
    1cd3:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cd6:	c7 44 24 04 83 4d 00 	movl   $0x4d83,0x4(%esp)
    1cdd:	00 
    1cde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ce5:	e8 71 23 00 00       	call   405b <printf>

  unlink("x");
    1cea:	c7 04 24 ff 48 00 00 	movl   $0x48ff,(%esp)
    1cf1:	e8 30 22 00 00       	call   3f26 <unlink>
  pid = fork();
    1cf6:	e8 d3 21 00 00       	call   3ece <fork>
    1cfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1cfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d02:	79 19                	jns    1d1d <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1d04:	c7 44 24 04 c9 44 00 	movl   $0x44c9,0x4(%esp)
    1d0b:	00 
    1d0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d13:	e8 43 23 00 00       	call   405b <printf>
    exit();
    1d18:	e8 b9 21 00 00       	call   3ed6 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d21:	74 07                	je     1d2a <linkunlink+0x5a>
    1d23:	b8 01 00 00 00       	mov    $0x1,%eax
    1d28:	eb 05                	jmp    1d2f <linkunlink+0x5f>
    1d2a:	b8 61 00 00 00       	mov    $0x61,%eax
    1d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d39:	e9 8e 00 00 00       	jmp    1dcc <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    1d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d41:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d47:	05 39 30 00 00       	add    $0x3039,%eax
    1d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d4f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d52:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d57:	89 c8                	mov    %ecx,%eax
    1d59:	f7 e2                	mul    %edx
    1d5b:	d1 ea                	shr    %edx
    1d5d:	89 d0                	mov    %edx,%eax
    1d5f:	01 c0                	add    %eax,%eax
    1d61:	01 d0                	add    %edx,%eax
    1d63:	89 ca                	mov    %ecx,%edx
    1d65:	29 c2                	sub    %eax,%edx
    1d67:	85 d2                	test   %edx,%edx
    1d69:	75 1e                	jne    1d89 <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    1d6b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d72:	00 
    1d73:	c7 04 24 ff 48 00 00 	movl   $0x48ff,(%esp)
    1d7a:	e8 97 21 00 00       	call   3f16 <open>
    1d7f:	89 04 24             	mov    %eax,(%esp)
    1d82:	e8 77 21 00 00       	call   3efe <close>
    1d87:	eb 3f                	jmp    1dc8 <linkunlink+0xf8>
    } else if((x % 3) == 1){
    1d89:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d8c:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d91:	89 c8                	mov    %ecx,%eax
    1d93:	f7 e2                	mul    %edx
    1d95:	d1 ea                	shr    %edx
    1d97:	89 d0                	mov    %edx,%eax
    1d99:	01 c0                	add    %eax,%eax
    1d9b:	01 d0                	add    %edx,%eax
    1d9d:	89 ca                	mov    %ecx,%edx
    1d9f:	29 c2                	sub    %eax,%edx
    1da1:	83 fa 01             	cmp    $0x1,%edx
    1da4:	75 16                	jne    1dbc <linkunlink+0xec>
      link("cat", "x");
    1da6:	c7 44 24 04 ff 48 00 	movl   $0x48ff,0x4(%esp)
    1dad:	00 
    1dae:	c7 04 24 94 4d 00 00 	movl   $0x4d94,(%esp)
    1db5:	e8 7c 21 00 00       	call   3f36 <link>
    1dba:	eb 0c                	jmp    1dc8 <linkunlink+0xf8>
    } else {
      unlink("x");
    1dbc:	c7 04 24 ff 48 00 00 	movl   $0x48ff,(%esp)
    1dc3:	e8 5e 21 00 00       	call   3f26 <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1dc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1dcc:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1dd0:	0f 8e 68 ff ff ff    	jle    1d3e <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1dd6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1dda:	74 1b                	je     1df7 <linkunlink+0x127>
    wait();
    1ddc:	e8 fd 20 00 00       	call   3ede <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
    1de1:	c7 44 24 04 98 4d 00 	movl   $0x4d98,0x4(%esp)
    1de8:	00 
    1de9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1df0:	e8 66 22 00 00       	call   405b <printf>
    1df5:	eb 05                	jmp    1dfc <linkunlink+0x12c>
  }

  if(pid)
    wait();
  else 
    exit();
    1df7:	e8 da 20 00 00       	call   3ed6 <exit>

  printf(1, "linkunlink ok\n");
}
    1dfc:	c9                   	leave  
    1dfd:	c3                   	ret    

00001dfe <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1dfe:	55                   	push   %ebp
    1dff:	89 e5                	mov    %esp,%ebp
    1e01:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e04:	c7 44 24 04 a7 4d 00 	movl   $0x4da7,0x4(%esp)
    1e0b:	00 
    1e0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e13:	e8 43 22 00 00       	call   405b <printf>
  unlink("bd");
    1e18:	c7 04 24 b4 4d 00 00 	movl   $0x4db4,(%esp)
    1e1f:	e8 02 21 00 00       	call   3f26 <unlink>

  fd = open("bd", O_CREATE);
    1e24:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1e2b:	00 
    1e2c:	c7 04 24 b4 4d 00 00 	movl   $0x4db4,(%esp)
    1e33:	e8 de 20 00 00       	call   3f16 <open>
    1e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e3f:	79 19                	jns    1e5a <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1e41:	c7 44 24 04 b7 4d 00 	movl   $0x4db7,0x4(%esp)
    1e48:	00 
    1e49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e50:	e8 06 22 00 00       	call   405b <printf>
    exit();
    1e55:	e8 7c 20 00 00       	call   3ed6 <exit>
  }
  close(fd);
    1e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e5d:	89 04 24             	mov    %eax,(%esp)
    1e60:	e8 99 20 00 00       	call   3efe <close>

  for(i = 0; i < 500; i++){
    1e65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e6c:	eb 68                	jmp    1ed6 <bigdir+0xd8>
    name[0] = 'x';
    1e6e:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e75:	8d 50 3f             	lea    0x3f(%eax),%edx
    1e78:	85 c0                	test   %eax,%eax
    1e7a:	0f 48 c2             	cmovs  %edx,%eax
    1e7d:	c1 f8 06             	sar    $0x6,%eax
    1e80:	83 c0 30             	add    $0x30,%eax
    1e83:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e89:	89 c2                	mov    %eax,%edx
    1e8b:	c1 fa 1f             	sar    $0x1f,%edx
    1e8e:	c1 ea 1a             	shr    $0x1a,%edx
    1e91:	01 d0                	add    %edx,%eax
    1e93:	83 e0 3f             	and    $0x3f,%eax
    1e96:	29 d0                	sub    %edx,%eax
    1e98:	83 c0 30             	add    $0x30,%eax
    1e9b:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1e9e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1ea2:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ea9:	c7 04 24 b4 4d 00 00 	movl   $0x4db4,(%esp)
    1eb0:	e8 81 20 00 00       	call   3f36 <link>
    1eb5:	85 c0                	test   %eax,%eax
    1eb7:	74 19                	je     1ed2 <bigdir+0xd4>
      printf(1, "bigdir link failed\n");
    1eb9:	c7 44 24 04 cd 4d 00 	movl   $0x4dcd,0x4(%esp)
    1ec0:	00 
    1ec1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ec8:	e8 8e 21 00 00       	call   405b <printf>
      exit();
    1ecd:	e8 04 20 00 00       	call   3ed6 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1ed2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ed6:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1edd:	7e 8f                	jle    1e6e <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1edf:	c7 04 24 b4 4d 00 00 	movl   $0x4db4,(%esp)
    1ee6:	e8 3b 20 00 00       	call   3f26 <unlink>
  for(i = 0; i < 500; i++){
    1eeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1ef2:	eb 60                	jmp    1f54 <bigdir+0x156>
    name[0] = 'x';
    1ef4:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1efb:	8d 50 3f             	lea    0x3f(%eax),%edx
    1efe:	85 c0                	test   %eax,%eax
    1f00:	0f 48 c2             	cmovs  %edx,%eax
    1f03:	c1 f8 06             	sar    $0x6,%eax
    1f06:	83 c0 30             	add    $0x30,%eax
    1f09:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f0f:	89 c2                	mov    %eax,%edx
    1f11:	c1 fa 1f             	sar    $0x1f,%edx
    1f14:	c1 ea 1a             	shr    $0x1a,%edx
    1f17:	01 d0                	add    %edx,%eax
    1f19:	83 e0 3f             	and    $0x3f,%eax
    1f1c:	29 d0                	sub    %edx,%eax
    1f1e:	83 c0 30             	add    $0x30,%eax
    1f21:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f24:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f28:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f2b:	89 04 24             	mov    %eax,(%esp)
    1f2e:	e8 f3 1f 00 00       	call   3f26 <unlink>
    1f33:	85 c0                	test   %eax,%eax
    1f35:	74 19                	je     1f50 <bigdir+0x152>
      printf(1, "bigdir unlink failed");
    1f37:	c7 44 24 04 e1 4d 00 	movl   $0x4de1,0x4(%esp)
    1f3e:	00 
    1f3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f46:	e8 10 21 00 00       	call   405b <printf>
      exit();
    1f4b:	e8 86 1f 00 00       	call   3ed6 <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1f50:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f54:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f5b:	7e 97                	jle    1ef4 <bigdir+0xf6>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1f5d:	c7 44 24 04 f6 4d 00 	movl   $0x4df6,0x4(%esp)
    1f64:	00 
    1f65:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f6c:	e8 ea 20 00 00       	call   405b <printf>
}
    1f71:	c9                   	leave  
    1f72:	c3                   	ret    

00001f73 <subdir>:

void
subdir(void)
{
    1f73:	55                   	push   %ebp
    1f74:	89 e5                	mov    %esp,%ebp
    1f76:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f79:	c7 44 24 04 01 4e 00 	movl   $0x4e01,0x4(%esp)
    1f80:	00 
    1f81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f88:	e8 ce 20 00 00       	call   405b <printf>

  unlink("ff");
    1f8d:	c7 04 24 0e 4e 00 00 	movl   $0x4e0e,(%esp)
    1f94:	e8 8d 1f 00 00       	call   3f26 <unlink>
  if(mkdir("dd") != 0){
    1f99:	c7 04 24 11 4e 00 00 	movl   $0x4e11,(%esp)
    1fa0:	e8 99 1f 00 00       	call   3f3e <mkdir>
    1fa5:	85 c0                	test   %eax,%eax
    1fa7:	74 19                	je     1fc2 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1fa9:	c7 44 24 04 14 4e 00 	movl   $0x4e14,0x4(%esp)
    1fb0:	00 
    1fb1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fb8:	e8 9e 20 00 00       	call   405b <printf>
    exit();
    1fbd:	e8 14 1f 00 00       	call   3ed6 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fc2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1fc9:	00 
    1fca:	c7 04 24 2c 4e 00 00 	movl   $0x4e2c,(%esp)
    1fd1:	e8 40 1f 00 00       	call   3f16 <open>
    1fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1fdd:	79 19                	jns    1ff8 <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    1fdf:	c7 44 24 04 32 4e 00 	movl   $0x4e32,0x4(%esp)
    1fe6:	00 
    1fe7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fee:	e8 68 20 00 00       	call   405b <printf>
    exit();
    1ff3:	e8 de 1e 00 00       	call   3ed6 <exit>
  }
  write(fd, "ff", 2);
    1ff8:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1fff:	00 
    2000:	c7 44 24 04 0e 4e 00 	movl   $0x4e0e,0x4(%esp)
    2007:	00 
    2008:	8b 45 f4             	mov    -0xc(%ebp),%eax
    200b:	89 04 24             	mov    %eax,(%esp)
    200e:	e8 e3 1e 00 00       	call   3ef6 <write>
  close(fd);
    2013:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2016:	89 04 24             	mov    %eax,(%esp)
    2019:	e8 e0 1e 00 00       	call   3efe <close>
  
  if(unlink("dd") >= 0){
    201e:	c7 04 24 11 4e 00 00 	movl   $0x4e11,(%esp)
    2025:	e8 fc 1e 00 00       	call   3f26 <unlink>
    202a:	85 c0                	test   %eax,%eax
    202c:	78 19                	js     2047 <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    202e:	c7 44 24 04 48 4e 00 	movl   $0x4e48,0x4(%esp)
    2035:	00 
    2036:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    203d:	e8 19 20 00 00       	call   405b <printf>
    exit();
    2042:	e8 8f 1e 00 00       	call   3ed6 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2047:	c7 04 24 6e 4e 00 00 	movl   $0x4e6e,(%esp)
    204e:	e8 eb 1e 00 00       	call   3f3e <mkdir>
    2053:	85 c0                	test   %eax,%eax
    2055:	74 19                	je     2070 <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    2057:	c7 44 24 04 75 4e 00 	movl   $0x4e75,0x4(%esp)
    205e:	00 
    205f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2066:	e8 f0 1f 00 00       	call   405b <printf>
    exit();
    206b:	e8 66 1e 00 00       	call   3ed6 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2070:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2077:	00 
    2078:	c7 04 24 90 4e 00 00 	movl   $0x4e90,(%esp)
    207f:	e8 92 1e 00 00       	call   3f16 <open>
    2084:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2087:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    208b:	79 19                	jns    20a6 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    208d:	c7 44 24 04 99 4e 00 	movl   $0x4e99,0x4(%esp)
    2094:	00 
    2095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    209c:	e8 ba 1f 00 00       	call   405b <printf>
    exit();
    20a1:	e8 30 1e 00 00       	call   3ed6 <exit>
  }
  write(fd, "FF", 2);
    20a6:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    20ad:	00 
    20ae:	c7 44 24 04 b1 4e 00 	movl   $0x4eb1,0x4(%esp)
    20b5:	00 
    20b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20b9:	89 04 24             	mov    %eax,(%esp)
    20bc:	e8 35 1e 00 00       	call   3ef6 <write>
  close(fd);
    20c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20c4:	89 04 24             	mov    %eax,(%esp)
    20c7:	e8 32 1e 00 00       	call   3efe <close>

  fd = open("dd/dd/../ff", 0);
    20cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    20d3:	00 
    20d4:	c7 04 24 b4 4e 00 00 	movl   $0x4eb4,(%esp)
    20db:	e8 36 1e 00 00       	call   3f16 <open>
    20e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20e7:	79 19                	jns    2102 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    20e9:	c7 44 24 04 c0 4e 00 	movl   $0x4ec0,0x4(%esp)
    20f0:	00 
    20f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20f8:	e8 5e 1f 00 00       	call   405b <printf>
    exit();
    20fd:	e8 d4 1d 00 00       	call   3ed6 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    2102:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2109:	00 
    210a:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    2111:	00 
    2112:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2115:	89 04 24             	mov    %eax,(%esp)
    2118:	e8 d1 1d 00 00       	call   3eee <read>
    211d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    2120:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2124:	75 0b                	jne    2131 <subdir+0x1be>
    2126:	0f b6 05 c0 8a 00 00 	movzbl 0x8ac0,%eax
    212d:	3c 66                	cmp    $0x66,%al
    212f:	74 19                	je     214a <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    2131:	c7 44 24 04 d9 4e 00 	movl   $0x4ed9,0x4(%esp)
    2138:	00 
    2139:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2140:	e8 16 1f 00 00       	call   405b <printf>
    exit();
    2145:	e8 8c 1d 00 00       	call   3ed6 <exit>
  }
  close(fd);
    214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    214d:	89 04 24             	mov    %eax,(%esp)
    2150:	e8 a9 1d 00 00       	call   3efe <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2155:	c7 44 24 04 f4 4e 00 	movl   $0x4ef4,0x4(%esp)
    215c:	00 
    215d:	c7 04 24 90 4e 00 00 	movl   $0x4e90,(%esp)
    2164:	e8 cd 1d 00 00       	call   3f36 <link>
    2169:	85 c0                	test   %eax,%eax
    216b:	74 19                	je     2186 <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    216d:	c7 44 24 04 00 4f 00 	movl   $0x4f00,0x4(%esp)
    2174:	00 
    2175:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    217c:	e8 da 1e 00 00       	call   405b <printf>
    exit();
    2181:	e8 50 1d 00 00       	call   3ed6 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2186:	c7 04 24 90 4e 00 00 	movl   $0x4e90,(%esp)
    218d:	e8 94 1d 00 00       	call   3f26 <unlink>
    2192:	85 c0                	test   %eax,%eax
    2194:	74 19                	je     21af <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    2196:	c7 44 24 04 21 4f 00 	movl   $0x4f21,0x4(%esp)
    219d:	00 
    219e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21a5:	e8 b1 1e 00 00       	call   405b <printf>
    exit();
    21aa:	e8 27 1d 00 00       	call   3ed6 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    21b6:	00 
    21b7:	c7 04 24 90 4e 00 00 	movl   $0x4e90,(%esp)
    21be:	e8 53 1d 00 00       	call   3f16 <open>
    21c3:	85 c0                	test   %eax,%eax
    21c5:	78 19                	js     21e0 <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21c7:	c7 44 24 04 3c 4f 00 	movl   $0x4f3c,0x4(%esp)
    21ce:	00 
    21cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21d6:	e8 80 1e 00 00       	call   405b <printf>
    exit();
    21db:	e8 f6 1c 00 00       	call   3ed6 <exit>
  }

  if(chdir("dd") != 0){
    21e0:	c7 04 24 11 4e 00 00 	movl   $0x4e11,(%esp)
    21e7:	e8 5a 1d 00 00       	call   3f46 <chdir>
    21ec:	85 c0                	test   %eax,%eax
    21ee:	74 19                	je     2209 <subdir+0x296>
    printf(1, "chdir dd failed\n");
    21f0:	c7 44 24 04 60 4f 00 	movl   $0x4f60,0x4(%esp)
    21f7:	00 
    21f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21ff:	e8 57 1e 00 00       	call   405b <printf>
    exit();
    2204:	e8 cd 1c 00 00       	call   3ed6 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    2209:	c7 04 24 71 4f 00 00 	movl   $0x4f71,(%esp)
    2210:	e8 31 1d 00 00       	call   3f46 <chdir>
    2215:	85 c0                	test   %eax,%eax
    2217:	74 19                	je     2232 <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    2219:	c7 44 24 04 7d 4f 00 	movl   $0x4f7d,0x4(%esp)
    2220:	00 
    2221:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2228:	e8 2e 1e 00 00       	call   405b <printf>
    exit();
    222d:	e8 a4 1c 00 00       	call   3ed6 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2232:	c7 04 24 97 4f 00 00 	movl   $0x4f97,(%esp)
    2239:	e8 08 1d 00 00       	call   3f46 <chdir>
    223e:	85 c0                	test   %eax,%eax
    2240:	74 19                	je     225b <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    2242:	c7 44 24 04 7d 4f 00 	movl   $0x4f7d,0x4(%esp)
    2249:	00 
    224a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2251:	e8 05 1e 00 00       	call   405b <printf>
    exit();
    2256:	e8 7b 1c 00 00       	call   3ed6 <exit>
  }
  if(chdir("./..") != 0){
    225b:	c7 04 24 a6 4f 00 00 	movl   $0x4fa6,(%esp)
    2262:	e8 df 1c 00 00       	call   3f46 <chdir>
    2267:	85 c0                	test   %eax,%eax
    2269:	74 19                	je     2284 <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    226b:	c7 44 24 04 ab 4f 00 	movl   $0x4fab,0x4(%esp)
    2272:	00 
    2273:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    227a:	e8 dc 1d 00 00       	call   405b <printf>
    exit();
    227f:	e8 52 1c 00 00       	call   3ed6 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    2284:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    228b:	00 
    228c:	c7 04 24 f4 4e 00 00 	movl   $0x4ef4,(%esp)
    2293:	e8 7e 1c 00 00       	call   3f16 <open>
    2298:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    229b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    229f:	79 19                	jns    22ba <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    22a1:	c7 44 24 04 be 4f 00 	movl   $0x4fbe,0x4(%esp)
    22a8:	00 
    22a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22b0:	e8 a6 1d 00 00       	call   405b <printf>
    exit();
    22b5:	e8 1c 1c 00 00       	call   3ed6 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22ba:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    22c1:	00 
    22c2:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    22c9:	00 
    22ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22cd:	89 04 24             	mov    %eax,(%esp)
    22d0:	e8 19 1c 00 00       	call   3eee <read>
    22d5:	83 f8 02             	cmp    $0x2,%eax
    22d8:	74 19                	je     22f3 <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    22da:	c7 44 24 04 d6 4f 00 	movl   $0x4fd6,0x4(%esp)
    22e1:	00 
    22e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22e9:	e8 6d 1d 00 00       	call   405b <printf>
    exit();
    22ee:	e8 e3 1b 00 00       	call   3ed6 <exit>
  }
  close(fd);
    22f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22f6:	89 04 24             	mov    %eax,(%esp)
    22f9:	e8 00 1c 00 00       	call   3efe <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    22fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2305:	00 
    2306:	c7 04 24 90 4e 00 00 	movl   $0x4e90,(%esp)
    230d:	e8 04 1c 00 00       	call   3f16 <open>
    2312:	85 c0                	test   %eax,%eax
    2314:	78 19                	js     232f <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2316:	c7 44 24 04 f4 4f 00 	movl   $0x4ff4,0x4(%esp)
    231d:	00 
    231e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2325:	e8 31 1d 00 00       	call   405b <printf>
    exit();
    232a:	e8 a7 1b 00 00       	call   3ed6 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    232f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2336:	00 
    2337:	c7 04 24 19 50 00 00 	movl   $0x5019,(%esp)
    233e:	e8 d3 1b 00 00       	call   3f16 <open>
    2343:	85 c0                	test   %eax,%eax
    2345:	78 19                	js     2360 <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    2347:	c7 44 24 04 22 50 00 	movl   $0x5022,0x4(%esp)
    234e:	00 
    234f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2356:	e8 00 1d 00 00       	call   405b <printf>
    exit();
    235b:	e8 76 1b 00 00       	call   3ed6 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2360:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2367:	00 
    2368:	c7 04 24 3e 50 00 00 	movl   $0x503e,(%esp)
    236f:	e8 a2 1b 00 00       	call   3f16 <open>
    2374:	85 c0                	test   %eax,%eax
    2376:	78 19                	js     2391 <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    2378:	c7 44 24 04 47 50 00 	movl   $0x5047,0x4(%esp)
    237f:	00 
    2380:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2387:	e8 cf 1c 00 00       	call   405b <printf>
    exit();
    238c:	e8 45 1b 00 00       	call   3ed6 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    2391:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2398:	00 
    2399:	c7 04 24 11 4e 00 00 	movl   $0x4e11,(%esp)
    23a0:	e8 71 1b 00 00       	call   3f16 <open>
    23a5:	85 c0                	test   %eax,%eax
    23a7:	78 19                	js     23c2 <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    23a9:	c7 44 24 04 63 50 00 	movl   $0x5063,0x4(%esp)
    23b0:	00 
    23b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23b8:	e8 9e 1c 00 00       	call   405b <printf>
    exit();
    23bd:	e8 14 1b 00 00       	call   3ed6 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23c2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    23c9:	00 
    23ca:	c7 04 24 11 4e 00 00 	movl   $0x4e11,(%esp)
    23d1:	e8 40 1b 00 00       	call   3f16 <open>
    23d6:	85 c0                	test   %eax,%eax
    23d8:	78 19                	js     23f3 <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    23da:	c7 44 24 04 79 50 00 	movl   $0x5079,0x4(%esp)
    23e1:	00 
    23e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23e9:	e8 6d 1c 00 00       	call   405b <printf>
    exit();
    23ee:	e8 e3 1a 00 00       	call   3ed6 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    23fa:	00 
    23fb:	c7 04 24 11 4e 00 00 	movl   $0x4e11,(%esp)
    2402:	e8 0f 1b 00 00       	call   3f16 <open>
    2407:	85 c0                	test   %eax,%eax
    2409:	78 19                	js     2424 <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    240b:	c7 44 24 04 92 50 00 	movl   $0x5092,0x4(%esp)
    2412:	00 
    2413:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    241a:	e8 3c 1c 00 00       	call   405b <printf>
    exit();
    241f:	e8 b2 1a 00 00       	call   3ed6 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2424:	c7 44 24 04 ad 50 00 	movl   $0x50ad,0x4(%esp)
    242b:	00 
    242c:	c7 04 24 19 50 00 00 	movl   $0x5019,(%esp)
    2433:	e8 fe 1a 00 00       	call   3f36 <link>
    2438:	85 c0                	test   %eax,%eax
    243a:	75 19                	jne    2455 <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    243c:	c7 44 24 04 b8 50 00 	movl   $0x50b8,0x4(%esp)
    2443:	00 
    2444:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    244b:	e8 0b 1c 00 00       	call   405b <printf>
    exit();
    2450:	e8 81 1a 00 00       	call   3ed6 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2455:	c7 44 24 04 ad 50 00 	movl   $0x50ad,0x4(%esp)
    245c:	00 
    245d:	c7 04 24 3e 50 00 00 	movl   $0x503e,(%esp)
    2464:	e8 cd 1a 00 00       	call   3f36 <link>
    2469:	85 c0                	test   %eax,%eax
    246b:	75 19                	jne    2486 <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    246d:	c7 44 24 04 dc 50 00 	movl   $0x50dc,0x4(%esp)
    2474:	00 
    2475:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    247c:	e8 da 1b 00 00       	call   405b <printf>
    exit();
    2481:	e8 50 1a 00 00       	call   3ed6 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2486:	c7 44 24 04 f4 4e 00 	movl   $0x4ef4,0x4(%esp)
    248d:	00 
    248e:	c7 04 24 2c 4e 00 00 	movl   $0x4e2c,(%esp)
    2495:	e8 9c 1a 00 00       	call   3f36 <link>
    249a:	85 c0                	test   %eax,%eax
    249c:	75 19                	jne    24b7 <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    249e:	c7 44 24 04 00 51 00 	movl   $0x5100,0x4(%esp)
    24a5:	00 
    24a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24ad:	e8 a9 1b 00 00       	call   405b <printf>
    exit();
    24b2:	e8 1f 1a 00 00       	call   3ed6 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24b7:	c7 04 24 19 50 00 00 	movl   $0x5019,(%esp)
    24be:	e8 7b 1a 00 00       	call   3f3e <mkdir>
    24c3:	85 c0                	test   %eax,%eax
    24c5:	75 19                	jne    24e0 <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24c7:	c7 44 24 04 22 51 00 	movl   $0x5122,0x4(%esp)
    24ce:	00 
    24cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24d6:	e8 80 1b 00 00       	call   405b <printf>
    exit();
    24db:	e8 f6 19 00 00       	call   3ed6 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24e0:	c7 04 24 3e 50 00 00 	movl   $0x503e,(%esp)
    24e7:	e8 52 1a 00 00       	call   3f3e <mkdir>
    24ec:	85 c0                	test   %eax,%eax
    24ee:	75 19                	jne    2509 <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24f0:	c7 44 24 04 3d 51 00 	movl   $0x513d,0x4(%esp)
    24f7:	00 
    24f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24ff:	e8 57 1b 00 00       	call   405b <printf>
    exit();
    2504:	e8 cd 19 00 00       	call   3ed6 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    2509:	c7 04 24 f4 4e 00 00 	movl   $0x4ef4,(%esp)
    2510:	e8 29 1a 00 00       	call   3f3e <mkdir>
    2515:	85 c0                	test   %eax,%eax
    2517:	75 19                	jne    2532 <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2519:	c7 44 24 04 58 51 00 	movl   $0x5158,0x4(%esp)
    2520:	00 
    2521:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2528:	e8 2e 1b 00 00       	call   405b <printf>
    exit();
    252d:	e8 a4 19 00 00       	call   3ed6 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    2532:	c7 04 24 3e 50 00 00 	movl   $0x503e,(%esp)
    2539:	e8 e8 19 00 00       	call   3f26 <unlink>
    253e:	85 c0                	test   %eax,%eax
    2540:	75 19                	jne    255b <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2542:	c7 44 24 04 75 51 00 	movl   $0x5175,0x4(%esp)
    2549:	00 
    254a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2551:	e8 05 1b 00 00       	call   405b <printf>
    exit();
    2556:	e8 7b 19 00 00       	call   3ed6 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    255b:	c7 04 24 19 50 00 00 	movl   $0x5019,(%esp)
    2562:	e8 bf 19 00 00       	call   3f26 <unlink>
    2567:	85 c0                	test   %eax,%eax
    2569:	75 19                	jne    2584 <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    256b:	c7 44 24 04 91 51 00 	movl   $0x5191,0x4(%esp)
    2572:	00 
    2573:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    257a:	e8 dc 1a 00 00       	call   405b <printf>
    exit();
    257f:	e8 52 19 00 00       	call   3ed6 <exit>
  }
  if(chdir("dd/ff") == 0){
    2584:	c7 04 24 2c 4e 00 00 	movl   $0x4e2c,(%esp)
    258b:	e8 b6 19 00 00       	call   3f46 <chdir>
    2590:	85 c0                	test   %eax,%eax
    2592:	75 19                	jne    25ad <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    2594:	c7 44 24 04 ad 51 00 	movl   $0x51ad,0x4(%esp)
    259b:	00 
    259c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25a3:	e8 b3 1a 00 00       	call   405b <printf>
    exit();
    25a8:	e8 29 19 00 00       	call   3ed6 <exit>
  }
  if(chdir("dd/xx") == 0){
    25ad:	c7 04 24 c5 51 00 00 	movl   $0x51c5,(%esp)
    25b4:	e8 8d 19 00 00       	call   3f46 <chdir>
    25b9:	85 c0                	test   %eax,%eax
    25bb:	75 19                	jne    25d6 <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    25bd:	c7 44 24 04 cb 51 00 	movl   $0x51cb,0x4(%esp)
    25c4:	00 
    25c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25cc:	e8 8a 1a 00 00       	call   405b <printf>
    exit();
    25d1:	e8 00 19 00 00       	call   3ed6 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25d6:	c7 04 24 f4 4e 00 00 	movl   $0x4ef4,(%esp)
    25dd:	e8 44 19 00 00       	call   3f26 <unlink>
    25e2:	85 c0                	test   %eax,%eax
    25e4:	74 19                	je     25ff <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    25e6:	c7 44 24 04 21 4f 00 	movl   $0x4f21,0x4(%esp)
    25ed:	00 
    25ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25f5:	e8 61 1a 00 00       	call   405b <printf>
    exit();
    25fa:	e8 d7 18 00 00       	call   3ed6 <exit>
  }
  if(unlink("dd/ff") != 0){
    25ff:	c7 04 24 2c 4e 00 00 	movl   $0x4e2c,(%esp)
    2606:	e8 1b 19 00 00       	call   3f26 <unlink>
    260b:	85 c0                	test   %eax,%eax
    260d:	74 19                	je     2628 <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    260f:	c7 44 24 04 e3 51 00 	movl   $0x51e3,0x4(%esp)
    2616:	00 
    2617:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    261e:	e8 38 1a 00 00       	call   405b <printf>
    exit();
    2623:	e8 ae 18 00 00       	call   3ed6 <exit>
  }
  if(unlink("dd") == 0){
    2628:	c7 04 24 11 4e 00 00 	movl   $0x4e11,(%esp)
    262f:	e8 f2 18 00 00       	call   3f26 <unlink>
    2634:	85 c0                	test   %eax,%eax
    2636:	75 19                	jne    2651 <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    2638:	c7 44 24 04 f8 51 00 	movl   $0x51f8,0x4(%esp)
    263f:	00 
    2640:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2647:	e8 0f 1a 00 00       	call   405b <printf>
    exit();
    264c:	e8 85 18 00 00       	call   3ed6 <exit>
  }
  if(unlink("dd/dd") < 0){
    2651:	c7 04 24 18 52 00 00 	movl   $0x5218,(%esp)
    2658:	e8 c9 18 00 00       	call   3f26 <unlink>
    265d:	85 c0                	test   %eax,%eax
    265f:	79 19                	jns    267a <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    2661:	c7 44 24 04 1e 52 00 	movl   $0x521e,0x4(%esp)
    2668:	00 
    2669:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2670:	e8 e6 19 00 00       	call   405b <printf>
    exit();
    2675:	e8 5c 18 00 00       	call   3ed6 <exit>
  }
  if(unlink("dd") < 0){
    267a:	c7 04 24 11 4e 00 00 	movl   $0x4e11,(%esp)
    2681:	e8 a0 18 00 00       	call   3f26 <unlink>
    2686:	85 c0                	test   %eax,%eax
    2688:	79 19                	jns    26a3 <subdir+0x730>
    printf(1, "unlink dd failed\n");
    268a:	c7 44 24 04 33 52 00 	movl   $0x5233,0x4(%esp)
    2691:	00 
    2692:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2699:	e8 bd 19 00 00       	call   405b <printf>
    exit();
    269e:	e8 33 18 00 00       	call   3ed6 <exit>
  }

  printf(1, "subdir ok\n");
    26a3:	c7 44 24 04 45 52 00 	movl   $0x5245,0x4(%esp)
    26aa:	00 
    26ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26b2:	e8 a4 19 00 00       	call   405b <printf>
}
    26b7:	c9                   	leave  
    26b8:	c3                   	ret    

000026b9 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26b9:	55                   	push   %ebp
    26ba:	89 e5                	mov    %esp,%ebp
    26bc:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26bf:	c7 44 24 04 50 52 00 	movl   $0x5250,0x4(%esp)
    26c6:	00 
    26c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26ce:	e8 88 19 00 00       	call   405b <printf>

  unlink("bigwrite");
    26d3:	c7 04 24 5f 52 00 00 	movl   $0x525f,(%esp)
    26da:	e8 47 18 00 00       	call   3f26 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    26df:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    26e6:	e9 b3 00 00 00       	jmp    279e <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    26eb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    26f2:	00 
    26f3:	c7 04 24 5f 52 00 00 	movl   $0x525f,(%esp)
    26fa:	e8 17 18 00 00       	call   3f16 <open>
    26ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    2702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2706:	79 19                	jns    2721 <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    2708:	c7 44 24 04 68 52 00 	movl   $0x5268,0x4(%esp)
    270f:	00 
    2710:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2717:	e8 3f 19 00 00       	call   405b <printf>
      exit();
    271c:	e8 b5 17 00 00       	call   3ed6 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    2721:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2728:	eb 50                	jmp    277a <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    272d:	89 44 24 08          	mov    %eax,0x8(%esp)
    2731:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    2738:	00 
    2739:	8b 45 ec             	mov    -0x14(%ebp),%eax
    273c:	89 04 24             	mov    %eax,(%esp)
    273f:	e8 b2 17 00 00       	call   3ef6 <write>
    2744:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    2747:	8b 45 e8             	mov    -0x18(%ebp),%eax
    274a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    274d:	74 27                	je     2776 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    274f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2752:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2756:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2759:	89 44 24 08          	mov    %eax,0x8(%esp)
    275d:	c7 44 24 04 80 52 00 	movl   $0x5280,0x4(%esp)
    2764:	00 
    2765:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    276c:	e8 ea 18 00 00       	call   405b <printf>
        exit();
    2771:	e8 60 17 00 00       	call   3ed6 <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    2776:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    277a:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    277e:	7e aa                	jle    272a <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2780:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2783:	89 04 24             	mov    %eax,(%esp)
    2786:	e8 73 17 00 00       	call   3efe <close>
    unlink("bigwrite");
    278b:	c7 04 24 5f 52 00 00 	movl   $0x525f,(%esp)
    2792:	e8 8f 17 00 00       	call   3f26 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    2797:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    279e:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    27a5:	0f 8e 40 ff ff ff    	jle    26eb <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    27ab:	c7 44 24 04 92 52 00 	movl   $0x5292,0x4(%esp)
    27b2:	00 
    27b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27ba:	e8 9c 18 00 00       	call   405b <printf>
}
    27bf:	c9                   	leave  
    27c0:	c3                   	ret    

000027c1 <bigfile>:

void
bigfile(void)
{
    27c1:	55                   	push   %ebp
    27c2:	89 e5                	mov    %esp,%ebp
    27c4:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27c7:	c7 44 24 04 9f 52 00 	movl   $0x529f,0x4(%esp)
    27ce:	00 
    27cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27d6:	e8 80 18 00 00       	call   405b <printf>

  unlink("bigfile");
    27db:	c7 04 24 ad 52 00 00 	movl   $0x52ad,(%esp)
    27e2:	e8 3f 17 00 00       	call   3f26 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    27e7:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    27ee:	00 
    27ef:	c7 04 24 ad 52 00 00 	movl   $0x52ad,(%esp)
    27f6:	e8 1b 17 00 00       	call   3f16 <open>
    27fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    27fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2802:	79 19                	jns    281d <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    2804:	c7 44 24 04 b5 52 00 	movl   $0x52b5,0x4(%esp)
    280b:	00 
    280c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2813:	e8 43 18 00 00       	call   405b <printf>
    exit();
    2818:	e8 b9 16 00 00       	call   3ed6 <exit>
  }
  for(i = 0; i < 20; i++){
    281d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2824:	eb 5a                	jmp    2880 <bigfile+0xbf>
    memset(buf, i, 600);
    2826:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    282d:	00 
    282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2831:	89 44 24 04          	mov    %eax,0x4(%esp)
    2835:	c7 04 24 c0 8a 00 00 	movl   $0x8ac0,(%esp)
    283c:	e8 ef 14 00 00       	call   3d30 <memset>
    if(write(fd, buf, 600) != 600){
    2841:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2848:	00 
    2849:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    2850:	00 
    2851:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2854:	89 04 24             	mov    %eax,(%esp)
    2857:	e8 9a 16 00 00       	call   3ef6 <write>
    285c:	3d 58 02 00 00       	cmp    $0x258,%eax
    2861:	74 19                	je     287c <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    2863:	c7 44 24 04 cb 52 00 	movl   $0x52cb,0x4(%esp)
    286a:	00 
    286b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2872:	e8 e4 17 00 00       	call   405b <printf>
      exit();
    2877:	e8 5a 16 00 00       	call   3ed6 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    287c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2880:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2884:	7e a0                	jle    2826 <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2886:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2889:	89 04 24             	mov    %eax,(%esp)
    288c:	e8 6d 16 00 00       	call   3efe <close>

  fd = open("bigfile", 0);
    2891:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2898:	00 
    2899:	c7 04 24 ad 52 00 00 	movl   $0x52ad,(%esp)
    28a0:	e8 71 16 00 00       	call   3f16 <open>
    28a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    28a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    28ac:	79 19                	jns    28c7 <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    28ae:	c7 44 24 04 e1 52 00 	movl   $0x52e1,0x4(%esp)
    28b5:	00 
    28b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28bd:	e8 99 17 00 00       	call   405b <printf>
    exit();
    28c2:	e8 0f 16 00 00       	call   3ed6 <exit>
  }
  total = 0;
    28c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    28d5:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    28dc:	00 
    28dd:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    28e4:	00 
    28e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    28e8:	89 04 24             	mov    %eax,(%esp)
    28eb:	e8 fe 15 00 00       	call   3eee <read>
    28f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    28f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28f7:	79 19                	jns    2912 <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    28f9:	c7 44 24 04 f6 52 00 	movl   $0x52f6,0x4(%esp)
    2900:	00 
    2901:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2908:	e8 4e 17 00 00       	call   405b <printf>
      exit();
    290d:	e8 c4 15 00 00       	call   3ed6 <exit>
    }
    if(cc == 0)
    2912:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2916:	74 7e                	je     2996 <bigfile+0x1d5>
      break;
    if(cc != 300){
    2918:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    291f:	74 19                	je     293a <bigfile+0x179>
      printf(1, "short read bigfile\n");
    2921:	c7 44 24 04 0b 53 00 	movl   $0x530b,0x4(%esp)
    2928:	00 
    2929:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2930:	e8 26 17 00 00       	call   405b <printf>
      exit();
    2935:	e8 9c 15 00 00       	call   3ed6 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    293a:	0f b6 05 c0 8a 00 00 	movzbl 0x8ac0,%eax
    2941:	0f be d0             	movsbl %al,%edx
    2944:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2947:	89 c1                	mov    %eax,%ecx
    2949:	c1 e9 1f             	shr    $0x1f,%ecx
    294c:	01 c8                	add    %ecx,%eax
    294e:	d1 f8                	sar    %eax
    2950:	39 c2                	cmp    %eax,%edx
    2952:	75 1a                	jne    296e <bigfile+0x1ad>
    2954:	0f b6 05 eb 8b 00 00 	movzbl 0x8beb,%eax
    295b:	0f be d0             	movsbl %al,%edx
    295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2961:	89 c1                	mov    %eax,%ecx
    2963:	c1 e9 1f             	shr    $0x1f,%ecx
    2966:	01 c8                	add    %ecx,%eax
    2968:	d1 f8                	sar    %eax
    296a:	39 c2                	cmp    %eax,%edx
    296c:	74 19                	je     2987 <bigfile+0x1c6>
      printf(1, "read bigfile wrong data\n");
    296e:	c7 44 24 04 1f 53 00 	movl   $0x531f,0x4(%esp)
    2975:	00 
    2976:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    297d:	e8 d9 16 00 00       	call   405b <printf>
      exit();
    2982:	e8 4f 15 00 00       	call   3ed6 <exit>
    }
    total += cc;
    2987:	8b 45 e8             	mov    -0x18(%ebp),%eax
    298a:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    298d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    2991:	e9 3f ff ff ff       	jmp    28d5 <bigfile+0x114>
    if(cc < 0){
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    2996:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    2997:	8b 45 ec             	mov    -0x14(%ebp),%eax
    299a:	89 04 24             	mov    %eax,(%esp)
    299d:	e8 5c 15 00 00       	call   3efe <close>
  if(total != 20*600){
    29a2:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    29a9:	74 19                	je     29c4 <bigfile+0x203>
    printf(1, "read bigfile wrong total\n");
    29ab:	c7 44 24 04 38 53 00 	movl   $0x5338,0x4(%esp)
    29b2:	00 
    29b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29ba:	e8 9c 16 00 00       	call   405b <printf>
    exit();
    29bf:	e8 12 15 00 00       	call   3ed6 <exit>
  }
  unlink("bigfile");
    29c4:	c7 04 24 ad 52 00 00 	movl   $0x52ad,(%esp)
    29cb:	e8 56 15 00 00       	call   3f26 <unlink>

  printf(1, "bigfile test ok\n");
    29d0:	c7 44 24 04 52 53 00 	movl   $0x5352,0x4(%esp)
    29d7:	00 
    29d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29df:	e8 77 16 00 00       	call   405b <printf>
}
    29e4:	c9                   	leave  
    29e5:	c3                   	ret    

000029e6 <fourteen>:

void
fourteen(void)
{
    29e6:	55                   	push   %ebp
    29e7:	89 e5                	mov    %esp,%ebp
    29e9:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29ec:	c7 44 24 04 63 53 00 	movl   $0x5363,0x4(%esp)
    29f3:	00 
    29f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29fb:	e8 5b 16 00 00       	call   405b <printf>

  if(mkdir("12345678901234") != 0){
    2a00:	c7 04 24 72 53 00 00 	movl   $0x5372,(%esp)
    2a07:	e8 32 15 00 00       	call   3f3e <mkdir>
    2a0c:	85 c0                	test   %eax,%eax
    2a0e:	74 19                	je     2a29 <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a10:	c7 44 24 04 81 53 00 	movl   $0x5381,0x4(%esp)
    2a17:	00 
    2a18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a1f:	e8 37 16 00 00       	call   405b <printf>
    exit();
    2a24:	e8 ad 14 00 00       	call   3ed6 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a29:	c7 04 24 a0 53 00 00 	movl   $0x53a0,(%esp)
    2a30:	e8 09 15 00 00       	call   3f3e <mkdir>
    2a35:	85 c0                	test   %eax,%eax
    2a37:	74 19                	je     2a52 <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a39:	c7 44 24 04 c0 53 00 	movl   $0x53c0,0x4(%esp)
    2a40:	00 
    2a41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a48:	e8 0e 16 00 00       	call   405b <printf>
    exit();
    2a4d:	e8 84 14 00 00       	call   3ed6 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a52:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a59:	00 
    2a5a:	c7 04 24 f0 53 00 00 	movl   $0x53f0,(%esp)
    2a61:	e8 b0 14 00 00       	call   3f16 <open>
    2a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a6d:	79 19                	jns    2a88 <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a6f:	c7 44 24 04 20 54 00 	movl   $0x5420,0x4(%esp)
    2a76:	00 
    2a77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a7e:	e8 d8 15 00 00       	call   405b <printf>
    exit();
    2a83:	e8 4e 14 00 00       	call   3ed6 <exit>
  }
  close(fd);
    2a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a8b:	89 04 24             	mov    %eax,(%esp)
    2a8e:	e8 6b 14 00 00       	call   3efe <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2a9a:	00 
    2a9b:	c7 04 24 60 54 00 00 	movl   $0x5460,(%esp)
    2aa2:	e8 6f 14 00 00       	call   3f16 <open>
    2aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aae:	79 19                	jns    2ac9 <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2ab0:	c7 44 24 04 90 54 00 	movl   $0x5490,0x4(%esp)
    2ab7:	00 
    2ab8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2abf:	e8 97 15 00 00       	call   405b <printf>
    exit();
    2ac4:	e8 0d 14 00 00       	call   3ed6 <exit>
  }
  close(fd);
    2ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2acc:	89 04 24             	mov    %eax,(%esp)
    2acf:	e8 2a 14 00 00       	call   3efe <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2ad4:	c7 04 24 ca 54 00 00 	movl   $0x54ca,(%esp)
    2adb:	e8 5e 14 00 00       	call   3f3e <mkdir>
    2ae0:	85 c0                	test   %eax,%eax
    2ae2:	75 19                	jne    2afd <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2ae4:	c7 44 24 04 e8 54 00 	movl   $0x54e8,0x4(%esp)
    2aeb:	00 
    2aec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2af3:	e8 63 15 00 00       	call   405b <printf>
    exit();
    2af8:	e8 d9 13 00 00       	call   3ed6 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2afd:	c7 04 24 18 55 00 00 	movl   $0x5518,(%esp)
    2b04:	e8 35 14 00 00       	call   3f3e <mkdir>
    2b09:	85 c0                	test   %eax,%eax
    2b0b:	75 19                	jne    2b26 <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2b0d:	c7 44 24 04 38 55 00 	movl   $0x5538,0x4(%esp)
    2b14:	00 
    2b15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b1c:	e8 3a 15 00 00       	call   405b <printf>
    exit();
    2b21:	e8 b0 13 00 00       	call   3ed6 <exit>
  }

  printf(1, "fourteen ok\n");
    2b26:	c7 44 24 04 69 55 00 	movl   $0x5569,0x4(%esp)
    2b2d:	00 
    2b2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b35:	e8 21 15 00 00       	call   405b <printf>
}
    2b3a:	c9                   	leave  
    2b3b:	c3                   	ret    

00002b3c <rmdot>:

void
rmdot(void)
{
    2b3c:	55                   	push   %ebp
    2b3d:	89 e5                	mov    %esp,%ebp
    2b3f:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    2b42:	c7 44 24 04 76 55 00 	movl   $0x5576,0x4(%esp)
    2b49:	00 
    2b4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b51:	e8 05 15 00 00       	call   405b <printf>
  if(mkdir("dots") != 0){
    2b56:	c7 04 24 82 55 00 00 	movl   $0x5582,(%esp)
    2b5d:	e8 dc 13 00 00       	call   3f3e <mkdir>
    2b62:	85 c0                	test   %eax,%eax
    2b64:	74 19                	je     2b7f <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b66:	c7 44 24 04 87 55 00 	movl   $0x5587,0x4(%esp)
    2b6d:	00 
    2b6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b75:	e8 e1 14 00 00       	call   405b <printf>
    exit();
    2b7a:	e8 57 13 00 00       	call   3ed6 <exit>
  }
  if(chdir("dots") != 0){
    2b7f:	c7 04 24 82 55 00 00 	movl   $0x5582,(%esp)
    2b86:	e8 bb 13 00 00       	call   3f46 <chdir>
    2b8b:	85 c0                	test   %eax,%eax
    2b8d:	74 19                	je     2ba8 <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2b8f:	c7 44 24 04 9a 55 00 	movl   $0x559a,0x4(%esp)
    2b96:	00 
    2b97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b9e:	e8 b8 14 00 00       	call   405b <printf>
    exit();
    2ba3:	e8 2e 13 00 00       	call   3ed6 <exit>
  }
  if(unlink(".") == 0){
    2ba8:	c7 04 24 b3 4c 00 00 	movl   $0x4cb3,(%esp)
    2baf:	e8 72 13 00 00       	call   3f26 <unlink>
    2bb4:	85 c0                	test   %eax,%eax
    2bb6:	75 19                	jne    2bd1 <rmdot+0x95>
    printf(1, "rm . worked!\n");
    2bb8:	c7 44 24 04 ad 55 00 	movl   $0x55ad,0x4(%esp)
    2bbf:	00 
    2bc0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bc7:	e8 8f 14 00 00       	call   405b <printf>
    exit();
    2bcc:	e8 05 13 00 00       	call   3ed6 <exit>
  }
  if(unlink("..") == 0){
    2bd1:	c7 04 24 46 48 00 00 	movl   $0x4846,(%esp)
    2bd8:	e8 49 13 00 00       	call   3f26 <unlink>
    2bdd:	85 c0                	test   %eax,%eax
    2bdf:	75 19                	jne    2bfa <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    2be1:	c7 44 24 04 bb 55 00 	movl   $0x55bb,0x4(%esp)
    2be8:	00 
    2be9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bf0:	e8 66 14 00 00       	call   405b <printf>
    exit();
    2bf5:	e8 dc 12 00 00       	call   3ed6 <exit>
  }
  if(chdir("/") != 0){
    2bfa:	c7 04 24 9a 44 00 00 	movl   $0x449a,(%esp)
    2c01:	e8 40 13 00 00       	call   3f46 <chdir>
    2c06:	85 c0                	test   %eax,%eax
    2c08:	74 19                	je     2c23 <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    2c0a:	c7 44 24 04 9c 44 00 	movl   $0x449c,0x4(%esp)
    2c11:	00 
    2c12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c19:	e8 3d 14 00 00       	call   405b <printf>
    exit();
    2c1e:	e8 b3 12 00 00       	call   3ed6 <exit>
  }
  if(unlink("dots/.") == 0){
    2c23:	c7 04 24 ca 55 00 00 	movl   $0x55ca,(%esp)
    2c2a:	e8 f7 12 00 00       	call   3f26 <unlink>
    2c2f:	85 c0                	test   %eax,%eax
    2c31:	75 19                	jne    2c4c <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    2c33:	c7 44 24 04 d1 55 00 	movl   $0x55d1,0x4(%esp)
    2c3a:	00 
    2c3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c42:	e8 14 14 00 00       	call   405b <printf>
    exit();
    2c47:	e8 8a 12 00 00       	call   3ed6 <exit>
  }
  if(unlink("dots/..") == 0){
    2c4c:	c7 04 24 e8 55 00 00 	movl   $0x55e8,(%esp)
    2c53:	e8 ce 12 00 00       	call   3f26 <unlink>
    2c58:	85 c0                	test   %eax,%eax
    2c5a:	75 19                	jne    2c75 <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    2c5c:	c7 44 24 04 f0 55 00 	movl   $0x55f0,0x4(%esp)
    2c63:	00 
    2c64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c6b:	e8 eb 13 00 00       	call   405b <printf>
    exit();
    2c70:	e8 61 12 00 00       	call   3ed6 <exit>
  }
  if(unlink("dots") != 0){
    2c75:	c7 04 24 82 55 00 00 	movl   $0x5582,(%esp)
    2c7c:	e8 a5 12 00 00       	call   3f26 <unlink>
    2c81:	85 c0                	test   %eax,%eax
    2c83:	74 19                	je     2c9e <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    2c85:	c7 44 24 04 08 56 00 	movl   $0x5608,0x4(%esp)
    2c8c:	00 
    2c8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c94:	e8 c2 13 00 00       	call   405b <printf>
    exit();
    2c99:	e8 38 12 00 00       	call   3ed6 <exit>
  }
  printf(1, "rmdot ok\n");
    2c9e:	c7 44 24 04 1d 56 00 	movl   $0x561d,0x4(%esp)
    2ca5:	00 
    2ca6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cad:	e8 a9 13 00 00       	call   405b <printf>
}
    2cb2:	c9                   	leave  
    2cb3:	c3                   	ret    

00002cb4 <dirfile>:

void
dirfile(void)
{
    2cb4:	55                   	push   %ebp
    2cb5:	89 e5                	mov    %esp,%ebp
    2cb7:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cba:	c7 44 24 04 27 56 00 	movl   $0x5627,0x4(%esp)
    2cc1:	00 
    2cc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cc9:	e8 8d 13 00 00       	call   405b <printf>

  fd = open("dirfile", O_CREATE);
    2cce:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2cd5:	00 
    2cd6:	c7 04 24 34 56 00 00 	movl   $0x5634,(%esp)
    2cdd:	e8 34 12 00 00       	call   3f16 <open>
    2ce2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2ce5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ce9:	79 19                	jns    2d04 <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    2ceb:	c7 44 24 04 3c 56 00 	movl   $0x563c,0x4(%esp)
    2cf2:	00 
    2cf3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cfa:	e8 5c 13 00 00       	call   405b <printf>
    exit();
    2cff:	e8 d2 11 00 00       	call   3ed6 <exit>
  }
  close(fd);
    2d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d07:	89 04 24             	mov    %eax,(%esp)
    2d0a:	e8 ef 11 00 00       	call   3efe <close>
  if(chdir("dirfile") == 0){
    2d0f:	c7 04 24 34 56 00 00 	movl   $0x5634,(%esp)
    2d16:	e8 2b 12 00 00       	call   3f46 <chdir>
    2d1b:	85 c0                	test   %eax,%eax
    2d1d:	75 19                	jne    2d38 <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2d1f:	c7 44 24 04 53 56 00 	movl   $0x5653,0x4(%esp)
    2d26:	00 
    2d27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d2e:	e8 28 13 00 00       	call   405b <printf>
    exit();
    2d33:	e8 9e 11 00 00       	call   3ed6 <exit>
  }
  fd = open("dirfile/xx", 0);
    2d38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2d3f:	00 
    2d40:	c7 04 24 6d 56 00 00 	movl   $0x566d,(%esp)
    2d47:	e8 ca 11 00 00       	call   3f16 <open>
    2d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d53:	78 19                	js     2d6e <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2d55:	c7 44 24 04 78 56 00 	movl   $0x5678,0x4(%esp)
    2d5c:	00 
    2d5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d64:	e8 f2 12 00 00       	call   405b <printf>
    exit();
    2d69:	e8 68 11 00 00       	call   3ed6 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d6e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d75:	00 
    2d76:	c7 04 24 6d 56 00 00 	movl   $0x566d,(%esp)
    2d7d:	e8 94 11 00 00       	call   3f16 <open>
    2d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d89:	78 19                	js     2da4 <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2d8b:	c7 44 24 04 78 56 00 	movl   $0x5678,0x4(%esp)
    2d92:	00 
    2d93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d9a:	e8 bc 12 00 00       	call   405b <printf>
    exit();
    2d9f:	e8 32 11 00 00       	call   3ed6 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2da4:	c7 04 24 6d 56 00 00 	movl   $0x566d,(%esp)
    2dab:	e8 8e 11 00 00       	call   3f3e <mkdir>
    2db0:	85 c0                	test   %eax,%eax
    2db2:	75 19                	jne    2dcd <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2db4:	c7 44 24 04 96 56 00 	movl   $0x5696,0x4(%esp)
    2dbb:	00 
    2dbc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dc3:	e8 93 12 00 00       	call   405b <printf>
    exit();
    2dc8:	e8 09 11 00 00       	call   3ed6 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2dcd:	c7 04 24 6d 56 00 00 	movl   $0x566d,(%esp)
    2dd4:	e8 4d 11 00 00       	call   3f26 <unlink>
    2dd9:	85 c0                	test   %eax,%eax
    2ddb:	75 19                	jne    2df6 <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2ddd:	c7 44 24 04 b3 56 00 	movl   $0x56b3,0x4(%esp)
    2de4:	00 
    2de5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dec:	e8 6a 12 00 00       	call   405b <printf>
    exit();
    2df1:	e8 e0 10 00 00       	call   3ed6 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2df6:	c7 44 24 04 6d 56 00 	movl   $0x566d,0x4(%esp)
    2dfd:	00 
    2dfe:	c7 04 24 d1 56 00 00 	movl   $0x56d1,(%esp)
    2e05:	e8 2c 11 00 00       	call   3f36 <link>
    2e0a:	85 c0                	test   %eax,%eax
    2e0c:	75 19                	jne    2e27 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e0e:	c7 44 24 04 d8 56 00 	movl   $0x56d8,0x4(%esp)
    2e15:	00 
    2e16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e1d:	e8 39 12 00 00       	call   405b <printf>
    exit();
    2e22:	e8 af 10 00 00       	call   3ed6 <exit>
  }
  if(unlink("dirfile") != 0){
    2e27:	c7 04 24 34 56 00 00 	movl   $0x5634,(%esp)
    2e2e:	e8 f3 10 00 00       	call   3f26 <unlink>
    2e33:	85 c0                	test   %eax,%eax
    2e35:	74 19                	je     2e50 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2e37:	c7 44 24 04 f7 56 00 	movl   $0x56f7,0x4(%esp)
    2e3e:	00 
    2e3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e46:	e8 10 12 00 00       	call   405b <printf>
    exit();
    2e4b:	e8 86 10 00 00       	call   3ed6 <exit>
  }

  fd = open(".", O_RDWR);
    2e50:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2e57:	00 
    2e58:	c7 04 24 b3 4c 00 00 	movl   $0x4cb3,(%esp)
    2e5f:	e8 b2 10 00 00       	call   3f16 <open>
    2e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e6b:	78 19                	js     2e86 <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2e6d:	c7 44 24 04 10 57 00 	movl   $0x5710,0x4(%esp)
    2e74:	00 
    2e75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e7c:	e8 da 11 00 00       	call   405b <printf>
    exit();
    2e81:	e8 50 10 00 00       	call   3ed6 <exit>
  }
  fd = open(".", 0);
    2e86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2e8d:	00 
    2e8e:	c7 04 24 b3 4c 00 00 	movl   $0x4cb3,(%esp)
    2e95:	e8 7c 10 00 00       	call   3f16 <open>
    2e9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e9d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2ea4:	00 
    2ea5:	c7 44 24 04 ff 48 00 	movl   $0x48ff,0x4(%esp)
    2eac:	00 
    2ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2eb0:	89 04 24             	mov    %eax,(%esp)
    2eb3:	e8 3e 10 00 00       	call   3ef6 <write>
    2eb8:	85 c0                	test   %eax,%eax
    2eba:	7e 19                	jle    2ed5 <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2ebc:	c7 44 24 04 2f 57 00 	movl   $0x572f,0x4(%esp)
    2ec3:	00 
    2ec4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ecb:	e8 8b 11 00 00       	call   405b <printf>
    exit();
    2ed0:	e8 01 10 00 00       	call   3ed6 <exit>
  }
  close(fd);
    2ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ed8:	89 04 24             	mov    %eax,(%esp)
    2edb:	e8 1e 10 00 00       	call   3efe <close>

  printf(1, "dir vs file OK\n");
    2ee0:	c7 44 24 04 43 57 00 	movl   $0x5743,0x4(%esp)
    2ee7:	00 
    2ee8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2eef:	e8 67 11 00 00       	call   405b <printf>
}
    2ef4:	c9                   	leave  
    2ef5:	c3                   	ret    

00002ef6 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2ef6:	55                   	push   %ebp
    2ef7:	89 e5                	mov    %esp,%ebp
    2ef9:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2efc:	c7 44 24 04 53 57 00 	movl   $0x5753,0x4(%esp)
    2f03:	00 
    2f04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f0b:	e8 4b 11 00 00       	call   405b <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f17:	e9 d2 00 00 00       	jmp    2fee <iref+0xf8>
    if(mkdir("irefd") != 0){
    2f1c:	c7 04 24 64 57 00 00 	movl   $0x5764,(%esp)
    2f23:	e8 16 10 00 00       	call   3f3e <mkdir>
    2f28:	85 c0                	test   %eax,%eax
    2f2a:	74 19                	je     2f45 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f2c:	c7 44 24 04 6a 57 00 	movl   $0x576a,0x4(%esp)
    2f33:	00 
    2f34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f3b:	e8 1b 11 00 00       	call   405b <printf>
      exit();
    2f40:	e8 91 0f 00 00       	call   3ed6 <exit>
    }
    if(chdir("irefd") != 0){
    2f45:	c7 04 24 64 57 00 00 	movl   $0x5764,(%esp)
    2f4c:	e8 f5 0f 00 00       	call   3f46 <chdir>
    2f51:	85 c0                	test   %eax,%eax
    2f53:	74 19                	je     2f6e <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2f55:	c7 44 24 04 7e 57 00 	movl   $0x577e,0x4(%esp)
    2f5c:	00 
    2f5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f64:	e8 f2 10 00 00       	call   405b <printf>
      exit();
    2f69:	e8 68 0f 00 00       	call   3ed6 <exit>
    }

    mkdir("");
    2f6e:	c7 04 24 92 57 00 00 	movl   $0x5792,(%esp)
    2f75:	e8 c4 0f 00 00       	call   3f3e <mkdir>
    link("README", "");
    2f7a:	c7 44 24 04 92 57 00 	movl   $0x5792,0x4(%esp)
    2f81:	00 
    2f82:	c7 04 24 d1 56 00 00 	movl   $0x56d1,(%esp)
    2f89:	e8 a8 0f 00 00       	call   3f36 <link>
    fd = open("", O_CREATE);
    2f8e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2f95:	00 
    2f96:	c7 04 24 92 57 00 00 	movl   $0x5792,(%esp)
    2f9d:	e8 74 0f 00 00       	call   3f16 <open>
    2fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fa5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fa9:	78 0b                	js     2fb6 <iref+0xc0>
      close(fd);
    2fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2fae:	89 04 24             	mov    %eax,(%esp)
    2fb1:	e8 48 0f 00 00       	call   3efe <close>
    fd = open("xx", O_CREATE);
    2fb6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2fbd:	00 
    2fbe:	c7 04 24 93 57 00 00 	movl   $0x5793,(%esp)
    2fc5:	e8 4c 0f 00 00       	call   3f16 <open>
    2fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fcd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fd1:	78 0b                	js     2fde <iref+0xe8>
      close(fd);
    2fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2fd6:	89 04 24             	mov    %eax,(%esp)
    2fd9:	e8 20 0f 00 00       	call   3efe <close>
    unlink("xx");
    2fde:	c7 04 24 93 57 00 00 	movl   $0x5793,(%esp)
    2fe5:	e8 3c 0f 00 00       	call   3f26 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2fea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2fee:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2ff2:	0f 8e 24 ff ff ff    	jle    2f1c <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2ff8:	c7 04 24 9a 44 00 00 	movl   $0x449a,(%esp)
    2fff:	e8 42 0f 00 00       	call   3f46 <chdir>
  printf(1, "empty file name OK\n");
    3004:	c7 44 24 04 96 57 00 	movl   $0x5796,0x4(%esp)
    300b:	00 
    300c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3013:	e8 43 10 00 00       	call   405b <printf>
}
    3018:	c9                   	leave  
    3019:	c3                   	ret    

0000301a <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    301a:	55                   	push   %ebp
    301b:	89 e5                	mov    %esp,%ebp
    301d:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    3020:	c7 44 24 04 aa 57 00 	movl   $0x57aa,0x4(%esp)
    3027:	00 
    3028:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    302f:	e8 27 10 00 00       	call   405b <printf>

  for(n=0; n<1000; n++){
    3034:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    303b:	eb 1d                	jmp    305a <forktest+0x40>
    pid = fork();
    303d:	e8 8c 0e 00 00       	call   3ece <fork>
    3042:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    3045:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3049:	78 1a                	js     3065 <forktest+0x4b>
      break;
    if(pid == 0)
    304b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    304f:	75 05                	jne    3056 <forktest+0x3c>
      exit();
    3051:	e8 80 0e 00 00       	call   3ed6 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    3056:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    305a:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    3061:	7e da                	jle    303d <forktest+0x23>
    3063:	eb 01                	jmp    3066 <forktest+0x4c>
    pid = fork();
    if(pid < 0)
      break;
    3065:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    3066:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    306d:	75 3f                	jne    30ae <forktest+0x94>
    printf(1, "fork claimed to work 1000 times!\n");
    306f:	c7 44 24 04 b8 57 00 	movl   $0x57b8,0x4(%esp)
    3076:	00 
    3077:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    307e:	e8 d8 0f 00 00       	call   405b <printf>
    exit();
    3083:	e8 4e 0e 00 00       	call   3ed6 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    3088:	e8 51 0e 00 00       	call   3ede <wait>
    308d:	85 c0                	test   %eax,%eax
    308f:	79 19                	jns    30aa <forktest+0x90>
      printf(1, "wait stopped early\n");
    3091:	c7 44 24 04 da 57 00 	movl   $0x57da,0x4(%esp)
    3098:	00 
    3099:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30a0:	e8 b6 0f 00 00       	call   405b <printf>
      exit();
    30a5:	e8 2c 0e 00 00       	call   3ed6 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    30aa:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30b2:	7f d4                	jg     3088 <forktest+0x6e>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    30b4:	e8 25 0e 00 00       	call   3ede <wait>
    30b9:	83 f8 ff             	cmp    $0xffffffff,%eax
    30bc:	74 19                	je     30d7 <forktest+0xbd>
    printf(1, "wait got too many\n");
    30be:	c7 44 24 04 ee 57 00 	movl   $0x57ee,0x4(%esp)
    30c5:	00 
    30c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30cd:	e8 89 0f 00 00       	call   405b <printf>
    exit();
    30d2:	e8 ff 0d 00 00       	call   3ed6 <exit>
  }
  
  printf(1, "fork test OK\n");
    30d7:	c7 44 24 04 01 58 00 	movl   $0x5801,0x4(%esp)
    30de:	00 
    30df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30e6:	e8 70 0f 00 00       	call   405b <printf>
}
    30eb:	c9                   	leave  
    30ec:	c3                   	ret    

000030ed <sbrktest>:

void
sbrktest(void)
{
    30ed:	55                   	push   %ebp
    30ee:	89 e5                	mov    %esp,%ebp
    30f0:	53                   	push   %ebx
    30f1:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    30f7:	a1 e4 62 00 00       	mov    0x62e4,%eax
    30fc:	c7 44 24 04 0f 58 00 	movl   $0x580f,0x4(%esp)
    3103:	00 
    3104:	89 04 24             	mov    %eax,(%esp)
    3107:	e8 4f 0f 00 00       	call   405b <printf>
  oldbrk = sbrk(0);
    310c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3113:	e8 46 0e 00 00       	call   3f5e <sbrk>
    3118:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    311b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3122:	e8 37 0e 00 00       	call   3f5e <sbrk>
    3127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    312a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3131:	eb 59                	jmp    318c <sbrktest+0x9f>
    b = sbrk(1);
    3133:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    313a:	e8 1f 0e 00 00       	call   3f5e <sbrk>
    313f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    3142:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3148:	74 2f                	je     3179 <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    314a:	a1 e4 62 00 00       	mov    0x62e4,%eax
    314f:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3152:	89 54 24 10          	mov    %edx,0x10(%esp)
    3156:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3159:	89 54 24 0c          	mov    %edx,0xc(%esp)
    315d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3160:	89 54 24 08          	mov    %edx,0x8(%esp)
    3164:	c7 44 24 04 1a 58 00 	movl   $0x581a,0x4(%esp)
    316b:	00 
    316c:	89 04 24             	mov    %eax,(%esp)
    316f:	e8 e7 0e 00 00       	call   405b <printf>
      exit();
    3174:	e8 5d 0d 00 00       	call   3ed6 <exit>
    }
    *b = 1;
    3179:	8b 45 e8             	mov    -0x18(%ebp),%eax
    317c:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    317f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3182:	83 c0 01             	add    $0x1,%eax
    3185:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    3188:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    318c:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    3193:	7e 9e                	jle    3133 <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    3195:	e8 34 0d 00 00       	call   3ece <fork>
    319a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    319d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    31a1:	79 1a                	jns    31bd <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
    31a3:	a1 e4 62 00 00       	mov    0x62e4,%eax
    31a8:	c7 44 24 04 35 58 00 	movl   $0x5835,0x4(%esp)
    31af:	00 
    31b0:	89 04 24             	mov    %eax,(%esp)
    31b3:	e8 a3 0e 00 00       	call   405b <printf>
    exit();
    31b8:	e8 19 0d 00 00       	call   3ed6 <exit>
  }
  c = sbrk(1);
    31bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31c4:	e8 95 0d 00 00       	call   3f5e <sbrk>
    31c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    31cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31d3:	e8 86 0d 00 00       	call   3f5e <sbrk>
    31d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    31db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31de:	83 c0 01             	add    $0x1,%eax
    31e1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    31e4:	74 1a                	je     3200 <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
    31e6:	a1 e4 62 00 00       	mov    0x62e4,%eax
    31eb:	c7 44 24 04 4c 58 00 	movl   $0x584c,0x4(%esp)
    31f2:	00 
    31f3:	89 04 24             	mov    %eax,(%esp)
    31f6:	e8 60 0e 00 00       	call   405b <printf>
    exit();
    31fb:	e8 d6 0c 00 00       	call   3ed6 <exit>
  }
  if(pid == 0)
    3200:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3204:	75 05                	jne    320b <sbrktest+0x11e>
    exit();
    3206:	e8 cb 0c 00 00       	call   3ed6 <exit>
  wait();
    320b:	e8 ce 0c 00 00       	call   3ede <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3210:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3217:	e8 42 0d 00 00       	call   3f5e <sbrk>
    321c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3222:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3227:	89 d1                	mov    %edx,%ecx
    3229:	29 c1                	sub    %eax,%ecx
    322b:	89 c8                	mov    %ecx,%eax
    322d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    3230:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3233:	89 04 24             	mov    %eax,(%esp)
    3236:	e8 23 0d 00 00       	call   3f5e <sbrk>
    323b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    323e:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3241:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3244:	74 1a                	je     3260 <sbrktest+0x173>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3246:	a1 e4 62 00 00       	mov    0x62e4,%eax
    324b:	c7 44 24 04 68 58 00 	movl   $0x5868,0x4(%esp)
    3252:	00 
    3253:	89 04 24             	mov    %eax,(%esp)
    3256:	e8 00 0e 00 00       	call   405b <printf>
    exit();
    325b:	e8 76 0c 00 00       	call   3ed6 <exit>
  }
  lastaddr = (char*) (BIG-1);
    3260:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    3267:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    326a:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    326d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3274:	e8 e5 0c 00 00       	call   3f5e <sbrk>
    3279:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    327c:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    3283:	e8 d6 0c 00 00       	call   3f5e <sbrk>
    3288:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    328b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    328f:	75 1a                	jne    32ab <sbrktest+0x1be>
    printf(stdout, "sbrk could not deallocate\n");
    3291:	a1 e4 62 00 00       	mov    0x62e4,%eax
    3296:	c7 44 24 04 a6 58 00 	movl   $0x58a6,0x4(%esp)
    329d:	00 
    329e:	89 04 24             	mov    %eax,(%esp)
    32a1:	e8 b5 0d 00 00       	call   405b <printf>
    exit();
    32a6:	e8 2b 0c 00 00       	call   3ed6 <exit>
  }
  c = sbrk(0);
    32ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32b2:	e8 a7 0c 00 00       	call   3f5e <sbrk>
    32b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32bd:	2d 00 10 00 00       	sub    $0x1000,%eax
    32c2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    32c5:	74 28                	je     32ef <sbrktest+0x202>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32c7:	a1 e4 62 00 00       	mov    0x62e4,%eax
    32cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
    32cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
    32d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    32d6:	89 54 24 08          	mov    %edx,0x8(%esp)
    32da:	c7 44 24 04 c4 58 00 	movl   $0x58c4,0x4(%esp)
    32e1:	00 
    32e2:	89 04 24             	mov    %eax,(%esp)
    32e5:	e8 71 0d 00 00       	call   405b <printf>
    exit();
    32ea:	e8 e7 0b 00 00       	call   3ed6 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    32ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32f6:	e8 63 0c 00 00       	call   3f5e <sbrk>
    32fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    32fe:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3305:	e8 54 0c 00 00       	call   3f5e <sbrk>
    330a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    330d:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3310:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3313:	75 19                	jne    332e <sbrktest+0x241>
    3315:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    331c:	e8 3d 0c 00 00       	call   3f5e <sbrk>
    3321:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3324:	81 c2 00 10 00 00    	add    $0x1000,%edx
    332a:	39 d0                	cmp    %edx,%eax
    332c:	74 28                	je     3356 <sbrktest+0x269>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    332e:	a1 e4 62 00 00       	mov    0x62e4,%eax
    3333:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3336:	89 54 24 0c          	mov    %edx,0xc(%esp)
    333a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    333d:	89 54 24 08          	mov    %edx,0x8(%esp)
    3341:	c7 44 24 04 fc 58 00 	movl   $0x58fc,0x4(%esp)
    3348:	00 
    3349:	89 04 24             	mov    %eax,(%esp)
    334c:	e8 0a 0d 00 00       	call   405b <printf>
    exit();
    3351:	e8 80 0b 00 00       	call   3ed6 <exit>
  }
  if(*lastaddr == 99){
    3356:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3359:	0f b6 00             	movzbl (%eax),%eax
    335c:	3c 63                	cmp    $0x63,%al
    335e:	75 1a                	jne    337a <sbrktest+0x28d>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3360:	a1 e4 62 00 00       	mov    0x62e4,%eax
    3365:	c7 44 24 04 24 59 00 	movl   $0x5924,0x4(%esp)
    336c:	00 
    336d:	89 04 24             	mov    %eax,(%esp)
    3370:	e8 e6 0c 00 00       	call   405b <printf>
    exit();
    3375:	e8 5c 0b 00 00       	call   3ed6 <exit>
  }

  a = sbrk(0);
    337a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3381:	e8 d8 0b 00 00       	call   3f5e <sbrk>
    3386:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3389:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    338c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3393:	e8 c6 0b 00 00       	call   3f5e <sbrk>
    3398:	89 da                	mov    %ebx,%edx
    339a:	29 c2                	sub    %eax,%edx
    339c:	89 d0                	mov    %edx,%eax
    339e:	89 04 24             	mov    %eax,(%esp)
    33a1:	e8 b8 0b 00 00       	call   3f5e <sbrk>
    33a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    33a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
    33ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33af:	74 28                	je     33d9 <sbrktest+0x2ec>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33b1:	a1 e4 62 00 00       	mov    0x62e4,%eax
    33b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
    33b9:	89 54 24 0c          	mov    %edx,0xc(%esp)
    33bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
    33c0:	89 54 24 08          	mov    %edx,0x8(%esp)
    33c4:	c7 44 24 04 54 59 00 	movl   $0x5954,0x4(%esp)
    33cb:	00 
    33cc:	89 04 24             	mov    %eax,(%esp)
    33cf:	e8 87 0c 00 00       	call   405b <printf>
    exit();
    33d4:	e8 fd 0a 00 00       	call   3ed6 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33d9:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    33e0:	eb 7b                	jmp    345d <sbrktest+0x370>
    ppid = getpid();
    33e2:	e8 6f 0b 00 00       	call   3f56 <getpid>
    33e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    33ea:	e8 df 0a 00 00       	call   3ece <fork>
    33ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    33f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    33f6:	79 1a                	jns    3412 <sbrktest+0x325>
      printf(stdout, "fork failed\n");
    33f8:	a1 e4 62 00 00       	mov    0x62e4,%eax
    33fd:	c7 44 24 04 c9 44 00 	movl   $0x44c9,0x4(%esp)
    3404:	00 
    3405:	89 04 24             	mov    %eax,(%esp)
    3408:	e8 4e 0c 00 00       	call   405b <printf>
      exit();
    340d:	e8 c4 0a 00 00       	call   3ed6 <exit>
    }
    if(pid == 0){
    3412:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3416:	75 39                	jne    3451 <sbrktest+0x364>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3418:	8b 45 f4             	mov    -0xc(%ebp),%eax
    341b:	0f b6 00             	movzbl (%eax),%eax
    341e:	0f be d0             	movsbl %al,%edx
    3421:	a1 e4 62 00 00       	mov    0x62e4,%eax
    3426:	89 54 24 0c          	mov    %edx,0xc(%esp)
    342a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    342d:	89 54 24 08          	mov    %edx,0x8(%esp)
    3431:	c7 44 24 04 75 59 00 	movl   $0x5975,0x4(%esp)
    3438:	00 
    3439:	89 04 24             	mov    %eax,(%esp)
    343c:	e8 1a 0c 00 00       	call   405b <printf>
      kill(ppid);
    3441:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3444:	89 04 24             	mov    %eax,(%esp)
    3447:	e8 ba 0a 00 00       	call   3f06 <kill>
      exit();
    344c:	e8 85 0a 00 00       	call   3ed6 <exit>
    }
    wait();
    3451:	e8 88 0a 00 00       	call   3ede <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3456:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    345d:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    3464:	0f 86 78 ff ff ff    	jbe    33e2 <sbrktest+0x2f5>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    346a:	8d 45 c8             	lea    -0x38(%ebp),%eax
    346d:	89 04 24             	mov    %eax,(%esp)
    3470:	e8 71 0a 00 00       	call   3ee6 <pipe>
    3475:	85 c0                	test   %eax,%eax
    3477:	74 19                	je     3492 <sbrktest+0x3a5>
    printf(1, "pipe() failed\n");
    3479:	c7 44 24 04 9a 48 00 	movl   $0x489a,0x4(%esp)
    3480:	00 
    3481:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3488:	e8 ce 0b 00 00       	call   405b <printf>
    exit();
    348d:	e8 44 0a 00 00       	call   3ed6 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3492:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3499:	e9 89 00 00 00       	jmp    3527 <sbrktest+0x43a>
    if((pids[i] = fork()) == 0){
    349e:	e8 2b 0a 00 00       	call   3ece <fork>
    34a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
    34a6:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    34aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34ad:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34b1:	85 c0                	test   %eax,%eax
    34b3:	75 48                	jne    34fd <sbrktest+0x410>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    34b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    34bc:	e8 9d 0a 00 00       	call   3f5e <sbrk>
    34c1:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34c6:	89 d1                	mov    %edx,%ecx
    34c8:	29 c1                	sub    %eax,%ecx
    34ca:	89 c8                	mov    %ecx,%eax
    34cc:	89 04 24             	mov    %eax,(%esp)
    34cf:	e8 8a 0a 00 00       	call   3f5e <sbrk>
      write(fds[1], "x", 1);
    34d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    34de:	00 
    34df:	c7 44 24 04 ff 48 00 	movl   $0x48ff,0x4(%esp)
    34e6:	00 
    34e7:	89 04 24             	mov    %eax,(%esp)
    34ea:	e8 07 0a 00 00       	call   3ef6 <write>
      // sit around until killed
      for(;;) sleep(1000);
    34ef:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    34f6:	e8 6b 0a 00 00       	call   3f66 <sleep>
    34fb:	eb f2                	jmp    34ef <sbrktest+0x402>
    }
    if(pids[i] != -1)
    34fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3500:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3504:	83 f8 ff             	cmp    $0xffffffff,%eax
    3507:	74 1a                	je     3523 <sbrktest+0x436>
      read(fds[0], &scratch, 1);
    3509:	8b 45 c8             	mov    -0x38(%ebp),%eax
    350c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3513:	00 
    3514:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3517:	89 54 24 04          	mov    %edx,0x4(%esp)
    351b:	89 04 24             	mov    %eax,(%esp)
    351e:	e8 cb 09 00 00       	call   3eee <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3523:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3527:	8b 45 f0             	mov    -0x10(%ebp),%eax
    352a:	83 f8 09             	cmp    $0x9,%eax
    352d:	0f 86 6b ff ff ff    	jbe    349e <sbrktest+0x3b1>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3533:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    353a:	e8 1f 0a 00 00       	call   3f5e <sbrk>
    353f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3542:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3549:	eb 27                	jmp    3572 <sbrktest+0x485>
    if(pids[i] == -1)
    354b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    354e:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3552:	83 f8 ff             	cmp    $0xffffffff,%eax
    3555:	74 16                	je     356d <sbrktest+0x480>
      continue;
    kill(pids[i]);
    3557:	8b 45 f0             	mov    -0x10(%ebp),%eax
    355a:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    355e:	89 04 24             	mov    %eax,(%esp)
    3561:	e8 a0 09 00 00       	call   3f06 <kill>
    wait();
    3566:	e8 73 09 00 00       	call   3ede <wait>
    356b:	eb 01                	jmp    356e <sbrktest+0x481>
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    356d:	90                   	nop
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    356e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3572:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3575:	83 f8 09             	cmp    $0x9,%eax
    3578:	76 d1                	jbe    354b <sbrktest+0x45e>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    357a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    357e:	75 1a                	jne    359a <sbrktest+0x4ad>
    printf(stdout, "failed sbrk leaked memory\n");
    3580:	a1 e4 62 00 00       	mov    0x62e4,%eax
    3585:	c7 44 24 04 8e 59 00 	movl   $0x598e,0x4(%esp)
    358c:	00 
    358d:	89 04 24             	mov    %eax,(%esp)
    3590:	e8 c6 0a 00 00       	call   405b <printf>
    exit();
    3595:	e8 3c 09 00 00       	call   3ed6 <exit>
  }

  if(sbrk(0) > oldbrk)
    359a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35a1:	e8 b8 09 00 00       	call   3f5e <sbrk>
    35a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    35a9:	76 1d                	jbe    35c8 <sbrktest+0x4db>
    sbrk(-(sbrk(0) - oldbrk));
    35ab:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    35ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35b5:	e8 a4 09 00 00       	call   3f5e <sbrk>
    35ba:	89 da                	mov    %ebx,%edx
    35bc:	29 c2                	sub    %eax,%edx
    35be:	89 d0                	mov    %edx,%eax
    35c0:	89 04 24             	mov    %eax,(%esp)
    35c3:	e8 96 09 00 00       	call   3f5e <sbrk>

  printf(stdout, "sbrk test OK\n");
    35c8:	a1 e4 62 00 00       	mov    0x62e4,%eax
    35cd:	c7 44 24 04 a9 59 00 	movl   $0x59a9,0x4(%esp)
    35d4:	00 
    35d5:	89 04 24             	mov    %eax,(%esp)
    35d8:	e8 7e 0a 00 00       	call   405b <printf>
}
    35dd:	81 c4 84 00 00 00    	add    $0x84,%esp
    35e3:	5b                   	pop    %ebx
    35e4:	5d                   	pop    %ebp
    35e5:	c3                   	ret    

000035e6 <validateint>:

void
validateint(int *p)
{
    35e6:	55                   	push   %ebp
    35e7:	89 e5                	mov    %esp,%ebp
    35e9:	56                   	push   %esi
    35ea:	53                   	push   %ebx
    35eb:	83 ec 14             	sub    $0x14,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    35ee:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
    35f5:	8b 55 08             	mov    0x8(%ebp),%edx
    35f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    35fb:	89 d1                	mov    %edx,%ecx
    35fd:	89 e3                	mov    %esp,%ebx
    35ff:	89 cc                	mov    %ecx,%esp
    3601:	cd 40                	int    $0x40
    3603:	89 dc                	mov    %ebx,%esp
    3605:	89 c6                	mov    %eax,%esi
    3607:	89 75 f4             	mov    %esi,-0xc(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    360a:	83 c4 14             	add    $0x14,%esp
    360d:	5b                   	pop    %ebx
    360e:	5e                   	pop    %esi
    360f:	5d                   	pop    %ebp
    3610:	c3                   	ret    

00003611 <validatetest>:

void
validatetest(void)
{
    3611:	55                   	push   %ebp
    3612:	89 e5                	mov    %esp,%ebp
    3614:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3617:	a1 e4 62 00 00       	mov    0x62e4,%eax
    361c:	c7 44 24 04 b7 59 00 	movl   $0x59b7,0x4(%esp)
    3623:	00 
    3624:	89 04 24             	mov    %eax,(%esp)
    3627:	e8 2f 0a 00 00       	call   405b <printf>
  hi = 1100*1024;
    362c:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    3633:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    363a:	eb 7f                	jmp    36bb <validatetest+0xaa>
    if((pid = fork()) == 0){
    363c:	e8 8d 08 00 00       	call   3ece <fork>
    3641:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3644:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3648:	75 10                	jne    365a <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    364a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    364d:	89 04 24             	mov    %eax,(%esp)
    3650:	e8 91 ff ff ff       	call   35e6 <validateint>
      exit();
    3655:	e8 7c 08 00 00       	call   3ed6 <exit>
    }
    sleep(0);
    365a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3661:	e8 00 09 00 00       	call   3f66 <sleep>
    sleep(0);
    3666:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    366d:	e8 f4 08 00 00       	call   3f66 <sleep>
    kill(pid);
    3672:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3675:	89 04 24             	mov    %eax,(%esp)
    3678:	e8 89 08 00 00       	call   3f06 <kill>
    wait();
    367d:	e8 5c 08 00 00       	call   3ede <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3682:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3685:	89 44 24 04          	mov    %eax,0x4(%esp)
    3689:	c7 04 24 c6 59 00 00 	movl   $0x59c6,(%esp)
    3690:	e8 a1 08 00 00       	call   3f36 <link>
    3695:	83 f8 ff             	cmp    $0xffffffff,%eax
    3698:	74 1a                	je     36b4 <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    369a:	a1 e4 62 00 00       	mov    0x62e4,%eax
    369f:	c7 44 24 04 d1 59 00 	movl   $0x59d1,0x4(%esp)
    36a6:	00 
    36a7:	89 04 24             	mov    %eax,(%esp)
    36aa:	e8 ac 09 00 00       	call   405b <printf>
      exit();
    36af:	e8 22 08 00 00       	call   3ed6 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    36b4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    36c1:	0f 83 75 ff ff ff    	jae    363c <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    36c7:	a1 e4 62 00 00       	mov    0x62e4,%eax
    36cc:	c7 44 24 04 ea 59 00 	movl   $0x59ea,0x4(%esp)
    36d3:	00 
    36d4:	89 04 24             	mov    %eax,(%esp)
    36d7:	e8 7f 09 00 00       	call   405b <printf>
}
    36dc:	c9                   	leave  
    36dd:	c3                   	ret    

000036de <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36de:	55                   	push   %ebp
    36df:	89 e5                	mov    %esp,%ebp
    36e1:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    36e4:	a1 e4 62 00 00       	mov    0x62e4,%eax
    36e9:	c7 44 24 04 f7 59 00 	movl   $0x59f7,0x4(%esp)
    36f0:	00 
    36f1:	89 04 24             	mov    %eax,(%esp)
    36f4:	e8 62 09 00 00       	call   405b <printf>
  for(i = 0; i < sizeof(uninit); i++){
    36f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3700:	eb 2d                	jmp    372f <bsstest+0x51>
    if(uninit[i] != '\0'){
    3702:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3705:	05 a0 63 00 00       	add    $0x63a0,%eax
    370a:	0f b6 00             	movzbl (%eax),%eax
    370d:	84 c0                	test   %al,%al
    370f:	74 1a                	je     372b <bsstest+0x4d>
      printf(stdout, "bss test failed\n");
    3711:	a1 e4 62 00 00       	mov    0x62e4,%eax
    3716:	c7 44 24 04 01 5a 00 	movl   $0x5a01,0x4(%esp)
    371d:	00 
    371e:	89 04 24             	mov    %eax,(%esp)
    3721:	e8 35 09 00 00       	call   405b <printf>
      exit();
    3726:	e8 ab 07 00 00       	call   3ed6 <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    372b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    372f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3732:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3737:	76 c9                	jbe    3702 <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    3739:	a1 e4 62 00 00       	mov    0x62e4,%eax
    373e:	c7 44 24 04 12 5a 00 	movl   $0x5a12,0x4(%esp)
    3745:	00 
    3746:	89 04 24             	mov    %eax,(%esp)
    3749:	e8 0d 09 00 00       	call   405b <printf>
}
    374e:	c9                   	leave  
    374f:	c3                   	ret    

00003750 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3750:	55                   	push   %ebp
    3751:	89 e5                	mov    %esp,%ebp
    3753:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3756:	c7 04 24 1f 5a 00 00 	movl   $0x5a1f,(%esp)
    375d:	e8 c4 07 00 00       	call   3f26 <unlink>
  pid = fork();
    3762:	e8 67 07 00 00       	call   3ece <fork>
    3767:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    376a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    376e:	0f 85 90 00 00 00    	jne    3804 <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3774:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    377b:	eb 12                	jmp    378f <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3780:	c7 04 85 00 63 00 00 	movl   $0x5a2c,0x6300(,%eax,4)
    3787:	2c 5a 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    378b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    378f:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    3793:	7e e8                	jle    377d <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    3795:	c7 05 7c 63 00 00 00 	movl   $0x0,0x637c
    379c:	00 00 00 
    printf(stdout, "bigarg test\n");
    379f:	a1 e4 62 00 00       	mov    0x62e4,%eax
    37a4:	c7 44 24 04 09 5b 00 	movl   $0x5b09,0x4(%esp)
    37ab:	00 
    37ac:	89 04 24             	mov    %eax,(%esp)
    37af:	e8 a7 08 00 00       	call   405b <printf>
    exec("echo", args);
    37b4:	c7 44 24 04 00 63 00 	movl   $0x6300,0x4(%esp)
    37bb:	00 
    37bc:	c7 04 24 28 44 00 00 	movl   $0x4428,(%esp)
    37c3:	e8 46 07 00 00       	call   3f0e <exec>
    printf(stdout, "bigarg test ok\n");
    37c8:	a1 e4 62 00 00       	mov    0x62e4,%eax
    37cd:	c7 44 24 04 16 5b 00 	movl   $0x5b16,0x4(%esp)
    37d4:	00 
    37d5:	89 04 24             	mov    %eax,(%esp)
    37d8:	e8 7e 08 00 00       	call   405b <printf>
    fd = open("bigarg-ok", O_CREATE);
    37dd:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    37e4:	00 
    37e5:	c7 04 24 1f 5a 00 00 	movl   $0x5a1f,(%esp)
    37ec:	e8 25 07 00 00       	call   3f16 <open>
    37f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    37f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    37f7:	89 04 24             	mov    %eax,(%esp)
    37fa:	e8 ff 06 00 00       	call   3efe <close>
    exit();
    37ff:	e8 d2 06 00 00       	call   3ed6 <exit>
  } else if(pid < 0){
    3804:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3808:	79 1a                	jns    3824 <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    380a:	a1 e4 62 00 00       	mov    0x62e4,%eax
    380f:	c7 44 24 04 26 5b 00 	movl   $0x5b26,0x4(%esp)
    3816:	00 
    3817:	89 04 24             	mov    %eax,(%esp)
    381a:	e8 3c 08 00 00       	call   405b <printf>
    exit();
    381f:	e8 b2 06 00 00       	call   3ed6 <exit>
  }
  wait();
    3824:	e8 b5 06 00 00       	call   3ede <wait>
  fd = open("bigarg-ok", 0);
    3829:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3830:	00 
    3831:	c7 04 24 1f 5a 00 00 	movl   $0x5a1f,(%esp)
    3838:	e8 d9 06 00 00       	call   3f16 <open>
    383d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3840:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3844:	79 1a                	jns    3860 <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    3846:	a1 e4 62 00 00       	mov    0x62e4,%eax
    384b:	c7 44 24 04 3f 5b 00 	movl   $0x5b3f,0x4(%esp)
    3852:	00 
    3853:	89 04 24             	mov    %eax,(%esp)
    3856:	e8 00 08 00 00       	call   405b <printf>
    exit();
    385b:	e8 76 06 00 00       	call   3ed6 <exit>
  }
  close(fd);
    3860:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3863:	89 04 24             	mov    %eax,(%esp)
    3866:	e8 93 06 00 00       	call   3efe <close>
  unlink("bigarg-ok");
    386b:	c7 04 24 1f 5a 00 00 	movl   $0x5a1f,(%esp)
    3872:	e8 af 06 00 00       	call   3f26 <unlink>
}
    3877:	c9                   	leave  
    3878:	c3                   	ret    

00003879 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3879:	55                   	push   %ebp
    387a:	89 e5                	mov    %esp,%ebp
    387c:	53                   	push   %ebx
    387d:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    3880:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    3887:	c7 44 24 04 54 5b 00 	movl   $0x5b54,0x4(%esp)
    388e:	00 
    388f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3896:	e8 c0 07 00 00       	call   405b <printf>

  for(nfiles = 0; ; nfiles++){
    389b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    38a2:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    38a6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38a9:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38ae:	89 c8                	mov    %ecx,%eax
    38b0:	f7 ea                	imul   %edx
    38b2:	c1 fa 06             	sar    $0x6,%edx
    38b5:	89 c8                	mov    %ecx,%eax
    38b7:	c1 f8 1f             	sar    $0x1f,%eax
    38ba:	89 d1                	mov    %edx,%ecx
    38bc:	29 c1                	sub    %eax,%ecx
    38be:	89 c8                	mov    %ecx,%eax
    38c0:	83 c0 30             	add    $0x30,%eax
    38c3:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38c9:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38ce:	89 d8                	mov    %ebx,%eax
    38d0:	f7 ea                	imul   %edx
    38d2:	c1 fa 06             	sar    $0x6,%edx
    38d5:	89 d8                	mov    %ebx,%eax
    38d7:	c1 f8 1f             	sar    $0x1f,%eax
    38da:	89 d1                	mov    %edx,%ecx
    38dc:	29 c1                	sub    %eax,%ecx
    38de:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    38e4:	89 d9                	mov    %ebx,%ecx
    38e6:	29 c1                	sub    %eax,%ecx
    38e8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    38ed:	89 c8                	mov    %ecx,%eax
    38ef:	f7 ea                	imul   %edx
    38f1:	c1 fa 05             	sar    $0x5,%edx
    38f4:	89 c8                	mov    %ecx,%eax
    38f6:	c1 f8 1f             	sar    $0x1f,%eax
    38f9:	89 d1                	mov    %edx,%ecx
    38fb:	29 c1                	sub    %eax,%ecx
    38fd:	89 c8                	mov    %ecx,%eax
    38ff:	83 c0 30             	add    $0x30,%eax
    3902:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3905:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3908:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    390d:	89 d8                	mov    %ebx,%eax
    390f:	f7 ea                	imul   %edx
    3911:	c1 fa 05             	sar    $0x5,%edx
    3914:	89 d8                	mov    %ebx,%eax
    3916:	c1 f8 1f             	sar    $0x1f,%eax
    3919:	89 d1                	mov    %edx,%ecx
    391b:	29 c1                	sub    %eax,%ecx
    391d:	6b c1 64             	imul   $0x64,%ecx,%eax
    3920:	89 d9                	mov    %ebx,%ecx
    3922:	29 c1                	sub    %eax,%ecx
    3924:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3929:	89 c8                	mov    %ecx,%eax
    392b:	f7 ea                	imul   %edx
    392d:	c1 fa 02             	sar    $0x2,%edx
    3930:	89 c8                	mov    %ecx,%eax
    3932:	c1 f8 1f             	sar    $0x1f,%eax
    3935:	89 d1                	mov    %edx,%ecx
    3937:	29 c1                	sub    %eax,%ecx
    3939:	89 c8                	mov    %ecx,%eax
    393b:	83 c0 30             	add    $0x30,%eax
    393e:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3941:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3944:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3949:	89 c8                	mov    %ecx,%eax
    394b:	f7 ea                	imul   %edx
    394d:	c1 fa 02             	sar    $0x2,%edx
    3950:	89 c8                	mov    %ecx,%eax
    3952:	c1 f8 1f             	sar    $0x1f,%eax
    3955:	29 c2                	sub    %eax,%edx
    3957:	89 d0                	mov    %edx,%eax
    3959:	c1 e0 02             	shl    $0x2,%eax
    395c:	01 d0                	add    %edx,%eax
    395e:	01 c0                	add    %eax,%eax
    3960:	89 ca                	mov    %ecx,%edx
    3962:	29 c2                	sub    %eax,%edx
    3964:	89 d0                	mov    %edx,%eax
    3966:	83 c0 30             	add    $0x30,%eax
    3969:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    396c:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3970:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3973:	89 44 24 08          	mov    %eax,0x8(%esp)
    3977:	c7 44 24 04 61 5b 00 	movl   $0x5b61,0x4(%esp)
    397e:	00 
    397f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3986:	e8 d0 06 00 00       	call   405b <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    398b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3992:	00 
    3993:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3996:	89 04 24             	mov    %eax,(%esp)
    3999:	e8 78 05 00 00       	call   3f16 <open>
    399e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    39a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    39a5:	79 20                	jns    39c7 <fsfull+0x14e>
      printf(1, "open %s failed\n", name);
    39a7:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39aa:	89 44 24 08          	mov    %eax,0x8(%esp)
    39ae:	c7 44 24 04 6d 5b 00 	movl   $0x5b6d,0x4(%esp)
    39b5:	00 
    39b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39bd:	e8 99 06 00 00       	call   405b <printf>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    39c2:	e9 51 01 00 00       	jmp    3b18 <fsfull+0x29f>
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf(1, "open %s failed\n", name);
      break;
    }
    int total = 0;
    39c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39ce:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    39d5:	00 
    39d6:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    39dd:	00 
    39de:	8b 45 e8             	mov    -0x18(%ebp),%eax
    39e1:	89 04 24             	mov    %eax,(%esp)
    39e4:	e8 0d 05 00 00       	call   3ef6 <write>
    39e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    39ec:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    39f3:	7e 0c                	jle    3a01 <fsfull+0x188>
        break;
      total += cc;
    39f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    39f8:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    39fb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    39ff:	eb cd                	jmp    39ce <fsfull+0x155>
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
    3a01:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    3a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3a05:	89 44 24 08          	mov    %eax,0x8(%esp)
    3a09:	c7 44 24 04 7d 5b 00 	movl   $0x5b7d,0x4(%esp)
    3a10:	00 
    3a11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a18:	e8 3e 06 00 00       	call   405b <printf>
    close(fd);
    3a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3a20:	89 04 24             	mov    %eax,(%esp)
    3a23:	e8 d6 04 00 00       	call   3efe <close>
    if(total == 0)
    3a28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3a2c:	0f 84 e6 00 00 00    	je     3b18 <fsfull+0x29f>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3a32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3a36:	e9 67 fe ff ff       	jmp    38a2 <fsfull+0x29>

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    3a3b:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a3f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a42:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a47:	89 c8                	mov    %ecx,%eax
    3a49:	f7 ea                	imul   %edx
    3a4b:	c1 fa 06             	sar    $0x6,%edx
    3a4e:	89 c8                	mov    %ecx,%eax
    3a50:	c1 f8 1f             	sar    $0x1f,%eax
    3a53:	89 d1                	mov    %edx,%ecx
    3a55:	29 c1                	sub    %eax,%ecx
    3a57:	89 c8                	mov    %ecx,%eax
    3a59:	83 c0 30             	add    $0x30,%eax
    3a5c:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a62:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a67:	89 d8                	mov    %ebx,%eax
    3a69:	f7 ea                	imul   %edx
    3a6b:	c1 fa 06             	sar    $0x6,%edx
    3a6e:	89 d8                	mov    %ebx,%eax
    3a70:	c1 f8 1f             	sar    $0x1f,%eax
    3a73:	89 d1                	mov    %edx,%ecx
    3a75:	29 c1                	sub    %eax,%ecx
    3a77:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a7d:	89 d9                	mov    %ebx,%ecx
    3a7f:	29 c1                	sub    %eax,%ecx
    3a81:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a86:	89 c8                	mov    %ecx,%eax
    3a88:	f7 ea                	imul   %edx
    3a8a:	c1 fa 05             	sar    $0x5,%edx
    3a8d:	89 c8                	mov    %ecx,%eax
    3a8f:	c1 f8 1f             	sar    $0x1f,%eax
    3a92:	89 d1                	mov    %edx,%ecx
    3a94:	29 c1                	sub    %eax,%ecx
    3a96:	89 c8                	mov    %ecx,%eax
    3a98:	83 c0 30             	add    $0x30,%eax
    3a9b:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a9e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3aa1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3aa6:	89 d8                	mov    %ebx,%eax
    3aa8:	f7 ea                	imul   %edx
    3aaa:	c1 fa 05             	sar    $0x5,%edx
    3aad:	89 d8                	mov    %ebx,%eax
    3aaf:	c1 f8 1f             	sar    $0x1f,%eax
    3ab2:	89 d1                	mov    %edx,%ecx
    3ab4:	29 c1                	sub    %eax,%ecx
    3ab6:	6b c1 64             	imul   $0x64,%ecx,%eax
    3ab9:	89 d9                	mov    %ebx,%ecx
    3abb:	29 c1                	sub    %eax,%ecx
    3abd:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ac2:	89 c8                	mov    %ecx,%eax
    3ac4:	f7 ea                	imul   %edx
    3ac6:	c1 fa 02             	sar    $0x2,%edx
    3ac9:	89 c8                	mov    %ecx,%eax
    3acb:	c1 f8 1f             	sar    $0x1f,%eax
    3ace:	89 d1                	mov    %edx,%ecx
    3ad0:	29 c1                	sub    %eax,%ecx
    3ad2:	89 c8                	mov    %ecx,%eax
    3ad4:	83 c0 30             	add    $0x30,%eax
    3ad7:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3ada:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3add:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ae2:	89 c8                	mov    %ecx,%eax
    3ae4:	f7 ea                	imul   %edx
    3ae6:	c1 fa 02             	sar    $0x2,%edx
    3ae9:	89 c8                	mov    %ecx,%eax
    3aeb:	c1 f8 1f             	sar    $0x1f,%eax
    3aee:	29 c2                	sub    %eax,%edx
    3af0:	89 d0                	mov    %edx,%eax
    3af2:	c1 e0 02             	shl    $0x2,%eax
    3af5:	01 d0                	add    %edx,%eax
    3af7:	01 c0                	add    %eax,%eax
    3af9:	89 ca                	mov    %ecx,%edx
    3afb:	29 c2                	sub    %eax,%edx
    3afd:	89 d0                	mov    %edx,%eax
    3aff:	83 c0 30             	add    $0x30,%eax
    3b02:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3b05:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3b09:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3b0c:	89 04 24             	mov    %eax,(%esp)
    3b0f:	e8 12 04 00 00       	call   3f26 <unlink>
    nfiles--;
    3b14:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b1c:	0f 89 19 ff ff ff    	jns    3a3b <fsfull+0x1c2>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3b22:	c7 44 24 04 8d 5b 00 	movl   $0x5b8d,0x4(%esp)
    3b29:	00 
    3b2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b31:	e8 25 05 00 00       	call   405b <printf>
}
    3b36:	83 c4 74             	add    $0x74,%esp
    3b39:	5b                   	pop    %ebx
    3b3a:	5d                   	pop    %ebp
    3b3b:	c3                   	ret    

00003b3c <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3b3c:	55                   	push   %ebp
    3b3d:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3b3f:	a1 e8 62 00 00       	mov    0x62e8,%eax
    3b44:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3b4a:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b4f:	a3 e8 62 00 00       	mov    %eax,0x62e8
  return randstate;
    3b54:	a1 e8 62 00 00       	mov    0x62e8,%eax
}
    3b59:	5d                   	pop    %ebp
    3b5a:	c3                   	ret    

00003b5b <main>:

int
main(int argc, char *argv[])
{
    3b5b:	55                   	push   %ebp
    3b5c:	89 e5                	mov    %esp,%ebp
    3b5e:	83 e4 f0             	and    $0xfffffff0,%esp
    3b61:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    3b64:	c7 44 24 04 a3 5b 00 	movl   $0x5ba3,0x4(%esp)
    3b6b:	00 
    3b6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b73:	e8 e3 04 00 00       	call   405b <printf>

  if(open("usertests.ran", 0) >= 0){
    3b78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b7f:	00 
    3b80:	c7 04 24 b7 5b 00 00 	movl   $0x5bb7,(%esp)
    3b87:	e8 8a 03 00 00       	call   3f16 <open>
    3b8c:	85 c0                	test   %eax,%eax
    3b8e:	78 19                	js     3ba9 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3b90:	c7 44 24 04 c8 5b 00 	movl   $0x5bc8,0x4(%esp)
    3b97:	00 
    3b98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b9f:	e8 b7 04 00 00       	call   405b <printf>
    exit();
    3ba4:	e8 2d 03 00 00       	call   3ed6 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3ba9:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3bb0:	00 
    3bb1:	c7 04 24 b7 5b 00 00 	movl   $0x5bb7,(%esp)
    3bb8:	e8 59 03 00 00       	call   3f16 <open>
    3bbd:	89 04 24             	mov    %eax,(%esp)
    3bc0:	e8 39 03 00 00       	call   3efe <close>

  createdelete();
    3bc5:	e8 b7 d6 ff ff       	call   1281 <createdelete>
  linkunlink();
    3bca:	e8 01 e1 ff ff       	call   1cd0 <linkunlink>
  concreate();
    3bcf:	e8 43 dd ff ff       	call   1917 <concreate>
  fourfiles();
    3bd4:	e8 40 d4 ff ff       	call   1019 <fourfiles>
  sharedfd();
    3bd9:	e8 3d d2 ff ff       	call   e1b <sharedfd>

  bigargtest();
    3bde:	e8 6d fb ff ff       	call   3750 <bigargtest>
  bigwrite();
    3be3:	e8 d1 ea ff ff       	call   26b9 <bigwrite>
  bigargtest();
    3be8:	e8 63 fb ff ff       	call   3750 <bigargtest>
  bsstest();
    3bed:	e8 ec fa ff ff       	call   36de <bsstest>
  sbrktest();
    3bf2:	e8 f6 f4 ff ff       	call   30ed <sbrktest>
  validatetest();
    3bf7:	e8 15 fa ff ff       	call   3611 <validatetest>

  opentest();
    3bfc:	e8 c6 c6 ff ff       	call   2c7 <opentest>
  writetest();
    3c01:	e8 6c c7 ff ff       	call   372 <writetest>
  writetest1();
    3c06:	e8 7c c9 ff ff       	call   587 <writetest1>
  createtest();
    3c0b:	e8 80 cb ff ff       	call   790 <createtest>

  openiputtest();
    3c10:	e8 b1 c5 ff ff       	call   1c6 <openiputtest>
  exitiputtest();
    3c15:	e8 c0 c4 ff ff       	call   da <exitiputtest>
  iputtest();
    3c1a:	e8 e1 c3 ff ff       	call   0 <iputtest>

  mem();
    3c1f:	e8 12 d1 ff ff       	call   d36 <mem>
  pipe1();
    3c24:	e8 48 cd ff ff       	call   971 <pipe1>
  preempt();
    3c29:	e8 31 cf ff ff       	call   b5f <preempt>
  exitwait();
    3c2e:	e8 85 d0 ff ff       	call   cb8 <exitwait>

  rmdot();
    3c33:	e8 04 ef ff ff       	call   2b3c <rmdot>
  fourteen();
    3c38:	e8 a9 ed ff ff       	call   29e6 <fourteen>
  bigfile();
    3c3d:	e8 7f eb ff ff       	call   27c1 <bigfile>
  subdir();
    3c42:	e8 2c e3 ff ff       	call   1f73 <subdir>
  linktest();
    3c47:	e8 82 da ff ff       	call   16ce <linktest>
  unlinkread();
    3c4c:	e8 a8 d8 ff ff       	call   14f9 <unlinkread>
  dirfile();
    3c51:	e8 5e f0 ff ff       	call   2cb4 <dirfile>
  iref();
    3c56:	e8 9b f2 ff ff       	call   2ef6 <iref>
  forktest();
    3c5b:	e8 ba f3 ff ff       	call   301a <forktest>
  bigdir(); // slow
    3c60:	e8 99 e1 ff ff       	call   1dfe <bigdir>
  exectest();
    3c65:	e8 b8 cc ff ff       	call   922 <exectest>

  exit();
    3c6a:	e8 67 02 00 00       	call   3ed6 <exit>

00003c6f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c6f:	55                   	push   %ebp
    3c70:	89 e5                	mov    %esp,%ebp
    3c72:	57                   	push   %edi
    3c73:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c74:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c77:	8b 55 10             	mov    0x10(%ebp),%edx
    3c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c7d:	89 cb                	mov    %ecx,%ebx
    3c7f:	89 df                	mov    %ebx,%edi
    3c81:	89 d1                	mov    %edx,%ecx
    3c83:	fc                   	cld    
    3c84:	f3 aa                	rep stos %al,%es:(%edi)
    3c86:	89 ca                	mov    %ecx,%edx
    3c88:	89 fb                	mov    %edi,%ebx
    3c8a:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3c8d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3c90:	5b                   	pop    %ebx
    3c91:	5f                   	pop    %edi
    3c92:	5d                   	pop    %ebp
    3c93:	c3                   	ret    

00003c94 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3c94:	55                   	push   %ebp
    3c95:	89 e5                	mov    %esp,%ebp
    3c97:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3c9a:	8b 45 08             	mov    0x8(%ebp),%eax
    3c9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3ca0:	90                   	nop
    3ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ca4:	0f b6 10             	movzbl (%eax),%edx
    3ca7:	8b 45 08             	mov    0x8(%ebp),%eax
    3caa:	88 10                	mov    %dl,(%eax)
    3cac:	8b 45 08             	mov    0x8(%ebp),%eax
    3caf:	0f b6 00             	movzbl (%eax),%eax
    3cb2:	84 c0                	test   %al,%al
    3cb4:	0f 95 c0             	setne  %al
    3cb7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3cbb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    3cbf:	84 c0                	test   %al,%al
    3cc1:	75 de                	jne    3ca1 <strcpy+0xd>
    ;
  return os;
    3cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3cc6:	c9                   	leave  
    3cc7:	c3                   	ret    

00003cc8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3cc8:	55                   	push   %ebp
    3cc9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3ccb:	eb 08                	jmp    3cd5 <strcmp+0xd>
    p++, q++;
    3ccd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3cd1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3cd5:	8b 45 08             	mov    0x8(%ebp),%eax
    3cd8:	0f b6 00             	movzbl (%eax),%eax
    3cdb:	84 c0                	test   %al,%al
    3cdd:	74 10                	je     3cef <strcmp+0x27>
    3cdf:	8b 45 08             	mov    0x8(%ebp),%eax
    3ce2:	0f b6 10             	movzbl (%eax),%edx
    3ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ce8:	0f b6 00             	movzbl (%eax),%eax
    3ceb:	38 c2                	cmp    %al,%dl
    3ced:	74 de                	je     3ccd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3cef:	8b 45 08             	mov    0x8(%ebp),%eax
    3cf2:	0f b6 00             	movzbl (%eax),%eax
    3cf5:	0f b6 d0             	movzbl %al,%edx
    3cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cfb:	0f b6 00             	movzbl (%eax),%eax
    3cfe:	0f b6 c0             	movzbl %al,%eax
    3d01:	89 d1                	mov    %edx,%ecx
    3d03:	29 c1                	sub    %eax,%ecx
    3d05:	89 c8                	mov    %ecx,%eax
}
    3d07:	5d                   	pop    %ebp
    3d08:	c3                   	ret    

00003d09 <strlen>:

uint
strlen(char *s)
{
    3d09:	55                   	push   %ebp
    3d0a:	89 e5                	mov    %esp,%ebp
    3d0c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3d0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3d16:	eb 04                	jmp    3d1c <strlen+0x13>
    3d18:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3d1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3d1f:	8b 45 08             	mov    0x8(%ebp),%eax
    3d22:	01 d0                	add    %edx,%eax
    3d24:	0f b6 00             	movzbl (%eax),%eax
    3d27:	84 c0                	test   %al,%al
    3d29:	75 ed                	jne    3d18 <strlen+0xf>
    ;
  return n;
    3d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d2e:	c9                   	leave  
    3d2f:	c3                   	ret    

00003d30 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d30:	55                   	push   %ebp
    3d31:	89 e5                	mov    %esp,%ebp
    3d33:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3d36:	8b 45 10             	mov    0x10(%ebp),%eax
    3d39:	89 44 24 08          	mov    %eax,0x8(%esp)
    3d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d40:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d44:	8b 45 08             	mov    0x8(%ebp),%eax
    3d47:	89 04 24             	mov    %eax,(%esp)
    3d4a:	e8 20 ff ff ff       	call   3c6f <stosb>
  return dst;
    3d4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d52:	c9                   	leave  
    3d53:	c3                   	ret    

00003d54 <strchr>:

char*
strchr(const char *s, char c)
{
    3d54:	55                   	push   %ebp
    3d55:	89 e5                	mov    %esp,%ebp
    3d57:	83 ec 04             	sub    $0x4,%esp
    3d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d5d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d60:	eb 14                	jmp    3d76 <strchr+0x22>
    if(*s == c)
    3d62:	8b 45 08             	mov    0x8(%ebp),%eax
    3d65:	0f b6 00             	movzbl (%eax),%eax
    3d68:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3d6b:	75 05                	jne    3d72 <strchr+0x1e>
      return (char*)s;
    3d6d:	8b 45 08             	mov    0x8(%ebp),%eax
    3d70:	eb 13                	jmp    3d85 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3d72:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3d76:	8b 45 08             	mov    0x8(%ebp),%eax
    3d79:	0f b6 00             	movzbl (%eax),%eax
    3d7c:	84 c0                	test   %al,%al
    3d7e:	75 e2                	jne    3d62 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3d85:	c9                   	leave  
    3d86:	c3                   	ret    

00003d87 <gets>:

char*
gets(char *buf, int max)
{
    3d87:	55                   	push   %ebp
    3d88:	89 e5                	mov    %esp,%ebp
    3d8a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3d8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3d94:	eb 46                	jmp    3ddc <gets+0x55>
    cc = read(0, &c, 1);
    3d96:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3d9d:	00 
    3d9e:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3da1:	89 44 24 04          	mov    %eax,0x4(%esp)
    3da5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3dac:	e8 3d 01 00 00       	call   3eee <read>
    3db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3db4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3db8:	7e 2f                	jle    3de9 <gets+0x62>
      break;
    buf[i++] = c;
    3dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3dbd:	8b 45 08             	mov    0x8(%ebp),%eax
    3dc0:	01 c2                	add    %eax,%edx
    3dc2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dc6:	88 02                	mov    %al,(%edx)
    3dc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
    3dcc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dd0:	3c 0a                	cmp    $0xa,%al
    3dd2:	74 16                	je     3dea <gets+0x63>
    3dd4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dd8:	3c 0d                	cmp    $0xd,%al
    3dda:	74 0e                	je     3dea <gets+0x63>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ddf:	83 c0 01             	add    $0x1,%eax
    3de2:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3de5:	7c af                	jl     3d96 <gets+0xf>
    3de7:	eb 01                	jmp    3dea <gets+0x63>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    3de9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3ded:	8b 45 08             	mov    0x8(%ebp),%eax
    3df0:	01 d0                	add    %edx,%eax
    3df2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3df5:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3df8:	c9                   	leave  
    3df9:	c3                   	ret    

00003dfa <stat>:

int
stat(char *n, struct stat *st)
{
    3dfa:	55                   	push   %ebp
    3dfb:	89 e5                	mov    %esp,%ebp
    3dfd:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3e00:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3e07:	00 
    3e08:	8b 45 08             	mov    0x8(%ebp),%eax
    3e0b:	89 04 24             	mov    %eax,(%esp)
    3e0e:	e8 03 01 00 00       	call   3f16 <open>
    3e13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3e1a:	79 07                	jns    3e23 <stat+0x29>
    return -1;
    3e1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3e21:	eb 23                	jmp    3e46 <stat+0x4c>
  r = fstat(fd, st);
    3e23:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e26:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e2d:	89 04 24             	mov    %eax,(%esp)
    3e30:	e8 f9 00 00 00       	call   3f2e <fstat>
    3e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e3b:	89 04 24             	mov    %eax,(%esp)
    3e3e:	e8 bb 00 00 00       	call   3efe <close>
  return r;
    3e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3e46:	c9                   	leave  
    3e47:	c3                   	ret    

00003e48 <atoi>:

int
atoi(const char *s)
{
    3e48:	55                   	push   %ebp
    3e49:	89 e5                	mov    %esp,%ebp
    3e4b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e55:	eb 23                	jmp    3e7a <atoi+0x32>
    n = n*10 + *s++ - '0';
    3e57:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e5a:	89 d0                	mov    %edx,%eax
    3e5c:	c1 e0 02             	shl    $0x2,%eax
    3e5f:	01 d0                	add    %edx,%eax
    3e61:	01 c0                	add    %eax,%eax
    3e63:	89 c2                	mov    %eax,%edx
    3e65:	8b 45 08             	mov    0x8(%ebp),%eax
    3e68:	0f b6 00             	movzbl (%eax),%eax
    3e6b:	0f be c0             	movsbl %al,%eax
    3e6e:	01 d0                	add    %edx,%eax
    3e70:	83 e8 30             	sub    $0x30,%eax
    3e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3e76:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3e7a:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7d:	0f b6 00             	movzbl (%eax),%eax
    3e80:	3c 2f                	cmp    $0x2f,%al
    3e82:	7e 0a                	jle    3e8e <atoi+0x46>
    3e84:	8b 45 08             	mov    0x8(%ebp),%eax
    3e87:	0f b6 00             	movzbl (%eax),%eax
    3e8a:	3c 39                	cmp    $0x39,%al
    3e8c:	7e c9                	jle    3e57 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e91:	c9                   	leave  
    3e92:	c3                   	ret    

00003e93 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3e93:	55                   	push   %ebp
    3e94:	89 e5                	mov    %esp,%ebp
    3e96:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3e99:	8b 45 08             	mov    0x8(%ebp),%eax
    3e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ea2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3ea5:	eb 13                	jmp    3eba <memmove+0x27>
    *dst++ = *src++;
    3ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3eaa:	0f b6 10             	movzbl (%eax),%edx
    3ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3eb0:	88 10                	mov    %dl,(%eax)
    3eb2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3eb6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3ebe:	0f 9f c0             	setg   %al
    3ec1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    3ec5:	84 c0                	test   %al,%al
    3ec7:	75 de                	jne    3ea7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3ec9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3ecc:	c9                   	leave  
    3ecd:	c3                   	ret    

00003ece <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3ece:	b8 01 00 00 00       	mov    $0x1,%eax
    3ed3:	cd 40                	int    $0x40
    3ed5:	c3                   	ret    

00003ed6 <exit>:
SYSCALL(exit)
    3ed6:	b8 02 00 00 00       	mov    $0x2,%eax
    3edb:	cd 40                	int    $0x40
    3edd:	c3                   	ret    

00003ede <wait>:
SYSCALL(wait)
    3ede:	b8 03 00 00 00       	mov    $0x3,%eax
    3ee3:	cd 40                	int    $0x40
    3ee5:	c3                   	ret    

00003ee6 <pipe>:
SYSCALL(pipe)
    3ee6:	b8 04 00 00 00       	mov    $0x4,%eax
    3eeb:	cd 40                	int    $0x40
    3eed:	c3                   	ret    

00003eee <read>:
SYSCALL(read)
    3eee:	b8 05 00 00 00       	mov    $0x5,%eax
    3ef3:	cd 40                	int    $0x40
    3ef5:	c3                   	ret    

00003ef6 <write>:
SYSCALL(write)
    3ef6:	b8 10 00 00 00       	mov    $0x10,%eax
    3efb:	cd 40                	int    $0x40
    3efd:	c3                   	ret    

00003efe <close>:
SYSCALL(close)
    3efe:	b8 15 00 00 00       	mov    $0x15,%eax
    3f03:	cd 40                	int    $0x40
    3f05:	c3                   	ret    

00003f06 <kill>:
SYSCALL(kill)
    3f06:	b8 06 00 00 00       	mov    $0x6,%eax
    3f0b:	cd 40                	int    $0x40
    3f0d:	c3                   	ret    

00003f0e <exec>:
SYSCALL(exec)
    3f0e:	b8 07 00 00 00       	mov    $0x7,%eax
    3f13:	cd 40                	int    $0x40
    3f15:	c3                   	ret    

00003f16 <open>:
SYSCALL(open)
    3f16:	b8 0f 00 00 00       	mov    $0xf,%eax
    3f1b:	cd 40                	int    $0x40
    3f1d:	c3                   	ret    

00003f1e <mknod>:
SYSCALL(mknod)
    3f1e:	b8 11 00 00 00       	mov    $0x11,%eax
    3f23:	cd 40                	int    $0x40
    3f25:	c3                   	ret    

00003f26 <unlink>:
SYSCALL(unlink)
    3f26:	b8 12 00 00 00       	mov    $0x12,%eax
    3f2b:	cd 40                	int    $0x40
    3f2d:	c3                   	ret    

00003f2e <fstat>:
SYSCALL(fstat)
    3f2e:	b8 08 00 00 00       	mov    $0x8,%eax
    3f33:	cd 40                	int    $0x40
    3f35:	c3                   	ret    

00003f36 <link>:
SYSCALL(link)
    3f36:	b8 13 00 00 00       	mov    $0x13,%eax
    3f3b:	cd 40                	int    $0x40
    3f3d:	c3                   	ret    

00003f3e <mkdir>:
SYSCALL(mkdir)
    3f3e:	b8 14 00 00 00       	mov    $0x14,%eax
    3f43:	cd 40                	int    $0x40
    3f45:	c3                   	ret    

00003f46 <chdir>:
SYSCALL(chdir)
    3f46:	b8 09 00 00 00       	mov    $0x9,%eax
    3f4b:	cd 40                	int    $0x40
    3f4d:	c3                   	ret    

00003f4e <dup>:
SYSCALL(dup)
    3f4e:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f53:	cd 40                	int    $0x40
    3f55:	c3                   	ret    

00003f56 <getpid>:
SYSCALL(getpid)
    3f56:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f5b:	cd 40                	int    $0x40
    3f5d:	c3                   	ret    

00003f5e <sbrk>:
SYSCALL(sbrk)
    3f5e:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f63:	cd 40                	int    $0x40
    3f65:	c3                   	ret    

00003f66 <sleep>:
SYSCALL(sleep)
    3f66:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f6b:	cd 40                	int    $0x40
    3f6d:	c3                   	ret    

00003f6e <uptime>:
SYSCALL(uptime)
    3f6e:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f73:	cd 40                	int    $0x40
    3f75:	c3                   	ret    

00003f76 <getprocs>:
SYSCALL(getprocs)
    3f76:	b8 16 00 00 00       	mov    $0x16,%eax
    3f7b:	cd 40                	int    $0x40
    3f7d:	c3                   	ret    

00003f7e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f7e:	55                   	push   %ebp
    3f7f:	89 e5                	mov    %esp,%ebp
    3f81:	83 ec 28             	sub    $0x28,%esp
    3f84:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f87:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3f8a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3f91:	00 
    3f92:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3f95:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f99:	8b 45 08             	mov    0x8(%ebp),%eax
    3f9c:	89 04 24             	mov    %eax,(%esp)
    3f9f:	e8 52 ff ff ff       	call   3ef6 <write>
}
    3fa4:	c9                   	leave  
    3fa5:	c3                   	ret    

00003fa6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3fa6:	55                   	push   %ebp
    3fa7:	89 e5                	mov    %esp,%ebp
    3fa9:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3fac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3fb3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3fb7:	74 17                	je     3fd0 <printint+0x2a>
    3fb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3fbd:	79 11                	jns    3fd0 <printint+0x2a>
    neg = 1;
    3fbf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fc9:	f7 d8                	neg    %eax
    3fcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fce:	eb 06                	jmp    3fd6 <printint+0x30>
  } else {
    x = xx;
    3fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3fd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3fdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fe3:	ba 00 00 00 00       	mov    $0x0,%edx
    3fe8:	f7 f1                	div    %ecx
    3fea:	89 d0                	mov    %edx,%eax
    3fec:	0f b6 80 ec 62 00 00 	movzbl 0x62ec(%eax),%eax
    3ff3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    3ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3ff9:	01 ca                	add    %ecx,%edx
    3ffb:	88 02                	mov    %al,(%edx)
    3ffd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
    4001:	8b 55 10             	mov    0x10(%ebp),%edx
    4004:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    4007:	8b 45 ec             	mov    -0x14(%ebp),%eax
    400a:	ba 00 00 00 00       	mov    $0x0,%edx
    400f:	f7 75 d4             	divl   -0x2c(%ebp)
    4012:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4015:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4019:	75 c2                	jne    3fdd <printint+0x37>
  if(neg)
    401b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    401f:	74 2e                	je     404f <printint+0xa9>
    buf[i++] = '-';
    4021:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4024:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4027:	01 d0                	add    %edx,%eax
    4029:	c6 00 2d             	movb   $0x2d,(%eax)
    402c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
    4030:	eb 1d                	jmp    404f <printint+0xa9>
    putc(fd, buf[i]);
    4032:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4035:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4038:	01 d0                	add    %edx,%eax
    403a:	0f b6 00             	movzbl (%eax),%eax
    403d:	0f be c0             	movsbl %al,%eax
    4040:	89 44 24 04          	mov    %eax,0x4(%esp)
    4044:	8b 45 08             	mov    0x8(%ebp),%eax
    4047:	89 04 24             	mov    %eax,(%esp)
    404a:	e8 2f ff ff ff       	call   3f7e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    404f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    4053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4057:	79 d9                	jns    4032 <printint+0x8c>
    putc(fd, buf[i]);
}
    4059:	c9                   	leave  
    405a:	c3                   	ret    

0000405b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    405b:	55                   	push   %ebp
    405c:	89 e5                	mov    %esp,%ebp
    405e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    4061:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4068:	8d 45 0c             	lea    0xc(%ebp),%eax
    406b:	83 c0 04             	add    $0x4,%eax
    406e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    4071:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4078:	e9 7d 01 00 00       	jmp    41fa <printf+0x19f>
    c = fmt[i] & 0xff;
    407d:	8b 55 0c             	mov    0xc(%ebp),%edx
    4080:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4083:	01 d0                	add    %edx,%eax
    4085:	0f b6 00             	movzbl (%eax),%eax
    4088:	0f be c0             	movsbl %al,%eax
    408b:	25 ff 00 00 00       	and    $0xff,%eax
    4090:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    4093:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4097:	75 2c                	jne    40c5 <printf+0x6a>
      if(c == '%'){
    4099:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    409d:	75 0c                	jne    40ab <printf+0x50>
        state = '%';
    409f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    40a6:	e9 4b 01 00 00       	jmp    41f6 <printf+0x19b>
      } else {
        putc(fd, c);
    40ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    40ae:	0f be c0             	movsbl %al,%eax
    40b1:	89 44 24 04          	mov    %eax,0x4(%esp)
    40b5:	8b 45 08             	mov    0x8(%ebp),%eax
    40b8:	89 04 24             	mov    %eax,(%esp)
    40bb:	e8 be fe ff ff       	call   3f7e <putc>
    40c0:	e9 31 01 00 00       	jmp    41f6 <printf+0x19b>
      }
    } else if(state == '%'){
    40c5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    40c9:	0f 85 27 01 00 00    	jne    41f6 <printf+0x19b>
      if(c == 'd'){
    40cf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    40d3:	75 2d                	jne    4102 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    40d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40d8:	8b 00                	mov    (%eax),%eax
    40da:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    40e1:	00 
    40e2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    40e9:	00 
    40ea:	89 44 24 04          	mov    %eax,0x4(%esp)
    40ee:	8b 45 08             	mov    0x8(%ebp),%eax
    40f1:	89 04 24             	mov    %eax,(%esp)
    40f4:	e8 ad fe ff ff       	call   3fa6 <printint>
        ap++;
    40f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    40fd:	e9 ed 00 00 00       	jmp    41ef <printf+0x194>
      } else if(c == 'x' || c == 'p'){
    4102:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4106:	74 06                	je     410e <printf+0xb3>
    4108:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    410c:	75 2d                	jne    413b <printf+0xe0>
        printint(fd, *ap, 16, 0);
    410e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4111:	8b 00                	mov    (%eax),%eax
    4113:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    411a:	00 
    411b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    4122:	00 
    4123:	89 44 24 04          	mov    %eax,0x4(%esp)
    4127:	8b 45 08             	mov    0x8(%ebp),%eax
    412a:	89 04 24             	mov    %eax,(%esp)
    412d:	e8 74 fe ff ff       	call   3fa6 <printint>
        ap++;
    4132:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4136:	e9 b4 00 00 00       	jmp    41ef <printf+0x194>
      } else if(c == 's'){
    413b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    413f:	75 46                	jne    4187 <printf+0x12c>
        s = (char*)*ap;
    4141:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4144:	8b 00                	mov    (%eax),%eax
    4146:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4149:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    414d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4151:	75 27                	jne    417a <printf+0x11f>
          s = "(null)";
    4153:	c7 45 f4 f2 5b 00 00 	movl   $0x5bf2,-0xc(%ebp)
        while(*s != 0){
    415a:	eb 1e                	jmp    417a <printf+0x11f>
          putc(fd, *s);
    415c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    415f:	0f b6 00             	movzbl (%eax),%eax
    4162:	0f be c0             	movsbl %al,%eax
    4165:	89 44 24 04          	mov    %eax,0x4(%esp)
    4169:	8b 45 08             	mov    0x8(%ebp),%eax
    416c:	89 04 24             	mov    %eax,(%esp)
    416f:	e8 0a fe ff ff       	call   3f7e <putc>
          s++;
    4174:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    4178:	eb 01                	jmp    417b <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    417a:	90                   	nop
    417b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    417e:	0f b6 00             	movzbl (%eax),%eax
    4181:	84 c0                	test   %al,%al
    4183:	75 d7                	jne    415c <printf+0x101>
    4185:	eb 68                	jmp    41ef <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4187:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    418b:	75 1d                	jne    41aa <printf+0x14f>
        putc(fd, *ap);
    418d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4190:	8b 00                	mov    (%eax),%eax
    4192:	0f be c0             	movsbl %al,%eax
    4195:	89 44 24 04          	mov    %eax,0x4(%esp)
    4199:	8b 45 08             	mov    0x8(%ebp),%eax
    419c:	89 04 24             	mov    %eax,(%esp)
    419f:	e8 da fd ff ff       	call   3f7e <putc>
        ap++;
    41a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    41a8:	eb 45                	jmp    41ef <printf+0x194>
      } else if(c == '%'){
    41aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    41ae:	75 17                	jne    41c7 <printf+0x16c>
        putc(fd, c);
    41b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41b3:	0f be c0             	movsbl %al,%eax
    41b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    41ba:	8b 45 08             	mov    0x8(%ebp),%eax
    41bd:	89 04 24             	mov    %eax,(%esp)
    41c0:	e8 b9 fd ff ff       	call   3f7e <putc>
    41c5:	eb 28                	jmp    41ef <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    41c7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    41ce:	00 
    41cf:	8b 45 08             	mov    0x8(%ebp),%eax
    41d2:	89 04 24             	mov    %eax,(%esp)
    41d5:	e8 a4 fd ff ff       	call   3f7e <putc>
        putc(fd, c);
    41da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41dd:	0f be c0             	movsbl %al,%eax
    41e0:	89 44 24 04          	mov    %eax,0x4(%esp)
    41e4:	8b 45 08             	mov    0x8(%ebp),%eax
    41e7:	89 04 24             	mov    %eax,(%esp)
    41ea:	e8 8f fd ff ff       	call   3f7e <putc>
      }
      state = 0;
    41ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    41f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    41fa:	8b 55 0c             	mov    0xc(%ebp),%edx
    41fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4200:	01 d0                	add    %edx,%eax
    4202:	0f b6 00             	movzbl (%eax),%eax
    4205:	84 c0                	test   %al,%al
    4207:	0f 85 70 fe ff ff    	jne    407d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    420d:	c9                   	leave  
    420e:	c3                   	ret    

0000420f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    420f:	55                   	push   %ebp
    4210:	89 e5                	mov    %esp,%ebp
    4212:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4215:	8b 45 08             	mov    0x8(%ebp),%eax
    4218:	83 e8 08             	sub    $0x8,%eax
    421b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    421e:	a1 88 63 00 00       	mov    0x6388,%eax
    4223:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4226:	eb 24                	jmp    424c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4228:	8b 45 fc             	mov    -0x4(%ebp),%eax
    422b:	8b 00                	mov    (%eax),%eax
    422d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4230:	77 12                	ja     4244 <free+0x35>
    4232:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4235:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4238:	77 24                	ja     425e <free+0x4f>
    423a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    423d:	8b 00                	mov    (%eax),%eax
    423f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4242:	77 1a                	ja     425e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4244:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4247:	8b 00                	mov    (%eax),%eax
    4249:	89 45 fc             	mov    %eax,-0x4(%ebp)
    424c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    424f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4252:	76 d4                	jbe    4228 <free+0x19>
    4254:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4257:	8b 00                	mov    (%eax),%eax
    4259:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    425c:	76 ca                	jbe    4228 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    425e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4261:	8b 40 04             	mov    0x4(%eax),%eax
    4264:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    426b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    426e:	01 c2                	add    %eax,%edx
    4270:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4273:	8b 00                	mov    (%eax),%eax
    4275:	39 c2                	cmp    %eax,%edx
    4277:	75 24                	jne    429d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4279:	8b 45 f8             	mov    -0x8(%ebp),%eax
    427c:	8b 50 04             	mov    0x4(%eax),%edx
    427f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4282:	8b 00                	mov    (%eax),%eax
    4284:	8b 40 04             	mov    0x4(%eax),%eax
    4287:	01 c2                	add    %eax,%edx
    4289:	8b 45 f8             	mov    -0x8(%ebp),%eax
    428c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    428f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4292:	8b 00                	mov    (%eax),%eax
    4294:	8b 10                	mov    (%eax),%edx
    4296:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4299:	89 10                	mov    %edx,(%eax)
    429b:	eb 0a                	jmp    42a7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    429d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42a0:	8b 10                	mov    (%eax),%edx
    42a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    42a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42aa:	8b 40 04             	mov    0x4(%eax),%eax
    42ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    42b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42b7:	01 d0                	add    %edx,%eax
    42b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    42bc:	75 20                	jne    42de <free+0xcf>
    p->s.size += bp->s.size;
    42be:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42c1:	8b 50 04             	mov    0x4(%eax),%edx
    42c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42c7:	8b 40 04             	mov    0x4(%eax),%eax
    42ca:	01 c2                	add    %eax,%edx
    42cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    42d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42d5:	8b 10                	mov    (%eax),%edx
    42d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42da:	89 10                	mov    %edx,(%eax)
    42dc:	eb 08                	jmp    42e6 <free+0xd7>
  } else
    p->s.ptr = bp;
    42de:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
    42e4:	89 10                	mov    %edx,(%eax)
  freep = p;
    42e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42e9:	a3 88 63 00 00       	mov    %eax,0x6388
}
    42ee:	c9                   	leave  
    42ef:	c3                   	ret    

000042f0 <morecore>:

static Header*
morecore(uint nu)
{
    42f0:	55                   	push   %ebp
    42f1:	89 e5                	mov    %esp,%ebp
    42f3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    42f6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    42fd:	77 07                	ja     4306 <morecore+0x16>
    nu = 4096;
    42ff:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    4306:	8b 45 08             	mov    0x8(%ebp),%eax
    4309:	c1 e0 03             	shl    $0x3,%eax
    430c:	89 04 24             	mov    %eax,(%esp)
    430f:	e8 4a fc ff ff       	call   3f5e <sbrk>
    4314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4317:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    431b:	75 07                	jne    4324 <morecore+0x34>
    return 0;
    431d:	b8 00 00 00 00       	mov    $0x0,%eax
    4322:	eb 22                	jmp    4346 <morecore+0x56>
  hp = (Header*)p;
    4324:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4327:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    432a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    432d:	8b 55 08             	mov    0x8(%ebp),%edx
    4330:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4333:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4336:	83 c0 08             	add    $0x8,%eax
    4339:	89 04 24             	mov    %eax,(%esp)
    433c:	e8 ce fe ff ff       	call   420f <free>
  return freep;
    4341:	a1 88 63 00 00       	mov    0x6388,%eax
}
    4346:	c9                   	leave  
    4347:	c3                   	ret    

00004348 <malloc>:

void*
malloc(uint nbytes)
{
    4348:	55                   	push   %ebp
    4349:	89 e5                	mov    %esp,%ebp
    434b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    434e:	8b 45 08             	mov    0x8(%ebp),%eax
    4351:	83 c0 07             	add    $0x7,%eax
    4354:	c1 e8 03             	shr    $0x3,%eax
    4357:	83 c0 01             	add    $0x1,%eax
    435a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    435d:	a1 88 63 00 00       	mov    0x6388,%eax
    4362:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4365:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4369:	75 23                	jne    438e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    436b:	c7 45 f0 80 63 00 00 	movl   $0x6380,-0x10(%ebp)
    4372:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4375:	a3 88 63 00 00       	mov    %eax,0x6388
    437a:	a1 88 63 00 00       	mov    0x6388,%eax
    437f:	a3 80 63 00 00       	mov    %eax,0x6380
    base.s.size = 0;
    4384:	c7 05 84 63 00 00 00 	movl   $0x0,0x6384
    438b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    438e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4391:	8b 00                	mov    (%eax),%eax
    4393:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4396:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4399:	8b 40 04             	mov    0x4(%eax),%eax
    439c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    439f:	72 4d                	jb     43ee <malloc+0xa6>
      if(p->s.size == nunits)
    43a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a4:	8b 40 04             	mov    0x4(%eax),%eax
    43a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    43aa:	75 0c                	jne    43b8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    43ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43af:	8b 10                	mov    (%eax),%edx
    43b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43b4:	89 10                	mov    %edx,(%eax)
    43b6:	eb 26                	jmp    43de <malloc+0x96>
      else {
        p->s.size -= nunits;
    43b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43bb:	8b 40 04             	mov    0x4(%eax),%eax
    43be:	89 c2                	mov    %eax,%edx
    43c0:	2b 55 ec             	sub    -0x14(%ebp),%edx
    43c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43c6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    43c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43cc:	8b 40 04             	mov    0x4(%eax),%eax
    43cf:	c1 e0 03             	shl    $0x3,%eax
    43d2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    43d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
    43db:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    43de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43e1:	a3 88 63 00 00       	mov    %eax,0x6388
      return (void*)(p + 1);
    43e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43e9:	83 c0 08             	add    $0x8,%eax
    43ec:	eb 38                	jmp    4426 <malloc+0xde>
    }
    if(p == freep)
    43ee:	a1 88 63 00 00       	mov    0x6388,%eax
    43f3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    43f6:	75 1b                	jne    4413 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    43f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    43fb:	89 04 24             	mov    %eax,(%esp)
    43fe:	e8 ed fe ff ff       	call   42f0 <morecore>
    4403:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    440a:	75 07                	jne    4413 <malloc+0xcb>
        return 0;
    440c:	b8 00 00 00 00       	mov    $0x0,%eax
    4411:	eb 13                	jmp    4426 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4413:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4416:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4419:	8b 45 f4             	mov    -0xc(%ebp),%eax
    441c:	8b 00                	mov    (%eax),%eax
    441e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    4421:	e9 70 ff ff ff       	jmp    4396 <malloc+0x4e>
}
    4426:	c9                   	leave  
    4427:	c3                   	ret    
