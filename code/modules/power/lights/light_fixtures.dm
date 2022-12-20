// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/light)

#define LIGHTING_POWER_FACTOR 40		//20W per unit luminosity
#define LIGHT_BULB_TEMPERATURE 400 //K - used value for a 60W bulb
// the standard tube light fixture
/obj/machinery/light
	name = "\improper LED light fixture"
	icon = 'icons/obj/lights.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube_example" // Set here for mapping, overriden in "update()".
	desc = "A lighting fixture."
	anchored = TRUE
	layer = 5  					// They were appearing under mobs which is a little weird - Ostaf
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	gfi_layer_rotation = GFI_ROTATION_DEFDIR
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
	var/switch_count = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/obj/item/cell/cell
	var/start_with_cell = TRUE	// if true, this fixture generates a very weak cell at roundstart
	var/emergency_mode = FALSE	// if true, the light is in emergency mode.
	var/no_emergency = FALSE	// if true, this light cannot enter emergency mode.

	var/next_spark = 0

	var/bulb_is_noisy = TRUE

	var/previous_stat
	var/randomize_color = TRUE
	var/default_color
	var/static/list/randomized_colors = LIGHT_STANDARD_COLORS
	var/static/list/emergency_lights = list(
		LIGHT_MODE_RED = LIGHT_COLOR_EMERGENCY,
		LIGHT_MODE_DELTA = LIGHT_COLOR_ORANGE
	)

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

	if(randomize_color)
		brightness_color = pick(randomized_colors)
	default_color = brightness_color // We need a different var so the new color doesn't get wiped away. Initial() wouldn't work since brightness_color is overridden.
	update(0)

/obj/machinery/light/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/machinery/light/update_icon()
	cut_overlays()
	icon_state = "[base_state]_empty"
	var/on = emergency_mode || !stat
	switch(status)		// set icon_states
		if(LIGHT_OK)
			var/target_color
			if(emergency_mode)
				target_color = LIGHT_COLOR_RED
			else
				target_color = brightness_color
				if (supports_nightmode && nightmode && !stat)
					target_color = BlendRGB("#D2D2D2", target_color, 0.25)

			if(on)
				var/image/I = LIGHT_FIXTURE_CACHE(icon, "[base_state]_on", target_color)
				I.layer = EFFECTS_ABOVE_LIGHTING_LAYER
				add_overlay(I)
			else if(!on)
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

	switch(status)
		if(LIGHT_OK)
			stat &= ~(MAINT|BROKEN)

		if(LIGHT_EMPTY)
			stat |= MAINT
			stat &= ~BROKEN

		if(LIGHT_BURNED)
			stat |= BROKEN
			stat &= ~MAINT

		if(LIGHT_BROKEN)
			stat |= BROKEN
			stat &= ~MAINT

	if(previous_stat != stat && !stat && bulb_is_noisy)
		playsound(loc, 'sound/effects/lighton.ogg', 65, 1)

	previous_stat = stat
	if(!stat)
		switch_count++
		if(prob(min(60, switch_count * switch_count * 0.01)))
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
	else if(has_emergency_power(LIGHT_EMERGENCY_POWER_USE) && !(stat & POWEROFF))
		update_use_power(POWER_USE_IDLE)
		emergency_mode = TRUE
		var/new_power = round(max(0.5, 0.75 * (cell.charge / cell.maxcharge)), 0.1)
		set_light(brightness_range * 0.25, new_power, LIGHT_COLOR_EMERGENCY)
	else
		update_use_power(POWER_USE_IDLE)
		set_light(0)

	update_icon()

	change_power_consumption((light_range * light_power) * 10, POWER_USE_ACTIVE)

/obj/machinery/light/proc/broken_sparks()
	if(world.time > next_spark && !(stat & POWEROFF) && has_power())
		spark(src, 3, alldirs)
		next_spark = world.time + 1 MINUTE + (rand(-15, 15) SECONDS)

/obj/machinery/light/process()
	if(cell && cell.charge != cell.maxcharge && has_power())
		cell.charge = min(cell.maxcharge, cell.charge + 0.2)
	if(emergency_mode && !use_emergency_power(LIGHT_EMERGENCY_POWER_USE))
		update(FALSE)
	if(status == LIGHT_BROKEN)
		broken_sparks()

/obj/machinery/light/proc/has_emergency_power(pwr = LIGHT_EMERGENCY_POWER_USE)
	if (no_emergency | !cell)
		return FALSE
	if (pwr ? cell.charge >= pwr : cell.charge)
		return status == LIGHT_OK

