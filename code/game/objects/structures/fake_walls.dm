#define FAKEWALL_OFFSET_VAL 26

/*
 * Fake wall object
 * This isn't supposed to be placed by hand, use `/obj/effect/map_effect/marker/fake_wall` to convert a wall.
 * Inherits the appearance and materials of the wall it was passed in `inherit_appearance()`
 */
/obj/structure/fake_wall
	name = "you're not supposed to see this!"
	layer = TURF_DETAIL_LAYER
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	should_use_health = TRUE
	smoothing_flags = SMOOTH_MORE | SMOOTH_NO_CLEAR_ICON | SMOOTH_UNDERLAYS
	canSmoothWith = list(
		/obj/structure/fake_wall,
		/turf/simulated/wall,
		/turf/unsimulated/wall,
		/obj/structure/window_frame,
		/obj/structure/machinery/door,
		/obj/structure/arch
	)

	atmos_canpass = CANPASS_PROC
	/// Inherited reinforced wall material.
	var/singleton/material/reinf_material

/obj/structure/fake_wall/New(loc, user)
	. = ..()
	add_fingerprint(user)
	update_icon()

/obj/structure/fake_wall/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can check for the false walls by <b>Left-Click</b>ing in any action intents but help."

/obj/structure/fake_wall/update_icon()
	QUEUE_SMOOTH(src)

/obj/structure/fake_wall/c_airblock()
	if(density)
		return AIR_BLOCKED
	return FALSE

/obj/structure/fake_wall/proc/inherit_appearance(turf/simulated/wall/wall_to_inherit)
	// appearance
	appearance = wall_to_inherit.appearance
	layer = TURF_DETAIL_LAYER // overriding whatever we got from the appearance

	// material
	material = wall_to_inherit.material
	reinf_material = wall_to_inherit?.reinf_material
	hitsound = material.hitsound
	var/integrity_value = material.integrity + (reinf_material ? reinf_material.integrity : 0)
	set_maxhealth(integrity_value / 2, TRUE) // since we're fake, we're less sturdy

	// changing the wall we're replacing
	wall_to_inherit.ChangeTurf(wall_to_inherit.under_turf)

	// airproof stuff, shamelessly copy-pasted from airproof plasticflaps
	var/turf/simulated/floor/T = get_turf(src)
	new /obj/effect/floor_decal/reset(T)
	if(istype(T))
		update_nearby_tiles()

	T.mouse_opacity = MOUSE_OPACITY_TRANSPARENT // so the turf doesn't appear in the right click menu, no power gaming allowed

/obj/structure/fake_wall/attack_hand(mob/user)
	if(user.a_intent != I_HELP)
		add_fingerprint(user)
		toggle_fake_wall(user)

/obj/structure/fake_wall/proc/toggle_fake_wall(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] starts feeling around and pushing on \the [src]..."), SPAN_NOTICE("You start feeling around and pushing on \the [src]..."))
	if(!do_after(user, 30, src, DO_DEPLOY))
		return

	var/turf/simulated/floor/T = get_turf(src)

	if(density) // being opened

		var/offset_direction
		for(offset_direction in GLOB.cardinals)
			var/turf/simulated/wall/W = get_step(src, offset_direction)
			if(!istype(W))
				continue

			break // we found a valid wall that we can offset to, offset_direction keeps the last value

		if(isnull(offset_direction))
			to_chat(user, SPAN_WARNING("There is no adjacent walls to push the plate toward to!"))
			return

		// only smooth with the wall we're being offset toward
		cardinal_smooth(GLOB.dir_to_ndir[offset_direction])

		var/x_offset_mult = 0
		var/y_offset_mult = 0
		switch(offset_direction)
			if(NORTH)
				y_offset_mult = 1
			if(SOUTH)
				y_offset_mult = -1
			if(EAST)
				x_offset_mult = 1
			if(WEST)
				x_offset_mult = -1

		animate(src, pixel_x = x_offset_mult * FAKEWALL_OFFSET_VAL, pixel_y = y_offset_mult * FAKEWALL_OFFSET_VAL, time = 5, easing = SINE_EASING)

		density = FALSE
		T?.mouse_opacity = MOUSE_OPACITY_ICON
		set_opacity(0)

	else // being closed

		density = TRUE
		T?.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		animate(src, pixel_x = 0, pixel_y = 0, time = 5, easing = SINE_EASING)
		set_opacity(1)
		update_icon() // recalculate the adjacencies since we're now closed

	update_nearby_tiles() // airproof toggle

/obj/structure/fake_wall/proc/dismantle_wall()
	var/turf/T = get_turf(src)
	material.place_dismantled_girder(T)
	material.place_dismantled_product(T)
	qdel(src)

