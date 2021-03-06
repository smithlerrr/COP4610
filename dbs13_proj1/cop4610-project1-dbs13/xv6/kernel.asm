
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 d6 10 80       	mov    $0x8010d650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 9a 37 10 80       	mov    $0x8010379a,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 0c 8a 10 	movl   $0x80108a0c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 d6 10 80 	movl   $0x8010d660,(%esp)
80100049:	e8 80 52 00 00       	call   801052ce <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 70 15 11 80 64 	movl   $0x80111564,0x80111570
80100055:	15 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 74 15 11 80 64 	movl   $0x80111564,0x80111574
8010005f:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 d6 10 80 	movl   $0x8010d694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 74 15 11 80    	mov    0x80111574,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 64 15 11 80 	movl   $0x80111564,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 74 15 11 80       	mov    0x80111574,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 74 15 11 80       	mov    %eax,0x80111574

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 64 15 11 80 	cmpl   $0x80111564,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 d6 10 80 	movl   $0x8010d660,(%esp)
801000bd:	e8 2d 52 00 00       	call   801052ef <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 74 15 11 80       	mov    0x80111574,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 d6 10 80 	movl   $0x8010d660,(%esp)
80100104:	e8 48 52 00 00       	call   80105351 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 d6 10 	movl   $0x8010d660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 ef 4e 00 00       	call   80105013 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 64 15 11 80 	cmpl   $0x80111564,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 70 15 11 80       	mov    0x80111570,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 d6 10 80 	movl   $0x8010d660,(%esp)
8010017c:	e8 d0 51 00 00       	call   80105351 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 64 15 11 80 	cmpl   $0x80111564,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 13 8a 10 80 	movl   $0x80108a13,(%esp)
8010019f:	e8 a2 03 00 00       	call   80100546 <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 2d 26 00 00       	call   80102805 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 24 8a 10 80 	movl   $0x80108a24,(%esp)
801001f6:	e8 4b 03 00 00       	call   80100546 <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 f0 25 00 00       	call   80102805 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 2b 8a 10 80 	movl   $0x80108a2b,(%esp)
80100230:	e8 11 03 00 00       	call   80100546 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 d6 10 80 	movl   $0x8010d660,(%esp)
8010023c:	e8 ae 50 00 00       	call   801052ef <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 74 15 11 80    	mov    0x80111574,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 64 15 11 80 	movl   $0x80111564,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 74 15 11 80       	mov    0x80111574,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 74 15 11 80       	mov    %eax,0x80111574

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 4a 4e 00 00       	call   801050ec <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 d6 10 80 	movl   $0x8010d660,(%esp)
801002a9:	e8 a3 50 00 00       	call   80105351 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801002c2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801002ca:	ec                   	in     (%dx),%al
801002cb:	89 c3                	mov    %eax,%ebx
801002cd:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002d0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801002d4:	83 c4 14             	add    $0x14,%esp
801002d7:	5b                   	pop    %ebx
801002d8:	5d                   	pop    %ebp
801002d9:	c3                   	ret    

801002da <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002da:	55                   	push   %ebp
801002db:	89 e5                	mov    %esp,%ebp
801002dd:	83 ec 08             	sub    $0x8,%esp
801002e0:	8b 55 08             	mov    0x8(%ebp),%edx
801002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801002e6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002ea:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002f1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002f5:	ee                   	out    %al,(%dx)
}
801002f6:	c9                   	leave  
801002f7:	c3                   	ret    

801002f8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f8:	55                   	push   %ebp
801002f9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002fb:	fa                   	cli    
}
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    

801002fe <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fe:	55                   	push   %ebp
801002ff:	89 e5                	mov    %esp,%ebp
80100301:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100308:	74 1c                	je     80100326 <printint+0x28>
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	c1 e8 1f             	shr    $0x1f,%eax
80100310:	0f b6 c0             	movzbl %al,%eax
80100313:	89 45 10             	mov    %eax,0x10(%ebp)
80100316:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031a:	74 0a                	je     80100326 <printint+0x28>
    x = -xx;
8010031c:	8b 45 08             	mov    0x8(%ebp),%eax
8010031f:	f7 d8                	neg    %eax
80100321:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100324:	eb 06                	jmp    8010032c <printint+0x2e>
  else
    x = xx;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010032c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100336:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100339:	ba 00 00 00 00       	mov    $0x0,%edx
8010033e:	f7 f1                	div    %ecx
80100340:	89 d0                	mov    %edx,%eax
80100342:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
80100349:	8d 4d e0             	lea    -0x20(%ebp),%ecx
8010034c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010034f:	01 ca                	add    %ecx,%edx
80100351:	88 02                	mov    %al,(%edx)
80100353:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
80100357:	8b 55 0c             	mov    0xc(%ebp),%edx
8010035a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010035d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100360:	ba 00 00 00 00       	mov    $0x0,%edx
80100365:	f7 75 d4             	divl   -0x2c(%ebp)
80100368:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010036f:	75 c2                	jne    80100333 <printint+0x35>

  if(sign)
80100371:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100375:	74 27                	je     8010039e <printint+0xa0>
    buf[i++] = '-';
80100377:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037d:	01 d0                	add    %edx,%eax
8010037f:	c6 00 2d             	movb   $0x2d,(%eax)
80100382:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
80100386:	eb 16                	jmp    8010039e <printint+0xa0>
    consputc(buf[i]);
80100388:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010038b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038e:	01 d0                	add    %edx,%eax
80100390:	0f b6 00             	movzbl (%eax),%eax
80100393:	0f be c0             	movsbl %al,%eax
80100396:	89 04 24             	mov    %eax,(%esp)
80100399:	e8 bb 03 00 00       	call   80100759 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010039e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003a6:	79 e0                	jns    80100388 <printint+0x8a>
    consputc(buf[i]);
}
801003a8:	c9                   	leave  
801003a9:	c3                   	ret    

801003aa <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003aa:	55                   	push   %ebp
801003ab:	89 e5                	mov    %esp,%ebp
801003ad:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003b0:	a1 f4 c5 10 80       	mov    0x8010c5f4,%eax
801003b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003bc:	74 0c                	je     801003ca <cprintf+0x20>
    acquire(&cons.lock);
801003be:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
801003c5:	e8 25 4f 00 00       	call   801052ef <acquire>

  if (fmt == 0)
801003ca:	8b 45 08             	mov    0x8(%ebp),%eax
801003cd:	85 c0                	test   %eax,%eax
801003cf:	75 0c                	jne    801003dd <cprintf+0x33>
    panic("null fmt");
801003d1:	c7 04 24 32 8a 10 80 	movl   $0x80108a32,(%esp)
801003d8:	e8 69 01 00 00       	call   80100546 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003dd:	8d 45 0c             	lea    0xc(%ebp),%eax
801003e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003ea:	e9 20 01 00 00       	jmp    8010050f <cprintf+0x165>
    if(c != '%'){
801003ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003f3:	74 10                	je     80100405 <cprintf+0x5b>
      consputc(c);
801003f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003f8:	89 04 24             	mov    %eax,(%esp)
801003fb:	e8 59 03 00 00       	call   80100759 <consputc>
      continue;
80100400:	e9 06 01 00 00       	jmp    8010050b <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100405:	8b 55 08             	mov    0x8(%ebp),%edx
80100408:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010040c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010040f:	01 d0                	add    %edx,%eax
80100411:	0f b6 00             	movzbl (%eax),%eax
80100414:	0f be c0             	movsbl %al,%eax
80100417:	25 ff 00 00 00       	and    $0xff,%eax
8010041c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010041f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100423:	0f 84 08 01 00 00    	je     80100531 <cprintf+0x187>
      break;
    switch(c){
80100429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010042c:	83 f8 70             	cmp    $0x70,%eax
8010042f:	74 4d                	je     8010047e <cprintf+0xd4>
80100431:	83 f8 70             	cmp    $0x70,%eax
80100434:	7f 13                	jg     80100449 <cprintf+0x9f>
80100436:	83 f8 25             	cmp    $0x25,%eax
80100439:	0f 84 a6 00 00 00    	je     801004e5 <cprintf+0x13b>
8010043f:	83 f8 64             	cmp    $0x64,%eax
80100442:	74 14                	je     80100458 <cprintf+0xae>
80100444:	e9 aa 00 00 00       	jmp    801004f3 <cprintf+0x149>
80100449:	83 f8 73             	cmp    $0x73,%eax
8010044c:	74 53                	je     801004a1 <cprintf+0xf7>
8010044e:	83 f8 78             	cmp    $0x78,%eax
80100451:	74 2b                	je     8010047e <cprintf+0xd4>
80100453:	e9 9b 00 00 00       	jmp    801004f3 <cprintf+0x149>
    case 'd':
      printint(*argp++, 10, 1);
80100458:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010045b:	8b 00                	mov    (%eax),%eax
8010045d:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100461:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100468:	00 
80100469:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100470:	00 
80100471:	89 04 24             	mov    %eax,(%esp)
80100474:	e8 85 fe ff ff       	call   801002fe <printint>
      break;
80100479:	e9 8d 00 00 00       	jmp    8010050b <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010047e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100481:	8b 00                	mov    (%eax),%eax
80100483:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100487:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010048e:	00 
8010048f:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100496:	00 
80100497:	89 04 24             	mov    %eax,(%esp)
8010049a:	e8 5f fe ff ff       	call   801002fe <printint>
      break;
8010049f:	eb 6a                	jmp    8010050b <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a4:	8b 00                	mov    (%eax),%eax
801004a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ad:	0f 94 c0             	sete   %al
801004b0:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004b4:	84 c0                	test   %al,%al
801004b6:	74 20                	je     801004d8 <cprintf+0x12e>
        s = "(null)";
801004b8:	c7 45 ec 3b 8a 10 80 	movl   $0x80108a3b,-0x14(%ebp)
      for(; *s; s++)
801004bf:	eb 17                	jmp    801004d8 <cprintf+0x12e>
        consputc(*s);
801004c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004c4:	0f b6 00             	movzbl (%eax),%eax
801004c7:	0f be c0             	movsbl %al,%eax
801004ca:	89 04 24             	mov    %eax,(%esp)
801004cd:	e8 87 02 00 00       	call   80100759 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004d2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d6:	eb 01                	jmp    801004d9 <cprintf+0x12f>
801004d8:	90                   	nop
801004d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004dc:	0f b6 00             	movzbl (%eax),%eax
801004df:	84 c0                	test   %al,%al
801004e1:	75 de                	jne    801004c1 <cprintf+0x117>
        consputc(*s);
      break;
801004e3:	eb 26                	jmp    8010050b <cprintf+0x161>
    case '%':
      consputc('%');
801004e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ec:	e8 68 02 00 00       	call   80100759 <consputc>
      break;
801004f1:	eb 18                	jmp    8010050b <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004f3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004fa:	e8 5a 02 00 00       	call   80100759 <consputc>
      consputc(c);
801004ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100502:	89 04 24             	mov    %eax,(%esp)
80100505:	e8 4f 02 00 00       	call   80100759 <consputc>
      break;
8010050a:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010050b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010050f:	8b 55 08             	mov    0x8(%ebp),%edx
80100512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100515:	01 d0                	add    %edx,%eax
80100517:	0f b6 00             	movzbl (%eax),%eax
8010051a:	0f be c0             	movsbl %al,%eax
8010051d:	25 ff 00 00 00       	and    $0xff,%eax
80100522:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100525:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100529:	0f 85 c0 fe ff ff    	jne    801003ef <cprintf+0x45>
8010052f:	eb 01                	jmp    80100532 <cprintf+0x188>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100531:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100532:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100536:	74 0c                	je     80100544 <cprintf+0x19a>
    release(&cons.lock);
80100538:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010053f:	e8 0d 4e 00 00       	call   80105351 <release>
}
80100544:	c9                   	leave  
80100545:	c3                   	ret    

80100546 <panic>:

void
panic(char *s)
{
80100546:	55                   	push   %ebp
80100547:	89 e5                	mov    %esp,%ebp
80100549:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
8010054c:	e8 a7 fd ff ff       	call   801002f8 <cli>
  cons.locking = 0;
80100551:	c7 05 f4 c5 10 80 00 	movl   $0x0,0x8010c5f4
80100558:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010055b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100561:	0f b6 00             	movzbl (%eax),%eax
80100564:	0f b6 c0             	movzbl %al,%eax
80100567:	89 44 24 04          	mov    %eax,0x4(%esp)
8010056b:	c7 04 24 42 8a 10 80 	movl   $0x80108a42,(%esp)
80100572:	e8 33 fe ff ff       	call   801003aa <cprintf>
  cprintf(s);
80100577:	8b 45 08             	mov    0x8(%ebp),%eax
8010057a:	89 04 24             	mov    %eax,(%esp)
8010057d:	e8 28 fe ff ff       	call   801003aa <cprintf>
  cprintf("\n");
80100582:	c7 04 24 51 8a 10 80 	movl   $0x80108a51,(%esp)
80100589:	e8 1c fe ff ff       	call   801003aa <cprintf>
  getcallerpcs(&s, pcs);
8010058e:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100591:	89 44 24 04          	mov    %eax,0x4(%esp)
80100595:	8d 45 08             	lea    0x8(%ebp),%eax
80100598:	89 04 24             	mov    %eax,(%esp)
8010059b:	e8 00 4e 00 00       	call   801053a0 <getcallerpcs>
  for(i=0; i<10; i++)
801005a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005a7:	eb 1b                	jmp    801005c4 <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005ac:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801005b4:	c7 04 24 53 8a 10 80 	movl   $0x80108a53,(%esp)
801005bb:	e8 ea fd ff ff       	call   801003aa <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005c4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005c8:	7e df                	jle    801005a9 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005ca:	c7 05 a0 c5 10 80 01 	movl   $0x1,0x8010c5a0
801005d1:	00 00 00 
  for(;;)
    ;
801005d4:	eb fe                	jmp    801005d4 <panic+0x8e>

801005d6 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005d6:	55                   	push   %ebp
801005d7:	89 e5                	mov    %esp,%ebp
801005d9:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005dc:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005e3:	00 
801005e4:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005eb:	e8 ea fc ff ff       	call   801002da <outb>
  pos = inb(CRTPORT+1) << 8;
801005f0:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005f7:	e8 b4 fc ff ff       	call   801002b0 <inb>
801005fc:	0f b6 c0             	movzbl %al,%eax
801005ff:	c1 e0 08             	shl    $0x8,%eax
80100602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100605:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010060c:	00 
8010060d:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100614:	e8 c1 fc ff ff       	call   801002da <outb>
  pos |= inb(CRTPORT+1);
80100619:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100620:	e8 8b fc ff ff       	call   801002b0 <inb>
80100625:	0f b6 c0             	movzbl %al,%eax
80100628:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010062b:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010062f:	75 30                	jne    80100661 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100631:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100634:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100639:	89 c8                	mov    %ecx,%eax
8010063b:	f7 ea                	imul   %edx
8010063d:	c1 fa 05             	sar    $0x5,%edx
80100640:	89 c8                	mov    %ecx,%eax
80100642:	c1 f8 1f             	sar    $0x1f,%eax
80100645:	29 c2                	sub    %eax,%edx
80100647:	89 d0                	mov    %edx,%eax
80100649:	c1 e0 02             	shl    $0x2,%eax
8010064c:	01 d0                	add    %edx,%eax
8010064e:	c1 e0 04             	shl    $0x4,%eax
80100651:	89 ca                	mov    %ecx,%edx
80100653:	29 c2                	sub    %eax,%edx
80100655:	b8 50 00 00 00       	mov    $0x50,%eax
8010065a:	29 d0                	sub    %edx,%eax
8010065c:	01 45 f4             	add    %eax,-0xc(%ebp)
8010065f:	eb 32                	jmp    80100693 <cgaputc+0xbd>
  else if(c == BACKSPACE){
80100661:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100668:	75 0c                	jne    80100676 <cgaputc+0xa0>
    if(pos > 0) --pos;
8010066a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010066e:	7e 23                	jle    80100693 <cgaputc+0xbd>
80100670:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100674:	eb 1d                	jmp    80100693 <cgaputc+0xbd>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100676:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010067b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010067e:	01 d2                	add    %edx,%edx
80100680:	01 c2                	add    %eax,%edx
80100682:	8b 45 08             	mov    0x8(%ebp),%eax
80100685:	66 25 ff 00          	and    $0xff,%ax
80100689:	80 cc 07             	or     $0x7,%ah
8010068c:	66 89 02             	mov    %ax,(%edx)
8010068f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
80100693:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010069a:	7e 53                	jle    801006ef <cgaputc+0x119>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010069c:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006a7:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ac:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006b3:	00 
801006b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801006b8:	89 04 24             	mov    %eax,(%esp)
801006bb:	e8 5a 4f 00 00       	call   8010561a <memmove>
    pos -= 80;
801006c0:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006c4:	b8 80 07 00 00       	mov    $0x780,%eax
801006c9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006cc:	01 c0                	add    %eax,%eax
801006ce:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
801006d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006d7:	01 c9                	add    %ecx,%ecx
801006d9:	01 ca                	add    %ecx,%edx
801006db:	89 44 24 08          	mov    %eax,0x8(%esp)
801006df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006e6:	00 
801006e7:	89 14 24             	mov    %edx,(%esp)
801006ea:	e8 58 4e 00 00       	call   80105547 <memset>
  }
  
  outb(CRTPORT, 14);
801006ef:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006f6:	00 
801006f7:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006fe:	e8 d7 fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos>>8);
80100703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100706:	c1 f8 08             	sar    $0x8,%eax
80100709:	0f b6 c0             	movzbl %al,%eax
8010070c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100710:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100717:	e8 be fb ff ff       	call   801002da <outb>
  outb(CRTPORT, 15);
8010071c:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100723:	00 
80100724:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010072b:	e8 aa fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos);
80100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100733:	0f b6 c0             	movzbl %al,%eax
80100736:	89 44 24 04          	mov    %eax,0x4(%esp)
8010073a:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100741:	e8 94 fb ff ff       	call   801002da <outb>
  crt[pos] = ' ' | 0x0700;
80100746:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010074b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010074e:	01 d2                	add    %edx,%edx
80100750:	01 d0                	add    %edx,%eax
80100752:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100757:	c9                   	leave  
80100758:	c3                   	ret    

80100759 <consputc>:

void
consputc(int c)
{
80100759:	55                   	push   %ebp
8010075a:	89 e5                	mov    %esp,%ebp
8010075c:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010075f:	a1 a0 c5 10 80       	mov    0x8010c5a0,%eax
80100764:	85 c0                	test   %eax,%eax
80100766:	74 07                	je     8010076f <consputc+0x16>
    cli();
80100768:	e8 8b fb ff ff       	call   801002f8 <cli>
    for(;;)
      ;
8010076d:	eb fe                	jmp    8010076d <consputc+0x14>
  }

  if(c == BACKSPACE){
8010076f:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100776:	75 26                	jne    8010079e <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100778:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010077f:	e8 c6 68 00 00       	call   8010704a <uartputc>
80100784:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010078b:	e8 ba 68 00 00       	call   8010704a <uartputc>
80100790:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100797:	e8 ae 68 00 00       	call   8010704a <uartputc>
8010079c:	eb 0b                	jmp    801007a9 <consputc+0x50>
  } else
    uartputc(c);
8010079e:	8b 45 08             	mov    0x8(%ebp),%eax
801007a1:	89 04 24             	mov    %eax,(%esp)
801007a4:	e8 a1 68 00 00       	call   8010704a <uartputc>
  cgaputc(c);
801007a9:	8b 45 08             	mov    0x8(%ebp),%eax
801007ac:	89 04 24             	mov    %eax,(%esp)
801007af:	e8 22 fe ff ff       	call   801005d6 <cgaputc>
}
801007b4:	c9                   	leave  
801007b5:	c3                   	ret    

801007b6 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b6:	55                   	push   %ebp
801007b7:	89 e5                	mov    %esp,%ebp
801007b9:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007bc:	c7 04 24 80 17 11 80 	movl   $0x80111780,(%esp)
801007c3:	e8 27 4b 00 00       	call   801052ef <acquire>
  while((c = getc()) >= 0){
801007c8:	e9 41 01 00 00       	jmp    8010090e <consoleintr+0x158>
    switch(c){
801007cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007d0:	83 f8 10             	cmp    $0x10,%eax
801007d3:	74 1e                	je     801007f3 <consoleintr+0x3d>
801007d5:	83 f8 10             	cmp    $0x10,%eax
801007d8:	7f 0a                	jg     801007e4 <consoleintr+0x2e>
801007da:	83 f8 08             	cmp    $0x8,%eax
801007dd:	74 68                	je     80100847 <consoleintr+0x91>
801007df:	e9 94 00 00 00       	jmp    80100878 <consoleintr+0xc2>
801007e4:	83 f8 15             	cmp    $0x15,%eax
801007e7:	74 2f                	je     80100818 <consoleintr+0x62>
801007e9:	83 f8 7f             	cmp    $0x7f,%eax
801007ec:	74 59                	je     80100847 <consoleintr+0x91>
801007ee:	e9 85 00 00 00       	jmp    80100878 <consoleintr+0xc2>
    case C('P'):  // Process listing.
      procdump();
801007f3:	e8 97 49 00 00       	call   8010518f <procdump>
      break;
801007f8:	e9 11 01 00 00       	jmp    8010090e <consoleintr+0x158>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007fd:	a1 3c 18 11 80       	mov    0x8011183c,%eax
80100802:	83 e8 01             	sub    $0x1,%eax
80100805:	a3 3c 18 11 80       	mov    %eax,0x8011183c
        consputc(BACKSPACE);
8010080a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100811:	e8 43 ff ff ff       	call   80100759 <consputc>
80100816:	eb 01                	jmp    80100819 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100818:	90                   	nop
80100819:	8b 15 3c 18 11 80    	mov    0x8011183c,%edx
8010081f:	a1 38 18 11 80       	mov    0x80111838,%eax
80100824:	39 c2                	cmp    %eax,%edx
80100826:	0f 84 db 00 00 00    	je     80100907 <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010082c:	a1 3c 18 11 80       	mov    0x8011183c,%eax
80100831:	83 e8 01             	sub    $0x1,%eax
80100834:	83 e0 7f             	and    $0x7f,%eax
80100837:	0f b6 80 b4 17 11 80 	movzbl -0x7feee84c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010083e:	3c 0a                	cmp    $0xa,%al
80100840:	75 bb                	jne    801007fd <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100842:	e9 c0 00 00 00       	jmp    80100907 <consoleintr+0x151>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100847:	8b 15 3c 18 11 80    	mov    0x8011183c,%edx
8010084d:	a1 38 18 11 80       	mov    0x80111838,%eax
80100852:	39 c2                	cmp    %eax,%edx
80100854:	0f 84 b0 00 00 00    	je     8010090a <consoleintr+0x154>
        input.e--;
8010085a:	a1 3c 18 11 80       	mov    0x8011183c,%eax
8010085f:	83 e8 01             	sub    $0x1,%eax
80100862:	a3 3c 18 11 80       	mov    %eax,0x8011183c
        consputc(BACKSPACE);
80100867:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010086e:	e8 e6 fe ff ff       	call   80100759 <consputc>
      }
      break;
80100873:	e9 92 00 00 00       	jmp    8010090a <consoleintr+0x154>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010087c:	0f 84 8b 00 00 00    	je     8010090d <consoleintr+0x157>
80100882:	8b 15 3c 18 11 80    	mov    0x8011183c,%edx
80100888:	a1 34 18 11 80       	mov    0x80111834,%eax
8010088d:	89 d1                	mov    %edx,%ecx
8010088f:	29 c1                	sub    %eax,%ecx
80100891:	89 c8                	mov    %ecx,%eax
80100893:	83 f8 7f             	cmp    $0x7f,%eax
80100896:	77 75                	ja     8010090d <consoleintr+0x157>
        c = (c == '\r') ? '\n' : c;
80100898:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010089c:	74 05                	je     801008a3 <consoleintr+0xed>
8010089e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008a1:	eb 05                	jmp    801008a8 <consoleintr+0xf2>
801008a3:	b8 0a 00 00 00       	mov    $0xa,%eax
801008a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008ab:	a1 3c 18 11 80       	mov    0x8011183c,%eax
801008b0:	89 c1                	mov    %eax,%ecx
801008b2:	83 e1 7f             	and    $0x7f,%ecx
801008b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008b8:	88 91 b4 17 11 80    	mov    %dl,-0x7feee84c(%ecx)
801008be:	83 c0 01             	add    $0x1,%eax
801008c1:	a3 3c 18 11 80       	mov    %eax,0x8011183c
        consputc(c);
801008c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008c9:	89 04 24             	mov    %eax,(%esp)
801008cc:	e8 88 fe ff ff       	call   80100759 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008d1:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008d5:	74 18                	je     801008ef <consoleintr+0x139>
801008d7:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008db:	74 12                	je     801008ef <consoleintr+0x139>
801008dd:	a1 3c 18 11 80       	mov    0x8011183c,%eax
801008e2:	8b 15 34 18 11 80    	mov    0x80111834,%edx
801008e8:	83 ea 80             	sub    $0xffffff80,%edx
801008eb:	39 d0                	cmp    %edx,%eax
801008ed:	75 1e                	jne    8010090d <consoleintr+0x157>
          input.w = input.e;
801008ef:	a1 3c 18 11 80       	mov    0x8011183c,%eax
801008f4:	a3 38 18 11 80       	mov    %eax,0x80111838
          wakeup(&input.r);
801008f9:	c7 04 24 34 18 11 80 	movl   $0x80111834,(%esp)
80100900:	e8 e7 47 00 00       	call   801050ec <wakeup>
        }
      }
      break;
80100905:	eb 06                	jmp    8010090d <consoleintr+0x157>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100907:	90                   	nop
80100908:	eb 04                	jmp    8010090e <consoleintr+0x158>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010090a:	90                   	nop
8010090b:	eb 01                	jmp    8010090e <consoleintr+0x158>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
8010090d:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010090e:	8b 45 08             	mov    0x8(%ebp),%eax
80100911:	ff d0                	call   *%eax
80100913:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010091a:	0f 89 ad fe ff ff    	jns    801007cd <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100920:	c7 04 24 80 17 11 80 	movl   $0x80111780,(%esp)
80100927:	e8 25 4a 00 00       	call   80105351 <release>
}
8010092c:	c9                   	leave  
8010092d:	c3                   	ret    

8010092e <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010092e:	55                   	push   %ebp
8010092f:	89 e5                	mov    %esp,%ebp
80100931:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100934:	8b 45 08             	mov    0x8(%ebp),%eax
80100937:	89 04 24             	mov    %eax,(%esp)
8010093a:	e8 ab 10 00 00       	call   801019ea <iunlock>
  target = n;
8010093f:	8b 45 10             	mov    0x10(%ebp),%eax
80100942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100945:	c7 04 24 80 17 11 80 	movl   $0x80111780,(%esp)
8010094c:	e8 9e 49 00 00       	call   801052ef <acquire>
  while(n > 0){
80100951:	e9 a8 00 00 00       	jmp    801009fe <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
80100956:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010095c:	8b 40 24             	mov    0x24(%eax),%eax
8010095f:	85 c0                	test   %eax,%eax
80100961:	74 21                	je     80100984 <consoleread+0x56>
        release(&input.lock);
80100963:	c7 04 24 80 17 11 80 	movl   $0x80111780,(%esp)
8010096a:	e8 e2 49 00 00       	call   80105351 <release>
        ilock(ip);
8010096f:	8b 45 08             	mov    0x8(%ebp),%eax
80100972:	89 04 24             	mov    %eax,(%esp)
80100975:	e8 22 0f 00 00       	call   8010189c <ilock>
        return -1;
8010097a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010097f:	e9 a9 00 00 00       	jmp    80100a2d <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
80100984:	c7 44 24 04 80 17 11 	movl   $0x80111780,0x4(%esp)
8010098b:	80 
8010098c:	c7 04 24 34 18 11 80 	movl   $0x80111834,(%esp)
80100993:	e8 7b 46 00 00       	call   80105013 <sleep>
80100998:	eb 01                	jmp    8010099b <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010099a:	90                   	nop
8010099b:	8b 15 34 18 11 80    	mov    0x80111834,%edx
801009a1:	a1 38 18 11 80       	mov    0x80111838,%eax
801009a6:	39 c2                	cmp    %eax,%edx
801009a8:	74 ac                	je     80100956 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009aa:	a1 34 18 11 80       	mov    0x80111834,%eax
801009af:	89 c2                	mov    %eax,%edx
801009b1:	83 e2 7f             	and    $0x7f,%edx
801009b4:	0f b6 92 b4 17 11 80 	movzbl -0x7feee84c(%edx),%edx
801009bb:	0f be d2             	movsbl %dl,%edx
801009be:	89 55 f0             	mov    %edx,-0x10(%ebp)
801009c1:	83 c0 01             	add    $0x1,%eax
801009c4:	a3 34 18 11 80       	mov    %eax,0x80111834
    if(c == C('D')){  // EOF
801009c9:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009cd:	75 17                	jne    801009e6 <consoleread+0xb8>
      if(n < target){
801009cf:	8b 45 10             	mov    0x10(%ebp),%eax
801009d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009d5:	73 2f                	jae    80100a06 <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009d7:	a1 34 18 11 80       	mov    0x80111834,%eax
801009dc:	83 e8 01             	sub    $0x1,%eax
801009df:	a3 34 18 11 80       	mov    %eax,0x80111834
      }
      break;
801009e4:	eb 20                	jmp    80100a06 <consoleread+0xd8>
    }
    *dst++ = c;
801009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009e9:	89 c2                	mov    %eax,%edx
801009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801009ee:	88 10                	mov    %dl,(%eax)
801009f0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
801009f4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009f8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009fc:	74 0b                	je     80100a09 <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a02:	7f 96                	jg     8010099a <consoleread+0x6c>
80100a04:	eb 04                	jmp    80100a0a <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a06:	90                   	nop
80100a07:	eb 01                	jmp    80100a0a <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a09:	90                   	nop
  }
  release(&input.lock);
80100a0a:	c7 04 24 80 17 11 80 	movl   $0x80111780,(%esp)
80100a11:	e8 3b 49 00 00       	call   80105351 <release>
  ilock(ip);
80100a16:	8b 45 08             	mov    0x8(%ebp),%eax
80100a19:	89 04 24             	mov    %eax,(%esp)
80100a1c:	e8 7b 0e 00 00       	call   8010189c <ilock>

  return target - n;
80100a21:	8b 45 10             	mov    0x10(%ebp),%eax
80100a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a27:	89 d1                	mov    %edx,%ecx
80100a29:	29 c1                	sub    %eax,%ecx
80100a2b:	89 c8                	mov    %ecx,%eax
}
80100a2d:	c9                   	leave  
80100a2e:	c3                   	ret    

80100a2f <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a2f:	55                   	push   %ebp
80100a30:	89 e5                	mov    %esp,%ebp
80100a32:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a35:	8b 45 08             	mov    0x8(%ebp),%eax
80100a38:	89 04 24             	mov    %eax,(%esp)
80100a3b:	e8 aa 0f 00 00       	call   801019ea <iunlock>
  acquire(&cons.lock);
80100a40:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100a47:	e8 a3 48 00 00       	call   801052ef <acquire>
  for(i = 0; i < n; i++)
80100a4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a53:	eb 1f                	jmp    80100a74 <consolewrite+0x45>
    consputc(buf[i] & 0xff);
80100a55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a5b:	01 d0                	add    %edx,%eax
80100a5d:	0f b6 00             	movzbl (%eax),%eax
80100a60:	0f be c0             	movsbl %al,%eax
80100a63:	25 ff 00 00 00       	and    $0xff,%eax
80100a68:	89 04 24             	mov    %eax,(%esp)
80100a6b:	e8 e9 fc ff ff       	call   80100759 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a77:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a7a:	7c d9                	jl     80100a55 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a7c:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100a83:	e8 c9 48 00 00       	call   80105351 <release>
  ilock(ip);
80100a88:	8b 45 08             	mov    0x8(%ebp),%eax
80100a8b:	89 04 24             	mov    %eax,(%esp)
80100a8e:	e8 09 0e 00 00       	call   8010189c <ilock>

  return n;
80100a93:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a96:	c9                   	leave  
80100a97:	c3                   	ret    

80100a98 <consoleinit>:

void
consoleinit(void)
{
80100a98:	55                   	push   %ebp
80100a99:	89 e5                	mov    %esp,%ebp
80100a9b:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a9e:	c7 44 24 04 57 8a 10 	movl   $0x80108a57,0x4(%esp)
80100aa5:	80 
80100aa6:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
80100aad:	e8 1c 48 00 00       	call   801052ce <initlock>
  initlock(&input.lock, "input");
80100ab2:	c7 44 24 04 5f 8a 10 	movl   $0x80108a5f,0x4(%esp)
80100ab9:	80 
80100aba:	c7 04 24 80 17 11 80 	movl   $0x80111780,(%esp)
80100ac1:	e8 08 48 00 00       	call   801052ce <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ac6:	c7 05 ec 21 11 80 2f 	movl   $0x80100a2f,0x801121ec
80100acd:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ad0:	c7 05 e8 21 11 80 2e 	movl   $0x8010092e,0x801121e8
80100ad7:	09 10 80 
  cons.locking = 1;
80100ada:	c7 05 f4 c5 10 80 01 	movl   $0x1,0x8010c5f4
80100ae1:	00 00 00 

  picenable(IRQ_KBD);
80100ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aeb:	e8 56 33 00 00       	call   80103e46 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100af0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100af7:	00 
80100af8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aff:	e8 c0 1e 00 00       	call   801029c4 <ioapicenable>
}
80100b04:	c9                   	leave  
80100b05:	c3                   	ret    

80100b06 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b06:	55                   	push   %ebp
80100b07:	89 e5                	mov    %esp,%ebp
80100b09:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b0f:	e8 8e 29 00 00       	call   801034a2 <begin_op>
  if((ip = namei(path)) == 0){
80100b14:	8b 45 08             	mov    0x8(%ebp),%eax
80100b17:	89 04 24             	mov    %eax,(%esp)
80100b1a:	e8 3e 19 00 00       	call   8010245d <namei>
80100b1f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b22:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b26:	75 0f                	jne    80100b37 <exec+0x31>
    end_op();
80100b28:	e8 f6 29 00 00       	call   80103523 <end_op>
    return -1;
80100b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b32:	e9 f9 03 00 00       	jmp    80100f30 <exec+0x42a>
  }
  ilock(ip);
80100b37:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b3a:	89 04 24             	mov    %eax,(%esp)
80100b3d:	e8 5a 0d 00 00       	call   8010189c <ilock>
  pgdir = 0;
80100b42:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b49:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b50:	00 
80100b51:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b58:	00 
80100b59:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b63:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 3b 12 00 00       	call   80101da9 <readi>
80100b6e:	83 f8 33             	cmp    $0x33,%eax
80100b71:	0f 86 6e 03 00 00    	jbe    80100ee5 <exec+0x3df>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b77:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b7d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b82:	0f 85 60 03 00 00    	jne    80100ee8 <exec+0x3e2>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b88:	e8 0d 76 00 00       	call   8010819a <setupkvm>
80100b8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b90:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b94:	0f 84 51 03 00 00    	je     80100eeb <exec+0x3e5>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b9a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100ba8:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bae:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bb1:	e9 c5 00 00 00       	jmp    80100c7b <exec+0x175>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bb9:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bc0:	00 
80100bc1:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bc5:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bcf:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bd2:	89 04 24             	mov    %eax,(%esp)
80100bd5:	e8 cf 11 00 00       	call   80101da9 <readi>
80100bda:	83 f8 20             	cmp    $0x20,%eax
80100bdd:	0f 85 0b 03 00 00    	jne    80100eee <exec+0x3e8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100be3:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100be9:	83 f8 01             	cmp    $0x1,%eax
80100bec:	75 7f                	jne    80100c6d <exec+0x167>
      continue;
    if(ph.memsz < ph.filesz)
80100bee:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100bf4:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bfa:	39 c2                	cmp    %eax,%edx
80100bfc:	0f 82 ef 02 00 00    	jb     80100ef1 <exec+0x3eb>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c02:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c08:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c0e:	01 d0                	add    %edx,%eax
80100c10:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c14:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c1e:	89 04 24             	mov    %eax,(%esp)
80100c21:	e8 46 79 00 00       	call   8010856c <allocuvm>
80100c26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c29:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c2d:	0f 84 c1 02 00 00    	je     80100ef4 <exec+0x3ee>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c33:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c39:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c3f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c45:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c49:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c4d:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c50:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c54:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c5b:	89 04 24             	mov    %eax,(%esp)
80100c5e:	e8 1a 78 00 00       	call   8010847d <loaduvm>
80100c63:	85 c0                	test   %eax,%eax
80100c65:	0f 88 8c 02 00 00    	js     80100ef7 <exec+0x3f1>
80100c6b:	eb 01                	jmp    80100c6e <exec+0x168>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c6d:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c6e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c72:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c75:	83 c0 20             	add    $0x20,%eax
80100c78:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c7b:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c82:	0f b7 c0             	movzwl %ax,%eax
80100c85:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c88:	0f 8f 28 ff ff ff    	jg     80100bb6 <exec+0xb0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c91:	89 04 24             	mov    %eax,(%esp)
80100c94:	e8 87 0e 00 00       	call   80101b20 <iunlockput>
  end_op();
80100c99:	e8 85 28 00 00       	call   80103523 <end_op>
  ip = 0;
80100c9e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100ca5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ca8:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cb2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb8:	05 00 20 00 00       	add    $0x2000,%eax
80100cbd:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ccb:	89 04 24             	mov    %eax,(%esp)
80100cce:	e8 99 78 00 00       	call   8010856c <allocuvm>
80100cd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cd6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cda:	0f 84 1a 02 00 00    	je     80100efa <exec+0x3f4>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce3:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cef:	89 04 24             	mov    %eax,(%esp)
80100cf2:	e8 a5 7a 00 00       	call   8010879c <clearpteu>
  sp = sz;
80100cf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cfa:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cfd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d04:	e9 97 00 00 00       	jmp    80100da0 <exec+0x29a>
    if(argc >= MAXARG)
80100d09:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d0d:	0f 87 ea 01 00 00    	ja     80100efd <exec+0x3f7>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d20:	01 d0                	add    %edx,%eax
80100d22:	8b 00                	mov    (%eax),%eax
80100d24:	89 04 24             	mov    %eax,(%esp)
80100d27:	e8 99 4a 00 00       	call   801057c5 <strlen>
80100d2c:	f7 d0                	not    %eax
80100d2e:	89 c2                	mov    %eax,%edx
80100d30:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d33:	01 d0                	add    %edx,%eax
80100d35:	83 e0 fc             	and    $0xfffffffc,%eax
80100d38:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d45:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d48:	01 d0                	add    %edx,%eax
80100d4a:	8b 00                	mov    (%eax),%eax
80100d4c:	89 04 24             	mov    %eax,(%esp)
80100d4f:	e8 71 4a 00 00       	call   801057c5 <strlen>
80100d54:	83 c0 01             	add    $0x1,%eax
80100d57:	89 c2                	mov    %eax,%edx
80100d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d5c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d63:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d66:	01 c8                	add    %ecx,%eax
80100d68:	8b 00                	mov    (%eax),%eax
80100d6a:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d6e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d72:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d75:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d7c:	89 04 24             	mov    %eax,(%esp)
80100d7f:	e8 dd 7b 00 00       	call   80108961 <copyout>
80100d84:	85 c0                	test   %eax,%eax
80100d86:	0f 88 74 01 00 00    	js     80100f00 <exec+0x3fa>
      goto bad;
    ustack[3+argc] = sp;
80100d8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8f:	8d 50 03             	lea    0x3(%eax),%edx
80100d92:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d95:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d9c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100daa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dad:	01 d0                	add    %edx,%eax
80100daf:	8b 00                	mov    (%eax),%eax
80100db1:	85 c0                	test   %eax,%eax
80100db3:	0f 85 50 ff ff ff    	jne    80100d09 <exec+0x203>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dbc:	83 c0 03             	add    $0x3,%eax
80100dbf:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dc6:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dca:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dd1:	ff ff ff 
  ustack[1] = argc;
80100dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd7:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de0:	83 c0 01             	add    $0x1,%eax
80100de3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dea:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ded:	29 d0                	sub    %edx,%eax
80100def:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100df5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df8:	83 c0 04             	add    $0x4,%eax
80100dfb:	c1 e0 02             	shl    $0x2,%eax
80100dfe:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e04:	83 c0 04             	add    $0x4,%eax
80100e07:	c1 e0 02             	shl    $0x2,%eax
80100e0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e0e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e14:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e18:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e22:	89 04 24             	mov    %eax,(%esp)
80100e25:	e8 37 7b 00 00       	call   80108961 <copyout>
80100e2a:	85 c0                	test   %eax,%eax
80100e2c:	0f 88 d1 00 00 00    	js     80100f03 <exec+0x3fd>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e32:	8b 45 08             	mov    0x8(%ebp),%eax
80100e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e3e:	eb 17                	jmp    80100e57 <exec+0x351>
    if(*s == '/')
80100e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e43:	0f b6 00             	movzbl (%eax),%eax
80100e46:	3c 2f                	cmp    $0x2f,%al
80100e48:	75 09                	jne    80100e53 <exec+0x34d>
      last = s+1;
80100e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e4d:	83 c0 01             	add    $0x1,%eax
80100e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e53:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5a:	0f b6 00             	movzbl (%eax),%eax
80100e5d:	84 c0                	test   %al,%al
80100e5f:	75 df                	jne    80100e40 <exec+0x33a>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e67:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e6a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e71:	00 
80100e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e75:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e79:	89 14 24             	mov    %edx,(%esp)
80100e7c:	e8 f6 48 00 00       	call   80105777 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e87:	8b 40 04             	mov    0x4(%eax),%eax
80100e8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e93:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e96:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ea2:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ea4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eaa:	8b 40 18             	mov    0x18(%eax),%eax
80100ead:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eb3:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eb6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebc:	8b 40 18             	mov    0x18(%eax),%eax
80100ebf:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ec2:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ec5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ecb:	89 04 24             	mov    %eax,(%esp)
80100ece:	e8 b8 73 00 00       	call   8010828b <switchuvm>
  freevm(oldpgdir);
80100ed3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ed6:	89 04 24             	mov    %eax,(%esp)
80100ed9:	e8 24 78 00 00       	call   80108702 <freevm>
  return 0;
80100ede:	b8 00 00 00 00       	mov    $0x0,%eax
80100ee3:	eb 4b                	jmp    80100f30 <exec+0x42a>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100ee5:	90                   	nop
80100ee6:	eb 1c                	jmp    80100f04 <exec+0x3fe>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100ee8:	90                   	nop
80100ee9:	eb 19                	jmp    80100f04 <exec+0x3fe>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100eeb:	90                   	nop
80100eec:	eb 16                	jmp    80100f04 <exec+0x3fe>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100eee:	90                   	nop
80100eef:	eb 13                	jmp    80100f04 <exec+0x3fe>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ef1:	90                   	nop
80100ef2:	eb 10                	jmp    80100f04 <exec+0x3fe>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ef4:	90                   	nop
80100ef5:	eb 0d                	jmp    80100f04 <exec+0x3fe>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100ef7:	90                   	nop
80100ef8:	eb 0a                	jmp    80100f04 <exec+0x3fe>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100efa:	90                   	nop
80100efb:	eb 07                	jmp    80100f04 <exec+0x3fe>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100efd:	90                   	nop
80100efe:	eb 04                	jmp    80100f04 <exec+0x3fe>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f00:	90                   	nop
80100f01:	eb 01                	jmp    80100f04 <exec+0x3fe>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f03:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f04:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f08:	74 0b                	je     80100f15 <exec+0x40f>
    freevm(pgdir);
80100f0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f0d:	89 04 24             	mov    %eax,(%esp)
80100f10:	e8 ed 77 00 00       	call   80108702 <freevm>
  if(ip){
80100f15:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f19:	74 10                	je     80100f2b <exec+0x425>
    iunlockput(ip);
80100f1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f1e:	89 04 24             	mov    %eax,(%esp)
80100f21:	e8 fa 0b 00 00       	call   80101b20 <iunlockput>
    end_op();
80100f26:	e8 f8 25 00 00       	call   80103523 <end_op>
  }
  return -1;
80100f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f30:	c9                   	leave  
80100f31:	c3                   	ret    

80100f32 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f32:	55                   	push   %ebp
80100f33:	89 e5                	mov    %esp,%ebp
80100f35:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f38:	c7 44 24 04 65 8a 10 	movl   $0x80108a65,0x4(%esp)
80100f3f:	80 
80100f40:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f47:	e8 82 43 00 00       	call   801052ce <initlock>
}
80100f4c:	c9                   	leave  
80100f4d:	c3                   	ret    

80100f4e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f4e:	55                   	push   %ebp
80100f4f:	89 e5                	mov    %esp,%ebp
80100f51:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f54:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f5b:	e8 8f 43 00 00       	call   801052ef <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f60:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
80100f67:	eb 29                	jmp    80100f92 <filealloc+0x44>
    if(f->ref == 0){
80100f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f6c:	8b 40 04             	mov    0x4(%eax),%eax
80100f6f:	85 c0                	test   %eax,%eax
80100f71:	75 1b                	jne    80100f8e <filealloc+0x40>
      f->ref = 1;
80100f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f76:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f7d:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100f84:	e8 c8 43 00 00       	call   80105351 <release>
      return f;
80100f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f8c:	eb 1e                	jmp    80100fac <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f8e:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f92:	81 7d f4 d4 21 11 80 	cmpl   $0x801121d4,-0xc(%ebp)
80100f99:	72 ce                	jb     80100f69 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f9b:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100fa2:	e8 aa 43 00 00       	call   80105351 <release>
  return 0;
80100fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fac:	c9                   	leave  
80100fad:	c3                   	ret    

80100fae <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fae:	55                   	push   %ebp
80100faf:	89 e5                	mov    %esp,%ebp
80100fb1:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fb4:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100fbb:	e8 2f 43 00 00       	call   801052ef <acquire>
  if(f->ref < 1)
80100fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc3:	8b 40 04             	mov    0x4(%eax),%eax
80100fc6:	85 c0                	test   %eax,%eax
80100fc8:	7f 0c                	jg     80100fd6 <filedup+0x28>
    panic("filedup");
80100fca:	c7 04 24 6c 8a 10 80 	movl   $0x80108a6c,(%esp)
80100fd1:	e8 70 f5 ff ff       	call   80100546 <panic>
  f->ref++;
80100fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd9:	8b 40 04             	mov    0x4(%eax),%eax
80100fdc:	8d 50 01             	lea    0x1(%eax),%edx
80100fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe2:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fe5:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80100fec:	e8 60 43 00 00       	call   80105351 <release>
  return f;
80100ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100ff4:	c9                   	leave  
80100ff5:	c3                   	ret    

80100ff6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ff6:	55                   	push   %ebp
80100ff7:	89 e5                	mov    %esp,%ebp
80100ff9:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100ffc:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80101003:	e8 e7 42 00 00       	call   801052ef <acquire>
  if(f->ref < 1)
80101008:	8b 45 08             	mov    0x8(%ebp),%eax
8010100b:	8b 40 04             	mov    0x4(%eax),%eax
8010100e:	85 c0                	test   %eax,%eax
80101010:	7f 0c                	jg     8010101e <fileclose+0x28>
    panic("fileclose");
80101012:	c7 04 24 74 8a 10 80 	movl   $0x80108a74,(%esp)
80101019:	e8 28 f5 ff ff       	call   80100546 <panic>
  if(--f->ref > 0){
8010101e:	8b 45 08             	mov    0x8(%ebp),%eax
80101021:	8b 40 04             	mov    0x4(%eax),%eax
80101024:	8d 50 ff             	lea    -0x1(%eax),%edx
80101027:	8b 45 08             	mov    0x8(%ebp),%eax
8010102a:	89 50 04             	mov    %edx,0x4(%eax)
8010102d:	8b 45 08             	mov    0x8(%ebp),%eax
80101030:	8b 40 04             	mov    0x4(%eax),%eax
80101033:	85 c0                	test   %eax,%eax
80101035:	7e 11                	jle    80101048 <fileclose+0x52>
    release(&ftable.lock);
80101037:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
8010103e:	e8 0e 43 00 00       	call   80105351 <release>
80101043:	e9 82 00 00 00       	jmp    801010ca <fileclose+0xd4>
    return;
  }
  ff = *f;
80101048:	8b 45 08             	mov    0x8(%ebp),%eax
8010104b:	8b 10                	mov    (%eax),%edx
8010104d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101050:	8b 50 04             	mov    0x4(%eax),%edx
80101053:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101056:	8b 50 08             	mov    0x8(%eax),%edx
80101059:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010105c:	8b 50 0c             	mov    0xc(%eax),%edx
8010105f:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101062:	8b 50 10             	mov    0x10(%eax),%edx
80101065:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101068:	8b 40 14             	mov    0x14(%eax),%eax
8010106b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010106e:	8b 45 08             	mov    0x8(%ebp),%eax
80101071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101078:	8b 45 08             	mov    0x8(%ebp),%eax
8010107b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101081:	c7 04 24 40 18 11 80 	movl   $0x80111840,(%esp)
80101088:	e8 c4 42 00 00       	call   80105351 <release>
  
  if(ff.type == FD_PIPE)
8010108d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101090:	83 f8 01             	cmp    $0x1,%eax
80101093:	75 18                	jne    801010ad <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101095:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101099:	0f be d0             	movsbl %al,%edx
8010109c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010109f:	89 54 24 04          	mov    %edx,0x4(%esp)
801010a3:	89 04 24             	mov    %eax,(%esp)
801010a6:	e8 52 30 00 00       	call   801040fd <pipeclose>
801010ab:	eb 1d                	jmp    801010ca <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b0:	83 f8 02             	cmp    $0x2,%eax
801010b3:	75 15                	jne    801010ca <fileclose+0xd4>
    begin_op();
801010b5:	e8 e8 23 00 00       	call   801034a2 <begin_op>
    iput(ff.ip);
801010ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010bd:	89 04 24             	mov    %eax,(%esp)
801010c0:	e8 8a 09 00 00       	call   80101a4f <iput>
    end_op();
801010c5:	e8 59 24 00 00       	call   80103523 <end_op>
  }
}
801010ca:	c9                   	leave  
801010cb:	c3                   	ret    

801010cc <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010cc:	55                   	push   %ebp
801010cd:	89 e5                	mov    %esp,%ebp
801010cf:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010d2:	8b 45 08             	mov    0x8(%ebp),%eax
801010d5:	8b 00                	mov    (%eax),%eax
801010d7:	83 f8 02             	cmp    $0x2,%eax
801010da:	75 38                	jne    80101114 <filestat+0x48>
    ilock(f->ip);
801010dc:	8b 45 08             	mov    0x8(%ebp),%eax
801010df:	8b 40 10             	mov    0x10(%eax),%eax
801010e2:	89 04 24             	mov    %eax,(%esp)
801010e5:	e8 b2 07 00 00       	call   8010189c <ilock>
    stati(f->ip, st);
801010ea:	8b 45 08             	mov    0x8(%ebp),%eax
801010ed:	8b 40 10             	mov    0x10(%eax),%eax
801010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801010f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801010f7:	89 04 24             	mov    %eax,(%esp)
801010fa:	e8 65 0c 00 00       	call   80101d64 <stati>
    iunlock(f->ip);
801010ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101102:	8b 40 10             	mov    0x10(%eax),%eax
80101105:	89 04 24             	mov    %eax,(%esp)
80101108:	e8 dd 08 00 00       	call   801019ea <iunlock>
    return 0;
8010110d:	b8 00 00 00 00       	mov    $0x0,%eax
80101112:	eb 05                	jmp    80101119 <filestat+0x4d>
  }
  return -1;
80101114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101119:	c9                   	leave  
8010111a:	c3                   	ret    

8010111b <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010111b:	55                   	push   %ebp
8010111c:	89 e5                	mov    %esp,%ebp
8010111e:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101121:	8b 45 08             	mov    0x8(%ebp),%eax
80101124:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101128:	84 c0                	test   %al,%al
8010112a:	75 0a                	jne    80101136 <fileread+0x1b>
    return -1;
8010112c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101131:	e9 9f 00 00 00       	jmp    801011d5 <fileread+0xba>
  if(f->type == FD_PIPE)
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 00                	mov    (%eax),%eax
8010113b:	83 f8 01             	cmp    $0x1,%eax
8010113e:	75 1e                	jne    8010115e <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101140:	8b 45 08             	mov    0x8(%ebp),%eax
80101143:	8b 40 0c             	mov    0xc(%eax),%eax
80101146:	8b 55 10             	mov    0x10(%ebp),%edx
80101149:	89 54 24 08          	mov    %edx,0x8(%esp)
8010114d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101150:	89 54 24 04          	mov    %edx,0x4(%esp)
80101154:	89 04 24             	mov    %eax,(%esp)
80101157:	e8 25 31 00 00       	call   80104281 <piperead>
8010115c:	eb 77                	jmp    801011d5 <fileread+0xba>
  if(f->type == FD_INODE){
8010115e:	8b 45 08             	mov    0x8(%ebp),%eax
80101161:	8b 00                	mov    (%eax),%eax
80101163:	83 f8 02             	cmp    $0x2,%eax
80101166:	75 61                	jne    801011c9 <fileread+0xae>
    ilock(f->ip);
80101168:	8b 45 08             	mov    0x8(%ebp),%eax
8010116b:	8b 40 10             	mov    0x10(%eax),%eax
8010116e:	89 04 24             	mov    %eax,(%esp)
80101171:	e8 26 07 00 00       	call   8010189c <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101176:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101179:	8b 45 08             	mov    0x8(%ebp),%eax
8010117c:	8b 50 14             	mov    0x14(%eax),%edx
8010117f:	8b 45 08             	mov    0x8(%ebp),%eax
80101182:	8b 40 10             	mov    0x10(%eax),%eax
80101185:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101189:	89 54 24 08          	mov    %edx,0x8(%esp)
8010118d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101190:	89 54 24 04          	mov    %edx,0x4(%esp)
80101194:	89 04 24             	mov    %eax,(%esp)
80101197:	e8 0d 0c 00 00       	call   80101da9 <readi>
8010119c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010119f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011a3:	7e 11                	jle    801011b6 <fileread+0x9b>
      f->off += r;
801011a5:	8b 45 08             	mov    0x8(%ebp),%eax
801011a8:	8b 50 14             	mov    0x14(%eax),%edx
801011ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ae:	01 c2                	add    %eax,%edx
801011b0:	8b 45 08             	mov    0x8(%ebp),%eax
801011b3:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011b6:	8b 45 08             	mov    0x8(%ebp),%eax
801011b9:	8b 40 10             	mov    0x10(%eax),%eax
801011bc:	89 04 24             	mov    %eax,(%esp)
801011bf:	e8 26 08 00 00       	call   801019ea <iunlock>
    return r;
801011c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011c7:	eb 0c                	jmp    801011d5 <fileread+0xba>
  }
  panic("fileread");
801011c9:	c7 04 24 7e 8a 10 80 	movl   $0x80108a7e,(%esp)
801011d0:	e8 71 f3 ff ff       	call   80100546 <panic>
}
801011d5:	c9                   	leave  
801011d6:	c3                   	ret    

801011d7 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d7:	55                   	push   %ebp
801011d8:	89 e5                	mov    %esp,%ebp
801011da:	53                   	push   %ebx
801011db:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011de:	8b 45 08             	mov    0x8(%ebp),%eax
801011e1:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011e5:	84 c0                	test   %al,%al
801011e7:	75 0a                	jne    801011f3 <filewrite+0x1c>
    return -1;
801011e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ee:	e9 23 01 00 00       	jmp    80101316 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011f3:	8b 45 08             	mov    0x8(%ebp),%eax
801011f6:	8b 00                	mov    (%eax),%eax
801011f8:	83 f8 01             	cmp    $0x1,%eax
801011fb:	75 21                	jne    8010121e <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101200:	8b 40 0c             	mov    0xc(%eax),%eax
80101203:	8b 55 10             	mov    0x10(%ebp),%edx
80101206:	89 54 24 08          	mov    %edx,0x8(%esp)
8010120a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010120d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101211:	89 04 24             	mov    %eax,(%esp)
80101214:	e8 76 2f 00 00       	call   8010418f <pipewrite>
80101219:	e9 f8 00 00 00       	jmp    80101316 <filewrite+0x13f>
  if(f->type == FD_INODE){
8010121e:	8b 45 08             	mov    0x8(%ebp),%eax
80101221:	8b 00                	mov    (%eax),%eax
80101223:	83 f8 02             	cmp    $0x2,%eax
80101226:	0f 85 de 00 00 00    	jne    8010130a <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010122c:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101233:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010123a:	e9 a8 00 00 00       	jmp    801012e7 <filewrite+0x110>
      int n1 = n - i;
8010123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101242:	8b 55 10             	mov    0x10(%ebp),%edx
80101245:	89 d1                	mov    %edx,%ecx
80101247:	29 c1                	sub    %eax,%ecx
80101249:	89 c8                	mov    %ecx,%eax
8010124b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010124e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101251:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101254:	7e 06                	jle    8010125c <filewrite+0x85>
        n1 = max;
80101256:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101259:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010125c:	e8 41 22 00 00       	call   801034a2 <begin_op>
      ilock(f->ip);
80101261:	8b 45 08             	mov    0x8(%ebp),%eax
80101264:	8b 40 10             	mov    0x10(%eax),%eax
80101267:	89 04 24             	mov    %eax,(%esp)
8010126a:	e8 2d 06 00 00       	call   8010189c <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010126f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101272:	8b 45 08             	mov    0x8(%ebp),%eax
80101275:	8b 50 14             	mov    0x14(%eax),%edx
80101278:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010127b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010127e:	01 c3                	add    %eax,%ebx
80101280:	8b 45 08             	mov    0x8(%ebp),%eax
80101283:	8b 40 10             	mov    0x10(%eax),%eax
80101286:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010128a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010128e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101292:	89 04 24             	mov    %eax,(%esp)
80101295:	e8 7d 0c 00 00       	call   80101f17 <writei>
8010129a:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010129d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012a1:	7e 11                	jle    801012b4 <filewrite+0xdd>
        f->off += r;
801012a3:	8b 45 08             	mov    0x8(%ebp),%eax
801012a6:	8b 50 14             	mov    0x14(%eax),%edx
801012a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012ac:	01 c2                	add    %eax,%edx
801012ae:	8b 45 08             	mov    0x8(%ebp),%eax
801012b1:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012b4:	8b 45 08             	mov    0x8(%ebp),%eax
801012b7:	8b 40 10             	mov    0x10(%eax),%eax
801012ba:	89 04 24             	mov    %eax,(%esp)
801012bd:	e8 28 07 00 00       	call   801019ea <iunlock>
      end_op();
801012c2:	e8 5c 22 00 00       	call   80103523 <end_op>

      if(r < 0)
801012c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012cb:	78 28                	js     801012f5 <filewrite+0x11e>
        break;
      if(r != n1)
801012cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012d3:	74 0c                	je     801012e1 <filewrite+0x10a>
        panic("short filewrite");
801012d5:	c7 04 24 87 8a 10 80 	movl   $0x80108a87,(%esp)
801012dc:	e8 65 f2 ff ff       	call   80100546 <panic>
      i += r;
801012e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012e4:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ea:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ed:	0f 8c 4c ff ff ff    	jl     8010123f <filewrite+0x68>
801012f3:	eb 01                	jmp    801012f6 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801012f5:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012f9:	3b 45 10             	cmp    0x10(%ebp),%eax
801012fc:	75 05                	jne    80101303 <filewrite+0x12c>
801012fe:	8b 45 10             	mov    0x10(%ebp),%eax
80101301:	eb 05                	jmp    80101308 <filewrite+0x131>
80101303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101308:	eb 0c                	jmp    80101316 <filewrite+0x13f>
  }
  panic("filewrite");
8010130a:	c7 04 24 97 8a 10 80 	movl   $0x80108a97,(%esp)
80101311:	e8 30 f2 ff ff       	call   80100546 <panic>
}
80101316:	83 c4 24             	add    $0x24,%esp
80101319:	5b                   	pop    %ebx
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret    

8010131c <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010131c:	55                   	push   %ebp
8010131d:	89 e5                	mov    %esp,%ebp
8010131f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101322:	8b 45 08             	mov    0x8(%ebp),%eax
80101325:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010132c:	00 
8010132d:	89 04 24             	mov    %eax,(%esp)
80101330:	e8 71 ee ff ff       	call   801001a6 <bread>
80101335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010133b:	83 c0 18             	add    $0x18,%eax
8010133e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101345:	00 
80101346:	89 44 24 04          	mov    %eax,0x4(%esp)
8010134a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010134d:	89 04 24             	mov    %eax,(%esp)
80101350:	e8 c5 42 00 00       	call   8010561a <memmove>
  brelse(bp);
80101355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101358:	89 04 24             	mov    %eax,(%esp)
8010135b:	e8 b7 ee ff ff       	call   80100217 <brelse>
}
80101360:	c9                   	leave  
80101361:	c3                   	ret    

80101362 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101362:	55                   	push   %ebp
80101363:	89 e5                	mov    %esp,%ebp
80101365:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101368:	8b 55 0c             	mov    0xc(%ebp),%edx
8010136b:	8b 45 08             	mov    0x8(%ebp),%eax
8010136e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101372:	89 04 24             	mov    %eax,(%esp)
80101375:	e8 2c ee ff ff       	call   801001a6 <bread>
8010137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010137d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101380:	83 c0 18             	add    $0x18,%eax
80101383:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010138a:	00 
8010138b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101392:	00 
80101393:	89 04 24             	mov    %eax,(%esp)
80101396:	e8 ac 41 00 00       	call   80105547 <memset>
  log_write(bp);
8010139b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139e:	89 04 24             	mov    %eax,(%esp)
801013a1:	e8 04 23 00 00       	call   801036aa <log_write>
  brelse(bp);
801013a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a9:	89 04 24             	mov    %eax,(%esp)
801013ac:	e8 66 ee ff ff       	call   80100217 <brelse>
}
801013b1:	c9                   	leave  
801013b2:	c3                   	ret    

801013b3 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013b3:	55                   	push   %ebp
801013b4:	89 e5                	mov    %esp,%ebp
801013b6:	53                   	push   %ebx
801013b7:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013c1:	8b 45 08             	mov    0x8(%ebp),%eax
801013c4:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801013cb:	89 04 24             	mov    %eax,(%esp)
801013ce:	e8 49 ff ff ff       	call   8010131c <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013da:	e9 0d 01 00 00       	jmp    801014ec <balloc+0x139>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e2:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013e8:	85 c0                	test   %eax,%eax
801013ea:	0f 48 c2             	cmovs  %edx,%eax
801013ed:	c1 f8 0c             	sar    $0xc,%eax
801013f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013f3:	c1 ea 03             	shr    $0x3,%edx
801013f6:	01 d0                	add    %edx,%eax
801013f8:	83 c0 03             	add    $0x3,%eax
801013fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801013ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101402:	89 04 24             	mov    %eax,(%esp)
80101405:	e8 9c ed ff ff       	call   801001a6 <bread>
8010140a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010140d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101414:	e9 a3 00 00 00       	jmp    801014bc <balloc+0x109>
      m = 1 << (bi % 8);
80101419:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010141c:	89 c2                	mov    %eax,%edx
8010141e:	c1 fa 1f             	sar    $0x1f,%edx
80101421:	c1 ea 1d             	shr    $0x1d,%edx
80101424:	01 d0                	add    %edx,%eax
80101426:	83 e0 07             	and    $0x7,%eax
80101429:	29 d0                	sub    %edx,%eax
8010142b:	ba 01 00 00 00       	mov    $0x1,%edx
80101430:	89 d3                	mov    %edx,%ebx
80101432:	89 c1                	mov    %eax,%ecx
80101434:	d3 e3                	shl    %cl,%ebx
80101436:	89 d8                	mov    %ebx,%eax
80101438:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010143e:	8d 50 07             	lea    0x7(%eax),%edx
80101441:	85 c0                	test   %eax,%eax
80101443:	0f 48 c2             	cmovs  %edx,%eax
80101446:	c1 f8 03             	sar    $0x3,%eax
80101449:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010144c:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101451:	0f b6 c0             	movzbl %al,%eax
80101454:	23 45 e8             	and    -0x18(%ebp),%eax
80101457:	85 c0                	test   %eax,%eax
80101459:	75 5d                	jne    801014b8 <balloc+0x105>
        bp->data[bi/8] |= m;  // Mark block in use.
8010145b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010145e:	8d 50 07             	lea    0x7(%eax),%edx
80101461:	85 c0                	test   %eax,%eax
80101463:	0f 48 c2             	cmovs  %edx,%eax
80101466:	c1 f8 03             	sar    $0x3,%eax
80101469:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010146c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101471:	89 d1                	mov    %edx,%ecx
80101473:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101476:	09 ca                	or     %ecx,%edx
80101478:	89 d1                	mov    %edx,%ecx
8010147a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010147d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101481:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101484:	89 04 24             	mov    %eax,(%esp)
80101487:	e8 1e 22 00 00       	call   801036aa <log_write>
        brelse(bp);
8010148c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010148f:	89 04 24             	mov    %eax,(%esp)
80101492:	e8 80 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101497:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010149a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010149d:	01 c2                	add    %eax,%edx
8010149f:	8b 45 08             	mov    0x8(%ebp),%eax
801014a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801014a6:	89 04 24             	mov    %eax,(%esp)
801014a9:	e8 b4 fe ff ff       	call   80101362 <bzero>
        return b + bi;
801014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014b4:	01 d0                	add    %edx,%eax
801014b6:	eb 4e                	jmp    80101506 <balloc+0x153>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014b8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014bc:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014c3:	7f 15                	jg     801014da <balloc+0x127>
801014c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014cb:	01 d0                	add    %edx,%eax
801014cd:	89 c2                	mov    %eax,%edx
801014cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014d2:	39 c2                	cmp    %eax,%edx
801014d4:	0f 82 3f ff ff ff    	jb     80101419 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014dd:	89 04 24             	mov    %eax,(%esp)
801014e0:	e8 32 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014e5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014f2:	39 c2                	cmp    %eax,%edx
801014f4:	0f 82 e5 fe ff ff    	jb     801013df <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014fa:	c7 04 24 a1 8a 10 80 	movl   $0x80108aa1,(%esp)
80101501:	e8 40 f0 ff ff       	call   80100546 <panic>
}
80101506:	83 c4 34             	add    $0x34,%esp
80101509:	5b                   	pop    %ebx
8010150a:	5d                   	pop    %ebp
8010150b:	c3                   	ret    

8010150c <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010150c:	55                   	push   %ebp
8010150d:	89 e5                	mov    %esp,%ebp
8010150f:	53                   	push   %ebx
80101510:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101513:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101516:	89 44 24 04          	mov    %eax,0x4(%esp)
8010151a:	8b 45 08             	mov    0x8(%ebp),%eax
8010151d:	89 04 24             	mov    %eax,(%esp)
80101520:	e8 f7 fd ff ff       	call   8010131c <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101525:	8b 45 0c             	mov    0xc(%ebp),%eax
80101528:	89 c2                	mov    %eax,%edx
8010152a:	c1 ea 0c             	shr    $0xc,%edx
8010152d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101530:	c1 e8 03             	shr    $0x3,%eax
80101533:	01 d0                	add    %edx,%eax
80101535:	8d 50 03             	lea    0x3(%eax),%edx
80101538:	8b 45 08             	mov    0x8(%ebp),%eax
8010153b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010153f:	89 04 24             	mov    %eax,(%esp)
80101542:	e8 5f ec ff ff       	call   801001a6 <bread>
80101547:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010154a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010154d:	25 ff 0f 00 00       	and    $0xfff,%eax
80101552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101555:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101558:	89 c2                	mov    %eax,%edx
8010155a:	c1 fa 1f             	sar    $0x1f,%edx
8010155d:	c1 ea 1d             	shr    $0x1d,%edx
80101560:	01 d0                	add    %edx,%eax
80101562:	83 e0 07             	and    $0x7,%eax
80101565:	29 d0                	sub    %edx,%eax
80101567:	ba 01 00 00 00       	mov    $0x1,%edx
8010156c:	89 d3                	mov    %edx,%ebx
8010156e:	89 c1                	mov    %eax,%ecx
80101570:	d3 e3                	shl    %cl,%ebx
80101572:	89 d8                	mov    %ebx,%eax
80101574:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101577:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157a:	8d 50 07             	lea    0x7(%eax),%edx
8010157d:	85 c0                	test   %eax,%eax
8010157f:	0f 48 c2             	cmovs  %edx,%eax
80101582:	c1 f8 03             	sar    $0x3,%eax
80101585:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101588:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010158d:	0f b6 c0             	movzbl %al,%eax
80101590:	23 45 ec             	and    -0x14(%ebp),%eax
80101593:	85 c0                	test   %eax,%eax
80101595:	75 0c                	jne    801015a3 <bfree+0x97>
    panic("freeing free block");
80101597:	c7 04 24 b7 8a 10 80 	movl   $0x80108ab7,(%esp)
8010159e:	e8 a3 ef ff ff       	call   80100546 <panic>
  bp->data[bi/8] &= ~m;
801015a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a6:	8d 50 07             	lea    0x7(%eax),%edx
801015a9:	85 c0                	test   %eax,%eax
801015ab:	0f 48 c2             	cmovs  %edx,%eax
801015ae:	c1 f8 03             	sar    $0x3,%eax
801015b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b4:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015b9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015bc:	f7 d1                	not    %ecx
801015be:	21 ca                	and    %ecx,%edx
801015c0:	89 d1                	mov    %edx,%ecx
801015c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c5:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015cc:	89 04 24             	mov    %eax,(%esp)
801015cf:	e8 d6 20 00 00       	call   801036aa <log_write>
  brelse(bp);
801015d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015d7:	89 04 24             	mov    %eax,(%esp)
801015da:	e8 38 ec ff ff       	call   80100217 <brelse>
}
801015df:	83 c4 34             	add    $0x34,%esp
801015e2:	5b                   	pop    %ebx
801015e3:	5d                   	pop    %ebp
801015e4:	c3                   	ret    

801015e5 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015e5:	55                   	push   %ebp
801015e6:	89 e5                	mov    %esp,%ebp
801015e8:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015eb:	c7 44 24 04 ca 8a 10 	movl   $0x80108aca,0x4(%esp)
801015f2:	80 
801015f3:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
801015fa:	e8 cf 3c 00 00       	call   801052ce <initlock>
}
801015ff:	c9                   	leave  
80101600:	c3                   	ret    

80101601 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101601:	55                   	push   %ebp
80101602:	89 e5                	mov    %esp,%ebp
80101604:	83 ec 48             	sub    $0x48,%esp
80101607:	8b 45 0c             	mov    0xc(%ebp),%eax
8010160a:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
8010160e:	8b 45 08             	mov    0x8(%ebp),%eax
80101611:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101614:	89 54 24 04          	mov    %edx,0x4(%esp)
80101618:	89 04 24             	mov    %eax,(%esp)
8010161b:	e8 fc fc ff ff       	call   8010131c <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101620:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101627:	e9 98 00 00 00       	jmp    801016c4 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
8010162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010162f:	c1 e8 03             	shr    $0x3,%eax
80101632:	83 c0 02             	add    $0x2,%eax
80101635:	89 44 24 04          	mov    %eax,0x4(%esp)
80101639:	8b 45 08             	mov    0x8(%ebp),%eax
8010163c:	89 04 24             	mov    %eax,(%esp)
8010163f:	e8 62 eb ff ff       	call   801001a6 <bread>
80101644:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101647:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164a:	8d 50 18             	lea    0x18(%eax),%edx
8010164d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101650:	83 e0 07             	and    $0x7,%eax
80101653:	c1 e0 06             	shl    $0x6,%eax
80101656:	01 d0                	add    %edx,%eax
80101658:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010165b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010165e:	0f b7 00             	movzwl (%eax),%eax
80101661:	66 85 c0             	test   %ax,%ax
80101664:	75 4f                	jne    801016b5 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101666:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010166d:	00 
8010166e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101675:	00 
80101676:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101679:	89 04 24             	mov    %eax,(%esp)
8010167c:	e8 c6 3e 00 00       	call   80105547 <memset>
      dip->type = type;
80101681:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101684:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101688:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010168b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010168e:	89 04 24             	mov    %eax,(%esp)
80101691:	e8 14 20 00 00       	call   801036aa <log_write>
      brelse(bp);
80101696:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101699:	89 04 24             	mov    %eax,(%esp)
8010169c:	e8 76 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
801016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016a8:	8b 45 08             	mov    0x8(%ebp),%eax
801016ab:	89 04 24             	mov    %eax,(%esp)
801016ae:	e8 e5 00 00 00       	call   80101798 <iget>
801016b3:	eb 29                	jmp    801016de <ialloc+0xdd>
    }
    brelse(bp);
801016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016b8:	89 04 24             	mov    %eax,(%esp)
801016bb:	e8 57 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016ca:	39 c2                	cmp    %eax,%edx
801016cc:	0f 82 5a ff ff ff    	jb     8010162c <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016d2:	c7 04 24 d1 8a 10 80 	movl   $0x80108ad1,(%esp)
801016d9:	e8 68 ee ff ff       	call   80100546 <panic>
}
801016de:	c9                   	leave  
801016df:	c3                   	ret    

801016e0 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016e6:	8b 45 08             	mov    0x8(%ebp),%eax
801016e9:	8b 40 04             	mov    0x4(%eax),%eax
801016ec:	c1 e8 03             	shr    $0x3,%eax
801016ef:	8d 50 02             	lea    0x2(%eax),%edx
801016f2:	8b 45 08             	mov    0x8(%ebp),%eax
801016f5:	8b 00                	mov    (%eax),%eax
801016f7:	89 54 24 04          	mov    %edx,0x4(%esp)
801016fb:	89 04 24             	mov    %eax,(%esp)
801016fe:	e8 a3 ea ff ff       	call   801001a6 <bread>
80101703:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101709:	8d 50 18             	lea    0x18(%eax),%edx
8010170c:	8b 45 08             	mov    0x8(%ebp),%eax
8010170f:	8b 40 04             	mov    0x4(%eax),%eax
80101712:	83 e0 07             	and    $0x7,%eax
80101715:	c1 e0 06             	shl    $0x6,%eax
80101718:	01 d0                	add    %edx,%eax
8010171a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010171d:	8b 45 08             	mov    0x8(%ebp),%eax
80101720:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101724:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101727:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172a:	8b 45 08             	mov    0x8(%ebp),%eax
8010172d:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101731:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101734:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101738:	8b 45 08             	mov    0x8(%ebp),%eax
8010173b:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010173f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101742:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101746:	8b 45 08             	mov    0x8(%ebp),%eax
80101749:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010174d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101750:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101754:	8b 45 08             	mov    0x8(%ebp),%eax
80101757:	8b 50 18             	mov    0x18(%eax),%edx
8010175a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010175d:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101760:	8b 45 08             	mov    0x8(%ebp),%eax
80101763:	8d 50 1c             	lea    0x1c(%eax),%edx
80101766:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101769:	83 c0 0c             	add    $0xc,%eax
8010176c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101773:	00 
80101774:	89 54 24 04          	mov    %edx,0x4(%esp)
80101778:	89 04 24             	mov    %eax,(%esp)
8010177b:	e8 9a 3e 00 00       	call   8010561a <memmove>
  log_write(bp);
80101780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101783:	89 04 24             	mov    %eax,(%esp)
80101786:	e8 1f 1f 00 00       	call   801036aa <log_write>
  brelse(bp);
8010178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178e:	89 04 24             	mov    %eax,(%esp)
80101791:	e8 81 ea ff ff       	call   80100217 <brelse>
}
80101796:	c9                   	leave  
80101797:	c3                   	ret    

80101798 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101798:	55                   	push   %ebp
80101799:	89 e5                	mov    %esp,%ebp
8010179b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010179e:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
801017a5:	e8 45 3b 00 00       	call   801052ef <acquire>

  // Is the inode already cached?
  empty = 0;
801017aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017b1:	c7 45 f4 74 22 11 80 	movl   $0x80112274,-0xc(%ebp)
801017b8:	eb 59                	jmp    80101813 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017bd:	8b 40 08             	mov    0x8(%eax),%eax
801017c0:	85 c0                	test   %eax,%eax
801017c2:	7e 35                	jle    801017f9 <iget+0x61>
801017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c7:	8b 00                	mov    (%eax),%eax
801017c9:	3b 45 08             	cmp    0x8(%ebp),%eax
801017cc:	75 2b                	jne    801017f9 <iget+0x61>
801017ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d1:	8b 40 04             	mov    0x4(%eax),%eax
801017d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017d7:	75 20                	jne    801017f9 <iget+0x61>
      ip->ref++;
801017d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017dc:	8b 40 08             	mov    0x8(%eax),%eax
801017df:	8d 50 01             	lea    0x1(%eax),%edx
801017e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e5:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017e8:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
801017ef:	e8 5d 3b 00 00       	call   80105351 <release>
      return ip;
801017f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f7:	eb 6f                	jmp    80101868 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017fd:	75 10                	jne    8010180f <iget+0x77>
801017ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101802:	8b 40 08             	mov    0x8(%eax),%eax
80101805:	85 c0                	test   %eax,%eax
80101807:	75 06                	jne    8010180f <iget+0x77>
      empty = ip;
80101809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010180f:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101813:	81 7d f4 14 32 11 80 	cmpl   $0x80113214,-0xc(%ebp)
8010181a:	72 9e                	jb     801017ba <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010181c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101820:	75 0c                	jne    8010182e <iget+0x96>
    panic("iget: no inodes");
80101822:	c7 04 24 e3 8a 10 80 	movl   $0x80108ae3,(%esp)
80101829:	e8 18 ed ff ff       	call   80100546 <panic>

  ip = empty;
8010182e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101831:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101837:	8b 55 08             	mov    0x8(%ebp),%edx
8010183a:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101842:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101848:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101852:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101859:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101860:	e8 ec 3a 00 00       	call   80105351 <release>

  return ip;
80101865:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101868:	c9                   	leave  
80101869:	c3                   	ret    

8010186a <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010186a:	55                   	push   %ebp
8010186b:	89 e5                	mov    %esp,%ebp
8010186d:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101870:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101877:	e8 73 3a 00 00       	call   801052ef <acquire>
  ip->ref++;
8010187c:	8b 45 08             	mov    0x8(%ebp),%eax
8010187f:	8b 40 08             	mov    0x8(%eax),%eax
80101882:	8d 50 01             	lea    0x1(%eax),%edx
80101885:	8b 45 08             	mov    0x8(%ebp),%eax
80101888:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010188b:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101892:	e8 ba 3a 00 00       	call   80105351 <release>
  return ip;
80101897:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010189a:	c9                   	leave  
8010189b:	c3                   	ret    

8010189c <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010189c:	55                   	push   %ebp
8010189d:	89 e5                	mov    %esp,%ebp
8010189f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018a6:	74 0a                	je     801018b2 <ilock+0x16>
801018a8:	8b 45 08             	mov    0x8(%ebp),%eax
801018ab:	8b 40 08             	mov    0x8(%eax),%eax
801018ae:	85 c0                	test   %eax,%eax
801018b0:	7f 0c                	jg     801018be <ilock+0x22>
    panic("ilock");
801018b2:	c7 04 24 f3 8a 10 80 	movl   $0x80108af3,(%esp)
801018b9:	e8 88 ec ff ff       	call   80100546 <panic>

  acquire(&icache.lock);
801018be:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
801018c5:	e8 25 3a 00 00       	call   801052ef <acquire>
  while(ip->flags & I_BUSY)
801018ca:	eb 13                	jmp    801018df <ilock+0x43>
    sleep(ip, &icache.lock);
801018cc:	c7 44 24 04 40 22 11 	movl   $0x80112240,0x4(%esp)
801018d3:	80 
801018d4:	8b 45 08             	mov    0x8(%ebp),%eax
801018d7:	89 04 24             	mov    %eax,(%esp)
801018da:	e8 34 37 00 00       	call   80105013 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018df:	8b 45 08             	mov    0x8(%ebp),%eax
801018e2:	8b 40 0c             	mov    0xc(%eax),%eax
801018e5:	83 e0 01             	and    $0x1,%eax
801018e8:	85 c0                	test   %eax,%eax
801018ea:	75 e0                	jne    801018cc <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018ec:	8b 45 08             	mov    0x8(%ebp),%eax
801018ef:	8b 40 0c             	mov    0xc(%eax),%eax
801018f2:	89 c2                	mov    %eax,%edx
801018f4:	83 ca 01             	or     $0x1,%edx
801018f7:	8b 45 08             	mov    0x8(%ebp),%eax
801018fa:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018fd:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101904:	e8 48 3a 00 00       	call   80105351 <release>

  if(!(ip->flags & I_VALID)){
80101909:	8b 45 08             	mov    0x8(%ebp),%eax
8010190c:	8b 40 0c             	mov    0xc(%eax),%eax
8010190f:	83 e0 02             	and    $0x2,%eax
80101912:	85 c0                	test   %eax,%eax
80101914:	0f 85 ce 00 00 00    	jne    801019e8 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
8010191a:	8b 45 08             	mov    0x8(%ebp),%eax
8010191d:	8b 40 04             	mov    0x4(%eax),%eax
80101920:	c1 e8 03             	shr    $0x3,%eax
80101923:	8d 50 02             	lea    0x2(%eax),%edx
80101926:	8b 45 08             	mov    0x8(%ebp),%eax
80101929:	8b 00                	mov    (%eax),%eax
8010192b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010192f:	89 04 24             	mov    %eax,(%esp)
80101932:	e8 6f e8 ff ff       	call   801001a6 <bread>
80101937:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193d:	8d 50 18             	lea    0x18(%eax),%edx
80101940:	8b 45 08             	mov    0x8(%ebp),%eax
80101943:	8b 40 04             	mov    0x4(%eax),%eax
80101946:	83 e0 07             	and    $0x7,%eax
80101949:	c1 e0 06             	shl    $0x6,%eax
8010194c:	01 d0                	add    %edx,%eax
8010194e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101951:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101954:	0f b7 10             	movzwl (%eax),%edx
80101957:	8b 45 08             	mov    0x8(%ebp),%eax
8010195a:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010195e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101961:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101965:	8b 45 08             	mov    0x8(%ebp),%eax
80101968:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010196c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010196f:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101973:	8b 45 08             	mov    0x8(%ebp),%eax
80101976:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010197a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197d:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101988:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198b:	8b 50 08             	mov    0x8(%eax),%edx
8010198e:	8b 45 08             	mov    0x8(%ebp),%eax
80101991:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101994:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101997:	8d 50 0c             	lea    0xc(%eax),%edx
8010199a:	8b 45 08             	mov    0x8(%ebp),%eax
8010199d:	83 c0 1c             	add    $0x1c,%eax
801019a0:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019a7:	00 
801019a8:	89 54 24 04          	mov    %edx,0x4(%esp)
801019ac:	89 04 24             	mov    %eax,(%esp)
801019af:	e8 66 3c 00 00       	call   8010561a <memmove>
    brelse(bp);
801019b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b7:	89 04 24             	mov    %eax,(%esp)
801019ba:	e8 58 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019bf:	8b 45 08             	mov    0x8(%ebp),%eax
801019c2:	8b 40 0c             	mov    0xc(%eax),%eax
801019c5:	89 c2                	mov    %eax,%edx
801019c7:	83 ca 02             	or     $0x2,%edx
801019ca:	8b 45 08             	mov    0x8(%ebp),%eax
801019cd:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019d0:	8b 45 08             	mov    0x8(%ebp),%eax
801019d3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019d7:	66 85 c0             	test   %ax,%ax
801019da:	75 0c                	jne    801019e8 <ilock+0x14c>
      panic("ilock: no type");
801019dc:	c7 04 24 f9 8a 10 80 	movl   $0x80108af9,(%esp)
801019e3:	e8 5e eb ff ff       	call   80100546 <panic>
  }
}
801019e8:	c9                   	leave  
801019e9:	c3                   	ret    

801019ea <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019ea:	55                   	push   %ebp
801019eb:	89 e5                	mov    %esp,%ebp
801019ed:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019f4:	74 17                	je     80101a0d <iunlock+0x23>
801019f6:	8b 45 08             	mov    0x8(%ebp),%eax
801019f9:	8b 40 0c             	mov    0xc(%eax),%eax
801019fc:	83 e0 01             	and    $0x1,%eax
801019ff:	85 c0                	test   %eax,%eax
80101a01:	74 0a                	je     80101a0d <iunlock+0x23>
80101a03:	8b 45 08             	mov    0x8(%ebp),%eax
80101a06:	8b 40 08             	mov    0x8(%eax),%eax
80101a09:	85 c0                	test   %eax,%eax
80101a0b:	7f 0c                	jg     80101a19 <iunlock+0x2f>
    panic("iunlock");
80101a0d:	c7 04 24 08 8b 10 80 	movl   $0x80108b08,(%esp)
80101a14:	e8 2d eb ff ff       	call   80100546 <panic>

  acquire(&icache.lock);
80101a19:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101a20:	e8 ca 38 00 00       	call   801052ef <acquire>
  ip->flags &= ~I_BUSY;
80101a25:	8b 45 08             	mov    0x8(%ebp),%eax
80101a28:	8b 40 0c             	mov    0xc(%eax),%eax
80101a2b:	89 c2                	mov    %eax,%edx
80101a2d:	83 e2 fe             	and    $0xfffffffe,%edx
80101a30:	8b 45 08             	mov    0x8(%ebp),%eax
80101a33:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a36:	8b 45 08             	mov    0x8(%ebp),%eax
80101a39:	89 04 24             	mov    %eax,(%esp)
80101a3c:	e8 ab 36 00 00       	call   801050ec <wakeup>
  release(&icache.lock);
80101a41:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101a48:	e8 04 39 00 00       	call   80105351 <release>
}
80101a4d:	c9                   	leave  
80101a4e:	c3                   	ret    

80101a4f <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a4f:	55                   	push   %ebp
80101a50:	89 e5                	mov    %esp,%ebp
80101a52:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a55:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101a5c:	e8 8e 38 00 00       	call   801052ef <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a61:	8b 45 08             	mov    0x8(%ebp),%eax
80101a64:	8b 40 08             	mov    0x8(%eax),%eax
80101a67:	83 f8 01             	cmp    $0x1,%eax
80101a6a:	0f 85 93 00 00 00    	jne    80101b03 <iput+0xb4>
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 40 0c             	mov    0xc(%eax),%eax
80101a76:	83 e0 02             	and    $0x2,%eax
80101a79:	85 c0                	test   %eax,%eax
80101a7b:	0f 84 82 00 00 00    	je     80101b03 <iput+0xb4>
80101a81:	8b 45 08             	mov    0x8(%ebp),%eax
80101a84:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a88:	66 85 c0             	test   %ax,%ax
80101a8b:	75 76                	jne    80101b03 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a90:	8b 40 0c             	mov    0xc(%eax),%eax
80101a93:	83 e0 01             	and    $0x1,%eax
80101a96:	85 c0                	test   %eax,%eax
80101a98:	74 0c                	je     80101aa6 <iput+0x57>
      panic("iput busy");
80101a9a:	c7 04 24 10 8b 10 80 	movl   $0x80108b10,(%esp)
80101aa1:	e8 a0 ea ff ff       	call   80100546 <panic>
    ip->flags |= I_BUSY;
80101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa9:	8b 40 0c             	mov    0xc(%eax),%eax
80101aac:	89 c2                	mov    %eax,%edx
80101aae:	83 ca 01             	or     $0x1,%edx
80101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab4:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101ab7:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101abe:	e8 8e 38 00 00       	call   80105351 <release>
    itrunc(ip);
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	89 04 24             	mov    %eax,(%esp)
80101ac9:	e8 7d 01 00 00       	call   80101c4b <itrunc>
    ip->type = 0;
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ada:	89 04 24             	mov    %eax,(%esp)
80101add:	e8 fe fb ff ff       	call   801016e0 <iupdate>
    acquire(&icache.lock);
80101ae2:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101ae9:	e8 01 38 00 00       	call   801052ef <acquire>
    ip->flags = 0;
80101aee:	8b 45 08             	mov    0x8(%ebp),%eax
80101af1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101af8:	8b 45 08             	mov    0x8(%ebp),%eax
80101afb:	89 04 24             	mov    %eax,(%esp)
80101afe:	e8 e9 35 00 00       	call   801050ec <wakeup>
  }
  ip->ref--;
80101b03:	8b 45 08             	mov    0x8(%ebp),%eax
80101b06:	8b 40 08             	mov    0x8(%eax),%eax
80101b09:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0f:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b12:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80101b19:	e8 33 38 00 00       	call   80105351 <release>
}
80101b1e:	c9                   	leave  
80101b1f:	c3                   	ret    

80101b20 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b26:	8b 45 08             	mov    0x8(%ebp),%eax
80101b29:	89 04 24             	mov    %eax,(%esp)
80101b2c:	e8 b9 fe ff ff       	call   801019ea <iunlock>
  iput(ip);
80101b31:	8b 45 08             	mov    0x8(%ebp),%eax
80101b34:	89 04 24             	mov    %eax,(%esp)
80101b37:	e8 13 ff ff ff       	call   80101a4f <iput>
}
80101b3c:	c9                   	leave  
80101b3d:	c3                   	ret    

80101b3e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b3e:	55                   	push   %ebp
80101b3f:	89 e5                	mov    %esp,%ebp
80101b41:	53                   	push   %ebx
80101b42:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b45:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b49:	77 3e                	ja     80101b89 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b51:	83 c2 04             	add    $0x4,%edx
80101b54:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b5f:	75 20                	jne    80101b81 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b61:	8b 45 08             	mov    0x8(%ebp),%eax
80101b64:	8b 00                	mov    (%eax),%eax
80101b66:	89 04 24             	mov    %eax,(%esp)
80101b69:	e8 45 f8 ff ff       	call   801013b3 <balloc>
80101b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b71:	8b 45 08             	mov    0x8(%ebp),%eax
80101b74:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b77:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b7d:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b84:	e9 bc 00 00 00       	jmp    80101c45 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b89:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b8d:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b91:	0f 87 a2 00 00 00    	ja     80101c39 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b97:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ba0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ba4:	75 19                	jne    80101bbf <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba9:	8b 00                	mov    (%eax),%eax
80101bab:	89 04 24             	mov    %eax,(%esp)
80101bae:	e8 00 f8 ff ff       	call   801013b3 <balloc>
80101bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bbc:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101bbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc2:	8b 00                	mov    (%eax),%eax
80101bc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bc7:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bcb:	89 04 24             	mov    %eax,(%esp)
80101bce:	e8 d3 e5 ff ff       	call   801001a6 <bread>
80101bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd9:	83 c0 18             	add    $0x18,%eax
80101bdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101be2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bec:	01 d0                	add    %edx,%eax
80101bee:	8b 00                	mov    (%eax),%eax
80101bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bf7:	75 30                	jne    80101c29 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bfc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c06:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 00                	mov    (%eax),%eax
80101c0e:	89 04 24             	mov    %eax,(%esp)
80101c11:	e8 9d f7 ff ff       	call   801013b3 <balloc>
80101c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c1c:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c21:	89 04 24             	mov    %eax,(%esp)
80101c24:	e8 81 1a 00 00       	call   801036aa <log_write>
    }
    brelse(bp);
80101c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c2c:	89 04 24             	mov    %eax,(%esp)
80101c2f:	e8 e3 e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c37:	eb 0c                	jmp    80101c45 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c39:	c7 04 24 1a 8b 10 80 	movl   $0x80108b1a,(%esp)
80101c40:	e8 01 e9 ff ff       	call   80100546 <panic>
}
80101c45:	83 c4 24             	add    $0x24,%esp
80101c48:	5b                   	pop    %ebx
80101c49:	5d                   	pop    %ebp
80101c4a:	c3                   	ret    

80101c4b <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c4b:	55                   	push   %ebp
80101c4c:	89 e5                	mov    %esp,%ebp
80101c4e:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c58:	eb 44                	jmp    80101c9e <itrunc+0x53>
    if(ip->addrs[i]){
80101c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c60:	83 c2 04             	add    $0x4,%edx
80101c63:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c67:	85 c0                	test   %eax,%eax
80101c69:	74 2f                	je     80101c9a <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c71:	83 c2 04             	add    $0x4,%edx
80101c74:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c78:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7b:	8b 00                	mov    (%eax),%eax
80101c7d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c81:	89 04 24             	mov    %eax,(%esp)
80101c84:	e8 83 f8 ff ff       	call   8010150c <bfree>
      ip->addrs[i] = 0;
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c8f:	83 c2 04             	add    $0x4,%edx
80101c92:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c99:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c9e:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ca2:	7e b6                	jle    80101c5a <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca7:	8b 40 4c             	mov    0x4c(%eax),%eax
80101caa:	85 c0                	test   %eax,%eax
80101cac:	0f 84 9b 00 00 00    	je     80101d4d <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb5:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbb:	8b 00                	mov    (%eax),%eax
80101cbd:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cc1:	89 04 24             	mov    %eax,(%esp)
80101cc4:	e8 dd e4 ff ff       	call   801001a6 <bread>
80101cc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ccf:	83 c0 18             	add    $0x18,%eax
80101cd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cd5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cdc:	eb 3b                	jmp    80101d19 <itrunc+0xce>
      if(a[j])
80101cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ceb:	01 d0                	add    %edx,%eax
80101ced:	8b 00                	mov    (%eax),%eax
80101cef:	85 c0                	test   %eax,%eax
80101cf1:	74 22                	je     80101d15 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cf6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d00:	01 d0                	add    %edx,%eax
80101d02:	8b 10                	mov    (%eax),%edx
80101d04:	8b 45 08             	mov    0x8(%ebp),%eax
80101d07:	8b 00                	mov    (%eax),%eax
80101d09:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d0d:	89 04 24             	mov    %eax,(%esp)
80101d10:	e8 f7 f7 ff ff       	call   8010150c <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d15:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d1c:	83 f8 7f             	cmp    $0x7f,%eax
80101d1f:	76 bd                	jbe    80101cde <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d24:	89 04 24             	mov    %eax,(%esp)
80101d27:	e8 eb e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d32:	8b 45 08             	mov    0x8(%ebp),%eax
80101d35:	8b 00                	mov    (%eax),%eax
80101d37:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d3b:	89 04 24             	mov    %eax,(%esp)
80101d3e:	e8 c9 f7 ff ff       	call   8010150c <bfree>
    ip->addrs[NDIRECT] = 0;
80101d43:	8b 45 08             	mov    0x8(%ebp),%eax
80101d46:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d50:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d57:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5a:	89 04 24             	mov    %eax,(%esp)
80101d5d:	e8 7e f9 ff ff       	call   801016e0 <iupdate>
}
80101d62:	c9                   	leave  
80101d63:	c3                   	ret    

80101d64 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d64:	55                   	push   %ebp
80101d65:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d67:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6a:	8b 00                	mov    (%eax),%eax
80101d6c:	89 c2                	mov    %eax,%edx
80101d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d71:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d74:	8b 45 08             	mov    0x8(%ebp),%eax
80101d77:	8b 50 04             	mov    0x4(%eax),%edx
80101d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d7d:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d87:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d8a:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d90:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d94:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d97:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9e:	8b 50 18             	mov    0x18(%eax),%edx
80101da1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101da4:	89 50 10             	mov    %edx,0x10(%eax)
}
80101da7:	5d                   	pop    %ebp
80101da8:	c3                   	ret    

80101da9 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101da9:	55                   	push   %ebp
80101daa:	89 e5                	mov    %esp,%ebp
80101dac:	53                   	push   %ebx
80101dad:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101db0:	8b 45 08             	mov    0x8(%ebp),%eax
80101db3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101db7:	66 83 f8 03          	cmp    $0x3,%ax
80101dbb:	75 60                	jne    80101e1d <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101dbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc4:	66 85 c0             	test   %ax,%ax
80101dc7:	78 20                	js     80101de9 <readi+0x40>
80101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dd0:	66 83 f8 09          	cmp    $0x9,%ax
80101dd4:	7f 13                	jg     80101de9 <readi+0x40>
80101dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ddd:	98                   	cwtl   
80101dde:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101de5:	85 c0                	test   %eax,%eax
80101de7:	75 0a                	jne    80101df3 <readi+0x4a>
      return -1;
80101de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dee:	e9 1e 01 00 00       	jmp    80101f11 <readi+0x168>
    return devsw[ip->major].read(ip, dst, n);
80101df3:	8b 45 08             	mov    0x8(%ebp),%eax
80101df6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dfa:	98                   	cwtl   
80101dfb:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101e02:	8b 55 14             	mov    0x14(%ebp),%edx
80101e05:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e09:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e0c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e10:	8b 55 08             	mov    0x8(%ebp),%edx
80101e13:	89 14 24             	mov    %edx,(%esp)
80101e16:	ff d0                	call   *%eax
80101e18:	e9 f4 00 00 00       	jmp    80101f11 <readi+0x168>
  }

  if(off > ip->size || off + n < off)
80101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e20:	8b 40 18             	mov    0x18(%eax),%eax
80101e23:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e26:	72 0d                	jb     80101e35 <readi+0x8c>
80101e28:	8b 45 14             	mov    0x14(%ebp),%eax
80101e2b:	8b 55 10             	mov    0x10(%ebp),%edx
80101e2e:	01 d0                	add    %edx,%eax
80101e30:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e33:	73 0a                	jae    80101e3f <readi+0x96>
    return -1;
80101e35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e3a:	e9 d2 00 00 00       	jmp    80101f11 <readi+0x168>
  if(off + n > ip->size)
80101e3f:	8b 45 14             	mov    0x14(%ebp),%eax
80101e42:	8b 55 10             	mov    0x10(%ebp),%edx
80101e45:	01 c2                	add    %eax,%edx
80101e47:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4a:	8b 40 18             	mov    0x18(%eax),%eax
80101e4d:	39 c2                	cmp    %eax,%edx
80101e4f:	76 0c                	jbe    80101e5d <readi+0xb4>
    n = ip->size - off;
80101e51:	8b 45 08             	mov    0x8(%ebp),%eax
80101e54:	8b 40 18             	mov    0x18(%eax),%eax
80101e57:	2b 45 10             	sub    0x10(%ebp),%eax
80101e5a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e64:	e9 99 00 00 00       	jmp    80101f02 <readi+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e69:	8b 45 10             	mov    0x10(%ebp),%eax
80101e6c:	c1 e8 09             	shr    $0x9,%eax
80101e6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e73:	8b 45 08             	mov    0x8(%ebp),%eax
80101e76:	89 04 24             	mov    %eax,(%esp)
80101e79:	e8 c0 fc ff ff       	call   80101b3e <bmap>
80101e7e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e81:	8b 12                	mov    (%edx),%edx
80101e83:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e87:	89 14 24             	mov    %edx,(%esp)
80101e8a:	e8 17 e3 ff ff       	call   801001a6 <bread>
80101e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
80101e95:	89 c2                	mov    %eax,%edx
80101e97:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e9d:	b8 00 02 00 00       	mov    $0x200,%eax
80101ea2:	89 c1                	mov    %eax,%ecx
80101ea4:	29 d1                	sub    %edx,%ecx
80101ea6:	89 ca                	mov    %ecx,%edx
80101ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eab:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101eae:	89 cb                	mov    %ecx,%ebx
80101eb0:	29 c3                	sub    %eax,%ebx
80101eb2:	89 d8                	mov    %ebx,%eax
80101eb4:	39 c2                	cmp    %eax,%edx
80101eb6:	0f 46 c2             	cmovbe %edx,%eax
80101eb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101ebc:	8b 45 10             	mov    0x10(%ebp),%eax
80101ebf:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ec4:	8d 50 10             	lea    0x10(%eax),%edx
80101ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eca:	01 d0                	add    %edx,%eax
80101ecc:	8d 50 08             	lea    0x8(%eax),%edx
80101ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ed2:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ed6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101eda:	8b 45 0c             	mov    0xc(%ebp),%eax
80101edd:	89 04 24             	mov    %eax,(%esp)
80101ee0:	e8 35 37 00 00       	call   8010561a <memmove>
    brelse(bp);
80101ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee8:	89 04 24             	mov    %eax,(%esp)
80101eeb:	e8 27 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef3:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef9:	01 45 10             	add    %eax,0x10(%ebp)
80101efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eff:	01 45 0c             	add    %eax,0xc(%ebp)
80101f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f05:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f08:	0f 82 5b ff ff ff    	jb     80101e69 <readi+0xc0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f0e:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f11:	83 c4 24             	add    $0x24,%esp
80101f14:	5b                   	pop    %ebx
80101f15:	5d                   	pop    %ebp
80101f16:	c3                   	ret    

80101f17 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f17:	55                   	push   %ebp
80101f18:	89 e5                	mov    %esp,%ebp
80101f1a:	53                   	push   %ebx
80101f1b:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f21:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f25:	66 83 f8 03          	cmp    $0x3,%ax
80101f29:	75 60                	jne    80101f8b <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f32:	66 85 c0             	test   %ax,%ax
80101f35:	78 20                	js     80101f57 <writei+0x40>
80101f37:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f3e:	66 83 f8 09          	cmp    $0x9,%ax
80101f42:	7f 13                	jg     80101f57 <writei+0x40>
80101f44:	8b 45 08             	mov    0x8(%ebp),%eax
80101f47:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f4b:	98                   	cwtl   
80101f4c:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	75 0a                	jne    80101f61 <writei+0x4a>
      return -1;
80101f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f5c:	e9 49 01 00 00       	jmp    801020aa <writei+0x193>
    return devsw[ip->major].write(ip, src, n);
80101f61:	8b 45 08             	mov    0x8(%ebp),%eax
80101f64:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f68:	98                   	cwtl   
80101f69:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
80101f70:	8b 55 14             	mov    0x14(%ebp),%edx
80101f73:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f77:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f7a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f7e:	8b 55 08             	mov    0x8(%ebp),%edx
80101f81:	89 14 24             	mov    %edx,(%esp)
80101f84:	ff d0                	call   *%eax
80101f86:	e9 1f 01 00 00       	jmp    801020aa <writei+0x193>
  }

  if(off > ip->size || off + n < off)
80101f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8e:	8b 40 18             	mov    0x18(%eax),%eax
80101f91:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f94:	72 0d                	jb     80101fa3 <writei+0x8c>
80101f96:	8b 45 14             	mov    0x14(%ebp),%eax
80101f99:	8b 55 10             	mov    0x10(%ebp),%edx
80101f9c:	01 d0                	add    %edx,%eax
80101f9e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fa1:	73 0a                	jae    80101fad <writei+0x96>
    return -1;
80101fa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fa8:	e9 fd 00 00 00       	jmp    801020aa <writei+0x193>
  if(off + n > MAXFILE*BSIZE)
80101fad:	8b 45 14             	mov    0x14(%ebp),%eax
80101fb0:	8b 55 10             	mov    0x10(%ebp),%edx
80101fb3:	01 d0                	add    %edx,%eax
80101fb5:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fba:	76 0a                	jbe    80101fc6 <writei+0xaf>
    return -1;
80101fbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc1:	e9 e4 00 00 00       	jmp    801020aa <writei+0x193>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fcd:	e9 a4 00 00 00       	jmp    80102076 <writei+0x15f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fd2:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd5:	c1 e8 09             	shr    $0x9,%eax
80101fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fdc:	8b 45 08             	mov    0x8(%ebp),%eax
80101fdf:	89 04 24             	mov    %eax,(%esp)
80101fe2:	e8 57 fb ff ff       	call   80101b3e <bmap>
80101fe7:	8b 55 08             	mov    0x8(%ebp),%edx
80101fea:	8b 12                	mov    (%edx),%edx
80101fec:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ff0:	89 14 24             	mov    %edx,(%esp)
80101ff3:	e8 ae e1 ff ff       	call   801001a6 <bread>
80101ff8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ffb:	8b 45 10             	mov    0x10(%ebp),%eax
80101ffe:	89 c2                	mov    %eax,%edx
80102000:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102006:	b8 00 02 00 00       	mov    $0x200,%eax
8010200b:	89 c1                	mov    %eax,%ecx
8010200d:	29 d1                	sub    %edx,%ecx
8010200f:	89 ca                	mov    %ecx,%edx
80102011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102014:	8b 4d 14             	mov    0x14(%ebp),%ecx
80102017:	89 cb                	mov    %ecx,%ebx
80102019:	29 c3                	sub    %eax,%ebx
8010201b:	89 d8                	mov    %ebx,%eax
8010201d:	39 c2                	cmp    %eax,%edx
8010201f:	0f 46 c2             	cmovbe %edx,%eax
80102022:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102025:	8b 45 10             	mov    0x10(%ebp),%eax
80102028:	25 ff 01 00 00       	and    $0x1ff,%eax
8010202d:	8d 50 10             	lea    0x10(%eax),%edx
80102030:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102033:	01 d0                	add    %edx,%eax
80102035:	8d 50 08             	lea    0x8(%eax),%edx
80102038:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010203f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102042:	89 44 24 04          	mov    %eax,0x4(%esp)
80102046:	89 14 24             	mov    %edx,(%esp)
80102049:	e8 cc 35 00 00       	call   8010561a <memmove>
    log_write(bp);
8010204e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102051:	89 04 24             	mov    %eax,(%esp)
80102054:	e8 51 16 00 00       	call   801036aa <log_write>
    brelse(bp);
80102059:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010205c:	89 04 24             	mov    %eax,(%esp)
8010205f:	e8 b3 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102064:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102067:	01 45 f4             	add    %eax,-0xc(%ebp)
8010206a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010206d:	01 45 10             	add    %eax,0x10(%ebp)
80102070:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102073:	01 45 0c             	add    %eax,0xc(%ebp)
80102076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102079:	3b 45 14             	cmp    0x14(%ebp),%eax
8010207c:	0f 82 50 ff ff ff    	jb     80101fd2 <writei+0xbb>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102082:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102086:	74 1f                	je     801020a7 <writei+0x190>
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8b 40 18             	mov    0x18(%eax),%eax
8010208e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102091:	73 14                	jae    801020a7 <writei+0x190>
    ip->size = off;
80102093:	8b 45 08             	mov    0x8(%ebp),%eax
80102096:	8b 55 10             	mov    0x10(%ebp),%edx
80102099:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010209c:	8b 45 08             	mov    0x8(%ebp),%eax
8010209f:	89 04 24             	mov    %eax,(%esp)
801020a2:	e8 39 f6 ff ff       	call   801016e0 <iupdate>
  }
  return n;
801020a7:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020aa:	83 c4 24             	add    $0x24,%esp
801020ad:	5b                   	pop    %ebx
801020ae:	5d                   	pop    %ebp
801020af:	c3                   	ret    

801020b0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020b6:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020bd:	00 
801020be:	8b 45 0c             	mov    0xc(%ebp),%eax
801020c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801020c5:	8b 45 08             	mov    0x8(%ebp),%eax
801020c8:	89 04 24             	mov    %eax,(%esp)
801020cb:	e8 ee 35 00 00       	call   801056be <strncmp>
}
801020d0:	c9                   	leave  
801020d1:	c3                   	ret    

801020d2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020d2:	55                   	push   %ebp
801020d3:	89 e5                	mov    %esp,%ebp
801020d5:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020d8:	8b 45 08             	mov    0x8(%ebp),%eax
801020db:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020df:	66 83 f8 01          	cmp    $0x1,%ax
801020e3:	74 0c                	je     801020f1 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020e5:	c7 04 24 2d 8b 10 80 	movl   $0x80108b2d,(%esp)
801020ec:	e8 55 e4 ff ff       	call   80100546 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020f8:	e9 87 00 00 00       	jmp    80102184 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020fd:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102104:	00 
80102105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102108:	89 44 24 08          	mov    %eax,0x8(%esp)
8010210c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010210f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102113:	8b 45 08             	mov    0x8(%ebp),%eax
80102116:	89 04 24             	mov    %eax,(%esp)
80102119:	e8 8b fc ff ff       	call   80101da9 <readi>
8010211e:	83 f8 10             	cmp    $0x10,%eax
80102121:	74 0c                	je     8010212f <dirlookup+0x5d>
      panic("dirlink read");
80102123:	c7 04 24 3f 8b 10 80 	movl   $0x80108b3f,(%esp)
8010212a:	e8 17 e4 ff ff       	call   80100546 <panic>
    if(de.inum == 0)
8010212f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102133:	66 85 c0             	test   %ax,%ax
80102136:	74 47                	je     8010217f <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
80102138:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010213b:	83 c0 02             	add    $0x2,%eax
8010213e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102142:	8b 45 0c             	mov    0xc(%ebp),%eax
80102145:	89 04 24             	mov    %eax,(%esp)
80102148:	e8 63 ff ff ff       	call   801020b0 <namecmp>
8010214d:	85 c0                	test   %eax,%eax
8010214f:	75 2f                	jne    80102180 <dirlookup+0xae>
      // entry matches path element
      if(poff)
80102151:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102155:	74 08                	je     8010215f <dirlookup+0x8d>
        *poff = off;
80102157:	8b 45 10             	mov    0x10(%ebp),%eax
8010215a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010215d:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010215f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102163:	0f b7 c0             	movzwl %ax,%eax
80102166:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102169:	8b 45 08             	mov    0x8(%ebp),%eax
8010216c:	8b 00                	mov    (%eax),%eax
8010216e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102171:	89 54 24 04          	mov    %edx,0x4(%esp)
80102175:	89 04 24             	mov    %eax,(%esp)
80102178:	e8 1b f6 ff ff       	call   80101798 <iget>
8010217d:	eb 19                	jmp    80102198 <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010217f:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102180:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102184:	8b 45 08             	mov    0x8(%ebp),%eax
80102187:	8b 40 18             	mov    0x18(%eax),%eax
8010218a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010218d:	0f 87 6a ff ff ff    	ja     801020fd <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102193:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102198:	c9                   	leave  
80102199:	c3                   	ret    

8010219a <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010219a:	55                   	push   %ebp
8010219b:	89 e5                	mov    %esp,%ebp
8010219d:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021a7:	00 
801021a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801021ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801021af:	8b 45 08             	mov    0x8(%ebp),%eax
801021b2:	89 04 24             	mov    %eax,(%esp)
801021b5:	e8 18 ff ff ff       	call   801020d2 <dirlookup>
801021ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021c1:	74 15                	je     801021d8 <dirlink+0x3e>
    iput(ip);
801021c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021c6:	89 04 24             	mov    %eax,(%esp)
801021c9:	e8 81 f8 ff ff       	call   80101a4f <iput>
    return -1;
801021ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021d3:	e9 b8 00 00 00       	jmp    80102290 <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021df:	eb 44                	jmp    80102225 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021e4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021eb:	00 
801021ec:	89 44 24 08          	mov    %eax,0x8(%esp)
801021f0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801021f7:	8b 45 08             	mov    0x8(%ebp),%eax
801021fa:	89 04 24             	mov    %eax,(%esp)
801021fd:	e8 a7 fb ff ff       	call   80101da9 <readi>
80102202:	83 f8 10             	cmp    $0x10,%eax
80102205:	74 0c                	je     80102213 <dirlink+0x79>
      panic("dirlink read");
80102207:	c7 04 24 3f 8b 10 80 	movl   $0x80108b3f,(%esp)
8010220e:	e8 33 e3 ff ff       	call   80100546 <panic>
    if(de.inum == 0)
80102213:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102217:	66 85 c0             	test   %ax,%ax
8010221a:	74 18                	je     80102234 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010221f:	83 c0 10             	add    $0x10,%eax
80102222:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102225:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102228:	8b 45 08             	mov    0x8(%ebp),%eax
8010222b:	8b 40 18             	mov    0x18(%eax),%eax
8010222e:	39 c2                	cmp    %eax,%edx
80102230:	72 af                	jb     801021e1 <dirlink+0x47>
80102232:	eb 01                	jmp    80102235 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102234:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102235:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010223c:	00 
8010223d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102240:	89 44 24 04          	mov    %eax,0x4(%esp)
80102244:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102247:	83 c0 02             	add    $0x2,%eax
8010224a:	89 04 24             	mov    %eax,(%esp)
8010224d:	e8 c4 34 00 00       	call   80105716 <strncpy>
  de.inum = inum;
80102252:	8b 45 10             	mov    0x10(%ebp),%eax
80102255:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102259:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010225c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102263:	00 
80102264:	89 44 24 08          	mov    %eax,0x8(%esp)
80102268:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010226b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010226f:	8b 45 08             	mov    0x8(%ebp),%eax
80102272:	89 04 24             	mov    %eax,(%esp)
80102275:	e8 9d fc ff ff       	call   80101f17 <writei>
8010227a:	83 f8 10             	cmp    $0x10,%eax
8010227d:	74 0c                	je     8010228b <dirlink+0xf1>
    panic("dirlink");
8010227f:	c7 04 24 4c 8b 10 80 	movl   $0x80108b4c,(%esp)
80102286:	e8 bb e2 ff ff       	call   80100546 <panic>
  
  return 0;
8010228b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102290:	c9                   	leave  
80102291:	c3                   	ret    

80102292 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102292:	55                   	push   %ebp
80102293:	89 e5                	mov    %esp,%ebp
80102295:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102298:	eb 04                	jmp    8010229e <skipelem+0xc>
    path++;
8010229a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010229e:	8b 45 08             	mov    0x8(%ebp),%eax
801022a1:	0f b6 00             	movzbl (%eax),%eax
801022a4:	3c 2f                	cmp    $0x2f,%al
801022a6:	74 f2                	je     8010229a <skipelem+0x8>
    path++;
  if(*path == 0)
801022a8:	8b 45 08             	mov    0x8(%ebp),%eax
801022ab:	0f b6 00             	movzbl (%eax),%eax
801022ae:	84 c0                	test   %al,%al
801022b0:	75 0a                	jne    801022bc <skipelem+0x2a>
    return 0;
801022b2:	b8 00 00 00 00       	mov    $0x0,%eax
801022b7:	e9 88 00 00 00       	jmp    80102344 <skipelem+0xb2>
  s = path;
801022bc:	8b 45 08             	mov    0x8(%ebp),%eax
801022bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022c2:	eb 04                	jmp    801022c8 <skipelem+0x36>
    path++;
801022c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022c8:	8b 45 08             	mov    0x8(%ebp),%eax
801022cb:	0f b6 00             	movzbl (%eax),%eax
801022ce:	3c 2f                	cmp    $0x2f,%al
801022d0:	74 0a                	je     801022dc <skipelem+0x4a>
801022d2:	8b 45 08             	mov    0x8(%ebp),%eax
801022d5:	0f b6 00             	movzbl (%eax),%eax
801022d8:	84 c0                	test   %al,%al
801022da:	75 e8                	jne    801022c4 <skipelem+0x32>
    path++;
  len = path - s;
801022dc:	8b 55 08             	mov    0x8(%ebp),%edx
801022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e2:	89 d1                	mov    %edx,%ecx
801022e4:	29 c1                	sub    %eax,%ecx
801022e6:	89 c8                	mov    %ecx,%eax
801022e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022eb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022ef:	7e 1c                	jle    8010230d <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
801022f1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022f8:	00 
801022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102300:	8b 45 0c             	mov    0xc(%ebp),%eax
80102303:	89 04 24             	mov    %eax,(%esp)
80102306:	e8 0f 33 00 00       	call   8010561a <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010230b:	eb 2a                	jmp    80102337 <skipelem+0xa5>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
8010230d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102310:	89 44 24 08          	mov    %eax,0x8(%esp)
80102314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102317:	89 44 24 04          	mov    %eax,0x4(%esp)
8010231b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010231e:	89 04 24             	mov    %eax,(%esp)
80102321:	e8 f4 32 00 00       	call   8010561a <memmove>
    name[len] = 0;
80102326:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102329:	8b 45 0c             	mov    0xc(%ebp),%eax
8010232c:	01 d0                	add    %edx,%eax
8010232e:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102331:	eb 04                	jmp    80102337 <skipelem+0xa5>
    path++;
80102333:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102337:	8b 45 08             	mov    0x8(%ebp),%eax
8010233a:	0f b6 00             	movzbl (%eax),%eax
8010233d:	3c 2f                	cmp    $0x2f,%al
8010233f:	74 f2                	je     80102333 <skipelem+0xa1>
    path++;
  return path;
80102341:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102344:	c9                   	leave  
80102345:	c3                   	ret    

80102346 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102346:	55                   	push   %ebp
80102347:	89 e5                	mov    %esp,%ebp
80102349:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010234c:	8b 45 08             	mov    0x8(%ebp),%eax
8010234f:	0f b6 00             	movzbl (%eax),%eax
80102352:	3c 2f                	cmp    $0x2f,%al
80102354:	75 1c                	jne    80102372 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102356:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010235d:	00 
8010235e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102365:	e8 2e f4 ff ff       	call   80101798 <iget>
8010236a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010236d:	e9 af 00 00 00       	jmp    80102421 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102372:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102378:	8b 40 68             	mov    0x68(%eax),%eax
8010237b:	89 04 24             	mov    %eax,(%esp)
8010237e:	e8 e7 f4 ff ff       	call   8010186a <idup>
80102383:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102386:	e9 96 00 00 00       	jmp    80102421 <namex+0xdb>
    ilock(ip);
8010238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010238e:	89 04 24             	mov    %eax,(%esp)
80102391:	e8 06 f5 ff ff       	call   8010189c <ilock>
    if(ip->type != T_DIR){
80102396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102399:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010239d:	66 83 f8 01          	cmp    $0x1,%ax
801023a1:	74 15                	je     801023b8 <namex+0x72>
      iunlockput(ip);
801023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a6:	89 04 24             	mov    %eax,(%esp)
801023a9:	e8 72 f7 ff ff       	call   80101b20 <iunlockput>
      return 0;
801023ae:	b8 00 00 00 00       	mov    $0x0,%eax
801023b3:	e9 a3 00 00 00       	jmp    8010245b <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801023b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023bc:	74 1d                	je     801023db <namex+0x95>
801023be:	8b 45 08             	mov    0x8(%ebp),%eax
801023c1:	0f b6 00             	movzbl (%eax),%eax
801023c4:	84 c0                	test   %al,%al
801023c6:	75 13                	jne    801023db <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023cb:	89 04 24             	mov    %eax,(%esp)
801023ce:	e8 17 f6 ff ff       	call   801019ea <iunlock>
      return ip;
801023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d6:	e9 80 00 00 00       	jmp    8010245b <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023e2:	00 
801023e3:	8b 45 10             	mov    0x10(%ebp),%eax
801023e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ed:	89 04 24             	mov    %eax,(%esp)
801023f0:	e8 dd fc ff ff       	call   801020d2 <dirlookup>
801023f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023fc:	75 12                	jne    80102410 <namex+0xca>
      iunlockput(ip);
801023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102401:	89 04 24             	mov    %eax,(%esp)
80102404:	e8 17 f7 ff ff       	call   80101b20 <iunlockput>
      return 0;
80102409:	b8 00 00 00 00       	mov    $0x0,%eax
8010240e:	eb 4b                	jmp    8010245b <namex+0x115>
    }
    iunlockput(ip);
80102410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102413:	89 04 24             	mov    %eax,(%esp)
80102416:	e8 05 f7 ff ff       	call   80101b20 <iunlockput>
    ip = next;
8010241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010241e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102421:	8b 45 10             	mov    0x10(%ebp),%eax
80102424:	89 44 24 04          	mov    %eax,0x4(%esp)
80102428:	8b 45 08             	mov    0x8(%ebp),%eax
8010242b:	89 04 24             	mov    %eax,(%esp)
8010242e:	e8 5f fe ff ff       	call   80102292 <skipelem>
80102433:	89 45 08             	mov    %eax,0x8(%ebp)
80102436:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010243a:	0f 85 4b ff ff ff    	jne    8010238b <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102440:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102444:	74 12                	je     80102458 <namex+0x112>
    iput(ip);
80102446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102449:	89 04 24             	mov    %eax,(%esp)
8010244c:	e8 fe f5 ff ff       	call   80101a4f <iput>
    return 0;
80102451:	b8 00 00 00 00       	mov    $0x0,%eax
80102456:	eb 03                	jmp    8010245b <namex+0x115>
  }
  return ip;
80102458:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010245b:	c9                   	leave  
8010245c:	c3                   	ret    

8010245d <namei>:

struct inode*
namei(char *path)
{
8010245d:	55                   	push   %ebp
8010245e:	89 e5                	mov    %esp,%ebp
80102460:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102463:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102466:	89 44 24 08          	mov    %eax,0x8(%esp)
8010246a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102471:	00 
80102472:	8b 45 08             	mov    0x8(%ebp),%eax
80102475:	89 04 24             	mov    %eax,(%esp)
80102478:	e8 c9 fe ff ff       	call   80102346 <namex>
}
8010247d:	c9                   	leave  
8010247e:	c3                   	ret    

8010247f <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010247f:	55                   	push   %ebp
80102480:	89 e5                	mov    %esp,%ebp
80102482:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102485:	8b 45 0c             	mov    0xc(%ebp),%eax
80102488:	89 44 24 08          	mov    %eax,0x8(%esp)
8010248c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102493:	00 
80102494:	8b 45 08             	mov    0x8(%ebp),%eax
80102497:	89 04 24             	mov    %eax,(%esp)
8010249a:	e8 a7 fe ff ff       	call   80102346 <namex>
}
8010249f:	c9                   	leave  
801024a0:	c3                   	ret    

801024a1 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024a1:	55                   	push   %ebp
801024a2:	89 e5                	mov    %esp,%ebp
801024a4:	53                   	push   %ebx
801024a5:	83 ec 14             	sub    $0x14,%esp
801024a8:	8b 45 08             	mov    0x8(%ebp),%eax
801024ab:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024af:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801024b3:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801024b7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801024bb:	ec                   	in     (%dx),%al
801024bc:	89 c3                	mov    %eax,%ebx
801024be:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801024c1:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801024c5:	83 c4 14             	add    $0x14,%esp
801024c8:	5b                   	pop    %ebx
801024c9:	5d                   	pop    %ebp
801024ca:	c3                   	ret    

801024cb <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024cb:	55                   	push   %ebp
801024cc:	89 e5                	mov    %esp,%ebp
801024ce:	57                   	push   %edi
801024cf:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024d0:	8b 55 08             	mov    0x8(%ebp),%edx
801024d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024d6:	8b 45 10             	mov    0x10(%ebp),%eax
801024d9:	89 cb                	mov    %ecx,%ebx
801024db:	89 df                	mov    %ebx,%edi
801024dd:	89 c1                	mov    %eax,%ecx
801024df:	fc                   	cld    
801024e0:	f3 6d                	rep insl (%dx),%es:(%edi)
801024e2:	89 c8                	mov    %ecx,%eax
801024e4:	89 fb                	mov    %edi,%ebx
801024e6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024e9:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024ec:	5b                   	pop    %ebx
801024ed:	5f                   	pop    %edi
801024ee:	5d                   	pop    %ebp
801024ef:	c3                   	ret    

801024f0 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	83 ec 08             	sub    $0x8,%esp
801024f6:	8b 55 08             	mov    0x8(%ebp),%edx
801024f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801024fc:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102500:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102503:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102507:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010250b:	ee                   	out    %al,(%dx)
}
8010250c:	c9                   	leave  
8010250d:	c3                   	ret    

8010250e <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010250e:	55                   	push   %ebp
8010250f:	89 e5                	mov    %esp,%ebp
80102511:	56                   	push   %esi
80102512:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102513:	8b 55 08             	mov    0x8(%ebp),%edx
80102516:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102519:	8b 45 10             	mov    0x10(%ebp),%eax
8010251c:	89 cb                	mov    %ecx,%ebx
8010251e:	89 de                	mov    %ebx,%esi
80102520:	89 c1                	mov    %eax,%ecx
80102522:	fc                   	cld    
80102523:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102525:	89 c8                	mov    %ecx,%eax
80102527:	89 f3                	mov    %esi,%ebx
80102529:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010252c:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010252f:	5b                   	pop    %ebx
80102530:	5e                   	pop    %esi
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret    

80102533 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102533:	55                   	push   %ebp
80102534:	89 e5                	mov    %esp,%ebp
80102536:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102539:	90                   	nop
8010253a:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102541:	e8 5b ff ff ff       	call   801024a1 <inb>
80102546:	0f b6 c0             	movzbl %al,%eax
80102549:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010254c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010254f:	25 c0 00 00 00       	and    $0xc0,%eax
80102554:	83 f8 40             	cmp    $0x40,%eax
80102557:	75 e1                	jne    8010253a <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102559:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010255d:	74 11                	je     80102570 <idewait+0x3d>
8010255f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102562:	83 e0 21             	and    $0x21,%eax
80102565:	85 c0                	test   %eax,%eax
80102567:	74 07                	je     80102570 <idewait+0x3d>
    return -1;
80102569:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010256e:	eb 05                	jmp    80102575 <idewait+0x42>
  return 0;
80102570:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102575:	c9                   	leave  
80102576:	c3                   	ret    

80102577 <ideinit>:

void
ideinit(void)
{
80102577:	55                   	push   %ebp
80102578:	89 e5                	mov    %esp,%ebp
8010257a:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010257d:	c7 44 24 04 54 8b 10 	movl   $0x80108b54,0x4(%esp)
80102584:	80 
80102585:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010258c:	e8 3d 2d 00 00       	call   801052ce <initlock>
  picenable(IRQ_IDE);
80102591:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102598:	e8 a9 18 00 00       	call   80103e46 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010259d:	a1 40 39 11 80       	mov    0x80113940,%eax
801025a2:	83 e8 01             	sub    $0x1,%eax
801025a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801025a9:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025b0:	e8 0f 04 00 00       	call   801029c4 <ioapicenable>
  idewait(0);
801025b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025bc:	e8 72 ff ff ff       	call   80102533 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025c1:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025c8:	00 
801025c9:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025d0:	e8 1b ff ff ff       	call   801024f0 <outb>
  for(i=0; i<1000; i++){
801025d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025dc:	eb 20                	jmp    801025fe <ideinit+0x87>
    if(inb(0x1f7) != 0){
801025de:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025e5:	e8 b7 fe ff ff       	call   801024a1 <inb>
801025ea:	84 c0                	test   %al,%al
801025ec:	74 0c                	je     801025fa <ideinit+0x83>
      havedisk1 = 1;
801025ee:	c7 05 38 c6 10 80 01 	movl   $0x1,0x8010c638
801025f5:	00 00 00 
      break;
801025f8:	eb 0d                	jmp    80102607 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025fe:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102605:	7e d7                	jle    801025de <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102607:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
8010260e:	00 
8010260f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102616:	e8 d5 fe ff ff       	call   801024f0 <outb>
}
8010261b:	c9                   	leave  
8010261c:	c3                   	ret    

8010261d <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010261d:	55                   	push   %ebp
8010261e:	89 e5                	mov    %esp,%ebp
80102620:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102623:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102627:	75 0c                	jne    80102635 <idestart+0x18>
    panic("idestart");
80102629:	c7 04 24 58 8b 10 80 	movl   $0x80108b58,(%esp)
80102630:	e8 11 df ff ff       	call   80100546 <panic>

  idewait(0);
80102635:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010263c:	e8 f2 fe ff ff       	call   80102533 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102641:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102648:	00 
80102649:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102650:	e8 9b fe ff ff       	call   801024f0 <outb>
  outb(0x1f2, 1);  // number of sectors
80102655:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010265c:	00 
8010265d:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102664:	e8 87 fe ff ff       	call   801024f0 <outb>
  outb(0x1f3, b->sector & 0xff);
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
8010266c:	8b 40 08             	mov    0x8(%eax),%eax
8010266f:	0f b6 c0             	movzbl %al,%eax
80102672:	89 44 24 04          	mov    %eax,0x4(%esp)
80102676:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010267d:	e8 6e fe ff ff       	call   801024f0 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102682:	8b 45 08             	mov    0x8(%ebp),%eax
80102685:	8b 40 08             	mov    0x8(%eax),%eax
80102688:	c1 e8 08             	shr    $0x8,%eax
8010268b:	0f b6 c0             	movzbl %al,%eax
8010268e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102692:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102699:	e8 52 fe ff ff       	call   801024f0 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010269e:	8b 45 08             	mov    0x8(%ebp),%eax
801026a1:	8b 40 08             	mov    0x8(%eax),%eax
801026a4:	c1 e8 10             	shr    $0x10,%eax
801026a7:	0f b6 c0             	movzbl %al,%eax
801026aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801026ae:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801026b5:	e8 36 fe ff ff       	call   801024f0 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
801026ba:	8b 45 08             	mov    0x8(%ebp),%eax
801026bd:	8b 40 04             	mov    0x4(%eax),%eax
801026c0:	83 e0 01             	and    $0x1,%eax
801026c3:	89 c2                	mov    %eax,%edx
801026c5:	c1 e2 04             	shl    $0x4,%edx
801026c8:	8b 45 08             	mov    0x8(%ebp),%eax
801026cb:	8b 40 08             	mov    0x8(%eax),%eax
801026ce:	c1 e8 18             	shr    $0x18,%eax
801026d1:	83 e0 0f             	and    $0xf,%eax
801026d4:	09 d0                	or     %edx,%eax
801026d6:	83 c8 e0             	or     $0xffffffe0,%eax
801026d9:	0f b6 c0             	movzbl %al,%eax
801026dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801026e0:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026e7:	e8 04 fe ff ff       	call   801024f0 <outb>
  if(b->flags & B_DIRTY){
801026ec:	8b 45 08             	mov    0x8(%ebp),%eax
801026ef:	8b 00                	mov    (%eax),%eax
801026f1:	83 e0 04             	and    $0x4,%eax
801026f4:	85 c0                	test   %eax,%eax
801026f6:	74 34                	je     8010272c <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026f8:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026ff:	00 
80102700:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102707:	e8 e4 fd ff ff       	call   801024f0 <outb>
    outsl(0x1f0, b->data, 512/4);
8010270c:	8b 45 08             	mov    0x8(%ebp),%eax
8010270f:	83 c0 18             	add    $0x18,%eax
80102712:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102719:	00 
8010271a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010271e:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102725:	e8 e4 fd ff ff       	call   8010250e <outsl>
8010272a:	eb 14                	jmp    80102740 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
8010272c:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80102733:	00 
80102734:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010273b:	e8 b0 fd ff ff       	call   801024f0 <outb>
  }
}
80102740:	c9                   	leave  
80102741:	c3                   	ret    

80102742 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102742:	55                   	push   %ebp
80102743:	89 e5                	mov    %esp,%ebp
80102745:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102748:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010274f:	e8 9b 2b 00 00       	call   801052ef <acquire>
  if((b = idequeue) == 0){
80102754:	a1 34 c6 10 80       	mov    0x8010c634,%eax
80102759:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010275c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102760:	75 11                	jne    80102773 <ideintr+0x31>
    release(&idelock);
80102762:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80102769:	e8 e3 2b 00 00       	call   80105351 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010276e:	e9 90 00 00 00       	jmp    80102803 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102776:	8b 40 14             	mov    0x14(%eax),%eax
80102779:	a3 34 c6 10 80       	mov    %eax,0x8010c634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102781:	8b 00                	mov    (%eax),%eax
80102783:	83 e0 04             	and    $0x4,%eax
80102786:	85 c0                	test   %eax,%eax
80102788:	75 2e                	jne    801027b8 <ideintr+0x76>
8010278a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102791:	e8 9d fd ff ff       	call   80102533 <idewait>
80102796:	85 c0                	test   %eax,%eax
80102798:	78 1e                	js     801027b8 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
8010279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279d:	83 c0 18             	add    $0x18,%eax
801027a0:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801027a7:	00 
801027a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801027ac:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027b3:	e8 13 fd ff ff       	call   801024cb <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027bb:	8b 00                	mov    (%eax),%eax
801027bd:	89 c2                	mov    %eax,%edx
801027bf:	83 ca 02             	or     $0x2,%edx
801027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c5:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ca:	8b 00                	mov    (%eax),%eax
801027cc:	89 c2                	mov    %eax,%edx
801027ce:	83 e2 fb             	and    $0xfffffffb,%edx
801027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d4:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d9:	89 04 24             	mov    %eax,(%esp)
801027dc:	e8 0b 29 00 00       	call   801050ec <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027e1:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801027e6:	85 c0                	test   %eax,%eax
801027e8:	74 0d                	je     801027f7 <ideintr+0xb5>
    idestart(idequeue);
801027ea:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801027ef:	89 04 24             	mov    %eax,(%esp)
801027f2:	e8 26 fe ff ff       	call   8010261d <idestart>

  release(&idelock);
801027f7:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
801027fe:	e8 4e 2b 00 00       	call   80105351 <release>
}
80102803:	c9                   	leave  
80102804:	c3                   	ret    

80102805 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102805:	55                   	push   %ebp
80102806:	89 e5                	mov    %esp,%ebp
80102808:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010280b:	8b 45 08             	mov    0x8(%ebp),%eax
8010280e:	8b 00                	mov    (%eax),%eax
80102810:	83 e0 01             	and    $0x1,%eax
80102813:	85 c0                	test   %eax,%eax
80102815:	75 0c                	jne    80102823 <iderw+0x1e>
    panic("iderw: buf not busy");
80102817:	c7 04 24 61 8b 10 80 	movl   $0x80108b61,(%esp)
8010281e:	e8 23 dd ff ff       	call   80100546 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102823:	8b 45 08             	mov    0x8(%ebp),%eax
80102826:	8b 00                	mov    (%eax),%eax
80102828:	83 e0 06             	and    $0x6,%eax
8010282b:	83 f8 02             	cmp    $0x2,%eax
8010282e:	75 0c                	jne    8010283c <iderw+0x37>
    panic("iderw: nothing to do");
80102830:	c7 04 24 75 8b 10 80 	movl   $0x80108b75,(%esp)
80102837:	e8 0a dd ff ff       	call   80100546 <panic>
  if(b->dev != 0 && !havedisk1)
8010283c:	8b 45 08             	mov    0x8(%ebp),%eax
8010283f:	8b 40 04             	mov    0x4(%eax),%eax
80102842:	85 c0                	test   %eax,%eax
80102844:	74 15                	je     8010285b <iderw+0x56>
80102846:	a1 38 c6 10 80       	mov    0x8010c638,%eax
8010284b:	85 c0                	test   %eax,%eax
8010284d:	75 0c                	jne    8010285b <iderw+0x56>
    panic("iderw: ide disk 1 not present");
8010284f:	c7 04 24 8a 8b 10 80 	movl   $0x80108b8a,(%esp)
80102856:	e8 eb dc ff ff       	call   80100546 <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010285b:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80102862:	e8 88 2a 00 00       	call   801052ef <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102867:	8b 45 08             	mov    0x8(%ebp),%eax
8010286a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102871:	c7 45 f4 34 c6 10 80 	movl   $0x8010c634,-0xc(%ebp)
80102878:	eb 0b                	jmp    80102885 <iderw+0x80>
8010287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287d:	8b 00                	mov    (%eax),%eax
8010287f:	83 c0 14             	add    $0x14,%eax
80102882:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102885:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102888:	8b 00                	mov    (%eax),%eax
8010288a:	85 c0                	test   %eax,%eax
8010288c:	75 ec                	jne    8010287a <iderw+0x75>
    ;
  *pp = b;
8010288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102891:	8b 55 08             	mov    0x8(%ebp),%edx
80102894:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102896:	a1 34 c6 10 80       	mov    0x8010c634,%eax
8010289b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010289e:	75 22                	jne    801028c2 <iderw+0xbd>
    idestart(b);
801028a0:	8b 45 08             	mov    0x8(%ebp),%eax
801028a3:	89 04 24             	mov    %eax,(%esp)
801028a6:	e8 72 fd ff ff       	call   8010261d <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028ab:	eb 15                	jmp    801028c2 <iderw+0xbd>
    sleep(b, &idelock);
801028ad:	c7 44 24 04 00 c6 10 	movl   $0x8010c600,0x4(%esp)
801028b4:	80 
801028b5:	8b 45 08             	mov    0x8(%ebp),%eax
801028b8:	89 04 24             	mov    %eax,(%esp)
801028bb:	e8 53 27 00 00       	call   80105013 <sleep>
801028c0:	eb 01                	jmp    801028c3 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028c2:	90                   	nop
801028c3:	8b 45 08             	mov    0x8(%ebp),%eax
801028c6:	8b 00                	mov    (%eax),%eax
801028c8:	83 e0 06             	and    $0x6,%eax
801028cb:	83 f8 02             	cmp    $0x2,%eax
801028ce:	75 dd                	jne    801028ad <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
801028d0:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
801028d7:	e8 75 2a 00 00       	call   80105351 <release>
}
801028dc:	c9                   	leave  
801028dd:	c3                   	ret    

801028de <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801028de:	55                   	push   %ebp
801028df:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028e1:	a1 14 32 11 80       	mov    0x80113214,%eax
801028e6:	8b 55 08             	mov    0x8(%ebp),%edx
801028e9:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028eb:	a1 14 32 11 80       	mov    0x80113214,%eax
801028f0:	8b 40 10             	mov    0x10(%eax),%eax
}
801028f3:	5d                   	pop    %ebp
801028f4:	c3                   	ret    

801028f5 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028f5:	55                   	push   %ebp
801028f6:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028f8:	a1 14 32 11 80       	mov    0x80113214,%eax
801028fd:	8b 55 08             	mov    0x8(%ebp),%edx
80102900:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102902:	a1 14 32 11 80       	mov    0x80113214,%eax
80102907:	8b 55 0c             	mov    0xc(%ebp),%edx
8010290a:	89 50 10             	mov    %edx,0x10(%eax)
}
8010290d:	5d                   	pop    %ebp
8010290e:	c3                   	ret    

8010290f <ioapicinit>:

void
ioapicinit(void)
{
8010290f:	55                   	push   %ebp
80102910:	89 e5                	mov    %esp,%ebp
80102912:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102915:	a1 44 33 11 80       	mov    0x80113344,%eax
8010291a:	85 c0                	test   %eax,%eax
8010291c:	0f 84 9f 00 00 00    	je     801029c1 <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102922:	c7 05 14 32 11 80 00 	movl   $0xfec00000,0x80113214
80102929:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010292c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102933:	e8 a6 ff ff ff       	call   801028de <ioapicread>
80102938:	c1 e8 10             	shr    $0x10,%eax
8010293b:	25 ff 00 00 00       	and    $0xff,%eax
80102940:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102943:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010294a:	e8 8f ff ff ff       	call   801028de <ioapicread>
8010294f:	c1 e8 18             	shr    $0x18,%eax
80102952:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102955:	0f b6 05 40 33 11 80 	movzbl 0x80113340,%eax
8010295c:	0f b6 c0             	movzbl %al,%eax
8010295f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102962:	74 0c                	je     80102970 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102964:	c7 04 24 a8 8b 10 80 	movl   $0x80108ba8,(%esp)
8010296b:	e8 3a da ff ff       	call   801003aa <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102970:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102977:	eb 3e                	jmp    801029b7 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102979:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010297c:	83 c0 20             	add    $0x20,%eax
8010297f:	0d 00 00 01 00       	or     $0x10000,%eax
80102984:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102987:	83 c2 08             	add    $0x8,%edx
8010298a:	01 d2                	add    %edx,%edx
8010298c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102990:	89 14 24             	mov    %edx,(%esp)
80102993:	e8 5d ff ff ff       	call   801028f5 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010299b:	83 c0 08             	add    $0x8,%eax
8010299e:	01 c0                	add    %eax,%eax
801029a0:	83 c0 01             	add    $0x1,%eax
801029a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801029aa:	00 
801029ab:	89 04 24             	mov    %eax,(%esp)
801029ae:	e8 42 ff ff ff       	call   801028f5 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029bd:	7e ba                	jle    80102979 <ioapicinit+0x6a>
801029bf:	eb 01                	jmp    801029c2 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
801029c1:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029c2:	c9                   	leave  
801029c3:	c3                   	ret    

801029c4 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029c4:	55                   	push   %ebp
801029c5:	89 e5                	mov    %esp,%ebp
801029c7:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801029ca:	a1 44 33 11 80       	mov    0x80113344,%eax
801029cf:	85 c0                	test   %eax,%eax
801029d1:	74 39                	je     80102a0c <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029d3:	8b 45 08             	mov    0x8(%ebp),%eax
801029d6:	83 c0 20             	add    $0x20,%eax
801029d9:	8b 55 08             	mov    0x8(%ebp),%edx
801029dc:	83 c2 08             	add    $0x8,%edx
801029df:	01 d2                	add    %edx,%edx
801029e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e5:	89 14 24             	mov    %edx,(%esp)
801029e8:	e8 08 ff ff ff       	call   801028f5 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801029f0:	c1 e0 18             	shl    $0x18,%eax
801029f3:	8b 55 08             	mov    0x8(%ebp),%edx
801029f6:	83 c2 08             	add    $0x8,%edx
801029f9:	01 d2                	add    %edx,%edx
801029fb:	83 c2 01             	add    $0x1,%edx
801029fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a02:	89 14 24             	mov    %edx,(%esp)
80102a05:	e8 eb fe ff ff       	call   801028f5 <ioapicwrite>
80102a0a:	eb 01                	jmp    80102a0d <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102a0c:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102a0d:	c9                   	leave  
80102a0e:	c3                   	ret    

80102a0f <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a0f:	55                   	push   %ebp
80102a10:	89 e5                	mov    %esp,%ebp
80102a12:	8b 45 08             	mov    0x8(%ebp),%eax
80102a15:	05 00 00 00 80       	add    $0x80000000,%eax
80102a1a:	5d                   	pop    %ebp
80102a1b:	c3                   	ret    

80102a1c <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a1c:	55                   	push   %ebp
80102a1d:	89 e5                	mov    %esp,%ebp
80102a1f:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a22:	c7 44 24 04 da 8b 10 	movl   $0x80108bda,0x4(%esp)
80102a29:	80 
80102a2a:	c7 04 24 20 32 11 80 	movl   $0x80113220,(%esp)
80102a31:	e8 98 28 00 00       	call   801052ce <initlock>
  kmem.use_lock = 0;
80102a36:	c7 05 54 32 11 80 00 	movl   $0x0,0x80113254
80102a3d:	00 00 00 
  freerange(vstart, vend);
80102a40:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a43:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a47:	8b 45 08             	mov    0x8(%ebp),%eax
80102a4a:	89 04 24             	mov    %eax,(%esp)
80102a4d:	e8 26 00 00 00       	call   80102a78 <freerange>
}
80102a52:	c9                   	leave  
80102a53:	c3                   	ret    

80102a54 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a54:	55                   	push   %ebp
80102a55:	89 e5                	mov    %esp,%ebp
80102a57:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a61:	8b 45 08             	mov    0x8(%ebp),%eax
80102a64:	89 04 24             	mov    %eax,(%esp)
80102a67:	e8 0c 00 00 00       	call   80102a78 <freerange>
  kmem.use_lock = 1;
80102a6c:	c7 05 54 32 11 80 01 	movl   $0x1,0x80113254
80102a73:	00 00 00 
}
80102a76:	c9                   	leave  
80102a77:	c3                   	ret    

80102a78 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a78:	55                   	push   %ebp
80102a79:	89 e5                	mov    %esp,%ebp
80102a7b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a81:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a8e:	eb 12                	jmp    80102aa2 <freerange+0x2a>
    kfree(p);
80102a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a93:	89 04 24             	mov    %eax,(%esp)
80102a96:	e8 16 00 00 00       	call   80102ab1 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a9b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa5:	05 00 10 00 00       	add    $0x1000,%eax
80102aaa:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102aad:	76 e1                	jbe    80102a90 <freerange+0x18>
    kfree(p);
}
80102aaf:	c9                   	leave  
80102ab0:	c3                   	ret    

80102ab1 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ab1:	55                   	push   %ebp
80102ab2:	89 e5                	mov    %esp,%ebp
80102ab4:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80102aba:	25 ff 0f 00 00       	and    $0xfff,%eax
80102abf:	85 c0                	test   %eax,%eax
80102ac1:	75 1b                	jne    80102ade <kfree+0x2d>
80102ac3:	81 7d 08 3c 61 11 80 	cmpl   $0x8011613c,0x8(%ebp)
80102aca:	72 12                	jb     80102ade <kfree+0x2d>
80102acc:	8b 45 08             	mov    0x8(%ebp),%eax
80102acf:	89 04 24             	mov    %eax,(%esp)
80102ad2:	e8 38 ff ff ff       	call   80102a0f <v2p>
80102ad7:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102adc:	76 0c                	jbe    80102aea <kfree+0x39>
    panic("kfree");
80102ade:	c7 04 24 df 8b 10 80 	movl   $0x80108bdf,(%esp)
80102ae5:	e8 5c da ff ff       	call   80100546 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102aea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102af1:	00 
80102af2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102af9:	00 
80102afa:	8b 45 08             	mov    0x8(%ebp),%eax
80102afd:	89 04 24             	mov    %eax,(%esp)
80102b00:	e8 42 2a 00 00       	call   80105547 <memset>

  if(kmem.use_lock)
80102b05:	a1 54 32 11 80       	mov    0x80113254,%eax
80102b0a:	85 c0                	test   %eax,%eax
80102b0c:	74 0c                	je     80102b1a <kfree+0x69>
    acquire(&kmem.lock);
80102b0e:	c7 04 24 20 32 11 80 	movl   $0x80113220,(%esp)
80102b15:	e8 d5 27 00 00       	call   801052ef <acquire>
  r = (struct run*)v;
80102b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80102b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b20:	8b 15 58 32 11 80    	mov    0x80113258,%edx
80102b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b29:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2e:	a3 58 32 11 80       	mov    %eax,0x80113258
  if(kmem.use_lock)
80102b33:	a1 54 32 11 80       	mov    0x80113254,%eax
80102b38:	85 c0                	test   %eax,%eax
80102b3a:	74 0c                	je     80102b48 <kfree+0x97>
    release(&kmem.lock);
80102b3c:	c7 04 24 20 32 11 80 	movl   $0x80113220,(%esp)
80102b43:	e8 09 28 00 00       	call   80105351 <release>
}
80102b48:	c9                   	leave  
80102b49:	c3                   	ret    

80102b4a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b4a:	55                   	push   %ebp
80102b4b:	89 e5                	mov    %esp,%ebp
80102b4d:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b50:	a1 54 32 11 80       	mov    0x80113254,%eax
80102b55:	85 c0                	test   %eax,%eax
80102b57:	74 0c                	je     80102b65 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b59:	c7 04 24 20 32 11 80 	movl   $0x80113220,(%esp)
80102b60:	e8 8a 27 00 00       	call   801052ef <acquire>
  r = kmem.freelist;
80102b65:	a1 58 32 11 80       	mov    0x80113258,%eax
80102b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b71:	74 0a                	je     80102b7d <kalloc+0x33>
    kmem.freelist = r->next;
80102b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b76:	8b 00                	mov    (%eax),%eax
80102b78:	a3 58 32 11 80       	mov    %eax,0x80113258
  if(kmem.use_lock)
80102b7d:	a1 54 32 11 80       	mov    0x80113254,%eax
80102b82:	85 c0                	test   %eax,%eax
80102b84:	74 0c                	je     80102b92 <kalloc+0x48>
    release(&kmem.lock);
80102b86:	c7 04 24 20 32 11 80 	movl   $0x80113220,(%esp)
80102b8d:	e8 bf 27 00 00       	call   80105351 <release>
  return (char*)r;
80102b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b95:	c9                   	leave  
80102b96:	c3                   	ret    

80102b97 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b97:	55                   	push   %ebp
80102b98:	89 e5                	mov    %esp,%ebp
80102b9a:	53                   	push   %ebx
80102b9b:	83 ec 14             	sub    $0x14,%esp
80102b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba1:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba5:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80102ba9:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102bad:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80102bb1:	ec                   	in     (%dx),%al
80102bb2:	89 c3                	mov    %eax,%ebx
80102bb4:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102bb7:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80102bbb:	83 c4 14             	add    $0x14,%esp
80102bbe:	5b                   	pop    %ebx
80102bbf:	5d                   	pop    %ebp
80102bc0:	c3                   	ret    

80102bc1 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102bc1:	55                   	push   %ebp
80102bc2:	89 e5                	mov    %esp,%ebp
80102bc4:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102bc7:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102bce:	e8 c4 ff ff ff       	call   80102b97 <inb>
80102bd3:	0f b6 c0             	movzbl %al,%eax
80102bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bdc:	83 e0 01             	and    $0x1,%eax
80102bdf:	85 c0                	test   %eax,%eax
80102be1:	75 0a                	jne    80102bed <kbdgetc+0x2c>
    return -1;
80102be3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102be8:	e9 25 01 00 00       	jmp    80102d12 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102bed:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102bf4:	e8 9e ff ff ff       	call   80102b97 <inb>
80102bf9:	0f b6 c0             	movzbl %al,%eax
80102bfc:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102bff:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c06:	75 17                	jne    80102c1f <kbdgetc+0x5e>
    shift |= E0ESC;
80102c08:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102c0d:	83 c8 40             	or     $0x40,%eax
80102c10:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102c15:	b8 00 00 00 00       	mov    $0x0,%eax
80102c1a:	e9 f3 00 00 00       	jmp    80102d12 <kbdgetc+0x151>
  } else if(data & 0x80){
80102c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c22:	25 80 00 00 00       	and    $0x80,%eax
80102c27:	85 c0                	test   %eax,%eax
80102c29:	74 45                	je     80102c70 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c2b:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102c30:	83 e0 40             	and    $0x40,%eax
80102c33:	85 c0                	test   %eax,%eax
80102c35:	75 08                	jne    80102c3f <kbdgetc+0x7e>
80102c37:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c3a:	83 e0 7f             	and    $0x7f,%eax
80102c3d:	eb 03                	jmp    80102c42 <kbdgetc+0x81>
80102c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c48:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c4d:	0f b6 00             	movzbl (%eax),%eax
80102c50:	83 c8 40             	or     $0x40,%eax
80102c53:	0f b6 c0             	movzbl %al,%eax
80102c56:	f7 d0                	not    %eax
80102c58:	89 c2                	mov    %eax,%edx
80102c5a:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102c5f:	21 d0                	and    %edx,%eax
80102c61:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
    return 0;
80102c66:	b8 00 00 00 00       	mov    $0x0,%eax
80102c6b:	e9 a2 00 00 00       	jmp    80102d12 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c70:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102c75:	83 e0 40             	and    $0x40,%eax
80102c78:	85 c0                	test   %eax,%eax
80102c7a:	74 14                	je     80102c90 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c7c:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c83:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102c88:	83 e0 bf             	and    $0xffffffbf,%eax
80102c8b:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  }

  shift |= shiftcode[data];
80102c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c93:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c98:	0f b6 00             	movzbl (%eax),%eax
80102c9b:	0f b6 d0             	movzbl %al,%edx
80102c9e:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102ca3:	09 d0                	or     %edx,%eax
80102ca5:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  shift ^= togglecode[data];
80102caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cad:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102cb2:	0f b6 00             	movzbl (%eax),%eax
80102cb5:	0f b6 d0             	movzbl %al,%edx
80102cb8:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102cbd:	31 d0                	xor    %edx,%eax
80102cbf:	a3 3c c6 10 80       	mov    %eax,0x8010c63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102cc4:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102cc9:	83 e0 03             	and    $0x3,%eax
80102ccc:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd6:	01 d0                	add    %edx,%eax
80102cd8:	0f b6 00             	movzbl (%eax),%eax
80102cdb:	0f b6 c0             	movzbl %al,%eax
80102cde:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102ce1:	a1 3c c6 10 80       	mov    0x8010c63c,%eax
80102ce6:	83 e0 08             	and    $0x8,%eax
80102ce9:	85 c0                	test   %eax,%eax
80102ceb:	74 22                	je     80102d0f <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102ced:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102cf1:	76 0c                	jbe    80102cff <kbdgetc+0x13e>
80102cf3:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102cf7:	77 06                	ja     80102cff <kbdgetc+0x13e>
      c += 'A' - 'a';
80102cf9:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102cfd:	eb 10                	jmp    80102d0f <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102cff:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d03:	76 0a                	jbe    80102d0f <kbdgetc+0x14e>
80102d05:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d09:	77 04                	ja     80102d0f <kbdgetc+0x14e>
      c += 'a' - 'A';
80102d0b:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d12:	c9                   	leave  
80102d13:	c3                   	ret    

80102d14 <kbdintr>:

void
kbdintr(void)
{
80102d14:	55                   	push   %ebp
80102d15:	89 e5                	mov    %esp,%ebp
80102d17:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d1a:	c7 04 24 c1 2b 10 80 	movl   $0x80102bc1,(%esp)
80102d21:	e8 90 da ff ff       	call   801007b6 <consoleintr>
}
80102d26:	c9                   	leave  
80102d27:	c3                   	ret    

80102d28 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d28:	55                   	push   %ebp
80102d29:	89 e5                	mov    %esp,%ebp
80102d2b:	53                   	push   %ebx
80102d2c:	83 ec 14             	sub    $0x14,%esp
80102d2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d32:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d36:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80102d3a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102d3e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80102d42:	ec                   	in     (%dx),%al
80102d43:	89 c3                	mov    %eax,%ebx
80102d45:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102d48:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80102d4c:	83 c4 14             	add    $0x14,%esp
80102d4f:	5b                   	pop    %ebx
80102d50:	5d                   	pop    %ebp
80102d51:	c3                   	ret    

80102d52 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d52:	55                   	push   %ebp
80102d53:	89 e5                	mov    %esp,%ebp
80102d55:	83 ec 08             	sub    $0x8,%esp
80102d58:	8b 55 08             	mov    0x8(%ebp),%edx
80102d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d5e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d62:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d65:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d69:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d6d:	ee                   	out    %al,(%dx)
}
80102d6e:	c9                   	leave  
80102d6f:	c3                   	ret    

80102d70 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d77:	9c                   	pushf  
80102d78:	5b                   	pop    %ebx
80102d79:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102d7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d7f:	83 c4 10             	add    $0x10,%esp
80102d82:	5b                   	pop    %ebx
80102d83:	5d                   	pop    %ebp
80102d84:	c3                   	ret    

80102d85 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d85:	55                   	push   %ebp
80102d86:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d88:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102d8d:	8b 55 08             	mov    0x8(%ebp),%edx
80102d90:	c1 e2 02             	shl    $0x2,%edx
80102d93:	01 c2                	add    %eax,%edx
80102d95:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d98:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d9a:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102d9f:	83 c0 20             	add    $0x20,%eax
80102da2:	8b 00                	mov    (%eax),%eax
}
80102da4:	5d                   	pop    %ebp
80102da5:	c3                   	ret    

80102da6 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102da6:	55                   	push   %ebp
80102da7:	89 e5                	mov    %esp,%ebp
80102da9:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102dac:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102db1:	85 c0                	test   %eax,%eax
80102db3:	0f 84 47 01 00 00    	je     80102f00 <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102db9:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102dc0:	00 
80102dc1:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102dc8:	e8 b8 ff ff ff       	call   80102d85 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102dcd:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102dd4:	00 
80102dd5:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102ddc:	e8 a4 ff ff ff       	call   80102d85 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102de1:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102de8:	00 
80102de9:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102df0:	e8 90 ff ff ff       	call   80102d85 <lapicw>
  lapicw(TICR, 10000000); 
80102df5:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102dfc:	00 
80102dfd:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e04:	e8 7c ff ff ff       	call   80102d85 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e09:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e10:	00 
80102e11:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e18:	e8 68 ff ff ff       	call   80102d85 <lapicw>
  lapicw(LINT1, MASKED);
80102e1d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e24:	00 
80102e25:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e2c:	e8 54 ff ff ff       	call   80102d85 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e31:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102e36:	83 c0 30             	add    $0x30,%eax
80102e39:	8b 00                	mov    (%eax),%eax
80102e3b:	c1 e8 10             	shr    $0x10,%eax
80102e3e:	25 ff 00 00 00       	and    $0xff,%eax
80102e43:	83 f8 03             	cmp    $0x3,%eax
80102e46:	76 14                	jbe    80102e5c <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102e48:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e4f:	00 
80102e50:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e57:	e8 29 ff ff ff       	call   80102d85 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e5c:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e63:	00 
80102e64:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e6b:	e8 15 ff ff ff       	call   80102d85 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e77:	00 
80102e78:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e7f:	e8 01 ff ff ff       	call   80102d85 <lapicw>
  lapicw(ESR, 0);
80102e84:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e8b:	00 
80102e8c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e93:	e8 ed fe ff ff       	call   80102d85 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e9f:	00 
80102ea0:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ea7:	e8 d9 fe ff ff       	call   80102d85 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102eac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eb3:	00 
80102eb4:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ebb:	e8 c5 fe ff ff       	call   80102d85 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ec0:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102ec7:	00 
80102ec8:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ecf:	e8 b1 fe ff ff       	call   80102d85 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102ed4:	90                   	nop
80102ed5:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102eda:	05 00 03 00 00       	add    $0x300,%eax
80102edf:	8b 00                	mov    (%eax),%eax
80102ee1:	25 00 10 00 00       	and    $0x1000,%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	75 eb                	jne    80102ed5 <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102eea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ef1:	00 
80102ef2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102ef9:	e8 87 fe ff ff       	call   80102d85 <lapicw>
80102efe:	eb 01                	jmp    80102f01 <lapicinit+0x15b>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102f00:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f01:	c9                   	leave  
80102f02:	c3                   	ret    

80102f03 <cpunum>:

int
cpunum(void)
{
80102f03:	55                   	push   %ebp
80102f04:	89 e5                	mov    %esp,%ebp
80102f06:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f09:	e8 62 fe ff ff       	call   80102d70 <readeflags>
80102f0e:	25 00 02 00 00       	and    $0x200,%eax
80102f13:	85 c0                	test   %eax,%eax
80102f15:	74 29                	je     80102f40 <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102f17:	a1 40 c6 10 80       	mov    0x8010c640,%eax
80102f1c:	85 c0                	test   %eax,%eax
80102f1e:	0f 94 c2             	sete   %dl
80102f21:	83 c0 01             	add    $0x1,%eax
80102f24:	a3 40 c6 10 80       	mov    %eax,0x8010c640
80102f29:	84 d2                	test   %dl,%dl
80102f2b:	74 13                	je     80102f40 <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f2d:	8b 45 04             	mov    0x4(%ebp),%eax
80102f30:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f34:	c7 04 24 e8 8b 10 80 	movl   $0x80108be8,(%esp)
80102f3b:	e8 6a d4 ff ff       	call   801003aa <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102f40:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102f45:	85 c0                	test   %eax,%eax
80102f47:	74 0f                	je     80102f58 <cpunum+0x55>
    return lapic[ID]>>24;
80102f49:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102f4e:	83 c0 20             	add    $0x20,%eax
80102f51:	8b 00                	mov    (%eax),%eax
80102f53:	c1 e8 18             	shr    $0x18,%eax
80102f56:	eb 05                	jmp    80102f5d <cpunum+0x5a>
  return 0;
80102f58:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f5d:	c9                   	leave  
80102f5e:	c3                   	ret    

80102f5f <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f5f:	55                   	push   %ebp
80102f60:	89 e5                	mov    %esp,%ebp
80102f62:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f65:	a1 5c 32 11 80       	mov    0x8011325c,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	74 14                	je     80102f82 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f6e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f75:	00 
80102f76:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f7d:	e8 03 fe ff ff       	call   80102d85 <lapicw>
}
80102f82:	c9                   	leave  
80102f83:	c3                   	ret    

80102f84 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f84:	55                   	push   %ebp
80102f85:	89 e5                	mov    %esp,%ebp
}
80102f87:	5d                   	pop    %ebp
80102f88:	c3                   	ret    

80102f89 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f89:	55                   	push   %ebp
80102f8a:	89 e5                	mov    %esp,%ebp
80102f8c:	83 ec 1c             	sub    $0x1c,%esp
80102f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80102f92:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f95:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f9c:	00 
80102f9d:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102fa4:	e8 a9 fd ff ff       	call   80102d52 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102fa9:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fb0:	00 
80102fb1:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102fb8:	e8 95 fd ff ff       	call   80102d52 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102fbd:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fc7:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fcf:	8d 50 02             	lea    0x2(%eax),%edx
80102fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fd5:	c1 e8 04             	shr    $0x4,%eax
80102fd8:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fdb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fdf:	c1 e0 18             	shl    $0x18,%eax
80102fe2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe6:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fed:	e8 93 fd ff ff       	call   80102d85 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102ff2:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102ff9:	00 
80102ffa:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103001:	e8 7f fd ff ff       	call   80102d85 <lapicw>
  microdelay(200);
80103006:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010300d:	e8 72 ff ff ff       	call   80102f84 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103012:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80103019:	00 
8010301a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103021:	e8 5f fd ff ff       	call   80102d85 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103026:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010302d:	e8 52 ff ff ff       	call   80102f84 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103039:	eb 40                	jmp    8010307b <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
8010303b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010303f:	c1 e0 18             	shl    $0x18,%eax
80103042:	89 44 24 04          	mov    %eax,0x4(%esp)
80103046:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010304d:	e8 33 fd ff ff       	call   80102d85 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103052:	8b 45 0c             	mov    0xc(%ebp),%eax
80103055:	c1 e8 0c             	shr    $0xc,%eax
80103058:	80 cc 06             	or     $0x6,%ah
8010305b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010305f:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103066:	e8 1a fd ff ff       	call   80102d85 <lapicw>
    microdelay(200);
8010306b:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103072:	e8 0d ff ff ff       	call   80102f84 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103077:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010307b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010307f:	7e ba                	jle    8010303b <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103081:	c9                   	leave  
80103082:	c3                   	ret    

80103083 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103083:	55                   	push   %ebp
80103084:	89 e5                	mov    %esp,%ebp
80103086:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103089:	8b 45 08             	mov    0x8(%ebp),%eax
8010308c:	0f b6 c0             	movzbl %al,%eax
8010308f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103093:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010309a:	e8 b3 fc ff ff       	call   80102d52 <outb>
  microdelay(200);
8010309f:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030a6:	e8 d9 fe ff ff       	call   80102f84 <microdelay>

  return inb(CMOS_RETURN);
801030ab:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030b2:	e8 71 fc ff ff       	call   80102d28 <inb>
801030b7:	0f b6 c0             	movzbl %al,%eax
}
801030ba:	c9                   	leave  
801030bb:	c3                   	ret    

801030bc <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030bc:	55                   	push   %ebp
801030bd:	89 e5                	mov    %esp,%ebp
801030bf:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801030c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801030c9:	e8 b5 ff ff ff       	call   80103083 <cmos_read>
801030ce:	8b 55 08             	mov    0x8(%ebp),%edx
801030d1:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801030d3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801030da:	e8 a4 ff ff ff       	call   80103083 <cmos_read>
801030df:	8b 55 08             	mov    0x8(%ebp),%edx
801030e2:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801030e5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801030ec:	e8 92 ff ff ff       	call   80103083 <cmos_read>
801030f1:	8b 55 08             	mov    0x8(%ebp),%edx
801030f4:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801030f7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
801030fe:	e8 80 ff ff ff       	call   80103083 <cmos_read>
80103103:	8b 55 08             	mov    0x8(%ebp),%edx
80103106:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103109:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103110:	e8 6e ff ff ff       	call   80103083 <cmos_read>
80103115:	8b 55 08             	mov    0x8(%ebp),%edx
80103118:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010311b:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103122:	e8 5c ff ff ff       	call   80103083 <cmos_read>
80103127:	8b 55 08             	mov    0x8(%ebp),%edx
8010312a:	89 42 14             	mov    %eax,0x14(%edx)
}
8010312d:	c9                   	leave  
8010312e:	c3                   	ret    

8010312f <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010312f:	55                   	push   %ebp
80103130:	89 e5                	mov    %esp,%ebp
80103132:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103135:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
8010313c:	e8 42 ff ff ff       	call   80103083 <cmos_read>
80103141:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103147:	83 e0 04             	and    $0x4,%eax
8010314a:	85 c0                	test   %eax,%eax
8010314c:	0f 94 c0             	sete   %al
8010314f:	0f b6 c0             	movzbl %al,%eax
80103152:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103155:	eb 01                	jmp    80103158 <cmostime+0x29>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103157:	90                   	nop

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103158:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010315b:	89 04 24             	mov    %eax,(%esp)
8010315e:	e8 59 ff ff ff       	call   801030bc <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103163:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010316a:	e8 14 ff ff ff       	call   80103083 <cmos_read>
8010316f:	25 80 00 00 00       	and    $0x80,%eax
80103174:	85 c0                	test   %eax,%eax
80103176:	75 2b                	jne    801031a3 <cmostime+0x74>
        continue;
    fill_rtcdate(&t2);
80103178:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010317b:	89 04 24             	mov    %eax,(%esp)
8010317e:	e8 39 ff ff ff       	call   801030bc <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103183:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010318a:	00 
8010318b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010318e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103192:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103195:	89 04 24             	mov    %eax,(%esp)
80103198:	e8 21 24 00 00       	call   801055be <memcmp>
8010319d:	85 c0                	test   %eax,%eax
8010319f:	75 b6                	jne    80103157 <cmostime+0x28>
      break;
801031a1:	eb 03                	jmp    801031a6 <cmostime+0x77>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801031a3:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031a4:	eb b1                	jmp    80103157 <cmostime+0x28>

  // convert
  if (bcd) {
801031a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801031aa:	0f 84 a8 00 00 00    	je     80103258 <cmostime+0x129>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031b3:	89 c2                	mov    %eax,%edx
801031b5:	c1 ea 04             	shr    $0x4,%edx
801031b8:	89 d0                	mov    %edx,%eax
801031ba:	c1 e0 02             	shl    $0x2,%eax
801031bd:	01 d0                	add    %edx,%eax
801031bf:	01 c0                	add    %eax,%eax
801031c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031c4:	83 e2 0f             	and    $0xf,%edx
801031c7:	01 d0                	add    %edx,%eax
801031c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801031cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031cf:	89 c2                	mov    %eax,%edx
801031d1:	c1 ea 04             	shr    $0x4,%edx
801031d4:	89 d0                	mov    %edx,%eax
801031d6:	c1 e0 02             	shl    $0x2,%eax
801031d9:	01 d0                	add    %edx,%eax
801031db:	01 c0                	add    %eax,%eax
801031dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031e0:	83 e2 0f             	and    $0xf,%edx
801031e3:	01 d0                	add    %edx,%eax
801031e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801031e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031eb:	89 c2                	mov    %eax,%edx
801031ed:	c1 ea 04             	shr    $0x4,%edx
801031f0:	89 d0                	mov    %edx,%eax
801031f2:	c1 e0 02             	shl    $0x2,%eax
801031f5:	01 d0                	add    %edx,%eax
801031f7:	01 c0                	add    %eax,%eax
801031f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031fc:	83 e2 0f             	and    $0xf,%edx
801031ff:	01 d0                	add    %edx,%eax
80103201:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103207:	89 c2                	mov    %eax,%edx
80103209:	c1 ea 04             	shr    $0x4,%edx
8010320c:	89 d0                	mov    %edx,%eax
8010320e:	c1 e0 02             	shl    $0x2,%eax
80103211:	01 d0                	add    %edx,%eax
80103213:	01 c0                	add    %eax,%eax
80103215:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103218:	83 e2 0f             	and    $0xf,%edx
8010321b:	01 d0                	add    %edx,%eax
8010321d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103220:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103223:	89 c2                	mov    %eax,%edx
80103225:	c1 ea 04             	shr    $0x4,%edx
80103228:	89 d0                	mov    %edx,%eax
8010322a:	c1 e0 02             	shl    $0x2,%eax
8010322d:	01 d0                	add    %edx,%eax
8010322f:	01 c0                	add    %eax,%eax
80103231:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103234:	83 e2 0f             	and    $0xf,%edx
80103237:	01 d0                	add    %edx,%eax
80103239:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010323c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010323f:	89 c2                	mov    %eax,%edx
80103241:	c1 ea 04             	shr    $0x4,%edx
80103244:	89 d0                	mov    %edx,%eax
80103246:	c1 e0 02             	shl    $0x2,%eax
80103249:	01 d0                	add    %edx,%eax
8010324b:	01 c0                	add    %eax,%eax
8010324d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103250:	83 e2 0f             	and    $0xf,%edx
80103253:	01 d0                	add    %edx,%eax
80103255:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103258:	8b 45 08             	mov    0x8(%ebp),%eax
8010325b:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010325e:	89 10                	mov    %edx,(%eax)
80103260:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103263:	89 50 04             	mov    %edx,0x4(%eax)
80103266:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103269:	89 50 08             	mov    %edx,0x8(%eax)
8010326c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010326f:	89 50 0c             	mov    %edx,0xc(%eax)
80103272:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103275:	89 50 10             	mov    %edx,0x10(%eax)
80103278:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010327b:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010327e:	8b 45 08             	mov    0x8(%ebp),%eax
80103281:	8b 40 14             	mov    0x14(%eax),%eax
80103284:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010328a:	8b 45 08             	mov    0x8(%ebp),%eax
8010328d:	89 50 14             	mov    %edx,0x14(%eax)
}
80103290:	c9                   	leave  
80103291:	c3                   	ret    

80103292 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103292:	55                   	push   %ebp
80103293:	89 e5                	mov    %esp,%ebp
80103295:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103298:	c7 44 24 04 14 8c 10 	movl   $0x80108c14,0x4(%esp)
8010329f:	80 
801032a0:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
801032a7:	e8 22 20 00 00       	call   801052ce <initlock>
  readsb(ROOTDEV, &sb);
801032ac:	8d 45 e8             	lea    -0x18(%ebp),%eax
801032af:	89 44 24 04          	mov    %eax,0x4(%esp)
801032b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801032ba:	e8 5d e0 ff ff       	call   8010131c <readsb>
  log.start = sb.size - sb.nlog;
801032bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c5:	89 d1                	mov    %edx,%ecx
801032c7:	29 c1                	sub    %eax,%ecx
801032c9:	89 c8                	mov    %ecx,%eax
801032cb:	a3 94 32 11 80       	mov    %eax,0x80113294
  log.size = sb.nlog;
801032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032d3:	a3 98 32 11 80       	mov    %eax,0x80113298
  log.dev = ROOTDEV;
801032d8:	c7 05 a4 32 11 80 01 	movl   $0x1,0x801132a4
801032df:	00 00 00 
  recover_from_log();
801032e2:	e8 9a 01 00 00       	call   80103481 <recover_from_log>
}
801032e7:	c9                   	leave  
801032e8:	c3                   	ret    

801032e9 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801032e9:	55                   	push   %ebp
801032ea:	89 e5                	mov    %esp,%ebp
801032ec:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032f6:	e9 8c 00 00 00       	jmp    80103387 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032fb:	8b 15 94 32 11 80    	mov    0x80113294,%edx
80103301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103304:	01 d0                	add    %edx,%eax
80103306:	83 c0 01             	add    $0x1,%eax
80103309:	89 c2                	mov    %eax,%edx
8010330b:	a1 a4 32 11 80       	mov    0x801132a4,%eax
80103310:	89 54 24 04          	mov    %edx,0x4(%esp)
80103314:	89 04 24             	mov    %eax,(%esp)
80103317:	e8 8a ce ff ff       	call   801001a6 <bread>
8010331c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103322:	83 c0 10             	add    $0x10,%eax
80103325:	8b 04 85 6c 32 11 80 	mov    -0x7feecd94(,%eax,4),%eax
8010332c:	89 c2                	mov    %eax,%edx
8010332e:	a1 a4 32 11 80       	mov    0x801132a4,%eax
80103333:	89 54 24 04          	mov    %edx,0x4(%esp)
80103337:	89 04 24             	mov    %eax,(%esp)
8010333a:	e8 67 ce ff ff       	call   801001a6 <bread>
8010333f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103342:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103345:	8d 50 18             	lea    0x18(%eax),%edx
80103348:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010334b:	83 c0 18             	add    $0x18,%eax
8010334e:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103355:	00 
80103356:	89 54 24 04          	mov    %edx,0x4(%esp)
8010335a:	89 04 24             	mov    %eax,(%esp)
8010335d:	e8 b8 22 00 00       	call   8010561a <memmove>
    bwrite(dbuf);  // write dst to disk
80103362:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103365:	89 04 24             	mov    %eax,(%esp)
80103368:	e8 70 ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
8010336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103370:	89 04 24             	mov    %eax,(%esp)
80103373:	e8 9f ce ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103378:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010337b:	89 04 24             	mov    %eax,(%esp)
8010337e:	e8 94 ce ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103383:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103387:	a1 a8 32 11 80       	mov    0x801132a8,%eax
8010338c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010338f:	0f 8f 66 ff ff ff    	jg     801032fb <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103395:	c9                   	leave  
80103396:	c3                   	ret    

80103397 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103397:	55                   	push   %ebp
80103398:	89 e5                	mov    %esp,%ebp
8010339a:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010339d:	a1 94 32 11 80       	mov    0x80113294,%eax
801033a2:	89 c2                	mov    %eax,%edx
801033a4:	a1 a4 32 11 80       	mov    0x801132a4,%eax
801033a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801033ad:	89 04 24             	mov    %eax,(%esp)
801033b0:	e8 f1 cd ff ff       	call   801001a6 <bread>
801033b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033bb:	83 c0 18             	add    $0x18,%eax
801033be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033c4:	8b 00                	mov    (%eax),%eax
801033c6:	a3 a8 32 11 80       	mov    %eax,0x801132a8
  for (i = 0; i < log.lh.n; i++) {
801033cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033d2:	eb 1b                	jmp    801033ef <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
801033d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033da:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033e1:	83 c2 10             	add    $0x10,%edx
801033e4:	89 04 95 6c 32 11 80 	mov    %eax,-0x7feecd94(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801033eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033ef:	a1 a8 32 11 80       	mov    0x801132a8,%eax
801033f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033f7:	7f db                	jg     801033d4 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801033f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033fc:	89 04 24             	mov    %eax,(%esp)
801033ff:	e8 13 ce ff ff       	call   80100217 <brelse>
}
80103404:	c9                   	leave  
80103405:	c3                   	ret    

80103406 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103406:	55                   	push   %ebp
80103407:	89 e5                	mov    %esp,%ebp
80103409:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010340c:	a1 94 32 11 80       	mov    0x80113294,%eax
80103411:	89 c2                	mov    %eax,%edx
80103413:	a1 a4 32 11 80       	mov    0x801132a4,%eax
80103418:	89 54 24 04          	mov    %edx,0x4(%esp)
8010341c:	89 04 24             	mov    %eax,(%esp)
8010341f:	e8 82 cd ff ff       	call   801001a6 <bread>
80103424:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010342a:	83 c0 18             	add    $0x18,%eax
8010342d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103430:	8b 15 a8 32 11 80    	mov    0x801132a8,%edx
80103436:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103439:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010343b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103442:	eb 1b                	jmp    8010345f <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
80103444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103447:	83 c0 10             	add    $0x10,%eax
8010344a:	8b 0c 85 6c 32 11 80 	mov    -0x7feecd94(,%eax,4),%ecx
80103451:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103454:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103457:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010345b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010345f:	a1 a8 32 11 80       	mov    0x801132a8,%eax
80103464:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103467:	7f db                	jg     80103444 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103469:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010346c:	89 04 24             	mov    %eax,(%esp)
8010346f:	e8 69 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
80103474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103477:	89 04 24             	mov    %eax,(%esp)
8010347a:	e8 98 cd ff ff       	call   80100217 <brelse>
}
8010347f:	c9                   	leave  
80103480:	c3                   	ret    

80103481 <recover_from_log>:

static void
recover_from_log(void)
{
80103481:	55                   	push   %ebp
80103482:	89 e5                	mov    %esp,%ebp
80103484:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103487:	e8 0b ff ff ff       	call   80103397 <read_head>
  install_trans(); // if committed, copy from log to disk
8010348c:	e8 58 fe ff ff       	call   801032e9 <install_trans>
  log.lh.n = 0;
80103491:	c7 05 a8 32 11 80 00 	movl   $0x0,0x801132a8
80103498:	00 00 00 
  write_head(); // clear the log
8010349b:	e8 66 ff ff ff       	call   80103406 <write_head>
}
801034a0:	c9                   	leave  
801034a1:	c3                   	ret    

801034a2 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034a2:	55                   	push   %ebp
801034a3:	89 e5                	mov    %esp,%ebp
801034a5:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801034a8:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
801034af:	e8 3b 1e 00 00       	call   801052ef <acquire>
  while(1){
    if(log.committing){
801034b4:	a1 a0 32 11 80       	mov    0x801132a0,%eax
801034b9:	85 c0                	test   %eax,%eax
801034bb:	74 16                	je     801034d3 <begin_op+0x31>
      sleep(&log, &log.lock);
801034bd:	c7 44 24 04 60 32 11 	movl   $0x80113260,0x4(%esp)
801034c4:	80 
801034c5:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
801034cc:	e8 42 1b 00 00       	call   80105013 <sleep>
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
801034d1:	eb e1                	jmp    801034b4 <begin_op+0x12>
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034d3:	8b 0d a8 32 11 80    	mov    0x801132a8,%ecx
801034d9:	a1 9c 32 11 80       	mov    0x8011329c,%eax
801034de:	8d 50 01             	lea    0x1(%eax),%edx
801034e1:	89 d0                	mov    %edx,%eax
801034e3:	c1 e0 02             	shl    $0x2,%eax
801034e6:	01 d0                	add    %edx,%eax
801034e8:	01 c0                	add    %eax,%eax
801034ea:	01 c8                	add    %ecx,%eax
801034ec:	83 f8 1e             	cmp    $0x1e,%eax
801034ef:	7e 16                	jle    80103507 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034f1:	c7 44 24 04 60 32 11 	movl   $0x80113260,0x4(%esp)
801034f8:	80 
801034f9:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
80103500:	e8 0e 1b 00 00       	call   80105013 <sleep>
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
80103505:	eb ad                	jmp    801034b4 <begin_op+0x12>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80103507:	a1 9c 32 11 80       	mov    0x8011329c,%eax
8010350c:	83 c0 01             	add    $0x1,%eax
8010350f:	a3 9c 32 11 80       	mov    %eax,0x8011329c
      release(&log.lock);
80103514:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
8010351b:	e8 31 1e 00 00       	call   80105351 <release>
      break;
80103520:	90                   	nop
    }
  }
}
80103521:	c9                   	leave  
80103522:	c3                   	ret    

80103523 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103523:	55                   	push   %ebp
80103524:	89 e5                	mov    %esp,%ebp
80103526:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
80103529:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103530:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
80103537:	e8 b3 1d 00 00       	call   801052ef <acquire>
  log.outstanding -= 1;
8010353c:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103541:	83 e8 01             	sub    $0x1,%eax
80103544:	a3 9c 32 11 80       	mov    %eax,0x8011329c
  if(log.committing)
80103549:	a1 a0 32 11 80       	mov    0x801132a0,%eax
8010354e:	85 c0                	test   %eax,%eax
80103550:	74 0c                	je     8010355e <end_op+0x3b>
    panic("log.committing");
80103552:	c7 04 24 18 8c 10 80 	movl   $0x80108c18,(%esp)
80103559:	e8 e8 cf ff ff       	call   80100546 <panic>
  if(log.outstanding == 0){
8010355e:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103563:	85 c0                	test   %eax,%eax
80103565:	75 13                	jne    8010357a <end_op+0x57>
    do_commit = 1;
80103567:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010356e:	c7 05 a0 32 11 80 01 	movl   $0x1,0x801132a0
80103575:	00 00 00 
80103578:	eb 0c                	jmp    80103586 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010357a:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
80103581:	e8 66 1b 00 00       	call   801050ec <wakeup>
  }
  release(&log.lock);
80103586:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
8010358d:	e8 bf 1d 00 00       	call   80105351 <release>

  if(do_commit){
80103592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103596:	74 33                	je     801035cb <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103598:	e8 de 00 00 00       	call   8010367b <commit>
    acquire(&log.lock);
8010359d:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
801035a4:	e8 46 1d 00 00       	call   801052ef <acquire>
    log.committing = 0;
801035a9:	c7 05 a0 32 11 80 00 	movl   $0x0,0x801132a0
801035b0:	00 00 00 
    wakeup(&log);
801035b3:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
801035ba:	e8 2d 1b 00 00       	call   801050ec <wakeup>
    release(&log.lock);
801035bf:	c7 04 24 60 32 11 80 	movl   $0x80113260,(%esp)
801035c6:	e8 86 1d 00 00       	call   80105351 <release>
  }
}
801035cb:	c9                   	leave  
801035cc:	c3                   	ret    

801035cd <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801035cd:	55                   	push   %ebp
801035ce:	89 e5                	mov    %esp,%ebp
801035d0:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035da:	e9 8c 00 00 00       	jmp    8010366b <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035df:	8b 15 94 32 11 80    	mov    0x80113294,%edx
801035e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035e8:	01 d0                	add    %edx,%eax
801035ea:	83 c0 01             	add    $0x1,%eax
801035ed:	89 c2                	mov    %eax,%edx
801035ef:	a1 a4 32 11 80       	mov    0x801132a4,%eax
801035f4:	89 54 24 04          	mov    %edx,0x4(%esp)
801035f8:	89 04 24             	mov    %eax,(%esp)
801035fb:	e8 a6 cb ff ff       	call   801001a6 <bread>
80103600:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
80103603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103606:	83 c0 10             	add    $0x10,%eax
80103609:	8b 04 85 6c 32 11 80 	mov    -0x7feecd94(,%eax,4),%eax
80103610:	89 c2                	mov    %eax,%edx
80103612:	a1 a4 32 11 80       	mov    0x801132a4,%eax
80103617:	89 54 24 04          	mov    %edx,0x4(%esp)
8010361b:	89 04 24             	mov    %eax,(%esp)
8010361e:	e8 83 cb ff ff       	call   801001a6 <bread>
80103623:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103626:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103629:	8d 50 18             	lea    0x18(%eax),%edx
8010362c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010362f:	83 c0 18             	add    $0x18,%eax
80103632:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103639:	00 
8010363a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010363e:	89 04 24             	mov    %eax,(%esp)
80103641:	e8 d4 1f 00 00       	call   8010561a <memmove>
    bwrite(to);  // write the log
80103646:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103649:	89 04 24             	mov    %eax,(%esp)
8010364c:	e8 8c cb ff ff       	call   801001dd <bwrite>
    brelse(from); 
80103651:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103654:	89 04 24             	mov    %eax,(%esp)
80103657:	e8 bb cb ff ff       	call   80100217 <brelse>
    brelse(to);
8010365c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010365f:	89 04 24             	mov    %eax,(%esp)
80103662:	e8 b0 cb ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103667:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010366b:	a1 a8 32 11 80       	mov    0x801132a8,%eax
80103670:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103673:	0f 8f 66 ff ff ff    	jg     801035df <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103679:	c9                   	leave  
8010367a:	c3                   	ret    

8010367b <commit>:

static void
commit()
{
8010367b:	55                   	push   %ebp
8010367c:	89 e5                	mov    %esp,%ebp
8010367e:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103681:	a1 a8 32 11 80       	mov    0x801132a8,%eax
80103686:	85 c0                	test   %eax,%eax
80103688:	7e 1e                	jle    801036a8 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010368a:	e8 3e ff ff ff       	call   801035cd <write_log>
    write_head();    // Write header to disk -- the real commit
8010368f:	e8 72 fd ff ff       	call   80103406 <write_head>
    install_trans(); // Now install writes to home locations
80103694:	e8 50 fc ff ff       	call   801032e9 <install_trans>
    log.lh.n = 0; 
80103699:	c7 05 a8 32 11 80 00 	movl   $0x0,0x801132a8
801036a0:	00 00 00 
    write_head();    // Erase the transaction from the log
801036a3:	e8 5e fd ff ff       	call   80103406 <write_head>
  }
}
801036a8:	c9                   	leave  
801036a9:	c3                   	ret    

801036aa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036aa:	55                   	push   %ebp
801036ab:	89 e5                	mov    %esp,%ebp
801036ad:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036b0:	a1 a8 32 11 80       	mov    0x801132a8,%eax
801036b5:	83 f8 1d             	cmp    $0x1d,%eax
801036b8:	7f 12                	jg     801036cc <log_write+0x22>
801036ba:	a1 a8 32 11 80       	mov    0x801132a8,%eax
801036bf:	8b 15 98 32 11 80    	mov    0x80113298,%edx
801036c5:	83 ea 01             	sub    $0x1,%edx
801036c8:	39 d0                	cmp    %edx,%eax
801036ca:	7c 0c                	jl     801036d8 <log_write+0x2e>
    panic("too big a transaction");
801036cc:	c7 04 24 27 8c 10 80 	movl   $0x80108c27,(%esp)
801036d3:	e8 6e ce ff ff       	call   80100546 <panic>
  if (log.outstanding < 1)
801036d8:	a1 9c 32 11 80       	mov    0x8011329c,%eax
801036dd:	85 c0                	test   %eax,%eax
801036df:	7f 0c                	jg     801036ed <log_write+0x43>
    panic("log_write outside of trans");
801036e1:	c7 04 24 3d 8c 10 80 	movl   $0x80108c3d,(%esp)
801036e8:	e8 59 ce ff ff       	call   80100546 <panic>

  for (i = 0; i < log.lh.n; i++) {
801036ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036f4:	eb 1d                	jmp    80103713 <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
801036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036f9:	83 c0 10             	add    $0x10,%eax
801036fc:	8b 04 85 6c 32 11 80 	mov    -0x7feecd94(,%eax,4),%eax
80103703:	89 c2                	mov    %eax,%edx
80103705:	8b 45 08             	mov    0x8(%ebp),%eax
80103708:	8b 40 08             	mov    0x8(%eax),%eax
8010370b:	39 c2                	cmp    %eax,%edx
8010370d:	74 10                	je     8010371f <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
8010370f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103713:	a1 a8 32 11 80       	mov    0x801132a8,%eax
80103718:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010371b:	7f d9                	jg     801036f6 <log_write+0x4c>
8010371d:	eb 01                	jmp    80103720 <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
8010371f:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103720:	8b 45 08             	mov    0x8(%ebp),%eax
80103723:	8b 40 08             	mov    0x8(%eax),%eax
80103726:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103729:	83 c2 10             	add    $0x10,%edx
8010372c:	89 04 95 6c 32 11 80 	mov    %eax,-0x7feecd94(,%edx,4)
  if (i == log.lh.n)
80103733:	a1 a8 32 11 80       	mov    0x801132a8,%eax
80103738:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010373b:	75 0d                	jne    8010374a <log_write+0xa0>
    log.lh.n++;
8010373d:	a1 a8 32 11 80       	mov    0x801132a8,%eax
80103742:	83 c0 01             	add    $0x1,%eax
80103745:	a3 a8 32 11 80       	mov    %eax,0x801132a8
  b->flags |= B_DIRTY; // prevent eviction
8010374a:	8b 45 08             	mov    0x8(%ebp),%eax
8010374d:	8b 00                	mov    (%eax),%eax
8010374f:	89 c2                	mov    %eax,%edx
80103751:	83 ca 04             	or     $0x4,%edx
80103754:	8b 45 08             	mov    0x8(%ebp),%eax
80103757:	89 10                	mov    %edx,(%eax)
}
80103759:	c9                   	leave  
8010375a:	c3                   	ret    

8010375b <v2p>:
8010375b:	55                   	push   %ebp
8010375c:	89 e5                	mov    %esp,%ebp
8010375e:	8b 45 08             	mov    0x8(%ebp),%eax
80103761:	05 00 00 00 80       	add    $0x80000000,%eax
80103766:	5d                   	pop    %ebp
80103767:	c3                   	ret    

80103768 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103768:	55                   	push   %ebp
80103769:	89 e5                	mov    %esp,%ebp
8010376b:	8b 45 08             	mov    0x8(%ebp),%eax
8010376e:	05 00 00 00 80       	add    $0x80000000,%eax
80103773:	5d                   	pop    %ebp
80103774:	c3                   	ret    

80103775 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103775:	55                   	push   %ebp
80103776:	89 e5                	mov    %esp,%ebp
80103778:	53                   	push   %ebx
80103779:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
8010377c:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010377f:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80103782:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103785:	89 c3                	mov    %eax,%ebx
80103787:	89 d8                	mov    %ebx,%eax
80103789:	f0 87 02             	lock xchg %eax,(%edx)
8010378c:	89 c3                	mov    %eax,%ebx
8010378e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103791:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103794:	83 c4 10             	add    $0x10,%esp
80103797:	5b                   	pop    %ebx
80103798:	5d                   	pop    %ebp
80103799:	c3                   	ret    

8010379a <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010379a:	55                   	push   %ebp
8010379b:	89 e5                	mov    %esp,%ebp
8010379d:	83 e4 f0             	and    $0xfffffff0,%esp
801037a0:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801037a3:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801037aa:	80 
801037ab:	c7 04 24 3c 61 11 80 	movl   $0x8011613c,(%esp)
801037b2:	e8 65 f2 ff ff       	call   80102a1c <kinit1>
  kvmalloc();      // kernel page table
801037b7:	e8 9b 4a 00 00       	call   80108257 <kvmalloc>
  mpinit();        // collect info about this machine
801037bc:	e8 56 04 00 00       	call   80103c17 <mpinit>
  lapicinit();
801037c1:	e8 e0 f5 ff ff       	call   80102da6 <lapicinit>
  seginit();       // set up segments
801037c6:	e8 21 44 00 00       	call   80107bec <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801037cb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037d1:	0f b6 00             	movzbl (%eax),%eax
801037d4:	0f b6 c0             	movzbl %al,%eax
801037d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801037db:	c7 04 24 58 8c 10 80 	movl   $0x80108c58,(%esp)
801037e2:	e8 c3 cb ff ff       	call   801003aa <cprintf>
  picinit();       // interrupt controller
801037e7:	e8 8f 06 00 00       	call   80103e7b <picinit>
  ioapicinit();    // another interrupt controller
801037ec:	e8 1e f1 ff ff       	call   8010290f <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801037f1:	e8 a2 d2 ff ff       	call   80100a98 <consoleinit>
  uartinit();      // serial port
801037f6:	e8 3e 37 00 00       	call   80106f39 <uartinit>
  pinit();         // process table
801037fb:	e8 de 0f 00 00       	call   801047de <pinit>
  tvinit();        // trap vectors
80103800:	e8 d7 32 00 00       	call   80106adc <tvinit>
  binit();         // buffer cache
80103805:	e8 2a c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010380a:	e8 23 d7 ff ff       	call   80100f32 <fileinit>
  iinit();         // inode cache
8010380f:	e8 d1 dd ff ff       	call   801015e5 <iinit>
  ideinit();       // disk
80103814:	e8 5e ed ff ff       	call   80102577 <ideinit>
  if(!ismp)
80103819:	a1 44 33 11 80       	mov    0x80113344,%eax
8010381e:	85 c0                	test   %eax,%eax
80103820:	75 05                	jne    80103827 <main+0x8d>
    timerinit();   // uniprocessor timer
80103822:	e8 fb 31 00 00       	call   80106a22 <timerinit>
  startothers();   // start other processors
80103827:	e8 7f 00 00 00       	call   801038ab <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010382c:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103833:	8e 
80103834:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010383b:	e8 14 f2 ff ff       	call   80102a54 <kinit2>
  userinit();      // first user process
80103840:	e8 b4 10 00 00       	call   801048f9 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103845:	e8 1a 00 00 00       	call   80103864 <mpmain>

8010384a <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010384a:	55                   	push   %ebp
8010384b:	89 e5                	mov    %esp,%ebp
8010384d:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103850:	e8 19 4a 00 00       	call   8010826e <switchkvm>
  seginit();
80103855:	e8 92 43 00 00       	call   80107bec <seginit>
  lapicinit();
8010385a:	e8 47 f5 ff ff       	call   80102da6 <lapicinit>
  mpmain();
8010385f:	e8 00 00 00 00       	call   80103864 <mpmain>

80103864 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103864:	55                   	push   %ebp
80103865:	89 e5                	mov    %esp,%ebp
80103867:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010386a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103870:	0f b6 00             	movzbl (%eax),%eax
80103873:	0f b6 c0             	movzbl %al,%eax
80103876:	89 44 24 04          	mov    %eax,0x4(%esp)
8010387a:	c7 04 24 6f 8c 10 80 	movl   $0x80108c6f,(%esp)
80103881:	e8 24 cb ff ff       	call   801003aa <cprintf>
  idtinit();       // load idt register
80103886:	e8 c5 33 00 00       	call   80106c50 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010388b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103891:	05 a8 00 00 00       	add    $0xa8,%eax
80103896:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010389d:	00 
8010389e:	89 04 24             	mov    %eax,(%esp)
801038a1:	e8 cf fe ff ff       	call   80103775 <xchg>
  scheduler();     // start running processes
801038a6:	e8 bf 15 00 00       	call   80104e6a <scheduler>

801038ab <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801038ab:	55                   	push   %ebp
801038ac:	89 e5                	mov    %esp,%ebp
801038ae:	53                   	push   %ebx
801038af:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801038b2:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801038b9:	e8 aa fe ff ff       	call   80103768 <p2v>
801038be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038c1:	b8 8a 00 00 00       	mov    $0x8a,%eax
801038c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801038ca:	c7 44 24 04 0c c5 10 	movl   $0x8010c50c,0x4(%esp)
801038d1:	80 
801038d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d5:	89 04 24             	mov    %eax,(%esp)
801038d8:	e8 3d 1d 00 00       	call   8010561a <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038dd:	c7 45 f4 60 33 11 80 	movl   $0x80113360,-0xc(%ebp)
801038e4:	e9 86 00 00 00       	jmp    8010396f <startothers+0xc4>
    if(c == cpus+cpunum())  // We've started already.
801038e9:	e8 15 f6 ff ff       	call   80102f03 <cpunum>
801038ee:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801038f4:	05 60 33 11 80       	add    $0x80113360,%eax
801038f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038fc:	74 69                	je     80103967 <startothers+0xbc>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801038fe:	e8 47 f2 ff ff       	call   80102b4a <kalloc>
80103903:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103906:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103909:	83 e8 04             	sub    $0x4,%eax
8010390c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010390f:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103915:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103917:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010391a:	83 e8 08             	sub    $0x8,%eax
8010391d:	c7 00 4a 38 10 80    	movl   $0x8010384a,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103923:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103926:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103929:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
80103930:	e8 26 fe ff ff       	call   8010375b <v2p>
80103935:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103937:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010393a:	89 04 24             	mov    %eax,(%esp)
8010393d:	e8 19 fe ff ff       	call   8010375b <v2p>
80103942:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103945:	0f b6 12             	movzbl (%edx),%edx
80103948:	0f b6 d2             	movzbl %dl,%edx
8010394b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010394f:	89 14 24             	mov    %edx,(%esp)
80103952:	e8 32 f6 ff ff       	call   80102f89 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103957:	90                   	nop
80103958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010395b:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103961:	85 c0                	test   %eax,%eax
80103963:	74 f3                	je     80103958 <startothers+0xad>
80103965:	eb 01                	jmp    80103968 <startothers+0xbd>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103967:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103968:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
8010396f:	a1 40 39 11 80       	mov    0x80113940,%eax
80103974:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010397a:	05 60 33 11 80       	add    $0x80113360,%eax
8010397f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103982:	0f 87 61 ff ff ff    	ja     801038e9 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103988:	83 c4 24             	add    $0x24,%esp
8010398b:	5b                   	pop    %ebx
8010398c:	5d                   	pop    %ebp
8010398d:	c3                   	ret    

8010398e <p2v>:
8010398e:	55                   	push   %ebp
8010398f:	89 e5                	mov    %esp,%ebp
80103991:	8b 45 08             	mov    0x8(%ebp),%eax
80103994:	05 00 00 00 80       	add    $0x80000000,%eax
80103999:	5d                   	pop    %ebp
8010399a:	c3                   	ret    

8010399b <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010399b:	55                   	push   %ebp
8010399c:	89 e5                	mov    %esp,%ebp
8010399e:	53                   	push   %ebx
8010399f:	83 ec 14             	sub    $0x14,%esp
801039a2:	8b 45 08             	mov    0x8(%ebp),%eax
801039a5:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039a9:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801039ad:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801039b1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801039b5:	ec                   	in     (%dx),%al
801039b6:	89 c3                	mov    %eax,%ebx
801039b8:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801039bb:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801039bf:	83 c4 14             	add    $0x14,%esp
801039c2:	5b                   	pop    %ebx
801039c3:	5d                   	pop    %ebp
801039c4:	c3                   	ret    

801039c5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039c5:	55                   	push   %ebp
801039c6:	89 e5                	mov    %esp,%ebp
801039c8:	83 ec 08             	sub    $0x8,%esp
801039cb:	8b 55 08             	mov    0x8(%ebp),%edx
801039ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801039d1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801039d5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039d8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801039dc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801039e0:	ee                   	out    %al,(%dx)
}
801039e1:	c9                   	leave  
801039e2:	c3                   	ret    

801039e3 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801039e3:	55                   	push   %ebp
801039e4:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
801039e6:	a1 44 c6 10 80       	mov    0x8010c644,%eax
801039eb:	89 c2                	mov    %eax,%edx
801039ed:	b8 60 33 11 80       	mov    $0x80113360,%eax
801039f2:	89 d1                	mov    %edx,%ecx
801039f4:	29 c1                	sub    %eax,%ecx
801039f6:	89 c8                	mov    %ecx,%eax
801039f8:	c1 f8 02             	sar    $0x2,%eax
801039fb:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a01:	5d                   	pop    %ebp
80103a02:	c3                   	ret    

80103a03 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a03:	55                   	push   %ebp
80103a04:	89 e5                	mov    %esp,%ebp
80103a06:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a17:	eb 15                	jmp    80103a2e <sum+0x2b>
    sum += addr[i];
80103a19:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80103a1f:	01 d0                	add    %edx,%eax
80103a21:	0f b6 00             	movzbl (%eax),%eax
80103a24:	0f b6 c0             	movzbl %al,%eax
80103a27:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a2a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103a2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a31:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a34:	7c e3                	jl     80103a19 <sum+0x16>
    sum += addr[i];
  return sum;
80103a36:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103a39:	c9                   	leave  
80103a3a:	c3                   	ret    

80103a3b <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a3b:	55                   	push   %ebp
80103a3c:	89 e5                	mov    %esp,%ebp
80103a3e:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a41:	8b 45 08             	mov    0x8(%ebp),%eax
80103a44:	89 04 24             	mov    %eax,(%esp)
80103a47:	e8 42 ff ff ff       	call   8010398e <p2v>
80103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a55:	01 d0                	add    %edx,%eax
80103a57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a60:	eb 3f                	jmp    80103aa1 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a62:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103a69:	00 
80103a6a:	c7 44 24 04 80 8c 10 	movl   $0x80108c80,0x4(%esp)
80103a71:	80 
80103a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a75:	89 04 24             	mov    %eax,(%esp)
80103a78:	e8 41 1b 00 00       	call   801055be <memcmp>
80103a7d:	85 c0                	test   %eax,%eax
80103a7f:	75 1c                	jne    80103a9d <mpsearch1+0x62>
80103a81:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a88:	00 
80103a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a8c:	89 04 24             	mov    %eax,(%esp)
80103a8f:	e8 6f ff ff ff       	call   80103a03 <sum>
80103a94:	84 c0                	test   %al,%al
80103a96:	75 05                	jne    80103a9d <mpsearch1+0x62>
      return (struct mp*)p;
80103a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a9b:	eb 11                	jmp    80103aae <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a9d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aa4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103aa7:	72 b9                	jb     80103a62 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103aae:	c9                   	leave  
80103aaf:	c3                   	ret    

80103ab0 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ab6:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac0:	83 c0 0f             	add    $0xf,%eax
80103ac3:	0f b6 00             	movzbl (%eax),%eax
80103ac6:	0f b6 c0             	movzbl %al,%eax
80103ac9:	89 c2                	mov    %eax,%edx
80103acb:	c1 e2 08             	shl    $0x8,%edx
80103ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad1:	83 c0 0e             	add    $0xe,%eax
80103ad4:	0f b6 00             	movzbl (%eax),%eax
80103ad7:	0f b6 c0             	movzbl %al,%eax
80103ada:	09 d0                	or     %edx,%eax
80103adc:	c1 e0 04             	shl    $0x4,%eax
80103adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ae2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ae6:	74 21                	je     80103b09 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103ae8:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103aef:	00 
80103af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103af3:	89 04 24             	mov    %eax,(%esp)
80103af6:	e8 40 ff ff ff       	call   80103a3b <mpsearch1>
80103afb:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103afe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b02:	74 50                	je     80103b54 <mpsearch+0xa4>
      return mp;
80103b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b07:	eb 5f                	jmp    80103b68 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b0c:	83 c0 14             	add    $0x14,%eax
80103b0f:	0f b6 00             	movzbl (%eax),%eax
80103b12:	0f b6 c0             	movzbl %al,%eax
80103b15:	89 c2                	mov    %eax,%edx
80103b17:	c1 e2 08             	shl    $0x8,%edx
80103b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b1d:	83 c0 13             	add    $0x13,%eax
80103b20:	0f b6 00             	movzbl (%eax),%eax
80103b23:	0f b6 c0             	movzbl %al,%eax
80103b26:	09 d0                	or     %edx,%eax
80103b28:	c1 e0 0a             	shl    $0xa,%eax
80103b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b31:	2d 00 04 00 00       	sub    $0x400,%eax
80103b36:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b3d:	00 
80103b3e:	89 04 24             	mov    %eax,(%esp)
80103b41:	e8 f5 fe ff ff       	call   80103a3b <mpsearch1>
80103b46:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b4d:	74 05                	je     80103b54 <mpsearch+0xa4>
      return mp;
80103b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b52:	eb 14                	jmp    80103b68 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b54:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103b5b:	00 
80103b5c:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103b63:	e8 d3 fe ff ff       	call   80103a3b <mpsearch1>
}
80103b68:	c9                   	leave  
80103b69:	c3                   	ret    

80103b6a <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b6a:	55                   	push   %ebp
80103b6b:	89 e5                	mov    %esp,%ebp
80103b6d:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b70:	e8 3b ff ff ff       	call   80103ab0 <mpsearch>
80103b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b7c:	74 0a                	je     80103b88 <mpconfig+0x1e>
80103b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b81:	8b 40 04             	mov    0x4(%eax),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	75 0a                	jne    80103b92 <mpconfig+0x28>
    return 0;
80103b88:	b8 00 00 00 00       	mov    $0x0,%eax
80103b8d:	e9 83 00 00 00       	jmp    80103c15 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b95:	8b 40 04             	mov    0x4(%eax),%eax
80103b98:	89 04 24             	mov    %eax,(%esp)
80103b9b:	e8 ee fd ff ff       	call   8010398e <p2v>
80103ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ba3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103baa:	00 
80103bab:	c7 44 24 04 85 8c 10 	movl   $0x80108c85,0x4(%esp)
80103bb2:	80 
80103bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bb6:	89 04 24             	mov    %eax,(%esp)
80103bb9:	e8 00 1a 00 00       	call   801055be <memcmp>
80103bbe:	85 c0                	test   %eax,%eax
80103bc0:	74 07                	je     80103bc9 <mpconfig+0x5f>
    return 0;
80103bc2:	b8 00 00 00 00       	mov    $0x0,%eax
80103bc7:	eb 4c                	jmp    80103c15 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bcc:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bd0:	3c 01                	cmp    $0x1,%al
80103bd2:	74 12                	je     80103be6 <mpconfig+0x7c>
80103bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd7:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103bdb:	3c 04                	cmp    $0x4,%al
80103bdd:	74 07                	je     80103be6 <mpconfig+0x7c>
    return 0;
80103bdf:	b8 00 00 00 00       	mov    $0x0,%eax
80103be4:	eb 2f                	jmp    80103c15 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103bed:	0f b7 c0             	movzwl %ax,%eax
80103bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf7:	89 04 24             	mov    %eax,(%esp)
80103bfa:	e8 04 fe ff ff       	call   80103a03 <sum>
80103bff:	84 c0                	test   %al,%al
80103c01:	74 07                	je     80103c0a <mpconfig+0xa0>
    return 0;
80103c03:	b8 00 00 00 00       	mov    $0x0,%eax
80103c08:	eb 0b                	jmp    80103c15 <mpconfig+0xab>
  *pmp = mp;
80103c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80103c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c10:	89 10                	mov    %edx,(%eax)
  return conf;
80103c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c15:	c9                   	leave  
80103c16:	c3                   	ret    

80103c17 <mpinit>:

void
mpinit(void)
{
80103c17:	55                   	push   %ebp
80103c18:	89 e5                	mov    %esp,%ebp
80103c1a:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c1d:	c7 05 44 c6 10 80 60 	movl   $0x80113360,0x8010c644
80103c24:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c27:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c2a:	89 04 24             	mov    %eax,(%esp)
80103c2d:	e8 38 ff ff ff       	call   80103b6a <mpconfig>
80103c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c39:	0f 84 9c 01 00 00    	je     80103ddb <mpinit+0x1c4>
    return;
  ismp = 1;
80103c3f:	c7 05 44 33 11 80 01 	movl   $0x1,0x80113344
80103c46:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c4c:	8b 40 24             	mov    0x24(%eax),%eax
80103c4f:	a3 5c 32 11 80       	mov    %eax,0x8011325c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c57:	83 c0 2c             	add    $0x2c,%eax
80103c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c60:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c64:	0f b7 d0             	movzwl %ax,%edx
80103c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6a:	01 d0                	add    %edx,%eax
80103c6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c6f:	e9 f4 00 00 00       	jmp    80103d68 <mpinit+0x151>
    switch(*p){
80103c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c77:	0f b6 00             	movzbl (%eax),%eax
80103c7a:	0f b6 c0             	movzbl %al,%eax
80103c7d:	83 f8 04             	cmp    $0x4,%eax
80103c80:	0f 87 bf 00 00 00    	ja     80103d45 <mpinit+0x12e>
80103c86:	8b 04 85 c8 8c 10 80 	mov    -0x7fef7338(,%eax,4),%eax
80103c8d:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c92:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c95:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c98:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c9c:	0f b6 d0             	movzbl %al,%edx
80103c9f:	a1 40 39 11 80       	mov    0x80113940,%eax
80103ca4:	39 c2                	cmp    %eax,%edx
80103ca6:	74 2d                	je     80103cd5 <mpinit+0xbe>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cab:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103caf:	0f b6 d0             	movzbl %al,%edx
80103cb2:	a1 40 39 11 80       	mov    0x80113940,%eax
80103cb7:	89 54 24 08          	mov    %edx,0x8(%esp)
80103cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cbf:	c7 04 24 8a 8c 10 80 	movl   $0x80108c8a,(%esp)
80103cc6:	e8 df c6 ff ff       	call   801003aa <cprintf>
        ismp = 0;
80103ccb:	c7 05 44 33 11 80 00 	movl   $0x0,0x80113344
80103cd2:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103cd8:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103cdc:	0f b6 c0             	movzbl %al,%eax
80103cdf:	83 e0 02             	and    $0x2,%eax
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	74 15                	je     80103cfb <mpinit+0xe4>
        bcpu = &cpus[ncpu];
80103ce6:	a1 40 39 11 80       	mov    0x80113940,%eax
80103ceb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103cf1:	05 60 33 11 80       	add    $0x80113360,%eax
80103cf6:	a3 44 c6 10 80       	mov    %eax,0x8010c644
      cpus[ncpu].id = ncpu;
80103cfb:	8b 15 40 39 11 80    	mov    0x80113940,%edx
80103d01:	a1 40 39 11 80       	mov    0x80113940,%eax
80103d06:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103d0c:	81 c2 60 33 11 80    	add    $0x80113360,%edx
80103d12:	88 02                	mov    %al,(%edx)
      ncpu++;
80103d14:	a1 40 39 11 80       	mov    0x80113940,%eax
80103d19:	83 c0 01             	add    $0x1,%eax
80103d1c:	a3 40 39 11 80       	mov    %eax,0x80113940
      p += sizeof(struct mpproc);
80103d21:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d25:	eb 41                	jmp    80103d68 <mpinit+0x151>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d30:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d34:	a2 40 33 11 80       	mov    %al,0x80113340
      p += sizeof(struct mpioapic);
80103d39:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d3d:	eb 29                	jmp    80103d68 <mpinit+0x151>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d3f:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d43:	eb 23                	jmp    80103d68 <mpinit+0x151>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d48:	0f b6 00             	movzbl (%eax),%eax
80103d4b:	0f b6 c0             	movzbl %al,%eax
80103d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d52:	c7 04 24 a8 8c 10 80 	movl   $0x80108ca8,(%esp)
80103d59:	e8 4c c6 ff ff       	call   801003aa <cprintf>
      ismp = 0;
80103d5e:	c7 05 44 33 11 80 00 	movl   $0x0,0x80113344
80103d65:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d6b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d6e:	0f 82 00 ff ff ff    	jb     80103c74 <mpinit+0x5d>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103d74:	a1 44 33 11 80       	mov    0x80113344,%eax
80103d79:	85 c0                	test   %eax,%eax
80103d7b:	75 1d                	jne    80103d9a <mpinit+0x183>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103d7d:	c7 05 40 39 11 80 01 	movl   $0x1,0x80113940
80103d84:	00 00 00 
    lapic = 0;
80103d87:	c7 05 5c 32 11 80 00 	movl   $0x0,0x8011325c
80103d8e:	00 00 00 
    ioapicid = 0;
80103d91:	c6 05 40 33 11 80 00 	movb   $0x0,0x80113340
80103d98:	eb 41                	jmp    80103ddb <mpinit+0x1c4>
    return;
  }

  if(mp->imcrp){
80103d9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d9d:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103da1:	84 c0                	test   %al,%al
80103da3:	74 36                	je     80103ddb <mpinit+0x1c4>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103da5:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103dac:	00 
80103dad:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103db4:	e8 0c fc ff ff       	call   801039c5 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103db9:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103dc0:	e8 d6 fb ff ff       	call   8010399b <inb>
80103dc5:	83 c8 01             	or     $0x1,%eax
80103dc8:	0f b6 c0             	movzbl %al,%eax
80103dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dcf:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103dd6:	e8 ea fb ff ff       	call   801039c5 <outb>
  }
}
80103ddb:	c9                   	leave  
80103ddc:	c3                   	ret    

80103ddd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103ddd:	55                   	push   %ebp
80103dde:	89 e5                	mov    %esp,%ebp
80103de0:	83 ec 08             	sub    $0x8,%esp
80103de3:	8b 55 08             	mov    0x8(%ebp),%edx
80103de6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103de9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103ded:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103df0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103df4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103df8:	ee                   	out    %al,(%dx)
}
80103df9:	c9                   	leave  
80103dfa:	c3                   	ret    

80103dfb <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103dfb:	55                   	push   %ebp
80103dfc:	89 e5                	mov    %esp,%ebp
80103dfe:	83 ec 0c             	sub    $0xc,%esp
80103e01:	8b 45 08             	mov    0x8(%ebp),%eax
80103e04:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e08:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e0c:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103e12:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e16:	0f b6 c0             	movzbl %al,%eax
80103e19:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e1d:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e24:	e8 b4 ff ff ff       	call   80103ddd <outb>
  outb(IO_PIC2+1, mask >> 8);
80103e29:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e2d:	66 c1 e8 08          	shr    $0x8,%ax
80103e31:	0f b6 c0             	movzbl %al,%eax
80103e34:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e38:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e3f:	e8 99 ff ff ff       	call   80103ddd <outb>
}
80103e44:	c9                   	leave  
80103e45:	c3                   	ret    

80103e46 <picenable>:

void
picenable(int irq)
{
80103e46:	55                   	push   %ebp
80103e47:	89 e5                	mov    %esp,%ebp
80103e49:	53                   	push   %ebx
80103e4a:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103e4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e50:	ba 01 00 00 00       	mov    $0x1,%edx
80103e55:	89 d3                	mov    %edx,%ebx
80103e57:	89 c1                	mov    %eax,%ecx
80103e59:	d3 e3                	shl    %cl,%ebx
80103e5b:	89 d8                	mov    %ebx,%eax
80103e5d:	89 c2                	mov    %eax,%edx
80103e5f:	f7 d2                	not    %edx
80103e61:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103e68:	21 d0                	and    %edx,%eax
80103e6a:	0f b7 c0             	movzwl %ax,%eax
80103e6d:	89 04 24             	mov    %eax,(%esp)
80103e70:	e8 86 ff ff ff       	call   80103dfb <picsetmask>
}
80103e75:	83 c4 04             	add    $0x4,%esp
80103e78:	5b                   	pop    %ebx
80103e79:	5d                   	pop    %ebp
80103e7a:	c3                   	ret    

80103e7b <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103e7b:	55                   	push   %ebp
80103e7c:	89 e5                	mov    %esp,%ebp
80103e7e:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e81:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e88:	00 
80103e89:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e90:	e8 48 ff ff ff       	call   80103ddd <outb>
  outb(IO_PIC2+1, 0xFF);
80103e95:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e9c:	00 
80103e9d:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ea4:	e8 34 ff ff ff       	call   80103ddd <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ea9:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103eb0:	00 
80103eb1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103eb8:	e8 20 ff ff ff       	call   80103ddd <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103ebd:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103ec4:	00 
80103ec5:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ecc:	e8 0c ff ff ff       	call   80103ddd <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103ed1:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103ed8:	00 
80103ed9:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ee0:	e8 f8 fe ff ff       	call   80103ddd <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103ee5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103eec:	00 
80103eed:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ef4:	e8 e4 fe ff ff       	call   80103ddd <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ef9:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103f00:	00 
80103f01:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f08:	e8 d0 fe ff ff       	call   80103ddd <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f0d:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103f14:	00 
80103f15:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f1c:	e8 bc fe ff ff       	call   80103ddd <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f21:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103f28:	00 
80103f29:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f30:	e8 a8 fe ff ff       	call   80103ddd <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f35:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f3c:	00 
80103f3d:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f44:	e8 94 fe ff ff       	call   80103ddd <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f49:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f50:	00 
80103f51:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f58:	e8 80 fe ff ff       	call   80103ddd <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f5d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f64:	00 
80103f65:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f6c:	e8 6c fe ff ff       	call   80103ddd <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103f71:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f78:	00 
80103f79:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f80:	e8 58 fe ff ff       	call   80103ddd <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103f85:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f8c:	00 
80103f8d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f94:	e8 44 fe ff ff       	call   80103ddd <outb>

  if(irqmask != 0xFFFF)
80103f99:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fa0:	66 83 f8 ff          	cmp    $0xffff,%ax
80103fa4:	74 12                	je     80103fb8 <picinit+0x13d>
    picsetmask(irqmask);
80103fa6:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fad:	0f b7 c0             	movzwl %ax,%eax
80103fb0:	89 04 24             	mov    %eax,(%esp)
80103fb3:	e8 43 fe ff ff       	call   80103dfb <picsetmask>
}
80103fb8:	c9                   	leave  
80103fb9:	c3                   	ret    

80103fba <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fba:	55                   	push   %ebp
80103fbb:	89 e5                	mov    %esp,%ebp
80103fbd:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103fc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd3:	8b 10                	mov    (%eax),%edx
80103fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd8:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fda:	e8 6f cf ff ff       	call   80100f4e <filealloc>
80103fdf:	8b 55 08             	mov    0x8(%ebp),%edx
80103fe2:	89 02                	mov    %eax,(%edx)
80103fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe7:	8b 00                	mov    (%eax),%eax
80103fe9:	85 c0                	test   %eax,%eax
80103feb:	0f 84 c8 00 00 00    	je     801040b9 <pipealloc+0xff>
80103ff1:	e8 58 cf ff ff       	call   80100f4e <filealloc>
80103ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ff9:	89 02                	mov    %eax,(%edx)
80103ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ffe:	8b 00                	mov    (%eax),%eax
80104000:	85 c0                	test   %eax,%eax
80104002:	0f 84 b1 00 00 00    	je     801040b9 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104008:	e8 3d eb ff ff       	call   80102b4a <kalloc>
8010400d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104010:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104014:	0f 84 9e 00 00 00    	je     801040b8 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
8010401a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401d:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104024:	00 00 00 
  p->writeopen = 1;
80104027:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402a:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104031:	00 00 00 
  p->nwrite = 0;
80104034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104037:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010403e:	00 00 00 
  p->nread = 0;
80104041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104044:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010404b:	00 00 00 
  initlock(&p->lock, "pipe");
8010404e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104051:	c7 44 24 04 dc 8c 10 	movl   $0x80108cdc,0x4(%esp)
80104058:	80 
80104059:	89 04 24             	mov    %eax,(%esp)
8010405c:	e8 6d 12 00 00       	call   801052ce <initlock>
  (*f0)->type = FD_PIPE;
80104061:	8b 45 08             	mov    0x8(%ebp),%eax
80104064:	8b 00                	mov    (%eax),%eax
80104066:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010406c:	8b 45 08             	mov    0x8(%ebp),%eax
8010406f:	8b 00                	mov    (%eax),%eax
80104071:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104075:	8b 45 08             	mov    0x8(%ebp),%eax
80104078:	8b 00                	mov    (%eax),%eax
8010407a:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010407e:	8b 45 08             	mov    0x8(%ebp),%eax
80104081:	8b 00                	mov    (%eax),%eax
80104083:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104086:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010408c:	8b 00                	mov    (%eax),%eax
8010408e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104094:	8b 45 0c             	mov    0xc(%ebp),%eax
80104097:	8b 00                	mov    (%eax),%eax
80104099:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010409d:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a0:	8b 00                	mov    (%eax),%eax
801040a2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a9:	8b 00                	mov    (%eax),%eax
801040ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040ae:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040b1:	b8 00 00 00 00       	mov    $0x0,%eax
801040b6:	eb 43                	jmp    801040fb <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801040b8:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
801040b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040bd:	74 0b                	je     801040ca <pipealloc+0x110>
    kfree((char*)p);
801040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c2:	89 04 24             	mov    %eax,(%esp)
801040c5:	e8 e7 e9 ff ff       	call   80102ab1 <kfree>
  if(*f0)
801040ca:	8b 45 08             	mov    0x8(%ebp),%eax
801040cd:	8b 00                	mov    (%eax),%eax
801040cf:	85 c0                	test   %eax,%eax
801040d1:	74 0d                	je     801040e0 <pipealloc+0x126>
    fileclose(*f0);
801040d3:	8b 45 08             	mov    0x8(%ebp),%eax
801040d6:	8b 00                	mov    (%eax),%eax
801040d8:	89 04 24             	mov    %eax,(%esp)
801040db:	e8 16 cf ff ff       	call   80100ff6 <fileclose>
  if(*f1)
801040e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801040e3:	8b 00                	mov    (%eax),%eax
801040e5:	85 c0                	test   %eax,%eax
801040e7:	74 0d                	je     801040f6 <pipealloc+0x13c>
    fileclose(*f1);
801040e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ec:	8b 00                	mov    (%eax),%eax
801040ee:	89 04 24             	mov    %eax,(%esp)
801040f1:	e8 00 cf ff ff       	call   80100ff6 <fileclose>
  return -1;
801040f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040fb:	c9                   	leave  
801040fc:	c3                   	ret    

801040fd <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801040fd:	55                   	push   %ebp
801040fe:	89 e5                	mov    %esp,%ebp
80104100:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80104103:	8b 45 08             	mov    0x8(%ebp),%eax
80104106:	89 04 24             	mov    %eax,(%esp)
80104109:	e8 e1 11 00 00       	call   801052ef <acquire>
  if(writable){
8010410e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104112:	74 1f                	je     80104133 <pipeclose+0x36>
    p->writeopen = 0;
80104114:	8b 45 08             	mov    0x8(%ebp),%eax
80104117:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010411e:	00 00 00 
    wakeup(&p->nread);
80104121:	8b 45 08             	mov    0x8(%ebp),%eax
80104124:	05 34 02 00 00       	add    $0x234,%eax
80104129:	89 04 24             	mov    %eax,(%esp)
8010412c:	e8 bb 0f 00 00       	call   801050ec <wakeup>
80104131:	eb 1d                	jmp    80104150 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80104133:	8b 45 08             	mov    0x8(%ebp),%eax
80104136:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010413d:	00 00 00 
    wakeup(&p->nwrite);
80104140:	8b 45 08             	mov    0x8(%ebp),%eax
80104143:	05 38 02 00 00       	add    $0x238,%eax
80104148:	89 04 24             	mov    %eax,(%esp)
8010414b:	e8 9c 0f 00 00       	call   801050ec <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104150:	8b 45 08             	mov    0x8(%ebp),%eax
80104153:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104159:	85 c0                	test   %eax,%eax
8010415b:	75 25                	jne    80104182 <pipeclose+0x85>
8010415d:	8b 45 08             	mov    0x8(%ebp),%eax
80104160:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104166:	85 c0                	test   %eax,%eax
80104168:	75 18                	jne    80104182 <pipeclose+0x85>
    release(&p->lock);
8010416a:	8b 45 08             	mov    0x8(%ebp),%eax
8010416d:	89 04 24             	mov    %eax,(%esp)
80104170:	e8 dc 11 00 00       	call   80105351 <release>
    kfree((char*)p);
80104175:	8b 45 08             	mov    0x8(%ebp),%eax
80104178:	89 04 24             	mov    %eax,(%esp)
8010417b:	e8 31 e9 ff ff       	call   80102ab1 <kfree>
80104180:	eb 0b                	jmp    8010418d <pipeclose+0x90>
  } else
    release(&p->lock);
80104182:	8b 45 08             	mov    0x8(%ebp),%eax
80104185:	89 04 24             	mov    %eax,(%esp)
80104188:	e8 c4 11 00 00       	call   80105351 <release>
}
8010418d:	c9                   	leave  
8010418e:	c3                   	ret    

8010418f <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010418f:	55                   	push   %ebp
80104190:	89 e5                	mov    %esp,%ebp
80104192:	53                   	push   %ebx
80104193:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104196:	8b 45 08             	mov    0x8(%ebp),%eax
80104199:	89 04 24             	mov    %eax,(%esp)
8010419c:	e8 4e 11 00 00       	call   801052ef <acquire>
  for(i = 0; i < n; i++){
801041a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041a8:	e9 a8 00 00 00       	jmp    80104255 <pipewrite+0xc6>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041ad:	8b 45 08             	mov    0x8(%ebp),%eax
801041b0:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041b6:	85 c0                	test   %eax,%eax
801041b8:	74 0d                	je     801041c7 <pipewrite+0x38>
801041ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041c0:	8b 40 24             	mov    0x24(%eax),%eax
801041c3:	85 c0                	test   %eax,%eax
801041c5:	74 15                	je     801041dc <pipewrite+0x4d>
        release(&p->lock);
801041c7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ca:	89 04 24             	mov    %eax,(%esp)
801041cd:	e8 7f 11 00 00       	call   80105351 <release>
        return -1;
801041d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041d7:	e9 9f 00 00 00       	jmp    8010427b <pipewrite+0xec>
      }
      wakeup(&p->nread);
801041dc:	8b 45 08             	mov    0x8(%ebp),%eax
801041df:	05 34 02 00 00       	add    $0x234,%eax
801041e4:	89 04 24             	mov    %eax,(%esp)
801041e7:	e8 00 0f 00 00       	call   801050ec <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041ec:	8b 45 08             	mov    0x8(%ebp),%eax
801041ef:	8b 55 08             	mov    0x8(%ebp),%edx
801041f2:	81 c2 38 02 00 00    	add    $0x238,%edx
801041f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801041fc:	89 14 24             	mov    %edx,(%esp)
801041ff:	e8 0f 0e 00 00       	call   80105013 <sleep>
80104204:	eb 01                	jmp    80104207 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104206:	90                   	nop
80104207:	8b 45 08             	mov    0x8(%ebp),%eax
8010420a:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104210:	8b 45 08             	mov    0x8(%ebp),%eax
80104213:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104219:	05 00 02 00 00       	add    $0x200,%eax
8010421e:	39 c2                	cmp    %eax,%edx
80104220:	74 8b                	je     801041ad <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104222:	8b 45 08             	mov    0x8(%ebp),%eax
80104225:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010422b:	89 c3                	mov    %eax,%ebx
8010422d:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80104233:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104236:	8b 55 0c             	mov    0xc(%ebp),%edx
80104239:	01 ca                	add    %ecx,%edx
8010423b:	0f b6 0a             	movzbl (%edx),%ecx
8010423e:	8b 55 08             	mov    0x8(%ebp),%edx
80104241:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80104245:	8d 50 01             	lea    0x1(%eax),%edx
80104248:	8b 45 08             	mov    0x8(%ebp),%eax
8010424b:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104251:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104255:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104258:	3b 45 10             	cmp    0x10(%ebp),%eax
8010425b:	7c a9                	jl     80104206 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010425d:	8b 45 08             	mov    0x8(%ebp),%eax
80104260:	05 34 02 00 00       	add    $0x234,%eax
80104265:	89 04 24             	mov    %eax,(%esp)
80104268:	e8 7f 0e 00 00       	call   801050ec <wakeup>
  release(&p->lock);
8010426d:	8b 45 08             	mov    0x8(%ebp),%eax
80104270:	89 04 24             	mov    %eax,(%esp)
80104273:	e8 d9 10 00 00       	call   80105351 <release>
  return n;
80104278:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010427b:	83 c4 24             	add    $0x24,%esp
8010427e:	5b                   	pop    %ebx
8010427f:	5d                   	pop    %ebp
80104280:	c3                   	ret    

80104281 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104281:	55                   	push   %ebp
80104282:	89 e5                	mov    %esp,%ebp
80104284:	53                   	push   %ebx
80104285:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104288:	8b 45 08             	mov    0x8(%ebp),%eax
8010428b:	89 04 24             	mov    %eax,(%esp)
8010428e:	e8 5c 10 00 00       	call   801052ef <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104293:	eb 3a                	jmp    801042cf <piperead+0x4e>
    if(proc->killed){
80104295:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010429b:	8b 40 24             	mov    0x24(%eax),%eax
8010429e:	85 c0                	test   %eax,%eax
801042a0:	74 15                	je     801042b7 <piperead+0x36>
      release(&p->lock);
801042a2:	8b 45 08             	mov    0x8(%ebp),%eax
801042a5:	89 04 24             	mov    %eax,(%esp)
801042a8:	e8 a4 10 00 00       	call   80105351 <release>
      return -1;
801042ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042b2:	e9 b7 00 00 00       	jmp    8010436e <piperead+0xed>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801042b7:	8b 45 08             	mov    0x8(%ebp),%eax
801042ba:	8b 55 08             	mov    0x8(%ebp),%edx
801042bd:	81 c2 34 02 00 00    	add    $0x234,%edx
801042c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801042c7:	89 14 24             	mov    %edx,(%esp)
801042ca:	e8 44 0d 00 00       	call   80105013 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042cf:	8b 45 08             	mov    0x8(%ebp),%eax
801042d2:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042d8:	8b 45 08             	mov    0x8(%ebp),%eax
801042db:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042e1:	39 c2                	cmp    %eax,%edx
801042e3:	75 0d                	jne    801042f2 <piperead+0x71>
801042e5:	8b 45 08             	mov    0x8(%ebp),%eax
801042e8:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042ee:	85 c0                	test   %eax,%eax
801042f0:	75 a3                	jne    80104295 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042f9:	eb 4a                	jmp    80104345 <piperead+0xc4>
    if(p->nread == p->nwrite)
801042fb:	8b 45 08             	mov    0x8(%ebp),%eax
801042fe:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104304:	8b 45 08             	mov    0x8(%ebp),%eax
80104307:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010430d:	39 c2                	cmp    %eax,%edx
8010430f:	74 3e                	je     8010434f <piperead+0xce>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104311:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104314:	8b 45 0c             	mov    0xc(%ebp),%eax
80104317:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010431a:	8b 45 08             	mov    0x8(%ebp),%eax
8010431d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104323:	89 c3                	mov    %eax,%ebx
80104325:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010432b:	8b 55 08             	mov    0x8(%ebp),%edx
8010432e:	0f b6 54 1a 34       	movzbl 0x34(%edx,%ebx,1),%edx
80104333:	88 11                	mov    %dl,(%ecx)
80104335:	8d 50 01             	lea    0x1(%eax),%edx
80104338:	8b 45 08             	mov    0x8(%ebp),%eax
8010433b:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104341:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104348:	3b 45 10             	cmp    0x10(%ebp),%eax
8010434b:	7c ae                	jl     801042fb <piperead+0x7a>
8010434d:	eb 01                	jmp    80104350 <piperead+0xcf>
    if(p->nread == p->nwrite)
      break;
8010434f:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104350:	8b 45 08             	mov    0x8(%ebp),%eax
80104353:	05 38 02 00 00       	add    $0x238,%eax
80104358:	89 04 24             	mov    %eax,(%esp)
8010435b:	e8 8c 0d 00 00       	call   801050ec <wakeup>
  release(&p->lock);
80104360:	8b 45 08             	mov    0x8(%ebp),%eax
80104363:	89 04 24             	mov    %eax,(%esp)
80104366:	e8 e6 0f 00 00       	call   80105351 <release>
  return i;
8010436b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010436e:	83 c4 24             	add    $0x24,%esp
80104371:	5b                   	pop    %ebx
80104372:	5d                   	pop    %ebp
80104373:	c3                   	ret    

80104374 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	53                   	push   %ebx
80104378:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010437b:	9c                   	pushf  
8010437c:	5b                   	pop    %ebx
8010437d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104380:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104383:	83 c4 10             	add    $0x10,%esp
80104386:	5b                   	pop    %ebx
80104387:	5d                   	pop    %ebp
80104388:	c3                   	ret    

80104389 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104389:	55                   	push   %ebp
8010438a:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010438c:	fb                   	sti    
}
8010438d:	5d                   	pop    %ebp
8010438e:	c3                   	ret    

8010438f <getprocs>:

static void wakeup1(void *chan);

int
getprocs(int max, struct uproc table[])
{
8010438f:	55                   	push   %ebp
80104390:	89 e5                	mov    %esp,%ebp
80104392:	83 ec 78             	sub    $0x78,%esp
  int proc_count = 0;
80104395:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc *p;
  p = ptable.proc;
8010439c:	c7 45 f0 94 39 11 80 	movl   $0x80113994,-0x10(%ebp)
  int i, j, k, num = 0;
801043a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043aa:	c7 45 f0 94 39 11 80 	movl   $0x80113994,-0x10(%ebp)
801043b1:	e9 af 00 00 00       	jmp    80104465 <getprocs+0xd6>
  {
  	if(p->state == 0)
801043b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043b9:	8b 40 0c             	mov    0xc(%eax),%eax
801043bc:	85 c0                	test   %eax,%eax
801043be:	0f 84 9c 00 00 00    	je     80104460 <getprocs+0xd1>
       	{continue;}

  	if(num < max)
801043c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043c7:	3b 45 08             	cmp    0x8(%ebp),%eax
801043ca:	0f 8d 8a 00 00 00    	jge    8010445a <getprocs+0xcb>
    	{
       		table[num].pid = p->pid;
801043d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043d3:	c1 e0 02             	shl    $0x2,%eax
801043d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801043dd:	29 c2                	sub    %eax,%edx
801043df:	8b 45 0c             	mov    0xc(%ebp),%eax
801043e2:	01 c2                	add    %eax,%edx
801043e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043e7:	8b 40 10             	mov    0x10(%eax),%eax
801043ea:	89 02                	mov    %eax,(%edx)
       		table[num].sz = p->sz;
801043ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043ef:	c1 e0 02             	shl    $0x2,%eax
801043f2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801043f9:	29 c2                	sub    %eax,%edx
801043fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801043fe:	01 c2                	add    %eax,%edx
80104400:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104403:	8b 00                	mov    (%eax),%eax
80104405:	89 42 08             	mov    %eax,0x8(%edx)
       		table[num].state = p->state;
80104408:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010440b:	c1 e0 02             	shl    $0x2,%eax
8010440e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80104415:	29 c2                	sub    %eax,%edx
80104417:	8b 45 0c             	mov    0xc(%ebp),%eax
8010441a:	01 c2                	add    %eax,%edx
8010441c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010441f:	8b 40 0c             	mov    0xc(%eax),%eax
80104422:	89 42 04             	mov    %eax,0x4(%edx)
       		strncpy(table[num].name, p->name, sizeof(table[num].name));
80104425:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104428:	8d 50 6c             	lea    0x6c(%eax),%edx
8010442b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010442e:	c1 e0 02             	shl    $0x2,%eax
80104431:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80104438:	29 c1                	sub    %eax,%ecx
8010443a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010443d:	01 c8                	add    %ecx,%eax
8010443f:	83 c0 0c             	add    $0xc,%eax
80104442:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104449:	00 
8010444a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010444e:	89 04 24             	mov    %eax,(%esp)
80104451:	e8 c0 12 00 00       	call   80105716 <strncpy>
       		num++;
80104456:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    	}

	proc_count++;
8010445a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010445e:	eb 01                	jmp    80104461 <getprocs+0xd2>
  int i, j, k, num = 0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
  	if(p->state == 0)
       	{continue;}
80104460:	90                   	nop
  int proc_count = 0;
  struct proc *p;
  p = ptable.proc;
  int i, j, k, num = 0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104461:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104465:	81 7d f0 94 58 11 80 	cmpl   $0x80115894,-0x10(%ebp)
8010446c:	0f 82 44 ff ff ff    	jb     801043b6 <getprocs+0x27>
    	}

	proc_count++;
  }

  for(i = 0; i < proc_count; i++)
80104472:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104479:	e9 8c 02 00 00       	jmp    8010470a <getprocs+0x37b>
  {
  	for(j = 0; j < proc_count - 1; j++)
8010447e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80104485:	e9 6d 02 00 00       	jmp    801046f7 <getprocs+0x368>
    	{
		if(table[j].sz < table[j + 1].sz)
8010448a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010448d:	c1 e0 02             	shl    $0x2,%eax
80104490:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80104497:	29 c2                	sub    %eax,%edx
80104499:	8b 45 0c             	mov    0xc(%ebp),%eax
8010449c:	01 d0                	add    %edx,%eax
8010449e:	8b 50 08             	mov    0x8(%eax),%edx
801044a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801044a4:	83 c0 01             	add    $0x1,%eax
801044a7:	c1 e0 02             	shl    $0x2,%eax
801044aa:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
801044b1:	29 c1                	sub    %eax,%ecx
801044b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801044b6:	01 c8                	add    %ecx,%eax
801044b8:	8b 40 08             	mov    0x8(%eax),%eax
801044bb:	39 c2                	cmp    %eax,%edx
801044bd:	0f 83 d5 00 00 00    	jae    80104598 <getprocs+0x209>
		{
			struct uproc temp;
			temp = table[j + 1];
801044c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801044c6:	83 c0 01             	add    $0x1,%eax
801044c9:	c1 e0 02             	shl    $0x2,%eax
801044cc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801044d3:	29 c2                	sub    %eax,%edx
801044d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801044d8:	01 d0                	add    %edx,%eax
801044da:	8b 10                	mov    (%eax),%edx
801044dc:	89 55 c0             	mov    %edx,-0x40(%ebp)
801044df:	8b 50 04             	mov    0x4(%eax),%edx
801044e2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801044e5:	8b 50 08             	mov    0x8(%eax),%edx
801044e8:	89 55 c8             	mov    %edx,-0x38(%ebp)
801044eb:	8b 50 0c             	mov    0xc(%eax),%edx
801044ee:	89 55 cc             	mov    %edx,-0x34(%ebp)
801044f1:	8b 50 10             	mov    0x10(%eax),%edx
801044f4:	89 55 d0             	mov    %edx,-0x30(%ebp)
801044f7:	8b 50 14             	mov    0x14(%eax),%edx
801044fa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801044fd:	8b 40 18             	mov    0x18(%eax),%eax
80104500:	89 45 d8             	mov    %eax,-0x28(%ebp)
			table[j + 1] = table[j];
80104503:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104506:	83 c0 01             	add    $0x1,%eax
80104509:	c1 e0 02             	shl    $0x2,%eax
8010450c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80104513:	29 c2                	sub    %eax,%edx
80104515:	8b 45 0c             	mov    0xc(%ebp),%eax
80104518:	01 d0                	add    %edx,%eax
8010451a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010451d:	c1 e2 02             	shl    $0x2,%edx
80104520:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80104527:	29 d1                	sub    %edx,%ecx
80104529:	8b 55 0c             	mov    0xc(%ebp),%edx
8010452c:	01 ca                	add    %ecx,%edx
8010452e:	8b 0a                	mov    (%edx),%ecx
80104530:	89 08                	mov    %ecx,(%eax)
80104532:	8b 4a 04             	mov    0x4(%edx),%ecx
80104535:	89 48 04             	mov    %ecx,0x4(%eax)
80104538:	8b 4a 08             	mov    0x8(%edx),%ecx
8010453b:	89 48 08             	mov    %ecx,0x8(%eax)
8010453e:	8b 4a 0c             	mov    0xc(%edx),%ecx
80104541:	89 48 0c             	mov    %ecx,0xc(%eax)
80104544:	8b 4a 10             	mov    0x10(%edx),%ecx
80104547:	89 48 10             	mov    %ecx,0x10(%eax)
8010454a:	8b 4a 14             	mov    0x14(%edx),%ecx
8010454d:	89 48 14             	mov    %ecx,0x14(%eax)
80104550:	8b 52 18             	mov    0x18(%edx),%edx
80104553:	89 50 18             	mov    %edx,0x18(%eax)
			table[j] = temp;
80104556:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104559:	c1 e0 02             	shl    $0x2,%eax
8010455c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80104563:	29 c2                	sub    %eax,%edx
80104565:	8b 45 0c             	mov    0xc(%ebp),%eax
80104568:	01 d0                	add    %edx,%eax
8010456a:	8b 55 c0             	mov    -0x40(%ebp),%edx
8010456d:	89 10                	mov    %edx,(%eax)
8010456f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80104572:	89 50 04             	mov    %edx,0x4(%eax)
80104575:	8b 55 c8             	mov    -0x38(%ebp),%edx
80104578:	89 50 08             	mov    %edx,0x8(%eax)
8010457b:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010457e:	89 50 0c             	mov    %edx,0xc(%eax)
80104581:	8b 55 d0             	mov    -0x30(%ebp),%edx
80104584:	89 50 10             	mov    %edx,0x10(%eax)
80104587:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010458a:	89 50 14             	mov    %edx,0x14(%eax)
8010458d:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104590:	89 50 18             	mov    %edx,0x18(%eax)
80104593:	e9 5b 01 00 00       	jmp    801046f3 <getprocs+0x364>
		}

		else if(table[j].sz == table[j + 1].sz)
80104598:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010459b:	c1 e0 02             	shl    $0x2,%eax
8010459e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801045a5:	29 c2                	sub    %eax,%edx
801045a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801045aa:	01 d0                	add    %edx,%eax
801045ac:	8b 50 08             	mov    0x8(%eax),%edx
801045af:	8b 45 e8             	mov    -0x18(%ebp),%eax
801045b2:	83 c0 01             	add    $0x1,%eax
801045b5:	c1 e0 02             	shl    $0x2,%eax
801045b8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
801045bf:	29 c1                	sub    %eax,%ecx
801045c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801045c4:	01 c8                	add    %ecx,%eax
801045c6:	8b 40 08             	mov    0x8(%eax),%eax
801045c9:	39 c2                	cmp    %eax,%edx
801045cb:	0f 85 22 01 00 00    	jne    801046f3 <getprocs+0x364>
		{
			struct uproc temp;
			int cmp;
			cmp = strncmp(table[j].name, table[j + 1].name, sizeof(table[j].name));
801045d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801045d4:	83 c0 01             	add    $0x1,%eax
801045d7:	c1 e0 02             	shl    $0x2,%eax
801045da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801045e1:	29 c2                	sub    %eax,%edx
801045e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801045e6:	01 d0                	add    %edx,%eax
801045e8:	8d 50 0c             	lea    0xc(%eax),%edx
801045eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801045ee:	c1 e0 02             	shl    $0x2,%eax
801045f1:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
801045f8:	29 c1                	sub    %eax,%ecx
801045fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801045fd:	01 c8                	add    %ecx,%eax
801045ff:	83 c0 0c             	add    $0xc,%eax
80104602:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104609:	00 
8010460a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010460e:	89 04 24             	mov    %eax,(%esp)
80104611:	e8 a8 10 00 00       	call   801056be <strncmp>
80104616:	89 45 dc             	mov    %eax,-0x24(%ebp)

			if(cmp > 0)
80104619:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
8010461d:	0f 8e d0 00 00 00    	jle    801046f3 <getprocs+0x364>
			{
				temp = table[j + 1];
80104623:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104626:	83 c0 01             	add    $0x1,%eax
80104629:	c1 e0 02             	shl    $0x2,%eax
8010462c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80104633:	29 c2                	sub    %eax,%edx
80104635:	8b 45 0c             	mov    0xc(%ebp),%eax
80104638:	01 d0                	add    %edx,%eax
8010463a:	8b 10                	mov    (%eax),%edx
8010463c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
8010463f:	8b 50 04             	mov    0x4(%eax),%edx
80104642:	89 55 a8             	mov    %edx,-0x58(%ebp)
80104645:	8b 50 08             	mov    0x8(%eax),%edx
80104648:	89 55 ac             	mov    %edx,-0x54(%ebp)
8010464b:	8b 50 0c             	mov    0xc(%eax),%edx
8010464e:	89 55 b0             	mov    %edx,-0x50(%ebp)
80104651:	8b 50 10             	mov    0x10(%eax),%edx
80104654:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80104657:	8b 50 14             	mov    0x14(%eax),%edx
8010465a:	89 55 b8             	mov    %edx,-0x48(%ebp)
8010465d:	8b 40 18             	mov    0x18(%eax),%eax
80104660:	89 45 bc             	mov    %eax,-0x44(%ebp)
				table[j + 1] = table[j];
80104663:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104666:	83 c0 01             	add    $0x1,%eax
80104669:	c1 e0 02             	shl    $0x2,%eax
8010466c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80104673:	29 c2                	sub    %eax,%edx
80104675:	8b 45 0c             	mov    0xc(%ebp),%eax
80104678:	01 d0                	add    %edx,%eax
8010467a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010467d:	c1 e2 02             	shl    $0x2,%edx
80104680:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80104687:	29 d1                	sub    %edx,%ecx
80104689:	8b 55 0c             	mov    0xc(%ebp),%edx
8010468c:	01 ca                	add    %ecx,%edx
8010468e:	8b 0a                	mov    (%edx),%ecx
80104690:	89 08                	mov    %ecx,(%eax)
80104692:	8b 4a 04             	mov    0x4(%edx),%ecx
80104695:	89 48 04             	mov    %ecx,0x4(%eax)
80104698:	8b 4a 08             	mov    0x8(%edx),%ecx
8010469b:	89 48 08             	mov    %ecx,0x8(%eax)
8010469e:	8b 4a 0c             	mov    0xc(%edx),%ecx
801046a1:	89 48 0c             	mov    %ecx,0xc(%eax)
801046a4:	8b 4a 10             	mov    0x10(%edx),%ecx
801046a7:	89 48 10             	mov    %ecx,0x10(%eax)
801046aa:	8b 4a 14             	mov    0x14(%edx),%ecx
801046ad:	89 48 14             	mov    %ecx,0x14(%eax)
801046b0:	8b 52 18             	mov    0x18(%edx),%edx
801046b3:	89 50 18             	mov    %edx,0x18(%eax)
				table[j] = temp;
801046b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801046b9:	c1 e0 02             	shl    $0x2,%eax
801046bc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801046c3:	29 c2                	sub    %eax,%edx
801046c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801046c8:	01 d0                	add    %edx,%eax
801046ca:	8b 55 a4             	mov    -0x5c(%ebp),%edx
801046cd:	89 10                	mov    %edx,(%eax)
801046cf:	8b 55 a8             	mov    -0x58(%ebp),%edx
801046d2:	89 50 04             	mov    %edx,0x4(%eax)
801046d5:	8b 55 ac             	mov    -0x54(%ebp),%edx
801046d8:	89 50 08             	mov    %edx,0x8(%eax)
801046db:	8b 55 b0             	mov    -0x50(%ebp),%edx
801046de:	89 50 0c             	mov    %edx,0xc(%eax)
801046e1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801046e4:	89 50 10             	mov    %edx,0x10(%eax)
801046e7:	8b 55 b8             	mov    -0x48(%ebp),%edx
801046ea:	89 50 14             	mov    %edx,0x14(%eax)
801046ed:	8b 55 bc             	mov    -0x44(%ebp),%edx
801046f0:	89 50 18             	mov    %edx,0x18(%eax)
	proc_count++;
  }

  for(i = 0; i < proc_count; i++)
  {
  	for(j = 0; j < proc_count - 1; j++)
801046f3:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
801046f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fa:	83 e8 01             	sub    $0x1,%eax
801046fd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80104700:	0f 8f 84 fd ff ff    	jg     8010448a <getprocs+0xfb>
    	}

	proc_count++;
  }

  for(i = 0; i < proc_count; i++)
80104706:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010470a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010470d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104710:	0f 8c 68 fd ff ff    	jl     8010447e <getprocs+0xef>
			}
		}
    	}
  }

  for(k = 0; k < proc_count; k++)
80104716:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010471d:	e9 ab 00 00 00       	jmp    801047cd <getprocs+0x43e>
  {
  	cprintf("PID: %d  ", table[k].pid);
80104722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104725:	c1 e0 02             	shl    $0x2,%eax
80104728:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010472f:	29 c2                	sub    %eax,%edx
80104731:	8b 45 0c             	mov    0xc(%ebp),%eax
80104734:	01 d0                	add    %edx,%eax
80104736:	8b 00                	mov    (%eax),%eax
80104738:	89 44 24 04          	mov    %eax,0x4(%esp)
8010473c:	c7 04 24 e1 8c 10 80 	movl   $0x80108ce1,(%esp)
80104743:	e8 62 bc ff ff       	call   801003aa <cprintf>
  	cprintf("State: %d  ", table[k].state);
80104748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010474b:	c1 e0 02             	shl    $0x2,%eax
8010474e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80104755:	29 c2                	sub    %eax,%edx
80104757:	8b 45 0c             	mov    0xc(%ebp),%eax
8010475a:	01 d0                	add    %edx,%eax
8010475c:	8b 40 04             	mov    0x4(%eax),%eax
8010475f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104763:	c7 04 24 eb 8c 10 80 	movl   $0x80108ceb,(%esp)
8010476a:	e8 3b bc ff ff       	call   801003aa <cprintf>
  	cprintf("Size: %d  ", table[k].sz);
8010476f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104772:	c1 e0 02             	shl    $0x2,%eax
80104775:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010477c:	29 c2                	sub    %eax,%edx
8010477e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104781:	01 d0                	add    %edx,%eax
80104783:	8b 40 08             	mov    0x8(%eax),%eax
80104786:	89 44 24 04          	mov    %eax,0x4(%esp)
8010478a:	c7 04 24 f7 8c 10 80 	movl   $0x80108cf7,(%esp)
80104791:	e8 14 bc ff ff       	call   801003aa <cprintf>
  	cprintf("Name: %s  " , table[k].name);
80104796:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104799:	c1 e0 02             	shl    $0x2,%eax
8010479c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801047a3:	29 c2                	sub    %eax,%edx
801047a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801047a8:	01 d0                	add    %edx,%eax
801047aa:	83 c0 0c             	add    $0xc,%eax
801047ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801047b1:	c7 04 24 02 8d 10 80 	movl   $0x80108d02,(%esp)
801047b8:	e8 ed bb ff ff       	call   801003aa <cprintf>
  	cprintf("\n");
801047bd:	c7 04 24 0d 8d 10 80 	movl   $0x80108d0d,(%esp)
801047c4:	e8 e1 bb ff ff       	call   801003aa <cprintf>
			}
		}
    	}
  }

  for(k = 0; k < proc_count; k++)
801047c9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801047d3:	0f 8c 49 ff ff ff    	jl     80104722 <getprocs+0x393>
  	cprintf("Size: %d  ", table[k].sz);
  	cprintf("Name: %s  " , table[k].name);
  	cprintf("\n");
  }

  return proc_count;
801047d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801047dc:	c9                   	leave  
801047dd:	c3                   	ret    

801047de <pinit>:

void
pinit(void)
{
801047de:	55                   	push   %ebp
801047df:	89 e5                	mov    %esp,%ebp
801047e1:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801047e4:	c7 44 24 04 0f 8d 10 	movl   $0x80108d0f,0x4(%esp)
801047eb:	80 
801047ec:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
801047f3:	e8 d6 0a 00 00       	call   801052ce <initlock>
}
801047f8:	c9                   	leave  
801047f9:	c3                   	ret    

801047fa <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801047fa:	55                   	push   %ebp
801047fb:	89 e5                	mov    %esp,%ebp
801047fd:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104800:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104807:	e8 e3 0a 00 00       	call   801052ef <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010480c:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80104813:	eb 0e                	jmp    80104823 <allocproc+0x29>
    if(p->state == UNUSED)
80104815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104818:	8b 40 0c             	mov    0xc(%eax),%eax
8010481b:	85 c0                	test   %eax,%eax
8010481d:	74 23                	je     80104842 <allocproc+0x48>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010481f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104823:	81 7d f4 94 58 11 80 	cmpl   $0x80115894,-0xc(%ebp)
8010482a:	72 e9                	jb     80104815 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010482c:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104833:	e8 19 0b 00 00       	call   80105351 <release>
  return 0;
80104838:	b8 00 00 00 00       	mov    $0x0,%eax
8010483d:	e9 b5 00 00 00       	jmp    801048f7 <allocproc+0xfd>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104842:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104846:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010484d:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104852:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104855:	89 42 10             	mov    %eax,0x10(%edx)
80104858:	83 c0 01             	add    $0x1,%eax
8010485b:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  release(&ptable.lock);
80104860:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104867:	e8 e5 0a 00 00       	call   80105351 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010486c:	e8 d9 e2 ff ff       	call   80102b4a <kalloc>
80104871:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104874:	89 42 08             	mov    %eax,0x8(%edx)
80104877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487a:	8b 40 08             	mov    0x8(%eax),%eax
8010487d:	85 c0                	test   %eax,%eax
8010487f:	75 11                	jne    80104892 <allocproc+0x98>
    p->state = UNUSED;
80104881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104884:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010488b:	b8 00 00 00 00       	mov    $0x0,%eax
80104890:	eb 65                	jmp    801048f7 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
80104892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104895:	8b 40 08             	mov    0x8(%eax),%eax
80104898:	05 00 10 00 00       	add    $0x1000,%eax
8010489d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801048a0:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801048a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048aa:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801048ad:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801048b1:	ba 92 6a 10 80       	mov    $0x80106a92,%edx
801048b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048b9:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801048bb:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801048bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048c5:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801048c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048cb:	8b 40 1c             	mov    0x1c(%eax),%eax
801048ce:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801048d5:	00 
801048d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801048dd:	00 
801048de:	89 04 24             	mov    %eax,(%esp)
801048e1:	e8 61 0c 00 00       	call   80105547 <memset>
  p->context->eip = (uint)forkret;
801048e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e9:	8b 40 1c             	mov    0x1c(%eax),%eax
801048ec:	ba e7 4f 10 80       	mov    $0x80104fe7,%edx
801048f1:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801048f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801048f7:	c9                   	leave  
801048f8:	c3                   	ret    

801048f9 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801048f9:	55                   	push   %ebp
801048fa:	89 e5                	mov    %esp,%ebp
801048fc:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801048ff:	e8 f6 fe ff ff       	call   801047fa <allocproc>
80104904:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490a:	a3 48 c6 10 80       	mov    %eax,0x8010c648
  if((p->pgdir = setupkvm()) == 0)
8010490f:	e8 86 38 00 00       	call   8010819a <setupkvm>
80104914:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104917:	89 42 04             	mov    %eax,0x4(%edx)
8010491a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491d:	8b 40 04             	mov    0x4(%eax),%eax
80104920:	85 c0                	test   %eax,%eax
80104922:	75 0c                	jne    80104930 <userinit+0x37>
    panic("userinit: out of memory?");
80104924:	c7 04 24 16 8d 10 80 	movl   $0x80108d16,(%esp)
8010492b:	e8 16 bc ff ff       	call   80100546 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104930:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104938:	8b 40 04             	mov    0x4(%eax),%eax
8010493b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010493f:	c7 44 24 04 e0 c4 10 	movl   $0x8010c4e0,0x4(%esp)
80104946:	80 
80104947:	89 04 24             	mov    %eax,(%esp)
8010494a:	e8 a3 3a 00 00       	call   801083f2 <inituvm>
  p->sz = PGSIZE;
8010494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104952:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495b:	8b 40 18             	mov    0x18(%eax),%eax
8010495e:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104965:	00 
80104966:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010496d:	00 
8010496e:	89 04 24             	mov    %eax,(%esp)
80104971:	e8 d1 0b 00 00       	call   80105547 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104979:	8b 40 18             	mov    0x18(%eax),%eax
8010497c:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104985:	8b 40 18             	mov    0x18(%eax),%eax
80104988:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010498e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104991:	8b 40 18             	mov    0x18(%eax),%eax
80104994:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104997:	8b 52 18             	mov    0x18(%edx),%edx
8010499a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010499e:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801049a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a5:	8b 40 18             	mov    0x18(%eax),%eax
801049a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049ab:	8b 52 18             	mov    0x18(%edx),%edx
801049ae:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801049b2:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801049b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b9:	8b 40 18             	mov    0x18(%eax),%eax
801049bc:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801049c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c6:	8b 40 18             	mov    0x18(%eax),%eax
801049c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d3:	8b 40 18             	mov    0x18(%eax),%eax
801049d6:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801049dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e0:	83 c0 6c             	add    $0x6c,%eax
801049e3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801049ea:	00 
801049eb:	c7 44 24 04 2f 8d 10 	movl   $0x80108d2f,0x4(%esp)
801049f2:	80 
801049f3:	89 04 24             	mov    %eax,(%esp)
801049f6:	e8 7c 0d 00 00       	call   80105777 <safestrcpy>
  p->cwd = namei("/");
801049fb:	c7 04 24 38 8d 10 80 	movl   $0x80108d38,(%esp)
80104a02:	e8 56 da ff ff       	call   8010245d <namei>
80104a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a0a:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a10:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104a17:	c9                   	leave  
80104a18:	c3                   	ret    

80104a19 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104a19:	55                   	push   %ebp
80104a1a:	89 e5                	mov    %esp,%ebp
80104a1c:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104a1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a25:	8b 00                	mov    (%eax),%eax
80104a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104a2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a2e:	7e 34                	jle    80104a64 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104a30:	8b 55 08             	mov    0x8(%ebp),%edx
80104a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a36:	01 c2                	add    %eax,%edx
80104a38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a3e:	8b 40 04             	mov    0x4(%eax),%eax
80104a41:	89 54 24 08          	mov    %edx,0x8(%esp)
80104a45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a48:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a4c:	89 04 24             	mov    %eax,(%esp)
80104a4f:	e8 18 3b 00 00       	call   8010856c <allocuvm>
80104a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a5b:	75 41                	jne    80104a9e <growproc+0x85>
      return -1;
80104a5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a62:	eb 58                	jmp    80104abc <growproc+0xa3>
  } else if(n < 0){
80104a64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a68:	79 34                	jns    80104a9e <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104a6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a70:	01 c2                	add    %eax,%edx
80104a72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a78:	8b 40 04             	mov    0x4(%eax),%eax
80104a7b:	89 54 24 08          	mov    %edx,0x8(%esp)
80104a7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a82:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a86:	89 04 24             	mov    %eax,(%esp)
80104a89:	e8 b8 3b 00 00       	call   80108646 <deallocuvm>
80104a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a95:	75 07                	jne    80104a9e <growproc+0x85>
      return -1;
80104a97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a9c:	eb 1e                	jmp    80104abc <growproc+0xa3>
  }
  proc->sz = sz;
80104a9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aa7:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104aa9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aaf:	89 04 24             	mov    %eax,(%esp)
80104ab2:	e8 d4 37 00 00       	call   8010828b <switchuvm>
  return 0;
80104ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104abc:	c9                   	leave  
80104abd:	c3                   	ret    

80104abe <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104abe:	55                   	push   %ebp
80104abf:	89 e5                	mov    %esp,%ebp
80104ac1:	57                   	push   %edi
80104ac2:	56                   	push   %esi
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104ac7:	e8 2e fd ff ff       	call   801047fa <allocproc>
80104acc:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104acf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104ad3:	75 0a                	jne    80104adf <fork+0x21>
    return -1;
80104ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ada:	e9 52 01 00 00       	jmp    80104c31 <fork+0x173>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104adf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae5:	8b 10                	mov    (%eax),%edx
80104ae7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aed:	8b 40 04             	mov    0x4(%eax),%eax
80104af0:	89 54 24 04          	mov    %edx,0x4(%esp)
80104af4:	89 04 24             	mov    %eax,(%esp)
80104af7:	e8 e6 3c 00 00       	call   801087e2 <copyuvm>
80104afc:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104aff:	89 42 04             	mov    %eax,0x4(%edx)
80104b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b05:	8b 40 04             	mov    0x4(%eax),%eax
80104b08:	85 c0                	test   %eax,%eax
80104b0a:	75 2c                	jne    80104b38 <fork+0x7a>
    kfree(np->kstack);
80104b0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b0f:	8b 40 08             	mov    0x8(%eax),%eax
80104b12:	89 04 24             	mov    %eax,(%esp)
80104b15:	e8 97 df ff ff       	call   80102ab1 <kfree>
    np->kstack = 0;
80104b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b1d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104b24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b27:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104b2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b33:	e9 f9 00 00 00       	jmp    80104c31 <fork+0x173>
  }
  np->sz = proc->sz;
80104b38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3e:	8b 10                	mov    (%eax),%edx
80104b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b43:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104b45:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b4f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104b52:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b55:	8b 50 18             	mov    0x18(%eax),%edx
80104b58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5e:	8b 40 18             	mov    0x18(%eax),%eax
80104b61:	89 c3                	mov    %eax,%ebx
80104b63:	b8 13 00 00 00       	mov    $0x13,%eax
80104b68:	89 d7                	mov    %edx,%edi
80104b6a:	89 de                	mov    %ebx,%esi
80104b6c:	89 c1                	mov    %eax,%ecx
80104b6e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b73:	8b 40 18             	mov    0x18(%eax),%eax
80104b76:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104b7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b84:	eb 3d                	jmp    80104bc3 <fork+0x105>
    if(proc->ofile[i])
80104b86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b8f:	83 c2 08             	add    $0x8,%edx
80104b92:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b96:	85 c0                	test   %eax,%eax
80104b98:	74 25                	je     80104bbf <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104b9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104ba3:	83 c2 08             	add    $0x8,%edx
80104ba6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104baa:	89 04 24             	mov    %eax,(%esp)
80104bad:	e8 fc c3 ff ff       	call   80100fae <filedup>
80104bb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104bb5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104bb8:	83 c1 08             	add    $0x8,%ecx
80104bbb:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104bbf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104bc3:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104bc7:	7e bd                	jle    80104b86 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104bc9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bcf:	8b 40 68             	mov    0x68(%eax),%eax
80104bd2:	89 04 24             	mov    %eax,(%esp)
80104bd5:	e8 90 cc ff ff       	call   8010186a <idup>
80104bda:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104bdd:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104be0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104be6:	8d 50 6c             	lea    0x6c(%eax),%edx
80104be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bec:	83 c0 6c             	add    $0x6c,%eax
80104bef:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104bf6:	00 
80104bf7:	89 54 24 04          	mov    %edx,0x4(%esp)
80104bfb:	89 04 24             	mov    %eax,(%esp)
80104bfe:	e8 74 0b 00 00       	call   80105777 <safestrcpy>
 
  pid = np->pid;
80104c03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c06:	8b 40 10             	mov    0x10(%eax),%eax
80104c09:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104c0c:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104c13:	e8 d7 06 00 00       	call   801052ef <acquire>
  np->state = RUNNABLE;
80104c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c1b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104c22:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104c29:	e8 23 07 00 00       	call   80105351 <release>
  
  return pid;
80104c2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104c31:	83 c4 2c             	add    $0x2c,%esp
80104c34:	5b                   	pop    %ebx
80104c35:	5e                   	pop    %esi
80104c36:	5f                   	pop    %edi
80104c37:	5d                   	pop    %ebp
80104c38:	c3                   	ret    

80104c39 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104c39:	55                   	push   %ebp
80104c3a:	89 e5                	mov    %esp,%ebp
80104c3c:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104c3f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c46:	a1 48 c6 10 80       	mov    0x8010c648,%eax
80104c4b:	39 c2                	cmp    %eax,%edx
80104c4d:	75 0c                	jne    80104c5b <exit+0x22>
    panic("init exiting");
80104c4f:	c7 04 24 3a 8d 10 80 	movl   $0x80108d3a,(%esp)
80104c56:	e8 eb b8 ff ff       	call   80100546 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c62:	eb 44                	jmp    80104ca8 <exit+0x6f>
    if(proc->ofile[fd]){
80104c64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c6d:	83 c2 08             	add    $0x8,%edx
80104c70:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c74:	85 c0                	test   %eax,%eax
80104c76:	74 2c                	je     80104ca4 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104c78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c81:	83 c2 08             	add    $0x8,%edx
80104c84:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c88:	89 04 24             	mov    %eax,(%esp)
80104c8b:	e8 66 c3 ff ff       	call   80100ff6 <fileclose>
      proc->ofile[fd] = 0;
80104c90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c96:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c99:	83 c2 08             	add    $0x8,%edx
80104c9c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104ca3:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104ca4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104ca8:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104cac:	7e b6                	jle    80104c64 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104cae:	e8 ef e7 ff ff       	call   801034a2 <begin_op>
  iput(proc->cwd);
80104cb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb9:	8b 40 68             	mov    0x68(%eax),%eax
80104cbc:	89 04 24             	mov    %eax,(%esp)
80104cbf:	e8 8b cd ff ff       	call   80101a4f <iput>
  end_op();
80104cc4:	e8 5a e8 ff ff       	call   80103523 <end_op>
  proc->cwd = 0;
80104cc9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ccf:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104cd6:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104cdd:	e8 0d 06 00 00       	call   801052ef <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104ce2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ce8:	8b 40 14             	mov    0x14(%eax),%eax
80104ceb:	89 04 24             	mov    %eax,(%esp)
80104cee:	e8 bb 03 00 00       	call   801050ae <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cf3:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80104cfa:	eb 38                	jmp    80104d34 <exit+0xfb>
    if(p->parent == proc){
80104cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cff:	8b 50 14             	mov    0x14(%eax),%edx
80104d02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d08:	39 c2                	cmp    %eax,%edx
80104d0a:	75 24                	jne    80104d30 <exit+0xf7>
      p->parent = initproc;
80104d0c:	8b 15 48 c6 10 80    	mov    0x8010c648,%edx
80104d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d15:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d1b:	8b 40 0c             	mov    0xc(%eax),%eax
80104d1e:	83 f8 05             	cmp    $0x5,%eax
80104d21:	75 0d                	jne    80104d30 <exit+0xf7>
        wakeup1(initproc);
80104d23:	a1 48 c6 10 80       	mov    0x8010c648,%eax
80104d28:	89 04 24             	mov    %eax,(%esp)
80104d2b:	e8 7e 03 00 00       	call   801050ae <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d30:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104d34:	81 7d f4 94 58 11 80 	cmpl   $0x80115894,-0xc(%ebp)
80104d3b:	72 bf                	jb     80104cfc <exit+0xc3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104d3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d43:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104d4a:	e8 b4 01 00 00       	call   80104f03 <sched>
  panic("zombie exit");
80104d4f:	c7 04 24 47 8d 10 80 	movl   $0x80108d47,(%esp)
80104d56:	e8 eb b7 ff ff       	call   80100546 <panic>

80104d5b <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104d5b:	55                   	push   %ebp
80104d5c:	89 e5                	mov    %esp,%ebp
80104d5e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104d61:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104d68:	e8 82 05 00 00       	call   801052ef <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104d6d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d74:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80104d7b:	e9 9a 00 00 00       	jmp    80104e1a <wait+0xbf>
      if(p->parent != proc)
80104d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d83:	8b 50 14             	mov    0x14(%eax),%edx
80104d86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d8c:	39 c2                	cmp    %eax,%edx
80104d8e:	0f 85 81 00 00 00    	jne    80104e15 <wait+0xba>
        continue;
      havekids = 1;
80104d94:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9e:	8b 40 0c             	mov    0xc(%eax),%eax
80104da1:	83 f8 05             	cmp    $0x5,%eax
80104da4:	75 70                	jne    80104e16 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da9:	8b 40 10             	mov    0x10(%eax),%eax
80104dac:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db2:	8b 40 08             	mov    0x8(%eax),%eax
80104db5:	89 04 24             	mov    %eax,(%esp)
80104db8:	e8 f4 dc ff ff       	call   80102ab1 <kfree>
        p->kstack = 0;
80104dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dca:	8b 40 04             	mov    0x4(%eax),%eax
80104dcd:	89 04 24             	mov    %eax,(%esp)
80104dd0:	e8 2d 39 00 00       	call   80108702 <freevm>
        p->state = UNUSED;
80104dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dec:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df6:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dfd:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104e04:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104e0b:	e8 41 05 00 00       	call   80105351 <release>
        return pid;
80104e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e13:	eb 53                	jmp    80104e68 <wait+0x10d>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104e15:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e16:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104e1a:	81 7d f4 94 58 11 80 	cmpl   $0x80115894,-0xc(%ebp)
80104e21:	0f 82 59 ff ff ff    	jb     80104d80 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104e27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104e2b:	74 0d                	je     80104e3a <wait+0xdf>
80104e2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e33:	8b 40 24             	mov    0x24(%eax),%eax
80104e36:	85 c0                	test   %eax,%eax
80104e38:	74 13                	je     80104e4d <wait+0xf2>
      release(&ptable.lock);
80104e3a:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104e41:	e8 0b 05 00 00       	call   80105351 <release>
      return -1;
80104e46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e4b:	eb 1b                	jmp    80104e68 <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104e4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e53:	c7 44 24 04 60 39 11 	movl   $0x80113960,0x4(%esp)
80104e5a:	80 
80104e5b:	89 04 24             	mov    %eax,(%esp)
80104e5e:	e8 b0 01 00 00       	call   80105013 <sleep>
  }
80104e63:	e9 05 ff ff ff       	jmp    80104d6d <wait+0x12>
}
80104e68:	c9                   	leave  
80104e69:	c3                   	ret    

80104e6a <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104e6a:	55                   	push   %ebp
80104e6b:	89 e5                	mov    %esp,%ebp
80104e6d:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104e70:	e8 14 f5 ff ff       	call   80104389 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104e75:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104e7c:	e8 6e 04 00 00       	call   801052ef <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e81:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80104e88:	eb 5f                	jmp    80104ee9 <scheduler+0x7f>
      if(p->state != RUNNABLE)
80104e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8d:	8b 40 0c             	mov    0xc(%eax),%eax
80104e90:	83 f8 03             	cmp    $0x3,%eax
80104e93:	75 4f                	jne    80104ee4 <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e98:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea1:	89 04 24             	mov    %eax,(%esp)
80104ea4:	e8 e2 33 00 00       	call   8010828b <switchuvm>
      p->state = RUNNING;
80104ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eac:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104eb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb9:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ebc:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ec3:	83 c2 04             	add    $0x4,%edx
80104ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eca:	89 14 24             	mov    %edx,(%esp)
80104ecd:	e8 1a 09 00 00       	call   801057ec <swtch>
      switchkvm();
80104ed2:	e8 97 33 00 00       	call   8010826e <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104ed7:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104ede:	00 00 00 00 
80104ee2:	eb 01                	jmp    80104ee5 <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104ee4:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ee5:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104ee9:	81 7d f4 94 58 11 80 	cmpl   $0x80115894,-0xc(%ebp)
80104ef0:	72 98                	jb     80104e8a <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104ef2:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104ef9:	e8 53 04 00 00       	call   80105351 <release>

  }
80104efe:	e9 6d ff ff ff       	jmp    80104e70 <scheduler+0x6>

80104f03 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104f03:	55                   	push   %ebp
80104f04:	89 e5                	mov    %esp,%ebp
80104f06:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104f09:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104f10:	e8 04 05 00 00       	call   80105419 <holding>
80104f15:	85 c0                	test   %eax,%eax
80104f17:	75 0c                	jne    80104f25 <sched+0x22>
    panic("sched ptable.lock");
80104f19:	c7 04 24 53 8d 10 80 	movl   $0x80108d53,(%esp)
80104f20:	e8 21 b6 ff ff       	call   80100546 <panic>
  if(cpu->ncli != 1)
80104f25:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f2b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104f31:	83 f8 01             	cmp    $0x1,%eax
80104f34:	74 0c                	je     80104f42 <sched+0x3f>
    panic("sched locks");
80104f36:	c7 04 24 65 8d 10 80 	movl   $0x80108d65,(%esp)
80104f3d:	e8 04 b6 ff ff       	call   80100546 <panic>
  if(proc->state == RUNNING)
80104f42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f48:	8b 40 0c             	mov    0xc(%eax),%eax
80104f4b:	83 f8 04             	cmp    $0x4,%eax
80104f4e:	75 0c                	jne    80104f5c <sched+0x59>
    panic("sched running");
80104f50:	c7 04 24 71 8d 10 80 	movl   $0x80108d71,(%esp)
80104f57:	e8 ea b5 ff ff       	call   80100546 <panic>
  if(readeflags()&FL_IF)
80104f5c:	e8 13 f4 ff ff       	call   80104374 <readeflags>
80104f61:	25 00 02 00 00       	and    $0x200,%eax
80104f66:	85 c0                	test   %eax,%eax
80104f68:	74 0c                	je     80104f76 <sched+0x73>
    panic("sched interruptible");
80104f6a:	c7 04 24 7f 8d 10 80 	movl   $0x80108d7f,(%esp)
80104f71:	e8 d0 b5 ff ff       	call   80100546 <panic>
  intena = cpu->intena;
80104f76:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f7c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104f85:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f8b:	8b 40 04             	mov    0x4(%eax),%eax
80104f8e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f95:	83 c2 1c             	add    $0x1c,%edx
80104f98:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f9c:	89 14 24             	mov    %edx,(%esp)
80104f9f:	e8 48 08 00 00       	call   801057ec <swtch>
  cpu->intena = intena;
80104fa4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104faa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fad:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104fb3:	c9                   	leave  
80104fb4:	c3                   	ret    

80104fb5 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104fb5:	55                   	push   %ebp
80104fb6:	89 e5                	mov    %esp,%ebp
80104fb8:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104fbb:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104fc2:	e8 28 03 00 00       	call   801052ef <acquire>
  proc->state = RUNNABLE;
80104fc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fcd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104fd4:	e8 2a ff ff ff       	call   80104f03 <sched>
  release(&ptable.lock);
80104fd9:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104fe0:	e8 6c 03 00 00       	call   80105351 <release>
}
80104fe5:	c9                   	leave  
80104fe6:	c3                   	ret    

80104fe7 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104fe7:	55                   	push   %ebp
80104fe8:	89 e5                	mov    %esp,%ebp
80104fea:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104fed:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80104ff4:	e8 58 03 00 00       	call   80105351 <release>

  if (first) {
80104ff9:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104ffe:	85 c0                	test   %eax,%eax
80105000:	74 0f                	je     80105011 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105002:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80105009:	00 00 00 
    initlog();
8010500c:	e8 81 e2 ff ff       	call   80103292 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105011:	c9                   	leave  
80105012:	c3                   	ret    

80105013 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80105013:	55                   	push   %ebp
80105014:	89 e5                	mov    %esp,%ebp
80105016:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80105019:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010501f:	85 c0                	test   %eax,%eax
80105021:	75 0c                	jne    8010502f <sleep+0x1c>
    panic("sleep");
80105023:	c7 04 24 93 8d 10 80 	movl   $0x80108d93,(%esp)
8010502a:	e8 17 b5 ff ff       	call   80100546 <panic>

  if(lk == 0)
8010502f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105033:	75 0c                	jne    80105041 <sleep+0x2e>
    panic("sleep without lk");
80105035:	c7 04 24 99 8d 10 80 	movl   $0x80108d99,(%esp)
8010503c:	e8 05 b5 ff ff       	call   80100546 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105041:	81 7d 0c 60 39 11 80 	cmpl   $0x80113960,0xc(%ebp)
80105048:	74 17                	je     80105061 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010504a:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80105051:	e8 99 02 00 00       	call   801052ef <acquire>
    release(lk);
80105056:	8b 45 0c             	mov    0xc(%ebp),%eax
80105059:	89 04 24             	mov    %eax,(%esp)
8010505c:	e8 f0 02 00 00       	call   80105351 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80105061:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105067:	8b 55 08             	mov    0x8(%ebp),%edx
8010506a:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
8010506d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105073:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
8010507a:	e8 84 fe ff ff       	call   80104f03 <sched>

  // Tidy up.
  proc->chan = 0;
8010507f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105085:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010508c:	81 7d 0c 60 39 11 80 	cmpl   $0x80113960,0xc(%ebp)
80105093:	74 17                	je     801050ac <sleep+0x99>
    release(&ptable.lock);
80105095:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
8010509c:	e8 b0 02 00 00       	call   80105351 <release>
    acquire(lk);
801050a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801050a4:	89 04 24             	mov    %eax,(%esp)
801050a7:	e8 43 02 00 00       	call   801052ef <acquire>
  }
}
801050ac:	c9                   	leave  
801050ad:	c3                   	ret    

801050ae <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801050ae:	55                   	push   %ebp
801050af:	89 e5                	mov    %esp,%ebp
801050b1:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050b4:	c7 45 fc 94 39 11 80 	movl   $0x80113994,-0x4(%ebp)
801050bb:	eb 24                	jmp    801050e1 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
801050bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050c0:	8b 40 0c             	mov    0xc(%eax),%eax
801050c3:	83 f8 02             	cmp    $0x2,%eax
801050c6:	75 15                	jne    801050dd <wakeup1+0x2f>
801050c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050cb:	8b 40 20             	mov    0x20(%eax),%eax
801050ce:	3b 45 08             	cmp    0x8(%ebp),%eax
801050d1:	75 0a                	jne    801050dd <wakeup1+0x2f>
      p->state = RUNNABLE;
801050d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050d6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050dd:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
801050e1:	81 7d fc 94 58 11 80 	cmpl   $0x80115894,-0x4(%ebp)
801050e8:	72 d3                	jb     801050bd <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
801050ea:	c9                   	leave  
801050eb:	c3                   	ret    

801050ec <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801050ec:	55                   	push   %ebp
801050ed:	89 e5                	mov    %esp,%ebp
801050ef:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801050f2:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
801050f9:	e8 f1 01 00 00       	call   801052ef <acquire>
  wakeup1(chan);
801050fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105101:	89 04 24             	mov    %eax,(%esp)
80105104:	e8 a5 ff ff ff       	call   801050ae <wakeup1>
  release(&ptable.lock);
80105109:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80105110:	e8 3c 02 00 00       	call   80105351 <release>
}
80105115:	c9                   	leave  
80105116:	c3                   	ret    

80105117 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105117:	55                   	push   %ebp
80105118:	89 e5                	mov    %esp,%ebp
8010511a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010511d:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80105124:	e8 c6 01 00 00       	call   801052ef <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105129:	c7 45 f4 94 39 11 80 	movl   $0x80113994,-0xc(%ebp)
80105130:	eb 41                	jmp    80105173 <kill+0x5c>
    if(p->pid == pid){
80105132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105135:	8b 40 10             	mov    0x10(%eax),%eax
80105138:	3b 45 08             	cmp    0x8(%ebp),%eax
8010513b:	75 32                	jne    8010516f <kill+0x58>
      p->killed = 1;
8010513d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105140:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105147:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514a:	8b 40 0c             	mov    0xc(%eax),%eax
8010514d:	83 f8 02             	cmp    $0x2,%eax
80105150:	75 0a                	jne    8010515c <kill+0x45>
        p->state = RUNNABLE;
80105152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105155:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010515c:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80105163:	e8 e9 01 00 00       	call   80105351 <release>
      return 0;
80105168:	b8 00 00 00 00       	mov    $0x0,%eax
8010516d:	eb 1e                	jmp    8010518d <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010516f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80105173:	81 7d f4 94 58 11 80 	cmpl   $0x80115894,-0xc(%ebp)
8010517a:	72 b6                	jb     80105132 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
8010517c:	c7 04 24 60 39 11 80 	movl   $0x80113960,(%esp)
80105183:	e8 c9 01 00 00       	call   80105351 <release>
  return -1;
80105188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010518d:	c9                   	leave  
8010518e:	c3                   	ret    

8010518f <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010518f:	55                   	push   %ebp
80105190:	89 e5                	mov    %esp,%ebp
80105192:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105195:	c7 45 f0 94 39 11 80 	movl   $0x80113994,-0x10(%ebp)
8010519c:	e9 d8 00 00 00       	jmp    80105279 <procdump+0xea>
    if(p->state == UNUSED)
801051a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051a4:	8b 40 0c             	mov    0xc(%eax),%eax
801051a7:	85 c0                	test   %eax,%eax
801051a9:	0f 84 c5 00 00 00    	je     80105274 <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801051af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051b2:	8b 40 0c             	mov    0xc(%eax),%eax
801051b5:	83 f8 05             	cmp    $0x5,%eax
801051b8:	77 23                	ja     801051dd <procdump+0x4e>
801051ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051bd:	8b 40 0c             	mov    0xc(%eax),%eax
801051c0:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801051c7:	85 c0                	test   %eax,%eax
801051c9:	74 12                	je     801051dd <procdump+0x4e>
      state = states[p->state];
801051cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051ce:	8b 40 0c             	mov    0xc(%eax),%eax
801051d1:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801051d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801051db:	eb 07                	jmp    801051e4 <procdump+0x55>
    else
      state = "???";
801051dd:	c7 45 ec aa 8d 10 80 	movl   $0x80108daa,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801051e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051e7:	8d 50 6c             	lea    0x6c(%eax),%edx
801051ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051ed:	8b 40 10             	mov    0x10(%eax),%eax
801051f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
801051f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051f7:	89 54 24 08          	mov    %edx,0x8(%esp)
801051fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ff:	c7 04 24 ae 8d 10 80 	movl   $0x80108dae,(%esp)
80105206:	e8 9f b1 ff ff       	call   801003aa <cprintf>
    if(p->state == SLEEPING){
8010520b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010520e:	8b 40 0c             	mov    0xc(%eax),%eax
80105211:	83 f8 02             	cmp    $0x2,%eax
80105214:	75 50                	jne    80105266 <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105216:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105219:	8b 40 1c             	mov    0x1c(%eax),%eax
8010521c:	8b 40 0c             	mov    0xc(%eax),%eax
8010521f:	83 c0 08             	add    $0x8,%eax
80105222:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80105225:	89 54 24 04          	mov    %edx,0x4(%esp)
80105229:	89 04 24             	mov    %eax,(%esp)
8010522c:	e8 6f 01 00 00       	call   801053a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80105231:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105238:	eb 1b                	jmp    80105255 <procdump+0xc6>
        cprintf(" %p", pc[i]);
8010523a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010523d:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105241:	89 44 24 04          	mov    %eax,0x4(%esp)
80105245:	c7 04 24 b7 8d 10 80 	movl   $0x80108db7,(%esp)
8010524c:	e8 59 b1 ff ff       	call   801003aa <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105251:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105255:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105259:	7f 0b                	jg     80105266 <procdump+0xd7>
8010525b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010525e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105262:	85 c0                	test   %eax,%eax
80105264:	75 d4                	jne    8010523a <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105266:	c7 04 24 0d 8d 10 80 	movl   $0x80108d0d,(%esp)
8010526d:	e8 38 b1 ff ff       	call   801003aa <cprintf>
80105272:	eb 01                	jmp    80105275 <procdump+0xe6>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105274:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105275:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80105279:	81 7d f0 94 58 11 80 	cmpl   $0x80115894,-0x10(%ebp)
80105280:	0f 82 1b ff ff ff    	jb     801051a1 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105286:	c9                   	leave  
80105287:	c3                   	ret    

80105288 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105288:	55                   	push   %ebp
80105289:	89 e5                	mov    %esp,%ebp
8010528b:	53                   	push   %ebx
8010528c:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010528f:	9c                   	pushf  
80105290:	5b                   	pop    %ebx
80105291:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80105294:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80105297:	83 c4 10             	add    $0x10,%esp
8010529a:	5b                   	pop    %ebx
8010529b:	5d                   	pop    %ebp
8010529c:	c3                   	ret    

8010529d <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010529d:	55                   	push   %ebp
8010529e:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801052a0:	fa                   	cli    
}
801052a1:	5d                   	pop    %ebp
801052a2:	c3                   	ret    

801052a3 <sti>:

static inline void
sti(void)
{
801052a3:	55                   	push   %ebp
801052a4:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801052a6:	fb                   	sti    
}
801052a7:	5d                   	pop    %ebp
801052a8:	c3                   	ret    

801052a9 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801052a9:	55                   	push   %ebp
801052aa:	89 e5                	mov    %esp,%ebp
801052ac:	53                   	push   %ebx
801052ad:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
801052b0:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801052b3:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
801052b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801052b9:	89 c3                	mov    %eax,%ebx
801052bb:	89 d8                	mov    %ebx,%eax
801052bd:	f0 87 02             	lock xchg %eax,(%edx)
801052c0:	89 c3                	mov    %eax,%ebx
801052c2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801052c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	5b                   	pop    %ebx
801052cc:	5d                   	pop    %ebp
801052cd:	c3                   	ret    

801052ce <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801052ce:	55                   	push   %ebp
801052cf:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801052d1:	8b 45 08             	mov    0x8(%ebp),%eax
801052d4:	8b 55 0c             	mov    0xc(%ebp),%edx
801052d7:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801052da:	8b 45 08             	mov    0x8(%ebp),%eax
801052dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801052e3:	8b 45 08             	mov    0x8(%ebp),%eax
801052e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801052ed:	5d                   	pop    %ebp
801052ee:	c3                   	ret    

801052ef <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801052ef:	55                   	push   %ebp
801052f0:	89 e5                	mov    %esp,%ebp
801052f2:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801052f5:	e8 49 01 00 00       	call   80105443 <pushcli>
  if(holding(lk))
801052fa:	8b 45 08             	mov    0x8(%ebp),%eax
801052fd:	89 04 24             	mov    %eax,(%esp)
80105300:	e8 14 01 00 00       	call   80105419 <holding>
80105305:	85 c0                	test   %eax,%eax
80105307:	74 0c                	je     80105315 <acquire+0x26>
    panic("acquire");
80105309:	c7 04 24 e5 8d 10 80 	movl   $0x80108de5,(%esp)
80105310:	e8 31 b2 ff ff       	call   80100546 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105315:	90                   	nop
80105316:	8b 45 08             	mov    0x8(%ebp),%eax
80105319:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105320:	00 
80105321:	89 04 24             	mov    %eax,(%esp)
80105324:	e8 80 ff ff ff       	call   801052a9 <xchg>
80105329:	85 c0                	test   %eax,%eax
8010532b:	75 e9                	jne    80105316 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010532d:	8b 45 08             	mov    0x8(%ebp),%eax
80105330:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105337:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010533a:	8b 45 08             	mov    0x8(%ebp),%eax
8010533d:	83 c0 0c             	add    $0xc,%eax
80105340:	89 44 24 04          	mov    %eax,0x4(%esp)
80105344:	8d 45 08             	lea    0x8(%ebp),%eax
80105347:	89 04 24             	mov    %eax,(%esp)
8010534a:	e8 51 00 00 00       	call   801053a0 <getcallerpcs>
}
8010534f:	c9                   	leave  
80105350:	c3                   	ret    

80105351 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105351:	55                   	push   %ebp
80105352:	89 e5                	mov    %esp,%ebp
80105354:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105357:	8b 45 08             	mov    0x8(%ebp),%eax
8010535a:	89 04 24             	mov    %eax,(%esp)
8010535d:	e8 b7 00 00 00       	call   80105419 <holding>
80105362:	85 c0                	test   %eax,%eax
80105364:	75 0c                	jne    80105372 <release+0x21>
    panic("release");
80105366:	c7 04 24 ed 8d 10 80 	movl   $0x80108ded,(%esp)
8010536d:	e8 d4 b1 ff ff       	call   80100546 <panic>

  lk->pcs[0] = 0;
80105372:	8b 45 08             	mov    0x8(%ebp),%eax
80105375:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010537c:	8b 45 08             	mov    0x8(%ebp),%eax
8010537f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105386:	8b 45 08             	mov    0x8(%ebp),%eax
80105389:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105390:	00 
80105391:	89 04 24             	mov    %eax,(%esp)
80105394:	e8 10 ff ff ff       	call   801052a9 <xchg>

  popcli();
80105399:	e8 ed 00 00 00       	call   8010548b <popcli>
}
8010539e:	c9                   	leave  
8010539f:	c3                   	ret    

801053a0 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801053a6:	8b 45 08             	mov    0x8(%ebp),%eax
801053a9:	83 e8 08             	sub    $0x8,%eax
801053ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801053af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801053b6:	eb 38                	jmp    801053f0 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801053b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801053bc:	74 53                	je     80105411 <getcallerpcs+0x71>
801053be:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801053c5:	76 4a                	jbe    80105411 <getcallerpcs+0x71>
801053c7:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801053cb:	74 44                	je     80105411 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801053cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801053da:	01 c2                	add    %eax,%edx
801053dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053df:	8b 40 04             	mov    0x4(%eax),%eax
801053e2:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801053e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053e7:	8b 00                	mov    (%eax),%eax
801053e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801053ec:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053f0:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053f4:	7e c2                	jle    801053b8 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801053f6:	eb 19                	jmp    80105411 <getcallerpcs+0x71>
    pcs[i] = 0;
801053f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105402:	8b 45 0c             	mov    0xc(%ebp),%eax
80105405:	01 d0                	add    %edx,%eax
80105407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010540d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105411:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105415:	7e e1                	jle    801053f8 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105417:	c9                   	leave  
80105418:	c3                   	ret    

80105419 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105419:	55                   	push   %ebp
8010541a:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010541c:	8b 45 08             	mov    0x8(%ebp),%eax
8010541f:	8b 00                	mov    (%eax),%eax
80105421:	85 c0                	test   %eax,%eax
80105423:	74 17                	je     8010543c <holding+0x23>
80105425:	8b 45 08             	mov    0x8(%ebp),%eax
80105428:	8b 50 08             	mov    0x8(%eax),%edx
8010542b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105431:	39 c2                	cmp    %eax,%edx
80105433:	75 07                	jne    8010543c <holding+0x23>
80105435:	b8 01 00 00 00       	mov    $0x1,%eax
8010543a:	eb 05                	jmp    80105441 <holding+0x28>
8010543c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105441:	5d                   	pop    %ebp
80105442:	c3                   	ret    

80105443 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105443:	55                   	push   %ebp
80105444:	89 e5                	mov    %esp,%ebp
80105446:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105449:	e8 3a fe ff ff       	call   80105288 <readeflags>
8010544e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105451:	e8 47 fe ff ff       	call   8010529d <cli>
  if(cpu->ncli++ == 0)
80105456:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010545c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105462:	85 d2                	test   %edx,%edx
80105464:	0f 94 c1             	sete   %cl
80105467:	83 c2 01             	add    $0x1,%edx
8010546a:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105470:	84 c9                	test   %cl,%cl
80105472:	74 15                	je     80105489 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
80105474:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010547a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010547d:	81 e2 00 02 00 00    	and    $0x200,%edx
80105483:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105489:	c9                   	leave  
8010548a:	c3                   	ret    

8010548b <popcli>:

void
popcli(void)
{
8010548b:	55                   	push   %ebp
8010548c:	89 e5                	mov    %esp,%ebp
8010548e:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105491:	e8 f2 fd ff ff       	call   80105288 <readeflags>
80105496:	25 00 02 00 00       	and    $0x200,%eax
8010549b:	85 c0                	test   %eax,%eax
8010549d:	74 0c                	je     801054ab <popcli+0x20>
    panic("popcli - interruptible");
8010549f:	c7 04 24 f5 8d 10 80 	movl   $0x80108df5,(%esp)
801054a6:	e8 9b b0 ff ff       	call   80100546 <panic>
  if(--cpu->ncli < 0)
801054ab:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054b1:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801054b7:	83 ea 01             	sub    $0x1,%edx
801054ba:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801054c0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054c6:	85 c0                	test   %eax,%eax
801054c8:	79 0c                	jns    801054d6 <popcli+0x4b>
    panic("popcli");
801054ca:	c7 04 24 0c 8e 10 80 	movl   $0x80108e0c,(%esp)
801054d1:	e8 70 b0 ff ff       	call   80100546 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801054d6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054dc:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054e2:	85 c0                	test   %eax,%eax
801054e4:	75 15                	jne    801054fb <popcli+0x70>
801054e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054ec:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801054f2:	85 c0                	test   %eax,%eax
801054f4:	74 05                	je     801054fb <popcli+0x70>
    sti();
801054f6:	e8 a8 fd ff ff       	call   801052a3 <sti>
}
801054fb:	c9                   	leave  
801054fc:	c3                   	ret    

801054fd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801054fd:	55                   	push   %ebp
801054fe:	89 e5                	mov    %esp,%ebp
80105500:	57                   	push   %edi
80105501:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105502:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105505:	8b 55 10             	mov    0x10(%ebp),%edx
80105508:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550b:	89 cb                	mov    %ecx,%ebx
8010550d:	89 df                	mov    %ebx,%edi
8010550f:	89 d1                	mov    %edx,%ecx
80105511:	fc                   	cld    
80105512:	f3 aa                	rep stos %al,%es:(%edi)
80105514:	89 ca                	mov    %ecx,%edx
80105516:	89 fb                	mov    %edi,%ebx
80105518:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010551b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010551e:	5b                   	pop    %ebx
8010551f:	5f                   	pop    %edi
80105520:	5d                   	pop    %ebp
80105521:	c3                   	ret    

80105522 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105522:	55                   	push   %ebp
80105523:	89 e5                	mov    %esp,%ebp
80105525:	57                   	push   %edi
80105526:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105527:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010552a:	8b 55 10             	mov    0x10(%ebp),%edx
8010552d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105530:	89 cb                	mov    %ecx,%ebx
80105532:	89 df                	mov    %ebx,%edi
80105534:	89 d1                	mov    %edx,%ecx
80105536:	fc                   	cld    
80105537:	f3 ab                	rep stos %eax,%es:(%edi)
80105539:	89 ca                	mov    %ecx,%edx
8010553b:	89 fb                	mov    %edi,%ebx
8010553d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105540:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105543:	5b                   	pop    %ebx
80105544:	5f                   	pop    %edi
80105545:	5d                   	pop    %ebp
80105546:	c3                   	ret    

80105547 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105547:	55                   	push   %ebp
80105548:	89 e5                	mov    %esp,%ebp
8010554a:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
8010554d:	8b 45 08             	mov    0x8(%ebp),%eax
80105550:	83 e0 03             	and    $0x3,%eax
80105553:	85 c0                	test   %eax,%eax
80105555:	75 49                	jne    801055a0 <memset+0x59>
80105557:	8b 45 10             	mov    0x10(%ebp),%eax
8010555a:	83 e0 03             	and    $0x3,%eax
8010555d:	85 c0                	test   %eax,%eax
8010555f:	75 3f                	jne    801055a0 <memset+0x59>
    c &= 0xFF;
80105561:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105568:	8b 45 10             	mov    0x10(%ebp),%eax
8010556b:	c1 e8 02             	shr    $0x2,%eax
8010556e:	89 c2                	mov    %eax,%edx
80105570:	8b 45 0c             	mov    0xc(%ebp),%eax
80105573:	89 c1                	mov    %eax,%ecx
80105575:	c1 e1 18             	shl    $0x18,%ecx
80105578:	8b 45 0c             	mov    0xc(%ebp),%eax
8010557b:	c1 e0 10             	shl    $0x10,%eax
8010557e:	09 c1                	or     %eax,%ecx
80105580:	8b 45 0c             	mov    0xc(%ebp),%eax
80105583:	c1 e0 08             	shl    $0x8,%eax
80105586:	09 c8                	or     %ecx,%eax
80105588:	0b 45 0c             	or     0xc(%ebp),%eax
8010558b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010558f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105593:	8b 45 08             	mov    0x8(%ebp),%eax
80105596:	89 04 24             	mov    %eax,(%esp)
80105599:	e8 84 ff ff ff       	call   80105522 <stosl>
8010559e:	eb 19                	jmp    801055b9 <memset+0x72>
  } else
    stosb(dst, c, n);
801055a0:	8b 45 10             	mov    0x10(%ebp),%eax
801055a3:	89 44 24 08          	mov    %eax,0x8(%esp)
801055a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801055aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ae:	8b 45 08             	mov    0x8(%ebp),%eax
801055b1:	89 04 24             	mov    %eax,(%esp)
801055b4:	e8 44 ff ff ff       	call   801054fd <stosb>
  return dst;
801055b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801055bc:	c9                   	leave  
801055bd:	c3                   	ret    

801055be <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801055be:	55                   	push   %ebp
801055bf:	89 e5                	mov    %esp,%ebp
801055c1:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801055c4:	8b 45 08             	mov    0x8(%ebp),%eax
801055c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801055ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801055cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801055d0:	eb 32                	jmp    80105604 <memcmp+0x46>
    if(*s1 != *s2)
801055d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055d5:	0f b6 10             	movzbl (%eax),%edx
801055d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055db:	0f b6 00             	movzbl (%eax),%eax
801055de:	38 c2                	cmp    %al,%dl
801055e0:	74 1a                	je     801055fc <memcmp+0x3e>
      return *s1 - *s2;
801055e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055e5:	0f b6 00             	movzbl (%eax),%eax
801055e8:	0f b6 d0             	movzbl %al,%edx
801055eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055ee:	0f b6 00             	movzbl (%eax),%eax
801055f1:	0f b6 c0             	movzbl %al,%eax
801055f4:	89 d1                	mov    %edx,%ecx
801055f6:	29 c1                	sub    %eax,%ecx
801055f8:	89 c8                	mov    %ecx,%eax
801055fa:	eb 1c                	jmp    80105618 <memcmp+0x5a>
    s1++, s2++;
801055fc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105600:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105604:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105608:	0f 95 c0             	setne  %al
8010560b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010560f:	84 c0                	test   %al,%al
80105611:	75 bf                	jne    801055d2 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105613:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105618:	c9                   	leave  
80105619:	c3                   	ret    

8010561a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010561a:	55                   	push   %ebp
8010561b:	89 e5                	mov    %esp,%ebp
8010561d:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105620:	8b 45 0c             	mov    0xc(%ebp),%eax
80105623:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105626:	8b 45 08             	mov    0x8(%ebp),%eax
80105629:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010562c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010562f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105632:	73 54                	jae    80105688 <memmove+0x6e>
80105634:	8b 45 10             	mov    0x10(%ebp),%eax
80105637:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010563a:	01 d0                	add    %edx,%eax
8010563c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010563f:	76 47                	jbe    80105688 <memmove+0x6e>
    s += n;
80105641:	8b 45 10             	mov    0x10(%ebp),%eax
80105644:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105647:	8b 45 10             	mov    0x10(%ebp),%eax
8010564a:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010564d:	eb 13                	jmp    80105662 <memmove+0x48>
      *--d = *--s;
8010564f:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105653:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105657:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010565a:	0f b6 10             	movzbl (%eax),%edx
8010565d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105660:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105662:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105666:	0f 95 c0             	setne  %al
80105669:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010566d:	84 c0                	test   %al,%al
8010566f:	75 de                	jne    8010564f <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105671:	eb 25                	jmp    80105698 <memmove+0x7e>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105673:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105676:	0f b6 10             	movzbl (%eax),%edx
80105679:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010567c:	88 10                	mov    %dl,(%eax)
8010567e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105682:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105686:	eb 01                	jmp    80105689 <memmove+0x6f>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105688:	90                   	nop
80105689:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010568d:	0f 95 c0             	setne  %al
80105690:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105694:	84 c0                	test   %al,%al
80105696:	75 db                	jne    80105673 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105698:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010569b:	c9                   	leave  
8010569c:	c3                   	ret    

8010569d <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010569d:	55                   	push   %ebp
8010569e:	89 e5                	mov    %esp,%ebp
801056a0:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801056a3:	8b 45 10             	mov    0x10(%ebp),%eax
801056a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801056aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b1:	8b 45 08             	mov    0x8(%ebp),%eax
801056b4:	89 04 24             	mov    %eax,(%esp)
801056b7:	e8 5e ff ff ff       	call   8010561a <memmove>
}
801056bc:	c9                   	leave  
801056bd:	c3                   	ret    

801056be <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801056be:	55                   	push   %ebp
801056bf:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801056c1:	eb 0c                	jmp    801056cf <strncmp+0x11>
    n--, p++, q++;
801056c3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801056c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801056cb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801056cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056d3:	74 1a                	je     801056ef <strncmp+0x31>
801056d5:	8b 45 08             	mov    0x8(%ebp),%eax
801056d8:	0f b6 00             	movzbl (%eax),%eax
801056db:	84 c0                	test   %al,%al
801056dd:	74 10                	je     801056ef <strncmp+0x31>
801056df:	8b 45 08             	mov    0x8(%ebp),%eax
801056e2:	0f b6 10             	movzbl (%eax),%edx
801056e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801056e8:	0f b6 00             	movzbl (%eax),%eax
801056eb:	38 c2                	cmp    %al,%dl
801056ed:	74 d4                	je     801056c3 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801056ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056f3:	75 07                	jne    801056fc <strncmp+0x3e>
    return 0;
801056f5:	b8 00 00 00 00       	mov    $0x0,%eax
801056fa:	eb 18                	jmp    80105714 <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
801056fc:	8b 45 08             	mov    0x8(%ebp),%eax
801056ff:	0f b6 00             	movzbl (%eax),%eax
80105702:	0f b6 d0             	movzbl %al,%edx
80105705:	8b 45 0c             	mov    0xc(%ebp),%eax
80105708:	0f b6 00             	movzbl (%eax),%eax
8010570b:	0f b6 c0             	movzbl %al,%eax
8010570e:	89 d1                	mov    %edx,%ecx
80105710:	29 c1                	sub    %eax,%ecx
80105712:	89 c8                	mov    %ecx,%eax
}
80105714:	5d                   	pop    %ebp
80105715:	c3                   	ret    

80105716 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105716:	55                   	push   %ebp
80105717:	89 e5                	mov    %esp,%ebp
80105719:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010571c:	8b 45 08             	mov    0x8(%ebp),%eax
8010571f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105722:	90                   	nop
80105723:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105727:	0f 9f c0             	setg   %al
8010572a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010572e:	84 c0                	test   %al,%al
80105730:	74 30                	je     80105762 <strncpy+0x4c>
80105732:	8b 45 0c             	mov    0xc(%ebp),%eax
80105735:	0f b6 10             	movzbl (%eax),%edx
80105738:	8b 45 08             	mov    0x8(%ebp),%eax
8010573b:	88 10                	mov    %dl,(%eax)
8010573d:	8b 45 08             	mov    0x8(%ebp),%eax
80105740:	0f b6 00             	movzbl (%eax),%eax
80105743:	84 c0                	test   %al,%al
80105745:	0f 95 c0             	setne  %al
80105748:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010574c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105750:	84 c0                	test   %al,%al
80105752:	75 cf                	jne    80105723 <strncpy+0xd>
    ;
  while(n-- > 0)
80105754:	eb 0c                	jmp    80105762 <strncpy+0x4c>
    *s++ = 0;
80105756:	8b 45 08             	mov    0x8(%ebp),%eax
80105759:	c6 00 00             	movb   $0x0,(%eax)
8010575c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105760:	eb 01                	jmp    80105763 <strncpy+0x4d>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105762:	90                   	nop
80105763:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105767:	0f 9f c0             	setg   %al
8010576a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010576e:	84 c0                	test   %al,%al
80105770:	75 e4                	jne    80105756 <strncpy+0x40>
    *s++ = 0;
  return os;
80105772:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    

80105777 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105777:	55                   	push   %ebp
80105778:	89 e5                	mov    %esp,%ebp
8010577a:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010577d:	8b 45 08             	mov    0x8(%ebp),%eax
80105780:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105783:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105787:	7f 05                	jg     8010578e <safestrcpy+0x17>
    return os;
80105789:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010578c:	eb 35                	jmp    801057c3 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
8010578e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105792:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105796:	7e 22                	jle    801057ba <safestrcpy+0x43>
80105798:	8b 45 0c             	mov    0xc(%ebp),%eax
8010579b:	0f b6 10             	movzbl (%eax),%edx
8010579e:	8b 45 08             	mov    0x8(%ebp),%eax
801057a1:	88 10                	mov    %dl,(%eax)
801057a3:	8b 45 08             	mov    0x8(%ebp),%eax
801057a6:	0f b6 00             	movzbl (%eax),%eax
801057a9:	84 c0                	test   %al,%al
801057ab:	0f 95 c0             	setne  %al
801057ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801057b2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801057b6:	84 c0                	test   %al,%al
801057b8:	75 d4                	jne    8010578e <safestrcpy+0x17>
    ;
  *s = 0;
801057ba:	8b 45 08             	mov    0x8(%ebp),%eax
801057bd:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801057c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057c3:	c9                   	leave  
801057c4:	c3                   	ret    

801057c5 <strlen>:

int
strlen(const char *s)
{
801057c5:	55                   	push   %ebp
801057c6:	89 e5                	mov    %esp,%ebp
801057c8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801057cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801057d2:	eb 04                	jmp    801057d8 <strlen+0x13>
801057d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057db:	8b 45 08             	mov    0x8(%ebp),%eax
801057de:	01 d0                	add    %edx,%eax
801057e0:	0f b6 00             	movzbl (%eax),%eax
801057e3:	84 c0                	test   %al,%al
801057e5:	75 ed                	jne    801057d4 <strlen+0xf>
    ;
  return n;
801057e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057ea:	c9                   	leave  
801057eb:	c3                   	ret    

801057ec <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801057ec:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801057f0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801057f4:	55                   	push   %ebp
  pushl %ebx
801057f5:	53                   	push   %ebx
  pushl %esi
801057f6:	56                   	push   %esi
  pushl %edi
801057f7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801057f8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801057fa:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801057fc:	5f                   	pop    %edi
  popl %esi
801057fd:	5e                   	pop    %esi
  popl %ebx
801057fe:	5b                   	pop    %ebx
  popl %ebp
801057ff:	5d                   	pop    %ebp
  ret
80105800:	c3                   	ret    

80105801 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105801:	55                   	push   %ebp
80105802:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105804:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010580a:	8b 00                	mov    (%eax),%eax
8010580c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010580f:	76 12                	jbe    80105823 <fetchint+0x22>
80105811:	8b 45 08             	mov    0x8(%ebp),%eax
80105814:	8d 50 04             	lea    0x4(%eax),%edx
80105817:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010581d:	8b 00                	mov    (%eax),%eax
8010581f:	39 c2                	cmp    %eax,%edx
80105821:	76 07                	jbe    8010582a <fetchint+0x29>
    return -1;
80105823:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105828:	eb 0f                	jmp    80105839 <fetchint+0x38>
  *ip = *(int*)(addr);
8010582a:	8b 45 08             	mov    0x8(%ebp),%eax
8010582d:	8b 10                	mov    (%eax),%edx
8010582f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105832:	89 10                	mov    %edx,(%eax)
  return 0;
80105834:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105839:	5d                   	pop    %ebp
8010583a:	c3                   	ret    

8010583b <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010583b:	55                   	push   %ebp
8010583c:	89 e5                	mov    %esp,%ebp
8010583e:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105841:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105847:	8b 00                	mov    (%eax),%eax
80105849:	3b 45 08             	cmp    0x8(%ebp),%eax
8010584c:	77 07                	ja     80105855 <fetchstr+0x1a>
    return -1;
8010584e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105853:	eb 48                	jmp    8010589d <fetchstr+0x62>
  *pp = (char*)addr;
80105855:	8b 55 08             	mov    0x8(%ebp),%edx
80105858:	8b 45 0c             	mov    0xc(%ebp),%eax
8010585b:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010585d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105863:	8b 00                	mov    (%eax),%eax
80105865:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105868:	8b 45 0c             	mov    0xc(%ebp),%eax
8010586b:	8b 00                	mov    (%eax),%eax
8010586d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105870:	eb 1e                	jmp    80105890 <fetchstr+0x55>
    if(*s == 0)
80105872:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105875:	0f b6 00             	movzbl (%eax),%eax
80105878:	84 c0                	test   %al,%al
8010587a:	75 10                	jne    8010588c <fetchstr+0x51>
      return s - *pp;
8010587c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010587f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105882:	8b 00                	mov    (%eax),%eax
80105884:	89 d1                	mov    %edx,%ecx
80105886:	29 c1                	sub    %eax,%ecx
80105888:	89 c8                	mov    %ecx,%eax
8010588a:	eb 11                	jmp    8010589d <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010588c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105890:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105893:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105896:	72 da                	jb     80105872 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010589d:	c9                   	leave  
8010589e:	c3                   	ret    

8010589f <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010589f:	55                   	push   %ebp
801058a0:	89 e5                	mov    %esp,%ebp
801058a2:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801058a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058ab:	8b 40 18             	mov    0x18(%eax),%eax
801058ae:	8b 50 44             	mov    0x44(%eax),%edx
801058b1:	8b 45 08             	mov    0x8(%ebp),%eax
801058b4:	c1 e0 02             	shl    $0x2,%eax
801058b7:	01 d0                	add    %edx,%eax
801058b9:	8d 50 04             	lea    0x4(%eax),%edx
801058bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801058bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801058c3:	89 14 24             	mov    %edx,(%esp)
801058c6:	e8 36 ff ff ff       	call   80105801 <fetchint>
}
801058cb:	c9                   	leave  
801058cc:	c3                   	ret    

801058cd <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801058cd:	55                   	push   %ebp
801058ce:	89 e5                	mov    %esp,%ebp
801058d0:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
801058d3:	8d 45 fc             	lea    -0x4(%ebp),%eax
801058d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801058da:	8b 45 08             	mov    0x8(%ebp),%eax
801058dd:	89 04 24             	mov    %eax,(%esp)
801058e0:	e8 ba ff ff ff       	call   8010589f <argint>
801058e5:	85 c0                	test   %eax,%eax
801058e7:	79 07                	jns    801058f0 <argptr+0x23>
    return -1;
801058e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ee:	eb 3d                	jmp    8010592d <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801058f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058f3:	89 c2                	mov    %eax,%edx
801058f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058fb:	8b 00                	mov    (%eax),%eax
801058fd:	39 c2                	cmp    %eax,%edx
801058ff:	73 16                	jae    80105917 <argptr+0x4a>
80105901:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105904:	89 c2                	mov    %eax,%edx
80105906:	8b 45 10             	mov    0x10(%ebp),%eax
80105909:	01 c2                	add    %eax,%edx
8010590b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105911:	8b 00                	mov    (%eax),%eax
80105913:	39 c2                	cmp    %eax,%edx
80105915:	76 07                	jbe    8010591e <argptr+0x51>
    return -1;
80105917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591c:	eb 0f                	jmp    8010592d <argptr+0x60>
  *pp = (char*)i;
8010591e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105921:	89 c2                	mov    %eax,%edx
80105923:	8b 45 0c             	mov    0xc(%ebp),%eax
80105926:	89 10                	mov    %edx,(%eax)
  return 0;
80105928:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010592d:	c9                   	leave  
8010592e:	c3                   	ret    

8010592f <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010592f:	55                   	push   %ebp
80105930:	89 e5                	mov    %esp,%ebp
80105932:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105935:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105938:	89 44 24 04          	mov    %eax,0x4(%esp)
8010593c:	8b 45 08             	mov    0x8(%ebp),%eax
8010593f:	89 04 24             	mov    %eax,(%esp)
80105942:	e8 58 ff ff ff       	call   8010589f <argint>
80105947:	85 c0                	test   %eax,%eax
80105949:	79 07                	jns    80105952 <argstr+0x23>
    return -1;
8010594b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105950:	eb 12                	jmp    80105964 <argstr+0x35>
  return fetchstr(addr, pp);
80105952:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105955:	8b 55 0c             	mov    0xc(%ebp),%edx
80105958:	89 54 24 04          	mov    %edx,0x4(%esp)
8010595c:	89 04 24             	mov    %eax,(%esp)
8010595f:	e8 d7 fe ff ff       	call   8010583b <fetchstr>
}
80105964:	c9                   	leave  
80105965:	c3                   	ret    

80105966 <syscall>:
[SYS_getprocs]	sys_getprocs,
};

void
syscall(void)
{
80105966:	55                   	push   %ebp
80105967:	89 e5                	mov    %esp,%ebp
80105969:	53                   	push   %ebx
8010596a:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
8010596d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105973:	8b 40 18             	mov    0x18(%eax),%eax
80105976:	8b 40 1c             	mov    0x1c(%eax),%eax
80105979:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010597c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105980:	7e 30                	jle    801059b2 <syscall+0x4c>
80105982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105985:	83 f8 16             	cmp    $0x16,%eax
80105988:	77 28                	ja     801059b2 <syscall+0x4c>
8010598a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105994:	85 c0                	test   %eax,%eax
80105996:	74 1a                	je     801059b2 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105998:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010599e:	8b 58 18             	mov    0x18(%eax),%ebx
801059a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a4:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801059ab:	ff d0                	call   *%eax
801059ad:	89 43 1c             	mov    %eax,0x1c(%ebx)
801059b0:	eb 3d                	jmp    801059ef <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801059b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059b8:	8d 48 6c             	lea    0x6c(%eax),%ecx
801059bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801059c1:	8b 40 10             	mov    0x10(%eax),%eax
801059c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059c7:	89 54 24 0c          	mov    %edx,0xc(%esp)
801059cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801059cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801059d3:	c7 04 24 13 8e 10 80 	movl   $0x80108e13,(%esp)
801059da:	e8 cb a9 ff ff       	call   801003aa <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801059df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059e5:	8b 40 18             	mov    0x18(%eax),%eax
801059e8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801059ef:	83 c4 24             	add    $0x24,%esp
801059f2:	5b                   	pop    %ebx
801059f3:	5d                   	pop    %ebp
801059f4:	c3                   	ret    

801059f5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801059f5:	55                   	push   %ebp
801059f6:	89 e5                	mov    %esp,%ebp
801059f8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801059fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a02:	8b 45 08             	mov    0x8(%ebp),%eax
80105a05:	89 04 24             	mov    %eax,(%esp)
80105a08:	e8 92 fe ff ff       	call   8010589f <argint>
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	79 07                	jns    80105a18 <argfd+0x23>
    return -1;
80105a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a16:	eb 50                	jmp    80105a68 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1b:	85 c0                	test   %eax,%eax
80105a1d:	78 21                	js     80105a40 <argfd+0x4b>
80105a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a22:	83 f8 0f             	cmp    $0xf,%eax
80105a25:	7f 19                	jg     80105a40 <argfd+0x4b>
80105a27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a30:	83 c2 08             	add    $0x8,%edx
80105a33:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a3e:	75 07                	jne    80105a47 <argfd+0x52>
    return -1;
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a45:	eb 21                	jmp    80105a68 <argfd+0x73>
  if(pfd)
80105a47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105a4b:	74 08                	je     80105a55 <argfd+0x60>
    *pfd = fd;
80105a4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a50:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a53:	89 10                	mov    %edx,(%eax)
  if(pf)
80105a55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a59:	74 08                	je     80105a63 <argfd+0x6e>
    *pf = f;
80105a5b:	8b 45 10             	mov    0x10(%ebp),%eax
80105a5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a61:	89 10                	mov    %edx,(%eax)
  return 0;
80105a63:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a68:	c9                   	leave  
80105a69:	c3                   	ret    

80105a6a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105a6a:	55                   	push   %ebp
80105a6b:	89 e5                	mov    %esp,%ebp
80105a6d:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105a70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a77:	eb 30                	jmp    80105aa9 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105a79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a82:	83 c2 08             	add    $0x8,%edx
80105a85:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	75 18                	jne    80105aa5 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105a8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a93:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a96:	8d 4a 08             	lea    0x8(%edx),%ecx
80105a99:	8b 55 08             	mov    0x8(%ebp),%edx
80105a9c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aa3:	eb 0f                	jmp    80105ab4 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105aa5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105aa9:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105aad:	7e ca                	jle    80105a79 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105aaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab4:	c9                   	leave  
80105ab5:	c3                   	ret    

80105ab6 <sys_dup>:

int
sys_dup(void)
{
80105ab6:	55                   	push   %ebp
80105ab7:	89 e5                	mov    %esp,%ebp
80105ab9:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105abc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105abf:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ac3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105aca:	00 
80105acb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ad2:	e8 1e ff ff ff       	call   801059f5 <argfd>
80105ad7:	85 c0                	test   %eax,%eax
80105ad9:	79 07                	jns    80105ae2 <sys_dup+0x2c>
    return -1;
80105adb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae0:	eb 29                	jmp    80105b0b <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ae5:	89 04 24             	mov    %eax,(%esp)
80105ae8:	e8 7d ff ff ff       	call   80105a6a <fdalloc>
80105aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105af0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105af4:	79 07                	jns    80105afd <sys_dup+0x47>
    return -1;
80105af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105afb:	eb 0e                	jmp    80105b0b <sys_dup+0x55>
  filedup(f);
80105afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b00:	89 04 24             	mov    %eax,(%esp)
80105b03:	e8 a6 b4 ff ff       	call   80100fae <filedup>
  return fd;
80105b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105b0b:	c9                   	leave  
80105b0c:	c3                   	ret    

80105b0d <sys_read>:

int
sys_read(void)
{
80105b0d:	55                   	push   %ebp
80105b0e:	89 e5                	mov    %esp,%ebp
80105b10:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b13:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b16:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b21:	00 
80105b22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b29:	e8 c7 fe ff ff       	call   801059f5 <argfd>
80105b2e:	85 c0                	test   %eax,%eax
80105b30:	78 35                	js     80105b67 <sys_read+0x5a>
80105b32:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b35:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b39:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105b40:	e8 5a fd ff ff       	call   8010589f <argint>
80105b45:	85 c0                	test   %eax,%eax
80105b47:	78 1e                	js     80105b67 <sys_read+0x5a>
80105b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b50:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b53:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b5e:	e8 6a fd ff ff       	call   801058cd <argptr>
80105b63:	85 c0                	test   %eax,%eax
80105b65:	79 07                	jns    80105b6e <sys_read+0x61>
    return -1;
80105b67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6c:	eb 19                	jmp    80105b87 <sys_read+0x7a>
  return fileread(f, p, n);
80105b6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b71:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105b7b:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b7f:	89 04 24             	mov    %eax,(%esp)
80105b82:	e8 94 b5 ff ff       	call   8010111b <fileread>
}
80105b87:	c9                   	leave  
80105b88:	c3                   	ret    

80105b89 <sys_write>:

int
sys_write(void)
{
80105b89:	55                   	push   %ebp
80105b8a:	89 e5                	mov    %esp,%ebp
80105b8c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b92:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b96:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b9d:	00 
80105b9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ba5:	e8 4b fe ff ff       	call   801059f5 <argfd>
80105baa:	85 c0                	test   %eax,%eax
80105bac:	78 35                	js     80105be3 <sys_write+0x5a>
80105bae:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bb5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105bbc:	e8 de fc ff ff       	call   8010589f <argint>
80105bc1:	85 c0                	test   %eax,%eax
80105bc3:	78 1e                	js     80105be3 <sys_write+0x5a>
80105bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bcc:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105bda:	e8 ee fc ff ff       	call   801058cd <argptr>
80105bdf:	85 c0                	test   %eax,%eax
80105be1:	79 07                	jns    80105bea <sys_write+0x61>
    return -1;
80105be3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be8:	eb 19                	jmp    80105c03 <sys_write+0x7a>
  return filewrite(f, p, n);
80105bea:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105bed:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105bf7:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bfb:	89 04 24             	mov    %eax,(%esp)
80105bfe:	e8 d4 b5 ff ff       	call   801011d7 <filewrite>
}
80105c03:	c9                   	leave  
80105c04:	c3                   	ret    

80105c05 <sys_close>:

int
sys_close(void)
{
80105c05:	55                   	push   %ebp
80105c06:	89 e5                	mov    %esp,%ebp
80105c08:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105c0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c0e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c15:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c20:	e8 d0 fd ff ff       	call   801059f5 <argfd>
80105c25:	85 c0                	test   %eax,%eax
80105c27:	79 07                	jns    80105c30 <sys_close+0x2b>
    return -1;
80105c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c2e:	eb 24                	jmp    80105c54 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105c30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c39:	83 c2 08             	add    $0x8,%edx
80105c3c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105c43:	00 
  fileclose(f);
80105c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c47:	89 04 24             	mov    %eax,(%esp)
80105c4a:	e8 a7 b3 ff ff       	call   80100ff6 <fileclose>
  return 0;
80105c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c54:	c9                   	leave  
80105c55:	c3                   	ret    

80105c56 <sys_fstat>:

int
sys_fstat(void)
{
80105c56:	55                   	push   %ebp
80105c57:	89 e5                	mov    %esp,%ebp
80105c59:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c5f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c6a:	00 
80105c6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c72:	e8 7e fd ff ff       	call   801059f5 <argfd>
80105c77:	85 c0                	test   %eax,%eax
80105c79:	78 1f                	js     80105c9a <sys_fstat+0x44>
80105c7b:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105c82:	00 
80105c83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c86:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c91:	e8 37 fc ff ff       	call   801058cd <argptr>
80105c96:	85 c0                	test   %eax,%eax
80105c98:	79 07                	jns    80105ca1 <sys_fstat+0x4b>
    return -1;
80105c9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c9f:	eb 12                	jmp    80105cb3 <sys_fstat+0x5d>
  return filestat(f, st);
80105ca1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca7:	89 54 24 04          	mov    %edx,0x4(%esp)
80105cab:	89 04 24             	mov    %eax,(%esp)
80105cae:	e8 19 b4 ff ff       	call   801010cc <filestat>
}
80105cb3:	c9                   	leave  
80105cb4:	c3                   	ret    

80105cb5 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105cb5:	55                   	push   %ebp
80105cb6:	89 e5                	mov    %esp,%ebp
80105cb8:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105cbb:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cc9:	e8 61 fc ff ff       	call   8010592f <argstr>
80105cce:	85 c0                	test   %eax,%eax
80105cd0:	78 17                	js     80105ce9 <sys_link+0x34>
80105cd2:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ce0:	e8 4a fc ff ff       	call   8010592f <argstr>
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	79 0a                	jns    80105cf3 <sys_link+0x3e>
    return -1;
80105ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cee:	e9 41 01 00 00       	jmp    80105e34 <sys_link+0x17f>

  begin_op();
80105cf3:	e8 aa d7 ff ff       	call   801034a2 <begin_op>
  if((ip = namei(old)) == 0){
80105cf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105cfb:	89 04 24             	mov    %eax,(%esp)
80105cfe:	e8 5a c7 ff ff       	call   8010245d <namei>
80105d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d0a:	75 0f                	jne    80105d1b <sys_link+0x66>
    end_op();
80105d0c:	e8 12 d8 ff ff       	call   80103523 <end_op>
    return -1;
80105d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d16:	e9 19 01 00 00       	jmp    80105e34 <sys_link+0x17f>
  }

  ilock(ip);
80105d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d1e:	89 04 24             	mov    %eax,(%esp)
80105d21:	e8 76 bb ff ff       	call   8010189c <ilock>
  if(ip->type == T_DIR){
80105d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d29:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d2d:	66 83 f8 01          	cmp    $0x1,%ax
80105d31:	75 1a                	jne    80105d4d <sys_link+0x98>
    iunlockput(ip);
80105d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d36:	89 04 24             	mov    %eax,(%esp)
80105d39:	e8 e2 bd ff ff       	call   80101b20 <iunlockput>
    end_op();
80105d3e:	e8 e0 d7 ff ff       	call   80103523 <end_op>
    return -1;
80105d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d48:	e9 e7 00 00 00       	jmp    80105e34 <sys_link+0x17f>
  }

  ip->nlink++;
80105d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d50:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d54:	8d 50 01             	lea    0x1(%eax),%edx
80105d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d5a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d61:	89 04 24             	mov    %eax,(%esp)
80105d64:	e8 77 b9 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
80105d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d6c:	89 04 24             	mov    %eax,(%esp)
80105d6f:	e8 76 bc ff ff       	call   801019ea <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105d74:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d77:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105d7a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d7e:	89 04 24             	mov    %eax,(%esp)
80105d81:	e8 f9 c6 ff ff       	call   8010247f <nameiparent>
80105d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d8d:	74 68                	je     80105df7 <sys_link+0x142>
    goto bad;
  ilock(dp);
80105d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d92:	89 04 24             	mov    %eax,(%esp)
80105d95:	e8 02 bb ff ff       	call   8010189c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9d:	8b 10                	mov    (%eax),%edx
80105d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da2:	8b 00                	mov    (%eax),%eax
80105da4:	39 c2                	cmp    %eax,%edx
80105da6:	75 20                	jne    80105dc8 <sys_link+0x113>
80105da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dab:	8b 40 04             	mov    0x4(%eax),%eax
80105dae:	89 44 24 08          	mov    %eax,0x8(%esp)
80105db2:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105db5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbc:	89 04 24             	mov    %eax,(%esp)
80105dbf:	e8 d6 c3 ff ff       	call   8010219a <dirlink>
80105dc4:	85 c0                	test   %eax,%eax
80105dc6:	79 0d                	jns    80105dd5 <sys_link+0x120>
    iunlockput(dp);
80105dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dcb:	89 04 24             	mov    %eax,(%esp)
80105dce:	e8 4d bd ff ff       	call   80101b20 <iunlockput>
    goto bad;
80105dd3:	eb 23                	jmp    80105df8 <sys_link+0x143>
  }
  iunlockput(dp);
80105dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd8:	89 04 24             	mov    %eax,(%esp)
80105ddb:	e8 40 bd ff ff       	call   80101b20 <iunlockput>
  iput(ip);
80105de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de3:	89 04 24             	mov    %eax,(%esp)
80105de6:	e8 64 bc ff ff       	call   80101a4f <iput>

  end_op();
80105deb:	e8 33 d7 ff ff       	call   80103523 <end_op>

  return 0;
80105df0:	b8 00 00 00 00       	mov    $0x0,%eax
80105df5:	eb 3d                	jmp    80105e34 <sys_link+0x17f>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105df7:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfb:	89 04 24             	mov    %eax,(%esp)
80105dfe:	e8 99 ba ff ff       	call   8010189c <ilock>
  ip->nlink--;
80105e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e06:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e0a:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e10:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e17:	89 04 24             	mov    %eax,(%esp)
80105e1a:	e8 c1 b8 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e22:	89 04 24             	mov    %eax,(%esp)
80105e25:	e8 f6 bc ff ff       	call   80101b20 <iunlockput>
  end_op();
80105e2a:	e8 f4 d6 ff ff       	call   80103523 <end_op>
  return -1;
80105e2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e34:	c9                   	leave  
80105e35:	c3                   	ret    

80105e36 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105e36:	55                   	push   %ebp
80105e37:	89 e5                	mov    %esp,%ebp
80105e39:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e3c:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105e43:	eb 4b                	jmp    80105e90 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e48:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105e4f:	00 
80105e50:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e54:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e57:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80105e5e:	89 04 24             	mov    %eax,(%esp)
80105e61:	e8 43 bf ff ff       	call   80101da9 <readi>
80105e66:	83 f8 10             	cmp    $0x10,%eax
80105e69:	74 0c                	je     80105e77 <isdirempty+0x41>
      panic("isdirempty: readi");
80105e6b:	c7 04 24 2f 8e 10 80 	movl   $0x80108e2f,(%esp)
80105e72:	e8 cf a6 ff ff       	call   80100546 <panic>
    if(de.inum != 0)
80105e77:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105e7b:	66 85 c0             	test   %ax,%ax
80105e7e:	74 07                	je     80105e87 <isdirempty+0x51>
      return 0;
80105e80:	b8 00 00 00 00       	mov    $0x0,%eax
80105e85:	eb 1b                	jmp    80105ea2 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8a:	83 c0 10             	add    $0x10,%eax
80105e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e93:	8b 45 08             	mov    0x8(%ebp),%eax
80105e96:	8b 40 18             	mov    0x18(%eax),%eax
80105e99:	39 c2                	cmp    %eax,%edx
80105e9b:	72 a8                	jb     80105e45 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105e9d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105ea2:	c9                   	leave  
80105ea3:	c3                   	ret    

80105ea4 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105ea4:	55                   	push   %ebp
80105ea5:	89 e5                	mov    %esp,%ebp
80105ea7:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105eaa:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105ead:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eb1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105eb8:	e8 72 fa ff ff       	call   8010592f <argstr>
80105ebd:	85 c0                	test   %eax,%eax
80105ebf:	79 0a                	jns    80105ecb <sys_unlink+0x27>
    return -1;
80105ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec6:	e9 af 01 00 00       	jmp    8010607a <sys_unlink+0x1d6>

  begin_op();
80105ecb:	e8 d2 d5 ff ff       	call   801034a2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ed0:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105ed3:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105ed6:	89 54 24 04          	mov    %edx,0x4(%esp)
80105eda:	89 04 24             	mov    %eax,(%esp)
80105edd:	e8 9d c5 ff ff       	call   8010247f <nameiparent>
80105ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ee9:	75 0f                	jne    80105efa <sys_unlink+0x56>
    end_op();
80105eeb:	e8 33 d6 ff ff       	call   80103523 <end_op>
    return -1;
80105ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef5:	e9 80 01 00 00       	jmp    8010607a <sys_unlink+0x1d6>
  }

  ilock(dp);
80105efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efd:	89 04 24             	mov    %eax,(%esp)
80105f00:	e8 97 b9 ff ff       	call   8010189c <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105f05:	c7 44 24 04 41 8e 10 	movl   $0x80108e41,0x4(%esp)
80105f0c:	80 
80105f0d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f10:	89 04 24             	mov    %eax,(%esp)
80105f13:	e8 98 c1 ff ff       	call   801020b0 <namecmp>
80105f18:	85 c0                	test   %eax,%eax
80105f1a:	0f 84 45 01 00 00    	je     80106065 <sys_unlink+0x1c1>
80105f20:	c7 44 24 04 43 8e 10 	movl   $0x80108e43,0x4(%esp)
80105f27:	80 
80105f28:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f2b:	89 04 24             	mov    %eax,(%esp)
80105f2e:	e8 7d c1 ff ff       	call   801020b0 <namecmp>
80105f33:	85 c0                	test   %eax,%eax
80105f35:	0f 84 2a 01 00 00    	je     80106065 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105f3b:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105f3e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f42:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f45:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f4c:	89 04 24             	mov    %eax,(%esp)
80105f4f:	e8 7e c1 ff ff       	call   801020d2 <dirlookup>
80105f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f5b:	0f 84 03 01 00 00    	je     80106064 <sys_unlink+0x1c0>
    goto bad;
  ilock(ip);
80105f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f64:	89 04 24             	mov    %eax,(%esp)
80105f67:	e8 30 b9 ff ff       	call   8010189c <ilock>

  if(ip->nlink < 1)
80105f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f73:	66 85 c0             	test   %ax,%ax
80105f76:	7f 0c                	jg     80105f84 <sys_unlink+0xe0>
    panic("unlink: nlink < 1");
80105f78:	c7 04 24 46 8e 10 80 	movl   $0x80108e46,(%esp)
80105f7f:	e8 c2 a5 ff ff       	call   80100546 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f87:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f8b:	66 83 f8 01          	cmp    $0x1,%ax
80105f8f:	75 1f                	jne    80105fb0 <sys_unlink+0x10c>
80105f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f94:	89 04 24             	mov    %eax,(%esp)
80105f97:	e8 9a fe ff ff       	call   80105e36 <isdirempty>
80105f9c:	85 c0                	test   %eax,%eax
80105f9e:	75 10                	jne    80105fb0 <sys_unlink+0x10c>
    iunlockput(ip);
80105fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa3:	89 04 24             	mov    %eax,(%esp)
80105fa6:	e8 75 bb ff ff       	call   80101b20 <iunlockput>
    goto bad;
80105fab:	e9 b5 00 00 00       	jmp    80106065 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105fb0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105fb7:	00 
80105fb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105fbf:	00 
80105fc0:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fc3:	89 04 24             	mov    %eax,(%esp)
80105fc6:	e8 7c f5 ff ff       	call   80105547 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105fcb:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105fce:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105fd5:	00 
80105fd6:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fda:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe4:	89 04 24             	mov    %eax,(%esp)
80105fe7:	e8 2b bf ff ff       	call   80101f17 <writei>
80105fec:	83 f8 10             	cmp    $0x10,%eax
80105fef:	74 0c                	je     80105ffd <sys_unlink+0x159>
    panic("unlink: writei");
80105ff1:	c7 04 24 58 8e 10 80 	movl   $0x80108e58,(%esp)
80105ff8:	e8 49 a5 ff ff       	call   80100546 <panic>
  if(ip->type == T_DIR){
80105ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106000:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106004:	66 83 f8 01          	cmp    $0x1,%ax
80106008:	75 1c                	jne    80106026 <sys_unlink+0x182>
    dp->nlink--;
8010600a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106011:	8d 50 ff             	lea    -0x1(%eax),%edx
80106014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106017:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010601b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601e:	89 04 24             	mov    %eax,(%esp)
80106021:	e8 ba b6 ff ff       	call   801016e0 <iupdate>
  }
  iunlockput(dp);
80106026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106029:	89 04 24             	mov    %eax,(%esp)
8010602c:	e8 ef ba ff ff       	call   80101b20 <iunlockput>

  ip->nlink--;
80106031:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106034:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106038:	8d 50 ff             	lea    -0x1(%eax),%edx
8010603b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106042:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106045:	89 04 24             	mov    %eax,(%esp)
80106048:	e8 93 b6 ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
8010604d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106050:	89 04 24             	mov    %eax,(%esp)
80106053:	e8 c8 ba ff ff       	call   80101b20 <iunlockput>

  end_op();
80106058:	e8 c6 d4 ff ff       	call   80103523 <end_op>

  return 0;
8010605d:	b8 00 00 00 00       	mov    $0x0,%eax
80106062:	eb 16                	jmp    8010607a <sys_unlink+0x1d6>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106064:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106068:	89 04 24             	mov    %eax,(%esp)
8010606b:	e8 b0 ba ff ff       	call   80101b20 <iunlockput>
  end_op();
80106070:	e8 ae d4 ff ff       	call   80103523 <end_op>
  return -1;
80106075:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010607a:	c9                   	leave  
8010607b:	c3                   	ret    

8010607c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010607c:	55                   	push   %ebp
8010607d:	89 e5                	mov    %esp,%ebp
8010607f:	83 ec 48             	sub    $0x48,%esp
80106082:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106085:	8b 55 10             	mov    0x10(%ebp),%edx
80106088:	8b 45 14             	mov    0x14(%ebp),%eax
8010608b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010608f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106093:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106097:	8d 45 de             	lea    -0x22(%ebp),%eax
8010609a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010609e:	8b 45 08             	mov    0x8(%ebp),%eax
801060a1:	89 04 24             	mov    %eax,(%esp)
801060a4:	e8 d6 c3 ff ff       	call   8010247f <nameiparent>
801060a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b0:	75 0a                	jne    801060bc <create+0x40>
    return 0;
801060b2:	b8 00 00 00 00       	mov    $0x0,%eax
801060b7:	e9 7e 01 00 00       	jmp    8010623a <create+0x1be>
  ilock(dp);
801060bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060bf:	89 04 24             	mov    %eax,(%esp)
801060c2:	e8 d5 b7 ff ff       	call   8010189c <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801060c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060ca:	89 44 24 08          	mov    %eax,0x8(%esp)
801060ce:	8d 45 de             	lea    -0x22(%ebp),%eax
801060d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d8:	89 04 24             	mov    %eax,(%esp)
801060db:	e8 f2 bf ff ff       	call   801020d2 <dirlookup>
801060e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060e7:	74 47                	je     80106130 <create+0xb4>
    iunlockput(dp);
801060e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ec:	89 04 24             	mov    %eax,(%esp)
801060ef:	e8 2c ba ff ff       	call   80101b20 <iunlockput>
    ilock(ip);
801060f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060f7:	89 04 24             	mov    %eax,(%esp)
801060fa:	e8 9d b7 ff ff       	call   8010189c <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801060ff:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106104:	75 15                	jne    8010611b <create+0x9f>
80106106:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106109:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010610d:	66 83 f8 02          	cmp    $0x2,%ax
80106111:	75 08                	jne    8010611b <create+0x9f>
      return ip;
80106113:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106116:	e9 1f 01 00 00       	jmp    8010623a <create+0x1be>
    iunlockput(ip);
8010611b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010611e:	89 04 24             	mov    %eax,(%esp)
80106121:	e8 fa b9 ff ff       	call   80101b20 <iunlockput>
    return 0;
80106126:	b8 00 00 00 00       	mov    $0x0,%eax
8010612b:	e9 0a 01 00 00       	jmp    8010623a <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106130:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106134:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106137:	8b 00                	mov    (%eax),%eax
80106139:	89 54 24 04          	mov    %edx,0x4(%esp)
8010613d:	89 04 24             	mov    %eax,(%esp)
80106140:	e8 bc b4 ff ff       	call   80101601 <ialloc>
80106145:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106148:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010614c:	75 0c                	jne    8010615a <create+0xde>
    panic("create: ialloc");
8010614e:	c7 04 24 67 8e 10 80 	movl   $0x80108e67,(%esp)
80106155:	e8 ec a3 ff ff       	call   80100546 <panic>

  ilock(ip);
8010615a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010615d:	89 04 24             	mov    %eax,(%esp)
80106160:	e8 37 b7 ff ff       	call   8010189c <ilock>
  ip->major = major;
80106165:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106168:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010616c:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106170:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106173:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106177:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010617b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010617e:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106184:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106187:	89 04 24             	mov    %eax,(%esp)
8010618a:	e8 51 b5 ff ff       	call   801016e0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010618f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106194:	75 6a                	jne    80106200 <create+0x184>
    dp->nlink++;  // for ".."
80106196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106199:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010619d:	8d 50 01             	lea    0x1(%eax),%edx
801061a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a3:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801061a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061aa:	89 04 24             	mov    %eax,(%esp)
801061ad:	e8 2e b5 ff ff       	call   801016e0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801061b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061b5:	8b 40 04             	mov    0x4(%eax),%eax
801061b8:	89 44 24 08          	mov    %eax,0x8(%esp)
801061bc:	c7 44 24 04 41 8e 10 	movl   $0x80108e41,0x4(%esp)
801061c3:	80 
801061c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c7:	89 04 24             	mov    %eax,(%esp)
801061ca:	e8 cb bf ff ff       	call   8010219a <dirlink>
801061cf:	85 c0                	test   %eax,%eax
801061d1:	78 21                	js     801061f4 <create+0x178>
801061d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d6:	8b 40 04             	mov    0x4(%eax),%eax
801061d9:	89 44 24 08          	mov    %eax,0x8(%esp)
801061dd:	c7 44 24 04 43 8e 10 	movl   $0x80108e43,0x4(%esp)
801061e4:	80 
801061e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061e8:	89 04 24             	mov    %eax,(%esp)
801061eb:	e8 aa bf ff ff       	call   8010219a <dirlink>
801061f0:	85 c0                	test   %eax,%eax
801061f2:	79 0c                	jns    80106200 <create+0x184>
      panic("create dots");
801061f4:	c7 04 24 76 8e 10 80 	movl   $0x80108e76,(%esp)
801061fb:	e8 46 a3 ff ff       	call   80100546 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106200:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106203:	8b 40 04             	mov    0x4(%eax),%eax
80106206:	89 44 24 08          	mov    %eax,0x8(%esp)
8010620a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010620d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106211:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106214:	89 04 24             	mov    %eax,(%esp)
80106217:	e8 7e bf ff ff       	call   8010219a <dirlink>
8010621c:	85 c0                	test   %eax,%eax
8010621e:	79 0c                	jns    8010622c <create+0x1b0>
    panic("create: dirlink");
80106220:	c7 04 24 82 8e 10 80 	movl   $0x80108e82,(%esp)
80106227:	e8 1a a3 ff ff       	call   80100546 <panic>

  iunlockput(dp);
8010622c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010622f:	89 04 24             	mov    %eax,(%esp)
80106232:	e8 e9 b8 ff ff       	call   80101b20 <iunlockput>

  return ip;
80106237:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010623a:	c9                   	leave  
8010623b:	c3                   	ret    

8010623c <sys_open>:

int
sys_open(void)
{
8010623c:	55                   	push   %ebp
8010623d:	89 e5                	mov    %esp,%ebp
8010623f:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106242:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106245:	89 44 24 04          	mov    %eax,0x4(%esp)
80106249:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106250:	e8 da f6 ff ff       	call   8010592f <argstr>
80106255:	85 c0                	test   %eax,%eax
80106257:	78 17                	js     80106270 <sys_open+0x34>
80106259:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010625c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106260:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106267:	e8 33 f6 ff ff       	call   8010589f <argint>
8010626c:	85 c0                	test   %eax,%eax
8010626e:	79 0a                	jns    8010627a <sys_open+0x3e>
    return -1;
80106270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106275:	e9 5c 01 00 00       	jmp    801063d6 <sys_open+0x19a>

  begin_op();
8010627a:	e8 23 d2 ff ff       	call   801034a2 <begin_op>

  if(omode & O_CREATE){
8010627f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106282:	25 00 02 00 00       	and    $0x200,%eax
80106287:	85 c0                	test   %eax,%eax
80106289:	74 3b                	je     801062c6 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
8010628b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010628e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106295:	00 
80106296:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010629d:	00 
8010629e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801062a5:	00 
801062a6:	89 04 24             	mov    %eax,(%esp)
801062a9:	e8 ce fd ff ff       	call   8010607c <create>
801062ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801062b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062b5:	75 6b                	jne    80106322 <sys_open+0xe6>
      end_op();
801062b7:	e8 67 d2 ff ff       	call   80103523 <end_op>
      return -1;
801062bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c1:	e9 10 01 00 00       	jmp    801063d6 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
801062c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062c9:	89 04 24             	mov    %eax,(%esp)
801062cc:	e8 8c c1 ff ff       	call   8010245d <namei>
801062d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062d8:	75 0f                	jne    801062e9 <sys_open+0xad>
      end_op();
801062da:	e8 44 d2 ff ff       	call   80103523 <end_op>
      return -1;
801062df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e4:	e9 ed 00 00 00       	jmp    801063d6 <sys_open+0x19a>
    }
    ilock(ip);
801062e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ec:	89 04 24             	mov    %eax,(%esp)
801062ef:	e8 a8 b5 ff ff       	call   8010189c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801062f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062f7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062fb:	66 83 f8 01          	cmp    $0x1,%ax
801062ff:	75 21                	jne    80106322 <sys_open+0xe6>
80106301:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106304:	85 c0                	test   %eax,%eax
80106306:	74 1a                	je     80106322 <sys_open+0xe6>
      iunlockput(ip);
80106308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010630b:	89 04 24             	mov    %eax,(%esp)
8010630e:	e8 0d b8 ff ff       	call   80101b20 <iunlockput>
      end_op();
80106313:	e8 0b d2 ff ff       	call   80103523 <end_op>
      return -1;
80106318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010631d:	e9 b4 00 00 00       	jmp    801063d6 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106322:	e8 27 ac ff ff       	call   80100f4e <filealloc>
80106327:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010632a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010632e:	74 14                	je     80106344 <sys_open+0x108>
80106330:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106333:	89 04 24             	mov    %eax,(%esp)
80106336:	e8 2f f7 ff ff       	call   80105a6a <fdalloc>
8010633b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010633e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106342:	79 28                	jns    8010636c <sys_open+0x130>
    if(f)
80106344:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106348:	74 0b                	je     80106355 <sys_open+0x119>
      fileclose(f);
8010634a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634d:	89 04 24             	mov    %eax,(%esp)
80106350:	e8 a1 ac ff ff       	call   80100ff6 <fileclose>
    iunlockput(ip);
80106355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106358:	89 04 24             	mov    %eax,(%esp)
8010635b:	e8 c0 b7 ff ff       	call   80101b20 <iunlockput>
    end_op();
80106360:	e8 be d1 ff ff       	call   80103523 <end_op>
    return -1;
80106365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010636a:	eb 6a                	jmp    801063d6 <sys_open+0x19a>
  }
  iunlock(ip);
8010636c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010636f:	89 04 24             	mov    %eax,(%esp)
80106372:	e8 73 b6 ff ff       	call   801019ea <iunlock>
  end_op();
80106377:	e8 a7 d1 ff ff       	call   80103523 <end_op>

  f->type = FD_INODE;
8010637c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010637f:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106385:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106388:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010638b:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010638e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106391:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106398:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010639b:	83 e0 01             	and    $0x1,%eax
8010639e:	85 c0                	test   %eax,%eax
801063a0:	0f 94 c0             	sete   %al
801063a3:	89 c2                	mov    %eax,%edx
801063a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a8:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801063ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063ae:	83 e0 01             	and    $0x1,%eax
801063b1:	85 c0                	test   %eax,%eax
801063b3:	75 0a                	jne    801063bf <sys_open+0x183>
801063b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063b8:	83 e0 02             	and    $0x2,%eax
801063bb:	85 c0                	test   %eax,%eax
801063bd:	74 07                	je     801063c6 <sys_open+0x18a>
801063bf:	b8 01 00 00 00       	mov    $0x1,%eax
801063c4:	eb 05                	jmp    801063cb <sys_open+0x18f>
801063c6:	b8 00 00 00 00       	mov    $0x0,%eax
801063cb:	89 c2                	mov    %eax,%edx
801063cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d0:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801063d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801063d6:	c9                   	leave  
801063d7:	c3                   	ret    

801063d8 <sys_mkdir>:

int
sys_mkdir(void)
{
801063d8:	55                   	push   %ebp
801063d9:	89 e5                	mov    %esp,%ebp
801063db:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801063de:	e8 bf d0 ff ff       	call   801034a2 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801063e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801063ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063f1:	e8 39 f5 ff ff       	call   8010592f <argstr>
801063f6:	85 c0                	test   %eax,%eax
801063f8:	78 2c                	js     80106426 <sys_mkdir+0x4e>
801063fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063fd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106404:	00 
80106405:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010640c:	00 
8010640d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106414:	00 
80106415:	89 04 24             	mov    %eax,(%esp)
80106418:	e8 5f fc ff ff       	call   8010607c <create>
8010641d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106424:	75 0c                	jne    80106432 <sys_mkdir+0x5a>
    end_op();
80106426:	e8 f8 d0 ff ff       	call   80103523 <end_op>
    return -1;
8010642b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106430:	eb 15                	jmp    80106447 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106435:	89 04 24             	mov    %eax,(%esp)
80106438:	e8 e3 b6 ff ff       	call   80101b20 <iunlockput>
  end_op();
8010643d:	e8 e1 d0 ff ff       	call   80103523 <end_op>
  return 0;
80106442:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106447:	c9                   	leave  
80106448:	c3                   	ret    

80106449 <sys_mknod>:

int
sys_mknod(void)
{
80106449:	55                   	push   %ebp
8010644a:	89 e5                	mov    %esp,%ebp
8010644c:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010644f:	e8 4e d0 ff ff       	call   801034a2 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106454:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106457:	89 44 24 04          	mov    %eax,0x4(%esp)
8010645b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106462:	e8 c8 f4 ff ff       	call   8010592f <argstr>
80106467:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010646a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010646e:	78 5e                	js     801064ce <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106470:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106473:	89 44 24 04          	mov    %eax,0x4(%esp)
80106477:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010647e:	e8 1c f4 ff ff       	call   8010589f <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106483:	85 c0                	test   %eax,%eax
80106485:	78 47                	js     801064ce <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106487:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010648a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010648e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106495:	e8 05 f4 ff ff       	call   8010589f <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010649a:	85 c0                	test   %eax,%eax
8010649c:	78 30                	js     801064ce <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
8010649e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064a1:	0f bf c8             	movswl %ax,%ecx
801064a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064a7:	0f bf d0             	movswl %ax,%edx
801064aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801064ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801064b1:	89 54 24 08          	mov    %edx,0x8(%esp)
801064b5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801064bc:	00 
801064bd:	89 04 24             	mov    %eax,(%esp)
801064c0:	e8 b7 fb ff ff       	call   8010607c <create>
801064c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064cc:	75 0c                	jne    801064da <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801064ce:	e8 50 d0 ff ff       	call   80103523 <end_op>
    return -1;
801064d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064d8:	eb 15                	jmp    801064ef <sys_mknod+0xa6>
  }
  iunlockput(ip);
801064da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064dd:	89 04 24             	mov    %eax,(%esp)
801064e0:	e8 3b b6 ff ff       	call   80101b20 <iunlockput>
  end_op();
801064e5:	e8 39 d0 ff ff       	call   80103523 <end_op>
  return 0;
801064ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064ef:	c9                   	leave  
801064f0:	c3                   	ret    

801064f1 <sys_chdir>:

int
sys_chdir(void)
{
801064f1:	55                   	push   %ebp
801064f2:	89 e5                	mov    %esp,%ebp
801064f4:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801064f7:	e8 a6 cf ff ff       	call   801034a2 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801064fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80106503:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010650a:	e8 20 f4 ff ff       	call   8010592f <argstr>
8010650f:	85 c0                	test   %eax,%eax
80106511:	78 14                	js     80106527 <sys_chdir+0x36>
80106513:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106516:	89 04 24             	mov    %eax,(%esp)
80106519:	e8 3f bf ff ff       	call   8010245d <namei>
8010651e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106525:	75 0c                	jne    80106533 <sys_chdir+0x42>
    end_op();
80106527:	e8 f7 cf ff ff       	call   80103523 <end_op>
    return -1;
8010652c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106531:	eb 61                	jmp    80106594 <sys_chdir+0xa3>
  }
  ilock(ip);
80106533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106536:	89 04 24             	mov    %eax,(%esp)
80106539:	e8 5e b3 ff ff       	call   8010189c <ilock>
  if(ip->type != T_DIR){
8010653e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106541:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106545:	66 83 f8 01          	cmp    $0x1,%ax
80106549:	74 17                	je     80106562 <sys_chdir+0x71>
    iunlockput(ip);
8010654b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010654e:	89 04 24             	mov    %eax,(%esp)
80106551:	e8 ca b5 ff ff       	call   80101b20 <iunlockput>
    end_op();
80106556:	e8 c8 cf ff ff       	call   80103523 <end_op>
    return -1;
8010655b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106560:	eb 32                	jmp    80106594 <sys_chdir+0xa3>
  }
  iunlock(ip);
80106562:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106565:	89 04 24             	mov    %eax,(%esp)
80106568:	e8 7d b4 ff ff       	call   801019ea <iunlock>
  iput(proc->cwd);
8010656d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106573:	8b 40 68             	mov    0x68(%eax),%eax
80106576:	89 04 24             	mov    %eax,(%esp)
80106579:	e8 d1 b4 ff ff       	call   80101a4f <iput>
  end_op();
8010657e:	e8 a0 cf ff ff       	call   80103523 <end_op>
  proc->cwd = ip;
80106583:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106589:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010658c:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010658f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106594:	c9                   	leave  
80106595:	c3                   	ret    

80106596 <sys_exec>:

int
sys_exec(void)
{
80106596:	55                   	push   %ebp
80106597:	89 e5                	mov    %esp,%ebp
80106599:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010659f:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801065a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065ad:	e8 7d f3 ff ff       	call   8010592f <argstr>
801065b2:	85 c0                	test   %eax,%eax
801065b4:	78 1a                	js     801065d0 <sys_exec+0x3a>
801065b6:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801065bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801065c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801065c7:	e8 d3 f2 ff ff       	call   8010589f <argint>
801065cc:	85 c0                	test   %eax,%eax
801065ce:	79 0a                	jns    801065da <sys_exec+0x44>
    return -1;
801065d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d5:	e9 c8 00 00 00       	jmp    801066a2 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801065da:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801065e1:	00 
801065e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065e9:	00 
801065ea:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065f0:	89 04 24             	mov    %eax,(%esp)
801065f3:	e8 4f ef ff ff       	call   80105547 <memset>
  for(i=0;; i++){
801065f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801065ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106602:	83 f8 1f             	cmp    $0x1f,%eax
80106605:	76 0a                	jbe    80106611 <sys_exec+0x7b>
      return -1;
80106607:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010660c:	e9 91 00 00 00       	jmp    801066a2 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106614:	c1 e0 02             	shl    $0x2,%eax
80106617:	89 c2                	mov    %eax,%edx
80106619:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010661f:	01 c2                	add    %eax,%edx
80106621:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106627:	89 44 24 04          	mov    %eax,0x4(%esp)
8010662b:	89 14 24             	mov    %edx,(%esp)
8010662e:	e8 ce f1 ff ff       	call   80105801 <fetchint>
80106633:	85 c0                	test   %eax,%eax
80106635:	79 07                	jns    8010663e <sys_exec+0xa8>
      return -1;
80106637:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010663c:	eb 64                	jmp    801066a2 <sys_exec+0x10c>
    if(uarg == 0){
8010663e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106644:	85 c0                	test   %eax,%eax
80106646:	75 26                	jne    8010666e <sys_exec+0xd8>
      argv[i] = 0;
80106648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010664b:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106652:	00 00 00 00 
      break;
80106656:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106657:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010665a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106660:	89 54 24 04          	mov    %edx,0x4(%esp)
80106664:	89 04 24             	mov    %eax,(%esp)
80106667:	e8 9a a4 ff ff       	call   80100b06 <exec>
8010666c:	eb 34                	jmp    801066a2 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010666e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106674:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106677:	c1 e2 02             	shl    $0x2,%edx
8010667a:	01 c2                	add    %eax,%edx
8010667c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106682:	89 54 24 04          	mov    %edx,0x4(%esp)
80106686:	89 04 24             	mov    %eax,(%esp)
80106689:	e8 ad f1 ff ff       	call   8010583b <fetchstr>
8010668e:	85 c0                	test   %eax,%eax
80106690:	79 07                	jns    80106699 <sys_exec+0x103>
      return -1;
80106692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106697:	eb 09                	jmp    801066a2 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106699:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010669d:	e9 5d ff ff ff       	jmp    801065ff <sys_exec+0x69>
  return exec(path, argv);
}
801066a2:	c9                   	leave  
801066a3:	c3                   	ret    

801066a4 <sys_pipe>:

int
sys_pipe(void)
{
801066a4:	55                   	push   %ebp
801066a5:	89 e5                	mov    %esp,%ebp
801066a7:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801066aa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801066b1:	00 
801066b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801066b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801066b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066c0:	e8 08 f2 ff ff       	call   801058cd <argptr>
801066c5:	85 c0                	test   %eax,%eax
801066c7:	79 0a                	jns    801066d3 <sys_pipe+0x2f>
    return -1;
801066c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ce:	e9 9b 00 00 00       	jmp    8010676e <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801066d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801066da:	8d 45 e8             	lea    -0x18(%ebp),%eax
801066dd:	89 04 24             	mov    %eax,(%esp)
801066e0:	e8 d5 d8 ff ff       	call   80103fba <pipealloc>
801066e5:	85 c0                	test   %eax,%eax
801066e7:	79 07                	jns    801066f0 <sys_pipe+0x4c>
    return -1;
801066e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ee:	eb 7e                	jmp    8010676e <sys_pipe+0xca>
  fd0 = -1;
801066f0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801066f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066fa:	89 04 24             	mov    %eax,(%esp)
801066fd:	e8 68 f3 ff ff       	call   80105a6a <fdalloc>
80106702:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106705:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106709:	78 14                	js     8010671f <sys_pipe+0x7b>
8010670b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010670e:	89 04 24             	mov    %eax,(%esp)
80106711:	e8 54 f3 ff ff       	call   80105a6a <fdalloc>
80106716:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010671d:	79 37                	jns    80106756 <sys_pipe+0xb2>
    if(fd0 >= 0)
8010671f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106723:	78 14                	js     80106739 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106725:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010672b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010672e:	83 c2 08             	add    $0x8,%edx
80106731:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106738:	00 
    fileclose(rf);
80106739:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010673c:	89 04 24             	mov    %eax,(%esp)
8010673f:	e8 b2 a8 ff ff       	call   80100ff6 <fileclose>
    fileclose(wf);
80106744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106747:	89 04 24             	mov    %eax,(%esp)
8010674a:	e8 a7 a8 ff ff       	call   80100ff6 <fileclose>
    return -1;
8010674f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106754:	eb 18                	jmp    8010676e <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106756:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106759:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010675c:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010675e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106761:	8d 50 04             	lea    0x4(%eax),%edx
80106764:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106767:	89 02                	mov    %eax,(%edx)
  return 0;
80106769:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010676e:	c9                   	leave  
8010676f:	c3                   	ret    

80106770 <sys_getprocs>:
#include "uproc.h"


int
sys_getprocs(void)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	57                   	push   %edi
80106774:	56                   	push   %esi
80106775:	53                   	push   %ebx
80106776:	83 ec 3c             	sub    $0x3c,%esp
80106779:	89 e0                	mov    %esp,%eax
8010677b:	89 c6                	mov    %eax,%esi
  int max;

  argint(0, &max);
8010677d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106780:	89 44 24 04          	mov    %eax,0x4(%esp)
80106784:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010678b:	e8 0f f1 ff ff       	call   8010589f <argint>

  if(max < 0)
80106790:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106793:	85 c0                	test   %eax,%eax
80106795:	79 0a                	jns    801067a1 <sys_getprocs+0x31>
	return -1;
80106797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010679c:	e9 e7 00 00 00       	jmp    80106888 <sys_getprocs+0x118>

  struct uproc table[max];
801067a1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801067a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
801067a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067aa:	89 d8                	mov    %ebx,%eax
801067ac:	ba 00 00 00 00       	mov    $0x0,%edx
801067b1:	69 fa e0 00 00 00    	imul   $0xe0,%edx,%edi
801067b7:	6b c8 00             	imul   $0x0,%eax,%ecx
801067ba:	01 cf                	add    %ecx,%edi
801067bc:	b9 e0 00 00 00       	mov    $0xe0,%ecx
801067c1:	f7 e1                	mul    %ecx
801067c3:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
801067c6:	89 ca                	mov    %ecx,%edx
801067c8:	89 d8                	mov    %ebx,%eax
801067ca:	c1 e0 02             	shl    $0x2,%eax
801067cd:	89 d8                	mov    %ebx,%eax
801067cf:	ba 00 00 00 00       	mov    $0x0,%edx
801067d4:	69 fa e0 00 00 00    	imul   $0xe0,%edx,%edi
801067da:	6b c8 00             	imul   $0x0,%eax,%ecx
801067dd:	01 cf                	add    %ecx,%edi
801067df:	b9 e0 00 00 00       	mov    $0xe0,%ecx
801067e4:	f7 e1                	mul    %ecx
801067e6:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
801067e9:	89 ca                	mov    %ecx,%edx
801067eb:	89 d8                	mov    %ebx,%eax
801067ed:	c1 e0 02             	shl    $0x2,%eax
801067f0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801067f7:	89 d1                	mov    %edx,%ecx
801067f9:	29 c1                	sub    %eax,%ecx
801067fb:	89 c8                	mov    %ecx,%eax
801067fd:	8d 50 03             	lea    0x3(%eax),%edx
80106800:	b8 10 00 00 00       	mov    $0x10,%eax
80106805:	83 e8 01             	sub    $0x1,%eax
80106808:	01 d0                	add    %edx,%eax
8010680a:	c7 45 d4 10 00 00 00 	movl   $0x10,-0x2c(%ebp)
80106811:	ba 00 00 00 00       	mov    $0x0,%edx
80106816:	f7 75 d4             	divl   -0x2c(%ebp)
80106819:	6b c0 10             	imul   $0x10,%eax,%eax
8010681c:	29 c4                	sub    %eax,%esp
8010681e:	8d 44 24 0c          	lea    0xc(%esp),%eax
80106822:	83 c0 03             	add    $0x3,%eax
80106825:	c1 e8 02             	shr    $0x2,%eax
80106828:	c1 e0 02             	shl    $0x2,%eax
8010682b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  argptr(1, (void*)&table, sizeof(table));
8010682e:	89 d8                	mov    %ebx,%eax
80106830:	c1 e0 02             	shl    $0x2,%eax
80106833:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
8010683a:	89 d1                	mov    %edx,%ecx
8010683c:	29 c1                	sub    %eax,%ecx
8010683e:	89 c8                	mov    %ecx,%eax
80106840:	89 c2                	mov    %eax,%edx
80106842:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106845:	89 54 24 08          	mov    %edx,0x8(%esp)
80106849:	89 44 24 04          	mov    %eax,0x4(%esp)
8010684d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106854:	e8 74 f0 ff ff       	call   801058cd <argptr>

  if(sizeof(table) <= 0)
80106859:	89 d8                	mov    %ebx,%eax
8010685b:	c1 e0 02             	shl    $0x2,%eax
8010685e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80106865:	89 d1                	mov    %edx,%ecx
80106867:	29 c1                	sub    %eax,%ecx
80106869:	89 c8                	mov    %ecx,%eax
8010686b:	85 c0                	test   %eax,%eax
8010686d:	75 07                	jne    80106876 <sys_getprocs+0x106>
	return -1;
8010686f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106874:	eb 12                	jmp    80106888 <sys_getprocs+0x118>

  return getprocs(max, table);
80106876:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106879:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010687c:	89 54 24 04          	mov    %edx,0x4(%esp)
80106880:	89 04 24             	mov    %eax,(%esp)
80106883:	e8 07 db ff ff       	call   8010438f <getprocs>
80106888:	89 f4                	mov    %esi,%esp
}
8010688a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010688d:	5b                   	pop    %ebx
8010688e:	5e                   	pop    %esi
8010688f:	5f                   	pop    %edi
80106890:	5d                   	pop    %ebp
80106891:	c3                   	ret    

80106892 <sys_fork>:

int
sys_fork(void)
{
80106892:	55                   	push   %ebp
80106893:	89 e5                	mov    %esp,%ebp
80106895:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106898:	e8 21 e2 ff ff       	call   80104abe <fork>
}
8010689d:	c9                   	leave  
8010689e:	c3                   	ret    

8010689f <sys_exit>:

int
sys_exit(void)
{
8010689f:	55                   	push   %ebp
801068a0:	89 e5                	mov    %esp,%ebp
801068a2:	83 ec 08             	sub    $0x8,%esp
  exit();
801068a5:	e8 8f e3 ff ff       	call   80104c39 <exit>
  return 0;  // not reached
801068aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068af:	c9                   	leave  
801068b0:	c3                   	ret    

801068b1 <sys_wait>:

int
sys_wait(void)
{
801068b1:	55                   	push   %ebp
801068b2:	89 e5                	mov    %esp,%ebp
801068b4:	83 ec 08             	sub    $0x8,%esp
  return wait();
801068b7:	e8 9f e4 ff ff       	call   80104d5b <wait>
}
801068bc:	c9                   	leave  
801068bd:	c3                   	ret    

801068be <sys_kill>:

int
sys_kill(void)
{
801068be:	55                   	push   %ebp
801068bf:	89 e5                	mov    %esp,%ebp
801068c1:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801068c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801068cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068d2:	e8 c8 ef ff ff       	call   8010589f <argint>
801068d7:	85 c0                	test   %eax,%eax
801068d9:	79 07                	jns    801068e2 <sys_kill+0x24>
    return -1;
801068db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e0:	eb 0b                	jmp    801068ed <sys_kill+0x2f>
  return kill(pid);
801068e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e5:	89 04 24             	mov    %eax,(%esp)
801068e8:	e8 2a e8 ff ff       	call   80105117 <kill>
}
801068ed:	c9                   	leave  
801068ee:	c3                   	ret    

801068ef <sys_getpid>:

int
sys_getpid(void)
{
801068ef:	55                   	push   %ebp
801068f0:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801068f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068f8:	8b 40 10             	mov    0x10(%eax),%eax
}
801068fb:	5d                   	pop    %ebp
801068fc:	c3                   	ret    

801068fd <sys_sbrk>:

int
sys_sbrk(void)
{
801068fd:	55                   	push   %ebp
801068fe:	89 e5                	mov    %esp,%ebp
80106900:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106903:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106906:	89 44 24 04          	mov    %eax,0x4(%esp)
8010690a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106911:	e8 89 ef ff ff       	call   8010589f <argint>
80106916:	85 c0                	test   %eax,%eax
80106918:	79 07                	jns    80106921 <sys_sbrk+0x24>
    return -1;
8010691a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010691f:	eb 24                	jmp    80106945 <sys_sbrk+0x48>
  addr = proc->sz;
80106921:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106927:	8b 00                	mov    (%eax),%eax
80106929:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010692c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010692f:	89 04 24             	mov    %eax,(%esp)
80106932:	e8 e2 e0 ff ff       	call   80104a19 <growproc>
80106937:	85 c0                	test   %eax,%eax
80106939:	79 07                	jns    80106942 <sys_sbrk+0x45>
    return -1;
8010693b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106940:	eb 03                	jmp    80106945 <sys_sbrk+0x48>
  return addr;
80106942:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106945:	c9                   	leave  
80106946:	c3                   	ret    

80106947 <sys_sleep>:

int
sys_sleep(void)
{
80106947:	55                   	push   %ebp
80106948:	89 e5                	mov    %esp,%ebp
8010694a:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010694d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106950:	89 44 24 04          	mov    %eax,0x4(%esp)
80106954:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010695b:	e8 3f ef ff ff       	call   8010589f <argint>
80106960:	85 c0                	test   %eax,%eax
80106962:	79 07                	jns    8010696b <sys_sleep+0x24>
    return -1;
80106964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106969:	eb 6c                	jmp    801069d7 <sys_sleep+0x90>
  acquire(&tickslock);
8010696b:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
80106972:	e8 78 e9 ff ff       	call   801052ef <acquire>
  ticks0 = ticks;
80106977:	a1 e0 60 11 80       	mov    0x801160e0,%eax
8010697c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010697f:	eb 34                	jmp    801069b5 <sys_sleep+0x6e>
    if(proc->killed){
80106981:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106987:	8b 40 24             	mov    0x24(%eax),%eax
8010698a:	85 c0                	test   %eax,%eax
8010698c:	74 13                	je     801069a1 <sys_sleep+0x5a>
      release(&tickslock);
8010698e:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
80106995:	e8 b7 e9 ff ff       	call   80105351 <release>
      return -1;
8010699a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010699f:	eb 36                	jmp    801069d7 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801069a1:	c7 44 24 04 a0 58 11 	movl   $0x801158a0,0x4(%esp)
801069a8:	80 
801069a9:	c7 04 24 e0 60 11 80 	movl   $0x801160e0,(%esp)
801069b0:	e8 5e e6 ff ff       	call   80105013 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801069b5:	a1 e0 60 11 80       	mov    0x801160e0,%eax
801069ba:	89 c2                	mov    %eax,%edx
801069bc:	2b 55 f4             	sub    -0xc(%ebp),%edx
801069bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069c2:	39 c2                	cmp    %eax,%edx
801069c4:	72 bb                	jb     80106981 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801069c6:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
801069cd:	e8 7f e9 ff ff       	call   80105351 <release>
  return 0;
801069d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069d7:	c9                   	leave  
801069d8:	c3                   	ret    

801069d9 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801069d9:	55                   	push   %ebp
801069da:	89 e5                	mov    %esp,%ebp
801069dc:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801069df:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
801069e6:	e8 04 e9 ff ff       	call   801052ef <acquire>
  xticks = ticks;
801069eb:	a1 e0 60 11 80       	mov    0x801160e0,%eax
801069f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801069f3:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
801069fa:	e8 52 e9 ff ff       	call   80105351 <release>
  return xticks;
801069ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a02:	c9                   	leave  
80106a03:	c3                   	ret    

80106a04 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a04:	55                   	push   %ebp
80106a05:	89 e5                	mov    %esp,%ebp
80106a07:	83 ec 08             	sub    $0x8,%esp
80106a0a:	8b 55 08             	mov    0x8(%ebp),%edx
80106a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a10:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a14:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a17:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a1b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106a1f:	ee                   	out    %al,(%dx)
}
80106a20:	c9                   	leave  
80106a21:	c3                   	ret    

80106a22 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106a22:	55                   	push   %ebp
80106a23:	89 e5                	mov    %esp,%ebp
80106a25:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106a28:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106a2f:	00 
80106a30:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106a37:	e8 c8 ff ff ff       	call   80106a04 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106a3c:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106a43:	00 
80106a44:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106a4b:	e8 b4 ff ff ff       	call   80106a04 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106a50:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106a57:	00 
80106a58:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106a5f:	e8 a0 ff ff ff       	call   80106a04 <outb>
  picenable(IRQ_TIMER);
80106a64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a6b:	e8 d6 d3 ff ff       	call   80103e46 <picenable>
}
80106a70:	c9                   	leave  
80106a71:	c3                   	ret    

80106a72 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a72:	1e                   	push   %ds
  pushl %es
80106a73:	06                   	push   %es
  pushl %fs
80106a74:	0f a0                	push   %fs
  pushl %gs
80106a76:	0f a8                	push   %gs
  pushal
80106a78:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106a79:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a7d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a7f:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106a81:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106a85:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106a87:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106a89:	54                   	push   %esp
  call trap
80106a8a:	e8 dd 01 00 00       	call   80106c6c <trap>
  addl $4, %esp
80106a8f:	83 c4 04             	add    $0x4,%esp

80106a92 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106a92:	61                   	popa   
  popl %gs
80106a93:	0f a9                	pop    %gs
  popl %fs
80106a95:	0f a1                	pop    %fs
  popl %es
80106a97:	07                   	pop    %es
  popl %ds
80106a98:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106a99:	83 c4 08             	add    $0x8,%esp
  iret
80106a9c:	cf                   	iret   

80106a9d <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106a9d:	55                   	push   %ebp
80106a9e:	89 e5                	mov    %esp,%ebp
80106aa0:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106aa6:	83 e8 01             	sub    $0x1,%eax
80106aa9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106aad:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab7:	c1 e8 10             	shr    $0x10,%eax
80106aba:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106abe:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106ac1:	0f 01 18             	lidtl  (%eax)
}
80106ac4:	c9                   	leave  
80106ac5:	c3                   	ret    

80106ac6 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106ac6:	55                   	push   %ebp
80106ac7:	89 e5                	mov    %esp,%ebp
80106ac9:	53                   	push   %ebx
80106aca:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106acd:	0f 20 d3             	mov    %cr2,%ebx
80106ad0:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106ad3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106ad6:	83 c4 10             	add    $0x10,%esp
80106ad9:	5b                   	pop    %ebx
80106ada:	5d                   	pop    %ebp
80106adb:	c3                   	ret    

80106adc <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106adc:	55                   	push   %ebp
80106add:	89 e5                	mov    %esp,%ebp
80106adf:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106ae2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ae9:	e9 c3 00 00 00       	jmp    80106bb1 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106af1:	8b 04 85 9c c0 10 80 	mov    -0x7fef3f64(,%eax,4),%eax
80106af8:	89 c2                	mov    %eax,%edx
80106afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106afd:	66 89 14 c5 e0 58 11 	mov    %dx,-0x7feea720(,%eax,8)
80106b04:	80 
80106b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b08:	66 c7 04 c5 e2 58 11 	movw   $0x8,-0x7feea71e(,%eax,8)
80106b0f:	80 08 00 
80106b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b15:	0f b6 14 c5 e4 58 11 	movzbl -0x7feea71c(,%eax,8),%edx
80106b1c:	80 
80106b1d:	83 e2 e0             	and    $0xffffffe0,%edx
80106b20:	88 14 c5 e4 58 11 80 	mov    %dl,-0x7feea71c(,%eax,8)
80106b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2a:	0f b6 14 c5 e4 58 11 	movzbl -0x7feea71c(,%eax,8),%edx
80106b31:	80 
80106b32:	83 e2 1f             	and    $0x1f,%edx
80106b35:	88 14 c5 e4 58 11 80 	mov    %dl,-0x7feea71c(,%eax,8)
80106b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b3f:	0f b6 14 c5 e5 58 11 	movzbl -0x7feea71b(,%eax,8),%edx
80106b46:	80 
80106b47:	83 e2 f0             	and    $0xfffffff0,%edx
80106b4a:	83 ca 0e             	or     $0xe,%edx
80106b4d:	88 14 c5 e5 58 11 80 	mov    %dl,-0x7feea71b(,%eax,8)
80106b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b57:	0f b6 14 c5 e5 58 11 	movzbl -0x7feea71b(,%eax,8),%edx
80106b5e:	80 
80106b5f:	83 e2 ef             	and    $0xffffffef,%edx
80106b62:	88 14 c5 e5 58 11 80 	mov    %dl,-0x7feea71b(,%eax,8)
80106b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b6c:	0f b6 14 c5 e5 58 11 	movzbl -0x7feea71b(,%eax,8),%edx
80106b73:	80 
80106b74:	83 e2 9f             	and    $0xffffff9f,%edx
80106b77:	88 14 c5 e5 58 11 80 	mov    %dl,-0x7feea71b(,%eax,8)
80106b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b81:	0f b6 14 c5 e5 58 11 	movzbl -0x7feea71b(,%eax,8),%edx
80106b88:	80 
80106b89:	83 ca 80             	or     $0xffffff80,%edx
80106b8c:	88 14 c5 e5 58 11 80 	mov    %dl,-0x7feea71b(,%eax,8)
80106b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b96:	8b 04 85 9c c0 10 80 	mov    -0x7fef3f64(,%eax,4),%eax
80106b9d:	c1 e8 10             	shr    $0x10,%eax
80106ba0:	89 c2                	mov    %eax,%edx
80106ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ba5:	66 89 14 c5 e6 58 11 	mov    %dx,-0x7feea71a(,%eax,8)
80106bac:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106bad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bb1:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106bb8:	0f 8e 30 ff ff ff    	jle    80106aee <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106bbe:	a1 9c c1 10 80       	mov    0x8010c19c,%eax
80106bc3:	66 a3 e0 5a 11 80    	mov    %ax,0x80115ae0
80106bc9:	66 c7 05 e2 5a 11 80 	movw   $0x8,0x80115ae2
80106bd0:	08 00 
80106bd2:	0f b6 05 e4 5a 11 80 	movzbl 0x80115ae4,%eax
80106bd9:	83 e0 e0             	and    $0xffffffe0,%eax
80106bdc:	a2 e4 5a 11 80       	mov    %al,0x80115ae4
80106be1:	0f b6 05 e4 5a 11 80 	movzbl 0x80115ae4,%eax
80106be8:	83 e0 1f             	and    $0x1f,%eax
80106beb:	a2 e4 5a 11 80       	mov    %al,0x80115ae4
80106bf0:	0f b6 05 e5 5a 11 80 	movzbl 0x80115ae5,%eax
80106bf7:	83 c8 0f             	or     $0xf,%eax
80106bfa:	a2 e5 5a 11 80       	mov    %al,0x80115ae5
80106bff:	0f b6 05 e5 5a 11 80 	movzbl 0x80115ae5,%eax
80106c06:	83 e0 ef             	and    $0xffffffef,%eax
80106c09:	a2 e5 5a 11 80       	mov    %al,0x80115ae5
80106c0e:	0f b6 05 e5 5a 11 80 	movzbl 0x80115ae5,%eax
80106c15:	83 c8 60             	or     $0x60,%eax
80106c18:	a2 e5 5a 11 80       	mov    %al,0x80115ae5
80106c1d:	0f b6 05 e5 5a 11 80 	movzbl 0x80115ae5,%eax
80106c24:	83 c8 80             	or     $0xffffff80,%eax
80106c27:	a2 e5 5a 11 80       	mov    %al,0x80115ae5
80106c2c:	a1 9c c1 10 80       	mov    0x8010c19c,%eax
80106c31:	c1 e8 10             	shr    $0x10,%eax
80106c34:	66 a3 e6 5a 11 80    	mov    %ax,0x80115ae6
  
  initlock(&tickslock, "time");
80106c3a:	c7 44 24 04 94 8e 10 	movl   $0x80108e94,0x4(%esp)
80106c41:	80 
80106c42:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
80106c49:	e8 80 e6 ff ff       	call   801052ce <initlock>
}
80106c4e:	c9                   	leave  
80106c4f:	c3                   	ret    

80106c50 <idtinit>:

void
idtinit(void)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106c56:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106c5d:	00 
80106c5e:	c7 04 24 e0 58 11 80 	movl   $0x801158e0,(%esp)
80106c65:	e8 33 fe ff ff       	call   80106a9d <lidt>
}
80106c6a:	c9                   	leave  
80106c6b:	c3                   	ret    

80106c6c <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106c6c:	55                   	push   %ebp
80106c6d:	89 e5                	mov    %esp,%ebp
80106c6f:	57                   	push   %edi
80106c70:	56                   	push   %esi
80106c71:	53                   	push   %ebx
80106c72:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106c75:	8b 45 08             	mov    0x8(%ebp),%eax
80106c78:	8b 40 30             	mov    0x30(%eax),%eax
80106c7b:	83 f8 40             	cmp    $0x40,%eax
80106c7e:	75 3e                	jne    80106cbe <trap+0x52>
    if(proc->killed)
80106c80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c86:	8b 40 24             	mov    0x24(%eax),%eax
80106c89:	85 c0                	test   %eax,%eax
80106c8b:	74 05                	je     80106c92 <trap+0x26>
      exit();
80106c8d:	e8 a7 df ff ff       	call   80104c39 <exit>
    proc->tf = tf;
80106c92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c98:	8b 55 08             	mov    0x8(%ebp),%edx
80106c9b:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106c9e:	e8 c3 ec ff ff       	call   80105966 <syscall>
    if(proc->killed)
80106ca3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ca9:	8b 40 24             	mov    0x24(%eax),%eax
80106cac:	85 c0                	test   %eax,%eax
80106cae:	0f 84 34 02 00 00    	je     80106ee8 <trap+0x27c>
      exit();
80106cb4:	e8 80 df ff ff       	call   80104c39 <exit>
    return;
80106cb9:	e9 2a 02 00 00       	jmp    80106ee8 <trap+0x27c>
  }

  switch(tf->trapno){
80106cbe:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc1:	8b 40 30             	mov    0x30(%eax),%eax
80106cc4:	83 e8 20             	sub    $0x20,%eax
80106cc7:	83 f8 1f             	cmp    $0x1f,%eax
80106cca:	0f 87 bc 00 00 00    	ja     80106d8c <trap+0x120>
80106cd0:	8b 04 85 3c 8f 10 80 	mov    -0x7fef70c4(,%eax,4),%eax
80106cd7:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106cd9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106cdf:	0f b6 00             	movzbl (%eax),%eax
80106ce2:	84 c0                	test   %al,%al
80106ce4:	75 31                	jne    80106d17 <trap+0xab>
      acquire(&tickslock);
80106ce6:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
80106ced:	e8 fd e5 ff ff       	call   801052ef <acquire>
      ticks++;
80106cf2:	a1 e0 60 11 80       	mov    0x801160e0,%eax
80106cf7:	83 c0 01             	add    $0x1,%eax
80106cfa:	a3 e0 60 11 80       	mov    %eax,0x801160e0
      wakeup(&ticks);
80106cff:	c7 04 24 e0 60 11 80 	movl   $0x801160e0,(%esp)
80106d06:	e8 e1 e3 ff ff       	call   801050ec <wakeup>
      release(&tickslock);
80106d0b:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
80106d12:	e8 3a e6 ff ff       	call   80105351 <release>
    }
    lapiceoi();
80106d17:	e8 43 c2 ff ff       	call   80102f5f <lapiceoi>
    break;
80106d1c:	e9 41 01 00 00       	jmp    80106e62 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106d21:	e8 1c ba ff ff       	call   80102742 <ideintr>
    lapiceoi();
80106d26:	e8 34 c2 ff ff       	call   80102f5f <lapiceoi>
    break;
80106d2b:	e9 32 01 00 00       	jmp    80106e62 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106d30:	e8 df bf ff ff       	call   80102d14 <kbdintr>
    lapiceoi();
80106d35:	e8 25 c2 ff ff       	call   80102f5f <lapiceoi>
    break;
80106d3a:	e9 23 01 00 00       	jmp    80106e62 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106d3f:	e8 a9 03 00 00       	call   801070ed <uartintr>
    lapiceoi();
80106d44:	e8 16 c2 ff ff       	call   80102f5f <lapiceoi>
    break;
80106d49:	e9 14 01 00 00       	jmp    80106e62 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
80106d4e:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d51:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106d54:	8b 45 08             	mov    0x8(%ebp),%eax
80106d57:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d5b:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106d5e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d64:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d67:	0f b6 c0             	movzbl %al,%eax
80106d6a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106d6e:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d72:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d76:	c7 04 24 9c 8e 10 80 	movl   $0x80108e9c,(%esp)
80106d7d:	e8 28 96 ff ff       	call   801003aa <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106d82:	e8 d8 c1 ff ff       	call   80102f5f <lapiceoi>
    break;
80106d87:	e9 d6 00 00 00       	jmp    80106e62 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106d8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d92:	85 c0                	test   %eax,%eax
80106d94:	74 11                	je     80106da7 <trap+0x13b>
80106d96:	8b 45 08             	mov    0x8(%ebp),%eax
80106d99:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106d9d:	0f b7 c0             	movzwl %ax,%eax
80106da0:	83 e0 03             	and    $0x3,%eax
80106da3:	85 c0                	test   %eax,%eax
80106da5:	75 46                	jne    80106ded <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106da7:	e8 1a fd ff ff       	call   80106ac6 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
80106dac:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106daf:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106db2:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106db9:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dbc:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106dbf:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dc2:	8b 52 30             	mov    0x30(%edx),%edx
80106dc5:	89 44 24 10          	mov    %eax,0x10(%esp)
80106dc9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106dcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106dd1:	89 54 24 04          	mov    %edx,0x4(%esp)
80106dd5:	c7 04 24 c0 8e 10 80 	movl   $0x80108ec0,(%esp)
80106ddc:	e8 c9 95 ff ff       	call   801003aa <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106de1:	c7 04 24 f2 8e 10 80 	movl   $0x80108ef2,(%esp)
80106de8:	e8 59 97 ff ff       	call   80100546 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ded:	e8 d4 fc ff ff       	call   80106ac6 <rcr2>
80106df2:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106df4:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106df7:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106dfa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e00:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e03:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106e06:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e09:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106e0c:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e0f:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106e12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e18:	83 c0 6c             	add    $0x6c,%eax
80106e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e24:	8b 40 10             	mov    0x10(%eax),%eax
80106e27:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106e2b:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106e2f:	89 74 24 14          	mov    %esi,0x14(%esp)
80106e33:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106e37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106e3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e3e:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e42:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e46:	c7 04 24 f8 8e 10 80 	movl   $0x80108ef8,(%esp)
80106e4d:	e8 58 95 ff ff       	call   801003aa <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106e52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e58:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106e5f:	eb 01                	jmp    80106e62 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106e61:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106e62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e68:	85 c0                	test   %eax,%eax
80106e6a:	74 24                	je     80106e90 <trap+0x224>
80106e6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e72:	8b 40 24             	mov    0x24(%eax),%eax
80106e75:	85 c0                	test   %eax,%eax
80106e77:	74 17                	je     80106e90 <trap+0x224>
80106e79:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e80:	0f b7 c0             	movzwl %ax,%eax
80106e83:	83 e0 03             	and    $0x3,%eax
80106e86:	83 f8 03             	cmp    $0x3,%eax
80106e89:	75 05                	jne    80106e90 <trap+0x224>
    exit();
80106e8b:	e8 a9 dd ff ff       	call   80104c39 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e96:	85 c0                	test   %eax,%eax
80106e98:	74 1e                	je     80106eb8 <trap+0x24c>
80106e9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ea0:	8b 40 0c             	mov    0xc(%eax),%eax
80106ea3:	83 f8 04             	cmp    $0x4,%eax
80106ea6:	75 10                	jne    80106eb8 <trap+0x24c>
80106ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80106eab:	8b 40 30             	mov    0x30(%eax),%eax
80106eae:	83 f8 20             	cmp    $0x20,%eax
80106eb1:	75 05                	jne    80106eb8 <trap+0x24c>
    yield();
80106eb3:	e8 fd e0 ff ff       	call   80104fb5 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ebe:	85 c0                	test   %eax,%eax
80106ec0:	74 27                	je     80106ee9 <trap+0x27d>
80106ec2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ec8:	8b 40 24             	mov    0x24(%eax),%eax
80106ecb:	85 c0                	test   %eax,%eax
80106ecd:	74 1a                	je     80106ee9 <trap+0x27d>
80106ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ed6:	0f b7 c0             	movzwl %ax,%eax
80106ed9:	83 e0 03             	and    $0x3,%eax
80106edc:	83 f8 03             	cmp    $0x3,%eax
80106edf:	75 08                	jne    80106ee9 <trap+0x27d>
    exit();
80106ee1:	e8 53 dd ff ff       	call   80104c39 <exit>
80106ee6:	eb 01                	jmp    80106ee9 <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106ee8:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106ee9:	83 c4 3c             	add    $0x3c,%esp
80106eec:	5b                   	pop    %ebx
80106eed:	5e                   	pop    %esi
80106eee:	5f                   	pop    %edi
80106eef:	5d                   	pop    %ebp
80106ef0:	c3                   	ret    

80106ef1 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106ef1:	55                   	push   %ebp
80106ef2:	89 e5                	mov    %esp,%ebp
80106ef4:	53                   	push   %ebx
80106ef5:	83 ec 14             	sub    $0x14,%esp
80106ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80106efb:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106eff:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80106f03:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80106f07:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80106f0b:	ec                   	in     (%dx),%al
80106f0c:	89 c3                	mov    %eax,%ebx
80106f0e:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80106f11:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80106f15:	83 c4 14             	add    $0x14,%esp
80106f18:	5b                   	pop    %ebx
80106f19:	5d                   	pop    %ebp
80106f1a:	c3                   	ret    

80106f1b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106f1b:	55                   	push   %ebp
80106f1c:	89 e5                	mov    %esp,%ebp
80106f1e:	83 ec 08             	sub    $0x8,%esp
80106f21:	8b 55 08             	mov    0x8(%ebp),%edx
80106f24:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f27:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106f2b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f2e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106f32:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106f36:	ee                   	out    %al,(%dx)
}
80106f37:	c9                   	leave  
80106f38:	c3                   	ret    

80106f39 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106f39:	55                   	push   %ebp
80106f3a:	89 e5                	mov    %esp,%ebp
80106f3c:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106f3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f46:	00 
80106f47:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106f4e:	e8 c8 ff ff ff       	call   80106f1b <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106f53:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106f5a:	00 
80106f5b:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106f62:	e8 b4 ff ff ff       	call   80106f1b <outb>
  outb(COM1+0, 115200/9600);
80106f67:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106f6e:	00 
80106f6f:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106f76:	e8 a0 ff ff ff       	call   80106f1b <outb>
  outb(COM1+1, 0);
80106f7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106f82:	00 
80106f83:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106f8a:	e8 8c ff ff ff       	call   80106f1b <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106f8f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106f96:	00 
80106f97:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106f9e:	e8 78 ff ff ff       	call   80106f1b <outb>
  outb(COM1+4, 0);
80106fa3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106faa:	00 
80106fab:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106fb2:	e8 64 ff ff ff       	call   80106f1b <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106fb7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106fbe:	00 
80106fbf:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106fc6:	e8 50 ff ff ff       	call   80106f1b <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106fcb:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106fd2:	e8 1a ff ff ff       	call   80106ef1 <inb>
80106fd7:	3c ff                	cmp    $0xff,%al
80106fd9:	74 6c                	je     80107047 <uartinit+0x10e>
    return;
  uart = 1;
80106fdb:	c7 05 4c c6 10 80 01 	movl   $0x1,0x8010c64c
80106fe2:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106fe5:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106fec:	e8 00 ff ff ff       	call   80106ef1 <inb>
  inb(COM1+0);
80106ff1:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ff8:	e8 f4 fe ff ff       	call   80106ef1 <inb>
  picenable(IRQ_COM1);
80106ffd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107004:	e8 3d ce ff ff       	call   80103e46 <picenable>
  ioapicenable(IRQ_COM1, 0);
80107009:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107010:	00 
80107011:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107018:	e8 a7 b9 ff ff       	call   801029c4 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010701d:	c7 45 f4 bc 8f 10 80 	movl   $0x80108fbc,-0xc(%ebp)
80107024:	eb 15                	jmp    8010703b <uartinit+0x102>
    uartputc(*p);
80107026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107029:	0f b6 00             	movzbl (%eax),%eax
8010702c:	0f be c0             	movsbl %al,%eax
8010702f:	89 04 24             	mov    %eax,(%esp)
80107032:	e8 13 00 00 00       	call   8010704a <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107037:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010703b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010703e:	0f b6 00             	movzbl (%eax),%eax
80107041:	84 c0                	test   %al,%al
80107043:	75 e1                	jne    80107026 <uartinit+0xed>
80107045:	eb 01                	jmp    80107048 <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107047:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107048:	c9                   	leave  
80107049:	c3                   	ret    

8010704a <uartputc>:

void
uartputc(int c)
{
8010704a:	55                   	push   %ebp
8010704b:	89 e5                	mov    %esp,%ebp
8010704d:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80107050:	a1 4c c6 10 80       	mov    0x8010c64c,%eax
80107055:	85 c0                	test   %eax,%eax
80107057:	74 4d                	je     801070a6 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107060:	eb 10                	jmp    80107072 <uartputc+0x28>
    microdelay(10);
80107062:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107069:	e8 16 bf ff ff       	call   80102f84 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010706e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107072:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107076:	7f 16                	jg     8010708e <uartputc+0x44>
80107078:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010707f:	e8 6d fe ff ff       	call   80106ef1 <inb>
80107084:	0f b6 c0             	movzbl %al,%eax
80107087:	83 e0 20             	and    $0x20,%eax
8010708a:	85 c0                	test   %eax,%eax
8010708c:	74 d4                	je     80107062 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010708e:	8b 45 08             	mov    0x8(%ebp),%eax
80107091:	0f b6 c0             	movzbl %al,%eax
80107094:	89 44 24 04          	mov    %eax,0x4(%esp)
80107098:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010709f:	e8 77 fe ff ff       	call   80106f1b <outb>
801070a4:	eb 01                	jmp    801070a7 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801070a6:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801070a7:	c9                   	leave  
801070a8:	c3                   	ret    

801070a9 <uartgetc>:

static int
uartgetc(void)
{
801070a9:	55                   	push   %ebp
801070aa:	89 e5                	mov    %esp,%ebp
801070ac:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801070af:	a1 4c c6 10 80       	mov    0x8010c64c,%eax
801070b4:	85 c0                	test   %eax,%eax
801070b6:	75 07                	jne    801070bf <uartgetc+0x16>
    return -1;
801070b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070bd:	eb 2c                	jmp    801070eb <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801070bf:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801070c6:	e8 26 fe ff ff       	call   80106ef1 <inb>
801070cb:	0f b6 c0             	movzbl %al,%eax
801070ce:	83 e0 01             	and    $0x1,%eax
801070d1:	85 c0                	test   %eax,%eax
801070d3:	75 07                	jne    801070dc <uartgetc+0x33>
    return -1;
801070d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070da:	eb 0f                	jmp    801070eb <uartgetc+0x42>
  return inb(COM1+0);
801070dc:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801070e3:	e8 09 fe ff ff       	call   80106ef1 <inb>
801070e8:	0f b6 c0             	movzbl %al,%eax
}
801070eb:	c9                   	leave  
801070ec:	c3                   	ret    

801070ed <uartintr>:

void
uartintr(void)
{
801070ed:	55                   	push   %ebp
801070ee:	89 e5                	mov    %esp,%ebp
801070f0:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801070f3:	c7 04 24 a9 70 10 80 	movl   $0x801070a9,(%esp)
801070fa:	e8 b7 96 ff ff       	call   801007b6 <consoleintr>
}
801070ff:	c9                   	leave  
80107100:	c3                   	ret    

80107101 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107101:	6a 00                	push   $0x0
  pushl $0
80107103:	6a 00                	push   $0x0
  jmp alltraps
80107105:	e9 68 f9 ff ff       	jmp    80106a72 <alltraps>

8010710a <vector1>:
.globl vector1
vector1:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $1
8010710c:	6a 01                	push   $0x1
  jmp alltraps
8010710e:	e9 5f f9 ff ff       	jmp    80106a72 <alltraps>

80107113 <vector2>:
.globl vector2
vector2:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $2
80107115:	6a 02                	push   $0x2
  jmp alltraps
80107117:	e9 56 f9 ff ff       	jmp    80106a72 <alltraps>

8010711c <vector3>:
.globl vector3
vector3:
  pushl $0
8010711c:	6a 00                	push   $0x0
  pushl $3
8010711e:	6a 03                	push   $0x3
  jmp alltraps
80107120:	e9 4d f9 ff ff       	jmp    80106a72 <alltraps>

80107125 <vector4>:
.globl vector4
vector4:
  pushl $0
80107125:	6a 00                	push   $0x0
  pushl $4
80107127:	6a 04                	push   $0x4
  jmp alltraps
80107129:	e9 44 f9 ff ff       	jmp    80106a72 <alltraps>

8010712e <vector5>:
.globl vector5
vector5:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $5
80107130:	6a 05                	push   $0x5
  jmp alltraps
80107132:	e9 3b f9 ff ff       	jmp    80106a72 <alltraps>

80107137 <vector6>:
.globl vector6
vector6:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $6
80107139:	6a 06                	push   $0x6
  jmp alltraps
8010713b:	e9 32 f9 ff ff       	jmp    80106a72 <alltraps>

80107140 <vector7>:
.globl vector7
vector7:
  pushl $0
80107140:	6a 00                	push   $0x0
  pushl $7
80107142:	6a 07                	push   $0x7
  jmp alltraps
80107144:	e9 29 f9 ff ff       	jmp    80106a72 <alltraps>

80107149 <vector8>:
.globl vector8
vector8:
  pushl $8
80107149:	6a 08                	push   $0x8
  jmp alltraps
8010714b:	e9 22 f9 ff ff       	jmp    80106a72 <alltraps>

80107150 <vector9>:
.globl vector9
vector9:
  pushl $0
80107150:	6a 00                	push   $0x0
  pushl $9
80107152:	6a 09                	push   $0x9
  jmp alltraps
80107154:	e9 19 f9 ff ff       	jmp    80106a72 <alltraps>

80107159 <vector10>:
.globl vector10
vector10:
  pushl $10
80107159:	6a 0a                	push   $0xa
  jmp alltraps
8010715b:	e9 12 f9 ff ff       	jmp    80106a72 <alltraps>

80107160 <vector11>:
.globl vector11
vector11:
  pushl $11
80107160:	6a 0b                	push   $0xb
  jmp alltraps
80107162:	e9 0b f9 ff ff       	jmp    80106a72 <alltraps>

80107167 <vector12>:
.globl vector12
vector12:
  pushl $12
80107167:	6a 0c                	push   $0xc
  jmp alltraps
80107169:	e9 04 f9 ff ff       	jmp    80106a72 <alltraps>

8010716e <vector13>:
.globl vector13
vector13:
  pushl $13
8010716e:	6a 0d                	push   $0xd
  jmp alltraps
80107170:	e9 fd f8 ff ff       	jmp    80106a72 <alltraps>

80107175 <vector14>:
.globl vector14
vector14:
  pushl $14
80107175:	6a 0e                	push   $0xe
  jmp alltraps
80107177:	e9 f6 f8 ff ff       	jmp    80106a72 <alltraps>

8010717c <vector15>:
.globl vector15
vector15:
  pushl $0
8010717c:	6a 00                	push   $0x0
  pushl $15
8010717e:	6a 0f                	push   $0xf
  jmp alltraps
80107180:	e9 ed f8 ff ff       	jmp    80106a72 <alltraps>

80107185 <vector16>:
.globl vector16
vector16:
  pushl $0
80107185:	6a 00                	push   $0x0
  pushl $16
80107187:	6a 10                	push   $0x10
  jmp alltraps
80107189:	e9 e4 f8 ff ff       	jmp    80106a72 <alltraps>

8010718e <vector17>:
.globl vector17
vector17:
  pushl $17
8010718e:	6a 11                	push   $0x11
  jmp alltraps
80107190:	e9 dd f8 ff ff       	jmp    80106a72 <alltraps>

80107195 <vector18>:
.globl vector18
vector18:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $18
80107197:	6a 12                	push   $0x12
  jmp alltraps
80107199:	e9 d4 f8 ff ff       	jmp    80106a72 <alltraps>

8010719e <vector19>:
.globl vector19
vector19:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $19
801071a0:	6a 13                	push   $0x13
  jmp alltraps
801071a2:	e9 cb f8 ff ff       	jmp    80106a72 <alltraps>

801071a7 <vector20>:
.globl vector20
vector20:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $20
801071a9:	6a 14                	push   $0x14
  jmp alltraps
801071ab:	e9 c2 f8 ff ff       	jmp    80106a72 <alltraps>

801071b0 <vector21>:
.globl vector21
vector21:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $21
801071b2:	6a 15                	push   $0x15
  jmp alltraps
801071b4:	e9 b9 f8 ff ff       	jmp    80106a72 <alltraps>

801071b9 <vector22>:
.globl vector22
vector22:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $22
801071bb:	6a 16                	push   $0x16
  jmp alltraps
801071bd:	e9 b0 f8 ff ff       	jmp    80106a72 <alltraps>

801071c2 <vector23>:
.globl vector23
vector23:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $23
801071c4:	6a 17                	push   $0x17
  jmp alltraps
801071c6:	e9 a7 f8 ff ff       	jmp    80106a72 <alltraps>

801071cb <vector24>:
.globl vector24
vector24:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $24
801071cd:	6a 18                	push   $0x18
  jmp alltraps
801071cf:	e9 9e f8 ff ff       	jmp    80106a72 <alltraps>

801071d4 <vector25>:
.globl vector25
vector25:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $25
801071d6:	6a 19                	push   $0x19
  jmp alltraps
801071d8:	e9 95 f8 ff ff       	jmp    80106a72 <alltraps>

801071dd <vector26>:
.globl vector26
vector26:
  pushl $0
801071dd:	6a 00                	push   $0x0
  pushl $26
801071df:	6a 1a                	push   $0x1a
  jmp alltraps
801071e1:	e9 8c f8 ff ff       	jmp    80106a72 <alltraps>

801071e6 <vector27>:
.globl vector27
vector27:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $27
801071e8:	6a 1b                	push   $0x1b
  jmp alltraps
801071ea:	e9 83 f8 ff ff       	jmp    80106a72 <alltraps>

801071ef <vector28>:
.globl vector28
vector28:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $28
801071f1:	6a 1c                	push   $0x1c
  jmp alltraps
801071f3:	e9 7a f8 ff ff       	jmp    80106a72 <alltraps>

801071f8 <vector29>:
.globl vector29
vector29:
  pushl $0
801071f8:	6a 00                	push   $0x0
  pushl $29
801071fa:	6a 1d                	push   $0x1d
  jmp alltraps
801071fc:	e9 71 f8 ff ff       	jmp    80106a72 <alltraps>

80107201 <vector30>:
.globl vector30
vector30:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $30
80107203:	6a 1e                	push   $0x1e
  jmp alltraps
80107205:	e9 68 f8 ff ff       	jmp    80106a72 <alltraps>

8010720a <vector31>:
.globl vector31
vector31:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $31
8010720c:	6a 1f                	push   $0x1f
  jmp alltraps
8010720e:	e9 5f f8 ff ff       	jmp    80106a72 <alltraps>

80107213 <vector32>:
.globl vector32
vector32:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $32
80107215:	6a 20                	push   $0x20
  jmp alltraps
80107217:	e9 56 f8 ff ff       	jmp    80106a72 <alltraps>

8010721c <vector33>:
.globl vector33
vector33:
  pushl $0
8010721c:	6a 00                	push   $0x0
  pushl $33
8010721e:	6a 21                	push   $0x21
  jmp alltraps
80107220:	e9 4d f8 ff ff       	jmp    80106a72 <alltraps>

80107225 <vector34>:
.globl vector34
vector34:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $34
80107227:	6a 22                	push   $0x22
  jmp alltraps
80107229:	e9 44 f8 ff ff       	jmp    80106a72 <alltraps>

8010722e <vector35>:
.globl vector35
vector35:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $35
80107230:	6a 23                	push   $0x23
  jmp alltraps
80107232:	e9 3b f8 ff ff       	jmp    80106a72 <alltraps>

80107237 <vector36>:
.globl vector36
vector36:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $36
80107239:	6a 24                	push   $0x24
  jmp alltraps
8010723b:	e9 32 f8 ff ff       	jmp    80106a72 <alltraps>

80107240 <vector37>:
.globl vector37
vector37:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $37
80107242:	6a 25                	push   $0x25
  jmp alltraps
80107244:	e9 29 f8 ff ff       	jmp    80106a72 <alltraps>

80107249 <vector38>:
.globl vector38
vector38:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $38
8010724b:	6a 26                	push   $0x26
  jmp alltraps
8010724d:	e9 20 f8 ff ff       	jmp    80106a72 <alltraps>

80107252 <vector39>:
.globl vector39
vector39:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $39
80107254:	6a 27                	push   $0x27
  jmp alltraps
80107256:	e9 17 f8 ff ff       	jmp    80106a72 <alltraps>

8010725b <vector40>:
.globl vector40
vector40:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $40
8010725d:	6a 28                	push   $0x28
  jmp alltraps
8010725f:	e9 0e f8 ff ff       	jmp    80106a72 <alltraps>

80107264 <vector41>:
.globl vector41
vector41:
  pushl $0
80107264:	6a 00                	push   $0x0
  pushl $41
80107266:	6a 29                	push   $0x29
  jmp alltraps
80107268:	e9 05 f8 ff ff       	jmp    80106a72 <alltraps>

8010726d <vector42>:
.globl vector42
vector42:
  pushl $0
8010726d:	6a 00                	push   $0x0
  pushl $42
8010726f:	6a 2a                	push   $0x2a
  jmp alltraps
80107271:	e9 fc f7 ff ff       	jmp    80106a72 <alltraps>

80107276 <vector43>:
.globl vector43
vector43:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $43
80107278:	6a 2b                	push   $0x2b
  jmp alltraps
8010727a:	e9 f3 f7 ff ff       	jmp    80106a72 <alltraps>

8010727f <vector44>:
.globl vector44
vector44:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $44
80107281:	6a 2c                	push   $0x2c
  jmp alltraps
80107283:	e9 ea f7 ff ff       	jmp    80106a72 <alltraps>

80107288 <vector45>:
.globl vector45
vector45:
  pushl $0
80107288:	6a 00                	push   $0x0
  pushl $45
8010728a:	6a 2d                	push   $0x2d
  jmp alltraps
8010728c:	e9 e1 f7 ff ff       	jmp    80106a72 <alltraps>

80107291 <vector46>:
.globl vector46
vector46:
  pushl $0
80107291:	6a 00                	push   $0x0
  pushl $46
80107293:	6a 2e                	push   $0x2e
  jmp alltraps
80107295:	e9 d8 f7 ff ff       	jmp    80106a72 <alltraps>

8010729a <vector47>:
.globl vector47
vector47:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $47
8010729c:	6a 2f                	push   $0x2f
  jmp alltraps
8010729e:	e9 cf f7 ff ff       	jmp    80106a72 <alltraps>

801072a3 <vector48>:
.globl vector48
vector48:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $48
801072a5:	6a 30                	push   $0x30
  jmp alltraps
801072a7:	e9 c6 f7 ff ff       	jmp    80106a72 <alltraps>

801072ac <vector49>:
.globl vector49
vector49:
  pushl $0
801072ac:	6a 00                	push   $0x0
  pushl $49
801072ae:	6a 31                	push   $0x31
  jmp alltraps
801072b0:	e9 bd f7 ff ff       	jmp    80106a72 <alltraps>

801072b5 <vector50>:
.globl vector50
vector50:
  pushl $0
801072b5:	6a 00                	push   $0x0
  pushl $50
801072b7:	6a 32                	push   $0x32
  jmp alltraps
801072b9:	e9 b4 f7 ff ff       	jmp    80106a72 <alltraps>

801072be <vector51>:
.globl vector51
vector51:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $51
801072c0:	6a 33                	push   $0x33
  jmp alltraps
801072c2:	e9 ab f7 ff ff       	jmp    80106a72 <alltraps>

801072c7 <vector52>:
.globl vector52
vector52:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $52
801072c9:	6a 34                	push   $0x34
  jmp alltraps
801072cb:	e9 a2 f7 ff ff       	jmp    80106a72 <alltraps>

801072d0 <vector53>:
.globl vector53
vector53:
  pushl $0
801072d0:	6a 00                	push   $0x0
  pushl $53
801072d2:	6a 35                	push   $0x35
  jmp alltraps
801072d4:	e9 99 f7 ff ff       	jmp    80106a72 <alltraps>

801072d9 <vector54>:
.globl vector54
vector54:
  pushl $0
801072d9:	6a 00                	push   $0x0
  pushl $54
801072db:	6a 36                	push   $0x36
  jmp alltraps
801072dd:	e9 90 f7 ff ff       	jmp    80106a72 <alltraps>

801072e2 <vector55>:
.globl vector55
vector55:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $55
801072e4:	6a 37                	push   $0x37
  jmp alltraps
801072e6:	e9 87 f7 ff ff       	jmp    80106a72 <alltraps>

801072eb <vector56>:
.globl vector56
vector56:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $56
801072ed:	6a 38                	push   $0x38
  jmp alltraps
801072ef:	e9 7e f7 ff ff       	jmp    80106a72 <alltraps>

801072f4 <vector57>:
.globl vector57
vector57:
  pushl $0
801072f4:	6a 00                	push   $0x0
  pushl $57
801072f6:	6a 39                	push   $0x39
  jmp alltraps
801072f8:	e9 75 f7 ff ff       	jmp    80106a72 <alltraps>

801072fd <vector58>:
.globl vector58
vector58:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $58
801072ff:	6a 3a                	push   $0x3a
  jmp alltraps
80107301:	e9 6c f7 ff ff       	jmp    80106a72 <alltraps>

80107306 <vector59>:
.globl vector59
vector59:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $59
80107308:	6a 3b                	push   $0x3b
  jmp alltraps
8010730a:	e9 63 f7 ff ff       	jmp    80106a72 <alltraps>

8010730f <vector60>:
.globl vector60
vector60:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $60
80107311:	6a 3c                	push   $0x3c
  jmp alltraps
80107313:	e9 5a f7 ff ff       	jmp    80106a72 <alltraps>

80107318 <vector61>:
.globl vector61
vector61:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $61
8010731a:	6a 3d                	push   $0x3d
  jmp alltraps
8010731c:	e9 51 f7 ff ff       	jmp    80106a72 <alltraps>

80107321 <vector62>:
.globl vector62
vector62:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $62
80107323:	6a 3e                	push   $0x3e
  jmp alltraps
80107325:	e9 48 f7 ff ff       	jmp    80106a72 <alltraps>

8010732a <vector63>:
.globl vector63
vector63:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $63
8010732c:	6a 3f                	push   $0x3f
  jmp alltraps
8010732e:	e9 3f f7 ff ff       	jmp    80106a72 <alltraps>

80107333 <vector64>:
.globl vector64
vector64:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $64
80107335:	6a 40                	push   $0x40
  jmp alltraps
80107337:	e9 36 f7 ff ff       	jmp    80106a72 <alltraps>

8010733c <vector65>:
.globl vector65
vector65:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $65
8010733e:	6a 41                	push   $0x41
  jmp alltraps
80107340:	e9 2d f7 ff ff       	jmp    80106a72 <alltraps>

80107345 <vector66>:
.globl vector66
vector66:
  pushl $0
80107345:	6a 00                	push   $0x0
  pushl $66
80107347:	6a 42                	push   $0x42
  jmp alltraps
80107349:	e9 24 f7 ff ff       	jmp    80106a72 <alltraps>

8010734e <vector67>:
.globl vector67
vector67:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $67
80107350:	6a 43                	push   $0x43
  jmp alltraps
80107352:	e9 1b f7 ff ff       	jmp    80106a72 <alltraps>

80107357 <vector68>:
.globl vector68
vector68:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $68
80107359:	6a 44                	push   $0x44
  jmp alltraps
8010735b:	e9 12 f7 ff ff       	jmp    80106a72 <alltraps>

80107360 <vector69>:
.globl vector69
vector69:
  pushl $0
80107360:	6a 00                	push   $0x0
  pushl $69
80107362:	6a 45                	push   $0x45
  jmp alltraps
80107364:	e9 09 f7 ff ff       	jmp    80106a72 <alltraps>

80107369 <vector70>:
.globl vector70
vector70:
  pushl $0
80107369:	6a 00                	push   $0x0
  pushl $70
8010736b:	6a 46                	push   $0x46
  jmp alltraps
8010736d:	e9 00 f7 ff ff       	jmp    80106a72 <alltraps>

80107372 <vector71>:
.globl vector71
vector71:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $71
80107374:	6a 47                	push   $0x47
  jmp alltraps
80107376:	e9 f7 f6 ff ff       	jmp    80106a72 <alltraps>

8010737b <vector72>:
.globl vector72
vector72:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $72
8010737d:	6a 48                	push   $0x48
  jmp alltraps
8010737f:	e9 ee f6 ff ff       	jmp    80106a72 <alltraps>

80107384 <vector73>:
.globl vector73
vector73:
  pushl $0
80107384:	6a 00                	push   $0x0
  pushl $73
80107386:	6a 49                	push   $0x49
  jmp alltraps
80107388:	e9 e5 f6 ff ff       	jmp    80106a72 <alltraps>

8010738d <vector74>:
.globl vector74
vector74:
  pushl $0
8010738d:	6a 00                	push   $0x0
  pushl $74
8010738f:	6a 4a                	push   $0x4a
  jmp alltraps
80107391:	e9 dc f6 ff ff       	jmp    80106a72 <alltraps>

80107396 <vector75>:
.globl vector75
vector75:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $75
80107398:	6a 4b                	push   $0x4b
  jmp alltraps
8010739a:	e9 d3 f6 ff ff       	jmp    80106a72 <alltraps>

8010739f <vector76>:
.globl vector76
vector76:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $76
801073a1:	6a 4c                	push   $0x4c
  jmp alltraps
801073a3:	e9 ca f6 ff ff       	jmp    80106a72 <alltraps>

801073a8 <vector77>:
.globl vector77
vector77:
  pushl $0
801073a8:	6a 00                	push   $0x0
  pushl $77
801073aa:	6a 4d                	push   $0x4d
  jmp alltraps
801073ac:	e9 c1 f6 ff ff       	jmp    80106a72 <alltraps>

801073b1 <vector78>:
.globl vector78
vector78:
  pushl $0
801073b1:	6a 00                	push   $0x0
  pushl $78
801073b3:	6a 4e                	push   $0x4e
  jmp alltraps
801073b5:	e9 b8 f6 ff ff       	jmp    80106a72 <alltraps>

801073ba <vector79>:
.globl vector79
vector79:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $79
801073bc:	6a 4f                	push   $0x4f
  jmp alltraps
801073be:	e9 af f6 ff ff       	jmp    80106a72 <alltraps>

801073c3 <vector80>:
.globl vector80
vector80:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $80
801073c5:	6a 50                	push   $0x50
  jmp alltraps
801073c7:	e9 a6 f6 ff ff       	jmp    80106a72 <alltraps>

801073cc <vector81>:
.globl vector81
vector81:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $81
801073ce:	6a 51                	push   $0x51
  jmp alltraps
801073d0:	e9 9d f6 ff ff       	jmp    80106a72 <alltraps>

801073d5 <vector82>:
.globl vector82
vector82:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $82
801073d7:	6a 52                	push   $0x52
  jmp alltraps
801073d9:	e9 94 f6 ff ff       	jmp    80106a72 <alltraps>

801073de <vector83>:
.globl vector83
vector83:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $83
801073e0:	6a 53                	push   $0x53
  jmp alltraps
801073e2:	e9 8b f6 ff ff       	jmp    80106a72 <alltraps>

801073e7 <vector84>:
.globl vector84
vector84:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $84
801073e9:	6a 54                	push   $0x54
  jmp alltraps
801073eb:	e9 82 f6 ff ff       	jmp    80106a72 <alltraps>

801073f0 <vector85>:
.globl vector85
vector85:
  pushl $0
801073f0:	6a 00                	push   $0x0
  pushl $85
801073f2:	6a 55                	push   $0x55
  jmp alltraps
801073f4:	e9 79 f6 ff ff       	jmp    80106a72 <alltraps>

801073f9 <vector86>:
.globl vector86
vector86:
  pushl $0
801073f9:	6a 00                	push   $0x0
  pushl $86
801073fb:	6a 56                	push   $0x56
  jmp alltraps
801073fd:	e9 70 f6 ff ff       	jmp    80106a72 <alltraps>

80107402 <vector87>:
.globl vector87
vector87:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $87
80107404:	6a 57                	push   $0x57
  jmp alltraps
80107406:	e9 67 f6 ff ff       	jmp    80106a72 <alltraps>

8010740b <vector88>:
.globl vector88
vector88:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $88
8010740d:	6a 58                	push   $0x58
  jmp alltraps
8010740f:	e9 5e f6 ff ff       	jmp    80106a72 <alltraps>

80107414 <vector89>:
.globl vector89
vector89:
  pushl $0
80107414:	6a 00                	push   $0x0
  pushl $89
80107416:	6a 59                	push   $0x59
  jmp alltraps
80107418:	e9 55 f6 ff ff       	jmp    80106a72 <alltraps>

8010741d <vector90>:
.globl vector90
vector90:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $90
8010741f:	6a 5a                	push   $0x5a
  jmp alltraps
80107421:	e9 4c f6 ff ff       	jmp    80106a72 <alltraps>

80107426 <vector91>:
.globl vector91
vector91:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $91
80107428:	6a 5b                	push   $0x5b
  jmp alltraps
8010742a:	e9 43 f6 ff ff       	jmp    80106a72 <alltraps>

8010742f <vector92>:
.globl vector92
vector92:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $92
80107431:	6a 5c                	push   $0x5c
  jmp alltraps
80107433:	e9 3a f6 ff ff       	jmp    80106a72 <alltraps>

80107438 <vector93>:
.globl vector93
vector93:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $93
8010743a:	6a 5d                	push   $0x5d
  jmp alltraps
8010743c:	e9 31 f6 ff ff       	jmp    80106a72 <alltraps>

80107441 <vector94>:
.globl vector94
vector94:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $94
80107443:	6a 5e                	push   $0x5e
  jmp alltraps
80107445:	e9 28 f6 ff ff       	jmp    80106a72 <alltraps>

8010744a <vector95>:
.globl vector95
vector95:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $95
8010744c:	6a 5f                	push   $0x5f
  jmp alltraps
8010744e:	e9 1f f6 ff ff       	jmp    80106a72 <alltraps>

80107453 <vector96>:
.globl vector96
vector96:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $96
80107455:	6a 60                	push   $0x60
  jmp alltraps
80107457:	e9 16 f6 ff ff       	jmp    80106a72 <alltraps>

8010745c <vector97>:
.globl vector97
vector97:
  pushl $0
8010745c:	6a 00                	push   $0x0
  pushl $97
8010745e:	6a 61                	push   $0x61
  jmp alltraps
80107460:	e9 0d f6 ff ff       	jmp    80106a72 <alltraps>

80107465 <vector98>:
.globl vector98
vector98:
  pushl $0
80107465:	6a 00                	push   $0x0
  pushl $98
80107467:	6a 62                	push   $0x62
  jmp alltraps
80107469:	e9 04 f6 ff ff       	jmp    80106a72 <alltraps>

8010746e <vector99>:
.globl vector99
vector99:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $99
80107470:	6a 63                	push   $0x63
  jmp alltraps
80107472:	e9 fb f5 ff ff       	jmp    80106a72 <alltraps>

80107477 <vector100>:
.globl vector100
vector100:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $100
80107479:	6a 64                	push   $0x64
  jmp alltraps
8010747b:	e9 f2 f5 ff ff       	jmp    80106a72 <alltraps>

80107480 <vector101>:
.globl vector101
vector101:
  pushl $0
80107480:	6a 00                	push   $0x0
  pushl $101
80107482:	6a 65                	push   $0x65
  jmp alltraps
80107484:	e9 e9 f5 ff ff       	jmp    80106a72 <alltraps>

80107489 <vector102>:
.globl vector102
vector102:
  pushl $0
80107489:	6a 00                	push   $0x0
  pushl $102
8010748b:	6a 66                	push   $0x66
  jmp alltraps
8010748d:	e9 e0 f5 ff ff       	jmp    80106a72 <alltraps>

80107492 <vector103>:
.globl vector103
vector103:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $103
80107494:	6a 67                	push   $0x67
  jmp alltraps
80107496:	e9 d7 f5 ff ff       	jmp    80106a72 <alltraps>

8010749b <vector104>:
.globl vector104
vector104:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $104
8010749d:	6a 68                	push   $0x68
  jmp alltraps
8010749f:	e9 ce f5 ff ff       	jmp    80106a72 <alltraps>

801074a4 <vector105>:
.globl vector105
vector105:
  pushl $0
801074a4:	6a 00                	push   $0x0
  pushl $105
801074a6:	6a 69                	push   $0x69
  jmp alltraps
801074a8:	e9 c5 f5 ff ff       	jmp    80106a72 <alltraps>

801074ad <vector106>:
.globl vector106
vector106:
  pushl $0
801074ad:	6a 00                	push   $0x0
  pushl $106
801074af:	6a 6a                	push   $0x6a
  jmp alltraps
801074b1:	e9 bc f5 ff ff       	jmp    80106a72 <alltraps>

801074b6 <vector107>:
.globl vector107
vector107:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $107
801074b8:	6a 6b                	push   $0x6b
  jmp alltraps
801074ba:	e9 b3 f5 ff ff       	jmp    80106a72 <alltraps>

801074bf <vector108>:
.globl vector108
vector108:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $108
801074c1:	6a 6c                	push   $0x6c
  jmp alltraps
801074c3:	e9 aa f5 ff ff       	jmp    80106a72 <alltraps>

801074c8 <vector109>:
.globl vector109
vector109:
  pushl $0
801074c8:	6a 00                	push   $0x0
  pushl $109
801074ca:	6a 6d                	push   $0x6d
  jmp alltraps
801074cc:	e9 a1 f5 ff ff       	jmp    80106a72 <alltraps>

801074d1 <vector110>:
.globl vector110
vector110:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $110
801074d3:	6a 6e                	push   $0x6e
  jmp alltraps
801074d5:	e9 98 f5 ff ff       	jmp    80106a72 <alltraps>

801074da <vector111>:
.globl vector111
vector111:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $111
801074dc:	6a 6f                	push   $0x6f
  jmp alltraps
801074de:	e9 8f f5 ff ff       	jmp    80106a72 <alltraps>

801074e3 <vector112>:
.globl vector112
vector112:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $112
801074e5:	6a 70                	push   $0x70
  jmp alltraps
801074e7:	e9 86 f5 ff ff       	jmp    80106a72 <alltraps>

801074ec <vector113>:
.globl vector113
vector113:
  pushl $0
801074ec:	6a 00                	push   $0x0
  pushl $113
801074ee:	6a 71                	push   $0x71
  jmp alltraps
801074f0:	e9 7d f5 ff ff       	jmp    80106a72 <alltraps>

801074f5 <vector114>:
.globl vector114
vector114:
  pushl $0
801074f5:	6a 00                	push   $0x0
  pushl $114
801074f7:	6a 72                	push   $0x72
  jmp alltraps
801074f9:	e9 74 f5 ff ff       	jmp    80106a72 <alltraps>

801074fe <vector115>:
.globl vector115
vector115:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $115
80107500:	6a 73                	push   $0x73
  jmp alltraps
80107502:	e9 6b f5 ff ff       	jmp    80106a72 <alltraps>

80107507 <vector116>:
.globl vector116
vector116:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $116
80107509:	6a 74                	push   $0x74
  jmp alltraps
8010750b:	e9 62 f5 ff ff       	jmp    80106a72 <alltraps>

80107510 <vector117>:
.globl vector117
vector117:
  pushl $0
80107510:	6a 00                	push   $0x0
  pushl $117
80107512:	6a 75                	push   $0x75
  jmp alltraps
80107514:	e9 59 f5 ff ff       	jmp    80106a72 <alltraps>

80107519 <vector118>:
.globl vector118
vector118:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $118
8010751b:	6a 76                	push   $0x76
  jmp alltraps
8010751d:	e9 50 f5 ff ff       	jmp    80106a72 <alltraps>

80107522 <vector119>:
.globl vector119
vector119:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $119
80107524:	6a 77                	push   $0x77
  jmp alltraps
80107526:	e9 47 f5 ff ff       	jmp    80106a72 <alltraps>

8010752b <vector120>:
.globl vector120
vector120:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $120
8010752d:	6a 78                	push   $0x78
  jmp alltraps
8010752f:	e9 3e f5 ff ff       	jmp    80106a72 <alltraps>

80107534 <vector121>:
.globl vector121
vector121:
  pushl $0
80107534:	6a 00                	push   $0x0
  pushl $121
80107536:	6a 79                	push   $0x79
  jmp alltraps
80107538:	e9 35 f5 ff ff       	jmp    80106a72 <alltraps>

8010753d <vector122>:
.globl vector122
vector122:
  pushl $0
8010753d:	6a 00                	push   $0x0
  pushl $122
8010753f:	6a 7a                	push   $0x7a
  jmp alltraps
80107541:	e9 2c f5 ff ff       	jmp    80106a72 <alltraps>

80107546 <vector123>:
.globl vector123
vector123:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $123
80107548:	6a 7b                	push   $0x7b
  jmp alltraps
8010754a:	e9 23 f5 ff ff       	jmp    80106a72 <alltraps>

8010754f <vector124>:
.globl vector124
vector124:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $124
80107551:	6a 7c                	push   $0x7c
  jmp alltraps
80107553:	e9 1a f5 ff ff       	jmp    80106a72 <alltraps>

80107558 <vector125>:
.globl vector125
vector125:
  pushl $0
80107558:	6a 00                	push   $0x0
  pushl $125
8010755a:	6a 7d                	push   $0x7d
  jmp alltraps
8010755c:	e9 11 f5 ff ff       	jmp    80106a72 <alltraps>

80107561 <vector126>:
.globl vector126
vector126:
  pushl $0
80107561:	6a 00                	push   $0x0
  pushl $126
80107563:	6a 7e                	push   $0x7e
  jmp alltraps
80107565:	e9 08 f5 ff ff       	jmp    80106a72 <alltraps>

8010756a <vector127>:
.globl vector127
vector127:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $127
8010756c:	6a 7f                	push   $0x7f
  jmp alltraps
8010756e:	e9 ff f4 ff ff       	jmp    80106a72 <alltraps>

80107573 <vector128>:
.globl vector128
vector128:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $128
80107575:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010757a:	e9 f3 f4 ff ff       	jmp    80106a72 <alltraps>

8010757f <vector129>:
.globl vector129
vector129:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $129
80107581:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107586:	e9 e7 f4 ff ff       	jmp    80106a72 <alltraps>

8010758b <vector130>:
.globl vector130
vector130:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $130
8010758d:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107592:	e9 db f4 ff ff       	jmp    80106a72 <alltraps>

80107597 <vector131>:
.globl vector131
vector131:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $131
80107599:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010759e:	e9 cf f4 ff ff       	jmp    80106a72 <alltraps>

801075a3 <vector132>:
.globl vector132
vector132:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $132
801075a5:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801075aa:	e9 c3 f4 ff ff       	jmp    80106a72 <alltraps>

801075af <vector133>:
.globl vector133
vector133:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $133
801075b1:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801075b6:	e9 b7 f4 ff ff       	jmp    80106a72 <alltraps>

801075bb <vector134>:
.globl vector134
vector134:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $134
801075bd:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801075c2:	e9 ab f4 ff ff       	jmp    80106a72 <alltraps>

801075c7 <vector135>:
.globl vector135
vector135:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $135
801075c9:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801075ce:	e9 9f f4 ff ff       	jmp    80106a72 <alltraps>

801075d3 <vector136>:
.globl vector136
vector136:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $136
801075d5:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801075da:	e9 93 f4 ff ff       	jmp    80106a72 <alltraps>

801075df <vector137>:
.globl vector137
vector137:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $137
801075e1:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801075e6:	e9 87 f4 ff ff       	jmp    80106a72 <alltraps>

801075eb <vector138>:
.globl vector138
vector138:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $138
801075ed:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801075f2:	e9 7b f4 ff ff       	jmp    80106a72 <alltraps>

801075f7 <vector139>:
.globl vector139
vector139:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $139
801075f9:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801075fe:	e9 6f f4 ff ff       	jmp    80106a72 <alltraps>

80107603 <vector140>:
.globl vector140
vector140:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $140
80107605:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010760a:	e9 63 f4 ff ff       	jmp    80106a72 <alltraps>

8010760f <vector141>:
.globl vector141
vector141:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $141
80107611:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107616:	e9 57 f4 ff ff       	jmp    80106a72 <alltraps>

8010761b <vector142>:
.globl vector142
vector142:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $142
8010761d:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107622:	e9 4b f4 ff ff       	jmp    80106a72 <alltraps>

80107627 <vector143>:
.globl vector143
vector143:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $143
80107629:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010762e:	e9 3f f4 ff ff       	jmp    80106a72 <alltraps>

80107633 <vector144>:
.globl vector144
vector144:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $144
80107635:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010763a:	e9 33 f4 ff ff       	jmp    80106a72 <alltraps>

8010763f <vector145>:
.globl vector145
vector145:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $145
80107641:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107646:	e9 27 f4 ff ff       	jmp    80106a72 <alltraps>

8010764b <vector146>:
.globl vector146
vector146:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $146
8010764d:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107652:	e9 1b f4 ff ff       	jmp    80106a72 <alltraps>

80107657 <vector147>:
.globl vector147
vector147:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $147
80107659:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010765e:	e9 0f f4 ff ff       	jmp    80106a72 <alltraps>

80107663 <vector148>:
.globl vector148
vector148:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $148
80107665:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010766a:	e9 03 f4 ff ff       	jmp    80106a72 <alltraps>

8010766f <vector149>:
.globl vector149
vector149:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $149
80107671:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107676:	e9 f7 f3 ff ff       	jmp    80106a72 <alltraps>

8010767b <vector150>:
.globl vector150
vector150:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $150
8010767d:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107682:	e9 eb f3 ff ff       	jmp    80106a72 <alltraps>

80107687 <vector151>:
.globl vector151
vector151:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $151
80107689:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010768e:	e9 df f3 ff ff       	jmp    80106a72 <alltraps>

80107693 <vector152>:
.globl vector152
vector152:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $152
80107695:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010769a:	e9 d3 f3 ff ff       	jmp    80106a72 <alltraps>

8010769f <vector153>:
.globl vector153
vector153:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $153
801076a1:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801076a6:	e9 c7 f3 ff ff       	jmp    80106a72 <alltraps>

801076ab <vector154>:
.globl vector154
vector154:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $154
801076ad:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801076b2:	e9 bb f3 ff ff       	jmp    80106a72 <alltraps>

801076b7 <vector155>:
.globl vector155
vector155:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $155
801076b9:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801076be:	e9 af f3 ff ff       	jmp    80106a72 <alltraps>

801076c3 <vector156>:
.globl vector156
vector156:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $156
801076c5:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801076ca:	e9 a3 f3 ff ff       	jmp    80106a72 <alltraps>

801076cf <vector157>:
.globl vector157
vector157:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $157
801076d1:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801076d6:	e9 97 f3 ff ff       	jmp    80106a72 <alltraps>

801076db <vector158>:
.globl vector158
vector158:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $158
801076dd:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801076e2:	e9 8b f3 ff ff       	jmp    80106a72 <alltraps>

801076e7 <vector159>:
.globl vector159
vector159:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $159
801076e9:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801076ee:	e9 7f f3 ff ff       	jmp    80106a72 <alltraps>

801076f3 <vector160>:
.globl vector160
vector160:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $160
801076f5:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801076fa:	e9 73 f3 ff ff       	jmp    80106a72 <alltraps>

801076ff <vector161>:
.globl vector161
vector161:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $161
80107701:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107706:	e9 67 f3 ff ff       	jmp    80106a72 <alltraps>

8010770b <vector162>:
.globl vector162
vector162:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $162
8010770d:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107712:	e9 5b f3 ff ff       	jmp    80106a72 <alltraps>

80107717 <vector163>:
.globl vector163
vector163:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $163
80107719:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010771e:	e9 4f f3 ff ff       	jmp    80106a72 <alltraps>

80107723 <vector164>:
.globl vector164
vector164:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $164
80107725:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010772a:	e9 43 f3 ff ff       	jmp    80106a72 <alltraps>

8010772f <vector165>:
.globl vector165
vector165:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $165
80107731:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107736:	e9 37 f3 ff ff       	jmp    80106a72 <alltraps>

8010773b <vector166>:
.globl vector166
vector166:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $166
8010773d:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107742:	e9 2b f3 ff ff       	jmp    80106a72 <alltraps>

80107747 <vector167>:
.globl vector167
vector167:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $167
80107749:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010774e:	e9 1f f3 ff ff       	jmp    80106a72 <alltraps>

80107753 <vector168>:
.globl vector168
vector168:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $168
80107755:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010775a:	e9 13 f3 ff ff       	jmp    80106a72 <alltraps>

8010775f <vector169>:
.globl vector169
vector169:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $169
80107761:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107766:	e9 07 f3 ff ff       	jmp    80106a72 <alltraps>

8010776b <vector170>:
.globl vector170
vector170:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $170
8010776d:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107772:	e9 fb f2 ff ff       	jmp    80106a72 <alltraps>

80107777 <vector171>:
.globl vector171
vector171:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $171
80107779:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010777e:	e9 ef f2 ff ff       	jmp    80106a72 <alltraps>

80107783 <vector172>:
.globl vector172
vector172:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $172
80107785:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010778a:	e9 e3 f2 ff ff       	jmp    80106a72 <alltraps>

8010778f <vector173>:
.globl vector173
vector173:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $173
80107791:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107796:	e9 d7 f2 ff ff       	jmp    80106a72 <alltraps>

8010779b <vector174>:
.globl vector174
vector174:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $174
8010779d:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801077a2:	e9 cb f2 ff ff       	jmp    80106a72 <alltraps>

801077a7 <vector175>:
.globl vector175
vector175:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $175
801077a9:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801077ae:	e9 bf f2 ff ff       	jmp    80106a72 <alltraps>

801077b3 <vector176>:
.globl vector176
vector176:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $176
801077b5:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801077ba:	e9 b3 f2 ff ff       	jmp    80106a72 <alltraps>

801077bf <vector177>:
.globl vector177
vector177:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $177
801077c1:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801077c6:	e9 a7 f2 ff ff       	jmp    80106a72 <alltraps>

801077cb <vector178>:
.globl vector178
vector178:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $178
801077cd:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801077d2:	e9 9b f2 ff ff       	jmp    80106a72 <alltraps>

801077d7 <vector179>:
.globl vector179
vector179:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $179
801077d9:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801077de:	e9 8f f2 ff ff       	jmp    80106a72 <alltraps>

801077e3 <vector180>:
.globl vector180
vector180:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $180
801077e5:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801077ea:	e9 83 f2 ff ff       	jmp    80106a72 <alltraps>

801077ef <vector181>:
.globl vector181
vector181:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $181
801077f1:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801077f6:	e9 77 f2 ff ff       	jmp    80106a72 <alltraps>

801077fb <vector182>:
.globl vector182
vector182:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $182
801077fd:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107802:	e9 6b f2 ff ff       	jmp    80106a72 <alltraps>

80107807 <vector183>:
.globl vector183
vector183:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $183
80107809:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010780e:	e9 5f f2 ff ff       	jmp    80106a72 <alltraps>

80107813 <vector184>:
.globl vector184
vector184:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $184
80107815:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010781a:	e9 53 f2 ff ff       	jmp    80106a72 <alltraps>

8010781f <vector185>:
.globl vector185
vector185:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $185
80107821:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107826:	e9 47 f2 ff ff       	jmp    80106a72 <alltraps>

8010782b <vector186>:
.globl vector186
vector186:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $186
8010782d:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107832:	e9 3b f2 ff ff       	jmp    80106a72 <alltraps>

80107837 <vector187>:
.globl vector187
vector187:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $187
80107839:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010783e:	e9 2f f2 ff ff       	jmp    80106a72 <alltraps>

80107843 <vector188>:
.globl vector188
vector188:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $188
80107845:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010784a:	e9 23 f2 ff ff       	jmp    80106a72 <alltraps>

8010784f <vector189>:
.globl vector189
vector189:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $189
80107851:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107856:	e9 17 f2 ff ff       	jmp    80106a72 <alltraps>

8010785b <vector190>:
.globl vector190
vector190:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $190
8010785d:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107862:	e9 0b f2 ff ff       	jmp    80106a72 <alltraps>

80107867 <vector191>:
.globl vector191
vector191:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $191
80107869:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010786e:	e9 ff f1 ff ff       	jmp    80106a72 <alltraps>

80107873 <vector192>:
.globl vector192
vector192:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $192
80107875:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010787a:	e9 f3 f1 ff ff       	jmp    80106a72 <alltraps>

8010787f <vector193>:
.globl vector193
vector193:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $193
80107881:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107886:	e9 e7 f1 ff ff       	jmp    80106a72 <alltraps>

8010788b <vector194>:
.globl vector194
vector194:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $194
8010788d:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107892:	e9 db f1 ff ff       	jmp    80106a72 <alltraps>

80107897 <vector195>:
.globl vector195
vector195:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $195
80107899:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010789e:	e9 cf f1 ff ff       	jmp    80106a72 <alltraps>

801078a3 <vector196>:
.globl vector196
vector196:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $196
801078a5:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801078aa:	e9 c3 f1 ff ff       	jmp    80106a72 <alltraps>

801078af <vector197>:
.globl vector197
vector197:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $197
801078b1:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801078b6:	e9 b7 f1 ff ff       	jmp    80106a72 <alltraps>

801078bb <vector198>:
.globl vector198
vector198:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $198
801078bd:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801078c2:	e9 ab f1 ff ff       	jmp    80106a72 <alltraps>

801078c7 <vector199>:
.globl vector199
vector199:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $199
801078c9:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801078ce:	e9 9f f1 ff ff       	jmp    80106a72 <alltraps>

801078d3 <vector200>:
.globl vector200
vector200:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $200
801078d5:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801078da:	e9 93 f1 ff ff       	jmp    80106a72 <alltraps>

801078df <vector201>:
.globl vector201
vector201:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $201
801078e1:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801078e6:	e9 87 f1 ff ff       	jmp    80106a72 <alltraps>

801078eb <vector202>:
.globl vector202
vector202:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $202
801078ed:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801078f2:	e9 7b f1 ff ff       	jmp    80106a72 <alltraps>

801078f7 <vector203>:
.globl vector203
vector203:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $203
801078f9:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801078fe:	e9 6f f1 ff ff       	jmp    80106a72 <alltraps>

80107903 <vector204>:
.globl vector204
vector204:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $204
80107905:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010790a:	e9 63 f1 ff ff       	jmp    80106a72 <alltraps>

8010790f <vector205>:
.globl vector205
vector205:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $205
80107911:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107916:	e9 57 f1 ff ff       	jmp    80106a72 <alltraps>

8010791b <vector206>:
.globl vector206
vector206:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $206
8010791d:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107922:	e9 4b f1 ff ff       	jmp    80106a72 <alltraps>

80107927 <vector207>:
.globl vector207
vector207:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $207
80107929:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010792e:	e9 3f f1 ff ff       	jmp    80106a72 <alltraps>

80107933 <vector208>:
.globl vector208
vector208:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $208
80107935:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010793a:	e9 33 f1 ff ff       	jmp    80106a72 <alltraps>

8010793f <vector209>:
.globl vector209
vector209:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $209
80107941:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107946:	e9 27 f1 ff ff       	jmp    80106a72 <alltraps>

8010794b <vector210>:
.globl vector210
vector210:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $210
8010794d:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107952:	e9 1b f1 ff ff       	jmp    80106a72 <alltraps>

80107957 <vector211>:
.globl vector211
vector211:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $211
80107959:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010795e:	e9 0f f1 ff ff       	jmp    80106a72 <alltraps>

80107963 <vector212>:
.globl vector212
vector212:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $212
80107965:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010796a:	e9 03 f1 ff ff       	jmp    80106a72 <alltraps>

8010796f <vector213>:
.globl vector213
vector213:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $213
80107971:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107976:	e9 f7 f0 ff ff       	jmp    80106a72 <alltraps>

8010797b <vector214>:
.globl vector214
vector214:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $214
8010797d:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107982:	e9 eb f0 ff ff       	jmp    80106a72 <alltraps>

80107987 <vector215>:
.globl vector215
vector215:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $215
80107989:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010798e:	e9 df f0 ff ff       	jmp    80106a72 <alltraps>

80107993 <vector216>:
.globl vector216
vector216:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $216
80107995:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010799a:	e9 d3 f0 ff ff       	jmp    80106a72 <alltraps>

8010799f <vector217>:
.globl vector217
vector217:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $217
801079a1:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801079a6:	e9 c7 f0 ff ff       	jmp    80106a72 <alltraps>

801079ab <vector218>:
.globl vector218
vector218:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $218
801079ad:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801079b2:	e9 bb f0 ff ff       	jmp    80106a72 <alltraps>

801079b7 <vector219>:
.globl vector219
vector219:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $219
801079b9:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801079be:	e9 af f0 ff ff       	jmp    80106a72 <alltraps>

801079c3 <vector220>:
.globl vector220
vector220:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $220
801079c5:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801079ca:	e9 a3 f0 ff ff       	jmp    80106a72 <alltraps>

801079cf <vector221>:
.globl vector221
vector221:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $221
801079d1:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801079d6:	e9 97 f0 ff ff       	jmp    80106a72 <alltraps>

801079db <vector222>:
.globl vector222
vector222:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $222
801079dd:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801079e2:	e9 8b f0 ff ff       	jmp    80106a72 <alltraps>

801079e7 <vector223>:
.globl vector223
vector223:
  pushl $0
801079e7:	6a 00                	push   $0x0
  pushl $223
801079e9:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801079ee:	e9 7f f0 ff ff       	jmp    80106a72 <alltraps>

801079f3 <vector224>:
.globl vector224
vector224:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $224
801079f5:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801079fa:	e9 73 f0 ff ff       	jmp    80106a72 <alltraps>

801079ff <vector225>:
.globl vector225
vector225:
  pushl $0
801079ff:	6a 00                	push   $0x0
  pushl $225
80107a01:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107a06:	e9 67 f0 ff ff       	jmp    80106a72 <alltraps>

80107a0b <vector226>:
.globl vector226
vector226:
  pushl $0
80107a0b:	6a 00                	push   $0x0
  pushl $226
80107a0d:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107a12:	e9 5b f0 ff ff       	jmp    80106a72 <alltraps>

80107a17 <vector227>:
.globl vector227
vector227:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $227
80107a19:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107a1e:	e9 4f f0 ff ff       	jmp    80106a72 <alltraps>

80107a23 <vector228>:
.globl vector228
vector228:
  pushl $0
80107a23:	6a 00                	push   $0x0
  pushl $228
80107a25:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107a2a:	e9 43 f0 ff ff       	jmp    80106a72 <alltraps>

80107a2f <vector229>:
.globl vector229
vector229:
  pushl $0
80107a2f:	6a 00                	push   $0x0
  pushl $229
80107a31:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107a36:	e9 37 f0 ff ff       	jmp    80106a72 <alltraps>

80107a3b <vector230>:
.globl vector230
vector230:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $230
80107a3d:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107a42:	e9 2b f0 ff ff       	jmp    80106a72 <alltraps>

80107a47 <vector231>:
.globl vector231
vector231:
  pushl $0
80107a47:	6a 00                	push   $0x0
  pushl $231
80107a49:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107a4e:	e9 1f f0 ff ff       	jmp    80106a72 <alltraps>

80107a53 <vector232>:
.globl vector232
vector232:
  pushl $0
80107a53:	6a 00                	push   $0x0
  pushl $232
80107a55:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107a5a:	e9 13 f0 ff ff       	jmp    80106a72 <alltraps>

80107a5f <vector233>:
.globl vector233
vector233:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $233
80107a61:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107a66:	e9 07 f0 ff ff       	jmp    80106a72 <alltraps>

80107a6b <vector234>:
.globl vector234
vector234:
  pushl $0
80107a6b:	6a 00                	push   $0x0
  pushl $234
80107a6d:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107a72:	e9 fb ef ff ff       	jmp    80106a72 <alltraps>

80107a77 <vector235>:
.globl vector235
vector235:
  pushl $0
80107a77:	6a 00                	push   $0x0
  pushl $235
80107a79:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107a7e:	e9 ef ef ff ff       	jmp    80106a72 <alltraps>

80107a83 <vector236>:
.globl vector236
vector236:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $236
80107a85:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107a8a:	e9 e3 ef ff ff       	jmp    80106a72 <alltraps>

80107a8f <vector237>:
.globl vector237
vector237:
  pushl $0
80107a8f:	6a 00                	push   $0x0
  pushl $237
80107a91:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107a96:	e9 d7 ef ff ff       	jmp    80106a72 <alltraps>

80107a9b <vector238>:
.globl vector238
vector238:
  pushl $0
80107a9b:	6a 00                	push   $0x0
  pushl $238
80107a9d:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107aa2:	e9 cb ef ff ff       	jmp    80106a72 <alltraps>

80107aa7 <vector239>:
.globl vector239
vector239:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $239
80107aa9:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107aae:	e9 bf ef ff ff       	jmp    80106a72 <alltraps>

80107ab3 <vector240>:
.globl vector240
vector240:
  pushl $0
80107ab3:	6a 00                	push   $0x0
  pushl $240
80107ab5:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107aba:	e9 b3 ef ff ff       	jmp    80106a72 <alltraps>

80107abf <vector241>:
.globl vector241
vector241:
  pushl $0
80107abf:	6a 00                	push   $0x0
  pushl $241
80107ac1:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107ac6:	e9 a7 ef ff ff       	jmp    80106a72 <alltraps>

80107acb <vector242>:
.globl vector242
vector242:
  pushl $0
80107acb:	6a 00                	push   $0x0
  pushl $242
80107acd:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107ad2:	e9 9b ef ff ff       	jmp    80106a72 <alltraps>

80107ad7 <vector243>:
.globl vector243
vector243:
  pushl $0
80107ad7:	6a 00                	push   $0x0
  pushl $243
80107ad9:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107ade:	e9 8f ef ff ff       	jmp    80106a72 <alltraps>

80107ae3 <vector244>:
.globl vector244
vector244:
  pushl $0
80107ae3:	6a 00                	push   $0x0
  pushl $244
80107ae5:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107aea:	e9 83 ef ff ff       	jmp    80106a72 <alltraps>

80107aef <vector245>:
.globl vector245
vector245:
  pushl $0
80107aef:	6a 00                	push   $0x0
  pushl $245
80107af1:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107af6:	e9 77 ef ff ff       	jmp    80106a72 <alltraps>

80107afb <vector246>:
.globl vector246
vector246:
  pushl $0
80107afb:	6a 00                	push   $0x0
  pushl $246
80107afd:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107b02:	e9 6b ef ff ff       	jmp    80106a72 <alltraps>

80107b07 <vector247>:
.globl vector247
vector247:
  pushl $0
80107b07:	6a 00                	push   $0x0
  pushl $247
80107b09:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107b0e:	e9 5f ef ff ff       	jmp    80106a72 <alltraps>

80107b13 <vector248>:
.globl vector248
vector248:
  pushl $0
80107b13:	6a 00                	push   $0x0
  pushl $248
80107b15:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107b1a:	e9 53 ef ff ff       	jmp    80106a72 <alltraps>

80107b1f <vector249>:
.globl vector249
vector249:
  pushl $0
80107b1f:	6a 00                	push   $0x0
  pushl $249
80107b21:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107b26:	e9 47 ef ff ff       	jmp    80106a72 <alltraps>

80107b2b <vector250>:
.globl vector250
vector250:
  pushl $0
80107b2b:	6a 00                	push   $0x0
  pushl $250
80107b2d:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107b32:	e9 3b ef ff ff       	jmp    80106a72 <alltraps>

80107b37 <vector251>:
.globl vector251
vector251:
  pushl $0
80107b37:	6a 00                	push   $0x0
  pushl $251
80107b39:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107b3e:	e9 2f ef ff ff       	jmp    80106a72 <alltraps>

80107b43 <vector252>:
.globl vector252
vector252:
  pushl $0
80107b43:	6a 00                	push   $0x0
  pushl $252
80107b45:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107b4a:	e9 23 ef ff ff       	jmp    80106a72 <alltraps>

80107b4f <vector253>:
.globl vector253
vector253:
  pushl $0
80107b4f:	6a 00                	push   $0x0
  pushl $253
80107b51:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107b56:	e9 17 ef ff ff       	jmp    80106a72 <alltraps>

80107b5b <vector254>:
.globl vector254
vector254:
  pushl $0
80107b5b:	6a 00                	push   $0x0
  pushl $254
80107b5d:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107b62:	e9 0b ef ff ff       	jmp    80106a72 <alltraps>

80107b67 <vector255>:
.globl vector255
vector255:
  pushl $0
80107b67:	6a 00                	push   $0x0
  pushl $255
80107b69:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107b6e:	e9 ff ee ff ff       	jmp    80106a72 <alltraps>

80107b73 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107b73:	55                   	push   %ebp
80107b74:	89 e5                	mov    %esp,%ebp
80107b76:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107b79:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b7c:	83 e8 01             	sub    $0x1,%eax
80107b7f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107b83:	8b 45 08             	mov    0x8(%ebp),%eax
80107b86:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107b8a:	8b 45 08             	mov    0x8(%ebp),%eax
80107b8d:	c1 e8 10             	shr    $0x10,%eax
80107b90:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107b94:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107b97:	0f 01 10             	lgdtl  (%eax)
}
80107b9a:	c9                   	leave  
80107b9b:	c3                   	ret    

80107b9c <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107b9c:	55                   	push   %ebp
80107b9d:	89 e5                	mov    %esp,%ebp
80107b9f:	83 ec 04             	sub    $0x4,%esp
80107ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107ba9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107bad:	0f 00 d8             	ltr    %ax
}
80107bb0:	c9                   	leave  
80107bb1:	c3                   	ret    

80107bb2 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107bb2:	55                   	push   %ebp
80107bb3:	89 e5                	mov    %esp,%ebp
80107bb5:	83 ec 04             	sub    $0x4,%esp
80107bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80107bbb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107bbf:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107bc3:	8e e8                	mov    %eax,%gs
}
80107bc5:	c9                   	leave  
80107bc6:	c3                   	ret    

80107bc7 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107bc7:	55                   	push   %ebp
80107bc8:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107bca:	8b 45 08             	mov    0x8(%ebp),%eax
80107bcd:	0f 22 d8             	mov    %eax,%cr3
}
80107bd0:	5d                   	pop    %ebp
80107bd1:	c3                   	ret    

80107bd2 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107bd2:	55                   	push   %ebp
80107bd3:	89 e5                	mov    %esp,%ebp
80107bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80107bd8:	05 00 00 00 80       	add    $0x80000000,%eax
80107bdd:	5d                   	pop    %ebp
80107bde:	c3                   	ret    

80107bdf <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107bdf:	55                   	push   %ebp
80107be0:	89 e5                	mov    %esp,%ebp
80107be2:	8b 45 08             	mov    0x8(%ebp),%eax
80107be5:	05 00 00 00 80       	add    $0x80000000,%eax
80107bea:	5d                   	pop    %ebp
80107beb:	c3                   	ret    

80107bec <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107bec:	55                   	push   %ebp
80107bed:	89 e5                	mov    %esp,%ebp
80107bef:	53                   	push   %ebx
80107bf0:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107bf3:	e8 0b b3 ff ff       	call   80102f03 <cpunum>
80107bf8:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107bfe:	05 60 33 11 80       	add    $0x80113360,%eax
80107c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c09:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c12:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1b:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c22:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c26:	83 e2 f0             	and    $0xfffffff0,%edx
80107c29:	83 ca 0a             	or     $0xa,%edx
80107c2c:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c32:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c36:	83 ca 10             	or     $0x10,%edx
80107c39:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c43:	83 e2 9f             	and    $0xffffff9f,%edx
80107c46:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c50:	83 ca 80             	or     $0xffffff80,%edx
80107c53:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c59:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c5d:	83 ca 0f             	or     $0xf,%edx
80107c60:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c66:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c6a:	83 e2 ef             	and    $0xffffffef,%edx
80107c6d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c73:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c77:	83 e2 df             	and    $0xffffffdf,%edx
80107c7a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c80:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c84:	83 ca 40             	or     $0x40,%edx
80107c87:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c91:	83 ca 80             	or     $0xffffff80,%edx
80107c94:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9a:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca1:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107ca8:	ff ff 
80107caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cad:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107cb4:	00 00 
80107cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb9:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cca:	83 e2 f0             	and    $0xfffffff0,%edx
80107ccd:	83 ca 02             	or     $0x2,%edx
80107cd0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107ce0:	83 ca 10             	or     $0x10,%edx
80107ce3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cec:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cf3:	83 e2 9f             	and    $0xffffff9f,%edx
80107cf6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cff:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d06:	83 ca 80             	or     $0xffffff80,%edx
80107d09:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d12:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d19:	83 ca 0f             	or     $0xf,%edx
80107d1c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d25:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d2c:	83 e2 ef             	and    $0xffffffef,%edx
80107d2f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d38:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d3f:	83 e2 df             	and    $0xffffffdf,%edx
80107d42:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d52:	83 ca 40             	or     $0x40,%edx
80107d55:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d65:	83 ca 80             	or     $0xffffff80,%edx
80107d68:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d71:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7b:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107d82:	ff ff 
80107d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d87:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107d8e:	00 00 
80107d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d93:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107da4:	83 e2 f0             	and    $0xfffffff0,%edx
80107da7:	83 ca 0a             	or     $0xa,%edx
80107daa:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107dba:	83 ca 10             	or     $0x10,%edx
80107dbd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc6:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107dcd:	83 ca 60             	or     $0x60,%edx
80107dd0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107de0:	83 ca 80             	or     $0xffffff80,%edx
80107de3:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dec:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107df3:	83 ca 0f             	or     $0xf,%edx
80107df6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dff:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e06:	83 e2 ef             	and    $0xffffffef,%edx
80107e09:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e12:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e19:	83 e2 df             	and    $0xffffffdf,%edx
80107e1c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e25:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e2c:	83 ca 40             	or     $0x40,%edx
80107e2f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e38:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e3f:	83 ca 80             	or     $0xffffff80,%edx
80107e42:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4b:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e55:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107e5c:	ff ff 
80107e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e61:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107e68:	00 00 
80107e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6d:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e77:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e7e:	83 e2 f0             	and    $0xfffffff0,%edx
80107e81:	83 ca 02             	or     $0x2,%edx
80107e84:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e94:	83 ca 10             	or     $0x10,%edx
80107e97:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ea7:	83 ca 60             	or     $0x60,%edx
80107eaa:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb3:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107eba:	83 ca 80             	or     $0xffffff80,%edx
80107ebd:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ecd:	83 ca 0f             	or     $0xf,%edx
80107ed0:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed9:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ee0:	83 e2 ef             	and    $0xffffffef,%edx
80107ee3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eec:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ef3:	83 e2 df             	and    $0xffffffdf,%edx
80107ef6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eff:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f06:	83 ca 40             	or     $0x40,%edx
80107f09:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f12:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f19:	83 ca 80             	or     $0xffffff80,%edx
80107f1c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f25:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2f:	05 b4 00 00 00       	add    $0xb4,%eax
80107f34:	89 c3                	mov    %eax,%ebx
80107f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f39:	05 b4 00 00 00       	add    $0xb4,%eax
80107f3e:	c1 e8 10             	shr    $0x10,%eax
80107f41:	89 c1                	mov    %eax,%ecx
80107f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f46:	05 b4 00 00 00       	add    $0xb4,%eax
80107f4b:	c1 e8 18             	shr    $0x18,%eax
80107f4e:	89 c2                	mov    %eax,%edx
80107f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f53:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107f5a:	00 00 
80107f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5f:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f69:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f72:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107f79:	83 e1 f0             	and    $0xfffffff0,%ecx
80107f7c:	83 c9 02             	or     $0x2,%ecx
80107f7f:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f88:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107f8f:	83 c9 10             	or     $0x10,%ecx
80107f92:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9b:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107fa2:	83 e1 9f             	and    $0xffffff9f,%ecx
80107fa5:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fae:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107fb5:	83 c9 80             	or     $0xffffff80,%ecx
80107fb8:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc1:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107fc8:	83 e1 f0             	and    $0xfffffff0,%ecx
80107fcb:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd4:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107fdb:	83 e1 ef             	and    $0xffffffef,%ecx
80107fde:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe7:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107fee:	83 e1 df             	and    $0xffffffdf,%ecx
80107ff1:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffa:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108001:	83 c9 40             	or     $0x40,%ecx
80108004:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010800a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800d:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108014:	83 c9 80             	or     $0xffffff80,%ecx
80108017:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010801d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108020:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108029:	83 c0 70             	add    $0x70,%eax
8010802c:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80108033:	00 
80108034:	89 04 24             	mov    %eax,(%esp)
80108037:	e8 37 fb ff ff       	call   80107b73 <lgdt>
  loadgs(SEG_KCPU << 3);
8010803c:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80108043:	e8 6a fb ff ff       	call   80107bb2 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804b:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108051:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108058:	00 00 00 00 
}
8010805c:	83 c4 24             	add    $0x24,%esp
8010805f:	5b                   	pop    %ebx
80108060:	5d                   	pop    %ebp
80108061:	c3                   	ret    

80108062 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108062:	55                   	push   %ebp
80108063:	89 e5                	mov    %esp,%ebp
80108065:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108068:	8b 45 0c             	mov    0xc(%ebp),%eax
8010806b:	c1 e8 16             	shr    $0x16,%eax
8010806e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108075:	8b 45 08             	mov    0x8(%ebp),%eax
80108078:	01 d0                	add    %edx,%eax
8010807a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010807d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108080:	8b 00                	mov    (%eax),%eax
80108082:	83 e0 01             	and    $0x1,%eax
80108085:	85 c0                	test   %eax,%eax
80108087:	74 17                	je     801080a0 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108089:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010808c:	8b 00                	mov    (%eax),%eax
8010808e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108093:	89 04 24             	mov    %eax,(%esp)
80108096:	e8 44 fb ff ff       	call   80107bdf <p2v>
8010809b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010809e:	eb 4b                	jmp    801080eb <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801080a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801080a4:	74 0e                	je     801080b4 <walkpgdir+0x52>
801080a6:	e8 9f aa ff ff       	call   80102b4a <kalloc>
801080ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801080b2:	75 07                	jne    801080bb <walkpgdir+0x59>
      return 0;
801080b4:	b8 00 00 00 00       	mov    $0x0,%eax
801080b9:	eb 47                	jmp    80108102 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801080bb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080c2:	00 
801080c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801080ca:	00 
801080cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ce:	89 04 24             	mov    %eax,(%esp)
801080d1:	e8 71 d4 ff ff       	call   80105547 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801080d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d9:	89 04 24             	mov    %eax,(%esp)
801080dc:	e8 f1 fa ff ff       	call   80107bd2 <v2p>
801080e1:	89 c2                	mov    %eax,%edx
801080e3:	83 ca 07             	or     $0x7,%edx
801080e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080e9:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801080eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801080ee:	c1 e8 0c             	shr    $0xc,%eax
801080f1:	25 ff 03 00 00       	and    $0x3ff,%eax
801080f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108100:	01 d0                	add    %edx,%eax
}
80108102:	c9                   	leave  
80108103:	c3                   	ret    

80108104 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108104:	55                   	push   %ebp
80108105:	89 e5                	mov    %esp,%ebp
80108107:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010810a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010810d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108115:	8b 55 0c             	mov    0xc(%ebp),%edx
80108118:	8b 45 10             	mov    0x10(%ebp),%eax
8010811b:	01 d0                	add    %edx,%eax
8010811d:	83 e8 01             	sub    $0x1,%eax
80108120:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108125:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108128:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010812f:	00 
80108130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108133:	89 44 24 04          	mov    %eax,0x4(%esp)
80108137:	8b 45 08             	mov    0x8(%ebp),%eax
8010813a:	89 04 24             	mov    %eax,(%esp)
8010813d:	e8 20 ff ff ff       	call   80108062 <walkpgdir>
80108142:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108145:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108149:	75 07                	jne    80108152 <mappages+0x4e>
      return -1;
8010814b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108150:	eb 46                	jmp    80108198 <mappages+0x94>
    if(*pte & PTE_P)
80108152:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108155:	8b 00                	mov    (%eax),%eax
80108157:	83 e0 01             	and    $0x1,%eax
8010815a:	85 c0                	test   %eax,%eax
8010815c:	74 0c                	je     8010816a <mappages+0x66>
      panic("remap");
8010815e:	c7 04 24 c4 8f 10 80 	movl   $0x80108fc4,(%esp)
80108165:	e8 dc 83 ff ff       	call   80100546 <panic>
    *pte = pa | perm | PTE_P;
8010816a:	8b 45 18             	mov    0x18(%ebp),%eax
8010816d:	0b 45 14             	or     0x14(%ebp),%eax
80108170:	89 c2                	mov    %eax,%edx
80108172:	83 ca 01             	or     $0x1,%edx
80108175:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108178:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010817a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108180:	74 10                	je     80108192 <mappages+0x8e>
      break;
    a += PGSIZE;
80108182:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108189:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108190:	eb 96                	jmp    80108128 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108192:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108193:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108198:	c9                   	leave  
80108199:	c3                   	ret    

8010819a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010819a:	55                   	push   %ebp
8010819b:	89 e5                	mov    %esp,%ebp
8010819d:	53                   	push   %ebx
8010819e:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801081a1:	e8 a4 a9 ff ff       	call   80102b4a <kalloc>
801081a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801081a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081ad:	75 0a                	jne    801081b9 <setupkvm+0x1f>
    return 0;
801081af:	b8 00 00 00 00       	mov    $0x0,%eax
801081b4:	e9 98 00 00 00       	jmp    80108251 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801081b9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081c0:	00 
801081c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801081c8:	00 
801081c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081cc:	89 04 24             	mov    %eax,(%esp)
801081cf:	e8 73 d3 ff ff       	call   80105547 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801081d4:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801081db:	e8 ff f9 ff ff       	call   80107bdf <p2v>
801081e0:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801081e5:	76 0c                	jbe    801081f3 <setupkvm+0x59>
    panic("PHYSTOP too high");
801081e7:	c7 04 24 ca 8f 10 80 	movl   $0x80108fca,(%esp)
801081ee:	e8 53 83 ff ff       	call   80100546 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081f3:	c7 45 f4 a0 c4 10 80 	movl   $0x8010c4a0,-0xc(%ebp)
801081fa:	eb 49                	jmp    80108245 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
801081fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801081ff:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108202:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108205:	8b 50 04             	mov    0x4(%eax),%edx
80108208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820b:	8b 58 08             	mov    0x8(%eax),%ebx
8010820e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108211:	8b 40 04             	mov    0x4(%eax),%eax
80108214:	29 c3                	sub    %eax,%ebx
80108216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108219:	8b 00                	mov    (%eax),%eax
8010821b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010821f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108223:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108227:	89 44 24 04          	mov    %eax,0x4(%esp)
8010822b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010822e:	89 04 24             	mov    %eax,(%esp)
80108231:	e8 ce fe ff ff       	call   80108104 <mappages>
80108236:	85 c0                	test   %eax,%eax
80108238:	79 07                	jns    80108241 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010823a:	b8 00 00 00 00       	mov    $0x0,%eax
8010823f:	eb 10                	jmp    80108251 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108241:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108245:	81 7d f4 e0 c4 10 80 	cmpl   $0x8010c4e0,-0xc(%ebp)
8010824c:	72 ae                	jb     801081fc <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010824e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108251:	83 c4 34             	add    $0x34,%esp
80108254:	5b                   	pop    %ebx
80108255:	5d                   	pop    %ebp
80108256:	c3                   	ret    

80108257 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108257:	55                   	push   %ebp
80108258:	89 e5                	mov    %esp,%ebp
8010825a:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010825d:	e8 38 ff ff ff       	call   8010819a <setupkvm>
80108262:	a3 38 61 11 80       	mov    %eax,0x80116138
  switchkvm();
80108267:	e8 02 00 00 00       	call   8010826e <switchkvm>
}
8010826c:	c9                   	leave  
8010826d:	c3                   	ret    

8010826e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010826e:	55                   	push   %ebp
8010826f:	89 e5                	mov    %esp,%ebp
80108271:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108274:	a1 38 61 11 80       	mov    0x80116138,%eax
80108279:	89 04 24             	mov    %eax,(%esp)
8010827c:	e8 51 f9 ff ff       	call   80107bd2 <v2p>
80108281:	89 04 24             	mov    %eax,(%esp)
80108284:	e8 3e f9 ff ff       	call   80107bc7 <lcr3>
}
80108289:	c9                   	leave  
8010828a:	c3                   	ret    

8010828b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010828b:	55                   	push   %ebp
8010828c:	89 e5                	mov    %esp,%ebp
8010828e:	53                   	push   %ebx
8010828f:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108292:	e8 ac d1 ff ff       	call   80105443 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108297:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010829d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082a4:	83 c2 08             	add    $0x8,%edx
801082a7:	89 d3                	mov    %edx,%ebx
801082a9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082b0:	83 c2 08             	add    $0x8,%edx
801082b3:	c1 ea 10             	shr    $0x10,%edx
801082b6:	89 d1                	mov    %edx,%ecx
801082b8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801082bf:	83 c2 08             	add    $0x8,%edx
801082c2:	c1 ea 18             	shr    $0x18,%edx
801082c5:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801082cc:	67 00 
801082ce:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801082d5:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801082db:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801082e2:	83 e1 f0             	and    $0xfffffff0,%ecx
801082e5:	83 c9 09             	or     $0x9,%ecx
801082e8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801082ee:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801082f5:	83 c9 10             	or     $0x10,%ecx
801082f8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801082fe:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108305:	83 e1 9f             	and    $0xffffff9f,%ecx
80108308:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010830e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108315:	83 c9 80             	or     $0xffffff80,%ecx
80108318:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010831e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108325:	83 e1 f0             	and    $0xfffffff0,%ecx
80108328:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010832e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108335:	83 e1 ef             	and    $0xffffffef,%ecx
80108338:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010833e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108345:	83 e1 df             	and    $0xffffffdf,%ecx
80108348:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010834e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108355:	83 c9 40             	or     $0x40,%ecx
80108358:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010835e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80108365:	83 e1 7f             	and    $0x7f,%ecx
80108368:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010836e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108374:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010837a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108381:	83 e2 ef             	and    $0xffffffef,%edx
80108384:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010838a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108390:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108396:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010839c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801083a3:	8b 52 08             	mov    0x8(%edx),%edx
801083a6:	81 c2 00 10 00 00    	add    $0x1000,%edx
801083ac:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801083af:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801083b6:	e8 e1 f7 ff ff       	call   80107b9c <ltr>
  if(p->pgdir == 0)
801083bb:	8b 45 08             	mov    0x8(%ebp),%eax
801083be:	8b 40 04             	mov    0x4(%eax),%eax
801083c1:	85 c0                	test   %eax,%eax
801083c3:	75 0c                	jne    801083d1 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
801083c5:	c7 04 24 db 8f 10 80 	movl   $0x80108fdb,(%esp)
801083cc:	e8 75 81 ff ff       	call   80100546 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801083d1:	8b 45 08             	mov    0x8(%ebp),%eax
801083d4:	8b 40 04             	mov    0x4(%eax),%eax
801083d7:	89 04 24             	mov    %eax,(%esp)
801083da:	e8 f3 f7 ff ff       	call   80107bd2 <v2p>
801083df:	89 04 24             	mov    %eax,(%esp)
801083e2:	e8 e0 f7 ff ff       	call   80107bc7 <lcr3>
  popcli();
801083e7:	e8 9f d0 ff ff       	call   8010548b <popcli>
}
801083ec:	83 c4 14             	add    $0x14,%esp
801083ef:	5b                   	pop    %ebx
801083f0:	5d                   	pop    %ebp
801083f1:	c3                   	ret    

801083f2 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801083f2:	55                   	push   %ebp
801083f3:	89 e5                	mov    %esp,%ebp
801083f5:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801083f8:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801083ff:	76 0c                	jbe    8010840d <inituvm+0x1b>
    panic("inituvm: more than a page");
80108401:	c7 04 24 ef 8f 10 80 	movl   $0x80108fef,(%esp)
80108408:	e8 39 81 ff ff       	call   80100546 <panic>
  mem = kalloc();
8010840d:	e8 38 a7 ff ff       	call   80102b4a <kalloc>
80108412:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108415:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010841c:	00 
8010841d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108424:	00 
80108425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108428:	89 04 24             	mov    %eax,(%esp)
8010842b:	e8 17 d1 ff ff       	call   80105547 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108433:	89 04 24             	mov    %eax,(%esp)
80108436:	e8 97 f7 ff ff       	call   80107bd2 <v2p>
8010843b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108442:	00 
80108443:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108447:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010844e:	00 
8010844f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108456:	00 
80108457:	8b 45 08             	mov    0x8(%ebp),%eax
8010845a:	89 04 24             	mov    %eax,(%esp)
8010845d:	e8 a2 fc ff ff       	call   80108104 <mappages>
  memmove(mem, init, sz);
80108462:	8b 45 10             	mov    0x10(%ebp),%eax
80108465:	89 44 24 08          	mov    %eax,0x8(%esp)
80108469:	8b 45 0c             	mov    0xc(%ebp),%eax
8010846c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108470:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108473:	89 04 24             	mov    %eax,(%esp)
80108476:	e8 9f d1 ff ff       	call   8010561a <memmove>
}
8010847b:	c9                   	leave  
8010847c:	c3                   	ret    

8010847d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010847d:	55                   	push   %ebp
8010847e:	89 e5                	mov    %esp,%ebp
80108480:	53                   	push   %ebx
80108481:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108484:	8b 45 0c             	mov    0xc(%ebp),%eax
80108487:	25 ff 0f 00 00       	and    $0xfff,%eax
8010848c:	85 c0                	test   %eax,%eax
8010848e:	74 0c                	je     8010849c <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108490:	c7 04 24 0c 90 10 80 	movl   $0x8010900c,(%esp)
80108497:	e8 aa 80 ff ff       	call   80100546 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010849c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084a3:	e9 ad 00 00 00       	jmp    80108555 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801084a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801084ae:	01 d0                	add    %edx,%eax
801084b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084b7:	00 
801084b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801084bc:	8b 45 08             	mov    0x8(%ebp),%eax
801084bf:	89 04 24             	mov    %eax,(%esp)
801084c2:	e8 9b fb ff ff       	call   80108062 <walkpgdir>
801084c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084ce:	75 0c                	jne    801084dc <loaduvm+0x5f>
      panic("loaduvm: address should exist");
801084d0:	c7 04 24 2f 90 10 80 	movl   $0x8010902f,(%esp)
801084d7:	e8 6a 80 ff ff       	call   80100546 <panic>
    pa = PTE_ADDR(*pte);
801084dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084df:	8b 00                	mov    (%eax),%eax
801084e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801084e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ec:	8b 55 18             	mov    0x18(%ebp),%edx
801084ef:	89 d1                	mov    %edx,%ecx
801084f1:	29 c1                	sub    %eax,%ecx
801084f3:	89 c8                	mov    %ecx,%eax
801084f5:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801084fa:	77 11                	ja     8010850d <loaduvm+0x90>
      n = sz - i;
801084fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ff:	8b 55 18             	mov    0x18(%ebp),%edx
80108502:	89 d1                	mov    %edx,%ecx
80108504:	29 c1                	sub    %eax,%ecx
80108506:	89 c8                	mov    %ecx,%eax
80108508:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010850b:	eb 07                	jmp    80108514 <loaduvm+0x97>
    else
      n = PGSIZE;
8010850d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108514:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108517:	8b 55 14             	mov    0x14(%ebp),%edx
8010851a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010851d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108520:	89 04 24             	mov    %eax,(%esp)
80108523:	e8 b7 f6 ff ff       	call   80107bdf <p2v>
80108528:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010852b:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010852f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108533:	89 44 24 04          	mov    %eax,0x4(%esp)
80108537:	8b 45 10             	mov    0x10(%ebp),%eax
8010853a:	89 04 24             	mov    %eax,(%esp)
8010853d:	e8 67 98 ff ff       	call   80101da9 <readi>
80108542:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108545:	74 07                	je     8010854e <loaduvm+0xd1>
      return -1;
80108547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010854c:	eb 18                	jmp    80108566 <loaduvm+0xe9>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010854e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108555:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108558:	3b 45 18             	cmp    0x18(%ebp),%eax
8010855b:	0f 82 47 ff ff ff    	jb     801084a8 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108561:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108566:	83 c4 24             	add    $0x24,%esp
80108569:	5b                   	pop    %ebx
8010856a:	5d                   	pop    %ebp
8010856b:	c3                   	ret    

8010856c <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010856c:	55                   	push   %ebp
8010856d:	89 e5                	mov    %esp,%ebp
8010856f:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108572:	8b 45 10             	mov    0x10(%ebp),%eax
80108575:	85 c0                	test   %eax,%eax
80108577:	79 0a                	jns    80108583 <allocuvm+0x17>
    return 0;
80108579:	b8 00 00 00 00       	mov    $0x0,%eax
8010857e:	e9 c1 00 00 00       	jmp    80108644 <allocuvm+0xd8>
  if(newsz < oldsz)
80108583:	8b 45 10             	mov    0x10(%ebp),%eax
80108586:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108589:	73 08                	jae    80108593 <allocuvm+0x27>
    return oldsz;
8010858b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010858e:	e9 b1 00 00 00       	jmp    80108644 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108593:	8b 45 0c             	mov    0xc(%ebp),%eax
80108596:	05 ff 0f 00 00       	add    $0xfff,%eax
8010859b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801085a3:	e9 8d 00 00 00       	jmp    80108635 <allocuvm+0xc9>
    mem = kalloc();
801085a8:	e8 9d a5 ff ff       	call   80102b4a <kalloc>
801085ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801085b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085b4:	75 2c                	jne    801085e2 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801085b6:	c7 04 24 4d 90 10 80 	movl   $0x8010904d,(%esp)
801085bd:	e8 e8 7d ff ff       	call   801003aa <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801085c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801085c5:	89 44 24 08          	mov    %eax,0x8(%esp)
801085c9:	8b 45 10             	mov    0x10(%ebp),%eax
801085cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801085d0:	8b 45 08             	mov    0x8(%ebp),%eax
801085d3:	89 04 24             	mov    %eax,(%esp)
801085d6:	e8 6b 00 00 00       	call   80108646 <deallocuvm>
      return 0;
801085db:	b8 00 00 00 00       	mov    $0x0,%eax
801085e0:	eb 62                	jmp    80108644 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801085e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801085e9:	00 
801085ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801085f1:	00 
801085f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085f5:	89 04 24             	mov    %eax,(%esp)
801085f8:	e8 4a cf ff ff       	call   80105547 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801085fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108600:	89 04 24             	mov    %eax,(%esp)
80108603:	e8 ca f5 ff ff       	call   80107bd2 <v2p>
80108608:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010860b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108612:	00 
80108613:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108617:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010861e:	00 
8010861f:	89 54 24 04          	mov    %edx,0x4(%esp)
80108623:	8b 45 08             	mov    0x8(%ebp),%eax
80108626:	89 04 24             	mov    %eax,(%esp)
80108629:	e8 d6 fa ff ff       	call   80108104 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010862e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108635:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108638:	3b 45 10             	cmp    0x10(%ebp),%eax
8010863b:	0f 82 67 ff ff ff    	jb     801085a8 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108641:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108644:	c9                   	leave  
80108645:	c3                   	ret    

80108646 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108646:	55                   	push   %ebp
80108647:	89 e5                	mov    %esp,%ebp
80108649:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010864c:	8b 45 10             	mov    0x10(%ebp),%eax
8010864f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108652:	72 08                	jb     8010865c <deallocuvm+0x16>
    return oldsz;
80108654:	8b 45 0c             	mov    0xc(%ebp),%eax
80108657:	e9 a4 00 00 00       	jmp    80108700 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
8010865c:	8b 45 10             	mov    0x10(%ebp),%eax
8010865f:	05 ff 0f 00 00       	add    $0xfff,%eax
80108664:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010866c:	e9 80 00 00 00       	jmp    801086f1 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108674:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010867b:	00 
8010867c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108680:	8b 45 08             	mov    0x8(%ebp),%eax
80108683:	89 04 24             	mov    %eax,(%esp)
80108686:	e8 d7 f9 ff ff       	call   80108062 <walkpgdir>
8010868b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010868e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108692:	75 09                	jne    8010869d <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108694:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010869b:	eb 4d                	jmp    801086ea <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
8010869d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086a0:	8b 00                	mov    (%eax),%eax
801086a2:	83 e0 01             	and    $0x1,%eax
801086a5:	85 c0                	test   %eax,%eax
801086a7:	74 41                	je     801086ea <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801086a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086ac:	8b 00                	mov    (%eax),%eax
801086ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801086b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801086ba:	75 0c                	jne    801086c8 <deallocuvm+0x82>
        panic("kfree");
801086bc:	c7 04 24 65 90 10 80 	movl   $0x80109065,(%esp)
801086c3:	e8 7e 7e ff ff       	call   80100546 <panic>
      char *v = p2v(pa);
801086c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086cb:	89 04 24             	mov    %eax,(%esp)
801086ce:	e8 0c f5 ff ff       	call   80107bdf <p2v>
801086d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801086d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801086d9:	89 04 24             	mov    %eax,(%esp)
801086dc:	e8 d0 a3 ff ff       	call   80102ab1 <kfree>
      *pte = 0;
801086e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801086ea:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086f7:	0f 82 74 ff ff ff    	jb     80108671 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801086fd:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108700:	c9                   	leave  
80108701:	c3                   	ret    

80108702 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108702:	55                   	push   %ebp
80108703:	89 e5                	mov    %esp,%ebp
80108705:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108708:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010870c:	75 0c                	jne    8010871a <freevm+0x18>
    panic("freevm: no pgdir");
8010870e:	c7 04 24 6b 90 10 80 	movl   $0x8010906b,(%esp)
80108715:	e8 2c 7e ff ff       	call   80100546 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010871a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108721:	00 
80108722:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108729:	80 
8010872a:	8b 45 08             	mov    0x8(%ebp),%eax
8010872d:	89 04 24             	mov    %eax,(%esp)
80108730:	e8 11 ff ff ff       	call   80108646 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108735:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010873c:	eb 48                	jmp    80108786 <freevm+0x84>
    if(pgdir[i] & PTE_P){
8010873e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108741:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108748:	8b 45 08             	mov    0x8(%ebp),%eax
8010874b:	01 d0                	add    %edx,%eax
8010874d:	8b 00                	mov    (%eax),%eax
8010874f:	83 e0 01             	and    $0x1,%eax
80108752:	85 c0                	test   %eax,%eax
80108754:	74 2c                	je     80108782 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108759:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108760:	8b 45 08             	mov    0x8(%ebp),%eax
80108763:	01 d0                	add    %edx,%eax
80108765:	8b 00                	mov    (%eax),%eax
80108767:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010876c:	89 04 24             	mov    %eax,(%esp)
8010876f:	e8 6b f4 ff ff       	call   80107bdf <p2v>
80108774:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108777:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010877a:	89 04 24             	mov    %eax,(%esp)
8010877d:	e8 2f a3 ff ff       	call   80102ab1 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108782:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108786:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010878d:	76 af                	jbe    8010873e <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010878f:	8b 45 08             	mov    0x8(%ebp),%eax
80108792:	89 04 24             	mov    %eax,(%esp)
80108795:	e8 17 a3 ff ff       	call   80102ab1 <kfree>
}
8010879a:	c9                   	leave  
8010879b:	c3                   	ret    

8010879c <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010879c:	55                   	push   %ebp
8010879d:	89 e5                	mov    %esp,%ebp
8010879f:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801087a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087a9:	00 
801087aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801087ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801087b1:	8b 45 08             	mov    0x8(%ebp),%eax
801087b4:	89 04 24             	mov    %eax,(%esp)
801087b7:	e8 a6 f8 ff ff       	call   80108062 <walkpgdir>
801087bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801087bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801087c3:	75 0c                	jne    801087d1 <clearpteu+0x35>
    panic("clearpteu");
801087c5:	c7 04 24 7c 90 10 80 	movl   $0x8010907c,(%esp)
801087cc:	e8 75 7d ff ff       	call   80100546 <panic>
  *pte &= ~PTE_U;
801087d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d4:	8b 00                	mov    (%eax),%eax
801087d6:	89 c2                	mov    %eax,%edx
801087d8:	83 e2 fb             	and    $0xfffffffb,%edx
801087db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087de:	89 10                	mov    %edx,(%eax)
}
801087e0:	c9                   	leave  
801087e1:	c3                   	ret    

801087e2 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801087e2:	55                   	push   %ebp
801087e3:	89 e5                	mov    %esp,%ebp
801087e5:	53                   	push   %ebx
801087e6:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801087e9:	e8 ac f9 ff ff       	call   8010819a <setupkvm>
801087ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
801087f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801087f5:	75 0a                	jne    80108801 <copyuvm+0x1f>
    return 0;
801087f7:	b8 00 00 00 00       	mov    $0x0,%eax
801087fc:	e9 fd 00 00 00       	jmp    801088fe <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108801:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108808:	e9 cc 00 00 00       	jmp    801088d9 <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010880d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108810:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108817:	00 
80108818:	89 44 24 04          	mov    %eax,0x4(%esp)
8010881c:	8b 45 08             	mov    0x8(%ebp),%eax
8010881f:	89 04 24             	mov    %eax,(%esp)
80108822:	e8 3b f8 ff ff       	call   80108062 <walkpgdir>
80108827:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010882a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010882e:	75 0c                	jne    8010883c <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108830:	c7 04 24 86 90 10 80 	movl   $0x80109086,(%esp)
80108837:	e8 0a 7d ff ff       	call   80100546 <panic>
    if(!(*pte & PTE_P))
8010883c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010883f:	8b 00                	mov    (%eax),%eax
80108841:	83 e0 01             	and    $0x1,%eax
80108844:	85 c0                	test   %eax,%eax
80108846:	75 0c                	jne    80108854 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108848:	c7 04 24 a0 90 10 80 	movl   $0x801090a0,(%esp)
8010884f:	e8 f2 7c ff ff       	call   80100546 <panic>
    pa = PTE_ADDR(*pte);
80108854:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108857:	8b 00                	mov    (%eax),%eax
80108859:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010885e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108861:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108864:	8b 00                	mov    (%eax),%eax
80108866:	25 ff 0f 00 00       	and    $0xfff,%eax
8010886b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010886e:	e8 d7 a2 ff ff       	call   80102b4a <kalloc>
80108873:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108876:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010887a:	74 6e                	je     801088ea <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010887c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010887f:	89 04 24             	mov    %eax,(%esp)
80108882:	e8 58 f3 ff ff       	call   80107bdf <p2v>
80108887:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010888e:	00 
8010888f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108893:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108896:	89 04 24             	mov    %eax,(%esp)
80108899:	e8 7c cd ff ff       	call   8010561a <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010889e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801088a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088a4:	89 04 24             	mov    %eax,(%esp)
801088a7:	e8 26 f3 ff ff       	call   80107bd2 <v2p>
801088ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
801088af:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801088b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
801088b7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801088be:	00 
801088bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801088c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088c6:	89 04 24             	mov    %eax,(%esp)
801088c9:	e8 36 f8 ff ff       	call   80108104 <mappages>
801088ce:	85 c0                	test   %eax,%eax
801088d0:	78 1b                	js     801088ed <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801088d2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088df:	0f 82 28 ff ff ff    	jb     8010880d <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801088e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088e8:	eb 14                	jmp    801088fe <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801088ea:	90                   	nop
801088eb:	eb 01                	jmp    801088ee <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801088ed:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801088ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088f1:	89 04 24             	mov    %eax,(%esp)
801088f4:	e8 09 fe ff ff       	call   80108702 <freevm>
  return 0;
801088f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801088fe:	83 c4 44             	add    $0x44,%esp
80108901:	5b                   	pop    %ebx
80108902:	5d                   	pop    %ebp
80108903:	c3                   	ret    

80108904 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108904:	55                   	push   %ebp
80108905:	89 e5                	mov    %esp,%ebp
80108907:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010890a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108911:	00 
80108912:	8b 45 0c             	mov    0xc(%ebp),%eax
80108915:	89 44 24 04          	mov    %eax,0x4(%esp)
80108919:	8b 45 08             	mov    0x8(%ebp),%eax
8010891c:	89 04 24             	mov    %eax,(%esp)
8010891f:	e8 3e f7 ff ff       	call   80108062 <walkpgdir>
80108924:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010892a:	8b 00                	mov    (%eax),%eax
8010892c:	83 e0 01             	and    $0x1,%eax
8010892f:	85 c0                	test   %eax,%eax
80108931:	75 07                	jne    8010893a <uva2ka+0x36>
    return 0;
80108933:	b8 00 00 00 00       	mov    $0x0,%eax
80108938:	eb 25                	jmp    8010895f <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010893a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010893d:	8b 00                	mov    (%eax),%eax
8010893f:	83 e0 04             	and    $0x4,%eax
80108942:	85 c0                	test   %eax,%eax
80108944:	75 07                	jne    8010894d <uva2ka+0x49>
    return 0;
80108946:	b8 00 00 00 00       	mov    $0x0,%eax
8010894b:	eb 12                	jmp    8010895f <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010894d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108950:	8b 00                	mov    (%eax),%eax
80108952:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108957:	89 04 24             	mov    %eax,(%esp)
8010895a:	e8 80 f2 ff ff       	call   80107bdf <p2v>
}
8010895f:	c9                   	leave  
80108960:	c3                   	ret    

80108961 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108961:	55                   	push   %ebp
80108962:	89 e5                	mov    %esp,%ebp
80108964:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108967:	8b 45 10             	mov    0x10(%ebp),%eax
8010896a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010896d:	e9 89 00 00 00       	jmp    801089fb <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
80108972:	8b 45 0c             	mov    0xc(%ebp),%eax
80108975:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010897a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010897d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108980:	89 44 24 04          	mov    %eax,0x4(%esp)
80108984:	8b 45 08             	mov    0x8(%ebp),%eax
80108987:	89 04 24             	mov    %eax,(%esp)
8010898a:	e8 75 ff ff ff       	call   80108904 <uva2ka>
8010898f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108992:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108996:	75 07                	jne    8010899f <copyout+0x3e>
      return -1;
80108998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010899d:	eb 6b                	jmp    80108a0a <copyout+0xa9>
    n = PGSIZE - (va - va0);
8010899f:	8b 45 0c             	mov    0xc(%ebp),%eax
801089a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801089a5:	89 d1                	mov    %edx,%ecx
801089a7:	29 c1                	sub    %eax,%ecx
801089a9:	89 c8                	mov    %ecx,%eax
801089ab:	05 00 10 00 00       	add    $0x1000,%eax
801089b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801089b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089b6:	3b 45 14             	cmp    0x14(%ebp),%eax
801089b9:	76 06                	jbe    801089c1 <copyout+0x60>
      n = len;
801089bb:	8b 45 14             	mov    0x14(%ebp),%eax
801089be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801089c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801089c7:	29 c2                	sub    %eax,%edx
801089c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801089cc:	01 c2                	add    %eax,%edx
801089ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089d1:	89 44 24 08          	mov    %eax,0x8(%esp)
801089d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801089dc:	89 14 24             	mov    %edx,(%esp)
801089df:	e8 36 cc ff ff       	call   8010561a <memmove>
    len -= n;
801089e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089e7:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801089ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089ed:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801089f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801089f3:	05 00 10 00 00       	add    $0x1000,%eax
801089f8:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801089fb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801089ff:	0f 85 6d ff ff ff    	jne    80108972 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108a05:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a0a:	c9                   	leave  
80108a0b:	c3                   	ret    
