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
	item_icons = null
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
	if(!isliving(hit_atom) || !isliving(user))
		return

	var/mob/living/target = hit_atom
	if(target.stat == DEAD)
		to_chat(user, SPAN_WARNING("Not even a psion of your level can speak to the dead."))
		return

	var/psi_blocked = target.is_psi_blocked(user, FALSE)
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return

	var/safe_mode = FALSE
	var/target_sensitivity = target.check_psi_sensitivity()
	// Safe mode triggers if the caster's psi-sensitivity isn't 2 or more points greater than the receiver's sensitivity.
	if(user.check_psi_sensitivity() - target_sensitivity < PSI_RANK_HARMONIOUS)
		safe_mode = TRUE

	user.visible_message(SPAN_WARNING("[user] lays a palm on [hit_atom]'s forehead..."))
	var/question
	if(!safe_mode)
		question = tgui_input_text(user, "Ask your question.", "Read Mind", timeout = 25 SECONDS)
	if((!safe_mode && !question) || user.incapacitated())
		return TRUE

	to_chat(user, SPAN_NOTICE(\
		target_sensitivity >= PSI_RANK_SENSITIVE \
			? "<b>Your consciousness mingles with [target]'s thoughts, imploring them to share an answer: <i>[question]</i></b>"\
			: "<b>You dip your mentality into the surface layer of \the [target]'s mind, seeking an answer: <i>[question]</i></b>"))
	to_chat(target, SPAN_NOTICE("<b>Your mind is compelled to answer.</b>" \
		+ safe_mode \
			/* If the target wins the psi-sensitivity check, they're prompted to say whatever they want.*/\
			? "<b>What are you thinking about, currently?</b>" \
			/* And if the caster wins, the target is forced to answer a specific question.*/\
			: "<b>You cannot avoid the following question, and must answer truthfully: </b>" \
			+ "<b><i>[question]</i></b>"))

	// Attempt to get an answer from the target.
	var/answer =  tgui_input_text(\
		target,\
		"[question]\n"\
			+ safe_mode \
				? "You must answer with what you are currently thinking about.\n" \
				: "You must answer truthfully.\n"\
			+ "You have 25 seconds to type a response.", \
		"Read Mind", \
		timeout = 25 SECONDS)

	// Exit early if the target failed to answer.
	if(!answer || user.stat != CONSCIOUS)
		to_chat(user, SPAN_NOTICE("<b>You receive nothing useful from \the [target].</b>"))
		to_chat(target, SPAN_NOTICE("Your mind blanks out momentarily."))
		return

	if (target_sensitivity < 0)
		// Negative sensitivity (of target) case. Underdeveloped Zona Bovinae return a scrambled message.
		var/scrambled_message = stars(answer, (abs(target_sensitivity) * 25))
		to_chat(user, SPAN_NOTICE("<b>You tease a half-formed thought from [target]'s mind: <i>[scrambled_message]</i></b>"))
		to_chat(target, SPAN_NOTICE("<b>Your answer to [user] arrives vaguely as: <i>[scrambled_message]<i></b>"))
	else if(safe_mode)
		to_chat(user, SPAN_NOTICE("<b>You skim the first thoughts in [target]'s mind: <i>[answer]</i></b>"))
		to_chat(target, SPAN_NOTICE("<b>you answer [user] with: <i>[answer]</i></b>"))
	else
		to_chat(user, SPAN_NOTICE("<b>You pry the answer to your question from [target]'s mind: <i>[answer]</i></b>"))
		to_chat(target, SPAN_NOTICE("<b>You are compelled to answer [user] with: <i>[answer]</i></b>"))

	msg_admin_attack("[key_name(user)] read mind of [key_name(target)] " \
		+ safe_mode \
			? "skimming their surface thoughts " \
			: "forcing them to answer truthfully with question: \"[question]\" " \
		+ "and " \
		+ answer \
			? "got answer: \"[answer]\"." \
			: "got no answer.")

	// We take the logistic curve of the psi_sensitivity in order to create a double asymptote that confines the effects without requiring truncating to 0, or setting a maximum.
	// Maximums occur at +/- infinity. While normal values roughly around 0.5x occur very close to +/- 1.
	// "More sensitivity" reduces negative effects of the power.
	// "Less sensitivity" increases said negative effects.
	var/psi_sensitivity_ratio = ftanh(0.5 * target_sensitivity) * 20

	// Minimum of confusion time 0 seconds, maximum of 40 seconds. 20 seconds for an unaugmented human.
	// See: https://www.desmos.com/calculator/dl8zapsnsn
	target.confused += 20 SECONDS - (psi_sensitivity_ratio) SECONDS

	// Minimum brain damage of 0, maximum of 20%. 10% for a unaugmented human.
	// See: https://www.desmos.com/calculator/hqm4w7bgr4
	target.adjustBrainLoss(20 - (psi_sensitivity_ratio))

	to_chat(target, \
		target_sensitivity >= PSI_RANK_SENSITIVE \
			/* Case for high-sensitivity.*/\
			? SPAN_NOTICE("Your mind reels as it resists a blast of psychic pressure.")\
			: target_sensitivity >= 0 \
			/* Case for standard-human psi-sensitivity.*/\
			? SPAN_DANGER("Your head feels like it's going to explode, and you feel nauseated...")\
			/* Case for low-sensitivity.*/\
			: SPAN_DANGER("You black out briefly, awakening to a world that inexplicably smells like burnt toast."))
