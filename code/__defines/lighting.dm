//DVIEW defines
//DVIEW is a hack that uses a mob with darksight in order to find lists of viewable stuff while ignoring darkness

var/mob/dview/dview_mob = new

/mob/dview
	invisibility = 101
	density = 0

	anchored = 1
	simulated = 0

	see_in_dark = 1e6

#define FOR_DVIEW(type, range, center, invis_flags) \
	dview_mob.loc = center; \
	dview_mob.see_invisible = invis_flags; \
	for(type in view(range, dview_mob))

#define END_FOR_DVIEW dview_mob.loc = null

#define DVIEW(output, range, center, invis_flags) \
	dview_mob.loc = center; \
	dview_mob.see_invisible = invis_flags; \
	output = view(range, dview_mob); \
	dview_mob.loc = null ;




// Night lighting controller times
// The time (in ticks based on worldtime2ticks()) that various actions trigger
#define MORNING_LIGHT_RESET 252000       // 7am or 07:00 - lighting restores to normal in morning
#define NIGHT_LIGHT_ACTIVE 648000        // 6pm or 18:00 - night lighting mode activates
