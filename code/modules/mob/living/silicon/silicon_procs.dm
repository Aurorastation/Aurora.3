/mob/living/silicon/verb/silicon_mimic_accent()
	set name = "Mimic Accent"
	set category = "Subsystems"

	var/chosen_accent = tgui_input_list(src, "Choose an accent to mimic.", "Accent Mimicry", possible_accents)
	if(!chosen_accent)
		return

	accent = chosen_accent
	to_chat(src, SPAN_NOTICE("You have set your synthesizer to mimic the [chosen_accent] accent."))

/mob/living/silicon/put_in_hands(obj/item/W)
	..(W, TRUE)
