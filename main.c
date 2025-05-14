#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

// Example template file for the code of process, the PID of which is passed to the bash script.

int main(void){
  // This is where the pid of the process is dumped.
	FILE *f = fopen("pid", "w");
	if (f == NULL) {
    fprintf(stderr, "ERROR: could not open file; errno: %d", errno);
    exit(1);
  }
  fprintf(f, "%d", getpid());
	fclose(f);

  // The fork code. This is merely an example of a parent process with three children.
	for (int i = 0; i < 3; ++i) {
		if (fork() == 0) 
			exit(0);
	}

  // This while loop is necessary, so that the Bash script finds time to grab the PID of
  // the process.
	while (1);
	exit(0);
}
