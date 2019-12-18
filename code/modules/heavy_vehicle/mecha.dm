// Big stompy robots.
/mob/living/heavy_vehicle
	name = "exosuit"
	density = 1
	opacity = 1
	anchored = 1
	status_flags = PASSEMOTES
	a_intent = I_HURT
	mob_size = MOB_LARGE
	var/decal

	var/emp_damage = 0

	// Used to offset a non-32x32 icon appropriately.
	var/offset_x = -8
	var/offset_y = 0

	var/obj/item/device/radio/exosuit/radio

	var/wreckage_path = /obj/structure/mech_wreckage

	// Access updating/container.
	var/obj/item/card/id/access_card
	var/list/saved_access = list()
	var/sync_access = 1

	// Mob currently piloting the mech.
	var/list/pilots
	var/list/pilot_overlays

	// Visible external components. Not strictly accurately named for non-humanoid machines (submarines) but w/e
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body

	// Invisible components.
	var/datum/effect/effect/system/spark_spread/sparks

	// Equipment tracking vars.
	var/obj/item/mecha_equipment/selected_system
	var/selected_hardpoint
	var/list/hardpoints = list()
	var/hardpoints_locked
	var/maintenance_protocols

	// Material
	var/material/material

	// Cockpit access vars.
	var/hatch_closed = 0
	var/hatch_locked = 0

	var/use_air      = FALSE

	// Interface stuff.
	var/list/hud_elements = list()
	var/list/hardpoint_hud_elements = list()
	var/obj/screen/movable/mecha/health/hud_health
	var/obj/screen/movable/mecha/toggle/hatch_open/hud_open
	var/obj/screen/movable/mecha/power/hud_power

/mob/living/heavy_vehicle/Destroy()

	selected_system = null

	for(var/thing in pilots)
		var/mob/pilot = thing
		if(pilot.client)
			pilot.client.screen -= hud_elements
			pilot.client.images -= hud_elements
		pilot.forceMove(get_turf(src))
	pilots = null

	QDEL_NULL_LIST(hud_elements)

	hardpoint_hud_elements = null

	hardpoints = null

	QDEL_NULL(access_card)
	QDEL_NULL(arms)
	QDEL_NULL(legs)
	QDEL_NULL(head)
	QDEL_NULL(body)

	. = ..()

/mob/living/heavy_vehicle/IsAdvancedToolUser()
	return 1

/mob/living/heavy_vehicle/examine(var/mob/user)
	if(!user || !user.client)
		return
	to_chat(user, "That's \a [src].")
	user << desc
	if(LAZYLEN(pilots) && (!hatch_closed || body.pilot_coverage < 100 || body.transparent_cabin))
		to_chat(user, "It is being piloted by [english_list(pilots, nothing_text = "nobody")].")
	if(hardpoints.len)
		to_chat(user, "It has the following hardpoints:")
		for(var/hardpoint in hardpoints)
			var/obj/item/I = hardpoints[hardpoint]
			to_chat(user, "- [hardpoint]: [istype(I) ? "[I]" : "nothing"].")
	else
		to_chat(user, "It has no visible hardpoints.")

	for(var/obj/item/mech_component/thing in list(arms, legs, head, body))
		if(!thing)
			continue
		var/damage_string = "destroyed"
		switch(thing.damage_state)
			if(1)
				damage_string = "undamaged"
			if(2)
				damage_string = "damaged"
			if(3)
				damage_string = "badly damaged"
			if(4)
				damage_string = "almost destroyed"
		to_chat(user, "Its [thing.name] [thing.gender == PLURAL ? "are" : "is"] [damage_string].")

/mob/living/heavy_vehicle/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame)
	. = ..()

	if(!access_card) access_card = new (src)

	if(offset_x) pixel_x = offset_x
	if(offset_y) pixel_y = offset_y
	radio = new(src)

	// Grab all the supplied components.
	if(source_frame)
		if(source_frame.set_name)
			name = source_frame.set_name
		if(source_frame.arms)
			source_frame.arms.forceMove(src)
			arms = source_frame.arms
		if(source_frame.legs)
			source_frame.legs.forceMove(src)
			legs = source_frame.legs
		if(source_frame.head)
			source_frame.head.forceMove(src)
			head = source_frame.head
		if(source_frame.body)
			source_frame.body.forceMove(src)
			body = source_frame.body

	updatehealth()

	// Generate hardpoint list.
	for(var/obj/item/mech_component/thing in list(arms, legs, head, body))
		if(thing && thing.has_hardpoints.len)
			for(var/hardpoint in thing.has_hardpoints)
				hardpoints[hardpoint] = null

	if(head && head.radio)
		radio = new(src)

	// Create HUD.
	instantiate_hud()

	// Build icon.
	update_icon()

/mob/living/heavy_vehicle/return_air()
	return (body && body.pilot_coverage >= 100 && hatch_closed) ? body.cockpit : loc.return_air()

/mob/living/heavy_vehicle/GetIdCard()
	return access_card

/obj/item/device/radio/exosuit
	name = "exosuit radio"
	cell = null

/obj/item/device/radio/exosuit/get_cell()
	. = ..()
	if(!.)
		var/mob/living/heavy_vehicle/E = loc
		if(istype(E))
			return E.get_cell()

/obj/item/device/radio/exosuit/ui_host()
	var/mob/living/heavy_vehicle/E = loc
	if(istype(E))
		return E
	return null

/obj/item/device/radio/exosuit/attack_self(var/mob/user)
	var/mob/living/heavy_vehicle/exosuit = loc
	if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
		user.set_machine(src)
		interact(user)
	else
		to_chat(user, "<span class='warning'>The radio is too damaged to function.</span>")

/obj/item/device/radio/exosuit/CanUseTopic()
	. = ..()
	if(.)
		var/mob/living/heavy_vehicle/exosuit = loc
		if(istype(exosuit) && exosuit.head && exosuit.head.radio && exosuit.head.radio.is_functional())
			return ..()

/obj/item/device/radio/exosuit/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = mech_state)
	. = ..()
