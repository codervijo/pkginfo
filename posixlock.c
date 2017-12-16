#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <sched.h>
#include <limits.h>

#define LOCK_FILE "/var/lock/posix.lock"

void get_exclusive_lock ()
{
    int fd, pid;
    char wrbuf[PATH_MAX];
    struct flock lock;

    creat (LOCK_FILE, O_RDWR);
    fd = open (LOCK_FILE, O_RDWR);
    if (fd < 0)
    {
        fprintf (stderr, "Failed to lock for this program\n");
        exit (EXIT_FAILURE);
    }
    memset (&lock, 0, sizeof(lock));
    lock.l_type = F_WRLCK;
    while (fcntl(fd, F_SETLKW, &lock) != 0)
    {
        fprintf (stderr, "Lock is held by another process, spinning\n");
        sleep (1);
        sched_yield();
    }
    pid = getpid ();
    memset (wrbuf, 0, sizeof(wrbuf));
    snprintf (wrbuf, sizeof(wrbuf), "%d", pid);
    write (fd, wrbuf, sizeof(wrbuf));
    /* Note: we dont close the FD, because fcntl lock will be unlocked on close */

    return;
}

void release_exlusive_lock (void)
{
    int fd;
    struct flock lock;

    fd = open (LOCK_FILE, O_RDWR);
    if (fd < 0)
    {
        fprintf (stderr, "Failed to UNlock for this program\n");
        exit (EXIT_FAILURE);
    }
    memset (&lock, 0, sizeof(lock));
    lock.l_type = F_UNLCK;
    fcntl (fd, F_SETLKW, &lock);
    close (fd);
}

int main()
{
    get_exclusive_lock();
}