/obj/structure/fake_wall/on_death()
	material.place_dismantled_girder(get_turf(src))
	..()

// mostly copy-paste code from the wall code
/obj/structure/fake_wall/attackby(obj/item/attacking_item, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!user)
		return

	//get the user's location
	if(!istype(user.loc, /turf))
		return	//can't do this stuff whilst inside objects and such

	if(istype(attacking_item, /obj/item/plastique))
		return

	if(health < maxhealth && attacking_item.tool_behaviour == TOOL_WELDER)

		var/obj/item/weldingtool/WT = attacking_item

		if(!WT.isOn())
			return

		if(WT.use(0,user))
			to_chat(user, SPAN_NOTICE("You start repairing the damage to [src]."))
			playsound(src, 'sound/items/Welder.ogg', 50, 1)
			if(WT.use_tool(src, user, max(5, abs(health - maxhealth) / 5), volume = 50) && WT && WT.isOn())
				to_chat(user, SPAN_NOTICE("You finish repairing the damage to [src]."))
				add_health(maxhealth - health)
				update_icon()
				clear_bulletholes()
		else
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
			return
		return

	// Basic dismantling.

	var/cut_delay = 60 + material.cut_delay
	var/dismantle_verb
	var/dismantle_sound

	if(attacking_item.tool_behaviour == TOOL_WELDER)
		var/obj/item/weldingtool/WT = attacking_item
		if(!WT.isOn())
			return
		if(!WT.use(0,user))
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
			return
		dismantle_verb = "cutting"
		dismantle_sound = 'sound/items/Welder.ogg'
		cut_delay *= 0.7
	else if(istype(attacking_item, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/PC = attacking_item
		if(PC.check_power_and_message(user))
			return
		dismantle_sound = PC.fire_sound
		dismantle_verb = "slicing"
		cut_delay *= 0.8
	else if(istype(attacking_item, /obj/item/melee/energy))
		var/obj/item/melee/energy/WT = attacking_item
		if(WT.active)
			dismantle_sound = SFX_SPARKS
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else
			to_chat(user, SPAN_NOTICE("You need to activate the weapon to do that!"))
			return
	else if(istype(attacking_item, /obj/item/melee/energy/blade))
		dismantle_sound = SFX_SPARKS
		dismantle_verb = "slicing"
		cut_delay *= 0.5
	else if(istype(attacking_item, /obj/item/melee/chainsword))
		var/obj/item/melee/chainsword/WT = attacking_item
		if(WT.active)
			dismantle_sound = 'sound/weapons/saw/chainsawhit.ogg'
			dismantle_verb = "slicing"
			cut_delay *= 0.8
		else
			to_chat(user, SPAN_NOTICE("You need to activate the weapon to do that!"))
			return
	else if(istype(attacking_item, /obj/item/pickaxe))
		var/obj/item/pickaxe/P = attacking_item
		dismantle_verb = P.drill_verb
		dismantle_sound = P.drill_sound
		cut_delay -= P.digspeed
	else if(istype(attacking_item,/obj/item/melee/arm_blade/))
		dismantle_sound = SFX_PICKAXE
		dismantle_verb = "slicing and stabbing"
		cut_delay *= 1.5

	if(dismantle_verb)
		to_chat(user, SPAN_NOTICE("You begin [dismantle_verb] through the outer plating."))

		if(cut_delay<0)
			cut_delay = 1

		if(!attacking_item.use_tool(src, user, cut_delay, volume = 50))
			return

		//This prevents runtime errors if someone clicks the same wall more than once
		if (!istype(src, /obj/structure/fake_wall))
			return

		if(dismantle_sound)
			playsound(src, dismantle_sound, 100, 1)
		attacking_item.use_resource(user, 1)
		dismantle_wall()
		user.visible_message(SPAN_WARNING("The wall was torn open by \the [user]!"), SPAN_NOTICE("You remove the outer plating."))
		return

	return ..()

// ---------- Fake wall helper effect

// Converts a wall into a fake wall.
/obj/effect/map_effect/marker/fake_wall
	name = "fake wall converter"
	icon_state = "fake_wall"

/obj/effect/map_effect/marker/fake_wall/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/fake_wall/LateInitialize()
	var/turf/simulated/wall/found_wall = get_turf(src)
	if(!istype(found_wall))
		stack_trace("A fake wall object is placed at: ([loc.x], [loc.y], [loc.z]), but no wall was found in the location.")
		qdel(src)

	var/obj/structure/fake_wall/fake_wall = new /obj/structure/fake_wall(get_turf(src))
	fake_wall.inherit_appearance(found_wall)
	qdel(src)

#undef FAKEWALL_OFFSET_VAL
