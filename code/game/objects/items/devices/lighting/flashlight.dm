/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_lighting.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_lighting.dmi',
		)
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = ITEMSIZE_SMALL
	flags = CONDUCT
	slot_flags = SLOT_BELT
	light_color = LIGHT_COLOR_HALOGEN
	uv_intensity = 50
	light_wedge = LIGHT_WIDE

	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)

	action_button_name = "Toggle Flashlight"
	var/on = 0
	var/brightness_on = 3 //luminosity when on
	var/activation_sound = 'sound/items/flashlight.ogg'
	var/spawn_dir // a way for mappers to force which way a flashlight faces upon spawning

/obj/item/device/flashlight/Initialize()
	if (on)
		light_range = brightness_on
		update_icon()
	. = ..()
	if(light_wedge)
		set_dir(pick(NORTH, SOUTH, EAST, WEST))
		if(spawn_dir)
			set_dir(spawn_dir)
		update_light()

/obj/item/device/flashlight/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(brightness_on)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0)
	if (ismob(src.loc))	//for reasons, this makes headlights work.
		var/mob/M = src.loc
		M.update_inv_l_ear()
		M.update_inv_r_ear()
		M.update_inv_head()

/obj/item/device/flashlight/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, "You cannot turn the light on while in this [user.loc].") //To prevent some lighting anomalities.)
		return 0
	toggle()
	user.update_action_buttons()
	return 1

/obj/item/device/flashlight/proc/toggle()
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
	update_icon()

/obj/item/device/flashlight/vendor_action(var/obj/machinery/vending/V)
	toggle()

/obj/item/device/flashlight/examine(mob/user, distance)
	. = ..()
	if(light_wedge && isturf(loc))
		to_chat(user, FONT_SMALL(SPAN_NOTICE("\The [src] is facing [dir2text(dir)].")))

/obj/item/device/flashlight/dropped(mob/user)
	. = ..()
	if(light_wedge)
		set_dir(user.dir)
		update_light()

/obj/item/device/flashlight/throw_at(atom/target, range, speed, thrower, do_throw_animation)
	. = ..()
	if(light_wedge)
		var/new_dir = pick(NORTH, SOUTH, EAST, WEST)
		set_dir(new_dir)
		update_light()

/obj/item/device/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == BP_EYES)

		if(((user.is_clumsy()) || HAS_FLAG(user.mutations, DUMB)) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			if(M:eyecheck())
				to_chat(user, SPAN_WARNING("You're going to need to remove \The [M]'s eye protection first."))
				return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				to_chat(user, SPAN_WARNING("You can't find any [H.species.vision_organ ? H.species.vision_organ : "eyes"] on [H]!"))

			user.visible_message(SPAN_NOTICE("\The [user] directs [src] to [M]'s eyes."), SPAN_NOTICE("You direct [src] to [M]'s eyes."))

			if (H != user)	//can't look into your own eyes buster
				if(M.stat == DEAD || M.blinded || M.status_flags & FAKEDEATH)	//mob is dead or fully blind
					to_chat(user, SPAN_WARNING("\The [M]'s pupils do not react to the light!"))
					return
				if(HAS_FLAG(M.mutations, XRAY))
					to_chat(user, SPAN_NOTICE("\The [M]'s pupils give an eerie glow!"))
				if(vision.damage)
					to_chat(user, SPAN_WARNING("There's visible damage to [M]'s [vision.name]!"))
				else if(M.eye_blurry)
					to_chat(user, SPAN_NOTICE("\The [M]'s pupils react slower than normally."))
				if(M.getBrainLoss() > 15)
					to_chat(user, SPAN_NOTICE("There's visible lag between left and right pupils' reactions."))

				var/list/pinpoint = list(/decl/reagent/oxycomorphine=1,/decl/reagent/mortaphenyl=5)
				var/list/dilating = list(/decl/reagent/space_drugs=5,/decl/reagent/mindbreaker=1)
				var/datum/reagents/ingested = H.get_ingested_reagents()
				if(H.reagents.has_any_reagent(pinpoint) || ingested.has_any_reagent(pinpoint))
					to_chat(user, SPAN_NOTICE("\The [M]'s pupils are already pinpoint and cannot narrow any more."))
				else if(H.shock_stage >= 30 || H.reagents.has_any_reagent(dilating) || ingested.has_any_reagent(dilating) || H.breathing.has_any_reagent(dilating))
					to_chat(user, SPAN_NOTICE("\The [M]'s pupils narrow slightly, but are still very dilated."))
				else
					to_chat(user, SPAN_NOTICE("\The [M]'s pupils narrow."))

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
			M.flash_eyes()
	else
		return ..()

/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = "pen"
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	flags = CONDUCT
	slot_flags = SLOT_EARS
	brightness_on = 2
	w_class = ITEMSIZE_TINY
	light_wedge = LIGHT_OMNI

/obj/item/device/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = ""
	flags = CONDUCT
	brightness_on = 2
	w_class = ITEMSIZE_TINY

/obj/item/device/flashlight/heavy
	name = "heavy duty flashlight"
	desc = "A high-luminosity flashlight for specialist duties."
	icon_state = "heavyflashlight"
	item_state = "heavyflashlight"
	brightness_on = 4
	w_class = ITEMSIZE_NORMAL
	uv_intensity = 60
	matter = list(DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 70)
	light_wedge = LIGHT_SEMI

/obj/item/device/flashlight/maglight
	name = "maglight"
	desc = "A heavy flashlight designed for security personnel."
	icon_state = "maglight"
	item_state = "maglight"
	force = 10
	brightness_on = 5
	w_class = ITEMSIZE_NORMAL
	uv_intensity = 70
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	matter = list(DEFAULT_WALL_MATERIAL = 200, MATERIAL_GLASS = 100)
	hitsound = 'sound/weapons/smash.ogg'
	light_wedge = LIGHT_NARROW

/obj/item/device/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A glowing ball of what appears to be amber."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor1" //not a slime extract sprite but... something close enough!
	item_state = "slime"
	w_class = ITEMSIZE_TINY
	brightness_on = 6
	uv_intensity = 200
	on = 1 //Bio-luminesence has one setting, on.
	light_color = LIGHT_COLOR_SLIME_LAMP
	light_wedge = LIGHT_OMNI

/obj/item/device/flashlight/slime/update_icon()
	return

/obj/item/device/flashlight/slime/attack_self(mob/user)
	return //Bio-luminescence does not toggle.

/obj/item/device/flashlight/headlights
	name = "headlights"
	desc = "Some nifty lamps drawing from internal battery sources to produce a light, though a dim one."
	icon_state = "headlights"
	item_state = "headlights"
	flags = CONDUCT
	slot_flags = SLOT_HEAD | SLOT_EARS
	brightness_on = 2
	w_class = ITEMSIZE_TINY
	light_wedge = LIGHT_WIDE
	body_parts_covered = 0
