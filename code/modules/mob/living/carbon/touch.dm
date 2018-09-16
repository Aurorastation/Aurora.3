/mob/living/carbon/proc/touch(var/datum/reagents/from, var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	return from.trans_to_holder(target,amount,multiplier,copy)