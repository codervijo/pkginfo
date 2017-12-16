
/* From libusb: linux_usbfs.c */
static int check_usb_vfs (const char *dirname)
{
    DIR *dir;
    struct dirent *entry;
    int found = 0;

    dir = opendir(dirname);
    if (!dir)
        return 0;

    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_name[0] == '.')
            continue;

        /* We assume if we find any files that it must be the right place */
        found = 1;
        break;
    }

    closedir(dir);
    return found;
}

char *get_usbfile_contents (const char *dirname, char *fname)
{
    char filename[1024], contents[1024];
    char *ret;
    int fd, sz;

    memset(filename, 0, sizeof(filename));
    snprintf(filename, sizeof(filename), "%s/%s", dirname, fname);
    //printf("Reading from filename %s\n", filename);
    fd = open(filename, O_RDONLY);
    if (fd == -1) {
        fprintf(stderr, "Failed to open %s\n", filename);
        return NULL;
    }
    sz = read(fd, contents, sizeof(contents));
    close(fd);
    if (sz <= 0) {
        fprintf(stderr, "Failed to read from %s\n", contents);
        return NULL;
    }
    //printf("Read contents >%s< of size %d\n", contents, sz);
    ret = (char *)malloc(sz);
    if (ret == NULL) {
        fprintf(stderr, "Failed to get memory\n");
        return NULL;
    }
    memcpy(ret, contents, sz);
    //printf("Found content >%s< in file ]%s[\n", contents, filename);
    return ret;
}

const char *get_device_dir (const char *dirname)
{
    DIR *dir;
    const char *vname = "idVendor", *pname = "idProduct";
    const char *vid   = "0403", *pid = "6014";
    const char *ret = NULL;
    char *contents = NULL;
    struct dirent *entry;
    int vidfound = 0, pidfound = 0;

    dir = opendir(dirname);
    if (!dir)
        return NULL;

    while ((entry = readdir(dir)) != NULL) {
        if (entry->d_name[0] == '.')
            continue;

        //printf("From %s Checking %s\n", dirname, entry->d_name);
        if (strncasecmp(entry->d_name, vname, strlen(vname)) == 0) {
            //printf("Score 1! Found %s\n", entry->d_name);
            contents = get_usbfile_contents (dirname, entry->d_name);
            if (contents == NULL)
                continue;
            if (strncasecmp(contents, vid, strlen(vid)) == 0) {
                vidfound = 1;
            }
            free(contents);
        }
        if (strncasecmp(entry->d_name, pname, strlen(pname)) == 0) {
            //printf("Score!!! fOUND %s\n", entry->d_name);
            contents = get_usbfile_contents (dirname, entry->d_name);
            if (contents == NULL)
                continue;
            if (strncasecmp(contents, pid, strlen(pid)) == 0) {
                pidfound = 1;
            }
            free(contents);
        }
        if (vidfound == 1 && pidfound == 1) {
            //printf("Found both returning %s\n", dirname);
            closedir(dir);
            return dirname;
        }
        if (vidfound == 0 && pidfound == 0) {
            //printf("It's type is 0x%x and DIR is %x\n", entry->d_type, DT_DIR);
            if (entry->d_type == DT_DIR || entry->d_type == DT_LNK) {
                char path[PATH_MAX];

                memset(path, 0, sizeof(path));
                snprintf(path, sizeof(path), "%s/%s", dirname, entry->d_name);
                //printf("recursive search on %s\n", path);
                if (strlen(path) < 50) /* Poor man's cycle identification */
                    ret = get_device_dir(path);
                    if (ret != NULL)
                        break;
            }
        }
    }

    //printf("Returning %s\n", ret);
    closedir(dir);
    return ret;
}

int reset_usb_dev (char *sysusb)
{
    char cmd[PATH_MAX];
    const char *devusb = "/dev/bus/usb";

    if (check_usb_vfs(devusb)) {
        /* if /dev/bus/usb exists, send ioctl to RESET  */
        char devfname[PATH_MAX];
        char *busnum, *devnum;
        int fd = 0, rc = 0;

        /* If anything fails, reset by kicking authorized file */
        busnum = get_usbfile_contents (sysusb, "busnum");
        if (busnum != NULL) {
            devnum = get_usbfile_contents (sysusb, "devnum");
            if (devnum != NULL) {
                memset(devfname, 0, sizeof(devfname));
                snprintf(devfname, sizeof(devfname), "%s/%s/%s", devusb, busnum, devnum);
                free(busnum);
                free(devnum);
                fd = open(devfname, O_WRONLY);
                if (fd > 0 )
                    rc = ioctl(fd, USBDEVFS_RESET, 0);
                close(fd);
                if (rc > 0)
                    return BNCTL_OK;
            }
        }
    }

    //printf("Reseting in directory %s\n", sysusb);
    memset(cmd, 0, sizeof(cmd));
    snprintf(cmd, sizeof(cmd), "echo \"0\">%s/authorized", sysusb);
    system(cmd);
    sleep(1);
    snprintf(cmd, sizeof(cmd), "echo \"1\">%s/authorized", sysusb);
    system(cmd);
    sleep(1);
}

int main()
{
        usbdev = get_device_dir("/sys/bus/usb/devices");
        strcpy(ftdevpath, usbdev);
        //printf("Found usb dev dir to be %s\n", ftdevpath);
        reset_usb_dev(ftdevpath);
}
