/obj/machinery/portable_atmospherics/hydroponics/soil
	name = "soil"
	icon_state = "soil"
	density = 0
	use_power = 0
	mechanical = 0
	tray_light = 0
	waterlevel = 0
	nutrilevel = 0 // So they don't spawn with water or nutrient when built. Soil's hard mode, baby.
	maxWeedLevel = 10 // Retains the ability for soil to grow weeds, as it should.
/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(var/obj/item/O as obj, var/mob/user as mob)
	//A special case for if the container has only water, for manual watering with buckets
	if (istype(O,/obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = O
		if (RC.reagents.reagent_list.len == 1)
			if (RC.reagents.has_reagent("water", 1))
				if (waterlevel < maxWaterLevel)
					var/amountToRemove = min((maxWaterLevel - waterlevel), RC.reagents.total_volume)
					RC.reagents.remove_reagent("water", amountToRemove, 1)
					waterlevel += amountToRemove
					user.visible_message("[user] pours [amountToRemove]u of water into the soil."," You pour [amountToRemove]u of water into the soil.")
				else
					to_chat(user, "The soil is saturated with water already.")
				return 1

	if(istype(O,/obj/item/tank))
		return
	if(istype(O,/obj/item/shovel))
		if(do_after(user, 50/O.toolspeed))
			new /obj/item/stack/material/sandstone{amount = 3}(loc)
			to_chat(user, "<span class='notice'>You remove the soil from the bed and dismantle the sandstone base.</span>")
			playsound(src, 'sound/effects/stonedoor_openclose.ogg', 40, 1)
			qdel(src)
	else
		..()

/obj/machinery/portable_atmospherics/hydroponics/soil/New()
	..()
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/close_lid_verb
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/setlight

/obj/machinery/portable_atmospherics/hydroponics/soil/CanPass()
	return 1

// Holder for vine plants.
// Icons for plants are generated as overlays, so setting it to invisible wouldn't work.
// Hence using a blank icon.
/obj/machinery/portable_atmospherics/hydroponics/soil/invisible
	name = "plant"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/New(var/newloc,var/datum/seed/newseed)
	..()
	seed = newseed
	dead = 0
	age = 1
	health = seed.get_trait(TRAIT_ENDURANCE)
	lastcycle = world.time
	pixel_y = rand(-5,5)
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

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/machinery_process()
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
			plant.invisibility = initial(plant.invisibility)
	return ..()
