/obj/machinery/portable_atmospherics/hydroponics/soil
	name = "soil"
	desc = "A mound of earth. You could plant some seeds here."
	icon_state = "soil"
	density = 0
	use_power = POWER_USE_OFF
	mechanical = 0
	tray_light = 0
	waterlevel = 0
	nutrilevel = 0 // So they don't spawn with water or nutrient when built. Soil's hard mode, baby.
	maxWeedLevel = 10 // Retains the ability for soil to grow weeds, as it should.

/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(obj/item/attacking_item, mob/user)
	//A special case for if the container has only water, for manual watering with buckets
	if (istype(attacking_item, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = attacking_item
		if (LAZYLEN(RC.reagents.reagent_volumes) == 1)
			if (RC.reagents.has_reagent(/singleton/reagent/water, 1))
				if (waterlevel < maxWaterLevel)
					var/amountToRemove = min((maxWaterLevel - waterlevel), RC.reagents.total_volume)
					RC.reagents.remove_reagent(/singleton/reagent/water, amountToRemove, 1)
					waterlevel += amountToRemove
					user.visible_message("[user] pours [amountToRemove]u of water into the soil."," You pour [amountToRemove]u of water into the soil.")
				else
					to_chat(user, "The soil is saturated with water already.")
				return 1

	if(istype(attacking_item, /obj/item/tank))
		return
	if(istype(attacking_item, /obj/item/shovel))
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			new /obj/item/stack/material/sandstone{amount = 3}(loc)
			to_chat(user, SPAN_NOTICE("You remove the soil from the bed and dismantle the sandstone base."))
			playsound(src, 'sound/effects/stonedoor_openclose.ogg', 40, 1)
			qdel(src)
	else
		..()

/obj/machinery/portable_atmospherics/hydroponics/soil/New()
	..()
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/close_lid_verb
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/setlight

// Holder for vine plants.
// Icons for plants are generated as overlays, so setting it to invisible wouldn't work.
// Hence using a blank icon.
/obj/machinery/portable_atmospherics/hydroponics/soil/invisible
	name = "plant"
	desc = null
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Initialize(var/newloc,var/datum/seed/newseed,var/start_mature)
	..()
	seed = newseed
	dead = 0
	age = start_mature ? seed.get_trait(TRAIT_MATURATION) : 1
	health = seed.get_trait(TRAIT_ENDURANCE)
	lastcycle = world.time
	pixel_y = rand(-5,5)
	waterlevel = 100
	nutrilevel = 100
	check_health()

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/remove_dead()
	..()
	qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/harvest()
	..()
	if(!seed) // Repeat harvests are a thing.
		qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/die()
	qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/process()
	if(!seed)
		qdel(src)
		return
	else if(name=="plant")
		name = seed.display_name
	..()

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Destroy()
	// Check if we're masking a decal that needs to be visible again.
	for(var/obj/effect/plant/plant in get_turf(src))
		if(plant.invisibility == INVISIBILITY_MAXIMUM)
			plant.set_invisibility(initial(plant.invisibility))
	return ..()
