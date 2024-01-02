/obj/machinery/computer/ship/sensors
	name = "sensors console"
	icon_screen = "sensors"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN
	extra_view = 4
	var/obj/machinery/shipsensors/sensors
	var/obj/machinery/iff_beacon/identification
	circuit = /obj/item/circuitboard/ship/sensors
	linked_type = /obj/effect/overmap/visitable
	var/contact_details = null
	var/contact_name = null

	var/working_sound = 'sound/machines/sensors/sensorloop.ogg'
	var/datum/sound_token/sound_token
	var/sound_id

	var/datum/weakref/sensor_ref
	var/list/last_scan

/obj/machinery/computer/ship/sensors/cockpit
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	working_sound = 'sound/machines/sensors/ping.ogg'
	icon_state = "left_wide"
	icon_screen = "sensors"
	icon_keyboard = null
	circuit = null

/obj/machinery/computer/ship/sensors/terminal
	name = "sensors terminal"
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "teleport"
	icon_keyboard = "teleport_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1


/obj/machinery/computer/ship/sensors/Destroy()
	QDEL_NULL(sound_token)
	sensors = null
	identification = null
	return ..()

/obj/machinery/computer/ship/sensors/proc/get_sensors()
	return sensors

/obj/machinery/computer/ship/sensors/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	. = ..()
	if(!.)
		return
	find_sensors_and_iff()

/obj/machinery/computer/ship/sensors/proc/find_sensors_and_iff()
	if(!linked)
		return
	for(var/obj/machinery/shipsensors/S in SSmachinery.machinery)
		if(linked.check_ownership(S))
			sensors = S
			break
	for(var/obj/machinery/iff_beacon/IB in SSmachinery.machinery)
		if(linked.check_ownership(IB))
			identification = IB
			break

/obj/machinery/computer/ship/sensors/proc/update_sound()
	if(!working_sound)
		return
	if(!sound_id)
		sound_id = "[type]_[sequential_id(/obj/machinery/computer/ship/sensors)]"

	var/obj/machinery/shipsensors/sensors = get_sensors()
	if(linked && sensors?.use_power && !(sensors.stat & NOPOWER))
		var/volume = 15
		if(!sound_token)
			sound_token = sound_player.PlayLoopingSound(src, sound_id, working_sound, volume = volume, range = 10, sound_type = ASFX_CONSOLE_AMBIENCE)
		sound_token.SetVolume(volume)
	else if(sound_token)
		QDEL_NULL(sound_token)

/obj/machinery/computer/ship/sensors/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sensors", capitalize_first_letters(name))
		RegisterSignal(ui, COMSIG_TGUI_CLOSE, PROC_REF(handle_unlook_signal))
		ui.open()

