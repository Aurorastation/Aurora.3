/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	desc_info = "Use this item in your hand, to turn on the light. Click this light with the opposite hand, to remove the cell contained inside."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	light_color = LIGHT_COLOR_HALOGEN
	uv_intensity = 50
	light_wedge = LIGHT_WIDE

	matter = list(MATERIAL_PLASTIC = 50, MATERIAL_GLASS = 20)

	action_button_name = "Toggle Flashlight"
	/// Is the light currently on or off?
	var/on = FALSE
	/// Luminosity when on
	var/brightness_on = 4
	// Lighting power when on
	var/flashlight_power = 0.8
	/// Sound the light makes when it's switched
	var/toggle_sound = 'sound/machines/switch_flashlight.ogg'
	/// Sound the light makes when it's turned on
	var/activation_sound = 'sound/items/flashlight.ogg'
	var/obj/item/cell/cell
	var/cell_type = /obj/item/cell/device
	var/list/brightness_levels
	var/brightness_level = "high"
	var/power_usage
	/// Does the light use power?
	var/power_use = TRUE
	/// Should the item start with a cell?
	var/starts_with_cell = TRUE
	/// Does the item accept large cells?
	var/accepts_large_cells = FALSE
	/// Is the light always on?
	var/always_on = FALSE
	/// How efficient the flashlight is at producing light compared to baseline
	var/efficiency_modifier = 1.0
	/// A way for mappers to force which way a flashlight faces upon spawning
	var/spawn_dir

/obj/item/device/flashlight/Initialize()

	if(power_use && cell_type)
		if(starts_with_cell)
			cell = new cell_type(src)
		brightness_levels = list("low" = 1/32, "medium" = 1/16, "high" = 1/8) // ~26 minutes at high power with a device cell.
		power_usage = (brightness_levels[brightness_level] / efficiency_modifier)
	else
		verbs -= /obj/item/device/flashlight/verb/toggle_brightness

	if (on)
		if(brightness_level == "low")
			light_range = brightness_on * 0.5
		else if(brightness_level == "high")
			light_range = brightness_on * 1.5
		else
			light_range = brightness_on
		update_icon()

	. = ..()

	if(light_wedge)
		set_dir(pick(NORTH, SOUTH, EAST, WEST))
		if(spawn_dir)
			set_dir(spawn_dir)
		update_light()

/obj/item/device/flashlight/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(cell)
	return ..()

/obj/item/device/flashlight/get_cell()
	return cell

/obj/item/device/flashlight/proc/set_brightness(mob/user)
	var/choice = tgui_input_list(user, "Choose a brightness level.", "Flashlight", brightness_levels)
	if(choice)
		brightness_level = choice
		power_usage = brightness_levels[choice]
		to_chat(user, SPAN_NOTICE("You set the brightness level on \the [src] to [brightness_level]."))
		update_icon()

/obj/item/device/flashlight/process()
	if(!on || !cell)
		return PROCESS_KILL

	if(brightness_level && power_usage)
		if(cell.use(power_usage) != power_usage)
			visible_message(
				SPAN_WARNING("\The [src] flickers before shutting out!")
			)
			playsound(src.loc, 'sound/effects/sparks3.ogg', 10, 1, -3)
			toggle()
			return PROCESS_KILL

/obj/item/device/flashlight/update_icon()
	if(always_on)
		return

	if(on)
		icon_state = "[initial(icon_state)]-on"
		if(brightness_level == "low")
			set_light(brightness_on * 0.5, flashlight_power * 0.75, light_color)
		else if(brightness_level == "high")
			set_light(brightness_on * 1.5, flashlight_power * 1.1, light_color)
		else
			set_light(brightness_on, flashlight_power, light_color)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0)
	if (ismob(src.loc))	//for reasons, this makes headlights work.
		var/mob/M = src.loc
		M.update_inv_l_ear()
		M.update_inv_r_ear()
		M.update_inv_head()

/obj/item/device/flashlight/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(power_use && brightness_level)
		. += SPAN_NOTICE("\The [src] is set to [brightness_level].")
		if(cell)
			. += SPAN_NOTICE("\The [src] has \a [cell] attached. It has [round(cell.percent())]% charge remaining.")
	if(light_wedge && isturf(loc))
		. += FONT_SMALL(SPAN_NOTICE("\The [src] is facing [dir2text(dir)]."))

