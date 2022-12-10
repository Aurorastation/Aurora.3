/obj/item/device/assembly/prox_sensor
	name = "proximity sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	icon_state = "prox"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 800, MATERIAL_GLASS = 200)
	flags = PROXMOVE
	wires = WIRE_PULSE

	secured = FALSE

	var/scanning = FALSE
	var/timing = FALSE
	var/time = 10
	var/range = 2

/obj/item/device/assembly/prox_sensor/activate()
	. = ..()
	if(!.)
		return 0//Cooldown check
	timing = !timing
	update_icon()
	return FALSE

/obj/item/device/assembly/prox_sensor/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSprocessing, src)
	else
		scanning = FALSE
		timing = FALSE
		STOP_PROCESSING(SSprocessing, src)
	update_icon()
	return secured

/obj/item/device/assembly/prox_sensor/HasProximity(atom/movable/AM as mob|obj)
	if(!istype(AM))
		log_debug("DEBUG: HasProximity called with [AM] on [src] ([usr]).")
		return
	if(istype(AM, /obj/effect/beam))
		return
	if(AM.move_speed < 12)
		sense()

/obj/item/device/assembly/prox_sensor/proc/sense()
	var/turf/mainloc = get_turf(src)
	if((!holder && !secured) || !scanning || cooldown)
		return FALSE
	pulse(FALSE)
	if(!holder)
		mainloc.audible_message("[icon2html(src, viewers(get_turf(src)))] *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	addtimer(CALLBACK(src, .proc/process_cooldown), 1 SECOND)

/obj/item/device/assembly/prox_sensor/process()
	if(scanning)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(range, mainloc))
			if(A.move_speed < 12)
				sense()

	if(timing)
		if(time >= 0)
			time--
		if(time <= 0)
			timing = FALSE
			toggle_scan()
			time = 10

	SSvueui.check_uis_for_change(src)

/obj/item/device/assembly/prox_sensor/dropped()
	spawn(0)
		sense()

/obj/item/device/assembly/prox_sensor/proc/toggle_scan()
	if(!secured)
		return FALSE
	scanning = !scanning
	update_icon()
	return

/obj/item/device/assembly/prox_sensor/update_icon()
	cut_overlays()
	attached_overlays = list()
	if(timing)
		add_overlay("prox_timing")
		attached_overlays += "prox_timing"
	if(scanning)
		add_overlay("prox_scanning")
		attached_overlays += "prox_scanning"
	if(holder)
		holder.update_icon()
		if(istype(holder.loc, /obj/item/grenade/chem_grenade))
			var/obj/item/grenade/chem_grenade/grenade = holder.loc
			grenade.primed(scanning)

/obj/item/device/assembly/prox_sensor/Move()
	..()
	sense()

/obj/item/device/assembly/prox_sensor/interact(mob/user)
	if(!secured)
		to_chat(user, SPAN_WARNING("\The [src] is unsecured!"))
		return FALSE

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "devices-assembly-proximity", 450, 360, capitalize_first_letters(name), state = deep_inventory_state)
	ui.open()

/obj/item/device/assembly/prox_sensor/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		data = list()

	var/second = time % 60
	var/minute = (time - second) / 60

	VUEUI_SET_CHECK(data["timeractive"], timing, ., data)
	VUEUI_SET_CHECK(data["minute"], minute, ., data)
	VUEUI_SET_CHECK(data["second"], second, ., data)
	VUEUI_SET_CHECK(data["scanning"], scanning, ., data)
	VUEUI_SET_CHECK(data["range"], range, ., data)

/obj/item/device/assembly/prox_sensor/Topic(href, href_list)
	..()

	if(href_list["scanning"])
		toggle_scan()

	if(href_list["time"])
		timing = !timing
		update_icon()

	if(href_list["tp"])
		var/tp = text2num(href_list["tp"])
		time += tp
		time = round(time)
		time = clamp(time, 1, 600)

	if(href_list["range"])
		var/r = text2num(href_list["range"])
		range += r
		range = clamp(range, 1, 5)

	var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
	ui.check_for_change()