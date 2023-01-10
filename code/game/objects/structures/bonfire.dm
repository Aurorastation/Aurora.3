#define MAX_ACTIVE_BONFIRE_LIMIT	15

var/global/list/total_active_bonfires = list()

/obj/structure/bonfire
	name = "bonfire"
	desc = "A large pile of wood, ready to be burned."
	icon = 'icons/obj/bonfire.dmi'
	icon_state = "bonfire"
	anchored = TRUE
	density = FALSE
	light_color = LIGHT_COLOR_FIRE
	var/fuel = 2000
	var/max_fuel = 2000
	var/on_fire = FALSE
	var/safe = FALSE
	var/obj/machinery/appliance/bonfire/cook_machine
	var/list/burnable_materials = list(MATERIAL_WOOD = 200, MATERIAL_WOOD_LOG = 400, MATERIAL_WOOD_BRANCH = 40, MATERIAL_COTTON = 20, MATERIAL_CLOTH = 50, MATERIAL_CARPET = 20, MATERIAL_CARDBOARD = 35)
	var/list/burnable_other = list(/obj/item/ore/coal = 750, /obj/item/torch = 20) //For items without material/default material
	var/heat_range = 5 //Range in which it will heat other people
	var/heating_power
	var/last_ambient_message
	var/burn_out = TRUE //Whether or not it deletes itself when fuel is depleted

/obj/structure/bonfire/Initialize()
	. = ..()
	fuel = rand(1000, 2000)
	create_reagents(120)

/obj/structure/bonfire/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	total_active_bonfires -= src
	. = ..()

/obj/structure/bonfire/examine(mob/user)
	..()
	if(get_dist(src, user) > 2)
		return
	if(on_fire)
		switch(fuel)
			if(0 to 200)
				to_chat(user, "\The [src] is burning weakly.")
			if(200 to 600)
				to_chat(user, "\The [src] is gently burning.")
			if(600 to 900)
				to_chat(user, "\The [src] is burning steadily.")
			if(900 to 1300)
				to_chat(user, "The flames are dancing wildly!")
			if(1300 to 2000)
				to_chat(user, "The fire is roaring!")

/obj/structure/bonfire/update_icon()
	if(on_fire)
		if(fuel < 200)
			icon_state = "[initial(icon_state)]_warm"
		else
			icon_state = "[initial(icon_state)]_fire"
	else
		icon_state = initial(icon_state)


