
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
	var/nearest_artifact_dir = 0
	var/last_scan_time = 0
	var/scan_delay = 25

/obj/item/ano_scanner/Initialize()
	. = ..()
	scan()

/obj/item/ano_scanner/attack_self(var/mob/user as mob)
	return src.interact(user)

/obj/item/ano_scanner/interact(var/mob/user as mob)
	if(world.time - last_scan_time >= scan_delay)
		spawn(0)
			var/arch_skill = GET_SKILL_LEVEL(user, ARCHAOLOGY_SKILL_COMPONENT) || SKILL_LEVEL_UNFAMILIAR
			scan(arch_skill)

			if(!user) return

			if(nearest_artifact_distance >= 0)
				var/dir_hint = (arch_skill >= SKILL_LEVEL_TRAINED && nearest_artifact_dir) ? " to the <b>[dir2text(nearest_artifact_dir)]</b>" : ""
				to_chat(user, "Exotic energy detected on wavelength '[nearest_artifact_id]' in a radius of [nearest_artifact_distance]m[dir_hint].")
			else
				to_chat(user, "Background radiation levels detected.")
			playsound(loc, 'sound/machines/boop2.ogg', 40)
	else
		to_chat(user, "Scanning array is recharging.")

/obj/item/ano_scanner/proc/scan(arch_skill = SKILL_LEVEL_UNFAMILIAR)
	last_scan_time = world.time
	nearest_artifact_distance = -1
	nearest_artifact_dir = 0
	var/turf/cur_turf = get_turf(src)
	if(!cur_turf)
		return

	if (SSxenoarch) //Sanity check due to runtimes ~Z
		for(var/turf/simulated/mineral/T in SSxenoarch.artifact_spawning_turfs)
			if(T.artifact_find)
				if(T.z == cur_turf.z)
					var/cur_dist = get_dist(cur_turf, T) * 2
					if( (nearest_artifact_distance < 0 || cur_dist < nearest_artifact_distance) && cur_dist <= T.artifact_find.artifact_detect_range )
						if(arch_skill >= SKILL_LEVEL_TRAINED)
							nearest_artifact_distance = cur_dist
						else
							nearest_artifact_distance = cur_dist + rand() * 2 - 1
						nearest_artifact_id = T.artifact_find.artifact_id
						nearest_artifact_dir = get_dir(cur_turf, T)
			else
				SSxenoarch.artifact_spawning_turfs.Remove(T)
	cur_turf.visible_message("<span class='info'>[src] clicks.</span>")
