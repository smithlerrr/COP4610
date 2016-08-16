#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"


int
main(int argc, char *argv[])
{
	struct uproc table[64];
	int max = 64;

  	int proc_count = getprocs(max, table);
  	printf(1, "Number of Processes: %d\n", proc_count);

	exit();
}



