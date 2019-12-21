/obj/item/grenade/spawnergrenade
	desc = "It is set to detonate in 5 seconds. It will unleash unleash an unspecified anomaly into the vicinity."
	name = "delivery grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "delivery"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4)
	var/flash = TRUE // this var handles whether we blind people when we explode
	var/banglet = 0
	var/spawner_type = null // must be an object path
	var/deliveryamt = 1 // amount of type to deliver
	var/list/newvars

/obj/item/grenade/spawnergrenade/prime()	// Prime now just handles the two loops that query for people in lockers and people who can see it.

	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)
		if (flash)
			for(var/mob/living/carbon/human/M in viewers(T, null))
				if(M.eyecheck(TRUE) < FLASH_PROTECTION_MODERATE)
					flick("e_flash", M.flash)
		else
			spark(T, 3, alldirs) //give spawning some flair if there's no flash

		for(var/i=1, i<=deliveryamt, i++)
			var/atom/movable/x = new spawner_type
			if(newvars && length(newvars))
				for(var/v in newvars)
					x.vars[v] = newvars[v]
			x.forceMove(T)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(x, pick(NORTH,SOUTH,EAST,WEST))

			// Spawn some hostile syndicate critters

	qdel(src)
	return

/obj/item/grenade/spawnergrenade/manhacks
	name = "manhack delivery grenade"
	desc = "It is set to detonate in 5 seconds. It will unleash a swarm of deadly manhack robots that will attack everyone but you and your allies."
	spawner_type = /mob/living/simple_animal/hostile/viscerator
	deliveryamt = 5 //Five seems a bit much, but we'll keep it as-is.
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)
	flash = FALSE

/obj/item/grenade/spawnergrenade/spesscarp
	name = "carp delivery grenade"
	spawner_type = /mob/living/simple_animal/hostile/carp
	deliveryamt = 5
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)

/obj/item/grenade/spawnergrenade/singularity
	name = "singularity grenade"
	spawner_type = /obj/singularity

/obj/item/grenade/spawnergrenade/singularity/toy
	spawner_type = /obj/item/toy/spinningtoy
	fake = TRUE

/obj/item/grenade/spawnergrenade/fake_carp
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 5)
	spawner_type = /mob/living/simple_animal/hostile/carp/holodeck
	deliveryamt = 4
	fake = TRUE
	newvars = list("faction" = null, "melee_damage_lower" = 0, "melee_damage_upper" = 0, "environment_smash" = 0, "destroy_surroundings" = 0)
