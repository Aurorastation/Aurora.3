/*
This file is used to include linter settings, as they might be incompatible with each other.
Nothing should ever be included before this file.
*/

//SpacemanDMM suite, always included as its definitions are used downstream directly, and just nulled if SPACEMAN_DMM is not defined
#include "___linters\spaceman_dmm.dm"

//OpenDream, only included if OPENDREAM is defined, as otherwise SpacemanDMM isn't happy about the pragma directives
#ifdef OPENDREAM
#include "___linters\odlint.dm"
#endif
