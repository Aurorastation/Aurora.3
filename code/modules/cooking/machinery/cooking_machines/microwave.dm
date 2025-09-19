#define NOT_BROKEN			0
#define SCREWDRIVER_BROKEN	1
#define WRENCH_BROKEN		2

/obj/machinery/appliance/cooker/microwave
	name = "microwave"
	desc = "A possibly occult device capable of perfectly preparing many types of food."
	icon_state = "mw"

	cook_type = "microwaved"
	appliancetype = MICROWAVE
	can_burn_food = TRUE

	food_color = COLOR_GRAY

	active_power_usage = 2 KILO WATTS
	idle_power_usage = 0
	heating_power = 6000

	finish_verb = null
	cooked_sound = null

	///Looping sound for the microwave
	var/datum/looping_sound/microwave/microwave_loop

	/// Becomes dirty when a wrong recipe is inputted or something burns
	var/dirtiness = FALSE
	/// If above 0, the microwave is broken and can't be used
	var/broken = NOT_BROKEN
	/// Multiplier for break chance
	var/break_multiplier = 1.0

	starts_with = list(
		/obj/item/reagent_containers/cooking_container/microwave_plate
	)

	var/active_timer_hash
	var/operating = FALSE

/obj/machinery/appliance/cooker/microwave/Initialize()
	. = ..()
	microwave_loop = new(src)
	temp_options = list()
	for(var/newtime = 1 to 6)
		var/image/disp_image = image('icons/mob/screen/radial.dmi', "radial_time")
		var/hue = RotateHue(hsv(0, 255, 255), 120 * (1 - (newtime-5)/(6)))
		disp_image.color = HSVtoRGB(hue)
		temp_options["[30 * newtime]"] = disp_image

/obj/machinery/appliance/cooker/microwave/Destroy()
	QDEL_NULL(microwave_loop)
	. = ..()

/obj/machinery/appliance/cooker/microwave/has_space(obj/item/item)
	if(istype(item, /obj/item/reagent_containers/cooking_container))
		if(length(cooking_objs) < max_contents)
			return TRUE
	else
		if(length(cooking_objs))
			var/datum/cooking_item/cooking_item = cooking_objs[1]
			var/obj/item/reagent_containers/cooking_container/microwave_plate/plate = cooking_item.container
			if(plate?.can_fit(item))
				return cooking_item
	return FALSE

/obj/machinery/appliance/cooker/microwave/attackby(obj/item/O, mob/living/user, list/click_params)
	if (broken)
		// Start repairs by using a screwdriver
		if(broken == SCREWDRIVER_BROKEN && O.isscrewdriver())
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts to fix part of \the [src]."), \
				SPAN_NOTICE("You start to fix part of \the [src].") \
			)
			if (O.use_tool(src, user, 2 SECONDS, volume = 50))
				user.visible_message( \
					SPAN_NOTICE("\The [user] fixes part of \the [src]."), \
					SPAN_NOTICE("You have fixed part of \the [src].") \
				)
				broken = WRENCH_BROKEN // Fix it a bit
			return TRUE

		// Finish repairs using a wrench
		if (broken == WRENCH_BROKEN && O.iswrench())
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts to fix part of \the [src]."), \
				SPAN_NOTICE("You start to fix part of \the [src].") \
			)
			if (O.use_tool(src, user, 2 SECONDS, volume = 50))
				user.visible_message( \
					SPAN_NOTICE("\The [user] fixes \the [src]."), \
					SPAN_NOTICE("You have fixed \the [src].") \
				)
				broken = NOT_BROKEN // Fix it!
				update_icon()
				atom_flags = ATOM_FLAG_OPEN_CONTAINER
			return TRUE

		// Otherwise, we can't add anything to the micrwoave
		else
			to_chat(user, SPAN_WARNING("It's broken, and this isn't the right way to fix it!"))
			return TRUE

	if(dirtiness) // The microwave is all dirty, so it can't be used!
		var/has_rag = istype(O, /obj/item/reagent_containers/glass/rag)
		var/has_cleaner = O.reagents != null && O.reagents.has_reagent(/singleton/reagent/spacecleaner, 5)
		if (has_rag || has_cleaner)
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts to clean \the [src]."), \
				SPAN_NOTICE("You start to clean \the [src].") \
			)
			if (do_after(user, 2 SECONDS, src, DO_UNIQUE))
				user.visible_message( \
					SPAN_NOTICE("\The [user] has cleaned \the [src]."), \
					SPAN_NOTICE("You clean out \the [src].") \
				)

				// You can use a rag to wipe down the inside of the microwave
				// Otherwise, you'll need some space cleaner
				if (!has_rag)
					O.reagents.remove_reagent(/singleton/reagent/spacecleaner, 5)
					playsound(loc, 'sound/effects/spray2.ogg', 50, 1, -6)

				dirtiness = FALSE // It's clean!
				broken = NOT_BROKEN // just to be sure
				update_icon()
				atom_flags = ATOM_FLAG_OPEN_CONTAINER
			return TRUE

		// Otherwise, bad luck!
		else
			to_chat(user, SPAN_WARNING("You need to clean \the [src] before you use it!"))
			return TRUE
	return ..()

