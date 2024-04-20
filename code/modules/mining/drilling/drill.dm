#define DRILL_LIGHT_IDLE 0
#define DRILL_LIGHT_WARNING 1
#define DRILL_LIGHT_ACTIVE 2

/obj/machinery/mining
	icon = 'icons/obj/mining_drill.dmi'
	anchored = FALSE
	use_power = POWER_USE_OFF //The drill takes power directly from a cell.
	density = TRUE
	layer = MOB_LAYER + 0.1 //So it draws over mobs in the tile north of it.

/obj/machinery/mining/drill
	name = "mining drill head"
	desc = "A large industrial drill. Its bore does not penetrate deep enough to access the sublevels."
	desc_info = "You can upgrade this machine with better matter bins, capacitors, micro lasers, and power cells. You can also attach a mining satchel that has a warp pack and a linked ore box to it, to bluespace teleport any mined ore directly into the linked ore box."
	icon_state = "mining_drill"
	var/braces_needed = 2
	var/list/supports = list()
	var/supported = FALSE
	var/active = FALSE
	var/current_error

	var/list/resource_field = list()

	var/ore_types = list(
		ORE_URANIUM = /obj/item/ore/uranium,
		ORE_IRON = /obj/item/ore/iron,
		ORE_COAL = /obj/item/ore/coal,
		ORE_SAND = /obj/item/ore/glass,
		ORE_PHORON = /obj/item/ore/phoron,
		ORE_SILVER = /obj/item/ore/silver,
		ORE_GOLD = /obj/item/ore/gold,
		ORE_DIAMOND = /obj/item/ore/diamond,
		ORE_PLATINUM = /obj/item/ore/osmium,
		ORE_HYDROGEN = /obj/item/ore/hydrogen,
		ORE_BAUXITE = /obj/item/ore/aluminium,
		ORE_GALENA = /obj/item/ore/lead
	)

	//Upgrades
	var/harvest_speed
	var/capacity
	var/charge_use
	var/obj/item/cell/cell
	var/obj/item/storage/bag/ore/attached_satchel

	//Flags
	var/need_update_field = FALSE
	var/need_player_check = FALSE

	var/datum/effect_system/sparks/spark_system

	component_types = list(
		/obj/item/circuitboard/miningdrill,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/micro_laser,
		/obj/item/cell/high
	)

/obj/machinery/mining/drill/Initialize()
	. = ..()
	spark_system = bind_spark(src, 3)

/obj/machinery/mining/drill/Destroy()
	QDEL_NULL(attached_satchel)
	QDEL_NULL(spark_system)
	return ..()

