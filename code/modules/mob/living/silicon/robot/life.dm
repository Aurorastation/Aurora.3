/mob/living/silicon/robot/Life()
	set background = BACKGROUND_ENABLED

	if(transforming)
		return

	blinded = null

	//Status updates, death etc.
	clamp_values()
	handle_regular_status_updates()
	handle_actions()

	if(client)
		handle_regular_hud_updates()
		update_items()
	if(stat)
		cut_overlay(eye_overlay)
		has_cut_eye_overlay = TRUE
	else if(has_cut_eye_overlay)
		eye_overlay = cached_eye_overlays[a_intent]
		add_overlay(eye_overlay)
		has_cut_eye_overlay = null
	if(stat != DEAD) //still using power
		use_power()
		process_killswitch()
		process_locks()
		process_queued_alarms()
		process_level_restrictions()
	update_canmove()

/mob/living/silicon/robot/proc/clamp_values()
	SetParalysis(min(paralysis, 30))
	sleeping = FALSE
	adjustBruteLoss(0)
	adjustToxLoss(0)
	adjustOxyLoss(0)
	adjustFireLoss(0)

/mob/living/silicon/robot/proc/use_power()
	used_power_this_tick = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		C.update_power_state()

	if(cell?.charge > 0 && is_component_functioning("power cell"))
		if(module_state_1)
			cell_use_power(50) // 50W load for every enabled tool TODO: tool-specific loads
		if(module_state_2)
			cell_use_power(50)
		if(module_state_3)
			cell_use_power(50)

		if(lights_on)
			if(intense_light)
				cell_use_power(100)	// Upgraded light. Double intensity, much larger power usage.
			else
				cell_use_power(30) 	// 30W light. Normal lights would use ~15W, but increased for balance reasons.
		has_power = TRUE
	else
		if(has_power)
			to_chat(src, SPAN_WARNING("You are now running on emergency backup power."))
		has_power = 0
		if(lights_on) // Light is on but there is no power!
			lights_on = 0
			set_light(0)

/mob/living/silicon/robot/handle_regular_status_updates()
	if(camera && !scrambled_codes)
		if(stat == DEAD || wires.IsIndexCut(BORG_WIRE_CAMERA))
			camera.set_status(0)
		else
			camera.set_status(1)

	updatehealth()

	if(sleeping)
		Paralyse(3)
		sleeping--

	if(resting)
		Weaken(5)

	if(health < config.health_threshold_dead && stat != DEAD) //die only once
		death()

	if(stat != DEAD)
		if(paralysis || stunned || weakened || !has_power) //Stunned etc.
			stat = UNCONSCIOUS
			if(stunned > 0)
				AdjustStunned(-1)
			if(weakened > 0)
				AdjustWeakened(-1)
			if(paralysis > 0)
				AdjustParalysis(-1)
				blinded = TRUE
			else
				blinded = FALSE

		else //Not stunned.
			stat = CONSCIOUS

	else //Dead.
		blinded = TRUE
		stat = DEAD

	if(stuttering)
		stuttering--

	if(eye_blind)
		eye_blind--
		blinded = 1

	if(ear_deaf > 0)
		ear_deaf--
	if(ear_damage < 25)
		ear_damage -= 0.05
		ear_damage = max(ear_damage, 0)

	if((sdisabilities & BLIND))
		blinded = TRUE
	if((sdisabilities & DEAF))
		ear_deaf = TRUE

	if(eye_blurry > 0)
		eye_blurry--
		eye_blurry = max(0, eye_blurry)

	if(druggy > 0)
		druggy--
		druggy = max(0, druggy)

	//update the state of modules and components here
	if(stat != CONSCIOUS)
		uneq_all()

	if(common_radio)
		if(!is_component_functioning("radio"))
			common_radio.on = FALSE
		else
			common_radio.on = TRUE

	if(is_component_functioning("camera"))
		blinded = FALSE
	else
		blinded = TRUE

	return TRUE

