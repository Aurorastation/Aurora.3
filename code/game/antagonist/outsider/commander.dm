var/datum/antagonist/commander/commander

/datum/antagonist/commander
	id = MODE_COMMANDER
	role_text = "Syndicate Commander"
	role_text_plural = "Syndicate Commanders"
	welcome_text = "You are in charge of the syndicate sleeper agents aboard the NSS Aurora. You report directly to the upper echelons of the Syndicate, and their benefactors."
	id_type = /obj/item/card/id/syndicate
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE
	landmark_id = "SyndiCommander"

	faction = "syndicate"

	hard_cap = 1
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

/datum/antagonist/commander/New()
    ..()
    commander = src

/datum/antagonist/commander/equip(mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for (var/obj/item/I in player)
		if (istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/syndicate/officer/commander, FALSE)
	player.equipOutfit(/datum/outfit/admin/syndicate/officer/commander, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

	spawn_uplink(player)

	return TRUE

/datum/antagonist/commander/proc/spawn_uplink(var/mob/living/carbon/human/commander_mob)
	if(!istype(commander_mob))
		return

	var/loc = ""
	var/obj/item/R = locate() //Hide the uplink in a PDA if available, otherwise radio

	if(commander_mob.client.prefs.uplinklocation == "Headset")
		R = locate(/obj/item/device/radio) in commander_mob.contents
		if(!R)
			R = locate(/obj/item/device/pda) in commander_mob.contents
			to_chat(commander_mob, "Could not locate a Radio, installing in PDA instead!")
		if (!R)
			to_chat(commander_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")
	else if(commander_mob.client.prefs.uplinklocation == "PDA")
		R = locate(/obj/item/device/pda) in commander_mob.contents
		if(!R)
			R = locate(/obj/item/device/radio) in commander_mob.contents
			to_chat(commander_mob, "Could not locate a PDA, installing into a Radio instead!")
		if(!R)
			to_chat(commander_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")
	else if(commander_mob.client.prefs.uplinklocation == "None")
		to_chat(commander_mob, "You have elected to not have an AntagCorp portable teleportation relay installed!")
		R = null
	else
		to_chat(commander_mob, "You have not selected a location for your relay in the antagonist options! Defaulting to PDA!")
		R = locate(/obj/item/device/pda) in commander_mob.contents
		if (!R)
			R = locate(/obj/item/device/radio) in commander_mob.contents
			to_chat(commander_mob, "Could not locate a PDA, installing into a Radio instead!")
		if (!R)
			to_chat(commander_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")

	if(!R)
		return

	if(istype(R,/obj/item/device/radio))
		// generate list of radio freqs
		var/obj/item/device/radio/target_radio = R
		var/freq = PUBLIC_LOW_FREQ
		var/list/freqlist = list()
		while (freq <= PUBLIC_HIGH_FREQ)
			if (freq < 1451 || freq > PUB_FREQ)
				freqlist += freq
			freq += 2
			if ((freq % 2) == 0)
				freq += 1
		freq = freqlist[rand(1, freqlist.len)]
		var/obj/item/device/uplink/hidden/T = new(R, commander_mob.mind)
		T.uses = 10
		target_radio.hidden_uplink = T
		target_radio.traitor_frequency = freq
		to_chat(commander_mob, "A portable object teleportation relay has been installed in your [R.name] [loc]. Simply dial the frequency [format_frequency(freq)] to unlock its hidden features.")
		commander_mob.mind.store_memory("<B>Radio Freq:</B> [format_frequency(freq)] ([R.name] [loc]).")

	else if (istype(R, /obj/item/device/pda))
		// generate a passcode if the uplink is hidden in a PDA
		var/pda_pass = "[rand(100,999)] [pick("Alpha","Bravo","Delta","Omega")]"
		var/obj/item/device/uplink/hidden/T = new(R, commander_mob.mind)
		T.uses = 10
		R.hidden_uplink = T
		var/obj/item/device/pda/P = R
		P.lock_code = pda_pass
		to_chat(commander_mob, "A portable object teleportation relay has been installed in your [R.name] [loc]. Simply enter the code \"[pda_pass]\" into the ringtone select to unlock its hidden features.")
		commander_mob.mind.store_memory("<B>Uplink Passcode:</B> [pda_pass] ([R.name] [loc]).")