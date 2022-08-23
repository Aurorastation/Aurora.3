/obj/item/ship_ammunition
	name = "artillery shell"
	desc = "A shell of some sort."
	w_class = ITEMSIZE_HUGE
	slowdown = 2
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
				visible_message(SPAN_NOTICE("[user] tightens their grip on [src] and starts heaving effortlessly..."))
				if(do_after(user, 1 SECONDS))
					visible_message(SPAN_NOTICE("[user] heaves \the [src] up!"))
					return TRUE
			if(istype(H.back, /obj/item/rig))
				var/obj/item/rig/R = H.back
				if(R.suit_is_deployed())
					visible_message(SPAN_NOTICE("[user] tightens their grip on [src] and starts heaving with some difficulty..."))
					if(do_after(user, 5 SECONDS))
						visible_message(SPAN_NOTICE("[user] heaves \the [src] up!"))
						return TRUE
		to_chat(user, SPAN_WARNING("\The [src] is way too heavy for you to pick up without some assistance!"))
		return FALSE
	return TRUE

