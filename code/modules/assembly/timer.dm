/obj/item/device/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 50)

	wires = WIRE_PULSE_ASSEMBLY
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
	addtimer(CALLBACK(src, PROC_REF(process_cooldown)), 1 SECOND)

/obj/item/device/assembly/timer/process()
	if(timing)
		if(time > 0)
			time--
		if(time <= 0)
			timing = FALSE
			timer_end()
			time = 10

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

	ui_interact(user)

/obj/item/device/assembly/timer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Timer", "Timer Assembly", 320, 220)
		ui.open()

/obj/item/device/assembly/timer/ui_data(mob/user)
	var/list/data = list()

	data["timeractive"] = timing
	data["time"] = time

	return data

/obj/item/device/assembly/timer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("time")
			timing = !timing
			update_icon()
			. = TRUE

		if("tp")
			var/tp = text2num(params["tp"])
			time = clamp(tp, 1, 600)
			. = TRUE
