// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/light)

#define LIGHTING_POWER_FACTOR 40		//20W per unit luminosity
#define LIGHT_BULB_TEMPERATURE 400 //K - used value for a 60W bulb
// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube_empty"
	desc = "A lighting fixture."
	anchored = 1
	layer = 5  					// They were appearing under mobs which is a little weird - Ostaf
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	gfi_layer_rotation = GFI_ROTATION_DEFDIR
	var/brightness_range = 8	// luminosity when on, also used in power calculation
	var/brightness_power = 0.8
	var/night_brightness_range = 6
	var/night_brightness_power = 0.6
	var/supports_nightmode = TRUE
	var/nightmode = FALSE
	var/brightness_color = LIGHT_COLOR_HALOGEN
	uv_intensity = 255
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = 0
	var/light_type = /obj/item/light/tube		// the type of light item
	var/obj/item/light/inserted_light = /obj/item/light/tube
	var/fitting = "tube"
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode

	var/obj/item/cell/cell
	var/start_with_cell = TRUE	// if true, this fixture generates a very weak cell at roundstart
	var/emergency_mode = FALSE	// if true, the light is in emergency mode.
	var/no_emergency = FALSE	// if true, this light cannot enter emergency mode.

	var/bulb_is_noisy = TRUE

	var/previous_stat

/obj/machinery/light/skrell
	base_state = "skrell"
	icon_state = "skrell_empty"
	supports_nightmode = FALSE
	fitting= "skrell"
	bulb_is_noisy = FALSE
	light_type = /obj/item/light/tube
	inserted_light = /obj/item/light/tube
	brightness_power = 1
	brightness_color = LIGHT_COLOR_PURPLE

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	fitting = "bulb"
	brightness_range = 5
	brightness_power = 0.75
	brightness_color = LIGHT_COLOR_TUNGSTEN
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb
	inserted_light = /obj/item/light/bulb
	supports_nightmode = FALSE
	bulb_is_noisy = FALSE

/obj/machinery/light/small/emergency
	brightness_range = 6
	brightness_power = 1
	brightness_color = "#FA8282"//"#FF0000"

/obj/machinery/light/small/red
	brightness_range = 2.5
	brightness_power = 1
	brightness_color = LIGHT_COLOR_RED

/obj/machinery/light/colored/blue
	brightness_color = LIGHT_COLOR_BLUE

/obj/machinery/light/colored/red
	brightness_color = LIGHT_COLOR_RED

/obj/machinery/light/spot
	name = "spotlight"
	fitting = "large tube"
	light_type = /obj/item/light/tube/large
	inserted_light = /obj/item/light/tube/large
	brightness_range = 12
	brightness_power = 4
	supports_nightmode = FALSE

/obj/machinery/light/spot/weak
	name = "exterior spotlight"
	brightness_range = 12
	brightness_power = 1.2

/obj/machinery/light/built
	start_with_cell = FALSE

/obj/machinery/light/built/Initialize()
	status = LIGHT_EMPTY
	stat |= MAINT
	. = ..()

/obj/machinery/light/small/built/Initialize()
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

	if (mapload && loc && isNotAdminLevel(z))
		switch(fitting)
			if("tube")
				if(prob(2))
					broken(1)
			if("bulb")
				if(prob(5))
					broken(1)

	update(0)

/obj/machinery/light/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/machinery/light/update_icon()
	cut_overlays()
	icon_state = "[base_state]_empty"
	switch(status)		// set icon_states
		if(LIGHT_OK)
			var/target_color
			if (emergency_mode)
				target_color = LIGHT_COLOR_RED
			else
				target_color = brightness_color
				if (supports_nightmode && nightmode && !stat)
					target_color = BlendRGB("#d2d2d2", target_color, 0.25)

			var/on = emergency_mode || !stat

			add_overlay(LIGHT_FIXTURE_CACHE(icon, "[base_state][on]", target_color))

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
			use_power = 2
			active_power_usage = light_range * LIGHTING_POWER_FACTOR
			if (supports_nightmode && nightmode)
				set_light(night_brightness_range, night_brightness_power, brightness_color)
			else
				set_light(brightness_range, brightness_power, brightness_color)
	else if (has_emergency_power(LIGHT_EMERGENCY_POWER_USE) && !(stat & POWEROFF))
		use_power = 1
		emergency_mode = TRUE
		var/new_power = round(max(0.5, 0.75 * (cell.charge / cell.maxcharge)), 0.1)
		set_light(brightness_range * 0.25, new_power, LIGHT_COLOR_EMERGENCY)
	else
		use_power = 1
		set_light(0)

	update_icon()

	active_power_usage = ((light_range * light_power) * 10)

