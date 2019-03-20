/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = 2
	flags = CONDUCT
	slot_flags = SLOT_BELT
	light_color = LIGHT_COLOR_HALOGEN
	uv_intensity = 50
	light_wedge = LIGHT_WIDE

	matter = list(DEFAULT_WALL_MATERIAL = 50,"glass" = 20)

	action_button_name = "Toggle Flashlight"
	var/on = 0
	var/brightness_on = 3 //luminosity when on
	var/activation_sound = 'sound/items/flashlight.ogg'

/obj/item/device/flashlight/Initialize()
	if (on)
		light_range = brightness_on
		update_icon()
	. = ..()

/obj/item/device/flashlight/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(brightness_on)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0)

/obj/item/device/flashlight/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in this [user.loc].") //To prevent some lighting anomalities.)
		return 0
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
	update_icon()
	user.update_action_buttons()
	return 1


/obj/item/device/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == "eyes")

		if(((CLUMSY in user.mutations) || (DUMB in user.mutations)) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			if(M:eyecheck())
				to_chat(user, span("warning", "You're going to need to remove \The [M]'s eye protection first."))
				return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				to_chat(user, span("warning", "You can't find any [H.species.vision_organ ? H.species.vision_organ : "eyes"] on [H]!"))

			user.visible_message(span("notice", "\The [user] directs [src] to [M]'s eyes."), span("notice", "You direct [src] to [M]'s eyes."))

			if (H != user)	//can't look into your own eyes buster
				if(M.stat == DEAD || M.blinded)	//mob is dead or fully blind
					to_chat(user, span("warning","\The [M]'s pupils do not react to the light!"))
					return
				if(XRAY in M.mutations)
					to_chat(user, span("notice", "\The [M]'s pupils give an eerie glow!"))
				if(vision.damage)
					to_chat(user, span("warning", "There's visible damage to [M]'s [vision.name]!"))
				else if(M.eye_blurry)
					to_chat(user, span("notice", "\The [M]'s pupils react slower than normally."))
				if(M.getBrainLoss() > 15)
					to_chat(user, span("notice", "There's visible lag between left and right pupils' reactions."))

				var/list/pinpoint = list("oxycodone"=1,"tramadol"=5)
				var/list/dilating = list("space_drugs"=5,"mindbreaker"=1)
				if(M.reagents.has_any_reagent(pinpoint) || H.ingested.has_any_reagent(pinpoint) || H.breathing.has_any_reagent(pinpoint))
					to_chat(user, span("notice", "\The [M]'s pupils are already pinpoint and cannot narrow any more."))
				else if(M.reagents.has_any_reagent(dilating) || H.ingested.has_any_reagent(dilating) || H.breathing.has_any_reagent(dilating))
					to_chat(user, span("notice", "\The [M]'s pupils narrow slightly, but are still very dilated."))
				else
					to_chat(user, span("notice", "\The [M]'s pupils narrow."))

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
			flick("flash", M.flash)
	else
		return ..()

/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	flags = CONDUCT
	slot_flags = SLOT_EARS
	brightness_on = 2
	w_class = 1
	light_wedge = LIGHT_OMNI

/obj/item/device/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = ""
	flags = CONDUCT
	brightness_on = 2
	w_class = 1

/obj/item/device/flashlight/heavy
	name = "heavy duty flashlight"
	desc = "A high-luminosity flashlight for specialist duties."
	icon_state = "heavyflashlight"
	item_state = "heavyflashlight"
	brightness_on = 4
	w_class = 3
	uv_intensity = 60
	matter = list(DEFAULT_WALL_MATERIAL = 100,"glass" = 70)
	contained_sprite = 1
	light_wedge = LIGHT_SEMI

/obj/item/device/flashlight/maglight
	name = "maglight"
	desc = "A heavy flashlight designed for security personnel."
	icon_state = "maglight"
	item_state = "maglight"
	force = 10
	brightness_on = 5
	w_class = 3
	uv_intensity = 70
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	matter = list(DEFAULT_WALL_MATERIAL = 200,"glass" = 100)
	hitsound = 'sound/weapons/smash.ogg'
	contained_sprite = 1
	light_wedge = LIGHT_NARROW


// the desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	brightness_on = 5
	w_class = 5
	flags = CONDUCT
	uv_intensity = 100
	on = 1
	slot_flags = 0 //No wearing desklamps
	light_wedge = LIGHT_OMNI


// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	brightness_on = 5
	light_color = "#FFC58F"

/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = 2.0
	brightness_on = 4 // Pretty bright.
	light_power = 4
	light_color = LIGHT_COLOR_FLARE
	icon_state = "flare"
	item_state = "flare"
	action_button_name = null //just pull it manually, neckbeard.
	var/fuel = 0
	uv_intensity = 100
	var/on_damage = 7
	var/produce_heat = 1500
	light_wedge = LIGHT_OMNI
	activation_sound = 'sound/items/flare.ogg'

/obj/item/device/flashlight/flare/New()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	..()

/obj/item/device/flashlight/flare/process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSprocessing, src)

