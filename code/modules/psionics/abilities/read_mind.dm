/singleton/psionic_power/read_mind
	name = "Read Mind"
	desc = "Rip thoughts from someone's mind. If your rank is Psionically Sensitive, you may only skim the surface thoughts from a person's mind. \
			If your rank is Psionically Harmonious or above, your target is forced to respond to a five-word question with the truth."
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

	var/psi_blocked = target.is_psi_blocked(user)
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return

	var/safe_mode = FALSE
	var/mob/living/L = user
	if(L.psi.get_rank() < PSI_RANK_HARMONIOUS)
		safe_mode = TRUE

	user.visible_message(SPAN_WARNING("[user] lays a palm on [hit_atom]'s forehead..."))
	var/question
	if(!safe_mode)
		question = sanitize(input(user, "Ask your question.", "Read Mind") as null|text)
	if((!safe_mode && !question) || user.incapacitated())
		return TRUE

	var/started_mindread = world.time
	if(target.has_psi_aug())
		to_chat(user, SPAN_NOTICE("<b>Your psyche links with [target]'s psi-receiver, seeking [safe_mode ? "their surface thoughts." : "an answer from their mind's surface: <i>[question]</i>"]</b>"))
		to_chat(target, SPAN_NOTICE("<b>[user]'s psyche links with your psi-receiver. [safe_mode ? "What are you thinking about, currently?" : "You cannot avoid the following question, and must answer truthfully: <i>[question]</i>"]</b>"))
	else
		to_chat(user, SPAN_NOTICE("<b>You dip your mentality into the surface layer of \the [target]'s mind, seeking an answer: <i>[question]</i></b>"))
		to_chat(target, SPAN_NOTICE("<b>Your mind is compelled to answer. [safe_mode ? "What are you thinking about, currently?" : "You cannot avoid the following question, and must answer truthfully: <i>[question]</i>"]</b>"))
	var/answer =  sanitize(input(target, "[question]\n[safe_mode ? "You must answer with what you are currently thinking about." : "You must answer truthfully."]\nYou have 25 seconds to type a response.", "Read Mind") as null|text)
	if(!answer || world.time > started_mindread + 25 SECONDS || user.stat != CONSCIOUS)
		to_chat(user, SPAN_NOTICE("<b>You receive nothing useful from \the [target].</b>"))
		to_chat(target, SPAN_NOTICE("Your mind blanks out momentarily."))
	else
		if(safe_mode)
			to_chat(user, SPAN_NOTICE("<b>You skim the first thoughts in [target]'s mind: <i>[answer]</i></b>"))
		else
			to_chat(user, SPAN_NOTICE("<b>You pry the answer to your question from [target]'s mind: <i>[answer]</i></b>"))
	msg_admin_attack("[key_name(user)] read mind of [key_name(target)] [safe_mode ? "skimming their surface thoughts" : "forcing them to answer truthfully with question \"[question]\""]  and [answer?"got answer \"[answer]\".":"got no answer."]")
	if(safe_mode)
		target.confused += 15
		target.adjustBrainLoss(10)
		to_chat(target, SPAN_WARNING("You feel somewhat nauseated, and a headache's come up too..."))
	else
		target.adjustBrainLoss(20)
		target.confused += 20
		to_chat(target, SPAN_DANGER("Your head feels like it's going to explode, and you feel nauseated..."))