/obj/structure/bonfire/AltClick(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(use_check_and_message(H))
		return
	if(fuel >= max(max_fuel * 0.1, 50))
		to_chat(H, SPAN_NOTICE("You grab a burning stick from the fire."))
		fuel -= 40
		var/obj/item/device/flashlight/flare/torch/stick/torch = new(get_turf(user))
		H.put_in_active_hand(torch)

/obj/structure/bonfire/attackby(obj/item/W, mob/user)
	if(W.isFlameSource() && !on_fire) // needs to go last or else nothing else will work
		light(user)
		return
	if(on_fire && (istype(W, /obj/item/flame) || istype(W, /obj/item/device/flashlight/flare/torch) || istype(W, /obj/item/clothing/mask/smokable))) //light unlit stuff
		W.attackby(src, user)
		return
	if(fuel < max_fuel)
		if(istype(W, /obj/item/stack/material))
			var/obj/item/stack/material/I = W
			if(I.default_type in burnable_materials)
				I.use(1)
				fuel = min(fuel + burnable_materials[I.default_type], max_fuel)
				user.visible_message(SPAN_NOTICE("\The [user] adds some of \the [I] to \the [src]."))
				return
		if(is_type_in_list(W, burnable_other))
			var/fuel_add = burnable_other[W]
			fuel = min(fuel + fuel_add, max_fuel)
			user.visible_message(SPAN_NOTICE("\The [user] tosses \the [W] into \the [src]."))
			user.drop_from_inventory(W)
			qdel(W)
			return
		else if(istype(W, /obj/item/material))
			var/obj/item/material/M = W
			if(M.material.name in burnable_materials)
				var/fuel_add = burnable_materials[M.material] * (M.w_class / 5) //if you crafted a small item, it's not worth as much fuel
				fuel = min(fuel + fuel_add, max_fuel)
				user.visible_message(SPAN_NOTICE("\The [user] tosses \the [M] into \the [src]."))
				user.drop_from_inventory(W)
				W.forceMove(get_turf(src))
				qdel(W)
				return
		else
			var/obj/item/reagent_containers/RC = W
			if(RC.is_open_container())
				RC.reagents.trans_to(src, RC.amount_per_transfer_from_this)
				handle_reagents()

/obj/structure/bonfire/proc/light(mob/user)
	if(!fuel)
		to_chat(user, SPAN_WARNING("There is not enough fuel to start a fire."))
		return
	if(total_active_bonfires.len >= MAX_ACTIVE_BONFIRE_LIMIT)
		to_chat(user, SPAN_WARNING("\The [src] refuses to light, despite all your efforts."))
		return
	if(!on_fire)
		on_fire = TRUE
		check_light()
		update_icon()
		START_PROCESSING(SSprocessing, src)
		total_active_bonfires += src

/obj/structure/bonfire/proc/check_light()
	if(on_fire)
		switch(fuel)
			if(0 to 200)
				set_light(2)
			if(200 to 600)
				set_light(3)
			if(600 to 900)
				set_light(4)
			if(900 to 1300)
				set_light(5)
			if(1300 to 2000)
				set_light(6)
	else
		set_light(0)

/obj/structure/bonfire/proc/check_heat_range()
	if(on_fire)
		switch(fuel)
			if(0 to 200)
				heat_range = 2
			if(200 to 600)
				heat_range = 3
			if(600 to 900)
				heat_range = 4
			if(900 to 1300)
				heat_range = 5
			if(1300 to 2000)
				heat_range = 6
	else
		heat_range = 0
	return heat_range


/obj/structure/bonfire/proc/handle_reagents()
	var/singleton/reagent/R
	var/reagent_level
	if(reagents.total_volume > 0 && on_fire)
		if(reagents.has_reagent(/singleton/reagent/woodpulp))
			R = GET_SINGLETON(/singleton/reagent/woodpulp)
			reagent_level = reagents.reagent_volumes[R.type]
			fuel = min(max_fuel, fuel + reagent_level * 5)
		if(reagents.has_reagent(/singleton/reagent/fuel))
			R = GET_SINGLETON(/singleton/reagent/fuel)
			reagent_level = reagents.reagent_volumes[R.type]
			fuel = min(max_fuel, fuel + reagent_level * 10)
		if(reagents.has_reagent(/singleton/reagent/water))
			R = GET_SINGLETON(/singleton/reagent/water)
			reagent_level = reagents.reagent_volumes[R.type]
			fuel = max(0, fuel - reagent_level * 10)
		if(reagents.has_reagent(/singleton/reagent/toxin/fertilizer/monoammoniumphosphate))
			R = GET_SINGLETON(/singleton/reagent/toxin/fertilizer/monoammoniumphosphate)
			reagent_level = reagents.reagent_volumes[R.type]
			fuel = max(0, fuel - reagent_level * 20)
		if(reagents.has_reagent(/singleton/reagent/toxin/phoron))
			R = GET_SINGLETON(/singleton/reagent/toxin/phoron)
			reagent_level = reagents.reagent_volumes[R.type]
			fuel = min(max_fuel, fuel + (reagent_level * 25))

		if(reagents.has_reagent(/singleton/reagent/alcohol))
			R = GET_SINGLETON(/singleton/reagent/alcohol)
			var/singleton/reagent/alcohol/A = R
			reagent_level = reagents.reagent_volumes[A.type]
			fuel = min(max_fuel, fuel + (reagent_level * (A.strength/20)))

		R.remove_self(reagent_level, reagents)

/obj/structure/bonfire/process()
	if(!on_fire)
		return

	handle_reagents()

	fuel -= rand(1, 2)

	if(fuel <= 0)
		extinguish()
		playsound()

	update_icon()

	if(isturf(loc))
		var/turf/T = loc
		T.hotspot_expose(700, 5)

	if(locate(/mob/living, src.loc))
		var/mob/living/M = locate(/mob/living, src.loc)
		burn(M)

	check_light()
	heat()
	warm_person()
	if(prob(2))
		ambient_message()
	playsound(get_turf(src), 'sound/effects/fireplace.ogg', 30, 1, -3)

/obj/structure/bonfire/proc/extinguish()
	on_fire = FALSE
	STOP_PROCESSING(SSprocessing, src)
	check_light()
	update_icon()
	total_active_bonfires -= src
	if(burn_out)
		visible_message(SPAN_NOTICE("\The [src] burns out, turning to a pile of ash and burnt wood."))
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)

/obj/structure/bonfire/proc/heat()
	if(!on_fire)
		return
	heating_power = 32000 * (fuel / max_fuel)	//Less fuel, less heat
	var/turf/simulated/L = get_turf(src)
	if(istype(L))
		var/datum/gas_mixture/env = L.return_air()
		if(env && abs(env.temperature - (T20C + 5)) > 0.1)
			var/transfer_moles = 0.35 * env.total_moles
			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(removed)
				var/heat_transfer = removed.get_thermal_energy_change(T20C + 5)
				if(heat_transfer > 0)	//heating air
					heat_transfer = min(heat_transfer, heating_power)
					removed.add_thermal_energy(heat_transfer)
				env.merge(removed)
	//fire_act stuff inside. Mobs handled in burn()
	for(var/obj/O in get_turf(src))
		if(O == src)
			continue
		heat_object(O)

