#include <sys/types.h>
#include <stdio.h>
#include <dirent.h>

static void print_ifs (const char *dirname)
{
    DIR *dir;
    struct dirent *entry;
    char   fname[1024], lname[1024];

    dir = opendir(dirname);
    if (!dir)
        return 0;

    while ((entry = readdir(dir)) != NULL)
    {
        if (entry->d_name[0] == '.')
            continue;

        memset(fname, 0, sizeof(fname));
        snprintf(fname, sizeof(fname), "%s/%s", "/sys/class/net",
                 entry->d_name);
        memset(lname, 0, sizeof(lname));
        readlink(fname, lname, sizeof(lname));
        if (strstr(lname, "virtual") == NULL) {
            printf("Got this device:%s\n", entry->d_name);
        }
    }

    closedir(dir);
    return;
}

main()
{
    print_ifs("/sys/class/net");
}