/obj/machinery/mining/drill/process()
	if(need_player_check)
		return

	check_supports()

	if(!active)
		return

	if(!anchored || !use_cell_power())
		system_error("System configuration or charge error.")
		return

	if(need_update_field)
		get_resource_field()

	if(world.time % 10 == 0)
		update_icon()

	if(!active)
		return

	//Drill through the flooring, if any.
	if(istype(get_turf(src), /turf/unsimulated/floor/asteroid))
		var/turf/unsimulated/floor/asteroid/T = get_turf(src)
		if(!T.dug)
			T.gets_dug()
			for(var/obj/item/ore/ore in range(1, src)) // gets_dug causes ore to spawn, this picks that ore up as well
				ore.forceMove(src)
				if(attached_satchel?.linked_box)
					attached_satchel.insert_into_storage(ore)
	else if(istype(get_turf(src), /turf/simulated/floor/exoplanet))
		var/turf/simulated/floor/exoplanet/T = get_turf(src)
		if(T.diggable)
			new /obj/structure/pit(T)
			T.diggable = 0
			for(var/obj/item/ore/ore in range(1, src)) // gets_dug causes ore to spawn, this picks that ore up as well
				ore.forceMove(src)
				if(attached_satchel?.linked_box)
					attached_satchel.insert_into_storage(ore)
	else if(istype(get_turf(src), /turf/simulated/floor))
		var/turf/simulated/floor/T = get_turf(src)
		var/turf/below_turf = GetBelow(T)
		if(below_turf && !istype(below_turf.loc, /area/mine) && !istype(below_turf.loc, /area/exoplanet) && !istype(below_turf.loc, /area/template_noop))
			system_error("Potential station breach below.")
			return
		T.ex_act(2.0)

	//Dig out the tasty ores.
	if(length(resource_field))
		var/turf/harvesting = pick(resource_field)

		while(length(resource_field) && !harvesting.resources)
			harvesting.has_resources = FALSE
			harvesting.resources = null
			harvesting.cut_overlay(harvesting.resource_indicator)
			QDEL_NULL(harvesting.resource_indicator)
			resource_field -= harvesting
			if(length(resource_field))
				harvesting = pick(resource_field)

		if(!harvesting)
			return

		var/total_harvest = harvest_speed //Ore harvest-per-tick.
		var/found_resource = FALSE //If this doesn't get set, the area is depleted and the drill errors out.

		for(var/ore in ore_types)
			if(length(contents) >= capacity)
				system_error("Insufficient storage space.")
				active = FALSE
				need_player_check = TRUE
				update_icon()
				return

			if(length(contents) + total_harvest >= capacity)
				total_harvest = capacity - length(contents)

			if(total_harvest <= 0)
				break
			if(harvesting.resources[ore])
				found_resource = TRUE

				var/create_ore = 0
				if(harvesting.resources[ore] >= total_harvest)
					harvesting.resources[ore] -= total_harvest
					create_ore = total_harvest
					total_harvest = 0
				else
					total_harvest -= harvesting.resources[ore]
					create_ore = harvesting.resources[ore]
					harvesting.resources[ore] = 0

				for(var/i = 1, i <= create_ore, i++)
					var/oretype = ore_types[ore]
					var/obj/stored_ore = new oretype(src)
					if(attached_satchel?.linked_box)
						attached_satchel.insert_into_storage(stored_ore)

		if(!found_resource)
			harvesting.has_resources = FALSE
			harvesting.resources = null
			harvesting.cut_overlay(harvesting.resource_indicator)
			QDEL_NULL(harvesting.resource_indicator)
			resource_field -= harvesting
	else
		active = FALSE
		need_player_check = TRUE
		system_error("Resource field depleted.")
		update_icon()

/obj/machinery/mining/drill/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(need_player_check)
		. += SPAN_WARNING("The drill error light is flashing. The cell panel is [panel_open ? "open" : "closed"].")
	else
		. += "The drill is [active ? "active" : "inactive"] and the cell panel is [panel_open ? "open" : "closed"]."
	if(panel_open)
		. += "The power cell is [cell ? "installed" : "missing"]."
	. += "The cell charge meter reads [cell ? round(cell.percent(),1) : 0]%."
	if(is_adjacent)
		if(attached_satchel)
			. += FONT_SMALL(SPAN_NOTICE("It has a [attached_satchel] attached to it."))
		if(current_error)
			. += FONT_SMALL(SPAN_WARNING("The error display reads \"[current_error]\"."))
	return

/obj/machinery/mining/drill/proc/activate_light(var/lights = DRILL_LIGHT_IDLE)
	switch(lights)
		if(DRILL_LIGHT_IDLE)
			set_light(2, 0.75, LIGHT_COLOR_TUNGSTEN)
		if(DRILL_LIGHT_WARNING)
			set_light(3, 1, LIGHT_COLOR_EMERGENCY)
		if(DRILL_LIGHT_ACTIVE)
			set_light(4, 1, LIGHT_COLOR_LAVA)

