#include <stdint.h>

#if _WIN32
#define MYLIB_EXPORT __declspec(dllexport)
#else
#define MYLIB_EXPORT
#endif

MYLIB_EXPORT int32_t add(int32_t a, int32_t b);