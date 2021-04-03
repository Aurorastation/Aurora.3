// Helper proc to make sure no more than one active syndieborg exists at a time.
/proc/can_buy_syndieborg()
	for (var/mob/living/silicon/robot/R in silicon_mob_list)
		if (istype(R, /mob/living/silicon/robot/syndicate))
			return 0

	return 1

/obj/item/antag_spawner
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_TINY
	var/uses = 1
	var/mob_type
	var/ghost_role_id

/obj/item/antag_spawner/attack_self(mob/user)
	if(uses <= 0)
		to_chat(user, SPAN_WARNING("This teleporter is out of uses."))
		return
	request_player(user)

/obj/item/antag_spawner/proc/equip_antag(mob/target, mob/user)
	return

/obj/item/antag_spawner/proc/request_player(var/mob/user)
	uses--

	var/mob/M = new mob_type(get_turf(user))
	M.faction = user.faction
	spark(M, 4, alldirs)
	SSghostroles.add_spawn_atom(ghost_role_id, M)
	equip_antag(M, user)
	return M

/obj/item/antag_spawner/borg_tele
	name = "syndicate cyborg teleporter"
	desc = "A single-use teleporter used to deploy a Syndicate Cyborg on the field. Due to budget restrictions, it is only possible to deploy a single cyborg at time."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	mob_type = /mob/living/silicon/robot/syndicate
	ghost_role_id = "syndiborg"

/obj/item/antag_spawner/borg_tele/equip_antag(mob/target, mob/user)
	. = ..()
	var/mob/living/silicon/robot/syndicate/S = target
	if(user?.mind.special_role)
		var/datum/antagonist/user_antag = all_antag_types[lowertext(user.mind.special_role)]
		if(user_antag)
			S.assigned_antagonist = user_antag
	S.say("Initiating boot-up sequence!")

/obj/item/antag_spawner/technomancer_apprentice
	name = "apprentice teleporter"
	desc = "A teleportation device, which will bring a less potent manipulator of space to you."
	icon = 'icons/obj/objects.dmi'
	icon_state = "locator"
	mob_type = /mob/living/carbon/human
	ghost_role_id = "technoapprentice"

/obj/item/antag_spawner/technomancer_apprentice/attack_self(var/mob/user)
	if(uses <= 0)
		to_chat(user, SPAN_WARNING("This teleporter is out of charge."))
	to_chat(user, SPAN_NOTICE("The teleporter is now attempting to lock on to your apprentice!"))
	request_player()
/*
/obj/item/antag_spawner/technomancer_apprentice/equip_antag(var/mob/M) TODOMATT: this should go on the ghost spawner
	var/mob/living/carbon/human/H = M
	C.prefs.copy_to(H)
	H.key = C.key

	to_chat(H, "<b>You are the Technomancer's apprentice! Your goal is to assist them in their mission at the [station_name()].</b>")
	to_chat(H, "<b>Your service has not gone unrewarded, however. Studying under them, you have learned how to use a Manipulation Core \
	of your own.  You also have a catalog, to purchase your own functions and equipment as you see fit.</b>")
	to_chat(H, "<b>It would be wise to speak to your master, and learn what their plans are for today.</b>")

	spawn(1)
		technomancers.add_antagonist(H.mind, 0, 1, 0, 0, 0)
		equip_antag(H)
		used = 1
		qdel(src)

/obj/item/antag_spawner/technomancer_apprentice/equip_antag(mob/technomancer_mob)
	var/datum/antagonist/technomancer/antag_datum = all_antag_types[MODE_TECHNOMANCER]
	antag_datum.equip_apprentice(technomancer_mob)*/