/obj/machinery/mining/drill/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/mining/drill/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/mecha_equipment/drill_mover)) // the drill mover afterattack handles it
		return
	if(!active)
		if(default_deconstruction_screwdriver(user, attacking_item))
			return
		if(default_part_replacement(user, attacking_item))
			return

	if(istype(attacking_item, /obj/item/mining_scanner))
		if(!length(resource_field))
			to_chat(user, SPAN_WARNING("\The [src] has no resource field to draw data from!"))
			return
		to_chat(user, SPAN_NOTICE("You start drawing the data from \the [src]..."))
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			if(!length(resource_field))
				to_chat(user, SPAN_WARNING("\The [src] has no resource field to draw data from!"))
				return
			var/list/ore_data = list()
			for(var/ore_type in ore_types)
				ore_data[ore_type] = 0
			for(var/field in resource_field)
				var/turf/T = field
				if(!T.resources)
					continue
				for(var/ore in ore_types)
					if(T.resources[ore])
						ore_data[ore] += T.resources[ore]
			to_chat(user, SPAN_NOTICE("\The [src] has found this ore in the vicinity, and is able to gather it:"))
			for(var/entry in ore_data)
				to_chat(user, SPAN_NOTICE(" | <b>[entry]</b> - <b>[ore_data[entry]]</b>"))
		return

	if(active)
		return ..()

	if(istype(attacking_item, /obj/item/storage/bag/ore))
		var/obj/item/storage/bag/ore/S = attacking_item
		if(attached_satchel)
			to_chat(user, SPAN_WARNING("\The [src] already has a satchel attached to it!"))
			return
		if(!S.linked_beacon)
			to_chat(user, SPAN_WARNING("\The [S] doesn't have an extraction pack in it!"))
			return
		if(!S.linked_box)
			to_chat(user, SPAN_WARNING("\The [S] doesn't have a linked ore box!"))
			return
		user.drop_from_inventory(S, src)
		attached_satchel = S
		to_chat(user, SPAN_NOTICE("You attach \the [S] to \the [src]."))
		for(var/obj/item/ore/ore in src) // takes ore currently in the drill and beams it away
			attached_satchel.insert_into_storage(ore)
		return

	if(attacking_item.iswrench())
		if(!attached_satchel)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a satchel attached to it!"))
			return
		user.visible_message(SPAN_NOTICE("\The [user] starts detaching \the [attached_satchel]."), SPAN_NOTICE("You start detaching \the [attached_satchel]."))
		if(attacking_item.use_tool(src, user, 30, volume = 50))
			if(!attached_satchel)
				return
			attached_satchel.forceMove(get_turf(user))
			user.put_in_hands(attached_satchel)
			user.visible_message(SPAN_NOTICE("\The [user] detaches \the [attached_satchel]."), SPAN_NOTICE("You detach \the [attached_satchel]."))
			attached_satchel = null
		return

	if(attacking_item.iscrowbar())
		if(panel_open)
			if(cell)
				to_chat(user, SPAN_NOTICE("You shimmy out \the [cell]."))
				cell.forceMove(get_turf(user))
				component_parts -= cell
				user.put_in_hands(cell)
				cell = null
				return
			else
				to_chat(user, SPAN_WARNING("There's no cell to remove!"))
				return
		else
			to_chat(user, SPAN_WARNING("The hatch must be open to take out a power cell."))
			return

	if(istype(attacking_item, /obj/item/gripper/miner)) // the gripper will always be empty, because it passes its wrapped object's attack if it has one
		var/obj/item/gripper/miner/M = attacking_item
		if(panel_open)
			if(cell)
				to_chat(user, SPAN_NOTICE("You use your gripper to squeeze the cell out of its case."))
				cell.forceMove(get_turf(user))
				component_parts -= cell
				M.grip_item(cell, user, FALSE)
				cell = null
				return
			else
				to_chat(user, SPAN_WARNING("There's no cell to remove!"))
				return
		else
			to_chat(user, SPAN_WARNING("The hatch must be open to take out a power cell."))
			return

	if(istype(attacking_item, /obj/item/cell))
		if(panel_open)
			if(cell)
				to_chat(user, SPAN_WARNING("There is already a power cell inside."))
				return
			else
				// insert cell
				user.drop_from_inventory(attacking_item, src)
				cell = attacking_item
				component_parts += attacking_item
				attacking_item.add_fingerprint(user)
				visible_message("<b>\The [user]</b> inserts a power cell into \the [src].",
					SPAN_NOTICE("You insert the power cell into \the [src]."))
				power_change()
		else
			to_chat(user, SPAN_WARNING("The hatch must be open to insert a power cell."))
			return
	else
		..()
	return

