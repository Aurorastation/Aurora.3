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
	if(uses <= 0)
		to_chat(user, SPAN_WARNING("This teleporter is out of uses."))
		return

	uses--

	var/mob/living/silicon/robot/syndicate/F = new /mob/living/silicon/robot/syndicate(get_turf(user))
	if(user?.mind.special_role)
		var/datum/antagonist/user_antag = all_antag_types[lowertext(user.mind.special_role)]
		if(user_antag)
			F.assigned_antagonist = user_antag
	F.faction = user.faction
	F.say("Initiating boot-up sequence!")
	spark(F, 4, alldirs)
	SSghostroles.add_spawn_atom("syndiborg", F)
	var/area/A = get_area(src)
	if(A)
		say_dead_direct("A syndicate cyborg has started its boot process in [A.name]! Spawn in as it by using the ghost spawner menu in the ghost tab, and try to be good!")