/singleton/psionic_power/commune
	name = "Commune"
	desc = "Psionically commune with the target."
	icon_state = "tech_audibledeception"
	point_cost = 0
	ability_flags = PSI_FLAG_FOUNDATIONAL
	spell_path = /obj/item/spell/commune

/obj/item/spell/commune
	name = "commune"
	desc = "Déjà-vu."
	icon_state = "overload"
	cast_methods = CAST_RANGED|CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 15

/obj/item/spell/commune/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	. = ..()
	if(!.)
		return
	commune(hit_atom, user)

/obj/item/spell/commune/on_ranged_cast(atom/hit_atom, mob/user)
	. = ..()
	if(!.)
		return
	commune(hit_atom, user)

/obj/item/spell/commune/proc/commune(atom/hit_atom, mob/user)
	if(!isliving(hit_atom))
		return

	var/mob/living/target = hit_atom
	if(target.stat == DEAD)
		to_chat(user, SPAN_WARNING("Not even a psion of your level can speak to the dead."))
		return

	var/psi_blocked = target.is_psi_blocked(user)
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return

	user.visible_message(SPAN_NOTICE("<i>[user] blinks, their eyes briefly developing an unnatural shine.</i>"))
	var/text = tgui_input_text(user, "What would you like to say?", "Commune", "", MAX_MESSAGE_LEN, TRUE)
	text = sanitize(text)
	if(!text)
		return
	text = formalize_text(text)

	if(target.stat == DEAD)
		to_chat(user, SPAN_WARNING("Not even a psion of your level can speak to the dead."))
		return

	log_say("[key_name(user)] communed to [key_name(target)]: [text]")

	to_chat(user, SPAN_CULT("You psionically say to [target]: [text]"))

	for (var/mob/M in GLOB.player_list)
		if (istype(M, /mob/abstract/new_player))
			continue
		else if(M.stat == DEAD && M.client.prefs.toggles & CHAT_GHOSTEARS)
			to_chat(M, "<span class='notice'>[user] psionically says to [target]:</span> [text]")

	var/mob/living/carbon/human/H = target
	if(H.has_psionics())
		to_chat(H, SPAN_CULT("<b>You instinctively sense [user] passing a thought into your mind:</b> [text]"))
	else if(target.has_psi_aug())
		to_chat(H, SPAN_CULT("<b>You sense [user]'s psyche link with your psi-receiver, a thought sliding into your mind:</b> [text]"))
	else
		to_chat(H, SPAN_ALIEN("<b>A thought from outside your consciousness slips into your mind:</b> [text]"))