/obj/machinery/mining/drill/attack_hand(mob/user)
	check_supports()

	if(need_player_check)
		to_chat(user, SPAN_NOTICE("You hit the manual override and reset the drill's error checking."))
		current_error = null
		need_player_check = FALSE
		if(anchored)
			get_resource_field()
		update_icon()
		return
	else if(supported && !panel_open)
		if(use_cell_power())
			active = !active
			if(active)
				visible_message(SPAN_NOTICE("\The [src] lurches downwards, grinding noisily."))
				need_update_field = TRUE
			else
				visible_message(SPAN_NOTICE("\The [src] shudders to a grinding halt."))
		else
			to_chat(user, SPAN_NOTICE("\The [src] is unpowered."))
	else
		if(use_cell_power())
			if(!supported && !panel_open)
				system_error("Unbraced drill error.")
				sleep(30)
				if(!supported) //if you can resolve it manually in three seconds then power to you good-sir.
					visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [src.name] beeps, \"Unbraced drill error automatically corrected. Please brace your drill.\""))
				else
					visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [src.name] beeps, \"Unbraced drill error manually resolved. Operations may resume normally.\""))
			if(supported && panel_open)
				if(cell)
					system_error("Unsealed cell fitting error. Volatile cell discharge may occur if not immediately corrected.")
					spark_system.queue()
					sleep(20)
					spark_system.queue()
					sleep(10)
					spark_system.queue()
					sleep(10)
					if(panel_open)
						if(prob(70))
							visible_message(SPAN_DANGER("\The [src]'s cell shorts out!"))
							cell.use(cell.charge)
						else
							visible_message(SPAN_DANGER("\The [src]'s cell detonates!"))
							explosion(get_turf(src), -1, -1, 2, 1)
							qdel(cell)
							component_parts -= cell
							cell = null
					else
						visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [src.name] beeps, \"Unsealed cell fitting error manually resolved. Operations may resume normally.\""))
		else
			to_chat(user, SPAN_NOTICE("\The [src] is unpowered."))
	update_icon()

/obj/machinery/mining/drill/update_icon()
	if(need_player_check)
		icon_state = "mining_drill_error"
		activate_light(DRILL_LIGHT_WARNING)
	else if(active)
		icon_state = "mining_drill_active"
		activate_light(DRILL_LIGHT_ACTIVE)
	else if(supported)
		icon_state = "mining_drill_braced"
		activate_light(DRILL_LIGHT_IDLE)
	else
		icon_state = "mining_drill"
		activate_light(DRILL_LIGHT_IDLE)
	return

/obj/machinery/mining/drill/RefreshParts()
	..()
	harvest_speed = 0
	capacity = 0
	charge_use = 25

	for(var/obj/item/stock_parts/P in component_parts)
		if(ismicrolaser(P))
			harvest_speed = P.rating
		else if(ismatterbin(P))
			capacity = 200 * P.rating
		else if(iscapacitor(P))
			charge_use -= 5 * P.rating
	cell = locate(/obj/item/cell) in component_parts

/obj/machinery/mining/drill/proc/check_supports()
	supported = FALSE

	if(supports && length(supports) >= braces_needed)
		supported = TRUE
		anchored = TRUE
	else
		icon_state = "mining_drill"
		active = FALSE
		anchored = FALSE

	update_icon()

/obj/machinery/mining/drill/proc/system_error(var/error)
	if(error)
		visible_message(SPAN_WARNING("[icon2html(src, viewers(get_turf(src)))] <b>[capitalize_first_letters(src.name)]</b> flashes a system warning: \"[error]\"."))
		current_error = error
		playsound(get_turf(src), 'sound/machines/warning-buzzer.ogg', 100, 1)
	need_player_check = TRUE
	active = FALSE
	update_icon()

/obj/machinery/mining/drill/proc/get_resource_field()
	resource_field = list()
	need_update_field = FALSE

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	for(var/turf/mine_turf in block(locate(src.x + 2, src.y + 2, src.z), locate(src.x - 2, src.y - 2, src.z)))
		if(mine_turf?.has_resources)
			resource_field += mine_turf

	if(!length(resource_field))
		system_error("Resources depleted.")

