#define CHECK_STING(holder, target) \
	if(isliving(target) && holder.a_intent == I_HURT && holder.mind) { \
		var/datum/changeling/changeling = holder.mind.antag_datums[MODE_CHANGELING]; \
		if(changeling && changeling.prepared_sting) { \
			if(changeling.prepared_sting.can_sting(A)) { \
				changeling.prepared_sting.do_sting(A); \
				QDEL_NULL(changeling.prepared_sting); \
				return; \
			} \
		} \
	}

/mob/living/UnarmedAttack(var/atom/A, var/proximity)
	CHECK_STING(src, A)
	. = ..()

/mob/living/RangedAttack(var/atom/A, var/params)
	if(!get_active_hand())
		CHECK_STING(src, A)
	. = ..()

#undef CHECK_STING
