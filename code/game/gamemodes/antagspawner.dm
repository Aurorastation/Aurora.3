// Helper proc to make sure no more than one active syndieborg exists at a time.
/proc/can_buy_syndieborg()
	for (var/mob/living/silicon/robot/R in silicon_mob_list)
		if (istype(R, /mob/living/silicon/robot/syndicate))
			return 0

	return 1

/obj/item/weapon/antag_spawner
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
	var/used = 0

/obj/item/weapon/antag_spawner/proc/spawn_antag(var/client/C, var/turf/T, var/type = "")
	return

/obj/item/weapon/antag_spawner/proc/equip_antag(mob/target as mob)
	return

/obj/item/weapon/antag_spawner/borg_tele
	name = "Syndicate Cyborg Teleporter"
	desc = "A single-use teleporter used to deploy a Syndicate Cyborg on the field. Due to budget restrictions, it is only possible to deploy a single cyborg at time."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	var/searching = 0
	var/askDelay = 10 * 60 * 1

/obj/item/weapon/antag_spawner/borg_tele/attack_self(mob/user)
	user << "<span class='notice'>The syndicate robot teleporter is attempting to locate an available cyborg.</span>"
	searching = 1
	for(var/mob/dead/observer/O in player_list)
		if(!O.MayRespawn())
			continue
		if(jobban_isbanned(O, "Syndicate") && jobban_isbanned(O, "Mercenary") && jobban_isbanned(O, "Cyborg"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_OPERATIVE)
				question(O.client)
	spawn(600)
		searching = 0
		if(!used)
			user << "<span class='warning'>Unable to connect to the Syndicate Command. Perhaps you could try again later?</span>"


/obj/item/weapon/antag_spawner/borg_tele/proc/question(var/client/C)
	spawn(0)
		if(!C)
			return
		var/response = alert(C, "Someone is requesting a syndicate cyborg  Would you like to play as one?",
		"Syndicate robot request","Yes", "No", "Never for this round")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as a syndicate cyborg?", "Syndicate cyborg request", "Yes", "No")
		if(!C || used || !searching)
			return
		if(response == "Yes")
			spawn_antag(C, get_turf(src))
		else if (response == "Never for this round")
			C.prefs.be_special ^= BE_OPERATIVE

obj/item/weapon/antag_spawner/borg_tele/spawn_antag(client/C, turf/T)
	var/datum/effect/effect/system/spark_spread/S = new /datum/effect/effect/system/spark_spread
	S.set_up(4, 1, src)
	S.start()
	var/mob/living/silicon/robot/H = new /mob/living/silicon/robot/syndicate(T)
	C.prefs.copy_to(H)
	H.key = C.key
	var/newname = sanitizeSafe(input(H,"Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
	if (newname != "")
		H.real_name = newname
		H.name = H.real_name
	H.mind.special_role = "Mercenary"
	H << "<b>You are a syndicate cyborg, bound to help and follow the orders of the mercenaries that are deploying you. Remember to speak to the other mercenaries to know more about their plans, you are also able to change your name using the name pick command.</b>"

	spawn(1)
		used = 1
		qdel(src)
