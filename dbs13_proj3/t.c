#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <errno.h>


struct shm_buffer{
	char *source[4000];
	int b_count;
};

const char *name = "/shared-mem";		// file name
int SIZE;								// file size
int shm_fd;								// file descriptor, from shm_open()
char *shm_base;							// base address, from mmap()
FILE *input, *output;					// file types of input output
char *ifile, *ofile;					// string literalls of input output file
int st_size;							// how many 4kb buffers we will need

void display(char *prog, char *bytes, int n);
int getFileSize(FILE *input);


// MAIN 
int main(int argc, char *argv[])
{
   int pipefd[2];
   pid_t cpid;
   char buf;
   int block = 1;
   int b_length;

   

   if (argc != 3) {
       //fprintf(stderr, "Usage: %s <string>\n", argv[0]);
       fprintf(stderr, "Usage: %s <inputfile> <outputfile>\n", argv[0]);
       exit(EXIT_FAILURE);
   }

   ifile = argv[1];
   SIZE = getFileSize(argv[1]);
   printf("SIZE: (%d)\n", SIZE);

   if(SIZE < 4000)
   	st_size = 1;
   if(SIZE >= 4000)
   	st_size = (SIZE / 4000)+1;

   printf("how many buffers are needed?: %d\n", st_size);


   struct shm_buffer myMemory;


   	myMemory.b_count = 1;




   if (pipe(pipefd) == -1) {
       perror("pipe");
       exit(EXIT_FAILURE);
   }

   cpid = fork();
   // if fork fails
   if (cpid == -1) {
       perror("fork");
       exit(EXIT_FAILURE);
   }

   // child / consumer
   if (cpid == 0) {    /* Child reads from pipe */
	shm_fd = shm_open(name, O_RDONLY, 0666);
	if (shm_fd == -1) {
		printf("cons: Shared memory failed: %s\n", strerror(errno));
		exit(1);
	}

	/* map the shared memory segment to the address space of the process */
	shm_base = mmap(0, SIZE, PROT_READ, MAP_SHARED, shm_fd, 0);
	if (shm_base == MAP_FAILED) {
		printf("CHILD: Map failed: %s\n", strerror(errno));
		// close and unlink?
		exit(1);
	}
	//=-=-=-=-=-=Critical Section=-=-=-=-=-=-=-=
	//sem_wait(mysem);
	printf ("\nDoes the child work?\n");
	printf("%s\n", shm_base);


	//sem_post(mysem);
	//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	//close(pipefd[1]);          /* Close unused write end */
	int blocknumber = 0;
	int blocklength = 0;
	int p1 = 1;
	// get block number

	read(pipefd[0], &blocknumber, sizeof(int));
	printf("\nBlock#: %i\n", blocknumber);
		
//printf("gethere?**");
	

	// sends back true for first val recieved
	//close(pipefd[0]);
	//open(pipefd[1]);
	//write(pipefd[1], &p1, sizeof(p1)); 
	

	//close(pipefd[1]);          /* Close unused write end */
	
	// get block length
	read(pipefd[0], &blocklength, sizeof(int));
	printf("\nBlockLength: %i\n", blocklength);

	//close(pipefd[0]);
	//open(pipefd[1]);
	// send back confirmation 
	int vv = blocknumber;
	write(pipefd[1], &vv, sizeof(vv));


	//while (read(pipefd[0], &buf, 1) > 0)
	//   write(STDOUT_FILENO, &buf, 1);

	//write(STDOUT_FILENO, "\n", 1);
	//close(pipefd[0]);
	_exit(EXIT_SUCCESS);

   } 


   // parent / producer
   else {    

	char *ptr;		// shm_base is fixed, ptr is movable

	/* create the shared memory segment as if it was a file */
	shm_fd = shm_open(name, O_CREAT | O_RDWR, 0666);
	if (shm_fd == -1) {
		printf("PARENT: Shared memory failed: %s\n", strerror(errno));
		exit(1);
	}

	
	/* configure the size of the shared memory segment */
	// this should be the size of the entire file that we read 
  	ftruncate(shm_fd, SIZE);

	/* map the shared memory segment to the address space of the process */
	shm_base = mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
	if (shm_base == MAP_FAILED) {
		printf("prod: Map failed: %s\n", strerror(errno));
		// close and shm_unlink?
		exit(1);
	}

	//=-=-=-=-=-=Critical Section=-=-=-=-=-=-=-=
	// need loop until child returns done 
	// must only take 4KB at once then let child read
	// will send block number and block length to child thorugh pipe
	//do{
		//sem_wait(mysem);
	if((input = fopen(argv[1],"r")) == NULL)
		{   // if fopen fails
		    perror("fopen");
		    exit(EXIT_FAILURE);
		}
	ptr = shm_base;



	int result = fread(myMemory.source,1,500,input);
	printf("result of fread: %i\n", result);

	ptr += sprintf(ptr, "%s", myMemory.source);

	printf ("\nDoes the parent work?\n");



		//sem_post(mysem);
	//}while(x != 0);// loop until returned block number is 0
	//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

   /* Parent writes block number and block length to pipe */
	//close(pipefd[0]);          /* Close unused read end */

	//send block number
	int n = 12345;

	write(pipefd[1], &n, sizeof(n));


	//close(pipefd[1]);          
	//open(pipefd[0]);
	//int first;
	//read(pipefd[0], &first, sizeof(first));
	//write(STDOUT_FILENO, &first, sizeof(first));
	//if(first == 1)
	//	printf("TRUE\n");
	//close(pipefd[0]);
	//send block length
	//printf("gethere-?");
	int q = 999;
	//open(pipefd[1]);
	write(pipefd[1], &q, sizeof(q));
	//printf("gethere?");

	//get back block number from child
	//close(pipefd[1]);
	//open(pipefd[0]);
	int ret;
	read(pipefd[0], &ret, sizeof(int));
	//write(STDOUT_FILENO, &ret, 1);

	if(ret == n)
		printf("RETURNED SAME\n");	


	wait(NULL);                /* Wait for child */
	exit(EXIT_SUCCESS);
   }
}

void display(char *prog, char *bytes, int n)
{
  printf("display: %s\n", prog);
  for (int i = 0; i < n; i++)
    { printf("%02x%c", bytes[i], ((i+1)%16) ? ' ' : '\n'); }
  printf("\n");
}

int getFileSize(FILE *input){
	// open file
	if((input = fopen(ifile,"r")) == NULL)
		{   // if fopen fails
		    perror("fopen");
		    exit(EXIT_FAILURE);
		}

	long shm_size;
	//find size of the file we are reading
	if (fseek(input, 0L, SEEK_END) == 0){
         shm_size = ftell(input);
        if (shm_size == -1) { 
        	perror("fseek");
		    exit(EXIT_FAILURE);
		}
	}
	fclose(input);
	return shm_size;
}