/singleton/psionic_power/commune
	name = "Commune"
	desc = "Psionically commune with the target. Use on an adjacent object to store a mental image for sending. Use in hand with a mental image to warp and add to its description, or clear a warped one."
	icon_state = "tech_audibledeception"
	point_cost = 0
	ability_flags = PSI_FLAG_FOUNDATIONAL
	spell_path = /obj/item/spell/commune

/obj/item/spell/commune
	name = "commune"
	desc = "Déjà-vu."
	icon_state = "overload"
	item_icons = null
	cast_methods = CAST_RANGED|CAST_MELEE|CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 15
//For shared/remote-examine Communes, similar to Show-Held-Object
	var/object
	var/note //desc
	var/image //chat icon
	var/warpdesc //Custom text added right after normal note desc

/obj/item/spell/commune/Destroy()
	object = null
	return ..()

/obj/item/spell/commune/on_use_cast(mob/user)
	. = ..()
	if(warpdesc)
		warpdesc = null
		to_chat(user, SPAN_NOTICE("You rein back to your initial mental image of \the [object], clearing the warped additions."))
	else if(warpdesc == null && (object))
		warpdesc = tgui_input_text(user, "How would you warp the mental image of \the [object]? This will only add to its existing description, never override or delete.", "Warp Mental Image", "", MAX_MESSAGE_LEN, TRUE)
		if(!warpdesc)
			warpdesc = null
			return
		to_chat(user, SPAN_NOTICE("You rethink your mental image of \the [object], warping in additions to its details."))
	else return

/obj/item/spell/commune/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	. = ..()
	if(!.)
		return
	if(object)
		to_chat(user, SPAN_NOTICE("You already have a mental image in mind of \the [object]."))
		return
	else if(isobj(hit_atom) && !object)
		object = "[hit_atom.name]" //Save a snapshot of its info so they don't auto-update.
		note = ("[hit_atom.desc]" + " [hit_atom.desc_feedback]")
		image = icon2html(hit_atom, user)
		to_chat(user, SPAN_NOTICE("You note and refine a mental image of \the [object] for sending."))

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

	var/psi_blocked = target.is_psi_blocked(user, FALSE)
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return

//Checks psi-sensitivity for remote item examines, because normal Commune gets blocked
	if(object)
		to_chat(user, SPAN_CULT("You psionically project to [target]: [image] [object]\n[note]" + " [warpdesc]"))
		var/mob/living/carbon/human/T = target
		var/target_sensitivity = T.check_psi_sensitivity()
		if(target_sensitivity >= 1) //Small detail, psions can subtly tell apart warped descriptions easier with the new line.
			to_chat(T, SPAN_NOTICE("<i>[user] blinks, their eyes briefly developing an unnatural shine.</i>"))
			to_chat(T, SPAN_CULT("What must be [user]'s mental image of \a [image] [object] appears in your mind.\n[note]\n[warpdesc]"))
		else if(target_sensitivity >= 0) //Info span so it feels like an actual examine at a glance
			to_chat(T, SPAN_INFO("<b>A mental image of \a [image] [object] suddenly builds in your mind.</b>\n[note]" + " [warpdesc]"))
		else //60% chance low-targets don't even get the icon. 35% (per point) of the object's name is scrambled, but base desc can still clue the item
			var/scrmbldobject = stars(object, (abs(target_sensitivity) * 35))
			var/scrmbldnote = stars(note, (abs(target_sensitivity) * 25))
			var/scrmbldwarp = stars(warpdesc, (abs(target_sensitivity) * 45)) //Warped descriptions are even more abnormal, so extra scrambled
			to_chat(T, SPAN_ALIEN("<b>A mental image of \a [prob(40)?"[image] ":""][scrmbldobject] attempts to form in your mind.</b>\n[scrmbldnote]" + " [scrmbldwarp]"))

		log_say("[key_name(user)] communed to [key_name(target)]: [image] [object]\n[note]" + " [warpdesc]")

		for(var/mob/M as anything in GLOB.player_list)
			if(M.stat == DEAD && M.client.prefs.toggles & CHAT_GHOSTEARS)
				to_chat(M, "<span class='notice'>[user] psionically says to [target]:</span> [image] [object]\n[note]" + " [warpdesc]")
		return
	var/text = tgui_input_text(user, "What would you like to say?", "Commune", "", MAX_MESSAGE_LEN, TRUE)
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
	var/target_sensitivity = H.check_psi_sensitivity()
	if(target_sensitivity >= 1)
		// Augmented case for anyone with enhancements to their psi-sensitivity.
		to_chat(H, SPAN_NOTICE("<i>[user] blinks, their eyes briefly developing an unnatural shine.</i>"))
		to_chat(H, SPAN_CULT("<b>You instinctively sense [user] passing a thought into your mind:</b> [text]"))
	else if (target_sensitivity >= 0)
		// Standard case for most characters.
		to_chat(H, SPAN_ALIEN("<b>A thought from outside your consciousness slips into your mind:</b> [text]"))
	else
		// Negative sensitivity case, message arrives scrambled.
		// 25% of the message is scrambled per negative point of psi-sensitivity. Allowing fractional points.
		var/scrambled_message = stars(text, (abs(target_sensitivity) * 25))
		to_chat(H, SPAN_ALIEN("<b>A half-formed thought passes through your mind:</b> [scrambled_message]"))
