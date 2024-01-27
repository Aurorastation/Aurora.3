// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/light)

#define LIGHTING_POWER_FACTOR 40		//20W per unit luminosity
// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/machinery/light.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube_empty"
	desc = "A lighting fixture."
	desc_info = "Use grab intent when interacting with a working light to take it out of its fixture."
	anchored = TRUE
	layer = 5  					// They were appearing under mobs which is a little weird - Ostaf
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	gfi_layer_rotation = GFI_ROTATION_DEFDIR
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/brightness_range = 8	// luminosity when on, also used in power calculation
	var/brightness_power = 0.45
	var/night_brightness_range = 6
	var/night_brightness_power = 0.4
	var/supports_nightmode = TRUE
	var/nightmode = FALSE
	var/brightness_color = LIGHT_COLOR_HALOGEN
	uv_intensity = 255
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = 0
	var/light_type = /obj/item/light/tube		// the type of light item
	var/obj/item/light/inserted_light = /obj/item/light/tube
	var/fitting = "tube"
	var/must_start_working = FALSE // Whether the bulb can break during Initialize or not
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode

	var/obj/item/cell/cell
	var/start_with_cell = TRUE	// if true, this fixture generates a very weak cell at roundstart
	var/emergency_mode = FALSE	// if true, the light is in emergency mode.
	var/no_emergency = FALSE	// if true, this light cannot enter emergency mode.

	var/next_spark = 0

	var/bulb_is_noisy = TRUE

	var/fitting_has_empty_icon = FALSE
	var/fitting_is_on_floor = FALSE

	var/previous_stat
	var/randomize_color = TRUE
	var/default_color
	var/static/list/randomized_colors = LIGHT_STANDARD_COLORS
	var/static/list/emergency_lights = list(
		LIGHT_MODE_RED = LIGHT_COLOR_EMERGENCY,
		LIGHT_MODE_DELTA = LIGHT_COLOR_ORANGE
	)
	init_flags = 0

/obj/machinery/light/skrell
	base_state = "skrell"
	icon_state = "skrell_empty"
	supports_nightmode = FALSE
	fitting = "skrell"
	bulb_is_noisy = FALSE
	light_type = /obj/item/light/tube
	inserted_light = /obj/item/light/tube
	brightness_power = 0.45
	brightness_color = LIGHT_COLOR_PURPLE

/obj/machinery/light/floor
	name = "floor lighting fixture"
	icon_state = "floortube_example"
	base_state = "floortube"
	desc = "A lighting fixture. This one is set into the floor."
	layer = 2.5
	fitting_has_empty_icon = TRUE
	fitting_is_on_floor = TRUE

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb_empty"
	base_state = "bulb"
	fitting = "bulb"
	brightness_range = 5
	brightness_power = 0.45
	brightness_color = LIGHT_COLOR_TUNGSTEN
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb
	inserted_light = /obj/item/light/bulb
	supports_nightmode = FALSE
	bulb_is_noisy = FALSE

/obj/machinery/light/small/floor
	name = "small floor lighting fixture"
	icon_state = "floor_example"
	base_state = "floor"
	desc = "A small lighting fixture. This one is set into the floor."
	layer = 2.5
	fitting_is_on_floor = TRUE

/obj/machinery/light/small/emergency
	brightness_range = 6
	brightness_power = 0.45
	brightness_color = LIGHT_COLOR_EMERGENCY_SOFT
	randomize_color = FALSE

/obj/machinery/light/small/red
	brightness_range = 2.5
	brightness_power = 0.45
	brightness_color = LIGHT_COLOR_RED
	randomize_color = FALSE

/obj/machinery/light/colored/blue
	brightness_color = LIGHT_COLOR_BLUE
	randomize_color = FALSE

/obj/machinery/light/colored/red
	brightness_color = LIGHT_COLOR_RED
	randomize_color = FALSE

/obj/machinery/light/colored/decayed
	brightness_color = LIGHT_COLOR_DECAYED
	randomize_color = FALSE

/obj/machinery/light/colored/dying
	brightness_color = LIGHT_COLOR_DYING
	randomize_color = FALSE

/obj/machinery/light/broken
	status = LIGHT_BROKEN

/obj/machinery/light/spot
	name = "spotlight fixture"
	icon_state = "tube_empty"
	desc = "An extremely powerful lighting fixture."
	fitting = "large tube"
	light_type = /obj/item/light/tube/large
	inserted_light = /obj/item/light/tube/large
	brightness_range = 12
	brightness_power = 3.5
	supports_nightmode = FALSE

