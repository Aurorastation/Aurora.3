mob/proc/flash_pain()
	flick("pain",pain)

mob/var/list/pain_stored = list()
mob/var/last_pain_message = ""
mob/var/next_pain_time = 0

// partname is the name of a body part
// amount is a num from 1 to 100
/mob/living/carbon/proc/pain(var/partname, var/amount, var/force, var/burning = 0)
	if(stat >= 1)
		return
	if(!can_feel_pain())
		return
	if(analgesic > 40)
		return
	if(world.time < next_pain_time && !force)
		return
	if(amount > 10 && istype(src,/mob/living/carbon/human))
		if(src:paralysis)
			src:paralysis = max(0, src:paralysis-round(amount/10))
	if(amount > 50 && prob(amount / 5))
		src:drop_item()
	var/msg
	if(burning)
		switch(amount)
			if(1 to 10)
				msg = "<span class='danger'>Your [partname] burns.</span>"
			if(11 to 90)
				flash_weak_pain()
				msg = "<span class='danger'><font size=3>Your [partname] burns horribly!</font></span>"
			if(91 to 10000)
				flash_pain()
				msg = "<span class='danger'><font size=4>Your [partname] feels like it's on fire!</font></span>"
	else
		switch(amount)
			if(5 to 14)
				msg = "<b>Your [partname] hurts.</b>"
			if(15 to 90)
				flash_weak_pain()
				msg = "<b><font size=3>Your [partname] hurts badly!</font></b>"
			if(91 to 10000)
				flash_pain()
				msg = "<b><font size=3>Your [partname] is screaming out in pain!</font></b>"
	if(msg && (msg != last_pain_message || prob(10)))
		last_pain_message = msg
		to_chat(src, msg)
	next_pain_time = world.time + 50


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
		if(power >= 70)
			to_chat(src, "<span class='danger'><font size=3>[message]</font></span>")
		else if(power >= 40)
			to_chat(src, "<span class='danger'><font size=2>[message]</font></span>")
		else if(power >= 10)
			to_chat(src, "<span class='danger'>[message]</span>")
		else
			to_chat(src, "<span class='warning'>[message]</span>")

	next_pain_time = world.time + (100-power)

/mob/living/carbon/human/proc/handle_pain()
	// not when sleeping

	if(!can_feel_pain())
		return

	if(stat >= DEAD)
		return
	if(analgesic > 70)
		return

	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs)
		if(E.status & (ORGAN_DEAD|ORGAN_ROBOT)) continue
		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ)
		pain(damaged_organ.name, maxdam, 0)

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/internal/I in internal_organs)
		if(I.status & (ORGAN_DEAD|ORGAN_ROBOT))
			continue
		if(prob(2))
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			var/painmessage
			if(I.is_broken())
				painmessage = "You feel an excrutiating pain in your [parent.name]!"
			else if (I.is_bruised())
				painmessage = "You feel a sharp pain in your [parent.name]..."
			else if (I.is_damaged())
				painmessage = "You feel discomfort in your [parent.name]."
			if(painmessage)
				custom_pain(painmessage, 5, 5)
			//The less hardcoded values, the better.

	var/toxDamageMessage = null
	var/toxMessageProb = 1
	switch(getToxLoss())
		if(1 to 5)
			toxMessageProb = 1
			toxDamageMessage = "Your body stings slightly."
		if(6 to 10)
			toxMessageProb = 2
			toxDamageMessage = "Your whole body hurts a little."
		if(11 to 15)
			toxMessageProb = 2
			toxDamageMessage = "Your whole body hurts."
		if(15 to 25)
			toxMessageProb = 3
			toxDamageMessage = "Your whole body hurts badly!"
		if(26 to INFINITY)
			toxMessageProb = 5
			toxDamageMessage = "Your body aches all over, it's driving you mad!"

	if(toxDamageMessage && prob(toxMessageProb))
		custom_pain(toxDamageMessage, 5, 5)