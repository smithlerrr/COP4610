#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define name "/example"
#define SIZE 4096

int main(int argc, char *argv[])
{
    int pipefd[2];
    int shm_fd;
    pid_t cpid;
    char buf;
    char *shm_base;

    if (argc != 2) 
    {
        fprintf(stderr, "Usage: %s <string>\n", argv[0]);
        exit(-1);
    }

    if (pipe(pipefd) == -1) 
    {
        perror("Pipe failed.\n");
        exit(-1);
    }

    cpid = fork();

    if (cpid == -1) 
    {
        perror("Fork failed.\n");
        exit(-1);
    }

    shm_fd = shm_open(name, O_CREATE | O_RDWR, 0666);

    if(shm_fd < 0)
    {
        perror("Shared Memory failed\n");
        exit(1);
    }

    fprintf(stderr, "Shared Memory created! %s\n", name);
    ftruncate(shm_fd, BUFF_SIZE);
    
    shm_base = mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
    
    if (shm_base == NULL) 
    {
        perror("Map failed\n");
        exit(1);
    }

    fprintf(stderr, "Shared memory segment allocated correctly\n");

    if (cpid == 0) /* Child reads from pipe */
    {   
        close(pipefd[1]);  /* Close unused write end */

        while (read(pipefd[0], &shm_base, 1) > 0)
            write(STDOUT_FILENO, &buf, 1);

        write(STDOUT_FILENO, "\n", 1);
        close(pipefd[0]);
        _exit(EXIT_SUCCESS);

    } 

    else 
    {            /* Parent writes argv[1] to pipe */
        close(pipefd[0]);          /* Close unused read end */
        write(pipefd[1], argv[1], strlen(argv[1]));
        close(pipefd[1]);          /* Reader will see EOF */
        wait(NULL);                /* Wait for child */
        exit(EXIT_SUCCESS);
    }
}