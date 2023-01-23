/obj/item/device/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 50)

	wires = WIRE_PULSE
	secured = FALSE

	var/timing = FALSE
	var/time = 10


/obj/item/device/assembly/timer/activate()
	. = ..()
	if(!.)
		return FALSE //Cooldown check

	timing = !timing
	update_icon()
	return FALSE

/obj/item/device/assembly/timer/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSprocessing, src)
	else
		timing = FALSE
		STOP_PROCESSING(SSprocessing, src)
	update_icon()
	return secured

/obj/item/device/assembly/timer/proc/timer_end()
	if(!secured)
		return FALSE
	pulse(FALSE)
	if(!holder)
		audible_message("[icon2html(src, viewers(get_turf(src)))] *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	addtimer(CALLBACK(src, .proc/process_cooldown), 1 SECOND)

/obj/item/device/assembly/timer/process()
	if(timing)
		if(time > 0)
			time--
		if(time <= 0)
			timing = FALSE
			timer_end()
			time = 10

	SSvueui.check_uis_for_change(src)

/obj/item/device/assembly/timer/update_icon()
	cut_overlays()
	attached_overlays = list()
	if(timing)
		add_overlay("timer_timing")
		attached_overlays += "timer_timing"
	if(holder)
		holder.update_icon()

/obj/item/device/assembly/timer/interact(mob/user)
	if(!secured)
		to_chat(user, SPAN_WARNING("\The [src] is unsecured!"))
		return

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "devices-assembly-timer", 320, 220, capitalize_first_letters(name), state = deep_inventory_state)
	ui.open()

/obj/item/device/assembly/timer/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		data = list()

	var/second = time % 60
	var/minute = (time - second) / 60

	VUEUI_SET_CHECK(data["timeractive"], timing, ., data)
	VUEUI_SET_CHECK(data["minute"], minute, ., data)
	VUEUI_SET_CHECK(data["second"], second, ., data)

/obj/item/device/assembly/timer/Topic(href, href_list)
	..()

	if(href_list["time"])
		timing = !timing
		update_icon()

	if(href_list["tp"])
		var/tp = text2num(href_list["tp"])
		time += tp
		time = round(time)
		time = clamp(time, 1, 600)

	var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
	ui.check_for_change()