/obj/machinery/computer/ship/sensors/ui_data(mob/user)

	simple_asset_ensure_is_sent(user, /datum/asset/simple/paper)

	var/data = list()

	data["viewing"] = viewing_overmap(user)
	data["muted"] = muted

	data["grid_x"] = linked.x
	data["grid_y"] = linked.y
	data["direction"] = dir2angle(linked.dir)
	var/linked_x = linked.x
	var/linked_y = linked.y
	var/obj/effect/overmap/visitable/ship/linked_ship = linked
	if(istype(linked_ship))
		linked_x += linked_ship.position[1] / 2.0
		linked_y += linked_ship.position[2] / 2.0
		data["is_ship"] = TRUE
	data["x"] = linked_x
	data["y"] = linked_y

	if(sensors)
		data["on"] = sensors.use_power
		data["range"] = sensors.range
		data["health"] = sensors.health
		data["max_health"] = sensors.max_health
		data["deep_scan_name"] = sensors.deep_scan_sensor_name
		data["deep_scan_range"] = sensors.deep_scan_range
		data["deep_scan_toggled"] = sensors.deep_scan_toggled
		data["heat"] = sensors.heat
		data["critical_heat"] = sensors.critical_heat
		if(sensors.health == 0)
			data["status"] = "DESTROYED"
		else if(!sensors.powered())
			data["status"] = "NO POWER"
		else if(!sensors.in_vacuum())
			data["status"] = "VACUUM SEAL BROKEN"
		else
			data["status"] = "OK"
		var/list/distress_beacons = list()
		for(var/caller in SSdistress.active_distress_beacons)
			var/datum/distress_beacon/beacon = SSdistress.active_distress_beacons[caller]
			var/obj/effect/overmap/vessel = beacon.caller
			var/mob/living/carbon/human/H = beacon.user
			var/job_string = H.job ? "[H.job] " : ""
			var/bearing = round(90 - Atan2(vessel.x - linked.x, vessel.y - linked.y),5)
			if(bearing < 0)
				bearing += 360
			distress_beacons.Add(list(list("caller" = vessel.name, "sender" = "[job_string][H.name]", "bearing" = bearing)))
		if(length(distress_beacons))
			data["distress_beacons"] = distress_beacons
		data["desired_range"] = sensors.desired_range
		data["range_choices"] = list()
		for(var/i in 1 to sensors.max_range)
			data["range_choices"] += i


		var/list/contacts = list()
		var/list/potential_contacts = list()

		for(var/obj/effect/overmap/nearby in view(7, linked))
			if(nearby.requires_contact) // Some ships require.
				continue
			potential_contacts |= nearby

		// Effects that require contact are only added to the contacts if they have been identified.
		// Allows for coord tracking out of range of the player's view.
		for(var/obj/effect/overmap/visitable/identified_contact in contact_datums)
			potential_contacts |= identified_contact

		for(var/obj/effect/overmap/contact in potential_contacts)
			if(linked == contact)
				continue
			if(!contact.scannable)
				continue

			var/obj/effect/overmap/visitable/ship/landable/contact_landable = contact
			var/landed = (istype(contact_landable) && contact_landable.status == SHIP_STATUS_LANDED)

			var/contact_x = contact.x
			var/contact_y = contact.y

			var/obj/effect/overmap/visitable/ship/contact_ship = contact
			if(istype(contact_ship))
				contact_x += contact_ship.position[1] / 2.0
				contact_y += contact_ship.position[2] / 2.0

			var/bearing = round(BEARING_RELATIVE(linked_x, linked_y, contact_x, contact_y),5)
			if(bearing < 0)
				bearing += 360

			var/distance = DIST_BETWEEN_TWO_POINTS(linked_x, linked_y, contact_x, contact_y)

			contacts.Add(list(list(
				"name"=contact.name,
				"ref"="\ref[contact]",
				"bearing"=bearing,
				"can_datalink"=(!(contact in connected.datalinked)),
				"distance"=distance,
				"landed"=landed,
				"x"=contact_x,
				"y"=contact_y
			)))

		data["contacts"] = contacts

		// Add datalink requests
		if(length(connected.datalink_requests))
			var/list/local_datalink_requests = list()
			for(var/obj/effect/overmap/visitable/requestor in connected.datalink_requests)
				local_datalink_requests.Add(list(list("name"=requestor.name, "ref"="\ref[requestor]")))
			data["datalink_requests"]  = local_datalink_requests

		if(length(connected.datalinked))
			var/list/local_datalinked = list()
			for(var/obj/effect/overmap/visitable/datalinked_ship in connected.datalinked)
				local_datalinked.Add(list(list("name"=datalinked_ship.name, "ref"="\ref[datalinked_ship]")))
			data["datalinked"]  = local_datalinked

		data["last_scan"] = last_scan
	else
		data["status"] = "MISSING"
		data["range"] = "N/A"
		data["on"] = 0

	if(identification)
		data["id_on"] = identification.use_power
		if(identification.disabled)
			data["id_status"] = "ERROR"
		else if(!identification.use_power)
			data["id_status"] = "NOT TRANSMITTING"
		else
			data["id_status"] = "TRANSMITTING"
		data["id_class"] = linked.class
		data["id_name"] = linked.designation
		data["can_change_class"] = identification.can_change_class
		data["can_change_name"] = identification.can_change_name
		if(contact_details)
			data["contact_details"] = contact_details
	else
		data["id_status"] = "NOBEACON" //Should not really happen.

	return data

