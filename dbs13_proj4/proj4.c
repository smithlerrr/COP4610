//Drew Smith
//COP4610
//April 2016
//Producer-Consumer Project

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <semaphore.h>
#include <pthread.h>
#include <signal.h>

#define BUFFER_SIZE 5
#define TRUE 1

typedef int buffer_item;
buffer_item buffer[BUFFER_SIZE];

// FUNCTION PROTOTYPES
void initializeBuffer();
void *producer(void *param);
void *consumer(void *param); 
int insert_item(buffer_item item); 
int remove_item(buffer_item *item);
void sig_handler(int);

// GLOBAL VARIABLES
pthread_mutex_t mutex;
int counter, first, last;
int flag = 0;
sem_t empty, full;

int main(int argc, char *argv[]) 
{
  int i;

  if(argc != 4)   
  {
     fprintf(stderr, "USAGE:./proj4 <INT> <INT> <INT>\n");
  }

  int sleeptime = atoi(argv[1]);
  int numProd = atoi(argv[2]);
  int numCons = atoi(argv[3]);

  initializeBuffer();

  pthread_t p_tid[numProd];
  pthread_attr_t p_attr[numProd]; 

  for (i = 0; i < numProd-1; i++) 
  {
    pthread_attr_init(&p_attr[i] );
    pthread_create( &p_tid[i], &p_attr[i], producer, NULL );
  }

  pthread_t c_tid[numCons];
  pthread_attr_t c_attr[numCons];

  for (i = 0; i < numCons-1; i++) 
  {
    pthread_attr_init( &c_attr[i] );
    pthread_create( &c_tid[i], &c_attr[i], consumer, NULL );
  }

  for (i = 0; i < numProd; i++)
    pthread_join(p_tid[i], NULL);

  for (i = 0; i < numCons; i++)
    pthread_join(c_tid[i], NULL);

  sleep(sleeptime);
  printf("Exit the program\n");
  exit(0);
}

void initializeBuffer() 
{
  sem_init(&empty, 0, BUFFER_SIZE);
  sem_init(&full, 0, 0);
  pthread_mutex_init(&mutex, NULL);
  counter = 0;
  first = 0;
  last = 0;
}

void *producer(void *param)
{
  buffer_item item;

  do 
  {
    signal(SIGINT, sig_handler);
    sleep((rand() % 10) + 1);
    item = rand();
    sem_wait(&empty);
    pthread_mutex_lock(&mutex);

    if(insert_item(item)) 
      fprintf(stderr, "Producer Error!\n");
    
    else 
    {
      printf("producer produced %d\n", item);
    }

    pthread_mutex_unlock(&mutex);
    sem_post(&full);

    if(flag == 1)
      break;
  } while(TRUE);
}

void *consumer(void *param) 
{
  buffer_item item;

  do
  {
    signal(SIGINT, sig_handler);
    sleep((rand() % 10) + 1);
    sem_wait(&full);
    pthread_mutex_lock(&mutex);
    
    if(remove_item(&item)) 
      fprintf(stderr, "Consumer Error!\n");
    
    else 
      printf("consumer consumed %d\n", item);

    pthread_mutex_unlock(&mutex);
    sem_post(&empty);

    if(flag == 1)
      break;
  } while(TRUE);
}

/* Add an item to the buffer */
int insert_item(buffer_item item) 
{
  if(counter < BUFFER_SIZE) 
  {
    buffer[last] = item;
    last = (last + 1) % BUFFER_SIZE;
    counter++;
    return 0;
  }
  
  else
  { 
    printf("\nError: The buffer is full.");
    return -1;
  }
}

/* Remove item from the buffer */
int remove_item(buffer_item *item) 
{
  if(counter > 0) 
  {
    *item = buffer[first];
    first = (first + 1) % BUFFER_SIZE;
    counter--;
    return 0;
  }
   
  else
  { 
    printf("Error: The buffer is empty.");
    return -1;
  }
}

void sig_handler(int sig)
{
  if(sig == SIGINT)
  {
    printf("\nReceived SIGINT.\nKilling threads...\n");
    sleep(2);
    flag = 1;
  }
}