/obj/machinery/light/proc/use_emergency_power(pwr = 0.2)
	if(!has_emergency_power(pwr))
		return FALSE
	if(cell.charge > 300) // It's meant to handle 120 W, ya doofus.
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
	if(emergency_mode)
		return light_range != brightness_range * 0.25 || light_power != max(0.5, 0.75 * (cell.charge / cell.maxcharge)) || light_color != LIGHT_COLOR_EMERGENCY
	else if(supports_nightmode && nightmode)
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
		user.visible_message(
			SPAN_WARNING("\The [user] completely shatters \the [src]!"),
			SPAN_WARNING("You completely shatter \the [src]!")
		)
		shatter()
	else
		user.visible_message(
			SPAN_WARNING("\The [user] smashes \the [src]!"),
			SPAN_WARNING("You smash \the [src]!")
		)
		broken()
	user.do_attack_animation(src)
	return TRUE

// Examine.
/obj/machinery/light/examine(mob/user)
	. = ..()
	switch(status)
		if(LIGHT_OK)
			to_chat(user, "It is turned [!(stat & POWEROFF) ? "on" : "off"].")
		if(LIGHT_EMPTY)
			to_chat(user, "\The [fitting] is empty.")
		if(LIGHT_BURNED)
			to_chat(user, "\The [fitting] has burnt out.")
		if(LIGHT_BROKEN)
			to_chat(user, "\The [fitting] has broken.")
	if(cell)
		to_chat(user, "The underside of \the [src] indicates it has [round((cell.charge / cell.maxcharge) * 100, 0.1)]% power left.")

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
				switch_count = L.switch_count
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
			else
				to_chat(user, SPAN_WARNING("This type of light requires a [fitting]."))
				return

	// Attempt to break the light.
	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)
		smash_check(W, user, "smashes", "smashes", TRUE)
	else if(status == LIGHT_BROKEN)
		smash_check(W, user, "completely shatters", "shatters completely", FALSE)

	// Attempt to stick weapon into light socket.
	else if(status == LIGHT_EMPTY)
		if(W.isscrewdriver()) // If it's a screwdriver open it.
			playsound(get_turf(src), W.usesound, 75, 1)
			user.visible_message(
				SPAN_NOTICE("\The [user] opens \the [src]'s casing."),
				SPAN_NOTICE("You open \the [src]'s casing."),
				SPAN_NOTICE("You hear a noise.")
			)
			var/obj/machinery/light_construct/newlight = null
			switch(fitting)
				if("tube")
					newlight = new /obj/machinery/light_construct(get_turf(src))
					newlight.icon_state = "tube-construct-stage2"
				if("bulb")
					newlight = new /obj/machinery/light_construct/small(get_turf(src))
					newlight.icon_state = "bulb-construct-stage2"
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
		if(has_power() && (W.flags & CONDUCT))
			spark(src, 3)
			if(prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))

/obj/machinery/light/proc/smash_check(var/obj/O, var/mob/living/user, var/others_text, var/self_text, var/only_break)
	if(prob(1 + O.force * 5))
		user.visible_message(
			SPAN_WARNING("\The [user] [others_text] \the [src]!"),
			SPAN_WARNING("You hit \the [src], and it [self_text]!"),
			SPAN_WARNING("You hear a tinkle of breaking glass!")
		)
		if(!stat && (O.flags & CONDUCT))
			if(prob(12))
				electrocute_mob(user, get_area(src), src, 0.3)
		if(only_break)
			broken()
		else
			shatter()
	else
		user.visible_message(
			SPAN_WARNING("\The [user] hits \the [src], but it doesn't break."),
			SPAN_WARNING("You hit \the [src], but it doesn't break."),
			SPAN_WARNING("You hear something hitting against glass.")
		)

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
	var/thecallback = CALLBACK(src, .proc/handle_flicker)
	for (var/i = 0; i < amount; i++)
		addtimer(thecallback, offset)
		offset += rand(5, 15)

	addtimer(CALLBACK(src, .proc/end_flicker), offset)

