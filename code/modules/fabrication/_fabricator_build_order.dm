/// Queue items are needed so that the queue knows exactly what it's doing.
/datum/fabricator_build_order
	/// The recipe singleton. We need to know exactly what we're making.
	var/singleton/autolathe_recipe/target_recipe
	/// Multiplier, used to know how many sheets we are printing. Note that this is specifically for sheets.
	var/multiplier = 1
	/// The materials used for this order.
	var/list/earmarked_materials = list()
	/// Remaining time for this order.
	var/remaining_time = 0

/datum/fabricator_build_order/New(singleton/autolathe_recipe/_target_recipe, _multiplier = 1)
	..()
	target_recipe = _target_recipe
	multiplier = _multiplier

/datum/fabricator_build_order/Destroy()
	target_recipe = null
	. = ..()