/obj/machinery/appliance/cooker/microwave/RefreshParts()
	..()
	var/laser_rating = 0
	for(var/obj/item/stock_parts/micro_laser/ML)
		laser_rating += ML.rating
	heating_power = initial(heating_power) + clamp(laser_rating, 1, 5) * 150

	var/mb_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB)
		mb_rating += MB.rating
	break_multiplier = 1 / clamp((mb_rating), 1, 3)

/obj/machinery/appliance/cooker/microwave/update_cooking_power()
	if(!operating)
		cooking_power = 0
		return
	..()

/obj/machinery/appliance/cooker/microwave/attempt_toggle_power(mob/user)
	if (use_check_and_message(user, issilicon(user) ? USE_ALLOW_NON_ADJACENT : 0))
		return

	if (broken)
		to_chat(user, SPAN_WARNING("[src] is very broken. You'll need to fix it before you can use it again."))
		return
	else if (dirtiness)
		to_chat(user, SPAN_WARNING("[src] is covered in muck. You'll need to wipe it down or clean it out before you can use it again."))
		return

	if (operating)
		operating = FALSE
		temperature = T20C
		update_use_power(POWER_USE_OFF)
	else
		var/desired_time = show_radial_menu(user, src, temp_options, require_near = TRUE, tooltips = TRUE, no_repeat_close = TRUE)
		if(!desired_time)
			return
		set_temp = optimal_temp
		temperature = optimal_temp
		operating = TRUE
		update_use_power(POWER_USE_ACTIVE)
		addtimer(CALLBACK(src, PROC_REF(turn_off)), text2num(desired_time) SECONDS, TIMER_STOPPABLE)

	activation_message(user)
	cooking = use_power
	update_icon()

/obj/machinery/appliance/cooker/microwave/can_remove_items(mob/user)
	return !use_check_and_message(user) && !operating

/obj/machinery/appliance/cooker/microwave/proc/turn_off()
	if(active_timer_hash)
		deltimer(active_timer_hash)
		active_timer_hash = null
	operating = FALSE
	temperature = T20C
	update_use_power(POWER_USE_OFF)
	audible_message(SPAN_NOTICE("<b>[src]</b> pings!"))
	update_icon()

/obj/machinery/appliance/cooker/microwave/burn_food(datum/cooking_item/cooking_item)
	..()
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
	visible_message(SPAN_WARNING("Muck splatters over the inside of \the [src]!"))
	dirtiness = TRUE // Make it dirty so it can't be used until cleaned
	broke()
	update_icon()

/obj/machinery/appliance/cooker/microwave/proc/broke()
	spark(loc, 2, GLOB.alldirs)
	playsound(loc, /singleton/sound_category/spark_sound, 50, 1)
	if (prob(100 * break_multiplier))
		visible_message(SPAN_WARNING("\The [src] sputters and grinds to a halt!")) //Let them know they're stupid
		broken = WRENCH_BROKEN // Make it broken so it can't be used until fixed
		turn_off()

/obj/machinery/appliance/cooker/microwave/add_content(obj/item/I, mob/user)
	. = ..()
	flick("mwo", src)
	playsound(src, 'sound/machines/microwave/microwave-start.ogg', 50, TRUE)

/obj/machinery/appliance/cooker/microwave/update_icon()
	..()
	ClearOverlays()
	icon_state = initial(icon_state)
	update_microwaving_audio()
	if(operating)
		var/image/mwclosed_on = image(icon, "mw_on")
		if(!dirtiness)
			mwclosed_on.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		AddOverlays(mwclosed_on)
	if(dirtiness)
		if(broken)
			AddOverlays(image(icon, "mwbloodyo"))
		else
			AddOverlays(image(icon, "mwbloody"))
	if(broken)
		icon_state = "mwb"

/obj/machinery/appliance/cooker/microwave/proc/update_microwaving_audio()
	if(!microwave_loop)
		return
	if(use_power)
		microwave_loop.start()
	else
		microwave_loop.stop()

/obj/machinery/appliance/cooker/microwave/condition_hints(mob/user, distance, is_adjacent)
	. = ..()
	if(broken)
		. += SPAN_WARNING("\The [src] is very broken. You'll need to fix it before you can use it again.")
	else if (dirtiness)
		. += SPAN_WARNING("\The [src] is covered in muck. You'll need to wipe it down or clean it out before you can use it again.")

#undef NOT_BROKEN
#undef SCREWDRIVER_BROKEN
#undef WRENCH_BROKEN
