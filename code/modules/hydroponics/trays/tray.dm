/obj/machinery/portable_atmospherics/hydroponics
	name = "hydroponics tray"
	desc = "A mechanical basin designed to nurture plants and other aquatic life. It has various useful sensors."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "hydrotray3"
	density = 1
	anchored = 1
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 100

	var/mechanical = 1         // Set to 0 to stop it from drawing the alert lights.
	var/base_name = "tray"

	// Plant maintenance vars.
	var/waterlevel = 100       // Water (max 100)
	var/nutrilevel = 10        // Nutrient (max 10)
	var/pestlevel = 0          // Pests (max 10)
	var/weedlevel = 0          // Weeds (max 10)

	var/maxWaterLevel = 100
	var/maxNutriLevel = 10
	var/maxPestLevel = 10
	var/maxWeedLevel = 0 // Hydroponics systems don't grow weeds irl. Pests are still an issue.

	// Tray state vars.
	var/dead = 0               // Is it dead?
	var/harvest = 0            // Is it ready to harvest?
	var/age = 0                // Current plant age
	var/sampled = 0            // Have we taken a sample?
	var/last_biolum			   // What was the bioluminescence last tick?

	// Harvest/mutation mods.
	var/yield_mod = 0          // Modifier to yield
	var/mutation_mod = 0       // Modifier to mutation chance
	var/toxins = 0             // Toxicity in the tray?
	var/mutation_level = 0     // When it hits 100, the plant mutates.
	var/tray_light = 5         // Supplied lighting.

	// Mechanical concerns.
	var/health = 0             // Plant health.
	var/lastproduce = 0        // Last time tray was harvested
	var/lastcycle = 0          // Cycle timing/tracking var.
	var/cycledelay = 150       // Delay per cycle.
	var/closed_system          // If set, the tray will attempt to take atmos from a pipe.
	var/force_update           // Set this to bypass the cycle time check.
	var/obj/temp_chem_holder   // Something to hold reagents during process_reagents()
	var/labelled

	// Seed details/line data.
	var/datum/seed/seed = null // The currently planted seed

	// Reagent information for process(), consider moving this to a controller along
	// with cycle information under 'mechanical concerns' at some point.
	var/global/list/toxic_reagents = list(
		/singleton/reagent/dylovene =			 -2,
		/singleton/reagent/toxin =				  2,
		/singleton/reagent/hydrazine =			2.5,
		/singleton/reagent/acetone =			  1,
		/singleton/reagent/acid =				1.5,
		/singleton/reagent/acid/hydrochloric =	1.5,
		/singleton/reagent/acid/polyacid =		  3,
		/singleton/reagent/toxin/plantbgone =	  3,
		/singleton/reagent/cryoxadone =			 -3,
		/singleton/reagent/radium =				  2,
		/singleton/reagent/drugs/raskara_dust =		2.5
		)
	var/global/list/nutrient_reagents = list(
		/singleton/reagent/drink/milk =				 0.1,
		/singleton/reagent/alcohol/beer =	0.25,
		/singleton/reagent/phosphorus =				 0.1,
		/singleton/reagent/sugar =					 0.1,
		/singleton/reagent/drink/sodawater =		 0.1,
		/singleton/reagent/ammonia =				   1,
		/singleton/reagent/diethylamine =			   2,
		/singleton/reagent/nutriment =				   1,
		/singleton/reagent/adminordrazine =			   1,
		// Fertilizers
		/singleton/reagent/toxin/fertilizer/eznutrient =			1,
		/singleton/reagent/toxin/fertilizer/robustharvest =			1,
		/singleton/reagent/toxin/fertilizer/left4zed =				1,
		/singleton/reagent/toxin/fertilizer/monoammoniumphosphate =	1
		)
	var/global/list/weedkiller_reagents = list(
		/singleton/reagent/hydrazine =			-4,
		/singleton/reagent/phosphorus =			-2,
		/singleton/reagent/sugar =				 2,
		/singleton/reagent/acid =				-2,
		/singleton/reagent/acid/hydrochloric =	-2,
		/singleton/reagent/acid/polyacid =		-4,
		/singleton/reagent/toxin/plantbgone =	-8,
		/singleton/reagent/adminordrazine =		-5
		)
	var/global/list/pestkiller_reagents = list(
		/singleton/reagent/sugar =           2,
		/singleton/reagent/diethylamine =   -2,
		/singleton/reagent/adminordrazine = -5
		)
	var/global/list/water_reagents = list(
		/singleton/reagent/water =					  1,
		/singleton/reagent/adminordrazine =			  1,
		/singleton/reagent/drink/milk =				0.9,
		/singleton/reagent/alcohol/beer =	0.7,
		/singleton/reagent/hydrazine =				 -2,
		/singleton/reagent/phosphorus =			   -0.5,
		/singleton/reagent/water =					  1,
		/singleton/reagent/drink/sodawater =		  1
		)

	// Beneficial reagents also have values for modifying yield_mod and mut_mod (in that order).
	var/global/list/beneficial_reagents = list(
		/singleton/reagent/alcohol/beer=list( -0.05, 0,   0  ),
		/singleton/reagent/hydrazine =			list( -2,    0,   0  ),
		/singleton/reagent/phosphorus =			list( -0.75, 0,   0  ),
		/singleton/reagent/drink/sodawater =	list(  0.1,  0,   0  ),
		/singleton/reagent/acid =		  		list( -1,    0,   0  ),
		/singleton/reagent/acid/hydrochloric =	list( -1,    0,   0  ),
		/singleton/reagent/acid/polyacid =		list( -2,    0,   0  ),
		/singleton/reagent/toxin/plantbgone =	list( -2,    0,   0.2),
		/singleton/reagent/cryoxadone =	 		list(  3,    0,   0  ),
		/singleton/reagent/ammonia =			list(  0.5,  0,   0  ),
		/singleton/reagent/diethylamine =		list(  1,    0,   0  ),
		/singleton/reagent/nutriment =			list(  0.5,  0.1, 0  ),
		/singleton/reagent/radium =				list( -1.5,  0,   0.2),
		/singleton/reagent/adminordrazine =		list(  1,    1,   1  ),
		// Fertilizers
		/singleton/reagent/toxin/fertilizer/robustharvest =	list(  0,	0.2, 0  ),
		/singleton/reagent/toxin/fertilizer/left4zed =		list(  0,	0,   0.2)
		)

	// Mutagen list specifies minimum value for the mutation to take place, rather
	// than a bound as the lists above specify.
	var/global/list/mutagenic_reagents = list(
		/singleton/reagent/radium =   8,
		/singleton/reagent/mutagen = 15
		)