/obj/machinery/mining/drill/proc/use_cell_power()
	if(!cell)
		return FALSE
	if(cell.charge >= charge_use)
		cell.use(charge_use)
		return TRUE
	return FALSE

/obj/machinery/mining/drill/verb/unload()
	set name = "Unload Drill"
	set category = "Object"
	set src in oview(1)

	if(use_check_and_message(usr))
		return

	var/obj/structure/ore_box/B = locate() in orange(1)
	if(B)
		for(var/obj/item/ore/O in contents)
			O.forceMove(B)
		to_chat(usr, SPAN_NOTICE("You unload \the [src]'s storage cache into the ore box."))
	else
		for(var/obj/item/ore/O in contents)
			O.forceMove(get_turf(src))
		to_chat(usr, SPAN_NOTICE("You spill the contents of \the [src]'s storage box all over the ground."))


/obj/machinery/mining/brace
	name = "mining drill brace"
	desc = "A machinery brace for an industrial drill. It looks easily two feet thick."
	icon_state = "mining_brace"
	obj_flags = OBJ_FLAG_ROTATABLE
	var/obj/machinery/mining/drill/connected

	component_types = list(
		/obj/item/circuitboard/miningdrillbrace
	)

/obj/machinery/mining/brace/attackby(obj/item/attacking_item, mob/user)
	if(connected?.active)
		to_chat(user, SPAN_WARNING("You know you ought not work with the brace of a <i>running</i> drill, but you do anyways."))
		sleep(5)
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LA = H.get_organ(BP_L_HAND)
			var/obj/item/organ/external/RA = H.get_organ(BP_R_HAND)
			var/active_hand = H.hand
			if(prob(20))
				if(active_hand)
					LA.droplimb(0, DROPLIMB_BLUNT)
				else
					RA.droplimb(0, DROPLIMB_BLUNT)
				connected.system_error("Unexpected user interface error.")
				return
			else
				H.apply_damage(25, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE)
				connected.system_error("Unexpected user interface error.")
				return
		else
			var/mob/living/M = user
			M.apply_damage(25, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE)

	if(default_deconstruction_screwdriver(user, attacking_item))
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return

	if(attacking_item.iswrench())
		if(istype(get_turf(src), /turf/space))
			to_chat(user, SPAN_NOTICE("You send \the [src] careening into space. Idiot."))
			var/inertia = rand(10, 30)
			for(var/i in 1 to inertia)
				step_away(src, user, 15, 8)
				if(!(istype(get_turf(src), /turf/space)))
					break
				sleep(1)
			return

		if(connected?.active)
			if(prob(50))
				sleep(10)
				connected.system_error("Unbraced drill error.")
				sleep(30)
				if(connected?.active) //if you can resolve it manually in three seconds then power to you good-sir.
					visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [src.name] beeps, \"Unbraced drill error automatically corrected. Please brace your drill.\""))
			else
				connected.system_error("Unexpected user interface error.")
				return

		attacking_item.play_tool_sound(get_turf(src), 100)
		to_chat(user, SPAN_NOTICE("You [anchored ? "un" : ""]anchor the brace."))

		anchored = !anchored
		if(anchored)
			connect()
		else
			disconnect()

/obj/machinery/mining/brace/Destroy()
	disconnect()
	return ..()

/obj/machinery/mining/brace/proc/connect()
	for(var/angle in GLOB.cardinal) // make it face any drill in GLOB.cardinal direction from it
		var/obj/machinery/mining/drill/D = locate() in get_step(src, angle)
		if(D)
			src.dir = angle
			connected = D
			break

	if(!connected)
		return

	if(!connected.supports)
		connected.supports = list()

	icon_state = "mining_brace_active"

	connected.supports += src
	connected.check_supports()

/obj/machinery/mining/brace/proc/disconnect()
	if(!connected)
		return

	if(!connected.supports)
		connected.supports = list()

	icon_state = "mining_brace"

	connected.supports -= src
	connected.check_supports()
	connected = null

#undef DRILL_LIGHT_IDLE
#undef DRILL_LIGHT_WARNING
#undef DRILL_LIGHT_ACTIVE