/obj/item/device/flashlight/attack_self(mob/user)
	if(always_on)
		to_chat(user, SPAN_NOTICE("You cannot toggle \the [name]."))
		return 0

	if(power_use)
		if(!cell || !cell.check_charge(1))
			playsound(src.loc, toggle_sound, 60, 1)
			to_chat(user, SPAN_WARNING("You flip the switch on \the [name], but nothing happens!"))
			return 0

	if(!isturf(user.loc))
		to_chat(user, SPAN_NOTICE("You cannot turn the light on while in this [user.loc].")) //To prevent some lighting anomalies.
		return 0

	playsound(src.loc, toggle_sound, 60, 1)
	toggle()
	user.update_action_buttons()
	return 1

/obj/item/device/flashlight/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(cell)
			STOP_PROCESSING(SSprocessing, src)
			cell.update_icon()
			user.put_in_hands(cell)
			cell = null
			to_chat(user, SPAN_NOTICE("You remove the cell from \the [src]."))
			playsound(src, 'sound/machines/click.ogg', 30, 1, 0)
			on = FALSE
			update_icon()
			return
		..()
	else
		return ..()

/obj/item/device/flashlight/attackby(obj/item/attacking_item, mob/user)
	if(power_use)
		if(istype(attacking_item, /obj/item/cell))
			if(istype(attacking_item, /obj/item/cell/device) || accepts_large_cells)
				if(!cell)
					user.drop_item()
					attacking_item.loc = src
					cell = attacking_item
					to_chat(user, SPAN_NOTICE("You install a cell in \the [src]."))
					playsound(src, 'sound/machines/click.ogg', 30, 1, 0)
					update_icon()
				else
					to_chat(user, SPAN_WARNING("\The [src] already has a cell!"))
			else
				to_chat(user, SPAN_WARNING("\The [src] cannot accept that type of cell."))

	else
		..()

/obj/item/device/flashlight/proc/toggle()
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
	if(on && power_use)
		START_PROCESSING(SSprocessing, src)
	else if (power_use)
		STOP_PROCESSING(SSprocessing, src)
	update_icon()

/obj/item/device/flashlight/vendor_action(var/obj/machinery/vending/V)
	toggle()

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

