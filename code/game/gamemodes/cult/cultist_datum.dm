/datum/cultist
	var/list/memorized_runes

/datum/cultist/proc/memorize_rune()
	set name = "Memorize Rune"
	set desc = "Stand atop a rune and memorize it, allowing you to draw it without your tome."
	set category = "Cultist"

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("Your form is too simple to memorize runes!"))
		return

	if(usr.stat || usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You are in no shape to do this."))
		return

	var/datum/cultist/C = usr.mind.antag_datums[MODE_CULTIST]

	if(LAZYLEN(C.memorized_runes) >= 3)
		to_chat(usr, SPAN_WARNING("You can only memorize up to three runes!"))
		return

	var/mob/living/carbon/human/H = usr
	var/obj/effect/rune/R = locate() in get_turf(H)
	if(R)
		if(!R.rune.can_memorize())
			to_chat(H, SPAN_WARNING("This rune is too complex to be memorized!"))
			return
		if(LAZYISIN(C.memorized_runes, R.rune.name))
			to_chat(H, SPAN_WARNING("This rune is already memorized!"))
			return
		H.visible_message("<b>[H]</b> bends over and runs their hands across \the [src].", SPAN_NOTICE("You bend over and run your hands across the patterns of the rune, slowly memorizing it."))
		if(!do_after(H, 10 SECONDS, TRUE))
			return
		LAZYSET(C.memorized_runes, R.rune.name, R.rune.type)
		to_chat(H, SPAN_NOTICE("You memorize the [R.rune.name]! You will now be able to scribe it at will."))
	else
		to_chat(H, SPAN_WARNING("There was no rune beneath you to memorize."))

/datum/cultist/proc/forget_rune()
	set name = "Forget Rune"
	set desc = "Cleanse the knowledge of a rune from your memory, freeing up space for another."
	set category = "Cultist"

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("Your form is too simple to memorize runes!"))
		return

	if(usr.stat || usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You are in no shape to do this."))
		return

	var/datum/cultist/C = usr.mind.antag_datums[MODE_CULTIST]

	if(!LAZYLEN(C.memorized_runes))
		to_chat(usr, SPAN_WARNING("You have no runes memorized!"))
		return

	var/chosen_rune = input("Choose a rune to forget.") as null|anything in C.memorized_runes
	if(!chosen_rune)
		return
	LAZYREMOVE(C.memorized_runes, chosen_rune)

/datum/cultist/proc/scribe_rune()
	set name = "Scribe Rune"
	set desc = "Scribe a rune that you have memorized."
	set category = "Cultist"

	if(!ishuman(usr))
		to_chat(usr, SPAN_WARNING("Your form is too simple to memorize runes!"))
		return

	var/datum/cultist/C = usr.mind.antag_datums[MODE_CULTIST]

	if(!LAZYLEN(C.memorized_runes))
		to_chat(usr, SPAN_WARNING("You have no runes memorized!"))
		return

	if(usr.stat || usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You are in no shape to do this."))
		return

	var/chosen_rune = input("Choose a rune to scribe.") as null|anything in C.memorized_runes
	if(!chosen_rune)
		return

	var/mob/living/carbon/human/H = usr
	H.visible_message(SPAN_CULT("Blood flows out from \the [H]'s hands, taking shape beneath them..."))
	H.drip(4)

	if(do_after(H, 15 SECONDS))
		create_rune(H, chosen_rune)

/proc/create_rune(var/mob/living/carbon/human/scribe, var/chosen_rune)
	if(scribe.stat || scribe.incapacitated())
		to_chat(scribe, SPAN_WARNING("You are in no shape to do this."))
		return

	var/area/A = get_area(scribe)
	//prevents using multiple dialogs to layer runes.
	if(locate(/obj/effect/rune) in get_turf(scribe)) //This is check is done twice. once when choosing to scribe a rune, once here
		to_chat(scribe, SPAN_WARNING("There is already a rune in this location."))
		return

	log_and_message_admins("created \an [chosen_rune] at \the [A.name] - [scribe.loc.x]-[scribe.loc.y]-[scribe.loc.z].") //only message if it's actually made

	var/obj/effect/rune/R = new(get_turf(scribe), SScult.runes_by_name[chosen_rune])
	to_chat(scribe, SPAN_CULT("You finish drawing the Geometer's markings."))
	var/datum/rune/actual_rune = R.rune
	if(actual_rune.max_number_allowed)
		var/runes_allowed = SScult.limited_runes[actual_rune.type]
		if(runes_allowed <= 0)
			to_chat(scribe, SPAN_CULT("You can't draw any more of this rune!"))
		else
			to_chat(scribe, SPAN_CULT("You can only draw [runes_allowed] more of this rune."))
	R.blood_DNA = list()
	R.blood_DNA[scribe.dna.unique_enzymes] = scribe.dna.b_type
	R.color = scribe.species.blood_color
	R.filters = filter(type="drop_shadow", x = 1, y = 1, size = 4, color = scribe.species.blood_color)