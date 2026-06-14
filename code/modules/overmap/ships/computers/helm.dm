/datum/computer_file/data/waypoint
	var/list/fields = list()

/obj/structure/machinery/computer/ship/helm
	name = "helm control console"
	icon_screen = "helm"
	icon_keyboard = "cyan_key"
	icon_keyboard_emis = "cyan_key_mask"
	light_color = LIGHT_COLOR_CYAN
	var/autopilot = 0
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 1/(20 SECONDS) //top speed for autopilot, 5
	var/accellimit = 0.001 //manual limiter for acceleration

	var/list/linked_helmets = list()
	circuit = /obj/item/circuitboard/ship/helm

/obj/structure/machinery/computer/ship/helm/cockpit
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "main"
	icon_screen = "helm"
	icon_keyboard = null
	circuit = null

/obj/structure/machinery/computer/ship/helm/terminal
	name = "helm control terminal"
	icon = 'icons/obj/modular_computers/modular_terminal.dmi'
	icon_screen = "helm"
	icon_keyboard = "security_key"
	icon_keyboard_emis = "security_key_mask"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/obj/structure/machinery/computer/ship/helm/Initialize()
	. = ..()
	get_known_sectors()

/obj/structure/machinery/computer/ship/helm/Destroy()
	for(var/obj/item/clothing/head/helmet/pilot/PH as anything in linked_helmets)
		PH.linked_helm = null
	return ..()

/obj/structure/machinery/computer/ship/helm/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/clothing/head/helmet/pilot))
		if(!connected)
			to_chat(user, SPAN_WARNING("\The [src] isn't linked to any vessels!"))
			return
		var/obj/item/clothing/head/helmet/pilot/PH = attacking_item
		if(attacking_item in linked_helmets)
			to_chat(user, SPAN_NOTICE("You unlink \the [attacking_item] from \the [src]."))
			PH.set_console(null)
		else
			to_chat(user, SPAN_NOTICE("You link \the [attacking_item] to \the [src]."))
			PH.set_console(src)
			PH.set_hud_maptext("| Ship Status | [connected.x]-[connected.y] |<br>Speed: [connected.get_speed()] | Acceleration: [get_acceleration()]<br>ETA to Next Grid: [get_eta()]")
		check_processing()
		return
	return ..()

/obj/structure/machinery/computer/ship/helm/proc/get_known_sectors()
	var/area/overmap/map = GLOB.map_overmap
	if(!map)
		return
	for(var/obj/effect/overmap/visitable/sector/S in map)
		if (S.known)
			var/datum/computer_file/data/waypoint/R = new()
			R.fields["name"] = S.name
			R.fields["x"] = S.x
			R.fields["y"] = S.y
			known_sectors[S.name] = R

/obj/structure/machinery/computer/ship/helm/proc/check_processing()
	if(autopilot || length(linked_helmets))
		START_PROCESSING(SSprocessing, src)
		return
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/machinery/computer/ship/helm/process()
	..()
	if (autopilot && dx && dy)
		var/turf/T = locate(dx,dy,SSatlas.current_map.overmap_z)
		if(connected.loc == T)
			if(connected.is_still())
				autopilot = 0
			else
				connected.decelerate()
		else
			var/brake_path = connected.get_brake_path()
			var/direction = get_dir(connected.loc, T)
			var/acceleration = min(connected.get_acceleration(), accellimit)
			var/speed = connected.get_speed()
			var/heading = connected.get_heading()

			// Destination is current grid or speedlimit is exceeded
			if ((get_dist(connected.loc, T) <= brake_path) || speed > speedlimit)
				connected.decelerate()
			// Heading does not match direction
			else if (heading & ~direction)
				connected.accelerate(turn(heading & ~direction, 180), accellimit)
			// All other cases, move toward direction
			else if (speed + acceleration <= speedlimit)
				connected.accelerate(direction, accellimit)
	for(var/obj/item/clothing/head/helmet/pilot/PH as anything in linked_helmets)
		PH.set_hud_maptext("| Ship Status | [connected.x]-[connected.y] |<br>Speed: [round(connected.get_speed()*1000, 0.01)] | Acceleration: [get_acceleration()]<br>ETA to Next Grid: [get_eta()]")
		PH.check_ship_overlay(PH.loc, connected)

