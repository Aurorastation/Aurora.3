/datum/condition/human/broken_spine
	name = "Broken Spine"
	desc = "AAAAAAUUUUUUUGHHHHHHHH"
	traits = list(TRAIT_BROKEN_SPINE)
	apply_sound = 'sound/effects/conditions/broken_spine.ogg'
	max_condition_amount = 1

/datum/condition/human/broken_spine/on_apply()
	..()
	to_chat(parent, FONT_LARGE(SPAN_DANGER("You feel your spine crack and break!")))
	human.visible_message(SPAN_CONDITION("Your spine breaks in half!"), SPAN_CONDITION("[human]'s spine breaks in half!"))