/obj/machinery/light/built
	start_with_cell = FALSE

/obj/machinery/light/built/Initialize()
	status = LIGHT_EMPTY
	stat |= MAINT
	. = ..()

/obj/machinery/light/floor/built/Initialize()
	status = LIGHT_EMPTY
	stat |= MAINT
	. = ..()

/obj/machinery/light/small/built/Initialize()
	status = LIGHT_EMPTY
	stat |= MAINT
	. = ..()

/obj/machinery/light/small/floor/built/Initialize()
	status = LIGHT_EMPTY
	stat |= MAINT
	. = ..()

/obj/machinery/light/spot/built/Initialize()
	status = LIGHT_EMPTY
	stat |= MAINT
	. = ..()

// create a new lighting fixture
/obj/machinery/light/Initialize(mapload)
	. = ..()

	if (!has_power())
		stat |= NOPOWER
	if (start_with_cell && !no_emergency)
		cell = new /obj/item/cell/device/emergency_light(src)

	if (!must_start_working && mapload && loc && isNotAdminLevel(z))
		switch(fitting)
			if("tube")
				if(prob(2))
					broken(1)
			if("bulb")
				if(prob(5))
					broken(1)
			if("large tube")
				if(prob(1))
					broken(1)

	if(randomize_color)
		brightness_color = pick(randomized_colors)
	default_color = brightness_color // We need a different var so the new color doesn't get wiped away. Initial() wouldn't work since brightness_color is overridden.
	update(0)
	set_pixel_offsets()

/obj/machinery/light/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/machinery/light/set_pixel_offsets()
	pixel_x = dir & (NORTH|SOUTH) ? 0 : (dir == EAST ? 12 : -12)
	pixel_y = dir & (NORTH|SOUTH) ? (dir == NORTH ? DEFAULT_WALL_OFFSET : -2) : 0

/obj/machinery/light/small/set_pixel_offsets()
	pixel_x = dir & (NORTH|SOUTH) ? 0 : (dir == EAST ? 12 : -12)
	pixel_y = dir & (NORTH|SOUTH) ? (dir == NORTH ? DEFAULT_WALL_OFFSET : -22) : 0

/obj/machinery/light/floor/set_pixel_offsets()
	pixel_x = pixel_x
	pixel_y = pixel_y

/obj/machinery/light/update_icon()
	cut_overlays()
	if ((status == LIGHT_EMPTY) || !fitting_has_empty_icon)
		icon_state = "[base_state]_empty"
	else
		icon_state = "[base_state]"
	var/on = emergency_mode || !stat
	switch(status)		// set icon_states
		if(LIGHT_OK)
			var/target_color
			if (emergency_mode)
				target_color = LIGHT_COLOR_RED
			else
				target_color = brightness_color
				if (supports_nightmode && nightmode && !stat)
					target_color = BlendRGB("#D2D2D2", target_color, 0.25)

			if (on)
				var/image/I = LIGHT_FIXTURE_CACHE(icon, "[base_state]_on", target_color)
				if (!fitting_is_on_floor)
					I.layer = EFFECTS_ABOVE_LIGHTING_LAYER
				else
					I.layer = layer
				add_overlay(I)
			else
				add_overlay(LIGHT_FIXTURE_CACHE(icon, "[base_state]_off", target_color))

		if(LIGHT_BURNED)
			add_overlay(LIGHT_FIXTURE_CACHE(icon, "[base_state]_burned", brightness_color))
			stat |= BROKEN
			stat &= ~MAINT

		if(LIGHT_BROKEN)
			add_overlay(LIGHT_FIXTURE_CACHE(icon, "[base_state]_broken", brightness_color))
			stat |= BROKEN
			stat &= ~MAINT

