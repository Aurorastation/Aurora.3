/obj/item/ship_ammunition
	name = "artillery shell"
	desc = "A shell of some sort."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "nuke"
	w_class = ITEMSIZE_HUGE
	slowdown = 2
	drop_sound = 'sound/items/drop/shell_drop.ogg'
	var/written_message
	var/wielded = FALSE
	var/caliber = SHIP_CALIBER_NONE
	var/impact_type = SHIP_AMMO_IMPACT_HE //This decides what happens when the ammo hits. Is it a bunkerbuster? HE? AP?
	var/ammunition_status = SHIP_AMMO_STATUS_GOOD
	var/ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY
	var/ammunition_behaviour = SHIP_AMMO_BEHAVIOUR_DUMBFIRE //Not a bitfield!
	var/overmap_behaviour = SHIP_AMMO_CAN_HIT_HAZARDS|SHIP_AMMO_CAN_HIT_SHIPS //Whether or not the ammo can hit hazards or ships, or both.
	var/rupture_flags = SHIP_AMMO_RUPTURE_FLAG_EXPLODE
	var/rupture_gas
	var/overmap_icon_state = "cannon"
	var/obj/effect/overmap/origin
	var/atom/overmap_target
	var/obj/entry_point
	var/obj/item/projectile/original_projectile
	var/heading = SOUTH

	//Cookofff variables.
	var/drop_counter = 0
	var/cookoff_devastation = 0
	var/cookoff_heavy = 2
	var/cookoff_light = 3

/obj/item/ship_ammunition/Initialize()
	. = ..()
	update_status()

/obj/item/ship_ammunition/attackby(obj/item/I, mob/user)
	if(I.ispen())
		var/obj/item/pen/P = I
		if(use_check_and_message(user))
			var/friendly_message = sanitizeSafe(input(user, "What do you want to write on \the [src]?", "Personal Message"), 32)
			if(friendly_message)
				written_message = friendly_message
			visible_message(SPAN_NOTICE("[user] writes something on \the [src] with \the [P]."), SPAN_NOTICE("You leave a nice message on \the [src]!"))
			return
	return ..()

/obj/item/ship_ammunition/examine(mob/user, distance)
	. = ..()
	if(written_message)
		if(get_dist(user, src) > 3)
			to_chat(user, "It has something written on it, but you'd need to get closer to tell what the writing says.")
		else
			to_chat(user, "It has a message written on the casing: <span class='notice'><i>[written_message]</i></span>")

/obj/item/ship_ammunition/do_additional_pickup_checks(var/mob/user)
	if(ammunition_flags & SHIP_AMMO_FLAG_VERY_HEAVY)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/datum/species/S = H.species
			if(S.mob_size >= MOB_LARGE || S.resist_mod >= 10 || user.status_flags & GODMODE)
				visible_message(SPAN_NOTICE("[user] tightens their grip on [src] and starts heaving..."))
				if(do_after(user, 1 SECONDS))
					visible_message(SPAN_NOTICE("[user] heaves \the [src] up!"))
					wield(user)
					return TRUE
				else return FALSE
			if(istype(H.back, /obj/item/rig))
				var/obj/item/rig/R = H.back
				if(R.suit_is_deployed())
					visible_message(SPAN_NOTICE("[user] tightens their grip on [src] and starts heaving with some difficulty..."))
					if(do_after(user, 5 SECONDS))
						visible_message(SPAN_NOTICE("[user] heaves \the [src] up!"))
						wield(user)
						return TRUE
					else return FALSE
		to_chat(user, SPAN_WARNING("\The [src] is way too heavy for you to pick up without some assistance!"))
		return FALSE
	return TRUE

/obj/item/ship_ammunition/too_heavy_to_throw()
	if(ammunition_flags & SHIP_AMMO_FLAG_VERY_HEAVY)
		return TRUE
	else
		return FALSE

/obj/item/ship_ammunition/throw_impact(atom/hit_atom)
	. = ..()
	if(prob(50) && (ammunition_flags & SHIP_AMMO_FLAG_VERY_FRAGILE))
		cookoff(FALSE)

/obj/item/ship_ammunition/dropped(mob/user)
	. = ..()
	if(ammunition_flags & SHIP_AMMO_FLAG_VERY_FRAGILE)
		drop_counter++
		if(drop_counter == 2)
			visible_message(SPAN_WARNING("\The [src] makes a weird noise..."))
		if(drop_counter >= 3)
			cookoff(FALSE)