/obj/machinery/portable_atmospherics/hydroponics/AltClick()
	if (istype(usr, /mob/living/carbon/alien/diona))//A diona alt+clicking feeds the plant
		if(!Adjacent(usr))
			return
		if (closed_system)
			to_chat(usr, "The lid is closed, you don't have hands to open it and reach the plants inside!")
			return
		var/mob/living/carbon/alien/diona/nymph = usr
		if(nymph.nutrition > 100 && nutrilevel < 10)
			nymph.adjustNutritionLoss((10-nutrilevel)*5)
			nutrilevel = 10
			nymph.visible_message("<span class='notice'><b>[nymph]</b> secretes a trickle of green liquid, refilling [src].</span>","<span class='notice'>You secrete a trickle of green liquid, refilling [src].</span>")
		return//Nymphs cant open and close lids
	if(mechanical && !usr.incapacitated() && Adjacent(usr))
		close_lid(usr)
		return TRUE
	return ..()

/obj/machinery/portable_atmospherics/hydroponics/attack_ghost(var/mob/abstract/observer/user)
	if(!(seed && ispath(seed.product_type, /mob)))
		to_chat(user, SPAN_WARNING("This tray doesn't have any seeds, or the planted seeds does not spawn a mob!"))
		return
	if(!harvest)
		to_chat(user, SPAN_WARNING("\The [src] isn't ready to harvest yet!"))
		return
	if(jobban_isbanned(user, "Dionaea"))
		to_chat(user, SPAN_WARNING("You are banned from playing Dionae and other living plants!"))
		return
	var/response = alert(user, "Are you sure you want to harvest this [seed.display_name]?", "Living Plant Request", "Yes", "No")
	if(response == "Yes")
		harvest()

