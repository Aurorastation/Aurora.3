// Helper proc to make sure no more than one active syndieborg exists at a time.
/proc/can_buy_syndieborg()
	for (var/mob/living/silicon/robot/R in silicon_mob_list)
		if (istype(R, /mob/living/silicon/robot/syndicate))
			return 0

	return 1

/obj/item/antag_spawner
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
	var/uses = 1

/obj/item/antag_spawner/proc/equip_antag(mob/target as mob)
	return

/obj/item/antag_spawner/borg_tele
	name = "syndicate cyborg teleporter"
	desc = "A single-use teleporter used to deploy a Syndicate Cyborg on the field. Due to budget restrictions, it is only possible to deploy a single cyborg at time."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"

/obj/item/antag_spawner/borg_tele/attack_self(mob/user)

	if(uses == 0)
		to_chat(usr, "This teleporter is out of uses.")
		return

	to_chat(user, "<span class='notice'>The syndicate robot teleporter is attempting to locate an available cyborg.</span>")
	var/datum/ghosttrap/ghost = get_ghost_trap("syndicate cyborg")
	uses--

	var/mob/living/silicon/robot/syndicate/F = new(get_turf(usr))
	spark(F, 4, alldirs)
	ghost.request_player(F,"An operative is requesting a syndicate cyborg.", 60 SECONDS)
	F.faction = usr.faction
	spawn(600)
		if(F)
			if(!F.ckey || !F.client)
				F.visible_message("With no working brain to keep \the [F] working, it is teleported back.")
				qdel(F)
				uses++