/mob/living/silicon/robot/handle_regular_hud_updates()
	..()
	if(stat == DEAD || (XRAY in mutations) || (sight_mode & BORGXRAY))
		set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
		set_see_in_dark(8)
		set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)
	else if((sight_mode & BORGMESON) && (sight_mode & BORGTHERM))
		set_sight(sight|SEE_TURFS|SEE_MOBS)
		set_see_in_dark(8)
		set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	else if(sight_mode & BORGMESON)
		set_sight(sight|SEE_TURFS)
		set_see_in_dark(8)
		set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	else if(sight_mode & BORGMATERIAL)
		set_sight(sight|SEE_OBJS)
		set_see_in_dark(8)
	else if(sight_mode & BORGTHERM)
		set_sight(sight|SEE_MOBS)
		set_see_in_dark(8)
		set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)
	else if(stat != DEAD)
		set_sight(sight&(~SEE_TURFS)&(~SEE_MOBS)&(~SEE_OBJS))
		set_see_in_dark(8)
		set_see_invisible(SEE_INVISIBLE_LIVING)

	switch(sensor_mode)
		if(SEC_HUD)
			process_sec_hud(src, FALSE)
		if(MED_HUD)
			process_med_hud(src, FALSE)

	if(healths)
		if(stat != DEAD)
			if(istype(src, /mob/living/silicon/robot/drone))
				switch(health)
					if(35 to INFINITY)
						healths.icon_state = "health0"
					if(25 to 34)
						healths.icon_state = "health1"
					if(15 to 24)
						healths.icon_state = "health2"
					if(5 to 14)
						healths.icon_state = "health3"
					if(0 to 4)
						healths.icon_state = "health4"
					if(-35 to 0)
						healths.icon_state = "health5"
					else
						healths.icon_state = "health6"
			else
				switch(health)
					if(200 to INFINITY)
						healths.icon_state = "health0"
					if(150 to 200)
						healths.icon_state = "health1"
					if(100 to 150)
						healths.icon_state = "health2"
					if(50 to 100)
						healths.icon_state = "health3"
					if(0 to 50)
						healths.icon_state = "health4"
					if(config.health_threshold_dead to 0)
						healths.icon_state = "health5"
					else
						healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

	if(syndicate && client)
		for(var/datum/mind/tra in traitors.current_antagonists)
			if(tra.current)
				// TODO: Update to new antagonist system.
				var/I = image('icons/mob/mob.dmi', loc = tra.current, icon_state = "traitor")
				client.images += I
		disconnect_from_ai()
		if(mind)
			// TODO: Update to new antagonist system.
			if(!mind.special_role)
				mind.special_role = "traitor"
				traitors.current_antagonists |= mind

	if(cells)
		if(cell)
			var/cellcharge = cell.charge / cell.maxcharge
			switch(cellcharge)
				if(0.75 to INFINITY)
					cells.icon_state = "charge4"
				if(0.5 to 0.75)
					cells.icon_state = "charge3"
				if(0.25 to 0.5)
					cells.icon_state = "charge2"
				if(0 to 0.25)
					cells.icon_state = "charge1"
				else
					cells.icon_state = "charge0"
		else
			cells.icon_state = "charge-empty"

	if(bodytemp)
		switch(bodytemperature) //310.055 optimal body temp
			if(335 to INFINITY)
				bodytemp.icon_state = "temp2"
			if(320 to 335)
				bodytemp.icon_state = "temp1"
			if(300 to 320)
				bodytemp.icon_state = "temp0"
			if(260 to 300)
				bodytemp.icon_state = "temp-1"
			else
				bodytemp.icon_state = "temp-2"

	if(stat != DEAD)
		if(blinded)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")
			set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
			set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)

		if (machine)
			if (machine.check_eye(src) < 0)
				reset_view(null)
		else
			if(client && !client.adminobs)
				reset_view(null)

	return TRUE

/mob/living/silicon/robot/proc/update_items()
	if(client)
		client.screen -= contents
		for(var/obj/I in contents)
			if(I && !(istype(I, /obj/item/cell) || istype(I, /obj/item/device/radio) || istype(I, /obj/machinery/camera) || istype(I, /obj/item/device/mmi)))
				client.screen += I
	if(module_state_1)
		module_state_1:screen_loc = ui_inv1
	if(module_state_2)
		module_state_2:screen_loc = ui_inv2
	if(module_state_3)
		module_state_3:screen_loc = ui_inv3
	update_icon()

/mob/living/silicon/robot/proc/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 0)
			if(client)
				to_chat(src, SPAN_DANGER("Killswitch Activated!"))
			killswitch = FALSE
			spawn(5)
				gib()

/mob/living/silicon/robot/proc/process_locks()
	if(weapon_lock)
		uneq_all()
		weapon_lock_time --
		if(weapon_lock_time <= 0)
			if(client)
				to_chat(src, SPAN_WARNING("Weapon Lock Timed Out!"))
			weapon_lock = FALSE
			weapon_lock_time = 120

/mob/living/silicon/robot/update_canmove()
	if(paralysis || stunned || weakened || buckled_to || lock_charge || !is_component_functioning("actuator"))
		canmove = FALSE
	else
		canmove = TRUE
	return canmove

/mob/living/silicon/robot/proc/process_level_restrictions()
	//Abort if they should not get blown
	if(lock_charge || scrambled_codes || emagged || current_map.allow_borgs_to_leave)
		return FALSE
	//Check if they are on a player level -> abort
	var/turf/T = get_turf(src)
	if(!T || isStationLevel(T.z))
		return FALSE
	//If they are on centcom -> abort
	if(istype(get_area(src), /area/centcom) || istype(get_area(src), /area/shuttle/escape) || istype(get_area(src), /area/shuttle/arrival))
		return FALSE
	if(!self_destructing)
		start_self_destruct(TRUE)
	return TRUE

/mob/living/silicon/robot/update_fire()
	cut_overlay(image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing"))
	if(on_fire)
		add_overlay(image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing"))

/mob/living/silicon/robot/fire_act()
	if(!on_fire) //Silicons don't gain stacks from hotspots, but hotspots can ignite them
		IgniteMob()