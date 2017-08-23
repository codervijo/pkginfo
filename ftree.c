#include <stdio.h>
#include <string.h>
#include <dirent.h>

void
search_proc (const char *dirname, const char *fname)
{
    DIR *dir;
    struct dirent *entry;

    dir = opendir(dirname);
    if (!dir)
        return;

    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_name[0] == '.')
            continue;
        if (strncasecmp(entry->d_name, fname, strlen(fname)) == 0)
            printf("Found %s in %s\n", fname, dirname);
        if (entry->d_type & DT_DIR) {
            char path[PATH_MAX];

            memset(path, 0, sizeof(path));
            snprintf(path, PATH_MAX, "%s/%s", dirname, entry->d_name);
            search_proc(path, fname);
        }
    }

    closedir(dir);
        
}

int
main(void)
{
   search_proc("/sys", "idVendor");
} 