/obj/machinery/portable_atmospherics/hydroponics/attack_generic(var/mob/user)

	// Why did I ever think this was a good idea. TODO: move this onto the nymph mob.
	if(istype(user,/mob/living/carbon/alien/diona))
		var/mob/living/carbon/alien/diona/nymph = user

		if (closed_system)
			to_chat(user, "The lid is closed, you don't have hands to open it and reach the plants inside!")
			return
		if(nymph.stat == DEAD || nymph.paralysis || nymph.weakened || nymph.stunned || nymph.restrained())
			return
		if(weedlevel > 0)
			nymph.ingested.add_reagent(/singleton/reagent/nutriment, weedlevel/6)
			weedlevel = 0
			nymph.visible_message("<span class='notice'><b>[nymph]</b> roots through [src], ripping out weeds and eating them noisily.</span>","<span class='notice'>You root through [src], ripping out weeds and eating them noisily.</span>")
			return
		if (dead)//Let nymphs eat dead plants
			nymph.ingested.add_reagent(/singleton/reagent/nutriment, 1)
			nymph.visible_message("<span class='notice'><b>[nymph]</b> rips out the dead plants from [src], and loudly munches them.</span>","<span class='notice'>You root out the dead plants in [src], eating them with loud chewing sounds.</span>")
			remove_dead(user)
			return
		if (harvest)
			harvest(user)
			return
		else
			nymph.visible_message("<span class='notice'><b>[nymph]</b> rolls around in [src] for a bit.</span>","<span class='notice'>You roll around in [src] for a bit.</span>")
		return

/obj/machinery/portable_atmospherics/hydroponics/New()
	..()
	temp_chem_holder = new()
	temp_chem_holder.create_reagents(10)
	temp_chem_holder.atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	create_reagents(200)
	if(mechanical)
		connect()
	update_icon()

/obj/machinery/portable_atmospherics/hydroponics/bullet_act(var/obj/item/projectile/Proj)

	//Don't act on seeds like dionaea that shouldn't change.
	if(seed && seed.get_trait(TRAIT_IMMUTABLE) > 0)
		return

	//Override for somatoray projectiles.
	if(istype(Proj ,/obj/item/projectile/energy/floramut)&& prob(20))
		if(istype(Proj, /obj/item/projectile/energy/floramut/gene))
			var/obj/item/projectile/energy/floramut/gene/G = Proj
			if(seed)
				seed = seed.diverge_mutate_gene(G.gene, get_turf(loc))	//get_turf just in case it's not in a turf.
		else
			mutate(1)
			return
	else if(istype(Proj ,/obj/item/projectile/energy/florayield) && prob(20))
		yield_mod = min(10,yield_mod+rand(1,2))
		return

	..()

/obj/machinery/portable_atmospherics/hydroponics/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return TRUE

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	else
		return !density

/obj/machinery/portable_atmospherics/hydroponics/proc/check_health()
	if(seed && !dead && health <= 0)
		die()
	check_level_sanity()
	update_icon()

/obj/machinery/portable_atmospherics/hydroponics/proc/die()
	dead = 1
	mutation_level = 0
	harvest = 0
	weedlevel += 1 * HYDRO_SPEED_MULTIPLIER
	pestlevel = 0
	if(prob(min(25,max(1,seed.get_trait(TRAIT_POTENCY/2)))))
		if(seed.get_trait(TRAIT_SPOROUS) && !closed_system)
			seed.create_spores(get_turf(src))
			visible_message("<span class='danger'>\The [src] releases its spores!</span>")

//Process reagents being input into the tray.
/obj/machinery/portable_atmospherics/hydroponics/proc/process_reagents()

	if(!reagents) return

	if(reagents.total_volume <= 0)
		return

	reagents.trans_to_obj(temp_chem_holder, min(reagents.total_volume,rand(1,3)))

	for(var/_R in temp_chem_holder.reagents.reagent_volumes)

		var/reagent_total = REAGENT_VOLUME(temp_chem_holder.reagents, _R)

		if(seed && !dead)
			//Handle some general level adjustments.
			if(toxic_reagents[_R])
				toxins += toxic_reagents[_R]         * reagent_total
			if(weedkiller_reagents[_R])
				weedlevel -= weedkiller_reagents[_R] * reagent_total
			if(pestkiller_reagents[_R])
				pestlevel += pestkiller_reagents[_R] * reagent_total

			// Beneficial reagents have a few impacts along with health buffs.
			if(beneficial_reagents[_R])
				health += beneficial_reagents[_R][1]       * reagent_total
				yield_mod += beneficial_reagents[_R][2]    * reagent_total
				mutation_mod += beneficial_reagents[_R][3] * reagent_total

			// Mutagen is distinct from the previous types and mostly has a chance of proccing a mutation.
			if(mutagenic_reagents[_R])
				mutation_level += reagent_total*mutagenic_reagents[_R]+mutation_mod

		// Handle nutrient refilling.
		if(nutrient_reagents[_R])
			nutrilevel += nutrient_reagents[_R]  * reagent_total

		// Handle water and water refilling.
		var/water_added = 0
		if(water_reagents[_R])
			var/water_input = water_reagents[_R] * reagent_total
			water_added += water_input
			waterlevel += water_input

		// Water dilutes toxin level.
		if(water_added > 0)
			toxins -= round(water_added/4)

	temp_chem_holder.reagents.clear_reagents()
	check_health()

