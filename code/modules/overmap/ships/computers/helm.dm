/datum/computer_file/data/waypoint
	var/list/fields = list()

/obj/machinery/computer/ship/helm
	name = "helm control console"
	icon_screen = "helm"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN
	var/autopilot = 0
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 1/(20 SECONDS) //top speed for autopilot, 5
	var/accellimit = 0.001 //manual limiter for acceleration

	var/list/linked_helmets = list()
	circuit = /obj/item/circuitboard/ship/helm

/obj/machinery/computer/ship/helm/cockpit
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "main"
	icon_screen = "helm"
	icon_keyboard = null
	circuit = null

/obj/machinery/computer/ship/helm/terminal
	name = "helm control terminal"
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "helm"
	icon_keyboard = "security_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/obj/machinery/computer/ship/helm/Initialize()
	. = ..()
	get_known_sectors()

/obj/machinery/computer/ship/helm/Destroy()
	for(var/obj/item/clothing/head/helmet/pilot/PH as anything in linked_helmets)
		PH.linked_helm = null
	return ..()

/obj/machinery/computer/ship/helm/attackby(obj/item/I, user)
	if(istype(I, /obj/item/clothing/head/helmet/pilot))
		if(!connected)
			to_chat(user, SPAN_WARNING("\The [src] isn't linked to any vessels!"))
			return
		var/obj/item/clothing/head/helmet/pilot/PH = I
		if(I in linked_helmets)
			to_chat(user, SPAN_NOTICE("You unlink \the [I] from \the [src]."))
			PH.set_console(null)
		else
			to_chat(user, SPAN_NOTICE("You link \the [I] to \the [src]."))
			PH.set_console(src)
			PH.set_hud_maptext("| Ship Status | [connected.x]-[connected.y] |<br>Speed: [connected.get_speed()] | Acceleration: [get_acceleration()]<br>ETA to Next Grid: [get_eta()]")
		check_processing()
		return
	return ..()

/obj/machinery/computer/ship/helm/proc/get_known_sectors()
	var/area/overmap/map = global.map_overmap
	if(!map)
		return
	for(var/obj/effect/overmap/visitable/sector/S in map)
		if (S.known)
			var/datum/computer_file/data/waypoint/R = new()
			R.fields["name"] = S.name
			R.fields["x"] = S.x
			R.fields["y"] = S.y
			known_sectors[S.name] = R

/obj/machinery/computer/ship/helm/proc/check_processing()
	if(autopilot || length(linked_helmets))
		START_PROCESSING(SSprocessing, src)
		return
	STOP_PROCESSING(SSprocessing, src)

/obj/machinery/computer/ship/helm/process()
	..()
	if (autopilot && dx && dy)
		var/turf/T = locate(dx,dy,current_map.overmap_z)
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

/obj/machinery/computer/ship/helm/relaymove(var/mob/user, direction)
	if(viewing_overmap(user) && connected)
		connected.relaymove(user, direction, accellimit)
		return 1

/obj/machinery/computer/ship/helm/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Helm", capitalize_first_letters(name))
		RegisterSignal(ui, COMSIG_TGUI_CLOSE, PROC_REF(handle_unlook_signal))
		ui.open()

/obj/machinery/computer/ship/helm/ui_data(mob/user)
	var/list/data = list()

	if(!connected)
		display_reconnect_dialog(user, "helm")
	else
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
			rdata["reference"] = "\ref[R]"
			locations.Add(list(rdata))

		data["locations"] = locations

	return data

/obj/machinery/computer/ship/helm/proc/get_acceleration()
	return min(round(connected.get_acceleration()*1000, 0.01),accellimit*1000)

/obj/machinery/computer/ship/helm/proc/get_eta()
	var/ETA = connected.ETA()
	if(ETA && connected.get_speed())
		return "[round(ETA/7)] seconds"
	else
		return "N/A"

