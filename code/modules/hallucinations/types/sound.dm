/datum/hallucination/sound
	max_power = 40
	special_flags = HEARING_DEPENDENT
	var/list/sounds = list('sound/weapons/smash.ogg',
			'sound/weapons/flash_ring.ogg',
			'sound/effects/Explosion1.ogg',
			'sound/effects/Explosion2.ogg',
			'sound/effects/explosionfar.ogg',
			'sound/effects/crusher_alarm.ogg',
			'sound/effects/smoke.ogg')

/datum/hallucination/sound/start()
	sound_to(holder, pick(sounds))


/datum/hallucination/sound/echo
	duration = 50	//This delays end() by 5 seconds, where we have a chance of playing another sound from this list.
	max_power = HAL_POWER_HIGH
	sounds = list('sound/machines/airlock.ogg',
			'sound/voice/shriek1.ogg',
			'sound/misc/nymphchirp.ogg',
			'sound/machines/twobeep.ogg',
			'sound/machines/windowdoor.ogg',
			'sound/effects/glass_break1.ogg',
			'sound/weapons/railgun.ogg',
			'sound/effects/phasein.ogg',
			'sound/effects/sparks1.ogg',
			'sound/effects/sparks2.ogg',
			'sound/effects/sparks3.ogg',
			'sound/effects/stealthoff.ogg',
			'sound/misc/zapsplat/chitter1.ogg',
			'sound/misc/zapsplat/chitter2.ogg',
			'sound/effects/squelch1.ogg',
			'sound/items/Ratchet.ogg',
			'sound/items/Welder.ogg',
			'sound/items/Crowbar.ogg',
			'sound/items/Screwdriver.ogg',
			'sound/items/drill_use.ogg',
			'sound/items/air_wrench.ogg')

/datum/hallucination/sound/echo/end()
	if(prob(holder.hallucination / 2))
		sound_to(holder, pick(sounds))
	..()

/datum/hallucination/sound/creepy
	min_power = HAL_POWER_MED
	max_power = INFINITY
	special_flags = null	//These are spooky enough to happen even when deaf
	sounds = list('sound/effects/ghost.ogg',
				'sound/effects/ghost2.ogg',
				'sound/effects/screech.ogg',
				'sound/effects/creepyshriek.ogg',
				'sound/hallucinations/behind_you1.ogg',
				'sound/hallucinations/behind_you2.ogg',
				'sound/hallucinations/far_noise.ogg',
				'sound/hallucinations/growl1.ogg',
				'sound/hallucinations/growl2.ogg',
				'sound/hallucinations/growl3.ogg',
				'sound/hallucinations/im_here1.ogg',
				'sound/hallucinations/im_here2.ogg',
				'sound/hallucinations/i_see_you1.ogg',
				'sound/hallucinations/i_see_you2.ogg',
				'sound/hallucinations/look_up1.ogg',
				'sound/hallucinations/look_up2.ogg',
				'sound/hallucinations/over_here1.ogg',
				'sound/hallucinations/over_here2.ogg',
				'sound/hallucinations/over_here3.ogg',
				'sound/hallucinations/turn_around1.ogg',
				'sound/hallucinations/turn_around2.ogg',
				'sound/hallucinations/veryfar_noise.ogg',
				'sound/hallucinations/wail.ogg')

/datum/hallucination/sound/reaction
	min_power = 20
	max_power = INFINITY
	special_flags = null

/datum/hallucination/sound/reaction/start()
	switch(rand(1,3))
		if(1) //Nearmiss
			sound_to(holder, 'sound/weapons/gunshot/gunshot_light.ogg')
			to_chat(holder, SPAN_DANGER("Something zips by your head, barely missing you!")) //phantom reflex to audio
			shake_camera(holder, 3, 1)

		if(2) //Gunshot
			sound_to(holder, 'sound/weapons/gunshot/gunshot1.ogg')
			if(ishuman(holder))
				var/mob/living/carbon/human/H = holder
				var/obj/item/organ/external/O = pick(H.organs)
				O.add_pain(15)
				to_chat(holder, SPAN_DANGER("You feel a sharp pain in your [O.name]!")) //phantom pain reaction to audio
			else
				holder.adjustHalLoss(15)
				to_chat(holder, SPAN_DANGER("You feel a sharp pain in your chest!"))
			shake_camera(holder, 3, 1)
			if(prob(holder.hallucination))
				holder.eye_blurry += 8

		if(3) //Don't tase me bro
			sound_to(holder, 'sound/weapons/Taser.ogg')
			to_chat(holder, SPAN_DANGER("You feel numb as a shock courses through your body!")) //phantom pain reaction to audio
			holder.adjustHalLoss(20)
			if(prob(holder.hallucination))
				holder.eye_blind += 4