//Harvests the product of a plant.
/obj/machinery/portable_atmospherics/hydroponics/proc/harvest(var/mob/user)

	//Harvest the product of the plant,
	if(!seed || !harvest)
		return

	if(closed_system)
		if(user) to_chat(user, "You can't harvest from the plant while the lid is shut.")
		return

	if(user)
		seed.harvest(user,yield_mod)
	else
		seed.harvest(get_turf(src),yield_mod)
	// Reset values.
	if(seed.get_trait(TRAIT_SPOROUS))
		seed.create_spores(get_turf(src))
		visible_message("<span class='danger'>\The [src] releases its spores!</span>")
	harvest = 0
	lastproduce = age

	if(!seed.get_trait(TRAIT_HARVEST_REPEAT))
		yield_mod = 0
		seed = null
		dead = 0
		age = 0
		sampled = 0
		mutation_mod = 0

	check_health()
	return

//Clears out a dead plant.
/obj/machinery/portable_atmospherics/hydroponics/proc/remove_dead(var/mob/user)
	if(!user || !dead || !seed)
		return

	if(closed_system)
		to_chat(user, "You can't remove the dead plant while the lid is shut.")
		return

	seed = null
	dead = 0
	sampled = 0
	age = 0
	yield_mod = 0
	mutation_mod = 0

	to_chat(user, "You remove the dead plant.")
	lastproduce = 0
	check_health()
	return

// If a weed growth is sufficient, this proc is called.
/obj/machinery/portable_atmospherics/hydroponics/proc/weed_invasion()

	//Remove the seed if something is already planted.
	if(seed) seed = null
	seed = SSplants.seeds[pick(list("reishi","nettles","amanita","mushrooms","plumphelmet","towercap","harebells","weeds"))]
	if(!seed) return //Weed does not exist, someone fucked up.

	dead = 0
	age = 0
	health = seed.get_trait(TRAIT_ENDURANCE)
	lastcycle = world.time
	harvest = 0
	weedlevel = 0
	pestlevel = 0
	sampled = 0
	update_icon()
	visible_message("<span class='notice'>[src] has been overtaken by [seed.display_name].</span>")

	return

/obj/machinery/portable_atmospherics/hydroponics/proc/mutate(var/severity)

	// No seed, no mutations.
	if(!seed)
		return

	// Check if we should even bother working on the current seed datum.
	if(seed.mutants?.len && severity > 1)
		mutate_species()
		return

	// We need to make sure we're not modifying one of the global seed datums.
	// If it's not in the global list, then no products of the line have been
	// harvested yet and it's safe to assume it's restricted to this tray.
	if(!isnull(SSplants.seeds[seed.name]))
		seed = seed.diverge()
	seed.mutate(severity,get_turf(src))

	return

/obj/machinery/portable_atmospherics/hydroponics/remove_label()
	if(..())
		labelled = null
		update_icon()

	return

/obj/machinery/portable_atmospherics/hydroponics/verb/setlight()
	set name = "Set Light"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated())
		return
	if(ishuman(usr) || istype(usr, /mob/living/silicon/robot))
		var/new_light = tgui_input_list(usr, "Specify a light level.", "Set Light", list(0,1,2,3,4,5,6,7,8,9,10))
		if(new_light)
			tray_light = new_light
			to_chat(usr, "You set the tray to a light level of [tray_light] lumens.")
	return

/obj/machinery/portable_atmospherics/hydroponics/proc/check_level_sanity()
	//Make sure various values are sane.
	if(seed)
		health =     max(0,min(seed.get_trait(TRAIT_ENDURANCE),health))
	else
		health = 0
		dead = 0

	mutation_level = max(0,min(mutation_level,100))
	nutrilevel =     max(0,min(nutrilevel,10))
	waterlevel =     max(0,min(waterlevel,100))
	pestlevel =      max(0,min(pestlevel,10))
	weedlevel =      max(0,min(weedlevel,10))
	toxins =         max(0,min(toxins,10))

