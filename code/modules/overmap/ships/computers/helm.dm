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

/obj/machinery/computer/ship/helm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	if(!connected)
		display_reconnect_dialog(user, "helm")
	else
		var/turf/T = get_turf(connected)
		var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

		data["sector"] = current_sector ? current_sector.name : "Deep Space"
		data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
		data["landed"] = connected.get_landed_info()
		data["s_x"] = connected.x
		data["s_y"] = connected.y
		data["dest"] = dy && dx
		data["d_x"] = dx
		data["d_y"] = dy
		data["speedlimit"] = speedlimit ? speedlimit*1000 : "Halted"
		data["accel"] = get_acceleration()
		data["heading"] = connected.get_heading() ? dir2angle(connected.get_heading()) : 0
		data["autopilot"] = autopilot
		data["manual_control"] = viewing_overmap(user)
		data["canburn"] = connected.can_burn()
		data["cancombatroll"] = connected.can_combat_roll()
		data["cancombatturn"] = connected.can_combat_turn()
		data["accellimit"] = accellimit*1000

		var/speed = round(connected.get_speed()*1000, 0.01)
		if(connected.get_speed() < SHIP_SPEED_SLOW)
			speed = "<span class='good'>[speed]</span>"
		if(connected.get_speed() > SHIP_SPEED_FAST)
			speed = "<span class='average'>[speed]</span>"
		data["speed"] = speed

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

		ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, "helm.tmpl", "[connected.get_real_name()] Helm Control", 565, 545)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/obj/machinery/computer/ship/helm/proc/get_acceleration()
	return min(round(connected.get_acceleration()*1000, 0.01),accellimit*1000)

/obj/machinery/computer/ship/helm/proc/get_eta()
	var/ETA = connected.ETA()
	if(ETA && connected.get_speed())
		return "[round(ETA/7)] seconds"
	else
		return "N/A"

/obj/machinery/computer/ship/helm/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(!connected)
		return TOPIC_HANDLED

	if (href_list["add"])
		var/datum/computer_file/data/waypoint/R = new()
		var/sec_name = input("Input naviation entry name", "New navigation entry", "Sector #[known_sectors.len]") as text
		if(!CanInteract(usr, physical_state))
			return TOPIC_NOACTION
		if(!sec_name)
			sec_name = "Sector #[known_sectors.len]"
		R.fields["name"] = sec_name
		if(sec_name in known_sectors)
			to_chat(usr, "<span class='warning'>Sector with that name already exists, please input a different name.</span>")
			return TOPIC_REFRESH
		switch(href_list["add"])
			if("current")
				R.fields["x"] = connected.x
				R.fields["y"] = connected.y
			if("new")
				var/newx = input("Input new entry x coordinate", "Coordinate input", connected.x) as num
				if(!CanInteract(usr, physical_state))
					return TOPIC_REFRESH
				var/newy = input("Input new entry y coordinate", "Coordinate input", connected.y) as num
				if(!CanInteract(usr, physical_state))
					return TOPIC_NOACTION
				R.fields["x"] = Clamp(newx, 1, world.maxx)
				R.fields["y"] = Clamp(newy, 1, world.maxy)
		known_sectors[sec_name] = R

	if (href_list["remove"])
		var/datum/computer_file/data/waypoint/R = locate(href_list["remove"])
		if(R)
			known_sectors.Remove(R.fields["name"])
			qdel(R)

	if (href_list["setx"])
		var/newx = input("Input new destination x coordinate", "Coordinate input", dx) as num|null
		if(!CanInteract(usr, physical_state))
			return
		if (newx)
			dx = Clamp(newx, 1, world.maxx)

	if (href_list["sety"])
		var/newy = input("Input new destination y coordinate", "Coordinate input", dy) as num|null
		if(!CanInteract(usr, physical_state))
			return
		if (newy)
			dy = Clamp(newy, 1, world.maxy)

	if (href_list["x"] && href_list["y"])
		dx = text2num(href_list["x"])
		dy = text2num(href_list["y"])

	if (href_list["reset"])
		dx = 0
		dy = 0

	if (href_list["roll"])
		var/ndir = text2num(href_list["roll"])
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			visible_message(SPAN_DANGER("[H] starts tilting the yoke all the way to the [ndir == WEST ? "left" : "right"]!"))
			if(do_after(H, 1 SECOND))
				connected.combat_roll(ndir)

	if (href_list["turn"])
		var/ndir = text2num(href_list["turn"])
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			visible_message(SPAN_DANGER("[H] starts twisting the yoke all the way to the [ndir == WEST ? "left" : "right"]!"))
			if(do_after(H, 1 SECOND))
				connected.combat_turn(ndir)

	if (href_list["manual"])
		viewing_overmap(usr) ? unlook(usr) : look(usr)

	if (href_list["speedlimit"])
		var/newlimit = input("Input new speed limit for autopilot (0 to brake)", "Autopilot speed limit", speedlimit*1000) as num|null
		if(newlimit)
			speedlimit = Clamp(newlimit/1000, 0, 100)

	if (href_list["accellimit"])
		var/newlimit = input("Input new acceleration limit", "Acceleration limit", accellimit*1000) as num|null
		if(newlimit)
			accellimit = max(newlimit/1000, 0)

	if(!issilicon(usr)) // AI and robots aren't allowed to pilot
		if (href_list["move"])
			var/ndir = text2num(href_list["move"])
			connected.relaymove(usr, ndir, accellimit)
			addtimer(CALLBACK(src, .proc/updateUsrDialog), connected.burn_delay + 1) // remove when turning into vueui

		if (href_list["brake"])
			connected.decelerate()
			addtimer(CALLBACK(src, .proc/updateUsrDialog), connected.burn_delay + 1) // remove when turning into vueui

		if (href_list["apilot"])
			autopilot = !autopilot
			check_processing()
	else
		to_chat(usr, SPAN_WARNING("Your software does not allow you to interact with the piloting controls."))
		return TOPIC_HANDLED

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/ship/navigation
	name = "navigation console"
	icon_screen = "nav"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN

/obj/machinery/computer/ship/navigation/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!connected)
		display_reconnect_dialog(user, "Navigation")
		return

	var/data[0]


	var/turf/T = get_turf(connected)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["s_x"] = connected.x
	data["s_y"] = connected.y
	data["speed"] = round(connected.get_speed()*1000, 0.01)
	data["accel"] = round(connected.get_acceleration()*1000, 0.01)
	data["heading"] = connected.get_heading() ? dir2angle(connected.get_heading()) : 0
	data["viewing"] = viewing_overmap(user)

	if(connected.get_speed())
		data["ETAnext"] = "[round(connected.ETA()/10)] seconds"
	else
		data["ETAnext"] = "N/A"

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nav.tmpl", "[connected.get_real_name()] Navigation Screen", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/navigation/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if (!connected)
		return TOPIC_NOACTION

	if (href_list["viewing"])
		viewing_overmap(usr) ? unlook(usr) : look(usr)
		return TOPIC_REFRESH
