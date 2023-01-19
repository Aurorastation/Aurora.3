/mob/proc/flash_pain(var/target)
	if(pain)
		animate(pain, alpha = target, time = 15, easing = ELASTIC_EASING)
		animate(pain, alpha = 0, time = 20)

mob/var/last_pain_message = ""
mob/var/next_pain_time = 0

// message is the custom message to be displayed
// power decides how much painkillers will stop the message
// force means it ignores anti-spam timer
/mob/living/carbon/proc/custom_pain(var/message, var/power, var/force, var/obj/item/organ/external/affecting, var/nohalloss)
	if(!message || stat || !can_feel_pain() || chem_effects[CE_PAINKILLER] > power)
		return 0

	power -= chem_effects[CE_PAINKILLER]/2	//Take the edge off.

	// Excessive halloss is horrible, just give them enough to make it visible.
	if(!nohalloss && power)
		if(!affecting)
			adjustHalLoss(Ceiling(power/2))
		else
			affecting.add_pain(Ceiling(power/2))

	flash_pain(min(round(2*power)+55, 255))

	// Anti message spam checks
	if(force || (message != last_pain_message) || (world.time >= next_pain_time))
		last_pain_message = message
		if(power >= 110)
			flash_strong_pain()
			to_chat(src, "<span class='danger'><font size=3>[message]</font></span>")
		else if(power >= 70)
			to_chat(src, "<span class='danger'><font size=3>[message]</font></span>")
		else if(power >= 40)
			to_chat(src, "<span class='danger'><font size=2>[message]</font></span>")
		else if(power >= 10)
			to_chat(src, "<span class='danger'>[message]</span>")
		else
			to_chat(src, "<span class='warning'>[message]</span>")

		var/force_emote = species.get_pain_emote(src, power)
		if(force_emote && prob(power))
			var/singleton/emote/use_emote = usable_emotes[force_emote]
			if(!(use_emote.message_type == AUDIBLE_MESSAGE && silent))
				emote(force_emote)

	next_pain_time = world.time + 5 SECONDS

/mob/living/carbon/human/proc/handle_pain()
	if(stat >= DEAD)
		return
	if(!can_feel_pain())
		return
	if(world.time < next_pain_time)
		return

	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs)
		if(E.status & (ORGAN_DEAD|ORGAN_ROBOT))
			continue
		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ && chem_effects[CE_PAINKILLER] < maxdam)
		if(maxdam > 10 && paralysis)
			paralysis = max(0, paralysis - round(maxdam / 10))
		if(maxdam > 50 && prob(maxdam / 5))
			to_chat(src, SPAN_WARNING("A bolt of pain shoots through your body, causing your hands to spasm!"))
			drop_item()
		var/burning = damaged_organ.burn_dam > damaged_organ.brute_dam
		var/msg
		switch(maxdam)
			if(1 to 10)
				msg = "[burning ? species.organ_low_burn_message : species.organ_low_pain_message]"
			if(11 to 60)
				msg = "[burning ? species.organ_med_burn_message : species.organ_med_pain_message]"
			if(70 to 10000)
				msg = "[burning ? species.organ_high_burn_message : species.organ_high_pain_message]"
		msg = replacetext(msg, "%PARTNAME%", damaged_organ.name)
		custom_pain(msg, maxdam, prob(30), damaged_organ, TRUE)

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/internal/I in internal_organs)
		if(prob(1) && !((I.status & ORGAN_DEAD) || BP_IS_ROBOTIC(I)) && I.damage > 5)
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			var/pain = 10
			var/message = I.unknown_pain_location ? "You feel a dull pain in your [parent.name]..." : "You feel a dull pain radiating from your [I.name]..."
			if(I.is_bruised())
				pain = 25
				message = I.unknown_pain_location ? "You feel a stinging pain in your [parent.name]." : "You feel a stinging pain radiating from your [I.name]."
			if(I.is_broken())
				pain = 50
				message = I.unknown_pain_location ? "You feel a sharp pain in your [parent.name]!" : "You feel a sharp pain radiating from your [I.name]!"
			src.custom_pain(message, pain, affecting = parent)

	if(prob(1))
		switch(getToxLoss())
			if(5 to 17)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(17 to 35)
				custom_pain("Your body stings.", getToxLoss())
			if(35 to 60)
				custom_pain("Your body stings strongly.", getToxLoss())
			if(60 to 100)
				custom_pain("Your whole body hurts badly!", getToxLoss())
			if(100 to INFINITY)
				custom_pain("Your body aches all over, it's driving you mad!", getToxLoss())