/obj/machinery/portable_atmospherics/hydroponics/proc/mutate_species()

	var/previous_plant = seed.display_name
	var/newseed = seed.get_mutant_variant()
	if(newseed in SSplants.seeds)
		seed = SSplants.seeds[newseed]
	else
		return

	dead = 0
	mutate(1)
	age = 0
	health = seed.get_trait(TRAIT_ENDURANCE)
	lastcycle = world.time
	harvest = 0
	weedlevel = 0

	update_icon()
	visible_message("<span class='danger'>The </span><span class='notice'>[previous_plant]</span><span class='danger'> has suddenly mutated into </span><span class='notice'>[seed.display_name]!</span>")

	return

/obj/machinery/portable_atmospherics/hydroponics/attackby(obj/item/attacking_item, mob/user)

	//A special case for if the container has only water, for manual watering with buckets
	if (istype(attacking_item, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = attacking_item
		if(!RC.is_open_container())
			to_chat(user, SPAN_WARNING("You need to open \the [RC] first!"))
			return
		if (LAZYLEN(RC.reagents.reagent_volumes) == 1)
			if (RC.reagents.has_reagent(/singleton/reagent/water, 1))
				if (waterlevel < maxWaterLevel)
					var/amountToRemove = min((maxWaterLevel - waterlevel), RC.reagents.total_volume)
					RC.reagents.remove_reagent(/singleton/reagent/water, amountToRemove, 1)
					waterlevel += amountToRemove
					user.visible_message("<b>[user]</b> transfers some water to the tray.", "You transfer about [amountToRemove] units of water to the tray.")
				else
					to_chat(user, SPAN_WARNING("This tray is full of water already."))
				return TRUE

	if (attacking_item.is_open_container())
		return FALSE

	if(attacking_item.iswirecutter() || istype(attacking_item, /obj/item/surgery/scalpel))

		if(!seed)
			to_chat(user, "There is nothing to take a sample from in \the [src].")
			return

		if(sampled)
			to_chat(user, "You have already sampled from this plant.")
			return

		if(dead)
			to_chat(user, "The plant is dead.")
			return

		// Create a sample.
		seed.harvest(user,yield_mod,1)
		health -= (rand(3,5)*10)

		if(prob(30))
			sampled = 1

		// Bookkeeping.
		check_health()
		force_update = 1
		process()

		return

	else if(istype(attacking_item, /obj/item/reagent_containers/syringe))

		var/obj/item/reagent_containers/syringe/S = attacking_item

		if (S.mode == 1)
			if(seed)
				return ..()
			else
				to_chat(user, "There's no plant to inject.")
				return TRUE
		else
			if(seed)
				//Leaving this in in case we want to extract from plants later.
				to_chat(user, "You can't get any extract out of this plant.")
			else
				to_chat(user, "There's nothing to draw something from.")
			return TRUE

	else if (istype(attacking_item, /obj/item/seeds))

		if(!seed)

			var/obj/item/seeds/S = attacking_item
			user.remove_from_mob(attacking_item)

			if(!S.seed)
				to_chat(user, "The packet seems to be empty. You throw it away.")
				qdel(attacking_item)
				return

			if(S.seed.hydrotray_only && !mechanical)
				to_chat(user, SPAN_WARNING("This packet can only be planted in a hydroponics tray."))
				return

			to_chat(user, "You plant the [S.seed.seed_name] [S.seed.seed_noun].")
			lastproduce = 0
			seed = S.seed //Grab the seed datum.
			dead = 0
			age = 1
			//Snowflakey, maybe move this to the seed datum
			health = (istype(S, /obj/item/seeds/cutting) ? round(seed.get_trait(TRAIT_ENDURANCE)/rand(2,5)) : seed.get_trait(TRAIT_ENDURANCE))
			lastcycle = world.time

			qdel(attacking_item)

			check_health()

		else
			to_chat(user, "<span class='danger'>\The [src] already has seeds in it!</span>")

	else if (istype(attacking_item, /obj/item/material/minihoe))  // The minihoe

		if(weedlevel > 0)
			user.visible_message("<span class='danger'>[user] starts uprooting the weeds.</span>", "<span class='danger'>You remove the weeds from the [src].</span>")
			weedlevel = 0
			update_icon()
		else
			to_chat(user, "<span class='danger'>This plot is completely devoid of weeds. It doesn't need uprooting.</span>")

	else if (istype(attacking_item, /obj/item/storage/bag/plants))

		attack_hand(user)

		var/obj/item/storage/bag/plants/S = attacking_item
		for (var/obj/item/reagent_containers/food/snacks/grown/G in locate(user.x,user.y,user.z))
			if(!S.can_be_inserted(G))
				return
			S.handle_item_insertion(G, 1)

	else if ( istype(attacking_item, /obj/item/plantspray) )

		var/obj/item/plantspray/spray = attacking_item
		user.remove_from_mob(attacking_item)
		toxins += spray.toxicity
		pestlevel -= spray.pest_kill_str
		weedlevel -= spray.weed_kill_str
		to_chat(user, "You spray [src] with [attacking_item].")
		playsound(loc, 'sound/effects/spray3.ogg', 50, 1, -6)
		qdel(attacking_item)
		check_health()

	else if(mechanical && attacking_item.iswrench())

		//If there's a connector here, the portable_atmospherics setup can handle it.
		if(locate(/obj/machinery/atmospherics/portables_connector/) in loc)
			return ..()

		attacking_item.play_tool_sound(get_turf(src), 50)
		anchored = !anchored
		to_chat(user, "You [anchored ? "wrench" : "unwrench"] \the [src].")

	else if(attacking_item.force && seed)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.visible_message("<span class='danger'>\The [seed.display_name] has been attacked by [user] with \the [attacking_item]!</span>")
		if(!dead)
			var/total_damage = attacking_item.force
			if ((attacking_item.sharp) || (attacking_item.damtype == "fire")) //fire and sharp things are more effective when dealing with plants
				total_damage = 2*attacking_item.force
			health -= total_damage
			check_health()
	return

/obj/machinery/portable_atmospherics/hydroponics/do_simple_ranged_interaction(var/mob/user)
	if(dead)
		remove_dead(user)
	else if(harvest)
		harvest(user)

/obj/machinery/portable_atmospherics/hydroponics/attack_hand(mob/user as mob)

	if(istype(usr,/mob/living/silicon))
		return

	if(harvest)
		harvest(user)
	else if(dead)
		remove_dead(user)

/obj/machinery/portable_atmospherics/hydroponics/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(!seed)
		. += "[src] is empty."
		return

	. += "<span class='notice'>[seed.display_name] are growing here.</span>"

	if(!is_adjacent)
		return

	. += "The water gauge displays [round(waterlevel,0.1)]/100."
	. += "The nutrient gauge displays [round(nutrilevel,0.1)]/10."

	if(weedlevel >= 5)
		. += "\The [src] is <span class='danger'>infested with weeds</span>!"
	if(pestlevel >= 5)
		. += "\The [src] is <span class='danger'>infested with tiny worms</span>!"

	if(dead)
		. += "<span class='danger'>The plant is dead.</span>"
	else if(health <= (seed.get_trait(TRAIT_ENDURANCE)/ 2))
		. += "The plant looks <span class='danger'>unhealthy</span>."

	if(mechanical)
		var/turf/T = loc
		var/datum/gas_mixture/environment

		if(closed_system && (connected_port || holding))
			environment = air_contents

		if(!environment)
			if(istype(T))
				environment = T.return_air()

		if(!environment) //We're in a crate or nullspace, bail out.
			return

		var/light_string
		if(closed_system && mechanical)
			light_string = "that the internal lights are set to [tray_light] lumens"
		else
			var/light_available
			if(TURF_IS_DYNAMICALLY_LIT(T))
				light_available = T.get_lumcount(0, 3) * 10
			else
				light_available = 5

			light_string = "a light level of [light_available] lumens"

		. += "The tray's sensor suite is reporting [light_string] and a temperature of [environment.temperature]K."

/obj/machinery/portable_atmospherics/hydroponics/verb/close_lid_verb()
	set name = "Toggle Tray Lid"
	set category = "Object"
	set src in view(1)
	if(usr.incapacitated())
		return

	if(ishuman(usr) || istype(usr, /mob/living/silicon/robot))
		close_lid(usr)
	return

/obj/machinery/portable_atmospherics/hydroponics/proc/close_lid(var/mob/living/user)
	closed_system = !closed_system
	to_chat(user, "You [closed_system ? "close" : "open"] the tray's lid.")
	update_icon()
