/* usage.c: Output a help message (from help.h).

   Modified in 2001 by O. Weber.
   Written in 1995 by K. Berry.  Public domain.  */

#include "config.h"

/* Call usage if the program exits with an "usage error".  STR is supposed
   to be the program name. */

void
usage P1C(const_string, str)
{
  fprintf (stderr, "Try `%s --help' for more information.\n", str);
  uexit (1);
}

/* Call usage if the program exits by printing the help message.
   MESSAGE is an NULL-terminated array or strings which make up the
   help message.  Each string is printed on a separate line.
   We use arrays instead of a single string to work around compiler
   limitations (sigh).
*/
void
usagehelp P1C(const_string*, message)
{
    extern KPSEDLL char *kpse_bug_address;

    while (*message) {
        fputs(*message, stdout);
        putchar('\n');
        ++message;
    }
    putchar('\n');
    fputs(kpse_bug_address, stdout);
    uexit(0);
}
