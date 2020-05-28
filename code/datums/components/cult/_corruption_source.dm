#define SOURCE_PASSIVE    1 //This corruption source works by applying corruption to all mobs in X range.
#define SOURCE_ACTIVE     2 //This corruption soruce applies corruption when a mob does an action.

/datum/component/corruption_source
	var/strength = 0 //Strength is corruption applied per process tick if passive, otherwise, it is the amount of corruption added to a mob.

	var/source_type
	var/passive_range

/datum/component/corruption_source/Initialize(var/strength, var/source, var/range = 0)
	strength = strength
	source_type = source
	passive_range = range

/datum/component/corruption_source/proc/activate(var/mob/target)
