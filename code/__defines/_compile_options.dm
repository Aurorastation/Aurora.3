#define BACKGROUND_ENABLED 0    // The default value for all uses of set background. Set background can cause gradual lag and is recommended you only turn this on if necessary.
								// 1 will enable set background. 0 will disable set background.

// If defined, the sunlight system is enabled. Caution: this uses a LOT of memory.
//#define ENABLE_SUNLIGHT

// We want to use external resources. Kthx.
#define PRELOAD_RSC 0

#ifndef PRELOAD_RSC             //set to:
#define PRELOAD_RSC 2           //  0 to allow using external resources or on-demand behaviour;
#endif                          //  1 to use the default behaviour;
                                //  2 for preloading absolutely everything;