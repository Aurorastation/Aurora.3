/mob/living/proc/check_sting(var/mob/living/holder, var/atom/target)
	if(isliving(target) && holder.a_intent == I_HURT && holder.mind)
		var/datum/changeling/changeling = holder.mind.antag_datums[MODE_CHANGELING]
		if(changeling && changeling.prepared_sting)
			if(changeling.prepared_sting.can_sting(holder))
				changeling.prepared_sting.do_sting(holder)
				QDEL_NULL(changeling.prepared_sting)
				return TRUE

/mob/living/RangedAttack(var/atom/A, var/params)
	if(!get_active_hand())
		check_sting(src, A)
	. = ..()
