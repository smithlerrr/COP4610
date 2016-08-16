#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

#define BUFF_SIZE 4096

int main(int argc, char *argv[]) 
{
  int parent_pipe[2], child_pipe[2];
  int counter = 0;
  pid_t pid;
  char *buff;

  if (argc != 2) 
  {
    fprintf(stderr, "Usage: %s <string>\n", argv[0]);
    exit(-1);
  }

  if(pipe(parent_pipe) < 0) 
  {
    fprintf(stderr, "Cannot create pipe.\n");
    exit(-1);
  }

  if(pipe(child_pipe) < 0) 
  {
    fprintf(stderr, "Cannot create pipe.\n");
    exit(-1);
  }

  pid = fork();
  
  if(pid == -1) 
  {
    printf("Cannot fork.\n");
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

  if (pid == 0) 
  {

    close(child_pipe[1]);

    while (read(child_pipe[0], &buff, SIZE) > 0) 
    {
      sprintf(buff, "From child : %d", counter++);

      int len = write(child_pipe[1], buff, strlen(buff));
      if (len != strlen(buff)) {
        fprintf(stderr, "Error in writing to pipe\n");
        exit(-1);
      }

      memset(buff, 0, BUFF_SIZE);
      sleep(1);
    }
  } else {
    while (1) {
      memset(buff, 0, strlen(buff));

      int len = read(child_pipe[0], buff, BUFF_SIZE);
      if (len != strlen(buff)) {
        perror(NULL);
        break;
      }

      if (strlen(buff) != 0)
        printf("Parent Process: %s\n", buff);
      sleep(1);
    }
  }

  return EXIT_SUCCESS;
}