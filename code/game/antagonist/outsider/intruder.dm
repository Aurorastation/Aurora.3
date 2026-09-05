GLOBAL_DATUM(intruders, /datum/antagonist/intruder)

/datum/antagonist/intruder
	id = MODE_INTRUDER
	role_text = "Intruder"
	role_text_plural = "Intruders"
	bantype = "intruder"
	antag_indicator = "synd"
	landmark_id = "intruderspawn"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_SET_APPEARANCE | ANTAG_IMPLANT_IMMUNE | ANTAG_NO_FLAVORTEXT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_RANDSPAWN
	antaghud_indicator = "hudsyndicate"
	required_age = 0 // TESTING - revert to 10 before merging
	hard_cap = 4
	hard_cap_round = 4
	initial_spawn_req = 1
	initial_spawn_target = 1
	faction = "syndicate"
	protected_jobs = list()

/datum/antagonist/intruder/New()
	..()
	GLOB.intruders = src
	welcome_text = "You are an Intruder, deployed to infiltrate and sabotage the [station_name()]. You will pose as a regular crew member, but your true goals are your own. Work with your team if you wish, or pursue your own agenda. Succeed at all costs."

/datum/antagonist/intruder/can_become_antag(var/datum/mind/player)
	if(!..())
		return 0
	// Exclude robots, cyborgs, androids, and other non-human types
	if(istype(player.current, /mob/living/silicon))
		return 0
	return 1

/datum/antagonist/intruder/equip(var/mob/living/carbon/human/intruder_mob)
	if(!..())
		return FALSE

	intruder_mob.faction = "syndicate"

	// preEquipOutfit() alone only strips existing IDs - equipOutfit() actually equips the clothes
	intruder_mob.preEquipOutfit(/obj/outfit/antag/intruder, FALSE)
	intruder_mob.equipOutfit(/obj/outfit/antag/intruder, FALSE)
	intruder_mob.force_update_limbs()
	intruder_mob.update_eyes()
	intruder_mob.regenerate_icons()

	// Give them an uplink hidden in their PDA
	spawn_uplink(intruder_mob)

	return TRUE

/datum/antagonist/intruder/proc/spawn_uplink(var/mob/living/carbon/human/intruder_mob)
	if(!intruder_mob.client)
		return

	var/list/found_pdas = intruder_mob.search_contents_for(/obj/item/modular_computer)
	var/obj/item/modular_computer/pda = found_pdas.len ? found_pdas[1] : null
	var/list/found_radios = intruder_mob.search_contents_for(/obj/item/radio/headset)
	var/obj/item/radio/headset/radio = found_radios.len ? found_radios[1] : null

	var/obj/item/target
	switch(intruder_mob.client.prefs.uplinklocation)
		if("Headset")
			target = radio || pda
		else // "PDA" or unset
			target = pda || radio

	if(!target)
		to_chat(intruder_mob, "<span class='warning'>Could not find a PDA or headset to hide your uplink in!</span>")
		return

	if(istype(target, /obj/item/radio/headset))
		var/obj/item/uplink/hidden/U = new(target, intruder_mob.mind)
		radio.hidden_uplink = U
		var/freq = PUBLIC_LOW_FREQ
		var/list/freqlist = list()
		while(freq <= PUBLIC_HIGH_FREQ)
			if(freq < 1451 || freq > PUB_FREQ)
				freqlist += freq
			freq += 2
			if((freq % 2) == 0)
				freq += 1
		freq = freqlist[rand(1, freqlist.len)]
		radio.traitor_frequency = freq
		intruder_mob.mind.store_memory("<B>Uplink Frequency:</B> [format_frequency(freq)] ([target.name] [target.loc]).")
		to_chat(intruder_mob, "A portable object teleportation relay has been installed in your [target.name] [target.loc]. The secret frequency is [format_frequency(freq)]. Simply enter this frequency into your headset to unlock its hidden features.")
	else
		var/obj/item/uplink/hidden/U = new(target, intruder_mob.mind)
		pda.hidden_uplink = U
		var/pda_pass = "[rand(100,999)] [pick("Alpha","Bravo","Delta","Omega")]"
		to_chat(intruder_mob, "A portable object teleportation relay has been installed in your [target.name] [target.loc]. Simply enter the code \"[pda_pass]\" into the ringtone select to unlock its hidden features.")
		intruder_mob.mind.store_memory("<B>Uplink Passcode:</B> [pda_pass] ([target.name] [target.loc]).")
		U.pda_code = pda_pass

/datum/antagonist/intruder/get_antag_radio()
	return "Infiltrator"
