#include <stdio.h>
#include <win32lib.h>

#include <kpathsea/config.h>
#include <kpathsea/lib.h>
#include <kpathsea/c-vararg.h>

#ifdef OEM
boolean bOem = false;

#define IS_OEM(f) (bOem && (f == stdout))

int
putcOem(int c, FILE *f)
{
  if (IS_OEM(f)) {
    char buf[2];
    *buf = c;
    *(buf+1) = '\0';
    CharToOem(buf, buf);
    return putc(*buf, f);
  }
  else
    return putc(c, f);
}

int
FputsOem(FILE *f, char *s)
{
  if (IS_OEM(f)) {
    char *buf = xstrdup(s);
    int ret;
    CharToOem(buf, buf);
    ret = fputs(buf, f);
    free(buf);
    return ret;
  }
  else
    return fputs(s, f);
}

int
fprintfOem(FILE *f, const char *fmt, ...)
{
  int ret;
  va_list mark;
  va_start(mark, fmt);

  if (IS_OEM(f)) {
    char buf[1024];
    ret = _vsnprintf(buf, sizeof(buf), fmt, mark);
    CharToOem(buf, buf);
    fputs(buf, f);
  }
  else
    ret = vfprintf(f, fmt, mark);
  va_end(mark);
  return ret;
}

#endif
