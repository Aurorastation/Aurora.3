
/obj/item/ano_scanner
	name = "Alden-Saraspova counter"
	desc = "Aids in triangulation of exotic particles."
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "xenoarch_scanner"
	item_state = "xenoarch_scanner"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	var/nearest_artifact_id = "unknown"
	var/nearest_artifact_distance = -1
	var/last_scan_time = 0
	var/scan_delay = 25
	var/datum/device_power_supply/power_supply
	/// Forty scans from a standard 250 charge device cell.
	var/scan_power_cost = 6.25

/obj/item/ano_scanner/Initialize()
	. = ..()
	power_supply = new(src, /obj/item/cell/device, FALSE)

/obj/item/ano_scanner/Destroy()
	QDEL_NULL(power_supply)
	return ..()

/obj/item/ano_scanner/emp_act(severity)
	. = ..()
	power_supply.emp_act(severity)

/obj/item/ano_scanner/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		if(power_supply?.cell)
			. += "Its power cell has <b>[round(power_supply.cell.percent())]%</b> charge remaining."
		else
			. += SPAN_WARNING("It has no power cell installed.")

/obj/item/ano_scanner/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "A standard device cell powers forty scans."

/obj/item/ano_scanner/get_cell()
	return power_supply?.cell

/obj/item/ano_scanner/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && power_supply?.cell)
		power_supply.eject_cell(user)
		return
	return ..()

/obj/item/ano_scanner/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/cell))
		power_supply.install_cell(attacking_item, user)
		return
	return ..()

/obj/item/ano_scanner/attack_self(var/mob/user as mob)
	return src.interact(user)

/obj/item/ano_scanner/interact(var/mob/user as mob)
	if(world.time - last_scan_time >= scan_delay)
		if(!power_supply.use_per_use(scan_power_cost))
			to_chat(user, SPAN_WARNING("\The [src] does not have enough charge to complete the scan."))
			return
		spawn(0)
			scan()

			if(!user) return

			if(nearest_artifact_distance >= 0)
				to_chat(user, "Exotic energy detected on wavelength '[nearest_artifact_id]' in a radius of [nearest_artifact_distance]m")
			else
				to_chat(user, "Background radiation levels detected.")
			playsound(loc, 'sound/machines/boop2.ogg', 40)
	else
		to_chat(user, "Scanning array is recharging.")

/obj/item/ano_scanner/proc/scan()
	last_scan_time = world.time
	nearest_artifact_distance = -1
	var/turf/cur_turf = get_turf(src)
	if(!cur_turf)
		return

	if (SSxenoarch) //Sanity check due to runtimes ~Z
		for(var/turf/simulated/mineral/T in SSxenoarch.artifact_spawning_turfs)
			if(T.artifact_find)
				if(T.z == cur_turf.z)
					var/cur_dist = get_dist(cur_turf, T) * 2
					if( (nearest_artifact_distance < 0 || cur_dist < nearest_artifact_distance) && cur_dist <= T.artifact_find.artifact_detect_range )
						nearest_artifact_distance = cur_dist + rand() * 2 - 1
						nearest_artifact_id = T.artifact_find.artifact_id
			else
				SSxenoarch.artifact_spawning_turfs.Remove(T)
	cur_turf.visible_message("<span class='info'>[src] clicks.</span>")