/obj/structure/machinery/computer/ship/helm/relaymove(mob/living/user, direction)
	. = ..()

	if(viewing_overmap(user) && connected)
		connected.relaymove(user, direction, accellimit)
		return 1

/obj/structure/machinery/computer/ship/helm/ui_interact(mob/user, datum/tgui/ui)
	if(!connected)
		balloon_alert(user, "no connection!")
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Helm", capitalize_first_letters(name))
		RegisterSignal(ui, COMSIG_TGUI_CLOSE, PROC_REF(handle_unlook_signal))
		ui.open()

/obj/structure/machinery/computer/ship/helm/ui_data(mob/user)
	var/list/data = list()

	var/turf/T = get_turf(connected)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["landed"] = connected.get_landed_info()
	data["ship_coord_x"] = connected.x
	data["ship_coord_y"] = connected.y
	data["dest"] = dy && dx
	data["autopilot_x"] = dx
	data["autopilot_y"] = dy
	data["speedlimit"] = speedlimit ? speedlimit*1000 : "Halted"
	data["accel"] = get_acceleration()
	data["heading"] = connected.get_heading() ? dir2angle(connected.get_heading()) : 0
	data["direction"] = dir2angle(connected.dir)
	data["autopilot"] = autopilot
	data["manual_control"] = viewing_overmap(user)
	data["canburn"] = connected.can_burn()
	data["canturn"] = connected.can_turn()
	data["cancombatroll"] = connected.can_combat_roll()
	data["cancombatturn"] = connected.can_combat_turn()
	data["accellimit"] = accellimit*1000

	var/speed = round(connected.get_speed()*1000, 0.01)
	data["speed"] = speed
	if(connected.get_speed() < SHIP_SPEED_SLOW)
		data["speed_slow"] = TRUE
	if(connected.get_speed() > SHIP_SPEED_FAST)
		data["speed_fast"] = TRUE
	var/list/speed_xy = connected.get_speed_xy()
	data["ship_speed_x"] = speed_xy[1]
	data["ship_speed_y"] = speed_xy[2]

	data["ETAnext"] = get_eta()

	var/list/locations[0]
	for (var/key in known_sectors)
		var/datum/computer_file/data/waypoint/R = known_sectors[key]
		var/list/rdata[0]
		rdata["name"] = R.fields["name"]
		rdata["x"] = R.fields["x"]
		rdata["y"] = R.fields["y"]
		rdata["reference"] = "[REF(R)]"
		locations.Add(list(rdata))

	data["locations"] = locations

	return data

/obj/structure/machinery/computer/ship/helm/proc/get_acceleration()
	return min(round(connected.get_acceleration()*1000, 0.01),accellimit*1000)

/obj/structure/machinery/computer/ship/helm/proc/get_eta()
	var/ETA = connected.ETA()
	if(ETA && connected.get_speed())
		return "[round(ETA/7)] seconds"
	else
		return "N/A"