// ehh
/obj/machinery/light/machinery_process()
	if (cell && cell.charge != cell.maxcharge && has_power())
		cell.charge = min(cell.maxcharge, cell.charge + 0.2)
	if (emergency_mode && !use_emergency_power(LIGHT_EMERGENCY_POWER_USE))
		update(FALSE)

/obj/machinery/light/proc/has_emergency_power(pwr = LIGHT_EMERGENCY_POWER_USE)
	if (no_emergency | !cell)
		return FALSE
	if (pwr ? cell.charge >= pwr : cell.charge)
		return status == LIGHT_OK

/obj/machinery/light/proc/use_emergency_power(pwr = 0.2)
	if (!has_emergency_power(pwr))
		return FALSE
	if (cell.charge > 300)	//it's meant to handle 120 W, ya doofus
		visible_message("<span class='warning'>[src] short-circuits!</span>", "<span class='warning'>You hear glass breaking.</span>")
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
	if(status == LIGHT_EMPTY||status == LIGHT_BROKEN)
		to_chat(user, "That object is useless to you.")
		return
	if(!(status == LIGHT_OK||status == LIGHT_BURNED))
		return
	visible_message("<span class='danger'>[user] smashes the light!</span>")
	user.do_attack_animation(src)
	broken()
	return 1

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
			to_chat(user, "There is a [fitting] already inserted.")
			return
		else
			src.add_fingerprint(user)
			var/obj/item/light/L = W
			if(istype(L, light_type))
				status = L.status
				to_chat(user, "You insert the [L.name].")
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
				to_chat(user, "This type of light requires a [fitting].")
				return

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)
		if(prob(1+W.force * 5))

			to_chat(user, "You hit the light, and it smashes!")
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashes the light!", 3, "You hear a tinkle of breaking glass", 2)
			if(!stat && (W.flags & CONDUCT))
				//if(!user.mutations & COLD_RESISTANCE)
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			to_chat(user, "You hit the light!")

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(W.isscrewdriver()) //If it's a screwdriver open it.
			playsound(src.loc, W.usesound, 75, 1)
			user.visible_message("[user.name] opens [src]'s casing.", \
				"You open [src]'s casing.", "You hear a noise.")
			var/obj/machinery/light_construct/newlight = null
			switch(fitting)
				if("tube")
					newlight = new /obj/machinery/light_construct(src.loc)
					newlight.icon_state = "tube-construct-stage2"

				if("bulb")
					newlight = new /obj/machinery/light_construct/small(src.loc)
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

		to_chat(user, "You stick \the [W] into the light socket!")
		if(has_power() && (W.flags & CONDUCT))
			spark(src, 3)
			//if(!user.mutations & COLD_RESISTANCE)
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))


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
			playsound(src.loc, 'sound/effects/light_flicker.ogg', 75, 1)

/obj/machinery/light/proc/end_flicker()
	stat &= ~POWEROFF
	update(FALSE)
	flickering = FALSE

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	src.flicker(1)
	return

// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player
/obj/machinery/light/attack_hand(mob/user)

	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		to_chat(user, "There is no [fitting] in this light.")
		return

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			H.visible_message(
				"<span class='warning'>[user] smashes [src]!</span>",
				"<span class='warning'>You smash [src]!</span>",
				"<span class='notice'>You hear the tinkle of breaking glass.</span>"
			)
			broken()
			return

	// make it burn hands if not wearing fire-insulated gloves
	if(!stat)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))
			if(H.species.heat_level_1 > LIGHT_BULB_TEMPERATURE)
				prot = 1
			else if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature && G.max_heat_protection_temperature > LIGHT_BULB_TEMPERATURE)
					prot = 1
		else
			prot = 1

		if(prot || (COLD_RESISTANCE in user.mutations))
			to_chat(user, "You remove the light [fitting]")
		else
			to_chat(user, "You try to remove the light [fitting], but it's too hot and you don't want to burn your hand.")
			return				// if burned, don't remove the light
	else
		to_chat(user, "You remove the light [fitting].")

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
	if (!skip_sound_and_sparks)
		CHECK_TICK	// For lights-out events.

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
				broken()
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
	var/turf/T = get_turf(src.loc)
	broken()	// break it first to give a warning
	sleep(2)
	explosion(T, 0, 0, 2, 2)
	sleep(1)
	qdel(src)
