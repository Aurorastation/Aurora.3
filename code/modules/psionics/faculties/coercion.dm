/datum/psionic_faculty/coercion
	id = PSI_COERCION
	name = "Coercion"
	associated_intent = I_DISARM

/datum/psionic_power/coercion
	faculty = PSI_COERCION

/datum/psionic_power/coercion/invoke(var/mob/living/user, var/mob/living/target)
	if (!istype(target))
		to_chat(user, SPAN_WARNING("You cannot mentally attack \the [target]."))
		return FALSE

	. = ..()

/datum/psionic_power/coercion/blindstrike
	name =           "Blindstrike"
	cost =           8
	cooldown =       120
	use_ranged =     TRUE
	use_melee =      TRUE
	min_rank =       PSI_RANK_GRANDMASTER
	use_description = "Target the eyes on disarm intent and click anywhere to use a radial attack that blinds, deafens and disorients everyone near you."

/datum/psionic_power/coercion/blindstrike/invoke(var/mob/living/user, var/mob/living/target)
	if(user.zone_sel.selecting != BP_EYES)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user] suddenly throws back their head, as though screaming silently!"), SPAN_NOTICE("You strike at all around you with a deafening psionic scream!"))
		for(var/mob/living/M in orange(user.psi.get_rank(PSI_COERCION), user))
			if(M == user)
				continue
			if(prob(60) && iscarbon(M))
				var/mob/living/carbon/C = M
				C.emote("scream")
			to_chat(M, SPAN_DANGER("Your senses are blasted into oblivion by a psionic scream!"))
			M.eye_blind = max(M.eye_blind,3)
			M.ear_deaf = max(M.ear_deaf,6)
			if(!M.isSynthetic())
				M.confused = max(M.confused, rand(3,8))
		return TRUE

/datum/psionic_power/coercion/mindread
	name =            "Read Mind"
	cost =            30
	cooldown =        150 //It should take a good bit to be able to use this again.
	use_melee =       TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Target the head on disarm intent at melee range to attempt to read a victim's surface thoughts."

/datum/psionic_power/coercion/mindread/invoke(var/mob/living/user, var/mob/living/target)
	if(!isliving(target) || !istype(target) || user.zone_sel.selecting != BP_HEAD)
		return FALSE
	. = ..()
	if(!.)
		return

	if(target.stat == DEAD || (target.status_flags & FAKEDEATH) || !target.client)
		to_chat(user, SPAN_WARNING("[target] is in no state for a mind-read."))
		return TRUE

	user.visible_message(SPAN_WARNING("\The [user] touches \the [target]'s temple..."))
	var/question =  sanitize(input(user, "Say something?", "Read Mind", "Penny for your thoughts?") as null|text)
	if(!question || user.incapacitated() || !do_mob(user, target, 20))
		return TRUE
	var/psi_blocked = target.is_psi_blocked()
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return TRUE
	var/started_mindread = world.time
	if(target.has_psi_aug())
		to_chat(user, SPAN_NOTICE("<b>Your psyche links with [target]'s psi-receiver, seeking an answer from their mind's surface: <i>[question]</i></b>"))
		to_chat(target, SPAN_NOTICE("<b>[user]'s psyche links with your psi-receiver, your mind is compelled to answer: <i>[question]</i></b>"))
	else
		to_chat(user, SPAN_NOTICE("<b>You dip your mentality into the surface layer of \the [target]'s mind, seeking an answer: <i>[question]</i></b>"))
		to_chat(target, SPAN_NOTICE("<b>Your mind is compelled to answer: <i>[question]</i></b>"))
	var/answer =  sanitize(input(target, "[question]\nYou have 25 seconds to type a response", "Read Mind") as null|text)
	if(!answer || world.time > started_mindread + 25 SECONDS || user.stat != CONSCIOUS)
		to_chat(user, SPAN_NOTICE("<b>You receive nothing useful from \the [target].</b>"))
		to_chat(target, SPAN_NOTICE("Your mind blanks out momentarily."))
	else
		to_chat(user, SPAN_NOTICE("<b>You skim thoughts from the surface of \the [target]'s mind: <i>[answer]</i></b>"))
	msg_admin_attack("[key_name(user)] read mind of [key_name(target)] with question \"[question]\" and [answer?"got answer \"[answer]\".":"got no answer."]")
	return TRUE

