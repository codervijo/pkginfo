#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <security/pam_appl.h>

/* A conversation function which uses an internally-stored value for
   the responses. */
static int
fake_conv (int num_msg, const struct pam_message **msg,
	   struct pam_response **response, void *appdata_ptr)
{
  struct pam_response *reply;
  int count;

  /* Sanity test. */
  if (num_msg <= 0)
    return PAM_CONV_ERR;

  /* Allocate memory for the responses. */
  reply = calloc (num_msg, sizeof (struct pam_response));
  if (reply == NULL)
    return PAM_CONV_ERR;

  char *user, *pass;

  for (int i = 0; i < num_msg; i++) {
    switch(msg[i]->msg_style) {
    case PAM_PROMPT_ECHO_ON:
        fprintf(stdout, "Got prompt echo on\n");
        user=((char **)appdata_ptr)[0];
        fprintf(stdout, "user: %s\n", user);
        break;

    case PAM_PROMPT_ECHO_OFF:
        fprintf(stdout, "Echo oFF\n");
        fprintf(stdout, "Msg>>%s\n", msg[i]->msg);
        //user=((char **)appdata_ptr)[0];
        //fprintf(stdout, "user: %s\n", user);
        //pass=((char **)appdata_ptr)[1];
        //fprintf(stdout, "pass: %s\n", pass);
        break;

    case PAM_ERROR_MSG:
        fprintf(stdout, "error : %s\n", msg[i]->msg);
        break;

    case PAM_TEXT_INFO:
        fprintf(stdout, "%s\n", msg[i]->msg);
    }
  }
  /* Each prompt elicits the same response. */
  for (count = 0; count < num_msg; ++count)
    {
      reply[count].resp_retcode = 0;
      reply[count].resp = strdup ("12345");
    }

  /* Set the pointers in the response structure and return. */
  *response = reply;
  return PAM_SUCCESS;
}

static struct pam_conv conv = {
    fake_conv,
    NULL
};

int
main(int argc, char *argv[])
{
  pam_handle_t *pamh = NULL;
  const char *user="vijmaho";
  int retval;
  int debug = 0;

  if (argc > 1 && strcmp (argv[1], "-d") == 0)
    debug = 1;

  retval = pam_start("tst-pam_access1", user, &conv, &pamh);
  if (retval != PAM_SUCCESS)
    {
      if (debug)
	fprintf (stderr, "pam_access1: pam_start returned %d\n", retval);
      return 1;
    }

  retval = pam_set_item (pamh, PAM_TTY, "/dev/tty1");
  if (retval != PAM_SUCCESS)
    {
      if (debug)
	fprintf (stderr,
		 "pam_access1: pam_set_item(PAM_TTY) returned %d\n",
		 retval);
      return 1;
    }

  retval = pam_authenticate (pamh, 0);
  if (retval != PAM_SUCCESS)
    {
      if (debug)
	fprintf (stderr, "pam_access1: pam_authenticate returned %d\n", retval);
      return 1;
    }

  retval = pam_end (pamh,retval);
  if (retval != PAM_SUCCESS)
    {
      if (debug)
	fprintf (stderr, "pam_access1: pam_end returned %d\n", retval);
      return 1;
    }
  return 0;
}

