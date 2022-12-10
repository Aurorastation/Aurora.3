/obj/item/mech_component
	icon = 'icons/mecha/mech_parts.dmi'
	w_class = ITEMSIZE_HUGE
	pixel_x = -8
	gender = PLURAL
	var/on_mech_icon = 'icons/mecha/mech_parts.dmi'
	var/decal
	var/exosuit_desc_string
	var/total_damage = 0
	var/brute_damage = 0
	var/burn_damage = 0
	var/max_damage = 120
	var/damage_state = 1
	var/list/has_hardpoints = list()
	var/power_use = 0
	matter = list(DEFAULT_WALL_MATERIAL = 15000, MATERIAL_PLASTIC = 1000, MATERIAL_OSMIUM = 500)
	dir = SOUTH

/obj/item/mech_component/pickup(mob/user)
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	return

/obj/item/mech_component/proc/set_colour(new_colour)
	var/last_colour = color
	color = new_colour
	return color != last_colour

/obj/item/mech_component/emp_act(var/severity)
	take_burn_damage(rand((10 - (severity*3)),15-(severity*4)))
	for(var/obj/item/thing in contents)
		thing.emp_act(severity)

/obj/item/mech_component/examine(mob/user)
	. = ..()
	if(ready_to_install())
		to_chat(user, SPAN_NOTICE("It is ready for installation."))
	else
		show_missing_parts(user)

/obj/item/mech_component/set_dir()
	..(SOUTH)

/obj/item/mech_component/proc/show_missing_parts(var/mob/user)
	return

/obj/item/mech_component/proc/return_diagnostics(var/mob/user)
	to_chat(user, SPAN_NOTICE("[capitalize_first_letters(src.name)]:"))
	to_chat(user, SPAN_NOTICE(" - Integrity: <b>[round(((max_damage - total_damage) / max_damage) * 100, 0.1)]%</b>" ))

/obj/item/mech_component/proc/prebuild()
	return

/obj/item/mech_component/proc/install_component(var/obj/item/thing, var/mob/user)
	user.drop_from_inventory(thing)
	thing.forceMove(src)
	user.visible_message(SPAN_NOTICE("\The [user] installs \the [thing] in \the [src]."))
	return 1

/obj/item/mech_component/proc/update_health()
	total_damage = brute_damage + burn_damage
	if(total_damage > max_damage) total_damage = max_damage
	damage_state = Clamp(round((total_damage/max_damage) * 4), MECH_COMPONENT_DAMAGE_UNDAMAGED, MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)

/obj/item/mech_component/proc/ready_to_install()
	return 1

/obj/item/mech_component/proc/repair_brute_damage(var/amt)
	take_brute_damage(-amt)

/obj/item/mech_component/proc/repair_burn_damage(var/amt)
	take_burn_damage(-amt)

/obj/item/mech_component/proc/take_brute_damage(var/amt)
	brute_damage = max(0, brute_damage + amt)
	update_health()
	if(total_damage == max_damage)
		take_component_damage(amt,0)

/obj/item/mech_component/proc/take_burn_damage(var/amt)
	burn_damage = max(0, burn_damage + amt)
	update_health()
	if(total_damage == max_damage)
		take_component_damage(0,amt)

/obj/item/mech_component/proc/take_component_damage(var/brute, var/burn)
	var/list/damageable_components = list()
	for(var/obj/item/robot_parts/robot_component/RC in contents)
		damageable_components += RC
	if(!damageable_components.len) return
	var/obj/item/robot_parts/robot_component/RC = pick(damageable_components)
	if(RC.take_damage(brute, burn))
		qdel(RC)
		update_components()

/obj/item/mech_component/attackby(var/obj/item/thing, var/mob/user)
	if(thing.isscrewdriver())
		if(contents.len)
			var/obj/item/removed = pick(contents)
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [removed] from \the [src]."))
			removed.forceMove(user.loc)
			playsound(user.loc, 'sound/effects/pop.ogg', 50, 0)
			update_components()
		else
			to_chat(user, SPAN_WARNING("There is nothing to remove."))
		return
	if(thing.iswelder())
		repair_brute_generic(thing, user)
		return
	if(thing.iscoil())
		repair_burn_generic(thing, user)
		return
	return ..()

/obj/item/mech_component/proc/update_components()
	return

/obj/item/mech_component/proc/repair_brute_generic(var/obj/item/weldingtool/WT, var/mob/user)
	if(!istype(WT))
		return
	if(!brute_damage)
		to_chat(user, SPAN_NOTICE("You inspect \the [src] but find nothing to weld."))
		return
	if(!WT.isOn())
		to_chat(user, SPAN_WARNING("Turn \the [WT] on, first."))
		return
	if(WT.use(0, user))
		var/repair_value = 15
		if(brute_damage)
			repair_brute_damage(repair_value)
			to_chat(user, SPAN_NOTICE("You mend the damage to \the [src]."))
			playsound(user.loc, 'sound/items/welder.ogg', 25, 1)

/obj/item/mech_component/proc/repair_burn_generic(var/obj/item/stack/cable_coil/CC, var/mob/user)
	if(!istype(CC))
		return
	if(!burn_damage)
		to_chat(user, SPAN_NOTICE("\The [src]'s wiring doesn't need replacing."))
		return

	var/needed_amount = 3
	if(CC.get_amount() < needed_amount)
		to_chat(user, SPAN_WARNING("You need at least [needed_amount] unit\s of cable to repair this section."))
		return

	user.visible_message("\The [user] begins replacing the wiring of \the [src]...")

	if(burn_damage)
		if(QDELETED(CC) || QDELETED(src) || !CC.use(needed_amount))
			return

		repair_burn_damage(25)
		to_chat(user, SPAN_NOTICE("You mend the damage to \the [src]'s wiring."))
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 25, 1)
	return