/obj/item/ship_ammunition/attackby(obj/item/I, mob/user)
	. = ..()
	if(I.force > 10 && (ammunition_flags & SHIP_AMMO_FLAG_VERY_FRAGILE))
		cookoff(FALSE)

/obj/item/ship_ammunition/ex_act(severity)
	if(ammunition_flags & SHIP_AMMO_FLAG_INFLAMMABLE)
		cookoff(TRUE)

/obj/item/ship_ammunition/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(ammunition_flags & SHIP_AMMO_FLAG_INFLAMMABLE)
		if(exposed_temperature >= T0C+200)
			cookoff(TRUE)

/obj/item/ship_ammunition/proc/cookoff(var/caused_by_heat = TRUE)
	if(ammunition_flags & SHIP_AMMO_FLAG_INFLAMMABLE)
		visible_message(SPAN_DANGER("\The [src] [caused_by_heat ? "cooks" : "goes"] off and explodes!"))
		explosion(get_turf(src), cookoff_devastation, cookoff_heavy, cookoff_light)
		qdel(src)

/obj/item/ship_ammunition/proc/can_be_loaded()
	return FALSE

/obj/item/ship_ammunition/proc/update_status()
	return

/obj/item/ship_ammunition/proc/eject_shell(var/obj/machinery/ship_weapon/SW) //do cool casing ejection effects here
	return

/obj/item/ship_ammunition/proc/wield(var/mob/living/carbon/human/user)
	wielded = TRUE
	var/obj/item/offhand/O = new(user)
	O.name = "[initial(name)] - offhand"
	O.desc = "Your second grip on \the [initial(name)]."
	user.put_in_inactive_hand(O)

/obj/item/ship_ammunition/proc/unwield()
	wielded = FALSE

/obj/item/ship_ammunition/dropped(var/mob/living/user)
	..()
	if(user)
		var/obj/item/offhand/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
		return unwield()

/obj/item/ship_ammunition/can_swap_hands(var/mob/user)
	if(wielded)
		return FALSE
	return TRUE

/obj/item/ship_ammunition/proc/get_additional_info()
	return

/obj/item/ship_ammunition/proc/get_speed() //Step size for the projectile.
	return 4

/obj/item/ship_ammunition/touch_map_edge(var/new_z)
	if(isprojectile(loc))
		transfer_to_overmap(new_z)
		origin = map_sectors["[new_z]"]
		return TRUE
	else
		. = ..()

/obj/item/ship_ammunition/proc/transfer_to_overmap(var/new_z)
	var/obj/effect/overmap/start_object = map_sectors["[new_z]"]
	if(!start_object)
		return FALSE
	
	var/obj/effect/overmap/projectile/P = new(null, start_object.x, start_object.y)
	P.name = name
	P.desc = desc
	P.ammunition = src
	P.target = overmap_target
	if(istype(origin, /obj/effect/overmap/visitable/ship))
		var/obj/effect/overmap/visitable/ship/S = origin
		P.dir = S.dir
	P.icon_state = overmap_icon_state
	P.speed = get_speed()
	P.entry_target = entry_point
	forceMove(P)
	log_and_message_admins("A projectile ([name]) has entered the Overmap! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[P.x];Y=[P.y];Z=[P.z]'>JMP</a>)")
	return TRUE

//SNOWFLAKE CODE: ACTIVATE
//The problem is getting the projectile from the gun to the map edge. We want to do this naturally, but using process() and BYOND's walk procs makes it look very... unnatural. And also slow!
//The solution? Let's co-opt projectile code!
/obj/item/projectile/ship_ammo
	name = "ship ammunition"
	icon = 'icons/obj/guns/ship/physical_projectiles.dmi'
	icon_state = "small"
	range = 250
	var/obj/item/ship_ammunition/ammo
	var/primed = FALSE //If primed, we don't interact with map edges. Projectiles might spawn on a landmark at the edge of space, and we don't want them to get tp'd away.

/obj/item/projectile/ship_ammo/touch_map_edge()
	if(primed)
		return
	if(ammo.touch_map_edge(z))
		ammo.original_projectile = src
		forceMove(ammo)

/obj/item/projectile/ship_ammo/on_hit(atom/target, blocked, def_zone, var/is_landmark_hit = FALSE) //is_landmark_hit is TRUE when we hit a landmark (e.g on a planet).
	. = ..()

/obj/item/projectile/ship_ammo/proc/on_translate(var/turf/entry_turf, var/target_turf) //This proc is called when the projectile enters a new ship's overmap zlevel.
	return
