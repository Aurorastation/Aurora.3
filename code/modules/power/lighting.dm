// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/weapon/light)

#define LIGHTING_POWER_FACTOR 40		//20W per unit luminosity
#define LIGHT_BULB_TEMPERATURE 400 //K - used value for a 60W bulb

/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
	layer = 5
	var/stage = 1
	var/fixture_type = "tube"
	var/sheets_refunded = 2
	var/obj/machinery/light/newlight = null

/obj/machinery/light_construct/New()
	..()
	if (fixture_type == "bulb")
		icon_state = "bulb-construct-stage1"

/obj/machinery/light_construct/examine(mob/user)
	if(!..(user, 2))
		return

	switch(src.stage)
		if(1)
			user << "It's an empty frame."
			return
		if(2)
			user << "It's wired."
			return
		if(3)
			user << "The casing is closed."
			return

/obj/machinery/light_construct/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (iswrench(W))
		if (src.stage == 1)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			usr << "You begin deconstructing [src]."
			if (!do_after(usr, 30))
				return
			new /obj/item/stack/material/steel( get_turf(src.loc), sheets_refunded )
			user.visible_message("[user.name] deconstructs [src].", \
				"You deconstruct [src].", "You hear a noise.")
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
			qdel(src)
		if (src.stage == 2)
			usr << "You have to remove the wires first."
			return

		if (src.stage == 3)
			usr << "You have to unscrew the case first."
			return

	if(iswirecutter(W))
		if (src.stage != 2) return
		src.stage = 1
		switch(fixture_type)
			if ("tube")
				src.icon_state = "tube-construct-stage1"
			if("bulb")
				src.icon_state = "bulb-construct-stage1"
		new /obj/item/stack/cable_coil(get_turf(src.loc), 1, "red")
		user.visible_message("[user.name] removes the wiring from [src].", \
			"You remove the wiring from [src].", "You hear a noise.")
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		return

	if(iscoil(W))
		if (src.stage != 1) return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			switch(fixture_type)
				if ("tube")
					src.icon_state = "tube-construct-stage2"
				if("bulb")
					src.icon_state = "bulb-construct-stage2"
			src.stage = 2
			user.visible_message("[user.name] adds wires to [src].", \
				"You add wires to [src].")
		return

	if(isscrewdriver(W))
		if (src.stage == 2)
			switch(fixture_type)
				if("tube")
					src.icon_state = "tube_empty"
				if("bulb")
					src.icon_state = "bulb_empty"
			src.stage = 3
			user.visible_message("[user.name] closes [src]'s casing.", \
				"You close [src]'s casing.", "You hear a noise.")
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)

			switch(fixture_type)

				if("tube")
					newlight = new /obj/machinery/light/built(src.loc)
				if("bulb")
					newlight = new /obj/machinery/light/small/built(src.loc)

			newlight.dir = src.dir
			src.transfer_fingerprints_to(newlight)
			qdel(src)
			return
	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	layer = 5
	stage = 1
	fixture_type = "bulb"
	sheets_refunded = 1

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
	var/on = 0					// 1 if on, 0 if off
	var/on_gs = 0
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
	var/light_type = /obj/item/weapon/light/tube		// the type of light item
	var/obj/item/weapon/light/inserted_light = /obj/item/weapon/light/tube
	var/fitting = "tube"
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	fitting = "bulb"
	brightness_range = 5
	brightness_power = 0.75
	brightness_color = LIGHT_COLOR_TUNGSTEN
	desc = "A small lighting fixture."
	light_type = /obj/item/weapon/light/bulb
	inserted_light = /obj/item/weapon/light/bulb
	supports_nightmode = FALSE

/obj/machinery/light/small/emergency
	brightness_range = 6
	brightness_power = 1
	brightness_color = "#FA8282"//"#FF0000"

/obj/machinery/light/small/red
	brightness_range = 2.5
	brightness_power = 1
	brightness_color = LIGHT_COLOR_RED

/obj/machinery/light/spot
	name = "spotlight"
	fitting = "large tube"
	light_type = /obj/item/weapon/light/tube/large
	inserted_light = /obj/item/weapon/light/tube/large
	brightness_range = 12
	brightness_power = 4
	supports_nightmode = FALSE

/obj/machinery/light/built/Initialize()
	status = LIGHT_EMPTY
	. = ..()

