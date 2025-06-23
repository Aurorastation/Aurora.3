// **********************
// Other harvested materials from plants (that are not food)
// **********************

/obj/item/grown // Grown weapons
	name = "grown_weapon"
	icon = 'icons/obj/weapons.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_grown.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_grown.dmi',
		)
	storage_slot_sort_by_name = TRUE
	var/plantname
	var/potency = 1

/obj/item/grown/Initialize(newloc,planttype)
	. = ..()

	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src

	//Handle some post-spawn var stuff.
	if(planttype)
		plantname = planttype
		var/datum/seed/S = SSplants.seeds[plantname]
		if(!S || !S.chems)
			return

		potency = S.get_trait(TRAIT_POTENCY)

		for(var/rid in S.chems)
			var/list/chem_data = S.chems[rid]
			var/rtotal = chem_data[1]
			if(chem_data.len > 1 && potency > 0)
				rtotal += round(potency/chem_data[2])
			reagents.add_reagent(rid,max(1,rtotal))

/obj/item/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon = 'icons/obj/trash.dmi'
	icon_state = "corncob"
	item_state = "corncob"
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/corncob/attackby(obj/item/attacking_item, mob/user)
	..()
	if(istype(attacking_item, /obj/item/surgery/circular_saw) || istype(attacking_item, /obj/item/material/hatchet) || \
				istype(attacking_item, /obj/item/material/kitchen/utensil/knife) || istype(attacking_item, /obj/item/material/knife) || \
				istype(attacking_item, /obj/item/material/knife/ritual))
		to_chat(user, SPAN_NOTICE("You use [attacking_item] to fashion a pipe out of the corn cob!"))
		new /obj/item/clothing/mask/smokable/pipe/cobpipe (user.loc)
		qdel(src)
		return

/obj/item/bananapeel
	name = "banana peel"
	desc = "A peel from a banana."
	icon = 'icons/obj/trash.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_grown.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_grown.dmi'
		)
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/bananapeel/Initialize()
	. = ..()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/bananapeel/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(isliving(arrived))
		if(ishuman(arrived))
			var/mob/living/carbon/human/H = arrived
			if(H.shoes?.item_flags & ITEM_FLAG_LIGHT_STEP)
				return
		var/mob/living/M = arrived
		M.slip("the [src.name]",4)
