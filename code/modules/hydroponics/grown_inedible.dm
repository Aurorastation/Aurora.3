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
	w_class = ITEMSIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/corncob/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/surgery/circular_saw) || istype(W, /obj/item/material/hatchet) || istype(W, /obj/item/material/kitchen/utensil/knife) || istype(W, /obj/item/material/knife) || istype(W, /obj/item/material/knife/ritual))
		to_chat(user, "<span class='notice'>You use [W] to fashion a pipe out of the corn cob!</span>")
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
	w_class = ITEMSIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/bananapeel/Crossed(AM as mob|obj)
	if(isliving(AM))
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.shoes?.item_flags & LIGHTSTEP)
				return
		var/mob/living/M = AM
		M.slip("the [src.name]",4)