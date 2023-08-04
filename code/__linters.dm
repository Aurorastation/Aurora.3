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


//Poor man's code to try to catch people that are running the codebase without compiling tgui, aka in an unsupported way
//Basically, this tells you to use a supported compilation as defined in the repo's README
#if DM_VERSION < 515
/world/New()
	if(!fexists("./tgui/public/tgui.bundle.js"))
		world.log << "RTFM Error ID: 10-T"
		malfunction54()

/proc/malfunction54()
	set waitfor = 0
	while(TRUE)
		call(/proc/to_chat_immediate)(world, "<span class='danger'><font size=5>RTFM Error ID: 10-T</font></span>")
		sleep(10)
#else
#if !fexists("./tgui/public/tgui.bundle.js")
#error RTFM Error ID: 10-T
#endif
#endif
