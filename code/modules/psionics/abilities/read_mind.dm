/singleton/psionic_power/read_mind
	name = "Read Mind"
	desc = "Rip thoughts from someone's mind. This spell has two modes, switched by activating it in hand: for the first, they are required to answer truthfully, \
			and this deals brain damage and confusion; in the second mode, they do not receive the brain damage (only the confusion), but they must willingly accept \
			to have their mind read. Keep in mind that usage of mind reading is extremely illegal, no matter how you do it!"
	icon_state = "tech_illusion"
	spell_path = /obj/item/spell/read_mind
	ability_flags = PSI_FLAG_EVENT|PSI_FLAG_CANON

/obj/item/spell/read_mind
	name = "read mind"
	desc = "Rip thoughts from someone's mind."
	icon_state = "generic"
	cast_methods = CAST_MELEE|CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 50
	var/safe_mode = FALSE

/obj/item/spell/read_mind/on_use_cast(mob/user)
	. = ..(user, TRUE)
	if(!.)
		return
	safe_mode = !safe_mode
	if(safe_mode)
		to_chat(user, SPAN_NOTICE("Your mind reading can now be resisted and will not incur brain damage."))
	else
		to_chat(user, SPAN_NOTICE("Your mind reading can no longer be resisted and will incur brain damage."))

/obj/item/spell/read_mind/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	. = ..()
	if(!.)
		return
	read_mind(hit_atom, user)

/obj/item/spell/read_mind/proc/read_mind(atom/hit_atom, mob/user)
	if(!isliving(hit_atom))
		return

	if(!isliving(user))
		return

	var/mob/living/target = hit_atom
	if(target.stat == DEAD)
		to_chat(user, SPAN_WARNING("Not even a psion of your level can speak to the dead."))
		return

	var/psi_blocked = target.is_psi_blocked()
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return

	user.visible_message(SPAN_WARNING("[user] lays a palm on [hit_atom]'s forehead..."))
	var/question =  sanitize(input(user, "Ask your question.", "Read Mind") as null|text)

	if(!question || user.incapacitated())
		return TRUE

	var/started_mindread = world.time
	if(target.has_psi_aug())
		to_chat(user, SPAN_NOTICE("<b>Your psyche links with [target]'s psi-receiver, seeking an answer from their mind's surface: <i>[question]</i></b>"))
		to_chat(target, SPAN_NOTICE("<b>[user]'s psyche links with your psi-receiver. [safe_mode ? "You may resist, but in case you accept, you must \
				answer truthfully." : "You cannot avoid the question, and must answer truthfully."] <i>[question]</i></b>"))
	else
		to_chat(user, SPAN_NOTICE("<b>You dip your mentality into the surface layer of \the [target]'s mind, seeking an answer: <i>[question]</i></b>"))
		to_chat(target, SPAN_NOTICE("<b>Your mind is compelled to answer. [safe_mode ? "You may avoid the question, but in case you follow it, you must \
				answer truthfully." : "You cannot avoid the question, and must answer truthfully."]: <i>[question]</i></b>"))
	var/answer =  sanitize(input(target, "[question]\n[safe_mode ? "You may avoid the question, but must answer truthfully if you do not." : "You may not resist, \
							and must answer truthfully."]\nYou have 25 seconds to type a response.", "Read Mind") as null|text)
	if(!answer || world.time > started_mindread + 25 SECONDS || user.stat != CONSCIOUS)
		to_chat(user, SPAN_NOTICE("<b>You receive nothing useful from \the [target].</b>"))
		to_chat(target, SPAN_NOTICE("Your mind blanks out momentarily."))
	else
		to_chat(user, SPAN_NOTICE("<b>You skim thoughts from the surface of \the [target]'s mind: <i>[answer]</i></b>"))
	msg_admin_attack("[key_name(user)] read mind of [key_name(target)] with question \"[question]\" and [answer?"got answer \"[answer]\".":"got no answer."]")
	if(safe_mode)
		target.confused += 15
		to_chat(target, SPAN_WARNING("You feel somewhat nauseated..."))
	else
		target.adjustBrainLoss(20)
		target.confused += 20
		to_chat(target, SPAN_DANGER("Your head feels like it's going to explode, and you feel nauseated..."))