/obj/machinery/computer/ship/sensors/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if (..())
		return TRUE

	if (!linked)
		return FALSE

	if (action == "viewing")
		if(usr)
			viewing_overmap(usr) ? unlook(usr) : look(usr)
		return TRUE

	if (action == "link")
		find_sensors_and_iff()
		return TRUE

	if(sensors)
		if (action == "range")
			var/nrange = tgui_input_number("Set new sensors range", "Sensor range", sensors.range, sensors.max_range, 1)
			if(!CanInteract(usr, default_state))
				return FALSE
			if (nrange)
				sensors.set_desired_range(Clamp(nrange, 1, sensors.max_range))
			return TRUE
		if(action == "range_choice")
			var/nrange = text2num(params["range_choice"])
			if(!CanInteract(usr, default_state))
				return FALSE
			if(nrange)
				sensors.set_desired_range(Clamp(nrange, 1, sensors.max_range))
			return TRUE
		if (action == "toggle")
			sensors.toggle()
			return TRUE

		if(action == "deep_scan_toggle")
			sensors.deep_scan_toggled = !sensors.deep_scan_toggled
			return TRUE

	if(identification)
		if(action == "toggle_id")
			identification.toggle()
			return TRUE

		if(action == "change_ship_class")
			if(!identification.use_power)
				to_chat(usr, SPAN_WARNING("You cannot do this while the IFF is off!"))
				return
			var/new_class = tgui_input_text(usr, "Insert a new ship class. 4 letters maximum.", "IFF Management", linked.class, 4)
			if(!length(new_class))
				return
			new_class = sanitizeSafe(new_class, 5)
			new_class = uppertext(new_class)
			if(use_check_and_message(usr))
				return
			linked.set_new_class(new_class)
			playsound(src, 'sound/machines/twobeep.ogg', 50)
			visible_message(SPAN_NOTICE("\The [src] beeps, <i>\"IFF change to ship class registered.\"</i>"))
			return TRUE

		if(action == "change_ship_name")
			if(!identification.use_power)
				to_chat(usr, SPAN_WARNING("You cannot do this while the IFF is off!"))
				return
			var/new_name = tgui_input_text(usr, "Insert a new ship name. 24 letters maximum.", "IFF Management", linked.designation, MAX_NAME_LEN)
			if(!length(new_name))
				return
			new_name = sanitizeSafe(new_name, 24)
			new_name = capitalize(new_name)
			if(use_check_and_message(usr))
				return
			linked.set_new_designation(new_name)
			playsound(src, 'sound/machines/twobeep.ogg', 50)
			visible_message(SPAN_NOTICE("\The [src] beeps, <i>\"IFF change to ship designation registered.\"</i>"))
			return TRUE

	if (action == "scan_action")
		switch(params["scan_action"])
			if("clear")
				contact_details = null
			if("print")
				if(contact_details)
					playsound(loc, 'sound/machines/dotprinter.ogg', 30, 1)
					new/obj/item/paper/(get_turf(src), contact_details, "paper (Sensor Scan - [contact_name])")
		return TRUE

	if (action == "scan")
		var/obj/effect/overmap/O = locate(params["scan"])
		if(istype(O) && !QDELETED(O))
			if((O in view(7,linked))|| (O in contact_datums))
				playsound(loc, 'sound/machines/dotprinter.ogg', 30, 1)
				LAZYSET(last_scan, "data", O.get_scan_data(usr))
				LAZYSET(last_scan, "location", "[O.x],[O.y]")
				LAZYSET(last_scan, "name", "[O]")
				to_chat(usr, SPAN_NOTICE("Successfully scanned [O]."))
				contact_name = O.name
				contact_details = O.get_scan_data(usr)
		return TRUE

	if (action == "request_datalink")
		var/obj/effect/overmap/visitable/O = locate(params["request_datalink"])
		if(istype(O) && !QDELETED(O))
			if((O in view(7,linked)) || (O in contact_datums))

				for(var/obj/machinery/computer/ship/sensors/sensor_console in O.consoles)
					sensor_console.connected.datalink_requests |= src.connected
		return TRUE

	if (action == "accept_datalink_requests")
		var/obj/effect/overmap/visitable/O = locate(params["accept_datalink_requests"])
		for(var/obj/machinery/computer/ship/sensors/sensor_console in src.connected.consoles)
			sensor_console.datalink_add_ship_datalink(O)
			break
		src.connected.datalink_requests -= O	// Remove the request
		return TRUE

	if (action == "decline_datalink_requests")
		var/obj/effect/overmap/visitable/O = locate(params["decline_datalink_requests"])
		src.connected.datalink_requests -= O	// Remove the request

	if (action == "remove_datalink")
		var/obj/effect/overmap/visitable/O = locate(params["remove_datalink"])
		for(var/obj/machinery/computer/ship/sensors/rescinder_sensor_console in src.connected.consoles)	// Get sensor console from the rescinder
			rescinder_sensor_console.datalink_remove_ship_datalink(O, TRUE)
			return TRUE

	if (action == "play_message")
		var/caller = params["play_message"]
		var/datum/distress_beacon/beacon = SSdistress.active_distress_beacons[caller]
		var/mob/living/carbon/human/sender = beacon.user
		var/user_name = beacon.user_name
		var/accent_icon = sender.get_accent_icon()
		visible_message(SPAN_NOTICE("\The [src] beeps a few times as it replays the distress message."))
		playsound(src, 'sound/machines/compbeep5.ogg')
		visible_message(SPAN_ITALIC("[accent_icon] <b>[user_name]</b> explains, \"[beacon.distress_message]\""))
		return TRUE

	if(action == "inbound_fire")
		var/direction = params["inbound_fire"]
		if(direction != "clear")
			security_announcement.Announce("Enemy fire inbound, enemy fire inbound! [sanitizeSafe(direction)]!", "Brace for shock!", sound('sound/mecha/internaldmgalarm.ogg', volume = 90), 0)
		else
			security_announcement.Announce("No fire is incoming at the current moment, resume damage control.", "Space clear!", sound('sound/misc/announcements/security_level_old.ogg'), 0)
		return TRUE