/obj/machinery/light/proc/handle_flicker()
	if (status == LIGHT_OK)
		stat ^= POWEROFF
		update(FALSE)
		if (prob(50))
			playsound(get_turf(src), 'sound/effects/light_flicker.ogg', 75, 1)

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
/obj/machinery/light/attack_hand(mob/user)
	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		to_chat(user, SPAN_WARNING("There is no [fitting] in \the [src]."))
		return

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == I_HURT && H.species.can_shred(H))
			if(status != LIGHT_BROKEN || status != LIGHT_EMPTY)
				H.visible_message(
					SPAN_WARNING("\The [user] smashes \the [src]!"),
					SPAN_WARNING("You smash \the [src]!"),
					SPAN_WARNING("You hear the tinkle of breaking glass.")
				)
				broken()
				return
			else if(status == LIGHT_BROKEN)
				H.visible_message(
					SPAN_WARNING("\The [user] completely shatters \the [src]!"),
					SPAN_WARNING("You shatter \the [src] completely!"),
					SPAN_WARNING("You hear the tinkle of breaking glass.")
				)
				shatter()
				return

	// create a light tube/bulb item and put it in the user's hand
	if(inserted_light)
		var/obj/item/light/L = new inserted_light()
		L.status = status
		L.brightness_range = brightness_range
		L.brightness_power = brightness_power
		L.brightness_color = brightness_color

		// light item inherits the switch_count, then zero it
		L.switch_count = switch_count
		switch_count = 0

		L.update()
		L.add_fingerprint(user)

		user.put_in_active_hand(L)	//puts it in our active hand

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
	L.brightness_range = brightness_range
	L.brightness_power = brightness_power
	L.brightness_color = brightness_color

	// light item inherits the switch_count, then zero it
	L.switch_count = switch_count
	switch_count = 0

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

/obj/machinery/light/proc/broken(skip_sound_and_sparks = FALSE)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(get_turf(src), 'sound/effects/glass_hit.ogg', 75, 1)
		if(!stat)
			spark(src, 3)
	status = LIGHT_BROKEN
	stat |= BROKEN
	update()
	if (!skip_sound_and_sparks)
		CHECK_TICK	// For lights-out events.

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
	addtimer(CALLBACK(src, .proc/handle_power_change), rand(1, 2 SECONDS), TIMER_UNIQUE | TIMER_NO_HASH_WAIT)

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
	var/turf/T = get_turf(get_turf(src))
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

/********** Constructed Light Fixtures Start **********/
// Constructed Light Fixture
/obj/machinery/light/built
	start_with_cell = FALSE

/obj/machinery/light/built/Initialize()
	status = LIGHT_EMPTY
	stat |= MAINT
	. = ..()

// Constructed Small Light Fixture
/obj/machinery/light/small/built
	start_with_cell = FALSE

/obj/machinery/light/small/built/Initialize()
	status = LIGHT_EMPTY
	stat |= MAINT
	. = ..()
/********** Constructed Light Fixtures End **********/

/********** Light Fixtures Start **********/
// Light Fixture with Blue Light Tube
/obj/machinery/light/colored/blue
	brightness_color = LIGHT_COLOR_BLUE
	randomize_color = FALSE

// Light Fixture with Red Light Tube
/obj/machinery/light/colored/red
	brightness_color = LIGHT_COLOR_RED
	randomize_color = FALSE

// Spotlight Fixture
/obj/machinery/light/spot
	name = "\improper LED spotlight fixture"
	fitting = "large tube"
	light_type = /obj/item/light/tube/large
	inserted_light = /obj/item/light/tube/large
	brightness_range = 12
	brightness_power = 3.5
	supports_nightmode = FALSE

// Weak Spotlight Fixture
/obj/machinery/light/spot/weak
	name = "low-intensity spotlight"
	brightness_range = 12
	brightness_power = 1.2

// Skrell Light Fixture
/obj/machinery/light/skrell
	base_state = "skrell"
	icon_state = "skrell_empty"
	supports_nightmode = FALSE
	fitting= "skrell"
	bulb_is_noisy = FALSE
	light_type = /obj/item/light/tube
	inserted_light = /obj/item/light/tube
	brightness_power = 0.45
	brightness_color = LIGHT_COLOR_PURPLE
/********** Light Fixtures End **********/

/********** Small Light Fixtures Start **********/
// Small Light
/obj/machinery/light/small
	name = "small LED light fixture"
	desc = "A small light fixture."
	icon_state = "bulb_example"
	base_state = "bulb"
	fitting = "bulb"
	brightness_range = 5
	brightness_power = 0.45
	brightness_color = LIGHT_COLOR_TUNGSTEN
	light_type = /obj/item/light/bulb
	inserted_light = /obj/item/light/bulb
	supports_nightmode = FALSE
	bulb_is_noisy = FALSE

/obj/machinery/light/small/emergency
	brightness_range = 6
	brightness_power = 0.45
	brightness_color = LIGHT_COLOR_EMERGENCY_SOFT
	randomize_color = FALSE
/********** Small Light Fixtures End **********/