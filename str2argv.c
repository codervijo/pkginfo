{
       /* Convert instr into argc, argv */
        largc = 0;
        largv = NULL;
        largv = malloc(sizeof(char *));
        largv[largc] = malloc(strlen(PROGRAM)+1);
        memset(largv[largc], 0, strlen(PROGRAM)+1);
        largc++;
        while (instr[curr] != '\0')
        {
            //printf("start:%d curr:%d, instr[curr]:%c(%x)\n", start, curr, instr[curr], instr[curr]);
            if (!isspace(instr[curr]))
            {
                curr++;
                continue;
            }
            else
            {
                while (isblank(instr[start]) && start < curr)
                {
                    start++;
                }
                if (curr == start)
                {
                    continue;
                }
                largv = realloc(largv, (largc+1)*sizeof(char *));
                if (largv == NULL)
                {
                    fprintf(stderr, "Failed to get memory\n");
                    close(pipefd);
                    return -1;
                }
                int newstrlen = curr - start;
                largv[largc] = (char *)malloc(newstrlen);
                if (largv[largc] == NULL)
                {
                    fprintf(stderr, "Failed to get memory\n");
                    close(pipefd);
                    return -1;
                }
                memset(largv[largc], 0, newstrlen);
                memcpy(largv[largc], &instr[start], newstrlen);
                largv[largc][newstrlen] = '\0';
                //printf("Cmdline %d : %s\n", largc, largv[largc]);
                largc++;
                start = curr;
                curr++;
            }
        }
        largv = realloc(largv, (largc+1)*sizeof(char *));
        largv[largc] = NULL;
       /* Convert instr into argc, argv */
        largc = 0;
        largv = NULL;
        largv = malloc(sizeof(char *));
        largv[largc] = malloc(strlen(PROGRAM)+1);
        memset(largv[largc], 0, strlen(PROGRAM)+1);
        largc++;
        while (instr[curr] != '\0')
        {
            //printf("start:%d curr:%d, instr[curr]:%c(%x)\n", start, curr, instr[curr], instr[curr]);
            if (!isspace(instr[curr]))
            {
                curr++;
                continue;
            }
            else
            {
                while (isblank(instr[start]) && start < curr)
                {
                    start++;
                }
                if (curr == start)
                {
                    continue;
                }
                largv = realloc(largv, (largc+1)*sizeof(char *));
                if (largv == NULL)
                {
                    fprintf(stderr, "Failed to get memory\n");
                    close(pipefd);
                    return -1;
                }
                int newstrlen = curr - start;
                largv[largc] = (char *)malloc(newstrlen);
                if (largv[largc] == NULL)
                {
                    fprintf(stderr, "Failed to get memory\n");
                    close(pipefd);
                    return -1;
                }
                memset(largv[largc], 0, newstrlen);
                memcpy(largv[largc], &instr[start], newstrlen);
                largv[largc][newstrlen] = '\0';
                //printf("Cmdline %d : %s\n", largc, largv[largc]);
                largc++;
                start = curr;
                curr++;
            }
        }
        largv = realloc(largv, (largc+1)*sizeof(char *));
        largv[largc] = NULL;

}
