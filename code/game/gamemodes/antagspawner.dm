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
	name = "syndicate cyborg teleporter"
	desc = "A single-use teleporter used to deploy a Syndicate Cyborg on the field. Due to budget restrictions, it is only possible to deploy a single cyborg at time."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	var/searching = 0
	var/askDelay = 10 * 60 * 1

/obj/item/weapon/antag_spawner/borg_tele/attack_self(mob/user as mob)
	if(searching == 0)
		//Start the process of searching for a new user.
		user << "<span class='notice'>You carefully locate the manual activation switch and start the positronic brain's boot process.</span>"
		src.searching = 1
		var/datum/ghosttrap/G = get_ghost_trap("syndicate cyborg")
		G.request_player(brainmob, "Someone is requesting a syndicate cyborg.", 60 SECONDS)
		spawn_antag(G, get_turf(src))
		spawn(600) reset_search()

obj/item/weapon/antag_spawner/borg_tele/spawn_antag(client/G, turf/T)
	var/datum/effect/effect/system/spark_spread/S = new /datum/effect/effect/system/spark_spread
	S.set_up(4, 1, src)
	S.start()
	var/mob/living/silicon/robot/H = new /mob/living/silicon/robot/syndicate(T)
	H.key = G.key
	var/newname = sanitizeSafe(input(H,"Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
	if (newname != "")
		H.real_name = newname
		H.name = H.real_name
	H.mind.special_role = "Mercenary"
	H << "<b>You are a syndicate cyborg, bound to help and follow the orders of the mercenaries that are deploying you. Remember to speak to the other mercenaries to know more about their plans, you are also able to change your name using the name pick command.</b>"

	spawn(1)
		used = 1
		qdel(src)