/obj/structure/bonfire/proc/heat_object(obj/O)
	if(istype(O, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = O
		var/current_temperature = RC.reagents.get_temperature()
		if(current_temperature <= 310)
			var/thermal_energy_limit = RC.reagents.get_thermal_energy_change(current_temperature, 310)
			RC.reagents.add_thermal_energy(min(1750, thermal_energy_limit))
			RC.reagents.handle_reactions()

	if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/material/I = O
		if(I.default_type in burnable_materials)
			if(max_fuel - fuel >= burnable_materials[I.default_type])
				I.use(1)
				fuel += burnable_materials[I.default_type] * 0.75
	O.fire_act()

/obj/structure/bonfire/proc/warm_person()
	if(!on_fire)
		return
	heat_range = check_heat_range()
	var/turf/simulated/L = get_turf(src)
	if(!istype(L))
		return

	for(var/mob/living/carbon/human/H in oview(src, heat_range))
		var/turf/simulated/T = get_turf(H)
		var/datum/gas_mixture/mob_env
		if(!istype(T))
			continue
		mob_env = T.return_air()

		var/temp_adj = max(min(T20C, mob_env.temperature) - H.bodytemperature, -8)
		if(temp_adj > -1)	//only heats, not precise
			continue
		var/distance = get_dist(src, H)
		var/heating_div = distance > 2 ? distance - 1 : 1 //Heat drops off if you're 3 or more tiles away
		var/heat_eff = fuel / max_fuel	//Less fuel, less heat provided
		H.bodytemperature = min(H.bodytemperature + (abs((temp_adj * heat_eff)) / heating_div), 311)

/obj/structure/bonfire/Crossed(AM as mob|obj)
	if(on_fire)
		burn(AM, TRUE)
	..()

/obj/structure/bonfire/proc/burn(var/mob/living/M, var/entered = FALSE)
	if(safe)
		return
	if(M && prob((fuel / max_fuel) * 100))
		if(entered)
			to_chat(M, "<span class='warning'>You are covered by fire and heat from entering \the [src]!</span>")
		if(isanimal(M))
			var/mob/living/simple_animal/H = M
			if(H.flying) //flying mobs will ignore the lava
				return
			else
				M.bodytemperature = min(M.bodytemperature + 150, 1000)
		else
			if(prob(50))
				M.adjust_fire_stacks(5)
				M.IgniteMob()
				return

/obj/structure/bonfire/proc/ambient_message()
	if(on_fire && world.time >= last_ambient_message + 600)
		var/list/message_picks = list("The wood crackles in the heat.", "The flames of the fire dance vibrantly.", "Some wood crackles, sending harmless sparks dancing in the air",
				"The light of the fire pulses calmly.", "Dozens of sparks dance upward before burning out.")
		if(fuel / max_fuel >= 0.5)
			message_picks += list("The fire roars steadily.", "The flames flare up briefly, before relaxing once more.", "Light smoke twirls upward before fading away.")
		if(fuel / max_fuel <= 0.25)
			message_picks += list("The embers shift as a piece of wood falls into them.", "The glow of the fire pulses weakly.", "Ash dances upward with a few sparks.")
		var/message = "<I>[pick(message_picks)]</I>"
		visible_message(SPAN_GOOD(message))
		last_ambient_message = world.time

/obj/structure/bonfire/light_up/Initialize()
	. = ..()
	on_fire = TRUE
	check_light()
	update_icon()
	START_PROCESSING(SSprocessing, src)
	total_active_bonfires += src

/obj/structure/bonfire/fireplace
	name = "fireplace"
	desc = "A large stone brick fireplace."
	icon = 'icons/obj/fireplace.dmi'
	icon_state = "fireplace"
	pixel_x = -16
	safe = TRUE
	density = TRUE
	burn_out = FALSE

/obj/structure/bonfire/fireplace/New(var/newloc, var/material_name)
	..()
	fuel = 0	//don't start with fuel
	if(!material_name)
		material_name = MATERIAL_MARBLE
	material = SSmaterials.get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] fireplace"

/obj/structure/bonfire/fireplace/update_icon()
	cut_overlays()
	if(on_fire)
		switch(fuel)
			if(0 to 250)
				add_overlay("fireplace_fire0")
			if(251 to 750)
				add_overlay("fireplace_fire1")
			if(751 to 1200)
				add_overlay("fireplace_fire2")
			if(1201 to 1700)
				add_overlay("fireplace_fire3")
			if(1700 to 2000)
				add_overlay("fireplace_fire4")
		add_overlay("fireplace_glow")

/obj/structure/bonfire/fireplace/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!istype(mover) || mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(loc, target) == NORTH)
		return !density
	return TRUE

/obj/structure/bonfire/fireplace/CheckExit(atom/movable/O, turf/target)
	if(get_dir(loc, target) == NORTH)
		return !density
	return TRUE

#undef MAX_ACTIVE_BONFIRE_LIMIT