/obj/item/device/flashlight/emp_act(severity)
	. = ..()

	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/device/flashlight/attack(mob/living/target_mob, mob/living/user, target_zone)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == BP_EYES)

		if(((user.is_clumsy()) || (user.mutations & DUMB)) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		if(brightness_on < 2)
			to_chat(user, SPAN_WARNING("This light is too dim to see anything with!"))
			return

		var/mob/living/carbon/human/H = target_mob	//mob has protective eyewear
		if(istype(H))
			if(H.get_flash_protection())
				to_chat(user, SPAN_WARNING("You're going to need to remove \the [H]'s eye protection first."))
				return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				to_chat(user, SPAN_WARNING("You can't find any [H.species.vision_organ ? H.species.vision_organ : "eyes"] on [H]!"))

			user.visible_message(
				SPAN_NOTICE("\The [user] directs [src] to [H]'s eyes."),
				SPAN_NOTICE("You direct [src] to [H]'s eyes.")
			)

			inspect_vision(vision, user)

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
			if (!(brightness_on < 2))
				H.flash_act(length = 1 SECOND)
	else
		return ..()

/obj/item/device/flashlight/AltClick()
	toggle_brightness()

/obj/item/device/flashlight/proc/inspect_vision(obj/item/organ/vision, mob/living/user)
	var/mob/living/carbon/human/H = vision.owner

	if (H == user)	//can't look into your own eyes buster
		return

	if (!BP_IS_ROBOTIC(vision))

		if(H.stat == DEAD || H.blinded || H.status_flags & FAKEDEATH)	//mob is dead or fully blind
			to_chat(user, SPAN_WARNING("\The [H]'s pupils do not react to the light!"))
			return
		if((H.mutations & XRAY))
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils give an eerie glow!"))
		if(vision.damage)
			to_chat(user, SPAN_WARNING("There's visible damage to [H]'s [vision.name]!"))
		else if(H.eye_blurry)
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils react slower than normally."))
		if(H.getBrainLoss() > 15)
			to_chat(user, SPAN_NOTICE("There's visible lag between the left and right pupils' reactions."))

		var/list/pinpoint = list(/singleton/reagent/oxycomorphine=1,/singleton/reagent/mortaphenyl=5)
		var/list/dilating = list(/singleton/reagent/drugs/mms=5,/singleton/reagent/drugs/mindbreaker=1)
		var/datum/reagents/ingested = H.get_ingested_reagents()
		if(H.reagents.has_any_reagent(pinpoint) || ingested.has_any_reagent(pinpoint))
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils are already pinpoint and cannot narrow any more."))
		else if(H.shock_stage >= 30 || H.reagents.has_any_reagent(dilating) || ingested.has_any_reagent(dilating) || H.breathing.has_any_reagent(dilating))
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils narrow slightly, but are still very dilated."))
		else
			to_chat(user, SPAN_NOTICE("\The [H]'s pupils narrow."))

/obj/item/device/flashlight/verb/toggle_brightness()
	set name = "Toggle Flashlight Brightness"
	set category = "Object"
	set src in usr
	set_brightness(usr)

/obj/item/device/flashlight/empty
	starts_with_cell = FALSE

/obj/item/device/flashlight/on
	on = TRUE

/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = "pen"
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_EARS
	brightness_on = 2
	w_class = WEIGHT_CLASS_TINY
	light_wedge = LIGHT_OMNI

/obj/item/device/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = ""
	obj_flags = OBJ_FLAG_CONDUCTABLE
	brightness_on = 2
	efficiency_modifier = 2
	w_class = WEIGHT_CLASS_TINY

/obj/item/device/flashlight/heavy
	name = "heavy duty flashlight"
	desc = "A high-luminosity flashlight, for specialist duties."
	icon_state = "heavyflashlight"
	item_state = "heavyflashlight"
	brightness_on = 4
	w_class = WEIGHT_CLASS_NORMAL
	uv_intensity = 60
	matter = list(MATERIAL_PLASTIC = 100, MATERIAL_GLASS = 70)
	light_wedge = LIGHT_SEMI

/obj/item/device/flashlight/heavy/on
	on = TRUE

/obj/item/device/flashlight/maglight
	name = "maglight"
	desc = "A heavy flashlight, designed for security personnel."
	icon_state = "maglight"
	item_state = "maglight"
	force = 9
	brightness_on = 5
	efficiency_modifier = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	uv_intensity = 70
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	matter = list(MATERIAL_ALUMINIUM = 200, MATERIAL_GLASS = 100)
	hitsound = 'sound/weapons/smash.ogg'
	light_wedge = LIGHT_NARROW

/obj/item/device/flashlight/maglight/update_icon()
	..()
	if(on)
		item_state = "maglight-on"
	else
		item_state = "maglight"

/obj/item/device/flashlight/maglight/on
	on = TRUE

/obj/item/device/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A glowing ball of what appears to be amber."
	desc_info = null
	icon = 'icons/mob/npc/slimes.dmi'
	icon_state = "yellow slime extract"
	item_state = "flashlight"
	w_class = WEIGHT_CLASS_TINY
	brightness_on = 6
	uv_intensity = 200
	on = TRUE //Bio-luminesence has one setting, on.
	always_on = TRUE
	power_usage = FALSE
	light_color = LIGHT_COLOR_SLIME_LAMP
	light_wedge = LIGHT_OMNI

/obj/item/device/flashlight/headlights
	name = "headlights"
	desc = "Some nifty lamps drawing from internal battery sources to produce a light, though a dim one."
	icon_state = "headlights"
	item_state = "headlights"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_HEAD | SLOT_EARS
	brightness_on = 2
	w_class = WEIGHT_CLASS_TINY
	light_wedge = LIGHT_WIDE
	body_parts_covered = 0

/******************************Lantern*******************************/

/obj/item/device/flashlight/lantern
	name = "lantern"
	desc = "A mining lantern. Accepts larger cells than normal flashlights."
	icon_state = "lantern"
	item_state = "lantern"
	attack_verb = list("bludgeoned, bashed, whacked")
	matter = list(MATERIAL_STEEL = 200,MATERIAL_GLASS = 100)
	flashlight_power = 1
	brightness_on = 4
	cell_type = /obj/item/cell
	accepts_large_cells = TRUE
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_FIRE

/obj/item/device/flashlight/lantern/update_icon()
	..()
	if(on)
		item_state = "lantern-on"
	else
		item_state = "lantern"

/obj/item/device/flashlight/lantern/on
	on = TRUE
