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
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	mob_type = /mob/living/carbon/human
	ghost_role_id = "technoapprentice"

/obj/item/antag_spawner/technomancer_apprentice/attack_self(var/mob/user)
	if(uses <= 0)
		to_chat(user, SPAN_WARNING("This teleporter is out of charge."))
		return
	to_chat(user, SPAN_NOTICE("The teleporter is now attempting to lock on to your apprentice!"))
	request_player()

/obj/item/antag_spawner/technomancer_apprentice/request_player(mob/user)
	SSghostroles.add_spawn_atom(ghost_role_id, src)

/obj/item/antag_spawner/technomancer_apprentice/Destroy()
	SSghostroles.remove_spawn_atom(ghost_role_id, src)
	return ..()

/obj/item/antag_spawner/technomancer_apprentice/assign_player(var/mob/user)
	var/turf/T = get_turf(src)
	var/mob/living/carbon/human/G = new /mob/living/carbon/human(T)
	G.ckey = user.ckey

	anim(T, G, 'icons/mob/mob.dmi', null,"phasein-blue", null, G.dir)

	G.preEquipOutfit(/datum/outfit/admin/techomancer/apprentice, FALSE)
	G.equipOutfit(/datum/outfit/admin/techomancer/apprentice, FALSE)
	technomancers.add_antagonist(G.mind, FALSE, TRUE, FALSE, FALSE, FALSE)

	qdel(src)

	return G