/obj/structure/machinery/computer/ship/helm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(!connected)
		return TRUE

	if(action == "add")
		var/datum/computer_file/data/waypoint/R = new()
		var/sec_name = input("Input naviation entry name", "New navigation entry", "Sector #[known_sectors.len]") as text
		if(!CanInteract(usr, GLOB.physical_state))
			return FALSE
		if(!sec_name)
			sec_name = "Sector #[known_sectors.len]"
		R.fields["name"] = sec_name
		if(sec_name in known_sectors)
			to_chat(usr, SPAN_WARNING("Sector with that name already exists, please input a different name."))
			return TRUE
		switch(params["add"])
			if("current")
				R.fields["x"] = connected.x
				R.fields["y"] = connected.y
			if("new")
				var/newx = input("Input new entry x coordinate", "Coordinate input", connected.x) as num
				if(!CanInteract(usr, GLOB.physical_state))
					return TRUE
				var/newy = input("Input new entry y coordinate", "Coordinate input", connected.y) as num
				if(!CanInteract(usr, GLOB.physical_state))
					return FALSE
				R.fields["x"] = clamp(newx, 1, world.maxx)
				R.fields["y"] = clamp(newy, 1, world.maxy)
		known_sectors[sec_name] = R

	if (action == "remove")
		var/datum/computer_file/data/waypoint/R = locate(params["remove"])
		if(R)
			known_sectors.Remove(R.fields["name"])
			qdel(R)

	if (action == "setx")
		var/newx = input("Input new destination x coordinate", "Coordinate input", dx) as num|null
		if(!CanInteract(usr, GLOB.physical_state))
			return
		if (newx)
			dx = clamp(newx, 1, world.maxx)

	if (action == "sety")
		var/newy = input("Input new destination y coordinate", "Coordinate input", dy) as num|null
		if(!CanInteract(usr, GLOB.physical_state))
			return
		if (newy)
			dy = clamp(newy, 1, world.maxy)

	if (action == "xy")
		dx = text2num(params["x"])
		dy = text2num(params["y"])

	if (action == "reset")
		dx = 0
		dy = 0

	if (action == "roll")
		var/ndir = text2num(params["roll"])
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			var/piloting_difference =  H.GetComponent(PILOT_SPACECRAFT_SKILL_COMPONENT)?.skill_level - connected.pilot_class

			var/dir_to_move = turn(connected.dir, ndir == WEST ? 90 : -90)
			var/turf/new_turf = get_step(connected, dir_to_move)
			if(new_turf.x > SSatlas.current_map.overmap_size || new_turf.y > SSatlas.current_map.overmap_size)
				to_chat(H, SPAN_WARNING("Automated piloting safeties prevent you from going into deep space."))
				return
			if(do_after(H, 1 SECOND) && connected.can_combat_roll())
				visible_message(SPAN_DANGER("[H] tilts the yoke all the way to the [ndir == WEST ? "left" : "right"]!"))
				connected.combat_roll(ndir)
				if(piloting_difference <= 0 && prob(60)) //A lack of difference means skill level (1-4) is less than pilot_class (1-3)
					ndir = pick(NORTH, SOUTH)
					connected.forceMove(get_step(connected, ndir))
					if(connected.pilot_class != PILOTING_CLASS_TWO && prob(70))
						connected.forceMove(get_step(connected, ndir))
						to_chat(H, SPAN_WARNING("You don't need to be an expert to realize you fumbled that."))
					H.visible_message(SPAN_DANGER("[H]'s grip slips!"), SPAN_DANGER("Your handling slips and the vessel teeters off trajectory!"))
		if(issilicon(usr))
			var/mob/living/silicon/H = usr
			var/dir_to_move = turn(connected.dir, ndir == WEST ? 90 : -90)
			var/turf/new_turf = get_step(connected, dir_to_move)
			if(new_turf.x > SSatlas.current_map.overmap_size || new_turf.y > SSatlas.current_map.overmap_size)
				to_chat(H, SPAN_WARNING("Your integrated safeguards prevent you from going into deep space."))
				return
			if(do_after(H, 1 SECOND) && connected.can_combat_roll())
				visible_message(SPAN_DANGER("[H] remotely tilts the yoke systematically all the way to the [ndir == WEST ? "left" : "right"]!"))
				connected.combat_roll(ndir)

	if (action == "manual")
		viewing_overmap(usr) ? unlook(usr) : look(usr)

	if (action == "speedlimit")
		var/newlimit = input("Input new speed limit for autopilot (0 to brake)", "Autopilot speed limit", speedlimit*1000) as num|null
		if(newlimit)
			speedlimit = clamp(newlimit/1000, 0, 100)

	if (action == "accellimit")
		var/newlimit = input("Input new acceleration limit", "Acceleration limit", accellimit*1000) as num|null
		if(newlimit)
			accellimit = max(newlimit/1000, 0)

	if(isliving(usr))// AI and robots are allowed to pilot now!
		if (action == "move")
			var/mob/living/H = usr
			var/piloting_difference =  H.GetComponent(PILOT_SPACECRAFT_SKILL_COMPONENT)?.skill_level - connected.pilot_class

			if(piloting_difference <= 0)
				to_chat(H, SPAN_NOTICE("You begin burning up the vessel's speed..."))
				if((connected.pilot_class != PILOTING_CLASS_TWO && do_after(H, 2 SECONDS)) || (connected.pilot_class == PILOTING_CLASS_TWO && do_after(H, 1 SECOND)))
					connected.relaymove(H, connected.dir, accellimit)
					if(prob(65)) //Can't ignore the 1s burn_delay, so manually do the proc to adjust speed instead
						var/acceleration = min(connected.get_burn_acceleration(), accellimit)
						var/theta = dir2degree(connected.dir)
						if(connected.pilot_class == PILOTING_CLASS_MAX && prob(70))
							acceleration *= 2
						connected.adjust_speed(acceleration * cos(theta), acceleration * sin(theta))
							to_chat(H, SPAN_DANGER("Too fast!"))
						H.visible_message(SPAN_WARNING("[H] motions strongly at \the [src]"), SPAN_WARNING("The speed picks up faster than anticipated."))
				else
					return
			if(prob(H.confused * 5))
				params["turn"] = pick("45", "-45")
			else
				connected.relaymove(usr, connected.dir, accellimit)
				addtimer(CALLBACK(src, PROC_REF(refresh_ui)), connected.burn_delay + 1)

		if (action == "turn")
			var/ndir = text2num(params["turn"])
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/piloting_difference =  H.GetComponent(PILOT_SPACECRAFT_SKILL_COMPONENT)?.skill_level - connected.pilot_class

				if(connected.can_turn() && piloting_difference <= 0)
					to_chat(H, SPAN_NOTICE("You feel you can work a turn [ndir == WEST ? "left" : "right"] here..."))
					if((connected.pilot_class != PILOTING_CLASS_TWO && do_after(H, 3 SECONDS))  || (connected.pilot_class == PILOTING_CLASS_TWO && do_after(H, 1 SECOND)))
						connected.turn_ship(ndir)
						if(prob(60))
							connected.turn_ship(ndir)
							if(connected.pilot_class == PILOTING_CLASS_MAX && prob(70))
								connected.turn_ship(ndir)
								to_chat(H, SPAN_DANGER("Too far!"))
							H.visible_message(SPAN_WARNING("[H] swerves inaccurately on \the [src]"), SPAN_WARNING("You're imprecise and make a wider turn."))
						addtimer(CALLBACK(src, PROC_REF(refresh_ui)), min(connected.vessel_mass / 10, 1) SECONDS + 1)

					else // When moving/interrupted mid-action, always get worse result
						connected.turn_ship(ndir)
						connected.turn_ship(ndir)
						if(prob(70))
							connected.turn_ship(ndir)
							to_chat(H, SPAN_DANGER("Damn it!"))
						H.visible_message(SPAN_WARNING("[H] swerves loosely on \the [src]."), SPAN_WARNING("Your negligence overshoots the turning."))
						addtimer(CALLBACK(src, PROC_REF(refresh_ui)), min(connected.vessel_mass / 10, 1) SECONDS + 1)

				else if(connected.can_turn()) // Normal, w/o penalty
					connected.turn_ship(ndir)
					addtimer(CALLBACK(src, PROC_REF(refresh_ui)), min(connected.vessel_mass / 10, 1) SECONDS + 1)
			else if(connected.can_turn()) // For AI and robots
				connected.turn_ship(ndir)
				addtimer(CALLBACK(src, PROC_REF(refresh_ui)), min(connected.vessel_mass / 10, 1) SECONDS + 1)

		if (action == "combat_turn")
			var/ndir = text2num(params["combat_turn"])
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				if(do_after(H, 1 SECOND) && connected.can_combat_turn())
					visible_message(SPAN_DANGER("[H] twists the yoke all the way to the [ndir == WEST ? "left" : "right"]!"))
					connected.combat_turn(ndir)
			if(issilicon(usr))
				var/mob/living/silicon/H = usr
				if(do_after(H, 1 SECOND) && connected.can_combat_turn())
					visible_message(SPAN_DANGER("[H] remotely twists the yoke systematically all the way to the [ndir == WEST ? "left" : "right"]!"))
					connected.combat_turn(ndir)

		if (action == "brake")
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/piloting_difference =  H.GetComponent(PILOT_SPACECRAFT_SKILL_COMPONENT)?.skill_level - connected.pilot_class

				to_chat(H, SPAN_NOTICE("You begin clamping down the vessel's speed..."))
				if(piloting_difference <= 0)
					if((connected.pilot_class != PILOTING_CLASS_TWO && do_after(H, 2 SECONDS)) || (connected.pilot_class == PILOTING_CLASS_TWO && do_after(H, 1 SECOND)))
						connected.decelerate()
						if(prob(60)) // Can't ignore the 1s burn_delay, so manually do decelerate()'s effects instead
							var/magnitude_velocity = ((connected.speed[1] ** 2) + (connected.speed[2] **2)) ** (1/2)
							var/alpha = min(connected.get_burn_acceleration(), magnitude_velocity)
							var/delta_x = -(connected.speed[1] / magnitude_velocity) * alpha
							var/delta_y = -(connected.speed[2] / magnitude_velocity) * alpha
							if(connected.pilot_class != PILOTING_CLASS_TWO && prob(70))
								delta_x *= 2
								delta_y *= 2
							connected.adjust_speed(delta_x, delta_y)
							to_chat(H, SPAN_WARNING("That clamp was stronger than intended."))
					else
						return
				else // Normal, w/o penalty
					connected.decelerate()
					addtimer(CALLBACK(src, PROC_REF(refresh_ui)), connected.burn_delay + 1)
			else
				connected.decelerate()
				addtimer(CALLBACK(src, PROC_REF(refresh_ui)), connected.burn_delay + 1)

		if (action == "apilot")
			autopilot = !autopilot
			check_processing()
	else
		return TRUE

	add_fingerprint(usr)
	SStgui.update_uis(src)

