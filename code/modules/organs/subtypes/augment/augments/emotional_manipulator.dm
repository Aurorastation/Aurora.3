/obj/item/organ/internal/augment/emotional_manipulator
	name = "emotional manipulator"
	desc = "A Zeng Hu brain implant to manipulate the brain's chemicals to induce a calming or happy feeling. " \
		+ "This is one of the most popular implants across the company."
	icon_state = "emotional_manipulator"
	organ_tag = BP_AUG_EMOTION
	parent_organ = BP_HEAD
	action_button_name = "Activate Emotional Manipulator"
	activable = TRUE
	action_button_icon = "emotional_manipulator"
	cooldown = 10
	var/set_emotion = "Disabled"
	var/last_emotion = 0

	var/list/possible_emotions = list(
		"Disabled",
		"Happiness",
		"Calmness",
	)

/obj/item/organ/internal/augment/emotional_manipulator/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	var/choice = input(
		"Select the Emotional Choice.",
		"Emotional Manipulator"
	) as null|anything in capitalize_list(possible_emotions)

	set_emotion = lowertext(choice)

/obj/item/organ/internal/augment/emotional_manipulator/process()
	..()

	if(!owner)
		return

	if(world.time > (last_emotion + 5 MINUTES))
		switch(set_emotion)
			if("happiness")
				to_chat(owner, SPAN_GOOD("You feel happy."))
			if("calmness")
				to_chat(owner, SPAN_GOOD("You feel calm."))
		last_emotion = world.time

		if(is_broken())
			do_broken_act()

/obj/item/organ/internal/augment/emotional_manipulator/do_broken_act()
	if(owner)
		owner.hallucination += 20
	return TRUE