/obj/machinery/computer/ship/helm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(!connected)
		return TRUE

	if(action == "add")
		var/datum/computer_file/data/waypoint/R = new()
		var/sec_name = input("Input naviation entry name", "New navigation entry", "Sector #[known_sectors.len]") as text
		if(!CanInteract(usr, physical_state))
			return FALSE
		if(!sec_name)
			sec_name = "Sector #[known_sectors.len]"
		R.fields["name"] = sec_name
		if(sec_name in known_sectors)
			to_chat(usr, "<span class='warning'>Sector with that name already exists, please input a different name.</span>")
			return TRUE
		switch(params["add"])
			if("current")
				R.fields["x"] = connected.x
				R.fields["y"] = connected.y
			if("new")
				var/newx = input("Input new entry x coordinate", "Coordinate input", connected.x) as num
				if(!CanInteract(usr, physical_state))
					return TRUE
				var/newy = input("Input new entry y coordinate", "Coordinate input", connected.y) as num
				if(!CanInteract(usr, physical_state))
					return FALSE
				R.fields["x"] = Clamp(newx, 1, world.maxx)
				R.fields["y"] = Clamp(newy, 1, world.maxy)
		known_sectors[sec_name] = R

	if (action == "remove")
		var/datum/computer_file/data/waypoint/R = locate(params["remove"])
		if(R)
			known_sectors.Remove(R.fields["name"])
			qdel(R)

	if (action == "setx")
		var/newx = input("Input new destination x coordinate", "Coordinate input", dx) as num|null
		if(!CanInteract(usr, physical_state))
			return
		if (newx)
			dx = Clamp(newx, 1, world.maxx)

	if (action == "sety")
		var/newy = input("Input new destination y coordinate", "Coordinate input", dy) as num|null
		if(!CanInteract(usr, physical_state))
			return
		if (newy)
			dy = Clamp(newy, 1, world.maxy)

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
			var/dir_to_move = turn(connected.dir, ndir == WEST ? 90 : -90)
			var/turf/new_turf = get_step(connected, dir_to_move)
			if(new_turf.x > current_map.overmap_size || new_turf.y > current_map.overmap_size)
				to_chat(H, SPAN_WARNING("Automated piloting safeties prevent you from going into deep space."))
				return
			if(do_after(H, 1 SECOND) && connected.can_combat_roll())
				visible_message(SPAN_DANGER("[H] tilts the yoke all the way to the [ndir == WEST ? "left" : "right"]!"))
				connected.combat_roll(ndir)

	if (action == "manual")
		viewing_overmap(usr) ? unlook(usr) : look(usr)

	if (action == "speedlimit")
		var/newlimit = input("Input new speed limit for autopilot (0 to brake)", "Autopilot speed limit", speedlimit*1000) as num|null
		if(newlimit)
			speedlimit = Clamp(newlimit/1000, 0, 100)

	if (action == "accellimit")
		var/newlimit = input("Input new acceleration limit", "Acceleration limit", accellimit*1000) as num|null
		if(newlimit)
			accellimit = max(newlimit/1000, 0)

	if(!issilicon(usr)) // AI and robots aren't allowed to pilot
		if (action == "move")
			if(prob(usr.confused * 5))
				params["turn"] = pick("45", "-45")
			else
				connected.relaymove(usr, connected.dir, accellimit)
				addtimer(CALLBACK(src, PROC_REF(updateUsrDialog)), connected.burn_delay + 1) // remove when turning into vueui

		if (action == "turn")
			var/ndir = text2num(params["turn"])
			if(connected.can_turn())
				connected.turn_ship(ndir)
				addtimer(CALLBACK(src, PROC_REF(updateUsrDialog)), min(connected.vessel_mass / 10, 1) SECONDS + 1)

		if (action == "combat_turn")
			var/ndir = text2num(params["combat_turn"])
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				if(do_after(H, 1 SECOND) && connected.can_combat_turn())
					visible_message(SPAN_DANGER("[H] twists the yoke all the way to the [ndir == WEST ? "left" : "right"]!"))
					connected.combat_turn(ndir)

		if (action == "brake")
			connected.decelerate()
			addtimer(CALLBACK(src, PROC_REF(updateUsrDialog)), connected.burn_delay + 1)

		if (action == "apilot")
			autopilot = !autopilot
			check_processing()
	else
		to_chat(usr, SPAN_WARNING("Your software does not allow you to interact with the piloting controls."))
		return TRUE

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/ship/navigation
	name = "navigation console"
	icon_screen = "nav"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/ship/navigation

/obj/machinery/computer/ship/navigation/cockpit
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "right"
	icon_screen = "blue"
	icon_keyboard = null
	circuit = null

/obj/machinery/computer/ship/navigation/terminal
	name = "navigation terminal"
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "nav"
	icon_keyboard = "generic_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/obj/machinery/computer/ship/navigation/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Nav", capitalize_first_letters(name), ui_x=470, ui_y=320)
		RegisterSignal(ui, COMSIG_TGUI_CLOSE, PROC_REF(handle_unlook_signal))
		ui.open()

/obj/machinery/computer/ship/navigation/ui_data(mob/user)
	var/list/data = list()

	if(!connected)
		display_reconnect_dialog(user, "navigation")
	else
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

/obj/machinery/computer/ship/navigation/proc/get_eta()
	var/ETA = connected.ETA()
	if(ETA && connected.get_speed())
		return "[round(ETA/7)] seconds"
	else
		return "N/A"

/obj/machinery/computer/ship/navigation/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(!connected)
		return TRUE

	if(action == "viewing")
		viewing_overmap(usr) ? unlook(usr) : look(usr)

	add_fingerprint(usr)