/obj/structure/machinery/computer/ship/helm/proc/refresh_ui()
	SStgui.update_uis(src)

/obj/structure/machinery/computer/ship/navigation
	name = "navigation console"
	icon_screen = "nav"
	icon_keyboard = "cyan_key"
	icon_keyboard_emis = "cyan_key_mask"
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/ship/navigation

/obj/structure/machinery/computer/ship/navigation/cockpit
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "right"
	icon_screen = "blue"
	icon_keyboard = null
	circuit = null

/obj/structure/machinery/computer/ship/navigation/terminal
	name = "navigation terminal"
	icon = 'icons/obj/modular_computers/modular_terminal.dmi'
	icon_screen = "nav"
	icon_keyboard = "generic_key"
	icon_keyboard_emis = "generic_key_mask"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/obj/structure/machinery/computer/ship/navigation/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return FALSE
	if(use_check_and_message(user))
		return FALSE
	if(!emagged && !allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return FALSE
	user.set_machine(src)
	ui_interact(user)

/obj/structure/machinery/computer/ship/navigation/ui_interact(mob/user, datum/tgui/ui)
	if(!connected)
		balloon_alert(user, "no connection!")
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Nav", capitalize_first_letters(name), ui_x=470, ui_y=320)
		RegisterSignal(ui, COMSIG_TGUI_CLOSE, PROC_REF(handle_unlook_signal))
		ui.open()

/obj/structure/machinery/computer/ship/navigation/ui_data(mob/user)
	var/list/data = list()

	var/turf/T = get_turf(connected)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["ship_coord_x"] = connected.x
	data["ship_coord_y"] = connected.y
	data["speed"] = round(connected.get_speed()*1000, 0.01)
	data["accel"] = round(connected.get_acceleration()*1000, 0.01)
	var/list/speed_xy = connected.get_speed_xy()
	data["ship_speed_x"] = speed_xy[1]
	data["ship_speed_y"] = speed_xy[2]
	data["direction"] = dir2angle(connected.dir)
	data["heading"] = connected.get_heading() ? dir2angle(connected.get_heading()) : 0
	data["ETAnext"] = get_eta()
	data["viewing"] = viewing_overmap(user)

	return data

/obj/structure/machinery/computer/ship/navigation/proc/get_eta()
	var/ETA = connected.ETA()
	if(ETA && connected.get_speed())
		return "[round(ETA/7)] seconds"
	else
		return "N/A"

/obj/structure/machinery/computer/ship/navigation/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(!connected)
		return TRUE

	if(action == "viewing")
		viewing_overmap(usr) ? unlook(usr) : look(usr)

	add_fingerprint(usr)
