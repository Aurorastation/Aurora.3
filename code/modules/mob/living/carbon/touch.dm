/mob/living/carbon/proc/touch(var/datum/reagents/from, var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	var/datum/reagents/R = new /datum/reagents(amount*multiplier) //Temp holder
	from.trans_to_holder(R, amount, multiplier, copy)
	R.touch_mob(src)
	. = R.trans_to_holder(target, amount, multiplier, copy)
	qdel(R)
	return .
