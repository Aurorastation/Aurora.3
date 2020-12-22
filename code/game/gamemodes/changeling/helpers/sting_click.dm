#define CHECK_STING(holder, target) \
	if(isliving(target) && holder.a_intent == I_HURT && holder.mind && holder.mind.changeling && holder.mind.changeling.prepared_sting) { \
		if(holder.mind.changeling.prepared_sting.can_sting(A)) { \
			holder.mind.changeling.prepared_sting.do_sting(A); \
			QDEL_NULL(holder.mind.changeling.prepared_sting); \
			return; \
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