/obj/machinery/light/small/built/Initialize()
	status = LIGHT_EMPTY
	. = ..()

// create a new lighting fixture
/obj/machinery/light/Initialize(mapload)
	. = ..()
	on = has_power()

	if (mapload && loc && !(z in current_map.admin_levels))
		switch(fitting)
			if("tube")
				if(prob(2))
					broken(1)
			if("bulb")
				if(prob(5))
					broken(1)

	update(0)

/obj/machinery/light/update_icon()
	cut_overlays()
	icon_state = "[base_state]_empty"
	switch(status)		// set icon_states
		if(LIGHT_OK)
			var/image/I = image(icon, "[base_state][on]")
			I.color = brightness_color
			add_overlay(I)
			if (supports_nightmode && nightmode && on)
				color = "#d2d2d2"
			else
				color = null

		if(LIGHT_EMPTY)
			on = 0
		if(LIGHT_BURNED)
			var/image/I = image(icon, "[base_state]_burned")
			I.color = brightness_color
			add_overlay(I)
			on = 0
		if(LIGHT_BROKEN)
			var/image/I = image(icon, "[base_state]_broken")
			I.color = brightness_color
			add_overlay(I)
			on = 0

	if (!on)
		color = null

// update the icon_state and luminosity of the light depending on its state
/obj/machinery/light/proc/update(var/trigger = 1)
	update_icon()
	if(on)
		if (check_update())
			switchcount++
			if(rigged)
				if(status == LIGHT_OK && trigger)

					log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
					message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

					explode()
			else if( prob( min(60, switchcount*switchcount*0.01) ) )
				if(status == LIGHT_OK && trigger)
					status = LIGHT_BURNED
					cut_overlays()
					var/image/I = image(icon, "[base_state]_burned")
					I.color = brightness_color
					add_overlay(I)
					on = 0
					set_light(0)
			else
				use_power = 2
				active_power_usage = light_range * LIGHTING_POWER_FACTOR
				if (supports_nightmode && nightmode)
					set_light(night_brightness_range, night_brightness_power, brightness_color)
				else
					set_light(brightness_range, brightness_power, brightness_color)
	else
		use_power = 1
		set_light(0)

	active_power_usage = ((light_range * light_power) * 10)
	if(on != on_gs)
		on_gs = on

/obj/machinery/light/proc/check_update()
	if (supports_nightmode && nightmode)
		return light_range != night_brightness_range || light_power != night_brightness_power || light_color != brightness_color
	else
		return light_range != brightness_range || light_power != brightness_power || light_color != brightness_color

/obj/machinery/light/attack_generic(var/mob/user, var/damage)
	if(!damage)
		return
	if(status == LIGHT_EMPTY||status == LIGHT_BROKEN)
		user << "That object is useless to you."
		return
	if(!(status == LIGHT_OK||status == LIGHT_BURNED))
		return
	visible_message("<span class='danger'>[user] smashes the light!</span>")
	user.do_attack_animation(src)
	broken()
	return 1

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(var/s)
	on = (s && status == LIGHT_OK)
	update()

// examine verb
/obj/machinery/light/examine(mob/user)
	switch(status)
		if(LIGHT_OK)
			user << "[desc] It is turned [on? "on" : "off"]."
		if(LIGHT_EMPTY)
			user << "[desc] The [fitting] has been removed."
		if(LIGHT_BURNED)
			user << "[desc] The [fitting] is burnt out."
		if(LIGHT_BROKEN)
			user << "[desc] The [fitting] has been smashed."



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
	if(istype(W, /obj/item/weapon/light))
		if(status != LIGHT_EMPTY)
			user << "There is a [fitting] already inserted."
			return
		else
			src.add_fingerprint(user)
			var/obj/item/weapon/light/L = W
			if(istype(L, light_type))
				status = L.status
				user << "You insert the [L.name]."
				switchcount = L.switchcount
				rigged = L.rigged
				brightness_range = L.brightness_range
				brightness_power = L.brightness_power
				brightness_color = L.brightness_color
				inserted_light = L.type
				on = has_power()
				update()
				
				user.drop_item()	//drop the item to update overlays and such
				qdel(L)

				if(on && rigged)

					log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
					message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

					explode()
			else
				user << "This type of light requires a [fitting]."
				return

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)


		if(prob(1+W.force * 5))

			user << "You hit the light, and it smashes!"
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashes the light!", 3, "You hear a tinkle of breaking glass", 2)
			if(on && (W.flags & CONDUCT))
				//if(!user.mutations & COLD_RESISTANCE)
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			user << "You hit the light!"

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(isscrewdriver(W)) //If it's a screwdriver open it.
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)
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
			qdel(src)
			return

		user << "You stick \the [W] into the light socket!"
		if(has_power() && (W.flags & CONDUCT))
			spark(src, 3)
			//if(!user.mutations & COLD_RESISTANCE)
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))


// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/proc/has_power()
	var/area/A = get_area(src)
	return A && A.lightswitch && (!A.requires_power || A.power_light)

/obj/machinery/light/proc/flicker(amount = rand(10,20))
	set waitfor = FALSE
	if (flickering || !on || status != LIGHT_OK)
		return

	flickering = TRUE
	var/offset = 1
	var/thecallback = CALLBACK(src, .proc/handle_flicker)
	for (var/i = 0; i < amount; i++)
		addtimer(thecallback, offset)
		offset += rand(5, 15)

	playsound(src.loc, 'sound/effects/light_flicker.ogg', 75, 1)

	addtimer(CALLBACK(src, .proc/end_flicker), offset)

/obj/machinery/light/proc/handle_flicker()
	if (status == LIGHT_OK)
		on = !on
		update(FALSE)

/obj/machinery/light/proc/end_flicker()
	on = (status == LIGHT_OK)
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
		user << "There is no [fitting] in this light."
		return

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			for(var/mob/M in viewers(src))
				M.show_message("<span class='warning'>[user.name] smashed the light!</span>", 3, "You hear a tinkle of breaking glass", 2)
			broken()
			return

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))
			if(H.species.heat_level_1 > LIGHT_BULB_TEMPERATURE)
				prot = 1
			else if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					if(G.max_heat_protection_temperature > LIGHT_BULB_TEMPERATURE)
						prot = 1
		else
			prot = 1

		if(prot > 0 || (COLD_RESISTANCE in user.mutations))
			user << "You remove the light [fitting]"
		else if(TK in user.mutations)
			user << "You telekinetically remove the light [fitting]."
		else
			user << "You try to remove the light [fitting], but it's too hot and you don't want to burn your hand."
			return				// if burned, don't remove the light
	else
		user << "You remove the light [fitting]."

	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/weapon/light/L = new inserted_light()
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
	update()


/obj/machinery/light/attack_tk(mob/user)
	if(status == LIGHT_EMPTY)
		user << "There is no [fitting] in this light."
		return

	user << "You telekinetically remove the light [fitting]."
	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/weapon/light/L = new inserted_light()
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
	L.loc = loc

	inserted_light = null

	status = LIGHT_EMPTY
	update()

/obj/machinery/light/attack_ghost(mob/user)
	if(round_is_spooky())
		flicker(rand(2,5))
	else return ..()

// break the light and make sparks if was on