// update the icon_state and luminosity of the light depending on its state
/obj/machinery/light/proc/update(var/trigger = 1)
	emergency_mode = FALSE

	switch (status)
		if(LIGHT_OK)
			stat &= ~(MAINT|BROKEN)

		if(LIGHT_EMPTY)
			stat |= MAINT
			stat &= ~BROKEN

		if (LIGHT_BURNED)
			stat |= BROKEN
			stat &= ~MAINT

		if (LIGHT_BROKEN)
			stat |= BROKEN
			stat &= ~MAINT

	if (previous_stat != stat && !stat && bulb_is_noisy)
		playsound(loc, 'sound/effects/lighton.ogg', 65, 1)

	previous_stat = stat
	if(!stat)
		switchcount++
		if(rigged)
			if(status == LIGHT_OK && trigger)
				log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
				message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")
				explode()

		else if( prob( min(60, switchcount*switchcount*0.01) ) )
			if(status == LIGHT_OK && trigger)
				status = LIGHT_BURNED
				stat |= BROKEN
				set_light(0)
		else
			update_use_power(POWER_USE_ACTIVE)
			change_power_consumption(light_range * LIGHTING_POWER_FACTOR, POWER_USE_ACTIVE)
			if (supports_nightmode && nightmode)
				set_light(night_brightness_range, night_brightness_power, brightness_color)
			else
				set_light(brightness_range, brightness_power, brightness_color)
	else if (has_emergency_power(LIGHT_EMERGENCY_POWER_USE) && !(stat & POWEROFF))
		update_use_power(POWER_USE_IDLE)
		emergency_mode = TRUE
		var/new_power = round(max(0.5, 0.75 * (cell.charge / cell.maxcharge)), 0.1)
		set_light(brightness_range * 0.25, new_power, LIGHT_COLOR_EMERGENCY)
	else
		update_use_power(POWER_USE_IDLE)
		set_light(0)

	update_icon()

	change_power_consumption((light_range * light_power) * 10, POWER_USE_ACTIVE)

	if((status == LIGHT_BROKEN) || emergency_mode || (cell && !cell.fully_charged() && has_power()))
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	else if(processing_flags)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/light/proc/broken_sparks()
	if(world.time > next_spark && !(stat & POWEROFF) && has_power())
		spark(src, 3, GLOB.alldirs)
		next_spark = world.time + 1 MINUTE + (rand(-15, 15) SECONDS)

// ehh
/obj/machinery/light/process(seconds_per_tick)
	if (cell && has_power())
		cell.give(0.2 * seconds_per_tick)
		if(cell.fully_charged())
			return PROCESS_KILL
	if (emergency_mode && !use_emergency_power(LIGHT_EMERGENCY_POWER_USE))
		update(FALSE)
		return PROCESS_KILL
	if(status == LIGHT_BROKEN)
		broken_sparks()

/obj/machinery/light/proc/has_emergency_power(pwr = LIGHT_EMERGENCY_POWER_USE)
	if (no_emergency | !cell)
		return FALSE
	if (pwr ? cell.charge >= pwr : cell.charge)
		return status == LIGHT_OK

/obj/machinery/light/proc/use_emergency_power(pwr = 0.2)
	if (!has_emergency_power(pwr))
		return FALSE
	if (cell.charge > 300)	//it's meant to handle 120 W, ya doofus
		visible_message(SPAN_WARNING("\The [src] short-circuits!"), SPAN_WARNING("You hear glass breaking."))
		broken()
		return FALSE
	cell.use(pwr)
	// Hopefully this doesn't cause too many lighting updates.
	var/new_power = round(max(0.5, 0.75 * (cell.charge / cell.maxcharge)), 0.1)
	if (!IsAboutEqual(light_power, new_power))
		set_light(l_power = new_power)
	return TRUE

/obj/machinery/light/proc/check_update()
	if (emergency_mode)
		return light_range != brightness_range * 0.25 || light_power != max(0.5, 0.75 * (cell.charge / cell.maxcharge)) || light_color != LIGHT_COLOR_EMERGENCY
	else if (supports_nightmode && nightmode)
		return light_range != night_brightness_range || light_power != night_brightness_power || light_color != brightness_color
	else
		return light_range != brightness_range || light_power != brightness_power || light_color != brightness_color

/obj/machinery/light/attack_generic(var/mob/user, var/damage)
	if(!damage)
		return
	if(status == LIGHT_EMPTY)
		to_chat(user, SPAN_WARNING("\The [src] is useless to you."))
		return
	if(!(status == LIGHT_OK || status == LIGHT_BURNED))
		return
	if(status == LIGHT_BROKEN)
		user.visible_message(SPAN_WARNING("\The [user] completely shatters \the [src]!"), SPAN_WARNING("You completely shatter \the [src]!"))
		shatter()
	else
		user.visible_message(SPAN_WARNING("\The [user] smashes \the [src]!"), SPAN_WARNING("You smash \the [src]!"))
		broken()
	user.do_attack_animation(src)
	return TRUE

// examine verb
/obj/machinery/light/examine(mob/user)
	. = ..()
	switch(status)
		if(LIGHT_OK)
			to_chat(user, "It is turned [!(stat & POWEROFF) ? "on" : "off"].")
		if(LIGHT_EMPTY)
			to_chat(user, "\The [fitting] has been removed.")
		if(LIGHT_BURNED)
			to_chat(user, "\The [fitting] is burnt out.")
		if(LIGHT_BROKEN)
			to_chat(user, "\The [fitting] has been smashed.")
	if(cell)
		to_chat(user, "The charge meter reads [round((cell.charge / cell.maxcharge) * 100, 0.1)]%.")

// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/attackby(obj/item/W, mob/user)
	//Light replacer code
	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			LR.ReplaceLight(src, U)
			return

	// attempt to insert light
	if(istype(W, /obj/item/light))
		if(status != LIGHT_EMPTY)
			to_chat(user, SPAN_WARNING("There's already a [fitting] inserted."))
			return
		else
			src.add_fingerprint(user)
			var/obj/item/light/L = W
			if(istype(L, light_type))
				status = L.status
				to_chat(user, SPAN_NOTICE("You insert \the [L]."))
				switchcount = L.switchcount
				rigged = L.rigged
				brightness_range = L.brightness_range
				brightness_power = L.brightness_power
				brightness_color = L.brightness_color
				inserted_light = L.type
				if (!has_power())
					stat |= NOPOWER
				else
					stat &= ~NOPOWER

				update()

				user.drop_from_inventory(L,get_turf(src))
				qdel(L)

				if(!stat && rigged)
					log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
					message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

					explode()
			else
				to_chat(user, SPAN_WARNING("This type of light requires a [fitting]."))
				return

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)
		smash_check(W, user, "smashes", "smashes", TRUE)
	else if(status == LIGHT_BROKEN)
		smash_check(W, user, "completely shatters", "shatters completely", FALSE)

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(W.isscrewdriver()) //If it's a screwdriver open it.
			playsound(get_turf(src), W.usesound, 75, 1)
			user.visible_message(SPAN_NOTICE("\The [user] opens \the [src]'s casing."), SPAN_NOTICE("You open \the [src]'s casing."), SPAN_NOTICE("You hear a noise."))
			var/obj/machinery/light_construct/newlight = null
			switch(fitting)
				if("tube")
					newlight = new /obj/machinery/light_construct(get_turf(src))
					newlight.icon_state = "tube-construct-stage2"

				if("bulb")
					newlight = new /obj/machinery/light_construct/small(get_turf(src))
					newlight.icon_state = "bulb-construct-stage2"

				if("large tube")
					newlight = new /obj/machinery/light_construct/spot(get_turf(src))
					newlight.icon_state = "slight-construct-stage2"
			newlight.dir = src.dir
			newlight.stage = 2
			newlight.fingerprints = src.fingerprints
			newlight.fingerprintshidden = src.fingerprintshidden
			newlight.fingerprintslast = src.fingerprintslast
			if(cell)
				newlight.cell = cell
				cell.forceMove(newlight)
				cell = null
			qdel(src)
			return

		to_chat(user, SPAN_WARNING("You stick \the [W] into the light socket!"))
		if(has_power() && (W.obj_flags & OBJ_FLAG_CONDUCTABLE))
			spark(src, 3)
			if(prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))

/obj/machinery/light/proc/smash_check(var/obj/O, var/mob/living/user, var/others_text, var/self_text, var/only_break)
	if(prob(1 + O.force * 5))
		user.visible_message(SPAN_WARNING("\The [user] [others_text] \the [src]!"), SPAN_WARNING("You hit \the [src], and it [self_text]!"), SPAN_WARNING("You hear a tinkle of breaking glass!"))
		if(!stat && (O.obj_flags & OBJ_FLAG_CONDUCTABLE))
			if(prob(12))
				electrocute_mob(user, get_area(src), src, 0.3)
		if(only_break)
			broken()
		else
			shatter()
	else
		user.visible_message(SPAN_WARNING("\The [user] hits \the [src], but it doesn't break."), SPAN_WARNING("You hit \the [src], but it doesn't break."), SPAN_WARNING("You hear something hitting against glass."))

/obj/machinery/light/bullet_act(obj/item/projectile/P, def_zone)
	bullet_ping(P)
	shatter()

// returns whether this light has power
// true if area has power
/obj/machinery/light/proc/has_power()
	var/area/A = get_area(src)
	return A && (!A.requires_power || A.power_light)

/obj/machinery/light/proc/flicker(amount = rand(10,20))
	set waitfor = FALSE
	if (flickering || stat || status != LIGHT_OK)
		return

	flickering = TRUE
	var/offset = 1
	var/thecallback = CALLBACK(src, PROC_REF(handle_flicker))
	for (var/i = 0; i < amount; i++)
		addtimer(thecallback, offset)
		offset += rand(5, 15)

	addtimer(CALLBACK(src, PROC_REF(end_flicker)), offset)

