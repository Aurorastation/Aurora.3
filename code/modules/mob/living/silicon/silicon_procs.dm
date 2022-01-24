/mob/living/silicon/proc/silicon_mimic_accent()
	set name = "Mimic Accent"
	set category = "Subsystems"

	var/chosen_accent = input(src, "Choose an accent to mimic.", "Accent Mimicry") as null|anything in possible_accents
	if(!chosen_accent)
		return

	accent = chosen_accent
	to_chat(src, SPAN_NOTICE("You have set your synthesizer to mimic the [chosen_accent] accent."))

/mob/living/silicon/put_in_hands(obj/item/W)
	..(W, TRUE)