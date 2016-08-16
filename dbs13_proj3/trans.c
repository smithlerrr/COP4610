//Drew Smith
//COP4610
//March 24th, 2016
//Posix Shared Memory
////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <errno.h>

#define BUFF_SIZE 4096
#define NAME "/shared-mem"

int main(int argc, char *argv[]) 
{
    int child_pipe[2];
    int parent_pipe[2];
    char *buffer, *in, *out;
    pid_t pid;
    int shm_fd, size = 0;


    if(argc != 3) 
    {
        fprintf(stderr, "Usage: %s <InputFile> <OutputFile>\n", argv[0]);
        exit(-1);
    }

    in = argv[1];
    out = argv[2];

    if(pipe(child_pipe) || pipe(parent_pipe) == -1) 
    {
        perror("Pipe Failed\n");
        exit(-1);
    }

    pid = fork();   //CREATE PROCESSES 
    
    if (pid == -1) 
    {
        perror("Fork Failed\n");
        exit(-1);
    }

    shm_fd = shm_open(NAME, O_CREAT | O_RDWR, 0666);

    if(shm_fd == -1)
    {
        perror("Shared Memory failed\n");
        exit(-1);
    }

    fprintf(stderr, "Shared Memory created! %s\n", NAME);
    ftruncate(shm_fd, BUFF_SIZE);
    
    buffer = (char*)mmap(0, BUFF_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0); //GET STARTING ADDRESS
    
    if(buffer == MAP_FAILED) 
    {
        printf("Map failed: %s\n", strerror(errno));
        exit(-1);
    }

    fprintf(stderr, "Map allocated correctly\n");

    if (pid == 0) //CHILD READS FROM PIPE
    {   
        close(child_pipe[1]);  //CLOSE CHILD WRITE
        close(parent_pipe[0]);  //CLOSE PARENT READ
        FILE *fout;
        fout = fopen(out, "w");
        while ((size = read(parent_pipe[0], &buffer, BUFF_SIZE)) > 0) //WRITE TO OUTPUT FILE
            fwrite(buffer, size, 1, fout);
        
        fclose(fout);
        close(child_pipe[0]);
        _exit(EXIT_SUCCESS);

        //WRITE BLOCK AND SIZE BACK TO PARENT
    } 

    else //PARENT PIPE
    {
        close(parent_pipe[1]);   //CLOSE PARENT WRITE END
        close(child_pipe[0]);   //CLOSE CHILD READ END
        FILE *fin;
        fin = fopen(in, "r");
        while((size = fread(buffer, 1, BUFF_SIZE, fin)) > 0)
            write(shm_fd, &buffer, BUFF_SIZE);
        
        fclose(fin);
        close(parent_pipe[0]);
        wait(NULL);            
    } 
}