/datum/psionic_power/coercion/agony
	name =          "Agony"
	cost =          8
	cooldown =      50
	use_melee =     TRUE
	min_rank =      PSI_RANK_MASTER
	use_description = "Target the chest or groin on disarm intent to use a melee attack equivalent to a strike from a stun baton."

/datum/psionic_power/coercion/agony/invoke(var/mob/living/user, var/mob/living/target)
	if(!istype(target))
		return FALSE
	if(user.zone_sel.selecting != BP_CHEST && user.zone_sel.selecting != BP_GROIN)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [target] has been struck by \the [user]!"))
		playsound(user.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		target.stun_effect_act(0, 60, user.zone_sel.selecting)
		return TRUE

/datum/psionic_power/coercion/spasm
	name =           "Spasm"
	cost =           15
	cooldown =       100
	use_melee =      TRUE
	use_ranged =     TRUE
	min_rank =       PSI_RANK_MASTER
	use_description = "Target the arms or hands on disarm intent to use a ranged attack that may rip the weapons away from the target."

/datum/psionic_power/coercion/spasm/invoke(var/mob/living/user, var/mob/living/carbon/human/target)
	if(!istype(target))
		return FALSE

	if(!(user.zone_sel.selecting in list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND)))
		return FALSE

	. = ..()

	if(.)
		to_chat(user, SPAN_DANGER("You lash out, stabbing into \the [target] with a lance of psi-power."))
		to_chat(target, SPAN_DANGER("The muscles in your arms cramp horrendously!"))
		if(prob(75))
			target.emote("scream")
		if(prob(75) && target.l_hand && target.l_hand.simulated && target.unEquip(target.l_hand))
			target.visible_message(SPAN_DANGER("\The [target] drops what they were holding as their left hand spasms!"))
		if(prob(75) && target.r_hand && target.r_hand.simulated && target.unEquip(target.r_hand))
			target.visible_message(SPAN_DANGER("\The [target] drops what they were holding as their right hand spasms!"))
		return TRUE

/datum/psionic_power/coercion/mindslave
	name =          "Mindslave"
	cost =          28
	cooldown =      200
	use_grab =      TRUE
	min_rank =      PSI_RANK_PARAMOUNT
	use_description = "Grab a victim, target the eyes, then use the grab on them while on disarm intent, in order to convert them into a loyal mind-slave. The process takes some time, and failure is punished harshly."

/datum/psionic_power/coercion/mindslave/invoke(var/mob/living/user, var/mob/living/target)
	if(!istype(target) || user.zone_sel.selecting != BP_EYES)
		return FALSE
	. = ..()
	if(.)
		if(target.stat == DEAD || (target.status_flags & FAKEDEATH))
			to_chat(user, SPAN_WARNING("\The [target] is dead!"))
			return TRUE
		if(!target.mind || !target.key)
			to_chat(user, SPAN_WARNING("\The [target] is mindless!"))
			return TRUE
		for (var/obj/item/implant/mindshield/I in target)
			if (I.implanted)
				to_chat(user, SPAN_WARNING("\The [target]'s mind is protected from the mindslaving."))
				return TRUE

		user.visible_message(SPAN_DANGER("<i>\The [user] seizes the head of \the [target] in both hands...</i>"))
		to_chat(user, SPAN_WARNING("You plunge your mentality into that of \the [target]..."))
		to_chat(target, SPAN_DANGER("Your mind is invaded by the presence of \the [user]! They are trying to make you a slave!"))
		if(!do_after(user, target.stat == CONSCIOUS ? 80 : 40, target, 0, 1))
			user.psi.backblast(rand(10,25))
			return TRUE
		to_chat(user, SPAN_DANGER("You sear through \the [target]'s neurons, reshaping as you see fit and leaving them subservient to your will!"))
		to_chat(target, SPAN_DANGER("Your defenses have eroded away and \the [user] has made you their mindslave."))
		thralls.add_antagonist(target.mind, TRUE, TRUE, FALSE, TRUE, TRUE)
		return TRUE