/obj/item/device/flashlight/flare/proc/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	update_icon()

/obj/item/device/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(!fuel)
		to_chat(user, "<span class='notice'>It's out of fuel.</span>")
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message("<span class='notice'>[user] activates the flare.</span>", "<span class='notice'>You pull the cord on the flare, activating it!</span>")
		src.force = on_damage
		src.damtype = "fire"
		START_PROCESSING(SSprocessing, src)

/obj/item/device/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A glowing ball of what appears to be amber."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor1" //not a slime extract sprite but... something close enough!
	item_state = "slime"
	w_class = 1
	brightness_on = 6
	uv_intensity = 200
	on = 1 //Bio-luminesence has one setting, on.
	light_color = LIGHT_COLOR_SLIME_LAMP
	light_wedge = LIGHT_OMNI

/obj/item/device/flashlight/slime/update_icon()
	return

/obj/item/device/flashlight/slime/attack_self(mob/user)
	return //Bio-luminescence does not toggle.

//Glowsticks

/obj/item/device/flashlight/glowstick
	name = "green glowstick"
	desc = "A green military-grade glowstick."
	w_class = 2
	brightness_on = 1.5
	light_power = 1
	light_color = "#49F37C"
	icon = 'icons/obj/glowsticks.dmi'
	icon_state = "glowstick"
	item_state = "glowstick"
	contained_sprite = 1
	uv_intensity = 255
	var/fuel = 0
	light_wedge = LIGHT_OMNI
	activation_sound = null

/obj/item/device/flashlight/glowstick/New()
	fuel = rand(900, 1200)
	..()

/obj/item/device/flashlight/glowstick/process()
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSprocessing, src)

/obj/item/device/flashlight/glowstick/proc/turn_off()
	on = 0
	update_icon()

/obj/item/device/flashlight/glowstick/attack_self(var/mob/living/user)

	if(((CLUMSY in user.mutations)) && prob(50))
		to_chat(user, "<span class='notice'>You break \the [src] apart, spilling its contents everywhere!</span>")
		fuel = 0
		new /obj/effect/decal/cleanable/greenglow(get_turf(user))
		user.apply_effect((rand(15,30)),IRRADIATE,blocked = user.getarmor(null, "rad"))
		qdel(src)
		return

	if(!fuel)
		to_chat(user, "<span class='notice'>\The [src] has already been used.</span>")
		return
	if(on)
		to_chat(user, "<span class='notice'>\The [src] has already been turned on.</span>")
		return

	. = ..()

	if(.)
		user.visible_message("<span class='notice'>[user] cracks and shakes \the [src].</span>", "<span class='notice'>You crack and shake \the [src], turning it on!</span>")
		START_PROCESSING(SSprocessing, src)

/obj/item/device/flashlight/glowstick/red
	name = "red glowstick"
	desc = "A red military-grade glowstick."
	light_color = LIGHT_COLOR_RED //"#FC0F29"
	icon_state = "glowstick_red"
	item_state = "glowstick_red"

/obj/item/device/flashlight/glowstick/blue
	name = "blue glowstick"
	desc = "A blue military-grade glowstick."
	light_color = LIGHT_COLOR_BLUE //"#599DFF"
	icon_state = "glowstick_blue"
	item_state = "glowstick_blue"

/obj/item/device/flashlight/glowstick/orange
	name = "orange glowstick"
	desc = "A orange military-grade glowstick."
	light_color = LIGHT_COLOR_ORANGE//"#FA7C0B"
	icon_state = "glowstick_orange"
	item_state = "glowstick_orange"

/obj/item/device/flashlight/glowstick/yellow
	name = "yellow glowstick"
	desc = "A yellow military-grade glowstick."
	light_color = LIGHT_COLOR_YELLOW //"#FEF923"
	icon_state = "glowstick_yellow"
	item_state = "glowstick_yellow"

/obj/item/device/flashlight/headlights
	name = "headlights"
	desc = "Some nifty lamps drawing from internal battery sources to produce a light, though a dim one."
	icon_state = "headlights"
	item_state = "headlights"
	flags = CONDUCT
	slot_flags = SLOT_HEAD | SLOT_EARS
	brightness_on = 2
	w_class = 1
	light_wedge = LIGHT_WIDE
	body_parts_covered = 0