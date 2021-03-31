/decl/nanomachine_effect/nanomachines_son
	name = "Nanomachines, Son"
	desc = "Become the greatest Prime Minister the Solarian Alliance has ever seen."

	var/nanomachine_son_say_rate = 10 SECONDS

/decl/nanomachine_effect/nanomachines_son/do_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	H.rejuvenate()
	if(LAZYACCESS(parent.program_last_trigger, type) < world.time - nanomachine_son_say_rate)
		LAZYSET(parent.program_last_trigger, type, world.time)
		parent.speak_to_owner("Nanomachines, son.")