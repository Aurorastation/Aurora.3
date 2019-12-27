#define INVOKE_AUGMENT(holder, powers, target, return_on_invocation) \
	if(holder && holder.psi && holder.psi.can_use()) { \
		for(var/thing in powers) { \
			var/datum/special_power/psionic/power = thing; \
			var/obj/item/result = power.invoke(holder, target); \
			if(result) { \
				power.handle_post_power(holder, target); \
				if(istype(result)) { \
					sound_to(holder, sound('sound/effects/psi/power_evoke.ogg')); \
					LAZYADD(holder.psi.manifested_items, result); \
					holder.put_in_hands(result); \
				} \
				return return_on_invocation; \
			} \
		} \
	}

/mob/living/UnarmedAttack(var/atom/A, var/proximity)
	. = ..()
	if(. && augments)
		INVOKE_AUGMENT(src, psi.get_melee_powers(SSpsi.faculties_by_intent[a_intent]), A, FALSE)

/mob/living/RangedAttack(var/atom/A, var/params)
	if(augments)
		INVOKE_AUGMENT(src, psi.get_ranged_powers(SSpsi.faculties_by_intent[a_intent]), A, TRUE)
	. = ..()

/mob/living/attack_empty_hand(var/bp_hand)
	if(augments)
		INVOKE_AUGMENT(src, psi.get_manifestations(), src, FALSE)
	. = ..()

#undef INVOKE_AUGMENT