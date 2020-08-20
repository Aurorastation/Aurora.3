
/var/datum/controller/subsystem/cuisine/SScuisine

/datum/controller/subsystem/cuisine
	name = "Cuisine"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC
	var/list/recipe_datums = list()

/datum/controller/subsystem/cuisine/New()
	NEW_SS_GLOBAL(SScuisine)

#define ADD_TO_RDATUMS(i,t) if (R.appliance & i) { LAZYADD(recipe_datums["[i]"], t); added++; }

/datum/controller/subsystem/cuisine/Initialize(timeofday)
	for (var/type in subtypesof(/datum/recipe))
		var/datum/recipe/R = new type
		var/added = 0
		ADD_TO_RDATUMS(MIX, R)
		ADD_TO_RDATUMS(FRYER, R)
		ADD_TO_RDATUMS(OVEN, R)
		ADD_TO_RDATUMS(SKILLET, R)
		ADD_TO_RDATUMS(SAUCEPAN, R)
		ADD_TO_RDATUMS(POT, R)
		if (!added)
			log_debug("SSCuisine: warning: recipe '[type]' does not have a valid appliance type.")
			qdel(R)
	. = ..(timeofday)

#undef ADD_TO_RDATUMS