/obj/machinery/light/proc/broken(var/skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		if(on)
			spark(src, 3)
	status = LIGHT_BROKEN
	update()
	if (!skip_sound_and_sparks)
		CHECK_TICK	// For lights-out events.

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	on = 1
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
	addtimer(CALLBACK(src, .proc/handle_power_change), 10, TIMER_UNIQUE)

/obj/machinery/light/proc/handle_power_change()
	seton(has_power())

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

// Sets the light being output by a light tube or other static source
// Non or negative inputs will reset to default
/obj/machinery/light/proc/set_light_source(var/range = 0, var/power = 0, var/color = "")
	if (range > 0 && isnum(range))
		brightness_range = round(range)
	else
		brightness_range = initial(brightness_range)

	if (power > 0 && isnum(power))
		brightness_power = round(power)
	else
		brightness_power = initial(brightness_power)

	if (color && !isnull(sanitize_hexcolor(color, null)))
		brightness_color = color
	else
		brightness_color = initial(brightness_color)

// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/weapon/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = 1
	matter = list(DEFAULT_WALL_MATERIAL = 60)
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/switchcount = 0	// number of times switched
	var/rigged = 0		// true if rigged to explode
	var/brightness_range = 2 //how much light it gives off
	var/brightness_power = 1
	var/brightness_color = LIGHT_COLOR_HALOGEN
	var/lighttype = null
	var/randomize_range = TRUE

/obj/item/weapon/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube_preset"//preset state for mapping
	item_state = "c_tube"
	matter = list("glass" = 100)
	brightness_range = 8
	brightness_power = 0.8
	lighttype = "tube"

/obj/item/weapon/light/tube/colored/red
	name = "red light tube"
	brightness_color = LIGHT_COLOR_SCARLET

/obj/item/weapon/light/tube/colored/green
	name = "green light tube"
	brightness_color = LIGHT_COLOR_GREEN

/obj/item/weapon/light/tube/colored/blue
	name = "blue light tube"
	brightness_color = LIGHT_COLOR_BLUE

/obj/item/weapon/light/tube/colored/magenta
	name = "magenta light tube"
	brightness_color = LIGHT_COLOR_VIOLET

/obj/item/weapon/light/tube/colored/yellow
	name = "yellow light tube"
	brightness_color = LIGHT_COLOR_YELLOW

/obj/item/weapon/light/tube/colored/cyan
	name = "cyan light tube"
	brightness_color = LIGHT_COLOR_CYAN

/obj/item/weapon/light/tube/large
	w_class = 2
	name = "large light tube"
	brightness_range = 15
	brightness_power = 6
	randomize_range = FALSE

/obj/item/weapon/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb_preset"//preset state for mapping
	item_state = "contvapour"
	matter = list("glass" = 100)
	brightness_range = 5
	brightness_power = 0.75
	brightness_color = LIGHT_COLOR_TUNGSTEN
	lighttype = "bulb"

/obj/item/weapon/light/bulb/colored/red
	name = "red light bulb"
	brightness_color = LIGHT_COLOR_SCARLET

/obj/item/weapon/light/bulb/colored/green
	name = "green light bulb"
	brightness_color = LIGHT_COLOR_GREEN

/obj/item/weapon/light/bulb/colored/blue
	name = "blue light bulb"
	brightness_color = LIGHT_COLOR_BLUE

/obj/item/weapon/light/bulb/colored/magenta
	name = "magenta light bulb"
	brightness_color = LIGHT_COLOR_VIOLET

/obj/item/weapon/light/bulb/colored/yellow
	name = "yellow light bulb"
	brightness_color = LIGHT_COLOR_YELLOW

/obj/item/weapon/light/bulb/colored/cyan
	name = "cyan light bulb"
	brightness_color = LIGHT_COLOR_CYAN

/obj/item/weapon/light/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/weapon/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "flight"
	item_state = "egg4"
	matter = list("glass" = 100)
	brightness_range = 8
	brightness_power = 0.8
	randomize_range = FALSE

/obj/item/weapon/light/Initialize()
	. = ..()
	if(randomize_range)
		switch(lighttype)
			if("tube")
				brightness_range = rand(6,9)
			if("bulb")
				brightness_range = rand(4,6)
	update()

// update the icon state and description of the light
/obj/item/weapon/light/proc/update()
	cut_overlays()
	switch(status)
		if(LIGHT_OK)
			icon_state = "l[lighttype]_attachment"
			var/image/I = image(icon, "l[lighttype]")
			I.color = brightness_color
			add_overlay(I)
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "l[lighttype]_attachment"
			var/image/I = image(icon, "l[lighttype]_burned")
			I.color = brightness_color
			add_overlay(I)
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "l[lighttype]_attachment_broken"
			var/image/I = image(icon, "l[lighttype]_broken")
			I.color = brightness_color
			add_overlay(I)
			desc = "A broken [name]."

// attack bulb/tube with object
// if a syringe, can inject phoron to make it explode
/obj/item/weapon/light/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = I

		user << "You inject the solution into the [src]."

		if(S.reagents.has_reagent("phoron", 5))

			log_admin("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.",ckey=key_name(user))
			message_admins("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.")

			rigged = 1

		S.reagents.clear_reagents()
	else
		..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/weapon/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != I_HURT)
		return

	shatter()

/obj/item/weapon/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		src.visible_message("<span class='warning'>[name] shatters.</span>","<span class='warning'>You hear a small glass object shatter.</span>")
		status = LIGHT_BROKEN
		force = 5
		sharp = 1
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		update()