/obj/machinery/shipsensors
	name = "sensors suite"
	desc = "Long range gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
	icon = 'icons/obj/machinery/sensors.dmi'
	icon_state = "sensors"
	anchored = 1
	var/max_health = 200
	var/health = 200
	var/critical_heat = 50 // sparks and takes damage when active & above this heat
	var/heat_reduction = 1.7 // mitigates this much heat per tick - can sustain range 4
	var/heat = 0
	var/range = 1 // actual range
	var/desired_range = 1 // "desired" range, that the actual range will gradually move towards to
	var/desired_range_instant = FALSE // if true, instantly changes range to desired
	var/max_range = 10
	var/sensor_strength = 5//used for detecting ships via contacts
	var/deep_scan_range = 4 //Maximum range for the range() check in sensors. Basically a way to use range instead of view in this radius.
	var/deep_scan_toggled = FALSE //When TRUE, this sensor is using long range sensors.
	var/deep_scan_sensor_name = "High-Power Sensor Array"
	idle_power_usage = 5000

	var/base_icon_state

/obj/machinery/shipsensors/Initialize(mapload, d, populate_components, is_internal)
	base_icon_state = icon_state
	return ..()

/obj/machinery/shipsensors/attackby(obj/item/W, mob/user)
	var/damage = max_health - health
	if(damage && W.iswelder())

		var/obj/item/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.use(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(WT.use_tool(src, user, max(5, damage / 5), volume = 50) && WT && WT.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				take_damage(-damage)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
		return
	..()

/obj/machinery/shipsensors/proc/in_vacuum()
	var/turf/T=get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if(environment && environment.return_pressure() > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
			return 0
	return 1

/obj/machinery/shipsensors/update_icon()
	icon_state = "[base_icon_state]_off"
	if(!use_power)
		cut_overlays()

	if(use_power)
		icon_state = "[base_icon_state]_on"
		return

	var/overlay = "[base_icon_state]-effect"

	var/range_percentage = range / max_range * 100

	if(range_percentage < 20)
		overlay = "[overlay]1"
	else if(range_percentage < 40)
		overlay = "[overlay]2"
	else if(range_percentage < 60)
		overlay = "[overlay]3"
	else if(range_percentage < 80)
		overlay = "[overlay]4"
	else
		overlay = "[overlay]5"

	cut_overlays()
	add_overlay(overlay)
	var/heat_percentage = heat / critical_heat * 100
	if(heat_percentage > 85)
		add_overlay("sensors-effect-hot")

/obj/machinery/shipsensors/examine(mob/user)
	. = ..()
	if(health <= 0)
		to_chat(user, "\The [src] is wrecked.")
	else if(health < max_health * 0.25)
		to_chat(user, "<span class='danger'>\The [src] looks like it's about to break!</span>")
	else if(health < max_health * 0.5)
		to_chat(user, "<span class='danger'>\The [src] looks seriously damaged!</span>")
	else if(health < max_health * 0.75)
		to_chat(user, "\The [src] shows signs of damage!")

/obj/machinery/shipsensors/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	..()

/obj/machinery/shipsensors/proc/toggle()
	if(use_power) // reset desired range when turning off
		set_desired_range(1)
	if(!use_power && (health == 0 || !in_vacuum()))
		return // No turning on if broken or misplaced.
	if(!use_power) //need some juice to kickstart
		use_power_oneoff(idle_power_usage*5)
	update_use_power(!use_power)
	queue_icon_update()

/obj/machinery/shipsensors/process()
	..()
	if(use_power) //can't run in non-vacuum
		if(!in_vacuum())
			toggle()
		if(desired_range > range)
			set_range(range+1)
		if(desired_range < range)
			set_range(range-1)
		if(desired_range-range <= -max_range/2)
			set_range(range-1) // if working hard, spool down faster too
		if(heat > critical_heat)
			src.visible_message("<span class='danger'>\The [src] violently spews out sparks!</span>")
			spark(src, 3, GLOB.alldirs)
			take_damage(rand(10,50))
			toggle()
		if(deep_scan_toggled)
			heat += deep_scan_range / 8
		heat += active_power_usage / 15000
	else if(desired_range < range)
		set_range(range-1) // if power off, only spool down

	if (heat > 0)
		heat = max(0, heat - heat_reduction)

	update_icon()

/obj/machinery/shipsensors/power_change()
	. = ..()
	if(use_power && !powered())
		toggle()

/obj/machinery/shipsensors/proc/set_desired_range(nrange)
	desired_range = nrange
	if(desired_range_instant)
		set_range(nrange)

/obj/machinery/shipsensors/proc/set_range(nrange)
	range = nrange
	change_power_consumption(1500 * (range**2), POWER_USE_ACTIVE)

/obj/machinery/shipsensors/emp_act(severity)
	. = ..()

	if(!use_power)
		return

	take_damage(20/severity)
	toggle()

/obj/machinery/shipsensors/proc/take_damage(value)
	health = min(max(health - value, 0),max_health)
	if(use_power && health == 0)
		toggle()

// For small shuttles
/obj/machinery/shipsensors/weak
	heat_reduction = 1.7 // Can sustain range 4
	max_range = 7
	desc = "Miniturized gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
	deep_scan_range = 0

/obj/machinery/shipsensors/weak/scc_shuttle
	icon_state = "sensors"
	icon = 'icons/obj/spaceship/scc/helm_pieces.dmi'

/obj/machinery/shipsensors/strong
	desc = "An upgrade to the standard ship-mounted sensor array, this beast has massive cooling systems running beneath it, allowing it to run hotter for much longer. Can only run in vacuum to protect delicate quantum BS elements."
	heat_reduction = 3.7 // can sustain range 6
	max_range = 14
	deep_scan_range = 6
	deep_scan_sensor_name = "High-Power Sensor Array"

/obj/machinery/shipsensors/strong/scc_shuttle //Exclusively for the Horizon scout shuttle.
	icon_state = "sensors"
	icon = 'icons/obj/spaceship/scc/shuttle_sensors.dmi'

/obj/machinery/shipsensors/strong/venator
	name = "venator-class quantum sensor array"
	desc = "An incredibly advanced sensor array, created using top of the line technology in every conceivable area. Not only does it far outperform and outclass every other sensors system, it also boasts revolutionary quantum long-range sensors."
	icon = 'icons/obj/machinery/sensors_venator.dmi'
	deep_scan_range = 12
	deep_scan_sensor_name = "Venator-Class Ultra-High Depth Sensors"
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -32
	pixel_y = -32
