

#ifndef utils_hpp
#define utils_hpp


#include <stdio.h>


#if !defined(__GNUC__)
#error Constructs in this file (e.g. ## and __builtint_strrchr() depend on which compiler is used.
#endif


#define __FILENAME__ (__builtin_strrchr(__FILE__, '/') ? __builtin_strrchr(__FILE__, '/') + 1 : __FILE__)

// https://stackoverflow.com/a/27351464
#if defined(DEBUG) 
#define DEBUG_PRINT(fmt, ...) fprintf(stderr, "DEBUG %s:%d:%s(): " fmt, \
    __FILENAME__, __LINE__, __func__, ##__VA_ARGS__)
#else
#define DEBUG_PRINT(fmt, ...) // Don't do anything for Release builds.
#endif


#endif

