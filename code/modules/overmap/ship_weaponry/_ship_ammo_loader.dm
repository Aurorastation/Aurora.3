ABSTRACT_TYPE(/obj/structure/machinery/ammunition_loader)
	name = "ammunition loader"
	desc = "An ammunition loader for ship weapons systems. All hands to battlestations!"
	icon = 'icons/obj/machinery/ship_guns/ship_weapon_attachments.dmi'
	icon_state = "ammo_loader"
	density = TRUE
	anchored = TRUE
	maxhealth = 1000
	var/obj/structure/machinery/ship_weapon/weapon
	/// Used to connect weapon systems to the relevant ammunition loader.
	/// If empty, it will try to find the closest ship gun, and connect to it.
	var/weapon_id = ""

/obj/structure/machinery/ammunition_loader/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Use a multitool to check or update the weapon loader's internal network ID for linking purposes. You probably don't need to do this."

/obj/structure/machinery/ammunition_loader/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()

/obj/structure/machinery/ammunition_loader/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/ammunition_loader/LateInitialize()
	. = ..()

	if(weapon_id)
		// explicit weapon id match
		for(var/obj/structure/machinery/ship_weapon/sw in SSmachinery.machinery)
			if(sw.weapon_id != weapon_id)
				continue
			if(get_area(sw) != get_area(src))
				crash_with("[src] is set to [weapon_id] of [sw] at ([x], [y], [z]), but areas mismatch!")
				continue
			weapon = sw
			break
	else
		// automatic fallback to try to find the closest ship weapon within the same area
		var/area/our_area = get_area(src)
		var/obj/structure/machinery/ship_weapon/closest_gun
		var/closest_dist = null
		for(var/obj/structure/machinery/ship_weapon/sw in SSmachinery.machinery)
			if(get_area(sw) != our_area)
				continue
			var/dist = get_dist(src, sw)
			if(isnull(closest_dist) || dist < closest_dist)
				closest_dist = dist
				closest_gun = sw
		weapon = closest_gun

	if(!weapon)
		crash_with("[src] at ([x], [y], [z]) has no weapon attached!")

/obj/structure/machinery/ammunition_loader/ex_act(severity)
	switch(severity)
		if(1)
			add_damage(50)
		if(2)
			add_damage(25)
		if(3)
			add_damage(10)

/obj/structure/machinery/ammunition_loader/attackby(obj/item/attacking_item, mob/user)
	if(isliving(user))
		var/mob/living/carbon/human/H = user
		if(istype(attacking_item, /obj/item/ship_ammunition))
			var/obj/item/ship_ammunition/SA = attacking_item
			return load_ammo(SA, H)
	if(ismech(user))
		var/mob/living/heavy_vehicle/HV = user
		if(istype(attacking_item, /obj/item/mecha_equipment/clamp))
			var/obj/item/mecha_equipment/clamp/CL = attacking_item
			if(!length(CL.carrying))
				to_chat(user, SPAN_WARNING("\The [CL] is empty."))
				return TRUE
			if(istype(CL.carrying[1], /obj/item/ship_ammunition))
				var/obj/item/ship_ammunition/SA = CL.carrying[1]
				return load_ammo(SA, HV)
			else
				to_chat(user, SPAN_WARNING("\The [CL] does not appear to be holding any compatible ammunition."))
		if(istype(attacking_item, /obj/item/multitool))
			to_chat(user, SPAN_NOTICE("You hook up the tester's wires to \the [src]: its identification tag is <b>[weapon_id]</b>."))
			var/new_id = input(user, "Change the identification tag?", "Identification Tag", weapon_id)
			if(length(new_id) && !use_check_and_message(user))
				new_id = sanitizeSafe(new_id, 32)
				for(var/obj/structure/machinery/ship_weapon/SW in SSmachinery.machinery)
					if(SW.weapon_id == new_id)
						if(get_area(SW) != get_area(src))
							to_chat(user, SPAN_WARNING("The loader returns an error message of two beeps, indicating that the weapon ID is invalid."))
							return TRUE
					weapon_id = new_id
					to_chat(user, SPAN_NOTICE("With some finicking, you change the identification tag to <b>[new_id]</b>."))
					return TRUE
	. = ..()

/obj/structure/machinery/ammunition_loader/proc/load_ammo(var/obj/item/ship_ammunition/SA, var/mob/living/H)
	if(SA.caliber == weapon.get_caliber())
		if(SA.can_be_loaded())
			visible_message(SPAN_NOTICE("[H] begins loading \the [SA] into \the [src]..."))
			if(do_after(H, weapon.load_time, src, DO_UNIQUE))
				if(weapon.load_ammunition(SA, H))
					visible_message(SPAN_NOTICE("[H] loads \the [SA] into \the [src]!"))
					playsound(src, 'sound/weapons/ammo_load.ogg', 70)
					return TRUE
				else
					to_chat(H, SPAN_WARNING("The loader is full!"))
		else
			to_chat(H, SPAN_WARNING("That ammunition is not ready to be loaded!"))
	else
		to_chat(H, SPAN_WARNING("That ammunition does not fit here!"))
		return FALSE

/obj/structure/viewport
	name = "viewport"
	desc = "A viewport for some sort of ship-mounted weapon. You can see your enemies blow up into many, many bits and pieces from here."
	icon = 'icons/obj/machinery/ship_guns/ship_weapon_attachments.dmi'
	icon_state = "viewport_generic"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	atmos_canpass = CANPASS_DENSITY

/obj/structure/viewport/zavod
	icon_state = "viewport_zavod"

/obj/structure/viewport/unathi
	icon_state = "viewport_unathi"