/obj/machinery/light/proc/handle_flicker()
	if (status == LIGHT_OK)
		stat ^= POWEROFF
		update(FALSE)
		if (prob(50))
			playsound(src.loc, 'sound/effects/light_flicker.ogg', 75, 1)

/obj/machinery/light/proc/end_flicker()
	stat &= ~POWEROFF
	update(FALSE)
	flickering = FALSE

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	src.flicker(1)
	return

// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player
/obj/machinery/light/attack_hand(mob/user)
	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		to_chat(user, SPAN_WARNING("There is no [fitting] in \the [src]."))
		return

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == I_HURT && H.species.can_shred(H))
			if(status != LIGHT_BROKEN || status != LIGHT_EMPTY)
				H.visible_message(SPAN_WARNING("\The [user] smashes \the [src]!"), SPAN_WARNING("You smash \the [src]!"), SPAN_WARNING("You hear the tinkle of breaking glass."))
				broken()
				return
			else if(status == LIGHT_BROKEN)
				H.visible_message(SPAN_WARNING("\The [user] completely shatters \the [src]!"), SPAN_WARNING("You shatter \the [src] completely!"), SPAN_WARNING("You hear the tinkle of breaking glass."))
				shatter()
				return

	if(user.a_intent != I_GRAB && status == LIGHT_OK)
		return

	// create a light tube/bulb item and put it in the user's hand
	if(inserted_light)
		var/obj/item/light/L = new inserted_light()
		L.status = status
		L.rigged = rigged
		L.brightness_range = brightness_range
		L.brightness_power = brightness_power
		L.brightness_color = brightness_color

		// light item inherits the switchcount, then zero it
		L.switchcount = switchcount
		switchcount = 0

		L.update()
		L.add_fingerprint(user)

		user.put_in_active_hand(L)	//puts it in our active hand

		to_chat(user, SPAN_NOTICE("You remove the light [fitting]."))

		inserted_light = null

		status = LIGHT_EMPTY
		stat |= MAINT
		update()

/obj/machinery/light/do_simple_ranged_interaction(var/mob/user)
	if(status == LIGHT_EMPTY)
		to_chat(user, "There is no [fitting] in this light.")
		return

	to_chat(user, "You telekinetically remove the light [fitting].")
	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/light/L = new inserted_light()
	L.status = status
	L.rigged = rigged
	L.brightness_range = brightness_range
	L.brightness_power = brightness_power
	L.brightness_color = brightness_color

	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0

	L.update()
	L.add_fingerprint(user)
	L.forceMove(loc)

	inserted_light = null

	status = LIGHT_EMPTY
	update()

/obj/machinery/light/attack_ghost(mob/user)
	if(round_is_spooky())
		flicker(rand(2,5))
	else
		return ..()

// break the light and make sparks if was on

/obj/machinery/light/proc/broken(skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src.loc, 'sound/effects/glass_hit.ogg', 75, 1)
		if(!stat)
			spark(src, 3)
	status = LIGHT_BROKEN
	stat |= BROKEN
	update()

/obj/machinery/light/proc/shatter()
	if(status == LIGHT_EMPTY)
		return
	status = LIGHT_EMPTY
	stat |= BROKEN
	update()
	playsound(get_turf(src), 'sound/effects/glass_hit.ogg', 75, TRUE)
	new /obj/item/material/shard(get_turf(src))

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	update()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(75))
				shatter()
		if(3.0)
			if (prob(50))
				broken()
	return

// called when area power state changes
/obj/machinery/light/power_change()
	SHOULD_CALL_PARENT(FALSE)
	addtimer(CALLBACK(src, PROC_REF(handle_power_change)), rand(1, 2 SECONDS), TIMER_UNIQUE | TIMER_NO_HASH_WAIT)

/obj/machinery/light/proc/handle_power_change()
	if (has_power())
		stat &= ~NOPOWER
	else
		stat |= NOPOWER

	update()

// called when on fire

/obj/machinery/light/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

// explode the light

/obj/machinery/light/proc/explode()
	set waitfor = FALSE
	var/turf/T = get_turf(src.loc)
	broken()	// break it first to give a warning
	sleep(2)
	explosion(T, 0, 0, 2, 2)
	sleep(1)
	qdel(src)

/obj/machinery/light/set_emergency_state(var/new_security_level)
	var/area/A = get_area(src)
	if(new_security_level in emergency_lights)
		if(A.emergency_lights)
			brightness_color = emergency_lights[new_security_level]
			update(0)
	else
		if(brightness_color != default_color)
			brightness_color = default_color
			update(0)