/datum/psionic_power/coercion/assay
	name =            "Assay"
	cost =            15
	cooldown =        100
	use_grab =        TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Grab a patient, target the head, then use the grab on them while on disarm intent, in order to perform a deep coercive-redactive probe of their psionic potential."

/datum/psionic_power/coercion/assay/invoke(var/mob/living/user, var/mob/living/target)
	if(user.zone_sel.selecting != BP_HEAD)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_WARNING("\The [user] holds the head of \the [target] in both hands..."))
		to_chat(user, SPAN_NOTICE("You insinuate your mentality into that of \the [target]..."))
		to_chat(target, SPAN_WARNING("Your persona is being probed by the psychic lens of \the [user]."))
		if(!do_after(user, (target.stat == CONSCIOUS ? 50 : 25), target, 0, 1))
			user.psi.backblast(rand(5,10))
			return TRUE
		to_chat(user, SPAN_NOTICE("You retreat from \the [target], holding your new knowledge close."))
		to_chat(target, SPAN_DANGER("Your mental complexus is laid bare to judgement of \the [user]."))
		target.show_psi_assay(user)
		return TRUE

/datum/psionic_power/coercion/focus
	name =          "Focus"
	cost =          10
	cooldown =      80
	use_grab =     TRUE
	min_rank =      PSI_RANK_MASTER
	use_description = "Grab a patient, target the mouth, then use the grab on them while on disarm intent, in order to cure ailments of the mind."

/datum/psionic_power/coercion/focus/invoke(var/mob/living/user, var/mob/living/target)
	if(user.zone_sel.selecting != "mouth")
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_WARNING("\The [user] holds the head of \the [target] in both hands..."))
		to_chat(user, SPAN_NOTICE("You probe \the [target]'s mind for various ailments.."))
		to_chat(target, SPAN_WARNING("Your mind is being cleansed of ailments by \the [user]."))
		if(!do_after(user, (target.stat == CONSCIOUS ? 50 : 25), target, 0, 1))
			user.psi.backblast(rand(5,10))
			return TRUE
		to_chat(user, SPAN_WARNING("You clear \the [target]'s mind of ailments."))
		to_chat(target, SPAN_WARNING("Your mind is cleared of ailments."))

		var/coercion_rank = user.psi.get_rank(PSI_COERCION)
		if(coercion_rank >= PSI_RANK_GRANDMASTER)
			target.AdjustParalysis(-1)
		target.drowsiness = 0
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/M = target
			M.hallucination = max(M.hallucination, 10)
		return TRUE

/datum/psionic_power/coercion/commune
	name =              "Commune"
	cost =              15
	cooldown =          10
	use_melee =         TRUE
	use_ranged =        TRUE
	min_rank =          PSI_RANK_OPERANT
	use_sound =         null
	use_description =   "Target the mouth and click on a creature on disarm intent to psionically send them a message."
	admin_log = FALSE

