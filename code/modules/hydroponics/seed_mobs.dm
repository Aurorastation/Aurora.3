// The following procs are used to grab players for mobs produced by a seed (mostly for dionaea).
/datum/seed/proc/handle_living_product(var/mob/living/host)
	if(!host || !istype(host))
		return

	SSghostroles.add_spawn_atom("living_plant", host)
	addtimer(CALLBACK(src, .proc/kill_living_product, host), 1 MINUTE)

/datum/seed/proc/kill_living_product(var/mob/living/product)
	if(!product.ckey && !product.client)
		SSghostroles.remove_spawn_atom("living_plant", product)
		product.death() // This seems redundant, but a lot of mobs don't
		product.stat = DEAD // handle death() properly. Better safe than etc.
		product.visible_message(SPAN_DANGER("\The [product] is malformed and unable to survive. It expires pitifully, leaving behind some seeds."))

		var/total_yield = rand(1,3)
		for(var/j = 0; j <= total_yield; j++)
			var/obj/item/seeds/S = new(get_turf(product))
			S.seed_type = name
			S.update_seed()