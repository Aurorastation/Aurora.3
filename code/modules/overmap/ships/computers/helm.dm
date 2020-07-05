/datum/computer_file/data/waypoint
	var/list/fields = list()

/obj/machinery/computer/ship/helm
	name = "helm control console"
	icon_screen = "helm"
	light_color = "#7faaff"
	var/autopilot = 0
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 1/(20 SECONDS) //top speed for autopilot, 5
	var/accellimit = 0.001 //manual limiter for acceleration

/obj/machinery/computer/ship/helm/Initialize()
	. = ..()
	get_known_sectors()

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

/obj/machinery/computer/ship/helm/process()
	..()
	if (autopilot && dx && dy)
		var/turf/T = locate(dx,dy,current_map.overmap_z)
		if(linked.loc == T)
			if(linked.is_still())
				autopilot = 0
			else
				linked.decelerate()
		else
			var/brake_path = linked.get_brake_path()
			var/direction = get_dir(linked.loc, T)
			var/acceleration = min(linked.get_acceleration(), accellimit)
			var/speed = linked.get_speed()
			var/heading = linked.get_heading()

			// Destination is current grid or speedlimit is exceeded
			if ((get_dist(linked.loc, T) <= brake_path) || speed > speedlimit)
				linked.decelerate()
			// Heading does not match direction
			else if (heading & ~direction)
				linked.accelerate(turn(heading & ~direction, 180), accellimit)
			// All other cases, move toward direction
			else if (speed + acceleration <= speedlimit)
				linked.accelerate(direction, accellimit)
		return

/obj/machinery/computer/ship/helm/relaymove(var/mob/user, direction)
	if(viewing_overmap(user) && linked)
		linked.relaymove(user, direction, accellimit)
		return 1

/obj/machinery/computer/ship/helm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	if(!linked)
		display_reconnect_dialog(user, "helm")
	else
		var/turf/T = get_turf(linked)
		var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

		data["sector"] = current_sector ? current_sector.name : "Deep Space"
		data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
		data["landed"] = linked.get_landed_info()
		data["s_x"] = linked.x
		data["s_y"] = linked.y
		data["dest"] = dy && dx
		data["d_x"] = dx
		data["d_y"] = dy
		data["speedlimit"] = speedlimit ? speedlimit*1000 : "Halted"
		data["accel"] = min(round(linked.get_acceleration()*1000, 0.01),accellimit*1000)
		data["heading"] = linked.get_heading() ? dir2angle(linked.get_heading()) : 0
		data["autopilot"] = autopilot
		data["manual_control"] = viewing_overmap(user)
		data["canburn"] = linked.can_burn()
		data["accellimit"] = accellimit*1000

		var/speed = round(linked.get_speed()*1000, 0.01)
		if(linked.get_speed() < SHIP_SPEED_SLOW)
			speed = "<span class='good'>[speed]</span>"
		if(linked.get_speed() > SHIP_SPEED_FAST)
			speed = "<span class='average'>[speed]</span>"
		data["speed"] = speed

		if(linked.get_speed())
			data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
		else
			data["ETAnext"] = "N/A"

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
			ui = new(user, src, ui_key, "helm.tmpl", "[linked.name] Helm Control", 565, 545)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/obj/machinery/computer/ship/helm/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(!linked)
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
				R.fields["x"] = linked.x
				R.fields["y"] = linked.y
			if("new")
				var/newx = input("Input new entry x coordinate", "Coordinate input", linked.x) as num
				if(!CanInteract(usr, physical_state))
					return TOPIC_REFRESH
				var/newy = input("Input new entry y coordinate", "Coordinate input", linked.y) as num
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
		var/newx = input("Input new destiniation x coordinate", "Coordinate input", dx) as num|null
		if(!CanInteract(usr, physical_state))
			return
		if (newx)
			dx = Clamp(newx, 1, world.maxx)

	if (href_list["sety"])
		var/newy = input("Input new destiniation y coordinate", "Coordinate input", dy) as num|null
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

	if (href_list["speedlimit"])
		var/newlimit = input("Input new speed limit for autopilot (0 to brake)", "Autopilot speed limit", speedlimit*1000) as num|null
		if(newlimit)
			speedlimit = Clamp(newlimit/1000, 0, 100)
	if (href_list["accellimit"])
		var/newlimit = input("Input new acceleration limit", "Acceleration limit", accellimit*1000) as num|null
		if(newlimit)
			accellimit = max(newlimit/1000, 0)

	if (href_list["move"])
		var/ndir = text2num(href_list["move"])
		linked.relaymove(usr, ndir, accellimit)

	if (href_list["brake"])
		linked.decelerate()

	if (href_list["apilot"])
		autopilot = !autopilot

	if (href_list["manual"])
		viewing_overmap(usr) ? unlook(usr) : look(usr)

	add_fingerprint(usr)
	updateUsrDialog()


/obj/machinery/computer/ship/navigation
	name = "navigation console"
	icon_screen = "nav"

/obj/machinery/computer/ship/navigation/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "Navigation")
		return

	var/data[0]


	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["speed"] = round(linked.get_speed()*1000, 0.01)
	data["accel"] = round(linked.get_acceleration()*1000, 0.01)
	data["heading"] = linked.get_heading() ? dir2angle(linked.get_heading()) : 0
	data["viewing"] = viewing_overmap(user)

	if(linked.get_speed())
		data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
	else
		data["ETAnext"] = "N/A"

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nav.tmpl", "[linked.name] Navigation Screen", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/navigation/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if (!linked)
		return TOPIC_NOACTION

	if (href_list["viewing"])
		viewing_overmap(usr) ? unlook(usr) : look(usr)
		return TOPIC_REFRESH

/obj/machinery/computer/ship/navigation/telescreen	//little hacky but it's only used on one ship so it should be okay
	icon_state = "tele_nav"
	density = 0

/obj/machinery/computer/ship/navigation/telescreen/update_icon()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "tele_off"
		set_light(0)
	else
		icon_state = "tele_nav"
		set_light(2, 2, "#33FAAA")