/datum/psionic_power/coercion/commune/invoke(var/mob/living/user, var/mob/living/target)
	if((target == user) || user.zone_sel.selecting != BP_MOUTH)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_NOTICE("<i>[user] blinks, their eyes briefly developing an unnatural shine.</i>"))
		if(target.stat == DEAD)
			to_chat(user, SPAN_CULT("Not even a psion of your level can speak to the dead."))
			return

		var/text = input("What would you like to say?", "Speak to creature", null, null)
		text = sanitize(text)
		if(!text)
			return
		text = formalize_text(text)

		if(target.stat == DEAD)
			to_chat(user, SPAN_CULT("Not even a psion of your level can speak to the dead."))
			return

		var/psi_blocked = target.is_psi_blocked()
		if(psi_blocked)
			to_chat(user, psi_blocked)
			return

		log_say("[key_name(user)] communed to [key_name(target)]: [text]",ckey=key_name(src))

		to_chat(user, SPAN_CULT("You psionically say to [target]: [text]"))

		for (var/mob/M in player_list)
			if (istype(M, /mob/abstract/new_player))
				continue
			else if(M.stat == DEAD && M.client.prefs.toggles & CHAT_GHOSTEARS)
				to_chat(M, "<span class='notice'>[user] psionically says to [target]:</span> [text]")

		var/mob/living/carbon/human/H = target
		if(H.can_commune() || H.psi)
			to_chat(H, SPAN_CULT("<b>You instinctively sense [user] passing a thought into your mind:</b> [text]"))
		else if(target.has_psi_aug())
			to_chat(H, SPAN_CULT("<b>You sense [user]'s psyche link with your psi-receiver, a thought sliding into your mind:</b> [text]"))
		else
			to_chat(H, SPAN_ALIEN("<b>A thought from outside your consciousness slips into your mind:</b> [text]"))

/datum/psionic_power/coercion/psiping
	name =              "Psi Ping"
	cost =              5
	cooldown =          30
	use_melee =         TRUE
	use_manifest =      TRUE
	min_rank =          PSI_RANK_OPERANT
	use_sound =         null
	use_description =   "Activate an empty hand on help intent to detect nearby psionic signatures."
	admin_log = FALSE

/datum/psionic_power/coercion/psiping/invoke(var/mob/living/user, var/mob/living/target)
	if((target && user != target) || user.a_intent != I_HELP)
		return FALSE
	. = ..()
	if(.)
		to_chat(user, SPAN_NOTICE("You take a moment to tune into the local Nlom..."))
		if(!do_after(user, 3 SECONDS))
			return
		var/list/dirs = list()
		var/turf/our_turf = get_turf(user)
		for(var/mob/living/L in range(20))
			var/turf/T = get_turf(L)
			if(!T || L == user || L.stat == DEAD || L.invisibility == INVISIBILITY_LEVEL_TWO)
				continue
			if(!L.is_psi_pingable())
				continue
			var/image/ping_image = image(icon = 'icons/effects/effects.dmi', icon_state = "sonar_ping", loc = our_turf, layer = OBFUSCATION_LAYER + 0.1)
			pixel_shift_to_turf(ping_image, our_turf, T)
			user << ping_image
			addtimer(CALLBACK(GLOBAL_PROC, /proc/qdel, ping_image), 8)
			var/direction = num2text(get_dir(user, L))
			var/dist
			if(text2num(direction))
				switch(get_dist(user, L) / user.client.view)
					if(0 to 0.2)
						dist = "very close"
					if(0.2 to 0.4)
						dist = "close"
					if(0.4 to 0.6)
						dist = "a little ways away"
					if(0.6 to 0.8)
						dist = "farther away"
					else
						dist = "far away"
			else
				dist = "on top of you"
			LAZYINITLIST(dirs[direction])
			dirs[direction][dist] += 1
		for(var/d in dirs)
			var/list/feedback = list()
			for(var/dst in dirs[d])
				feedback += "[dirs[d][dst]] psionic signature\s [dst],"
			if(feedback.len > 1)
				feedback[feedback.len - 1] += " and"
			to_chat(user, SPAN_NOTICE("You sense " + jointext(feedback, " ") + " towards the [dir2text(text2num(d))]."))
		if(!length(dirs))
			to_chat(user, SPAN_NOTICE("You detect no psionic signatures but your own."))
