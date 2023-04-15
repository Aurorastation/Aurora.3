// Helper proc to make sure no more than one active syndieborg exists at a time.
/proc/can_buy_syndieborg()
	for (var/mob/living/silicon/robot/R in silicon_mob_list)
		if (istype(R, /mob/living/silicon/robot/combat))
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

/obj/item/antag_spawner/combat_robot
	name = "combat robot teleporter"
	desc = "A single-use teleporter used to deploy a Combat Robot on the field. Due to budget restrictions, it is only possible to deploy a single robot."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	mob_type = /mob/living/silicon/robot/combat
	ghost_role_id = "combatrobot"

/obj/item/antag_spawner/combat_robot/equip_antag(mob/target, mob/user)
	. = ..()
	var/mob/living/silicon/robot/combat/S = target
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
	var/outfit_type = /datum/outfit/admin/techomancer/apprentice
	var/preserve_appearance = FALSE

/obj/item/antag_spawner/technomancer_apprentice/attack_self(var/mob/user)
	if(uses <= 0)
		to_chat(user, SPAN_WARNING("This teleporter is out of charge."))
		return
	to_chat(user, SPAN_NOTICE("The teleporter is now attempting to lock on to your apprentice!"))
	request_player()

/obj/item/antag_spawner/technomancer_apprentice/request_player(mob/user)
	uses = 0
	SSghostroles.add_spawn_atom(ghost_role_id, src)

/obj/item/antag_spawner/technomancer_apprentice/Destroy()
	SSghostroles.remove_spawn_atom(ghost_role_id, src)
	return ..()

/obj/item/antag_spawner/technomancer_apprentice/assign_player(var/mob/user)
	var/turf/T = get_turf(src)
	var/mob/living/carbon/human/G = new mob_type(T)
	G.ckey = user.ckey

	anim(T, G, 'icons/mob/mob.dmi', null,"phasein-blue", null, G.dir)

	G.preEquipOutfit(outfit_type, FALSE)
	G.equipOutfit(outfit_type, FALSE)
	technomancers.add_antagonist(G.mind, FALSE, TRUE, FALSE, FALSE, preserve_appearance)

	qdel(src)

	return G

/obj/item/antag_spawner/technomancer_apprentice/golem
	name = "golem teleporter"
	desc = "A teleportation device, which will bring a powerful synthetic helper to you."
	mob_type = /mob/living/carbon/human/technomancer_golem
	ghost_role_id = "technogolem"
	outfit_type = /datum/outfit/admin/techomancer/golem
	preserve_appearance = TRUE