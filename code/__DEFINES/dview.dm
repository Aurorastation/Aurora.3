//DVIEW defines

#define FOR_DVIEW(type, range, center, invis_flags) \
	GLOB.dview_mob.loc = center; \
	GLOB.dview_mob.see_invisible = invis_flags; \
	for(type in view(range, GLOB.dview_mob))

#define END_FOR_DVIEW GLOB.dview_mob.loc = null

#define DVIEW(output, range, center, invis_flags) \
	GLOB.dview_mob.loc = center; \
	GLOB.dview_mob.see_invisible = invis_flags; \
	output = view(range, GLOB.dview_mob); \
	GLOB.dview_mob.loc = null;
