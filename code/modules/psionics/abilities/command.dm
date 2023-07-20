/singleton/psionic_power/command
	name = "Command"
	desc = "Send a psionic command to a target. It must be one word. The suggestion ends when they finish the task, when a minute passes or \
			when they take notable damage."
	icon_state = "wiz_blink"
	spell_path = /obj/item/spell/command
	ability_flags = PSI_FLAG_EVENT

/obj/item/spell/command
	name = "commune"
	desc = "Send a psionic command to a target."
	icon_state = "apportation"
	cast_methods = CAST_RANGED|CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 50

/obj/item/spell/command/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	. = ..()
	if(!.)
		return
	command(hit_atom, user)

/obj/item/spell/command/on_ranged_cast(atom/hit_atom, mob/user)
	. = ..()
	if(!.)
		return
	command(hit_atom, user)

/obj/item/spell/command/proc/command(atom/hit_atom, mob/user)
	if(!isliving(hit_atom))
		return

	if(!isliving(user))
		return

	var/mob/living/L = user
	var/multi_word = L.psi.get_rank() > PSI_RANK_HARMONIOUS

	var/mob/living/target = hit_atom
	if(target.stat == DEAD)
		to_chat(user, SPAN_WARNING("Not even a psion of your level can speak to the dead."))
		return

	var/psi_blocked = target.is_psi_blocked()
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return

	user.visible_message(SPAN_CULT("[user] opens a palm and aims it at [hit_atom]..."))
	var/text = input("Enter your command. [multi_word ? "This command may be up to 5 words." : "This command may only be one word."]", "Command", null, null)
	if(!text)
		return
	text = formalize_text(text)

	if(target.stat == DEAD)
		to_chat(user, SPAN_WARNING("Not even a psion of your level can speak to the dead."))
		return

	log_say("[key_name(user)] issued a [multi_word ? "multi-word" : "single-word"] command to [key_name(target)]: [text]",ckey=key_name(src))

	to_chat(user, SPAN_CULT("You psionically command to [target]: [text]"))

	for (var/mob/M in player_list)
		if (istype(M, /mob/abstract/new_player))
			continue
		else if(M.stat == DEAD && M.client.prefs.toggles & CHAT_GHOSTEARS)
			to_chat(M, "<span class='notice'>[user] psionically commands to [target]:</span> [text]")

	var/mob/living/carbon/human/H = target
	if(H.can_commune() || H.psi)
		to_chat(H, SPAN_CULT("<b>You are psionically commanded to carry out the following task:</b> [text]."))
	else if(target.has_psi_aug())
		to_chat(H, SPAN_CULT("<b>You sense [user]'s psyche link with your psi-receiver, a command sliding into your mind:</b> [text]"))
	else
		to_chat(H, SPAN_CULT("<b>A thought from outside your consciousness slips into your mind:</b> [text]"))
	to_chat(H, SPAN_DANGER("You are required to follow this command. It ends when a minute has passed, when you carry it out, or when you take a significant amount \
							of damage. [multi_word ? "You are required to follow up to five words." : "You are required to only follow the first word of the command."]"))
