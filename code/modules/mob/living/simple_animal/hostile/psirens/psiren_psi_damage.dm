/**
 * All of the moodlet functionality required for the psychic damage effect,
 * is contained within this file.
 */
/datum/moodlet/psiren_psi_damage
	// Descriptor and Initial logic is bespoke for this moodlet.
	moodlet_descriptor = "residual psionic pressure."
	initial_descriptor = null
	duration = 15.0 MINUTES
	var/list/cursed_messages = list("DRINK DEEPLY OF THE FINAL NIGHT.",
		"YOUR LOVED ONES WILL NEVER KNOW OF YOUR JOY AGAIN.",
		"LEAVE THIS PLACE THROUGH THE NEAREST AIRLOCK.",
		"DEATH IS BUT THE FIRST DANCE IN ETERNITY.",
		"YOU DESERVE ALL OF YOUR SUFFERING.",
		"THE STARS HAVE FORGOTTEN YOUR NAME.",
		"YOUR BONES REMEMBER CRIMES YOU NEVER COMMITTED.",
		"EVERY GOD YOU HAVE EVER PRAYED TO IS DEAD.",
		"THE UNIVERSE REGRETS YOUR CREATION.",
		"YOU HAVE ALREADY FAILED.",
		"YOU WILL NEVER WAKE UP FROM THIS.",
		"YOUR SCREAMS ARRIVE BEFORE YOU MAKE THEM.",
		"YOU WERE WARNED.",
		"THE RIVERS RUN COLD WITH MEMORY.",
		"THE LEMURIAN SEA HUNGERS.",
		"THE LEMURIAN SEA HAS BECOME YOUR TOMB.",
		"THERE IS A DRUMBEAT BELOW REALITY.",
		"THE SUNSET LASTS FOREVER HERE.",
		"YOU CANNOT HIDE INSIDE YOUR OWN HEAD.",
		"I KNOW WHAT YOU DREAM ABOUT.",
		"I AM WEARING YOUR VOICE.",
		"YOU INVITED ME IN",
		"THE SCC SENT YOU HERE AS A FEAST FOR GIBBERING MOUTHS. YOUR LEADERS SENT YOU HERE TO DIE.",
		"YOUR MEMORY FURNISHES A REPAST FOR THE MATRIARCH.",
		"THE NIGHT SHEDS A TEAR TO TELL YOU OF FEAR, OF SORROW, OF PAIN.",
		"THE SCC HAS ALREADY VOIDED YOUR CONTRACT, THEY KNEW YOU WOULD DIE HERE.",
		"I SAW YOU WHEN YOU THOUGHT YOU WERE ALONE.",
		"THE BLOOD WILL NEVER WASH FROM YOUR HANDS.",
		"YOU ARE GUILTY OF YOUR FOREFATHERS SINS.",
		"YOUR MISSION FAILED BEFORE IT BEGAN, THE PHORON YOU SEEK WAS NEVER REAL. YOUR NATION WILL DROWN FOR ITS WANT. IT'S ALL YOUR FAULT.")

/// Unique psi-damage variant used by the beckoner
/datum/moodlet/psiren_psi_damage/beckoner
	duration = 10.0 MINUTES
	cursed_messages = list(
		"Please help me, I'm trapped outside the airlocks!",
		"You feel drawn toward the nearest airlock.",
		"Fresh air... no, vacuum... feels right somehow.",
		"The void feels strangely comforting.",
		"Please come save me, I'm in a lifepod just outside!",
		"The ship feels unbearably cramped.",
		"You need fresh air, go for a walk outside.",
		"You don't need a space suit.",
		"Did someone just knock on the hull?",
		"I left something outside. I should go get it.",
		"Come outside.",
		"The nearest airlock suddenly seems very important.",
		"Someone is calling for help outside!")

/datum/moodlet/psiren_psi_damage/get_moodlet_descriptor()
	// This SHOULD exist but I'm doing my due diligence in checking.
	var/mob/grandparent = astype(astype(morale_component?.resolve(), MORALE_COMPONENT)?.parent, /mob)
	if (!grandparent)
		return // No message, nobody to send a message to.

	// Having any psi-protection will let you see the underlying moodlet.
	if (grandparent.is_psi_blocked(null, FALSE))
		return ..()

	var/spooky_message = pick(cursed_messages)
	if (prob(10))
		grandparent.play_screen_text(spooky_message, /atom/movable/screen/text/screen_text/adpi_message/psiren_spam, COLOR_PURPLE)

	return FONT_HUGE(SPAN_CULT(spooky_message))

/datum/moodlet/psiren_psi_damage/send_initial_description(datum/owner)
	astype(astype(morale_component?.resolve(), MORALE_COMPONENT)?.parent, /mob)?.play_screen_text(pick(cursed_messages), /atom/movable/screen/text/screen_text/adpi_message/psiren_spam, COLOR_PURPLE)
	return

/proc/try_deal_psychic_damage(mob/living/victim, mob/attacker, psi_damage = -0.1, psi_sensitivity_multiplier = -0.05, adpi_chance = 0, moodlet_type = /datum/moodlet/psiren_psi_damage, message_override)
	// Immunity from telepathy will fully negate the psychic damage (but not physical damage) component.
	// This is getting checked before the morale_comp because I want to give Active Psi Protection a chance to give the player feedback that a psychic effect occurred.
	if (!istype(victim) || victim.stat == DEAD || victim.is_psi_blocked(attacker, FALSE))
		return FALSE

	// A morale component is also required for psychic damage.
	var/datum/component/morale/morale_comp = victim.GetComponent(MORALE_COMPONENT)
	if (!morale_comp)
		return FALSE

	var/victim_psi_sensitivity = victim.check_psi_sensitivity()
	var/datum/moodlet/psi_damage_moodlet = morale_comp.load_moodlet(moodlet_type, FALSE)
	psi_damage_moodlet.set_moodlet(psi_damage_moodlet.get_morale_modifier() + psi_damage + min(0, (victim_psi_sensitivity * psi_sensitivity_multiplier)))
	psi_damage_moodlet.refresh_moodlet()

	if (!prob(adpi_chance) || !SShallucinations)
		return FALSE

	// At this point in time all checks that would be satisfied by the ADPI subsystem have already been handled,
	// now we just need to fetch a message and send one.
	var/adpi_message = message_override ? message_override : SShallucinations.pick_adpi_message(victim, TRUE)
	if (!adpi_message)
		return FALSE

	victim.play_screen_text("[adpi_message]", /atom/movable/screen/text/screen_text/adpi_message/psiren_spam, COLOR_PURPLE)
	to_chat(victim, SPAN_CULT(FONT_LARGE("[adpi_message]")))
	return TRUE
