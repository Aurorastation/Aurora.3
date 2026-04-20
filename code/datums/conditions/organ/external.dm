/datum/condition/organ/broken_spine
	name = "Broken Spine"
	desc = "AAAAAAUUUUUUUGHHHHHHHH"
	traits = list(TRAIT_BROKEN_SPINE)
	apply_sound = 'sound/effects/conditions/broken_spine.ogg'
	max_condition_amount = 1

/datum/condition/organ/broken_spine/on_apply()
	..()
	organ.owner?.visible_message(SPAN_CONDITION("[organ]'s spine breaks in half!"), SPAN_CONDITION("Your spine breaks in half!"))
