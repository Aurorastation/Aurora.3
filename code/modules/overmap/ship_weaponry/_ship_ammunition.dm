/obj/item/ship_ammunition
	name = "artillery shell"
	desc = "A shell of some sort."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "nuke"
	w_class = ITEMSIZE_HUGE
	slowdown = 2
	var/wielded = FALSE
	var/caliber = SHIP_CALIBER_NONE
	var/impact_type = SHIP_AMMO_IMPACT_HE //This decides what happens when the ammo hits. Is it a bunkerbuster? HE? AP?
	var/ammunition_status = SHIP_AMMO_STATUS_GOOD
	var/ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY
	var/rupture_flags = SHIP_AMMO_RUPTURE_FLAG_EXPLODE
	var/rupture_gas

/obj/item/ship_ammunition/do_additional_pickup_checks(var/mob/user)
	if(ammunition_flags & SHIP_AMMO_FLAG_VERY_HEAVY)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/datum/species/S = H.species
			if(S.mob_size >= MOB_LARGE || S.resist_mod >= 10)
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