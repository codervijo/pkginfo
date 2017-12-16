#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

#define PATH_MAX 1024
main(int argc, char *argv[])
{
    int num = atoi(argv[1]);

    for (int i=0; i<num; i++) {
        char wrbuf[PATH_MAX];
        creat("/tmp/vc1", S_IRWXU|S_IRWXG); // Needs to be closed
        int fd = open ("/tmp/vc1", O_RDWR);
        printf("Opened fd %d\n", fd);
        int pid = getpid ();
        memset(wrbuf, 0, sizeof(wrbuf));
        snprintf(wrbuf, sizeof(wrbuf), "%d", pid);
        write(fd, wrbuf, sizeof(wrbuf));
        close(fd);
        printf("Closed fd:%d\n", fd);
    }
}

