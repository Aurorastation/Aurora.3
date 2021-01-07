// The following procs are used to grab players for mobs produced by a seed (mostly for dionaea).
/datum/seed/proc/handle_living_product(var/mob/living/host)

	if(!host || !istype(host)) return

	if(host.is_diona() == DIONA_NYMPH)
		var/datum/ghosttrap/nymph/N = get_ghost_trap("living nymph")
		N.request_player(host, "Someone is harvesting \a [display_name].", 1 MINUTE)
	else
		var/datum/ghosttrap/plant/P = get_ghost_trap("living plant")
		P.request_player(host, "Someone is harvesting \a [display_name].", 1 MINUTE)

	addtimer(CALLBACK(src, .proc/check_spawn_filled, host), 1 MINUTE)

/datum/seed/proc/check_spawn_filled(var/mob/living/host)
	if(!host.ckey && !host.client)
		host.death()  // This seems redundant, but a lot of mobs don't
		host.stat = DEAD // handle death() properly. Better safe than etc.
		host.visible_message("<span class='danger'>[host] is malformed and unable to survive. It expires pitifully, leaving behind some seeds.</span>")

		var/total_yield = rand(1, 3)
		for(var/j = 0; j <= total_yield; j++)
			var/obj/item/seeds/S = new(get_turf(host))
			S.seed_type = name
			S.update_seed()
