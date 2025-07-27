/singleton/psionic_power/emotional_suggestion
	name = "Emotional Suggestion"
	desc = "Allows you to psionically commune with the target."
	icon_state = "tech_gambit"
	ability_flags = PSI_FLAG_EVENT|PSI_FLAG_CANON
	spell_path = /obj/item/spell/emotional_suggestion

/obj/item/spell/emotional_suggestion
	name = "emotional suggestion"
	desc = "Suggest an emotion to someone."
	icon_state = "generic"
	cast_methods = CAST_RANGED|CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 15

/obj/item/spell/emotional_suggestion/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	. = ..()
	if(!.)
		return
	emotional_suggestion(hit_atom, user)

/obj/item/spell/emotional_suggestion/on_ranged_cast(atom/hit_atom, mob/user)
	. = ..()
	if(!.)
		return
	emotional_suggestion(hit_atom, user)

/obj/item/spell/emotional_suggestion/proc/emotional_suggestion(atom/hit_atom, mob/user)
	if(!isliving(hit_atom))
		return

	var/mob/living/target = hit_atom
	if(target.stat == DEAD)
		to_chat(user, SPAN_WARNING("Not even a psion of your level can suggest to the dead."))
		return

	var/psi_blocked = target.is_psi_blocked(user)
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return

	user.visible_message(SPAN_NOTICE("<i>[user] blinks, their eyes briefly developing an unnatural shine.</i>"))
	var/text = tgui_input_list(user, "Which emotion would you like to suggest?", "Emotional Suggestion", list("Calm", "Happiness", "Sadness", "Fear", "Anger", "Stress", "Confusion"))
	if(!text)
		return

	text = lowertext(text)

	if(target.stat == DEAD)
		to_chat(user, SPAN_WARNING("Not even a psion of your level can suggest to the dead."))
		return

	log_say("[key_name(user)] suggested an emotion to [key_name(target)]: [text]")

	to_chat(user, SPAN_CULT("You psionically suggest an emotion to [target]: [text]"))

	for (var/mob/M in GLOB.player_list)
		if (istype(M, /mob/abstract/new_player))
			continue
		else if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTEARS))
			to_chat(M, "<span class='notice'>[user] psionically suggests an emotion to [target]:</span> [text]")

	var/mob/living/carbon/human/H = target
	if(H.has_psionics())
		to_chat(H, SPAN_NOTICE("You feel an emotion of <b>[text]</b> washing through your mind."))
	else if(target.has_psi_aug())
		to_chat(H, SPAN_NOTICE("You sense [user]'s psyche link with your psi-receiver, and an emotion envelops your mind: <b>[text]</b>."))
	else
		to_chat(H, SPAN_NOTICE("An emotion from outside your consciousness slips into your mind: <b>[text]</b>."))
