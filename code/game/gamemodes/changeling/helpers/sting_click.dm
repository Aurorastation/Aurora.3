/mob/living/proc/check_sting(mob/living/holder, atom/target)
	SHOULD_NOT_SLEEP(TRUE)

	if(isliving(target) && holder.a_intent == I_HURT && holder.mind)
		var/datum/changeling/changeling = holder.mind.antag_datums[MODE_CHANGELING]
		if(changeling && changeling.prepared_sting)
			if(changeling.prepared_sting.can_sting(target))
				changeling.prepared_sting.do_sting(target)
				QDEL_NULL(changeling.prepared_sting)
				return TRUE

/mob/living/RangedAttack(atom/A, params)
	if(!get_active_hand())
		check_sting(src, A)
	. = ..()
